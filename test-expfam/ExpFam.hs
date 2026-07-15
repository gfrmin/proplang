{-# LANGUAGE DataKinds #-}

-- | The expfam increment oracle (EXPFAM_PLAN Task 1; the canonized
-- increment protocol, CLAUDE.md). Written RUNTIME-red against the
-- Task-1 type-surface stubs; FROZEN after author review under the
-- extended MANIFEST.sha256 (author pack §5); from that signing, any
-- diff under test-expfam/ is a protocol violation.
--
-- Red drivers and pins (plan red/green split): groups 1 (carrier
-- basics, red via the carrierSpace stub), 2 (prices), 3 (generic
-- semantics), 4 (name semantics and rendering), 5 (expansion
-- agreement — CL-4 for the basis), 6 (sufficiency) are red until
-- Tasks 3–5 land; group 7 (float guardians on today's emission path)
-- and group 8 (raises-by-type rows against the stub flags) are pins,
-- green from the start, protecting anchor byte-stability through the
-- re-derivation.
--
-- Tolerances (plan E12; part of the oracle, never widened in place):
-- cross-path extensional properties 1e-9 relative in the frozen CL-4
-- formula shape; closed-form float pins 1e-12 relative; price pins
-- 1e-12 absolute. One plan deviation, flagged for the Task 2 review:
-- the plan sketched the emit-vs-name pin as exact (==), but emit's
-- rows are only publicly readable through 'push', whose
-- renormalization adds ulps over the name's direct construction — the
-- pin is 1e-12 relative (the cross-path convention), not (==).
--
-- THE STEP-3 PORT (delegated freeze edit, sentence-author-pack.md
-- §20.3/§25; the delegation recorded in the freeze commit): 'Bern'
-- died with the step-3 demolition, so E7's fast side 'nameAt' is now
-- 'bernFast' ITSELF — value-invariant by the definitional equation
-- the evaluator always used (Eval.hs:206: applyStd (Bern car)
-- (th :. VNil) = bernFast car th; the retired grammar route and this
-- one were the same float sequence by definition). Group 5 (E7) is
-- KEPT — it is the optimisation-law shape for the basis: the executed
-- fast form pinned, extensionally, against the generic family. The
-- Call-pricing row (r0 :137) and the Call-render golden (r0 :189)
-- retired with the constructor; group 6 (sufficiency) retired per the
-- amendment schedule booked at the expfam freeze ("group 6
-- retirement, KEEP E7" — its future-conjugate-fast-path license is
-- superseded by the optimisation law's in-increment pin discipline:
-- a fast path arrives WITH its pin, never against a pre-landed
-- license); the bern deletion row and UseBern.hs are
-- DISCHARGED-PERMANENT (the register category named at the step-3
-- sitting: the deletion the fixture proved possible became the
-- deletion that happened).
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import System.Exit (ExitCode (..))
import System.Process (readProcessWithExitCode)
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck

import PropLang.Belief
import PropLang.Enumerate
import PropLang.Eval
import PropLang.Syntax

main :: IO ()
main = defaultMain $ testGroup "proplang expfam basis (increment oracle)"
  [ groupCarrier
  , groupPrices
  , groupGeneric
  , groupName
  , groupExpansion
  , groupGuardian
  , groupAblation
  ]

lg :: Double -> Double
lg = logBase 2

-- (the r0 fixture grid g4 retired with its two consumers, the Call
-- pricing row and the Call render golden — the step-3 port)

-- a local two-point carrier, independent of the domain declaration
c2 :: Carrier Int
c2 = mkCarrier "c2" (0 :| [1])

assertBits :: String -> Double -> Bits -> Assertion
assertBits name expected (Bits actual) =
  assertBool (name ++ ": expected " ++ show expected ++ " bits, got "
              ++ show actual)
             (abs (actual - expected) <= 1e-12)

-- closed-form float pin at 1e-12 RELATIVE (plan E12)
assertRel :: String -> Double -> Double -> Assertion
assertRel name expected actual =
  assertBool (name ++ ": expected " ++ show expected ++ " (rel 1e-12), got "
              ++ show actual)
             (abs (actual - expected) <= 1e-12 * abs expected)

-- the frozen CL-4 tolerance shape, for cross-path properties
agrees :: Double -> Double -> Bool
agrees lhs rhs = abs (lhs - rhs) <= 1e-9 * (1 + abs rhs)

-- | The generic family belief at a natural parameter, read through the
-- public surface only: build the family kernel over a domain
-- containing eta, then apply it by pushing the point mass at eta.
genericAt :: Double -> Belief Obs
genericAt eta =
  let sp = mkSpace (eta :| [])
      k = evalx (ExpFam sp obsCarrier SId :: Expr '[] (K Double Obs))
                (mkEnv [] VNil)
  in push (point sp eta) k

-- | The derived name's belief at theta — since the step-3 port, the
-- executed fast form itself ('bernFast'; the header's port note). The
-- r0 route built it through the grammar as Call (Bern obsCarrier)
-- over a priced one-point-grid constant; the two were the same float
-- sequence by the evaluator's definitional equation (Eval.hs:206), so
-- every pin below is over unchanged floats.
nameAt :: Double -> Belief Obs
nameAt th = bernFast obsCarrier th

-- ---------------------------------------------------------------------
-- group 1: Carrier — a declared finite output space (plan Q1/E4)
-- ---------------------------------------------------------------------

groupCarrier :: TestTree
groupCarrier = testGroup "Carrier (declared finite output space, plan Q1/E4)"
  [ testCase "mkCarrier carries its name" $
      carrierName c2 @?= "c2"
  , testCase "mkCarrier carries its size" $
      carrierSize c2 @?= 2
  , testCase "obsCarrier is the declared demonstration carrier" $ do
      carrierName obsCarrier @?= "obs"
      carrierSize obsCarrier @?= 2
  , testCase "carrierSpace round-trips through the public surface" $
      mapM_ (\(_, p) -> assertRel "uniform mass over a 2-point carrier" 0.5 p)
            (top (uniform (carrierSpace c2)) 2)
  ]

-- ---------------------------------------------------------------------
-- group 2: prices — sort-local coding (plan E2; author pack §1 table)
-- ---------------------------------------------------------------------

groupPrices :: TestTree
groupPrices = testGroup "prices (sort-local coding, plan E2)"
  [ testCase "the family node prices at lg 2 (Code joined the KER sort at the step-1 freeze)" $
      let sp = mkSpace (0.5 :| []) :: Space Double
      in assertBits "ExpFam node"
           (lg 2) (bits (ExpFam sp obsCarrier SId :: Expr '[] (K Double Obs)))
  -- the Call (Bern _) pricing row (r0 :137) retired at the step-3
  -- freeze with the constructor; the stdname re-pricing 7 -> 6 lives
  -- where it always did, test-hygiene (D4: adjudication, never grep)
  ]

-- ---------------------------------------------------------------------
-- group 3: generic semantics — normalized exp over the carrier (Q1)
-- ---------------------------------------------------------------------

groupGeneric :: TestTree
groupGeneric = testGroup "generic expfam semantics (normalized exp, plan Q1)"
  [ testCase "p(1) = e^eta / (1 + e^eta) at eta in {-2, 0, 3}" $
      mapM_ checkEta [-2, 0, 3]
  , testProperty "masses normalize to 1" propNorm
  , testProperty "p(1) is strictly monotone in eta" propMono
  ]
  where
    checkEta eta =
      assertRel ("p(1) at eta=" ++ show eta)
                (exp eta / (1 + exp eta))
                (prob (genericAt eta) (is obsSpace 1))

propNorm :: Property
propNorm =
  forAll (choose (-6, 6)) $ \eta ->
    let totalMass = sum (map snd (top (genericAt eta) 2))
    in counterexample ("total mass " ++ show totalMass)
         (abs (totalMass - 1) <= 1e-12)

propMono :: Property
propMono =
  forAll (choose (-6, 5)) $ \eta ->
  forAll (choose (0.1, 1)) $ \d ->
    let p1 = prob (genericAt eta) (is obsSpace 1)
        p2 = prob (genericAt (eta + d)) (is obsSpace 1)
    in counterexample (show p1 ++ " >= " ++ show p2) (p1 < p2)

-- ---------------------------------------------------------------------
-- group 4: the derived name — semantics and rendering (plan E6/E7)
-- ---------------------------------------------------------------------

groupName :: TestTree
groupName = testGroup "the derived name bern (plan E6/E7)"
  [ testCase "renderExpr pins the family node string" $
      let sp = mkSpace (0.5 :| []) :: Space Double
      in renderExpr (ExpFam sp obsCarrier SId :: Expr '[] (K Double Obs))
           @?= "('expfam', 'obs', 'id')"
  -- the Call-render golden (r0 :189) retired at the step-3 freeze
  -- with the constructor
  , testCase "the name's masses are (1-theta, theta) at theta = 0.4" $ do
      let b = nameAt 0.4
      assertRel "p(0)" 0.6 (prob b (is obsSpace 0))
      assertRel "p(1)" 0.4 (prob b (is obsSpace 1))
  , testCase "emit's rows equal the name's beliefs, theta point by point" $
      mapM_ (\th -> do
               let bE = push (point thetaSpace th) emit
                   bN = nameAt th
               assertRel ("p(1) emit-vs-name at theta=" ++ show th)
                         (prob bE (is obsSpace 1)) (prob bN (is obsSpace 1))
               assertRel ("p(0) emit-vs-name at theta=" ++ show th)
                         (prob bE (is obsSpace 0)) (prob bN (is obsSpace 0)))
            [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
  ]

-- ---------------------------------------------------------------------
-- group 5: expansion agreement — CL-4 for the basis (plan E7): the
-- executed fast form is legal iff extensionally equal to the generic
-- family at eta = logit theta, enforced here, not trusted
-- ---------------------------------------------------------------------

groupExpansion :: TestTree
groupExpansion = testGroup "expansion agreement (CL-4 for the basis, plan E7)"
  [ testProperty "fast form at theta == generic family at logit theta"
      propExpansion
  ]

propExpansion :: Property
propExpansion =
  forAll (choose (0.05, 0.95)) $ \th ->
    let eta = log (th / (1 - th))
        gen = genericAt eta
        fast = nameAt th
        check y = agrees (prob fast (is obsSpace y)) (prob gen (is obsSpace y))
    in counterexample
         ("theta=" ++ show th ++ ": fast (" ++ show (prob fast (is obsSpace 1))
          ++ ") vs generic (" ++ show (prob gen (is obsSpace 1)) ++ ")")
         (check 0 && check 1)

-- ---------------------------------------------------------------------
-- group 6 (sufficiency, plan E8) RETIRED at the step-3 freeze, per
-- the amendment schedule booked at the expfam freeze ("group 6
-- retirement, KEEP E7"): it was the license for a future conjugate
-- fast path, landed before such a path existed; the optimisation law
-- (canonized at the step-2 boundary) superseded that shape — a fast
-- path arrives WITH its extensional pin in the increment that lands
-- it, never against a pre-landed license. E7 (group 5) is the kept
-- law-shaped row.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- group 7: float guardians (plan group 7; GREEN from the start): the
-- executed emission path's masses, pinned against today's code and
-- held through the Task 5 rewiring — any drift fails here before it
-- can reach a 1e-4 acceptance anchor
-- ---------------------------------------------------------------------

groupGuardian :: TestTree
groupGuardian = testGroup "float guardians (green from the start)"
  [ testCase "emit's masses are (1-theta, theta) at every theta point" $
      mapM_ checkTheta [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
  ]
  where
    checkTheta th = do
      let b = push (point thetaSpace th) emit
      assertRel ("p(1) at theta=" ++ show th) th (prob b (is obsSpace 1))
      assertRel ("p(0) at theta=" ++ show th) (1 - th) (prob b (is obsSpace 0))

-- ---------------------------------------------------------------------
-- group 8: deletion rows (plan E9; raises-by-type): audit/ablation.sh
-- is frozen and cannot gain rows, so the increment carries its own
-- runner, invoked here exactly as the frozen test 4 invokes the frozen
-- one
-- ---------------------------------------------------------------------

groupAblation :: TestTree
groupAblation = testGroup "expfam deletion rows (raises-by-type, plan E9)"
  [ ablationRow "expfam"
  , ablationRow "sid"
  -- the bern row is DISCHARGED-PERMANENT (step-3 freeze): 'Bern' left
  -- the grammar, so there is nothing left for the fixture to prove
  -- deletable — the deletion happened
  , ablationRow "carrier-obs"
  ]

ablationRow :: String -> TestTree
ablationRow row = testCase ("deletion row '" ++ row ++ "'") $ do
  (rc, out, err) <- readProcessWithExitCode
                      "sh" ["test-expfam/ablation.sh", row] ""
  assertEqual ("deletion row '" ++ row ++ "':\n" ++ out ++ err)
              ExitSuccess rc
