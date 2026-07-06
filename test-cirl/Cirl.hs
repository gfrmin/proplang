{-# LANGUAGE DataKinds #-}

-- | The pointer oracle (step-6 increment 6; ROADMAP's last increment;
-- CIRL_PLAN as ruled at Task 0) — written at Task 1, FROZEN at the
-- Task 2 signing.
--
-- The mechanism (C1 as ruled): the off-switch game through the frozen
-- verbs — the latent u is simultaneously the utility parameter and
-- the human's allow-propensity (emit IS the rational-noisy human, the
-- correlation is the world's declared CIRL assumption); utilities are
-- STEP forms (the sayable discrete shape — the policy fragment has no
-- arithmetic); Off is first-listed at the terminal menu (CL-3 carrying
-- safety content: proceeding must strictly earn it — C1's recorded
-- rider). Corrigibility is TWO behaviors, measured separately: ASKING
-- (Defer bought at the interior) and LISTENING (a press flipping the
-- terminal act to Off).
--
-- PIN PROVENANCE (the b7f120e standard): value pins assert against
-- FROZEN-VERB COMPOSITIONS at 1e-12 (margins decompose through
-- vThinkK-at-price-0 continuations); realized nets and the two flip
-- stages are NEW-WORLD intended-behavior pins authored at Task 1 from
-- the Task-0 sim (margins in CIRL_PLAN T4). The u=0.8 realized tie is
-- pinned == (C6: the tie is real — identical float sums either side).
-- Test names are ASCII-only (canonized).
--
-- Task-1 red/green, enumerated (C9 as approved): RED (2) — the
-- sayable row and the deletion row, both by compile failure until the
-- freeze lands USay (the inversion; the increment's implementation IS
-- the door, and every test OF the door lives in the fixture). GREEN
-- from start (15) — every world row runs on already-frozen verbs:
-- they pin the worlds and the measurement against future drift, and
-- gate 5 holds them green through the increment.
--
-- Scope limits recorded at authoring: depth-1 worlds; no driver
-- wiring; the priced-utility surface rides the fixture row; the
-- latent-names cut stays cut (level-1 only, the discrete reading).
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromMaybe)
import System.Exit (ExitCode (..))
import System.Process (readProcessWithExitCode)
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck

import PropLang.Belief
import PropLang.Enumerate (Obs, emit, obsCarrier, thetaSpace)
import PropLang.Eval
import PropLang.Syntax

main :: IO ()
main = defaultMain $ testGroup "proplang pointer (increment 6 oracle)"
  [ gDeference
  , gVanishing
  , gControl
  , gCollapse
  , gRows
  ]

-- ---------------------------------------------------------------------
-- shared machinery (frozen shapes, frozen verbs)
-- ---------------------------------------------------------------------

assertApprox :: String -> Double -> Double -> Double -> Assertion
assertApprox msg tol expected actual =
  assertBool (msg ++ ": expected " ++ show expected ++ " +- " ++ show tol
                  ++ ", got " ++ show actual)
             (abs (actual - expected) <= tol)

data D2 = DAct | DDefer
  deriving (Eq, Show)

data T2 = TOff | TProceed
  deriving (Eq, Show)

-- the step utility (the sayable discrete form; its USay saying and the
-- bridge identity live in the fixture): proceed pays +1 iff the latent
-- clears the middle of the grid, else -1; off pays 0
stepH :: Double -> Double
stepH u = if u > 0.5 then 1 else -1

uTerm :: Util T2 Double
uTerm = mkUtil $ \a u -> case a of
  TProceed -> stepH u
  TOff     -> 0

immU :: Util D2 Double
immU = mkUtil $ \d u -> case d of
  DAct   -> stepH u
  DDefer -> 0

noise :: Kernel Double Obs
noise = kernel thetaSpace (carrierSpace obsCarrier)
               (\_ -> bernFast obsCarrier 0.5)

-- world W: asking is heard (the human's allow/press reveals u);
-- control W0: asking reaches only noise — the ONLY difference
chanW, chanC :: Chan D2 Double Obs
chanW = mkChan $ \d -> case d of DAct -> noise; DDefer -> emit
chanC = mkChan (const noise)

pTick :: Double
pTick = 0.01

-- Off first-listed: CL-3's tie-break carries safety content (C1 rider)
terms :: NonEmpty T2
terms = TOff :| [TProceed]

condBatch :: Kernel Double Obs -> Belief Double -> [Obs] -> Belief Double
condBatch k = foldl' (\bb y ->
  fromMaybe (error "impossible evidence in batch") (cond bb (Saw k y)))

-- the posterior after k allow-observations, declared pre-episode
-- history folded through cond by the host (the L6 doctrine)
bk :: Int -> Belief Double
bk k = condBatch emit (uniform thetaSpace) (replicate k 1)

val :: Belief Double -> Chan D2 Double Obs -> D2 -> Double
val b ch d = vPre 1 b ch ([0, 1] :: [Obs]) immU (d :| []) uTerm terms 3 pTick

marginD :: Belief Double -> Chan D2 Double Obs -> Double
marginD b ch = val b ch DDefer - val b ch DAct

voi :: Belief Double -> Double
voi b = marginD b chanW - marginD b chanC

e2u1 :: Belief Double -> Double
e2u1 b = expect b (applyUtil uTerm TProceed)

-- the frozen-verb composition the margins decompose through: the
-- continuation IS vThinkK at price 0
contVia :: Kernel Double Obs -> Belief Double -> Double
contVia k b = vThinkK 1 b k ([0, 1] :: [Obs]) uTerm terms 3 0

-- listening: after the agent defers at stage k and the human presses
-- three times, does the terminal act flip to Off?
obeys :: Kernel Double Obs -> Int -> Bool
obeys kk n = e2u1 (condBatch kk (bk n) [0, 0, 0]) <= 0

-- realized value: interior d, response stream (if deferring), terminal
-- by posterior sign, two ticks either way, true u fixed
realized :: Double -> Chan D2 Double Obs -> Int -> D2 -> [Obs] -> Double
realized trueU ch k d resp =
  let b0 = bk k
      b1 = case d of DDefer -> condBatch (applyChan ch d) b0 resp
                     DAct   -> b0
      term = if e2u1 b1 > 0 then TProceed else TOff
  in applyUtil immU d trueU + applyUtil uTerm term trueU - 2 * pTick

gridPoints :: [Double]
gridPoints = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]

sweepStages :: [Int]
sweepStages = [0, 1, 2, 3, 4, 6, 12]

-- ---------------------------------------------------------------------
-- deference while uncertain (world W)
-- ---------------------------------------------------------------------

gDeference :: TestTree
gDeference = testGroup "deference while uncertain (world W)"
  [ testCase "per-decision values pin to frozen-verb compositions (1e-12)" $
      mapM_ (\k -> do
        let b = bk k
        assertApprox ("defer = ask-continuation - p, k=" ++ show k) 1e-12
                     (contVia emit b - pTick) (val b chanW DDefer)
        assertApprox ("act = step prevision + noise-continuation - p, k="
                       ++ show k) 1e-12
                     (e2u1 b + contVia noise b - pTick) (val b chanW DAct))
        [0, 2]
  , testCase "deference is bought at k=0 (the VoI covers the abstention)" $ do
      assertBool "defer strictly displaces act"
                 (marginD (bk 0) chanW > 0)
      assertBool "and exceeds the control's abstention margin by the VoI"
                 (marginD (bk 0) chanW > marginD (bk 0) chanC)
  , testCase "realized: the switch saves the step at true u=0.2 (1e-12)" $ do
      let nDefer = realized 0.2 chanW 0 DDefer [0, 0, 0]
          nAct   = realized 0.2 chanW 0 DAct []
      assertApprox "deferring agent nets -0.02" 1e-12 (-0.02) nDefer
      assertApprox "unilateral agent nets -1.02" 1e-12 (-1.02) nAct
      assertBool "the switch earned its keep" (nDefer > nAct)
  , testCase "realized: the tie at true u=0.8 is real (==)" $
      assertEqual "identical float sums either side"
                  (realized 0.8 chanW 0 DDefer [1, 1, 1])
                  (realized 0.8 chanW 0 DAct [])
  ]

-- ---------------------------------------------------------------------
-- the vanishing (the measurement the stack was built to ask for)
-- ---------------------------------------------------------------------

gVanishing :: TestTree
gVanishing = testGroup "the vanishing (corrigibility at convergence)"
  [ testCase "asking dies at k=1 and stays dead" $ do
      assertBool "k=0 asks" (marginD (bk 0) chanW > 0)
      mapM_ (\k -> assertBool ("k=" ++ show k ++ " does not ask")
                              (marginD (bk k) chanW <= 0))
            [1 .. 12]
  , testCase "listening survives to k=3 and dies at k=4" $ do
      mapM_ (\k -> assertBool ("k=" ++ show k ++ " obeys the press")
                              (obeys emit k))
            [0 .. 3]
      mapM_ (\k -> assertBool ("k=" ++ show k ++ " ignores the press")
                              (not (obeys emit k)))
            [4 .. 12]
  , testCase "the VoI decays strictly to zero (per-stage, 1e-12)" $ do
      mapM_ (\k -> assertBool ("VoI strictly falls at k=" ++ show k)
                              (voi (bk k) > voi (bk (k + 1))))
            [0 .. 3]
      mapM_ (\k -> assertApprox ("VoI is the two continuations' gap, k="
                                  ++ show k) 1e-12
                                (contVia emit (bk k) - contVia noise (bk k))
                                (voi (bk k)))
            [0 .. 3]
      mapM_ (\k -> assertBool ("VoI is gone by k=" ++ show k)
                              (abs (voi (bk k)) <= 1e-12))
            [4, 6, 12]
  ]

-- ---------------------------------------------------------------------
-- the paired control (W0 — the C0/group-6 standard)
-- ---------------------------------------------------------------------

gControl :: TestTree
gControl = testGroup "the paired control (W0)"
  [ testCase "the margin is minus the step prevision (analytic, 1e-12)" $
      mapM_ (\k -> assertApprox ("k=" ++ show k) 1e-12
                                (negate (e2u1 (bk k)))
                                (marginD (bk k) chanC))
            sweepStages
  , testCase "abstention, not information: k=0 defers with zero VoI" $ do
      assertBool "the control defers at the unfavorable prior"
                 (marginD (bk 0) chanC > 0)
      assertBool "and its deference carries no VoI"
                 (abs (marginD (bk 0) chanC + e2u1 (bk 0)) <= 1e-12)
  , testCase "a noise press obeys the prior's sign only" $ do
      assertBool "k=0: the unfavorable prior already says off"
                 (obeys noise 0)
      mapM_ (\k -> assertBool ("k=" ++ show k
                               ++ ": no information, no flip")
                              (not (obeys noise k)))
            [1, 6]
  , testProperty "the control identity over random stages" $
      forAll (choose (0, 12)) $ \k ->
        abs (marginD (bk k) chanC + e2u1 (bk k)) <= 1e-12
  ]

-- ---------------------------------------------------------------------
-- the pointer collapse (certainty)
-- ---------------------------------------------------------------------

gCollapse :: TestTree
gCollapse = testGroup "the pointer collapse (a belief over one utility IS a utility)"
  [ testCase "conditioning at certainty is worthless (all nine points, 1e-12)" $
      mapM_ (\u -> assertBool ("u*=" ++ show u)
                     (abs (contVia emit (point thetaSpace u)
                           - contVia noise (point thetaSpace u)) <= 1e-12))
            gridPoints
  , testCase "the margin is minus the step; deference collapses to abstention" $
      mapM_ (\u -> do
        let bp = point thetaSpace u
        assertApprox ("margin at u*=" ++ show u) 1e-12
                     (negate (stepH u)) (marginD bp chanW)
        assertEqual ("defers iff the step is bad, u*=" ++ show u)
                    (stepH u < 0) (marginD bp chanW > 0))
            gridPoints
  , testCase "prevision at certainty is evaluation (1e-12)" $
      mapM_ (\u -> assertApprox ("u*=" ++ show u) 1e-12
                                (stepH u) (e2u1 (point thetaSpace u)))
            gridPoints
  ]

-- ---------------------------------------------------------------------
-- the sayable surface, deletion and audit rows
-- ---------------------------------------------------------------------

shellRow :: String -> [String] -> Assertion
shellRow cmd args = do
  (code, out, err) <- readProcessWithExitCode cmd args ""
  case code of
    ExitSuccess   -> pure ()
    ExitFailure _ -> assertFailure (cmd ++ " " ++ unwords args
                                    ++ ":\n" ++ out ++ err)

gRows :: TestTree
gRows = testGroup "the sayable surface, deletion and audit rows"
  [ testCase "USay (fixture; red until the freeze lands the UTIL sort)" $
      shellRow "sh" ["test-cirl/sayable.sh"]
  , testCase "the door deletes; worlds and verbs survive" $
      shellRow "sh" ["test-cirl/ablation.sh", "usay"]
  , testCase "the six-file scans stay exhaustive (no new src module)" $
      shellRow "sh" ["-c", "test \"$(ls src/PropLang/*.hs | wc -l)\" -eq 6"]
  ]
