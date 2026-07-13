{-# LANGUAGE DataKinds #-}

-- | The fidelity-ladder oracle (step-6 increment 4; interface.md
-- section 6 as amended at this increment's freeze, section 7 item 5,
-- acceptance test F) — written at Task 1, runtime-red against the
-- type-surface stubs in src/ (the Eval worker returns 0; the Membrane
-- rung machinery is real data plumbing), FROZEN at the Task 2 signing.
--
-- Reading (c), as ruled at Task 0 (LADDER_PLAN L1): a rung of depth k
-- is an option with DECLARED TERMINATION — one choice committing k
-- batches over k real ticks, then re-deciding — valued by the k-batch
-- preposterior Est_k, where Est_0 is the value of acting now (the
-- induction base, used as-is) and Est_k = E_batch[Est_{k-1}] - price.
-- Est_1 is the frozen VThink verbatim; shallow-first menu order is
-- CL-3 at the menu.
--
-- PIN PROVENANCE (the b7f120e standard): every quantity that must
-- agree with a frozen artifact is IMPORTED from it (Anchors.t2Rows,
-- Streams.buffer36 — this suite's stanza reads test/ directly);
-- rung sequences and F-world nets are NEW-WORLD intended-behavior
-- pins, authored at Task 1 from the Task-0 sanity sim, margins in the
-- freeze pack. Test names are ASCII-only (canonized at this boundary).
--
-- Scope limits recorded at authoring: (1) buffers here are always
-- whole batches (multiples of 3), so the base rung's availability
-- clause and the frozen loop's partial-batch clause (batchN = min 3)
-- never diverge on exercised inputs; (2) rungs do not flow through
-- the membrane driver this increment (LADDER_PLAN L4 as ruled) — the
-- episode loops live here, in the frozen test-2 shape; (3) the
-- sayable form of the rung valuation is exercised by the
-- compile-fixture row (sayable.sh), red until the freeze lands
-- STDNAME's sixth member.
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)), toList)
import Data.Maybe (fromMaybe)
import System.Exit (ExitCode (..))
import System.Process (readProcessWithExitCode)
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck

import PropLang.Belief
import PropLang.Enumerate (Obs, emit, thetaSpace)
import PropLang.Eval
import PropLang.Membrane (baseRung, ladderRungs, mkRung, rungDepth)
import PropLang.Syntax

import Anchors (t2Rows)
import Streams (buffer36)

main :: IO ()
main = defaultMain $ testGroup "proplang ladder (increment 4 oracle)"
  [ g1Identity
  , g2Direction1
  , g3Direction2
  , g4Termination
  , g5Prices
  , g6Rows
  ]

-- ---------------------------------------------------------------------
-- shared machinery (the frozen test-2 shapes, through the real verbs)
-- ---------------------------------------------------------------------

assertApprox :: String -> Double -> Double -> Double -> Assertion
assertApprox msg tol expected actual =
  assertBool (msg ++ ": expected " ++ show expected ++ " +- " ++ show tol
                  ++ ", got " ++ show actual)
             (abs (actual - expected) <= tol)

data Dir = DirL | DirR
  deriving (Eq, Show)

dirName :: Dir -> String
dirName DirL = "L"
dirName DirR = "R"

-- the world-supplied stakes, verbatim from the frozen test 2
stakes :: Util Dir Double
stakes = mkUtil $ \a th ->
  let v = 2 * th - 1 in case a of DirR -> v; DirL -> negate v

dirs :: NonEmpty Dir
dirs = DirL :| [DirR]

-- act value through the real verb (the frozen call shape)
vAct1 :: Belief Double -> Double
vAct1 b =
  evalx (Call VAct (Var Z :* Var (S Z) :* Var (S (S Z)) :* ANil))
        (mkEnv [] (b :. stakes :. dirs :. VNil))

-- the frozen myopic preposterior through the real verb
vT1 :: Belief Double -> Int -> Double -> Double
vT1 b n p =
  evalx (Call VThink (Var Z :* Var (S Z) :* Var (S (S Z))
                    :* Var (S (S (S Z))) :* Var (S (S (S (S Z))))
                    :* Var (S (S (S (S (S Z)))))
                    :* Var (S (S (S (S (S (S Z)))))) :* ANil))
        (mkEnv [] (b :. emit :. ([0, 1] :: [Obs]) :. stakes :. dirs
                     :. n :. p :. VNil))

-- the chosen act: strict improvement, first-listed wins (CL-3)
chosenAct :: Belief Double -> Dir
chosenAct b =
  if expect b (applyUtil stakes DirR) > expect b (applyUtil stakes DirL)
    then DirR else DirL

condBatch :: Belief Double -> [Obs] -> Belief Double
condBatch = foldl' (\bb y ->
  fromMaybe (error "impossible evidence in batch") (cond bb (Saw emit y)))

-- the frozen myopic reference loop (runDeliberation's decision rule:
-- think displaces act iff strictly greater; the clock alone terminates)
myopicRun :: Double -> Belief Double -> [Obs] -> (Int, Dir)
myopicRun p = go 0
  where
    go ticks b buf
      | null buf = (ticks, chosenAct b)
      | vT1 b (min 3 (length buf)) p > vAct1 b =
          go (ticks + 1) (condBatch b (take 3 buf)) (drop 3 buf)
      | otherwise = (ticks, chosenAct b)

-- the ladder loop: options are act, then the rung menu shallow-first
-- (CL-3 at the menu, as ruled); strict improvement, first-listed wins.
-- Firing a depth-k rung is the ruled option-with-declared-termination:
-- k batches over k real ticks, then re-decide. Rungs are offered only
-- up to the remaining buffer (the dryness clause, L5).
runLadder :: Grid -> Double -> Belief Double -> [Obs] -> (Int, Dir, [Int])
runLadder g p = go 0 []
  where
    rungs = toList (ladderRungs g)
    go ticks ks b buf
      | null buf = (ticks, chosenAct b, reverse ks)
      | otherwise =
          let n = min 3 (length buf)
              avail = [ rungDepth r | r <- rungs
                      , 3 * rungDepth r <= length buf ]
              opts = (Nothing, vAct1 b)
                   : [ (Just k, vThinkK k b emit ([0, 1] :: [Obs])
                                  stakes dirs n p)
                     | k <- avail ]
              step (bo, bv) (o, v) = if v > bv then (o, v) else (bo, bv)
          in case fst (foldl' step (Nothing, vAct1 b) opts) of
               Nothing -> (ticks, chosenAct b, reverse ks)
               Just k  -> go (ticks + k) (k : ks)
                             (condBatch b (take (3 * k) buf))
                             (drop (3 * k) buf)

-- the depth grids: menu data with prices (interface.md section 6,
-- "for k in a priced grid"); the solo grid's one point is rejected by
-- the door (depth 1 already has its one spelling), leaving the base
-- rung alone — the degenerate ladder.
depthGrid :: Grid
depthGrid = mkGrid "depth" (2 :| [3])

depthGrid4 :: Grid
depthGrid4 = mkGrid "depth" (2 :| [3, 4])

soloGrid :: Grid
soloGrid = mkGrid "depth" (1 :| [])

t2Prices :: [Double]
t2Prices = [ p | (p, _, _) <- t2Rows ]

-- ---------------------------------------------------------------------
-- group 1: rung-1 identity (one arithmetic — the E7 doctrine)
-- ---------------------------------------------------------------------

g1Beliefs :: [Belief Double]
g1Beliefs =
  [ uniform thetaSpace
  , condBatch (uniform thetaSpace) (take 3 buffer36)
  , condBatch (uniform thetaSpace) (take 9 buffer36)
  , fPrior
  ]

g1Identity :: TestTree
g1Identity = testGroup "rung-1 identity (one arithmetic)"
  [ testCase "worker at depth 1 == the frozen VThink verb (exact)" $
      mapM_ (\(i, b) -> mapM_ (\p ->
               assertEqual ("belief " ++ show (i :: Int)
                            ++ ", price " ++ show p)
                           (vT1 b 3 p)
                           (vThinkK 1 b emit ([0, 1] :: [Obs])
                                    stakes dirs 3 p))
             t2Prices)
            (zip [0 ..] g1Beliefs)
  , testProperty "worker-verb identity at depth 1 (random prefix, price)" $
      \(NonNegative m) ->
        forAll (choose (0, 0.5)) $ \p ->
          let b = condBatch (uniform thetaSpace) (take (m `mod` 37) buffer36)
          in vThinkK 1 b emit ([0, 1] :: [Obs]) stakes dirs 3 p
               === vT1 b 3 p
  , testCase "the myopic reference reproduces the frozen t2Rows" $
      mapM_ (\(p, tkA, aA) -> do
               let (tk, a) = myopicRun p (uniform thetaSpace) buffer36
               assertEqual ("ticks at price " ++ show p) tkA tk
               assertEqual ("act at price " ++ show p) aA (dirName a))
            t2Rows
  , testCase "the degenerate ladder (solo grid) IS the myopic agent" $
      mapM_ (\p -> do
               let (mtk, ma) = myopicRun p (uniform thetaSpace) buffer36
               assertEqual ("triple at price " ++ show p)
                           (mtk, ma, replicate mtk 1)
                           (runLadder soloGrid p (uniform thetaSpace)
                                      buffer36))
            t2Prices
  ]

-- ---------------------------------------------------------------------
-- group 2: test F direction 1 — t2's anchors as CHOSEN behavior
-- ---------------------------------------------------------------------

-- Rung-sequence pins: NEW-WORLD intended-behavior pins, authored at
-- Task 1 from the Task-0 sanity sim (LADDER_PLAN T1 table; margins in
-- the freeze pack). The frozen quantities — tick counts and final
-- acts — are pinned in the first case straight from Anchors.t2Rows.
t2RungPins :: [(Double, [Int])]
t2RungPins =
  [ (0.3,   [1])
  , (0.05,  [1, 1, 1])
  , (0.005, [3, 3, 3, 3])
  , (0.0,   [3, 3, 3, 3])
  ]

g2Direction1 :: TestTree
g2Direction1 = testGroup "test F direction 1 (t2 anchors as chosen behavior)"
  [ testCase "ticks and final acts reproduce through the ladder (frozen anchors)" $
      mapM_ (\(p, tkA, aA) -> do
               let (tk, a, _) = runLadder depthGrid p (uniform thetaSpace)
                                          buffer36
               assertEqual ("ticks at price " ++ show p) tkA tk
               assertEqual ("act at price " ++ show p) aA (dirName a))
            t2Rows
  , testCase "the chosen rung is myopic where the clock bites (amended F)" $
      mapM_ (rungCheck) [ r | r@(p, _) <- t2RungPins, p >= 0.05 ]
  , testCase "the ladder buys fidelity where fidelity is cheap (pinned)" $
      mapM_ (rungCheck) [ r | r@(p, _) <- t2RungPins, p < 0.05 ]
  ]
  where
    rungCheck (p, ksA) = do
      let (_, _, ks) = runLadder depthGrid p (uniform thetaSpace) buffer36
      assertEqual ("rung sequence at price " ++ show p) ksA ks

-- ---------------------------------------------------------------------
-- group 3: test F direction 2 — the adversarial buffer
-- (design.md section 7's recorded bias, made flesh)
-- ---------------------------------------------------------------------

-- Declared pre-episode history, folded through cond BY THE HOST (the
-- L6 correction): the world never hands a belief — uniform/point/
-- fromBits stay the only prior sources. Net +4 means no single
-- 3-outcome batch can flip the R decision, so the myopic VoI sits at
-- exactly zero with a linear utility.
history4 :: [Obs]
history4 = [1, 1, 1, 1]

fPrior :: Belief Double
fPrior = condBatch (uniform thetaSpace) history4

-- the adversarial stream: the true theta lives at the bottom of the
-- grid, and the tilt is a lie the prior tells
zeros12 :: [Obs]
zeros12 = replicate 12 0

fTheta :: Double
fTheta = 0.1

realizedU :: Dir -> Double
realizedU a = applyUtil stakes a fTheta

fPrices :: [Double]
fPrices = [0.005, 0.001, 0.0005]

g3Direction2 :: TestTree
g3Direction2 = testGroup "test F direction 2 (adversarial buffer)"
  [ testCase "declared history tilts the prior; myopic VoI sits at zero" $
      mapM_ (\p ->
        let lhs = vT1 fPrior 3 p
            rhs = vAct1 fPrior - p
        in assertBool ("VoI at price " ++ show p ++ ": vThink "
                       ++ show lhs ++ " vs act-minus-price " ++ show rhs)
                      (abs (lhs - rhs) <= 1e-9 * (1 + abs rhs)))
        fPrices
  , testCase "fixed myopia acts immediately, into the stakes' wrong side" $
      mapM_ (\p -> assertEqual ("myopic at price " ++ show p)
                     (0 :: Int, "R")
                     (let (tk, a) = myopicRun p fPrior zeros12
                      in (tk, dirName a)))
            fPrices
  , testCase "the ladder does not buy when the clock is dear" $
      assertEqual "triple at price 0.005"
                  (0 :: Int, "R", [] :: [Int])
                  (let (tk, a, ks) = runLadder depthGrid 0.005 fPrior zeros12
                   in (tk, dirName a, ks))
  , testCase "near zero, the ladder buys depth and flips the act (pinned)" $
      mapM_ (\p -> assertEqual ("triple at price " ++ show p)
                     (3 :: Int, "L", [3])
                     (let (tk, a, ks) = runLadder depthGrid p fPrior zeros12
                      in (tk, dirName a, ks)))
            [0.001, 0.0005]
  , testCase "the purchase pays: net realized utility" $
      mapM_ (\p -> do
               let (mtk, ma) = myopicRun p fPrior zeros12
                   (ltk, la, _) = runLadder depthGrid p fPrior zeros12
                   netM = realizedU ma - fromIntegral mtk * p
                   netL = realizedU la - fromIntegral ltk * p
               assertApprox ("myopic net at " ++ show p) 1e-12 (-0.8) netM
               assertApprox ("ladder net at " ++ show p) 1e-12
                            (0.8 - 3 * p) netL
               assertBool "the deeper estimate earns its keep" (netL > netM))
            [0.001, 0.0005]
  ]

-- ---------------------------------------------------------------------
-- group 4: termination — section 6's theorem, the executable slice
-- ---------------------------------------------------------------------

-- Vmax = max |2*theta - 1| over the frozen theta grid (0.1 .. 0.9),
-- i.e. 0.8: the stakes' range bounds every act value, so
-- Est_k <= Vmax - k*price and at positive price rungs beyond
-- (Vmax - V0)/price can never beat acting — a theorem, not a cap.
-- The executable slice checks the bound on the computable prefix and
-- the argmax's indifference to grid points beyond it.
g4Termination :: TestTree
g4Termination = testGroup "termination (the ladder's theorem, executable slice)"
  [ testCase "Est_k respects the analytic bound Vmax - k * price" $
      mapM_ (\b -> mapM_ (\k ->
               assertBool ("depth " ++ show k)
                          (vThinkK k b emit ([0, 1] :: [Obs])
                                   stakes dirs 3 0.05
                             <= 0.8 - fromIntegral k * 0.05 + 1e-12))
             [1 .. 4 :: Int])
            g1Beliefs
  , testCase "extending the depth grid beyond the bound leaves behavior fixed" $
      mapM_ (\p -> assertEqual ("triples at price " ++ show p)
                     (runLadder depthGrid p (uniform thetaSpace) buffer36)
                     (runLadder depthGrid4 p (uniform thetaSpace) buffer36))
            [0.3, 0.05]
  ]

-- ---------------------------------------------------------------------
-- group 5: prices — the menu's grid, the door, the sayable surface
-- ---------------------------------------------------------------------

lg :: Double -> Double
lg = logBase 2

unBits :: Bits -> Double
unBits (Bits x) = x

g5Prices :: TestTree
g5Prices = testGroup "prices (menu grid, door, sayable surface)"
  [ testCase "a depth constant prices node + lg grid (1e-12)" $ do
      case mkC depthGrid 0 of
        Just c  -> assertApprox "lg 19 + lg 2" 1e-12
                     (lg 19 + lg 2) (unBits (bits (c :: Expr '[] Double)))
        Nothing -> assertFailure "mkC rejected an in-range depth index"
      case mkC depthGrid4 0 of
        Just c  -> assertApprox "lg 19 + lg 3" 1e-12
                     (lg 19 + lg 3) (unBits (bits (c :: Expr '[] Double)))
        Nothing -> assertFailure "mkC rejected an in-range depth index"
  , testCase "grid-size monotonicity at the depth C node" $
      case (mkC depthGrid 0, mkC depthGrid4 0) of
        (Just c2, Just c3) ->
          assertBool "lg 2 < lg 3"
            (unBits (bits (c2 :: Expr '[] Double))
               < unBits (bits (c3 :: Expr '[] Double)))
        _ -> assertFailure "mkC rejected an in-range depth index"
  , testCase "the rung door: off-grid depths are unconstructible" $ do
      assertEqual "out of range" Nothing
                  (rungDepth <$> mkRung depthGrid 5)
      assertEqual "non-integral point" Nothing
                  (rungDepth <$> mkRung (mkGrid "depth" (2.5 :| [])) 0)
      assertEqual "depth 1 has one spelling (baseRung)" Nothing
                  (rungDepth <$> mkRung soloGrid 0)
      assertEqual "in-range deeper point" (Just 2)
                  (rungDepth <$> mkRung depthGrid 0)
      assertEqual "the rung menu, shallow-first" [1, 2, 3]
                  (map rungDepth (toList (ladderRungs depthGrid)))
      assertEqual "the base rung is depth 1" 1 (rungDepth baseRung)
  , testCase "the sayable rung valuation (fixture; red until the freeze)" $
      shellRow "sh" ["test-ladder/sayable.sh"]
  ]

-- ---------------------------------------------------------------------
-- group 6: deletion and audit rows
-- ---------------------------------------------------------------------

shellRow :: String -> [String] -> Assertion
shellRow cmd args = do
  (code, out, err) <- readProcessWithExitCode cmd args ""
  case code of
    ExitSuccess   -> pure ()
    ExitFailure _ -> assertFailure (cmd ++ " " ++ unwords args
                                    ++ ":\n" ++ out ++ err)

g6Rows :: TestTree
g6Rows = testGroup "deletion and audit rows"
  [ testCase "the ladder deletes; the myopic base survives" $
      shellRow "sh" ["test-ladder/ablation.sh", "ladder"]
  , testCase "the six-file scans stay exhaustive (no new src module)" $
      shellRow "sh" ["-c", "test \"$(ls src/PropLang/*.hs | wc -l)\" -eq 6"]
  ]
