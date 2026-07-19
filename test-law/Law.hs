-- test-law: the wire boundary's W2 owed-law oracle (WIRE_PLAN.md
-- step W2a; issue #2 of the 2026-07-19 batch).
--
-- THE DEBT: AGENT_PLAN.md:1121-1126 homed the EU law-grade property
-- suite at step 9, naming VoI non-negativity over the surviving
-- Expect-composition; the step-6 register (test-stream/Stream.hs:41-42)
-- named the same home. Step 9 closed without landing it and without a
-- return row — the g4Self disease's second instance, RC-2 of the wire
-- boundary's root-cause record. This suite pays the debt. The two
-- neighbouring properties named by the same note already landed and
-- stay where they are (affine-invariance + argmax-optimality:
-- test-stream/Stream.hs:440,449; the executed Dutch-book check:
-- test-unify/Unify.hs:215-216).
--
-- THE LAW: for every belief b and every batch size n, the composed
-- preposterior value at price 0 dominates the composed myopic value —
-- VoI(b, n) = v_think(b, n; price=0) - v_act(b) >= 0 (Jensen). The
-- original defect this remedies was VOI COMPUTED NEGATIVE in the
-- machine (AGENT_PLAN.md:41-49); the priced VoI verbs died at step 9,
-- and this pins that their COMPOSED successor cannot reproduce it.
--
-- PIN-FREEZE FORM (capability already shipped; no implementation owed):
-- red demonstrated by seeded defect, live in-suite (g1c): dropping the
-- argmax to a single arm sends VoI negative on an L-favouring belief —
-- the non-negativity is the max's doing, and nothing else's.
--
-- GATE PROVENANCE (the CL-4 lesson: a gate is born from a measurement,
-- never a round guess): floor measured at the W2 evidence program over
-- 150,000 fromBits beliefs x n in 1..3 plus 15,000 evidence-conditioned
-- walks: min VoI = -1.1102230246251565e-16 (one ulp of cancellation
-- dust). Gate: -1e-13, three orders of margin. Transcript rides
-- wire-author-pack.md Part II.
--
-- FORMULA PROVENANCE (R-D20-i, copy-not-reconstruct): gk / vActS /
-- seqsOf / bodyFor / vThinkS are byte-wise copies of
-- test-reflexive/Reflexive.hs:83-126 (the frozen step-10 composition),
-- reviewable by diff against that file.
--
-- SAMPLED DOMAIN (the mandate-3 scope caveat): the header's "every
-- belief b and every batch size n" is quantified BY THE PROPERTIES
-- over bits in [0, 20] (spanning uniform through ~2^-20 relative
-- mass — beyond which weights are numerically saturated) and
-- n in {1, 2, 3} — the shipped composition's own batch domain
-- (batchCap = 3, test-reflexive/Reflexive.hs:94-95; the term count
-- grows 2^n). The law is claimed there and tested there.
{-# LANGUAGE DataKinds #-}
module Main (main) where

import Control.Monad (replicateM)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromJust)

import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck (choose, forAll, testProperty, vectorOf)

import PropLang.Belief (Belief, Bits (..), Evidence (Saw), cond, fromBits,
                        spacePoints, uniform)
import PropLang.Enumerate (Obs, emit, thetaSpace)
import PropLang.Eval (Vals (..), evalx, mkEnv)
import PropLang.Syntax (B, Expr (..), Idx (..), mkC, mkGrid)

main :: IO ()
main = defaultMain $ testGroup "law (wire boundary W2a: the owed VoI row)"
  [ g1VoiNonNeg
  ]

-- --- the step-10 composition, copied (test-reflexive/Reflexive.hs:83-126) ---

gk :: Double -> Expr env Double
gk v = case mkC (mkGrid "k" (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "gk"

vActS :: Expr '[B Double] Double
vActS = If (Gt eR eL) eR eL
  where
    b  = Var Z
    eR = Expect b (Sub (Mul (gk 2) (Var Z)) (gk 1))
    eL = Expect b (Sub (gk 1) (Mul (gk 2) (Var Z)))

seqsOf :: Int -> [[Obs]]
seqsOf n = replicateM n [0, 1]

bodyFor :: [Obs] -> Bool -> Expr (Double ': '[B Double]) Double
bodyFor s isR = Mul pfactor u
  where
    th       = Var Z
    oneMinus = Sub (gk 1) th
    pfactor  = foldr Mul (gk 1) [ if y == 1 then th else oneMinus | y <- s ]
    u        = if isR then Sub (Mul (gk 2) th) (gk 1)
                      else Sub (gk 1) (Mul (gk 2) th)

vThinkS :: Int -> Expr '[B Double] Double
vThinkS batchN = Sub (foldr Add (gk 0) terms) (Get "price")
  where
    b = Var Z
    terms = [ let eR = Expect b (bodyFor s True)
                  eL = Expect b (bodyFor s False)
              in If (Gt eR eL) eR eL
            | s <- seqsOf batchN ]

-- --- the quantity under law ---

voiAt :: Belief Double -> Int -> Double
voiAt b n = evalx (vThinkS n) (mkEnv [("price", 0)] (b :. VNil))
            - evalx vActS (mkEnv [] (b :. VNil))

-- the measured-floor gate (provenance in the header)
voiGate :: Double
voiGate = -1e-13

-- beliefs through the sealed module's public doors only
beliefOfBits :: [Double] -> Belief Double
beliefOfBits bs =
  fromBits thetaSpace (\th -> Bits (byTheta th))
  where
    byTheta th = case lookup th (zip (spacePoints thetaSpace) bs) of
      Just v  -> v
      Nothing -> 0

condWalkOf :: [Obs] -> Belief Double
condWalkOf = foldl' step (uniform thetaSpace)
  where step b y = fromJust (cond b (Saw emit y))

g1VoiNonNeg :: TestTree
g1VoiNonNeg = testGroup "g1 VoI non-negativity over the Expect-composition"
  [ testProperty "fromBits family: v_think(price 0) >= v_act, floor -1e-13" $
      forAll ((,) <$> vectorOf 9 (choose (0, 20)) <*> choose (1, 3)) $
        \(bs, n) -> voiAt (beliefOfBits bs) n >= voiGate
  , testProperty "evidence-walk family: the practically-reached beliefs obey the same law" $
      forAll ((,) <$> (flip vectorOf (choose (0, 1 :: Int)) =<< choose (0, 12))
                  <*> choose (1, 3)) $
        \(ys, n) -> voiAt (condWalkOf ys) n >= voiGate
  , testCase "seeded defect (the red, kept as its mirror): dropping the argmax sends VoI negative" $ do
      -- v_think with the R arm alone (no If/Gt max): on a belief
      -- favouring L, information loses value it never had — the
      -- inequality's content IS the max. An L-point belief at theta=0.1:
      let vThinkROnly = Sub (foldr Add (gk 0) terms) (Get "price")
            where terms = [ Expect (Var Z) (bodyFor s True) | s <- seqsOf 1 ]
          bL = beliefOfBits [0, 20, 20, 20, 20, 20, 20, 20, 20]
          broken = evalx vThinkROnly (mkEnv [("price", 0)] (bL :. VNil))
                   - evalx vActS (mkEnv [] (bL :. VNil))
      assertBool ("broken (single-arm) VoI = " ++ show broken
                  ++ " should be < -0.1: the seeded defect must be visibly red")
                 (broken < -0.1)
  ]
