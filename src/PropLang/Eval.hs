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
#ifndef DROP_EXPFAM
  , bernFast
#endif
#ifndef DROP_LADDER
  , vThinkK
#endif
#ifndef DROP_VPRE
  , vPre
#endif
  ) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromMaybe)

import PropLang.Belief (Belief, Evidence (Saw), Kernel, LogProb (LogProb),
                        cond, expect, logPredict)
#ifndef DROP_PUSH
import PropLang.Belief (push)
#endif
#ifndef DROP_FNIND
import PropLang.Belief (prob)
#endif
#ifndef DROP_EXPFAM
import PropLang.Belief (Bits (Bits), fromBits, kernel)
#endif
import PropLang.Syntax (Args (..), Expr (..), Fn (..), Idx (..), Name,
                        StdName (..), Util, applyUtil)
#ifndef DROP_EXPFAM
import PropLang.Syntax (Carrier, Stats (..), carrierSpace)
#endif
#ifndef DROP_VPRE
import PropLang.Syntax (Chan)
#endif

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

-- | Big-step evaluation. Pure and total. A priced constant carries its
-- grid point from 'mkC', so the 'C' case is a field read: no lookup,
-- no dormancy, no error site (plan R1).
evalx :: Expr env t -> Env env -> t
evalx expr env@(Env feats vals) = case expr of
  C _ _ v    -> v
  Get nm     -> fromMaybe 0.0 (lookup nm feats)
  If c t e   -> if evalx c env then evalx t env else evalx e env
  Gt a b     -> evalx a env > evalx b env
  Var ix     -> lookupVal ix vals
#ifndef DROP_PUSH
  Push b k   -> push (evalx b env) (evalx k env)
#endif
  CondE b ev -> cond (evalx b env) (evalx ev env)
  -- the two published expansions (plan Q1): probability derived from
  -- prevision, and the EU contract's utility section
  Expect b f -> case f of
#ifndef DROP_FNIND
    FnInd e    -> prob (evalx b env) e
#endif
#ifndef DROP_FNUTIL
    FnUtil u o -> expect (evalx b env) (applyUtil u o)
#endif
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
#ifndef DROP_EXPFAM
  -- the generic family (plan Q1): natural parameter in, belief over
  -- the declared carrier out — weights exp(eta * T(y)), normalized
  -- over the carrier's points by the only prior source (fromBits
  -- absorbs the log-partition A(eta) in its normalization)
  ExpFam sp car st ->
    kernel sp (carrierSpace car) $ \eta ->
      fromBits (carrierSpace car)
        (\y -> Bits (negate (eta * statVal st y) / ln2))
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
#ifndef DROP_LADDER
applyStd VThinkK (d :. b :. k :. ys :. u :. acts :. n :. price :. VNil) =
  vThinkK d b k ys u acts n price
#endif
#ifndef DROP_VPRE
applyStd VPre (d :. b :. ch :. ys :. uD :. ds :. u :. acts :. n :. price :. VNil) =
  vPre d b ch ys uD ds u acts n price
#endif
#if !defined(DROP_BERN) && !defined(DROP_EXPFAM)
applyStd (Bern car) (th :. VNil) = bernFast car th
#endif

negInf :: Double
negInf = -1 / 0

sumL :: [Double] -> Double
sumL = foldl' (+) 0

#ifndef DROP_EXPFAM
ln2 :: Double
ln2 = log 2

-- the sufficient statistic's value: first-order syntax, evaluated here
-- like every other verb (empty case when the STATS alphabet is ablated)
statVal :: Stats c -> c -> Double
statVal s = case s of
#ifndef DROP_SID
  SId -> realToFrac
#endif

-- | The Bernoulli fast form of the expfam basis (plan E7): the derived
-- name's executed semantics, kept literally the reference arithmetic —
-- CL-4's doctrine at the name layer: the fast path buys speed, never
-- semantics, and its expfam expansion is the property-enforced
-- contract (test-expfam group 5). Exported (additively) so the
-- domain's emission kernel in "PropLang.Enumerate" is this same form —
-- one arithmetic, no drift. Survives DROP_BERN (the name is sugar;
-- capability survives its deletion) and dies with the basis (E9).
bernFast :: Carrier Int -> Double -> Belief Int
bernFast car th =
  fromBits (carrierSpace car)
    (\y -> Bits (negate (logBase 2 (if y == 1 then th else 1 - th))))
#endif

-- max over acts of the prevision of the utility (the value of acting
-- now); iteration order and the strict-improvement rule mirror CL-3.
vAct :: Belief h -> Util a h -> NonEmpty a -> Double
vAct b u = foldl' step negInf
  where
    step bv a = let v = expect b (applyUtil u a) in if v > bv then v else bv

-- Russell–Wefald preposterior value of one more batch of computation:
-- the fidelity ladder's depth-1 case. 'vThinkAt' below is the one
-- arithmetic and this is its rung-1 face (the bitsAt pattern) — at
-- depth 1 the fold is line-for-line the frozen form: for each
-- length-n outcome sequence (binary-counting order over the given
-- alphabet), fold logPredict BEFORE cond per outcome, weight the
-- post-conditioning value of acting by exp of the summed log
-- marginals; an impossible branch contributes weight 0; the world's
-- price of the tick is subtracted at the end.
vThink :: Eq y
       => Belief h -> Kernel h y -> [y] -> Util a h -> NonEmpty a -> Int
       -> Double -> Double
vThink = vThinkAt 1

-- The one deliberation arithmetic (LADDER_PLAN L1, reading c as
-- ruled), private and unconditional like 'PropLang.Syntax'.bitsAt:
-- Est_0 is the value of acting now (the induction base, used as-is);
-- Est_j is the sum over length-n outcome sequences of exp(summed log
-- marginals) times Est_{j-1} of the conditioned belief, minus the
-- tick's price — so depth k telescopes to the k-batch preposterior of
-- acting minus k*price, every priced tick a real tick.
vThinkAt :: Eq y
         => Int -> Belief h -> Kernel h y -> [y] -> Util a h -> NonEmpty a
         -> Int -> Double -> Double
vThinkAt d b k ys u acts n price = est d b
  where
    est j bb | j <= 0    = vAct bb u acts
             | otherwise =
                 sumL (map (walk (est (j - 1)) 0 (Just bb)) (grow n [[]]))
                   - price
    grow m ss | m <= 0    = ss
              | otherwise = grow (m - 1) [s ++ [y] | s <- ss, y <- ys]
    walk cont lp (Just bc) (y : rest) =
      let LogProb l = logPredict bc (Saw k y)
      in walk cont (lp + l) (cond bc (Saw k y)) rest
    walk cont lp (Just bc) [] = exp lp * cont bc
    walk _    _  Nothing   _  = 0

#ifndef DROP_LADDER
-- | The fidelity ladder's rung valuation (interface.md section 6;
-- LADDER_PLAN L1, reading c — the recorded contract): @Est_0@ is the
-- value of acting now; @Est_k@ is the next-batch preposterior of
-- @Est_{k-1}@ minus the tick's price. @Est_1@ is therefore exactly
-- 'vThink', and @Est_k@ telescopes to the k-batch preposterior of
-- acting minus @k * price@ — every priced tick a real tick, the
-- induction base ("unexamined estimates are used as-is") sitting at
-- @Est_0@ and nowhere else.
--
-- The executed semantics IS 'vThinkAt' — one arithmetic with 'vThink'
-- as its depth-1 face (the E7 doctrine; the ladder oracle pins the
-- identity with ==).
vThinkK :: Eq y
        => Int -> Belief h -> Kernel h y -> [y] -> Util a h -> NonEmpty a
        -> Int -> Double -> Double
vThinkK = vThinkAt
#endif

#ifndef DROP_VPRE
-- | The action-dependent preposterior (PREPOSTERIOR_PLAN P1/P4 as
-- ruled; the verb VPre's executed semantics at the freeze): W_0 is
-- the frozen leaf — 'vAct' over the terminal menu, the induction base
-- untouched; W_j takes the best interior decision's immediate
-- prevision plus the continuation through THAT decision's own
-- channel, the tick's price outside the max. The frozen worker is the
-- degenerate case at the mute singleton (constant channel, zero
-- immediate, unit menu), and at Task 3 'vThinkAt' is re-based as
-- exactly that application (the bitsAt pattern's third use; the
-- oracle pins the identity with ==).
--
-- Task-1 type-surface STUB: returns 0 until Task 3 lands the one
-- arithmetic (the oracle's identity and world pins are red against
-- this stub by construction).
vPre :: Eq y
     => Int -> Belief h -> Chan d h y -> [y] -> Util d h -> NonEmpty d
     -> Util a h -> NonEmpty a -> Int -> Double -> Double
vPre _ _ _ _ _ _ _ _ _ _ = 0
#endif
