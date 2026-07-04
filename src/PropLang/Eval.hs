{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

-- | The evaluator (typed-port-spec §3): @evalx :: Expr env t -> Env env
-- -> t@ — the type IS the purity claim. Nothing effectful appears in any
-- type in this module (audit gate 3); the environment carries features
-- and typed bindings; stdlib semantics for 'PropLang.Syntax.StdName'
-- live here and are pure verb composition.
--
-- The 'Push' and 'Argmax' cases sit behind the same CPP flags as their
-- grammar constructors, so a code-level ablation deletes verb and
-- semantics together and all of src\/ stays compilable.
module PropLang.Eval
  ( Features
  , Vals(..)
  , Env
  , mkEnv
  , evalx
  ) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromMaybe)

import PropLang.Belief (Belief, Evidence (Saw), Kernel, LogProb (LogProb),
                        cond, expect, logPredict)
#ifndef DROP_PUSH
import PropLang.Belief (push)
#endif
import PropLang.Syntax (Args (..), Expr (..), Idx (..), Name, StdName (..),
                        Util, applyUtil, gridLookup)

-- | The world's published names, one tick's worth. Absent names read 0.0
-- (interface.md §1: prices, clocks, and echoes are names like any other).
type Features = [(Name, Double)]

-- | Typed value stack matching the expression's environment index.
data Vals env where
  VNil :: Vals '[]
  (:.) :: t -> Vals env -> Vals (t ': env)

infixr 5 :.

-- | The evaluation environment: features + typed bindings. Abstract.
data Env env = Env Features (Vals env)

mkEnv :: Features -> Vals env -> Env env
mkEnv = Env

lookupVal :: Idx env t -> Vals env -> t
lookupVal Z     (v :. _)  = v
lookupVal (S i) (_ :. vs) = lookupVal i vs

-- | Big-step evaluation. Pure and total: a dormant grid index reads 0.0
-- exactly as a dormant feature name does, and the 'Expect' case is
-- discharged by the emptiness of 'PropLang.Syntax.Fn' in the parity
-- phase.
evalx :: Expr env t -> Env env -> t
evalx expr env@(Env feats vals) = case expr of
  C g k      -> fromMaybe 0.0 (gridLookup g k)
  Get nm     -> fromMaybe 0.0 (lookup nm feats)
  If c t e   -> if evalx c env then evalx t env else evalx e env
  Gt a b     -> evalx a env > evalx b env
  Var ix     -> lookupVal ix vals
#ifndef DROP_PUSH
  Push b k   -> push (evalx b env) (evalx k env)
#endif
  CondE b ev -> cond (evalx b env) (evalx ev env)
  Expect _ f -> case f of {}
#ifndef DROP_ARGMAX
  Argmax o v ->
    -- CL-3: deterministic tie-break by option order; nothing may select
    -- an action but expected value (strict improvement to displace the
    -- incumbent, first-listed wins ties).
    let o0 :| os = evalx o env
        val cand = evalx v (Env feats (cand :. vals))
        go best bv [] = (best, bv)
        go best bv (c : rest) =
          let cv = val c
          in if cv > bv then go c cv rest else go best bv rest
    in fst (go o0 (val o0) os)
#endif
  Call sn as -> applyStd sn (evalArgs as env)

evalArgs :: Args env ts -> Env env -> Vals ts
evalArgs ANil      _   = VNil
evalArgs (a :* as) env = evalx a env :. evalArgs as env

-- The stdlib semantics (contracts recorded on 'StdName').
applyStd :: StdName args t -> Vals args -> t
applyStd EU     (b :. u :. a :. VNil) = expect b (applyUtil u a)
applyStd IsEq   (x :. y :. VNil)      = x == y
applyStd VAct   (b :. u :. acts :. VNil) = vAct b u acts
applyStd VThink (b :. k :. ys :. u :. acts :. n :. price :. VNil) =
  vThink b k ys u acts n price

negInf :: Double
negInf = -1 / 0

sumL :: [Double] -> Double
sumL = foldl' (+) 0

-- max over acts of the prevision of the utility (the value of acting
-- now); iteration order and the strict-improvement rule mirror CL-3.
vAct :: Belief h -> Util a h -> NonEmpty a -> Double
vAct b u = foldl' step negInf
  where
    step bv a = let v = expect b (applyUtil u a) in if v > bv then v else bv

-- Russell–Wefald preposterior value of one more batch of computation:
-- for each length-n outcome sequence (binary-counting order over the
-- given alphabet), fold logPredict BEFORE cond per outcome, weight the
-- post-conditioning value of acting by exp of the summed log marginals;
-- an impossible branch contributes weight 0; the world's price of the
-- tick is subtracted at the end.
vThink :: Eq y
       => Belief h -> Kernel h y -> [y] -> Util a h -> NonEmpty a -> Int
       -> Double -> Double
vThink b k ys u acts n price = sumL (map branch (grow n [[]])) - price
  where
    grow m ss | m <= 0    = ss
              | otherwise = grow (m - 1) [s ++ [y] | s <- ss, y <- ys]
    branch = go 0 (Just b)
    go lp (Just bb) (y : rest) =
      let LogProb l = logPredict bb (Saw k y)
      in go (lp + l) (cond bb (Saw k y)) rest
    go lp (Just bb) [] = exp lp * vAct bb u acts
    go _  Nothing   _  = 0
