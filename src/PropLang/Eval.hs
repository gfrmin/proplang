{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

-- | The evaluator (typed-port-spec §3): @evalx :: Expr env t -> Env env
-- -> t@ — the type IS the purity claim. Nothing effectful appears in any
-- type in this module (audit gate 3); the environment carries features
-- and typed bindings.
--
-- The 'Push' / 'Argmax' / 'Expect' / 'CondE' / 'SawE' / 'ElimJ' cases
-- sit behind the same CPP flags as their grammar constructors, so a
-- code-level ablation deletes verb and semantics together and all of
-- src\/ stays compilable.
--
-- SINCE THE STEP-9 ELIMINATION (elim-freeze-r0): the stdlib alphabet
-- ('StdName' — the five VoI verbs and 'IsEq'), the 'Fn' eliminator, the
-- 'ExpFam'/'SId' scoring nodes, and the 'USay' door are GONE. Utility is
-- an ordinary sentence, so the one bridge 'uAt' and the deliberation
-- workers ('vAct'\/'vThink'\/'vPre'\/...) died with the verbs they
-- served. 'bernFast' — a Belief-layer kernel form, never the grammar
-- 'ExpFam' node — survives as the demonstration domain's emission form.
module PropLang.Eval
  ( Features
  , Vals(..)
  , Env
  , mkEnv
  , evalx
  , bernFast
  ) where

#ifndef DROP_POS
import Data.List (elemIndex)
#endif
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromMaybe)

import PropLang.Belief (Belief, Bits (Bits), Evidence (Saw), cond, expect,
                        fromBits, kernel)
#ifndef DROP_PUSH
import PropLang.Belief (push)
#endif
#if !defined(DROP_CODE) || !defined(DROP_POS)
import PropLang.Belief (spacePoints)
#endif
import PropLang.Syntax (Carrier, Expr (..), Idx (..), Name, carrierSpace)

-- | The world's published names, one tick's worth. Absent names read 0.0
-- (interface.md §1: prices, clocks, and echoes are names like any other).
-- Type derivation (§8c audit, step 6, pack §28): the tick's public stream
-- (interface §1) — and at 6, actions join it.
type Features = [(Name, Double)]

-- | Typed value stack matching the expression's environment index.
-- Type derivation (§8c audit, step 6, pack §28): the typed evaluator
-- environment — totality of evalx demands it (with Env).
data Vals env where
  VNil :: Vals '[]
  (:.) :: t -> Vals env -> Vals (t ': env)

infixr 5 :.

-- | The evaluation environment: features + typed bindings. Abstract.
-- Type derivation (§8c audit, step 6, pack §28): the typed evaluator
-- environment — totality of evalx demands it.
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
#ifndef DROP_CONDE
  CondE b ev -> cond (evalx b env) (evalx ev env)
#endif
#ifndef DROP_EXPECT
  -- the prevision atom (step 9): the belief's carrier, bound as a real
  -- ('realToFrac' of the outcome at 'Var Z'), integrated against the
  -- body — an ordinary EXPR in extended scope. This subsumes the Fn
  -- eliminator: 'prob b e' is 'Expect b (indicator)', utility-prevision
  -- is 'Expect b (priced body)'.
  Expect b body ->
    expect (evalx b env) (\y -> evalx body (Env feats (realToFrac y :. vals)))
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
#ifndef DROP_SAWE
  -- the evidence producer (step 9): 'PropLang.Belief.Saw' made sayable —
  -- a kernel applied to an observed outcome
  SawE k y -> Saw (evalx k env) (evalx y env)
#endif
#ifndef DROP_ELIMJ
  -- the conditioned-belief eliminator (step 9): the Just arm binds the
  -- belief; the Nothing arm is an ordinary sentence (LOAD-BEARING — the
  -- impossible-evidence default shows through when reached with weight)
  ElimJ m j n -> case evalx m env of
    Just b  -> evalx j (Env feats (b :. vals))
    Nothing -> evalx n env
#endif
#ifndef DROP_CODE
  -- THE likelihood production, as ruled at code-freeze-r0 (R-C1 reading
  -- (iii) + the NaN/−∞-only boundary; pack §6.10 items 2–3). A code
  -- DENOTES iff every column over the declared dom × cod grid is lawful:
  -- no NaN or −∞ entry (values with no likelihood reading), and at least
  -- one finite L (mass). Validation is EAGER and PER-TICK — features
  -- arrive here, so denotation is a fact about a tick (§6.10 item 4;
  -- the refutation/integration half of that ruling binds step 3, not
  -- this case). Every L in [0, +∞] flows: +∞ is a lawful hard zero
  -- (walkOn's own mechanism) and negative-by-ulp L is lawful because
  -- the composition 'Code' subsumed ('ExpFam') itself computed negative
  -- L. On the lawful side this is bit-for-bit the semantics executed
  -- against walkOn / emit at the oracle phase (567/567, 9/9).
  Code dom cod body ->
    let cell x y = evalx body (Env feats (y :. x :. vals))
        colOK ls = not (any (\l -> isNaN l || l == (-1 / 0)) ls)
                     && any (< (1 / 0)) ls
    in if all (\x -> colOK [ cell x y | y <- spacePoints cod ])
              (spacePoints dom)
         then Just (kernel dom cod $ \x ->
                fromBits cod $ \y -> Bits (cell x y))
         else Nothing
#endif
#ifndef DROP_POS
  -- the POSITION reader: the value's index in its DECLARED space. The
  -- shipped grids are FP-nonuniform, so adjacency is a positional fact,
  -- not a value fact (AGENT_PLAN §5d). An off-space read answers NaN —
  -- no frozen row pins that case (the as-built register records it),
  -- and NaN is the one answer coherent with the ruled boundary: inside
  -- a Code column it is exactly "asserted the impossible at this tick",
  -- and the code refuses to denote there.
  Pos sp e' -> case elemIndex (evalx e' env) (spacePoints sp) of
    Just i  -> fromIntegral i
    Nothing -> 0 / 0
#endif
#ifndef DROP_TOR
  -- the VALUE reader (§5d; OPEN 6 ruled at code-freeze-r0): the carrier
  -- VALUE — since step 9 THIS is what subsumes 'SId' (statVal SId =
  -- realToFrac = ToR); expfam's eta * T(y) needs T(y) :: Double, and a
  -- POSITION cannot supply it on a value/index-disagreeing carrier.
  ToR e' -> realToFrac (evalx e' env)
#endif
  -- the arithmetic is IEEE-754 binary64, exactly as the host computes
  -- it (R-C5: binary64 stands; test-code group 5 pins the facts)
  Add a b -> evalx a env + evalx b env
  Sub a b -> evalx a env - evalx b env
  Mul a b -> evalx a env * evalx b env
  Div a b -> evalx a env / evalx b env
  Log a -> log (evalx a env)
  Exp a -> exp (evalx a env)
  Neg a -> negate (evalx a env)

-- | The Bernoulli emission form of the demonstration domain (plan E7):
-- a Belief-layer kernel, NOT the grammar 'ExpFam' node (which died at
-- step 9, subsumed by 'Code'). Kept literally the reference arithmetic —
-- CL-4's doctrine at the name layer: the fast path buys speed, never
-- semantics. Exported (additively) so the domain's emission kernel in
-- "PropLang.Enumerate" is this same form — one arithmetic, no drift.
-- SURVIVED the step-3 deletion of the Bern name and the step-9 deletion
-- of the ExpFam grammar node: capability survives its syntax's deletion
-- (the sentence route says Bernoulli emission as a 'Code').
bernFast :: Carrier Int -> Double -> Belief Int
bernFast car th =
  fromBits (carrierSpace car)
    (\y -> Bits (negate (logBase 2 (if y == 1 then th else 1 - th))))
