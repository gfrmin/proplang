{-# LANGUAGE DataKinds #-}

-- | The preposterior oracle (step-6 increment 5; ROADMAP increment 5
-- as sharpened; PREPOSTERIOR_PLAN as ruled at Task 0) — written at
-- Task 1, runtime-red against the type-surface stubs (the Eval vPre
-- stub returns 0; Chan is real data plumbing), FROZEN at the Task 2
-- signing.
--
-- The mechanism (P1 as ruled): the preposterior's evidence channel is
-- a function of the decision under evaluation — W_0 is the frozen
-- leaf (vAct over the terminal menu, the induction base untouched);
-- W_j takes the best interior decision's immediate prevision plus the
-- continuation through THAT decision's own channel, the tick's price
-- outside the max. The frozen worker is the degenerate case at the
-- mute singleton (constant channel, zero immediate, unit menu) — the
-- identity is pinned with == (P2: identity-as-definition is the
-- required form).
--
-- PIN PROVENANCE (the b7f120e standard): frozen quantities are
-- imported (Streams.buffer36; the frozen verbs drive every
-- composition); world W / control W0 choices and nets are NEW-WORLD
-- intended-behavior pins authored at Task 1 from the Task-0 sim
-- (margins in the freeze pack). Value pins are asserted against
-- FROZEN-VERB COMPOSITIONS at 1e-12, not against transcribed
-- decimals. Test names are ASCII-only (canonized).
--
-- Scope limits recorded at authoring: (1) the worlds are one interior
-- decision deep (depth 1) — the worker is depth-general and the
-- degeneracy pins exercise depths 1..3, but no world here chains
-- interior decisions; (2) rungs stay out of the membrane driver
-- (kickoff scope); (3) the sayable surface (STDNAME seven) rides the
-- compile-fixture row, red until the freeze.
--
-- Task-1 red/green, enumerated: RED (9) — both degeneracy identities,
-- the value pins, both W choices, realized-anticipation, the control's
-- choice and margin, the sayable row. GREEN from start (6) —
-- frozen-verb-only rows (the myopic agent, forced exploration, the
-- noise no-op), the two audit rows, and ONE stub-accidental green
-- (safe's cross-world == holds at stub 0 == 0; it becomes load-bearing
-- when the worker lands).
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

import Streams (buffer36)

main :: IO ()
main = defaultMain $ testGroup "proplang preposterior (increment 5 oracle)"
  [ g1Degeneracy
  , g2World
  , g3Control
  , g4Honesty
  , g5Sayable
  , g6Rows
  ]

-- ---------------------------------------------------------------------
-- shared machinery (frozen shapes, frozen verbs)
-- ---------------------------------------------------------------------

assertApprox :: String -> Double -> Double -> Double -> Assertion
assertApprox msg tol expected actual =
  assertBool (msg ++ ": expected " ++ show expected ++ " +- " ++ show tol
                  ++ ", got " ++ show actual)
             (abs (actual - expected) <= tol)

data Dir = DirL | DirR
  deriving (Eq, Show)

stakes :: Util Dir Double
stakes = mkUtil $ \a th ->
  let v = 2 * th - 1 in case a of DirR -> v; DirL -> negate v

dirs :: NonEmpty Dir
dirs = DirL :| [DirR]

chosenAct :: Belief Double -> Dir
chosenAct b =
  if expect b (applyUtil stakes DirR) > expect b (applyUtil stakes DirL)
    then DirR else DirL

condBatch :: Kernel Double Obs -> Belief Double -> [Obs] -> Belief Double
condBatch k = foldl' (\bb y ->
  fromMaybe (error "impossible evidence in batch") (cond bb (Saw k y)))

-- the mute singleton for the degeneracy identity: unit menu, zero
-- immediate (definitional zero, not a steering constant)
muteU :: Util () Double
muteU = mkUtil (\_ _ -> 0)

muteMenu :: NonEmpty ()
muteMenu = () :| []

-- degenerate vPre against the frozen worker, same args both sides
degen :: Int -> Belief Double -> Double -> (Double, Double)
degen d b p =
  ( vPre d b (mkChan (const emit)) ([0, 1] :: [Obs]) muteU muteMenu
         stakes dirs 3 p
  , vThinkK d b emit ([0, 1] :: [Obs]) stakes dirs 3 p )

-- ---------------------------------------------------------------------
-- the worlds (P6 as ruled; the plan's T4, margins in the pack)
-- ---------------------------------------------------------------------

-- declared pre-episode history, folded through cond by the host (the
-- L6 doctrine): net +1 tilts the uninformed decision-2 act to R
history1 :: [Obs]
history1 = [1]

b0 :: Belief Double
b0 = condBatch emit (uniform thetaSpace) history1

-- the uninformative channel: theta-independent Bernoulli(0.5), world
-- data built from the exported surface only
noise :: Kernel Double Obs
noise = kernel thetaSpace (carrierSpace obsCarrier)
               (\_ -> bernFast obsCarrier 0.5)

data D1 = Safe | Probe
  deriving (Eq, Show)

-- immediate utilities: safe pays s regardless of theta; probe pays 0
immW :: Double -> Util D1 Double
immW s = mkUtil $ \d _ -> case d of Safe -> s; Probe -> 0

-- world W: the probe shows the informative channel; control W0: the
-- probe's channel is ALSO noise — the ONLY difference between the
-- worlds (same menu, same immediates, same price, same stream)
chanW, chanC :: Chan D1 Double Obs
chanW = mkChan $ \d -> case d of Safe -> noise; Probe -> emit
chanC = mkChan (const noise)

pTick :: Double
pTick = 0.01

-- per-decision value: vPre at the singleton menu of that decision
val1 :: Chan D1 Double Obs -> Double -> D1 -> Double
val1 ch s d =
  vPre 1 b0 ch ([0, 1] :: [Obs]) (immW s) (d :| []) stakes dirs 3 pTick

-- the anticipating agent's decision (strict improvement, first-listed
-- wins — CL-3; Safe is first-listed, so the probe must strictly earn it)
decide :: Chan D1 Double Obs -> Double -> D1
decide ch s =
  let vs = val1 ch s Safe
      vp = val1 ch s Probe
  in if vp > vs then Probe else Safe

-- the myopic agent: immediate prevision only (the frozen EU argmax)
decideMyopic :: Double -> D1
decideMyopic s =
  if expect b0 (applyUtil (immW s) Probe)
       > expect b0 (applyUtil (immW s) Safe)
    then Probe else Safe

-- realized episode: true theta at the bottom of the grid; the probe
-- reveals three zeros; two ticks either way (the probe pays in
-- foregone immediate utility, not in extra clock)
trueTheta :: Double
trueTheta = 0.1

probeStream :: [Obs]
probeStream = [0, 0, 0]

realizedNet :: Chan D1 Double Obs -> Double -> D1 -> Double
realizedNet ch s d =
  let imm = case d of Safe -> s; Probe -> 0
      b1 = case d of
             Safe  -> b0
             Probe -> condBatch (applyChan ch d) b0 probeStream
  in imm + applyUtil stakes (chosenAct b1) trueTheta - 2 * pTick

-- frozen-verb compositions the value pins are asserted against: the
-- continuation through a channel is the frozen worker at price 0
contVia :: Kernel Double Obs -> Double
contVia k = vThinkK 1 b0 k ([0, 1] :: [Obs]) stakes dirs 3 0

-- ---------------------------------------------------------------------
-- group 1: the degeneracy identity (E7 at the preposterior)
-- ---------------------------------------------------------------------

g1Beliefs :: [Belief Double]
g1Beliefs =
  [ uniform thetaSpace
  , b0
  , condBatch emit (uniform thetaSpace) (take 6 buffer36)
  ]

g1Degeneracy :: TestTree
g1Degeneracy = testGroup "the degeneracy identity (E7 at the preposterior)"
  [ testCase "degenerate vPre == the frozen worker (exact, fixed cases)" $
      mapM_ (\(i, b) -> mapM_ (\(d, p) ->
               let (lhs, rhs) = degen d b p
               in assertEqual ("belief " ++ show (i :: Int) ++ ", depth "
                               ++ show d ++ ", price " ++ show p)
                              rhs lhs)
             [ (d, p) | d <- [1, 2, 3], p <- [0.05, 0] ])
            (zip [0 ..] g1Beliefs)
  , testProperty "degenerate identity over random prefixes and prices" $
      \(NonNegative m) ->
        forAll (choose (0, 0.5)) $ \p ->
          forAll (elements [1, 2]) $ \d ->
            let b = condBatch emit (uniform thetaSpace)
                              (take (m `mod` 37) buffer36)
                (lhs, rhs) = degen d b p
            in lhs === rhs
  ]

-- ---------------------------------------------------------------------
-- group 2: exploration priced (world W)
-- ---------------------------------------------------------------------

g2World :: TestTree
g2World = testGroup "exploration priced (world W)"
  [ testCase "per-decision values pin to frozen-verb compositions (1e-12)" $ do
      assertApprox "safe = s + noise-continuation - p" 1e-12
                   (0.05 + contVia noise - pTick) (val1 chanW 0.05 Safe)
      assertApprox "probe = 0 + emit-continuation - p" 1e-12
                   (contVia emit - pTick) (val1 chanW 0.05 Probe)
  , testCase "the probe is bought at s=0.05 (the VoI covers the sacrifice)" $ do
      assertBool "probe strictly displaces first-listed safe"
                 (val1 chanW 0.05 Probe > val1 chanW 0.05 Safe)
      assertEqual "the anticipating agent's choice" Probe (decide chanW 0.05)
  , testCase "the probe is declined at s=0.4 (the iff's other direction)" $ do
      assertBool "safe holds" (val1 chanW 0.4 Safe > val1 chanW 0.4 Probe)
      assertEqual "the choice" Safe (decide chanW 0.4)
  , testCase "the myopic agent never probes (immediate prevision only)" $
      mapM_ (\s -> assertEqual ("s = " ++ show s) Safe (decideMyopic s))
            [0.05, 0.4]
  , testCase "realized: anticipation beats myopia (pins at 1e-12)" $ do
      let netAD = realizedNet chanW 0.05 (decide chanW 0.05)
          netMy = realizedNet chanW 0.05 (decideMyopic 0.05)
      assertApprox "anticipating agent nets 0.78" 1e-12 0.78 netAD
      assertApprox "myopic agent nets -0.77" 1e-12 (-0.77) netMy
      assertBool "the anticipation earns its keep" (netAD > netMy)
  ]

-- ---------------------------------------------------------------------
-- group 3: the paired control (W0 — the C0/group-6 standard)
-- ---------------------------------------------------------------------

g3Control :: TestTree
g3Control = testGroup "the paired control (W0)"
  [ testCase "the same code path declines the uninformative probe" $ do
      assertBool "safe holds in the control"
                 (val1 chanC 0.05 Safe > val1 chanC 0.05 Probe)
      assertEqual "the choice" Safe (decide chanC 0.05)
  , testCase "the margin is the sacrifice exactly (analytic, 1e-12)" $
      assertApprox "value(safe) - value(probe) = s" 1e-12 0.05
                   (val1 chanC 0.05 Safe - val1 chanC 0.05 Probe)
  , testCase "forced exploration loses the sacrifice (realized, 1e-12)" $ do
      let netSafe = realizedNet chanC 0.05 Safe
          netProbe = realizedNet chanC 0.05 Probe
      assertApprox "safe nets -0.77" 1e-12 (-0.77) netSafe
      assertApprox "forced probe nets -0.82" 1e-12 (-0.82) netProbe
      assertBool "declining was correct" (netSafe > netProbe)
  ]

-- ---------------------------------------------------------------------
-- group 4: channel honesty
-- ---------------------------------------------------------------------

g4Honesty :: TestTree
g4Honesty = testGroup "channel honesty"
  [ testCase "conditioning on the noise channel is a posterior no-op (CL-4)" $
      mapM_ (\seq' ->
        let b' = condBatch noise b0 seq'
            lhs = expect b' (applyUtil stakes DirR)
            rhs = expect b0 (applyUtil stakes DirR)
        in assertBool ("seq " ++ show seq' ++ ": " ++ show lhs
                       ++ " vs " ++ show rhs)
                      (abs (lhs - rhs) <= 1e-9 * (1 + abs rhs)))
        [[0, 0, 0], [1, 0, 1], [1, 1, 1]]
  , testCase "W and W0 differ in the probe channel alone: safe's value ==" $
      assertEqual "identical floats through identical arithmetic"
                  (val1 chanW 0.05 Safe) (val1 chanC 0.05 Safe)
  ]

-- ---------------------------------------------------------------------
-- group 5: the sayable surface
-- ---------------------------------------------------------------------

g5Sayable :: TestTree
g5Sayable = testGroup "the sayable surface"
  [ testCase "Call VPre (fixture; red until the freeze lands STDNAME seven)" $
      shellRow "sh" ["test-prepost/sayable.sh"]
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
  [ testCase "the mechanism deletes; the myopic base and ladder survive" $
      shellRow "sh" ["test-prepost/ablation.sh", "vpre"]
  , testCase "the six-file scans stay exhaustive (no new src module)" $
      shellRow "sh" ["-c", "test \"$(ls src/PropLang/*.hs | wc -l)\" -eq 6"]
  ]
