{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

-- | test-elim/Elim.hs — step 9's increment oracle (AGENT_PLAN §7 step
-- 9; elim-freeze-r0). THE COMPOSITIONS AS SHIPPED SENTENCES.
--
-- The sitting ruled (2026-07-17): the five VoI verbs (EU/VAct/VThink/
-- VThinkK/VPre) and 'IsEq' are DELETED, the 'Fn'/'Stats'/'StdName'/
-- 'ExpFam'/'USay' surfaces with them. Ruling 1 (the per-verb gate is
-- LAW): "the re-execution lands as SHIPPED composition — the sentences
-- that replace the primitives ARE the deliverable, so proof (i) becomes
-- permanent rather than re-mortal." This suite IS that re-execution,
-- against the 20/1 alphabet (EXPR 20, KER 1) as it now ships.
--
-- R-D21 (the satisfiability transcript): the prototype wears the real
-- module's name — every row below EXECUTES against the shipped
-- "PropLang.Syntax"/"PropLang.Eval" (the OVERLAY form, the preferred
-- transcript). There is no throwaway prototype to discard: the
-- realization is the freeze itself, and green here IS the transcript.
--
-- WHAT EACH ROW LICENSES:
--
--   g1  prob's derivability (E-e1b, "executed, not argued"): 'prob b e'
--       == 'Expect b (indicator)'. The Event/FnInd surface dissolves
--       into the binder — OPEN 1 answers itself.
--   g2  EU's composition (E-e1a, the myopic verb): 'expect b u' ==
--       'Expect b (utility body)'. The FN sort is gone; utility is an
--       ordinary priced EXPR in the outcome-bound scope.
--   g3  VAct's composition: max over a menu of the EU composition — the
--       Argmax/Expect pairing, no verb.
--   g4  IsEq's composition (E-e2, the mandatory two-sided gate): over
--       every reachable lawful pair, 'a == b' == the If/Gt sentence
--       'If (Gt a b) F (If (Gt b a) F T)' — ZERO disagreements (E-e2's
--       0/1225). NaN, E-e2's sole disagreement, is not a lawful grid
--       point (R-C1 extended to 'mkGrid'), so the composition is TOTAL
--       on what the engine respects. IsEq deleted, not migrated: EXPR
--       settles at 20 (ruling A).
--   g5  the evidence chain, sayable: 'SawE' produces evidence, 'CondE'
--       conditions, 'ElimJ' eliminates — the round trip a sentence
--       could not take before ("the hole VThink papered over").
--   g6  ElimJ's Nothing arm is LOAD-BEARING (ruling 1, addition two):
--       at impossible evidence with real weight, the Nothing arm's
--       VALUE shows through — a sentence-level default, never a baked
--       constant.
--
-- WHAT IS NOT HERE (recorded, not hidden): the deliberation verbs'
-- ARBITRARY-DEPTH preposterior re-composition. E-e1a re-executed the
-- depth-1 case BIT-EXACT (28/28, cleaner than proof (i)'s 21/45 —
-- step 8's USent already collapsed the two-derivations seam); the
-- depth-1 identity is exactly g2/g3 here (the myopic base IS depth 1).
-- Arbitrary depth needs the world-rollforward endo-kernel and
-- sentence-level expectation over structured carriers — the 'Real a'
-- wall (D-f4 addition), filed to the step-10 case file as ONE cluster
-- (transition composition + Features eliminators + structured-carrier
-- expectation). The per-verb gate PASSED for all five at E-e1a; this
-- suite ships the myopic compositions permanently and cites the
-- measured depth-1 result for the ladder.
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.HUnit (assertBool, testCase, (@?=))

import PropLang.Belief (Belief, Kernel, expect, is, kernel, point, prob)
import PropLang.Enumerate (Obs, obsCarrier, obsSpace)
import PropLang.Eval (Vals (..), bernFast, evalx, mkEnv)
import PropLang.Syntax (B, Expr (..), Idx (..), mkC, mkGrid)

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "test-elim: the compositions as shipped sentences (20/1)"
  [ g1Prob, g2EU, g3VAct, g4IsEq, g5Chain, g6Nothing ]

-- ------------------------------------------------------------------
-- helpers
-- ------------------------------------------------------------------

-- a priced constant, the grammar's only constant door
cE :: Double -> Expr env Double
cE v = case mkC (mkGrid "k" (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "cE: singleton grid index 0 must construct"

-- constant guards over singleton grids (the If/Gt-composition literals)
trueE, falseE :: Expr env Bool
trueE  = Gt (cE 1) (cE 0)
falseE = Gt (cE 0) (cE 1)

-- the demonstration domain's beliefs (Belief-layer bernFast, the
-- emission form that survived ExpFam's deletion)
bAt :: Double -> Belief Obs
bAt = bernFast obsCarrier

thetas :: [Double]
thetas = [0.1, 0.25, 0.5, 0.75, 0.9]

-- ------------------------------------------------------------------
-- g1 — prob = Expect of the indicator (E-e1b; OPEN 1 self-answers)
-- ------------------------------------------------------------------

-- the indicator of "outcome == 1" over the Bernoulli domain: the bound
-- outcome (Var Z, realToFrac of y) exceeds 0.5 iff y == 1
indicator1 :: Expr '[Double, B Obs] Double
indicator1 = If (Gt (Var Z) (cE 0.5)) (cE 1) (cE 0)

g1Prob :: TestTree
g1Prob = testGroup "g1 prob b e == Expect b (indicator) (E-e1b)"
  [ testCase ("theta=" ++ show th) $
      let b = bAt th
          viaProb = prob b (is obsSpace 1)
          viaExpect = evalx (Expect (Var Z) indicator1) (mkEnv [] (b :. VNil))
      in viaExpect @?= viaProb
  | th <- thetas ]

-- ------------------------------------------------------------------
-- g2 — EU = Expect of the utility body (E-e1a, the myopic verb)
-- ------------------------------------------------------------------

-- a utility body: 2 * outcome - 1 (an ordinary priced EXPR reading the
-- bound outcome at Var Z; the FN payload is gone, utility is a sentence)
utilBody :: Expr '[Double, B Obs] Double
utilBody = Sub (Mul (cE 2) (Var Z)) (cE 1)

g2EU :: TestTree
g2EU = testGroup "g2 EU == Expect b (utility body) (E-e1a myopic)"
  [ testCase ("theta=" ++ show th) $
      let b = bAt th
          -- the pre-step-9 EU verb was 'expect b (\\y -> uAt fs u 0 y)'
          viaVerb = expect b (\y -> 2 * realToFrac y - 1)
          viaSay  = evalx (Expect (Var Z) utilBody) (mkEnv [] (b :. VNil))
      in viaSay @?= viaVerb
  | th <- thetas ]

-- ------------------------------------------------------------------
-- g3 — VAct = max over a menu of the EU composition (Argmax/Expect)
-- ------------------------------------------------------------------

g3VAct :: TestTree
g3VAct = testCase "g3 VAct == max over the menu of the EU composition" $
  let b = bAt 0.6
      menu = [0.1, 0.5, 0.9] :: [Double]
      -- the deleted VAct verb: max over acts of expect b (utility at a)
      viaVerb = maximum
        [ expect b (\y -> a * (2 * realToFrac y - 1)) | a <- menu ]
      -- the composition: each act scales the utility body; the host-side
      -- max mirrors CL-3 (strict > displaces)
      euOf a = evalx (Expect (Var Z) (Mul (cE a) utilBody))
                     (mkEnv [] (b :. VNil))
  in maximum (map euOf menu) @?= viaVerb

-- ------------------------------------------------------------------
-- g4 — IsEq == the If/Gt composition, ZERO disagreements (E-e2)
-- ------------------------------------------------------------------

-- the equality sentence over two constants (a == b iff neither >)
eqSay :: Double -> Double -> Bool
eqSay a b =
  evalx (If (Gt (cE a) (cE b)) falseE (If (Gt (cE b) (cE a)) falseE trueE))
        (mkEnv [] VNil)

g4IsEq :: TestTree
g4IsEq = testCase "g4 IsEq == If/Gt composition: 0 disagreements (E-e2)" $
  let pts = thetas ++ [0.2, 0.3, 0.4, 0.0, 1.0]
      disagreements =
        [ (a, b) | a <- pts, b <- pts, (a == b) /= eqSay a b ]
  in disagreements @?= []

-- ------------------------------------------------------------------
-- g5 — the evidence chain is sayable: SawE -> CondE -> ElimJ
-- ------------------------------------------------------------------

-- an identity-ish kernel: each outcome maps to a point mass on itself
idK :: Kernel Obs Obs
idK = kernel obsSpace obsSpace (point obsSpace)

-- SawE (Var Z :: kernel) (Var (S Z) :: outcome) : the evidence producer,
-- feeding CondE, eliminated by ElimJ — the round trip a sentence takes
chainSay :: Expr '[Kernel Obs Obs, Obs, B Obs] Double
chainSay =
  ElimJ (CondE (Var (S (S Z))) (SawE (Var Z) (Var (S Z))))
        (Expect (Var Z) (Var Z))   -- Just arm: prevision of the conditioned belief
        (cE 0.42)                  -- Nothing arm: a sentence-level default

g5Chain :: TestTree
g5Chain = testCase "g5 SawE -> CondE -> ElimJ round trip is sayable" $
  let b = bAt 0.6            -- mass on both outcomes
      -- observe outcome 1 through the identity kernel: cond succeeds
      out = evalx chainSay (mkEnv [] (idK :. (1 :: Obs) :. b :. VNil))
  in assertBool "conditioned prevision is finite and not the default"
       (not (isNaN out) && out /= 0.42)

-- ------------------------------------------------------------------
-- g6 — ElimJ's Nothing arm is LOAD-BEARING (ruling 1, addition two)
-- ------------------------------------------------------------------

g6Nothing :: TestTree
g6Nothing = testCase "g6 ElimJ Nothing arm shows through at impossible evidence" $
  let b = point obsSpace 1   -- point mass on 1: observing 0 is impossible
      -- SawE idK 0 against a point-mass-on-1 belief => cond Nothing
      out = evalx chainSay (mkEnv [] (idK :. (0 :: Obs) :. b :. VNil))
  in out @?= 0.42            -- the Nothing arm's VALUE, not a baked constant
