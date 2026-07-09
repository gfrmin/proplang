{-# LANGUAGE DataKinds #-}

-- | test-d/D.hs — increment D's frozen oracle (HOSTS_D_PACK sections
-- 10 and 15; oracle phase, Task 1). Runtime-red against the src
-- type-surface stubs (the prepost 2bf6c72 pattern), compiled under
-- the exact gate flags by test-d/red-run.sh.
--
-- THE GREEN/RED CONTRACT (enumerated here, enforced by the stubs):
--
--   GREEN from day zero (frozen surface only):
--     g0       the two mandatory opening fixtures, NON-TRIVIALLY
--              (4-decision interior menu, depths 1, 2 AND 3, strict
--              menu-over-singleton dominance at depth >= 2)
--     gCensus  empty-census witnesses (the gP5 pins re-run; the 1169
--              count; the TauSpec validating door)
--     gRouting the routing-closure VALUE pins (frozen vPre over pair
--              beliefs; rider 1's measured-unit cost in the arithmetic)
--     gBudget's world-side rows (the dominant term, measured now)
--
--   RED until implementation (each calls a stubbed name; every
--   expected value is derived from FROZEN artifacts — never a
--   parallel simulation):
--     gDegeneracy  UConst-only reproduces the CIRL belief/value facts
--     gHeadline    the drift edge over the static twin (r1 re-scope;
--                  the original k=12 floor fell — stop report)
--     gConsult     the re-opened consult window at the t=60 flip
--     gTauMix      verdictKernel == the independent finite tau-mixture
--     gLedger      the O1 pin family (per-latent agents untouched by
--                  verdict/outcome streams — R-D13's identity)
--     gOffPath     the bit-price identity: on-path-indistinguishable
--                  rivals hold posterior odds at prior odds
--                  (UTILITY_RESEARCH_CROSSAUDIT G2 — drafted AFTER
--                  the Task-2 pack's first delivery; RULED KEEP at
--                  the author's second review, 2026-07-09)
--     gO3          the bad-code paired world (outcome-first vs
--                  verdict-only, strict posterior ordering)
--     gDriver      routing at the driver (membraneTickU buys the
--                  right affordance)
--     gWire        latent\@1 codec goldens + the process row
--     gBudget's utility-side count rows
--
-- SCOPE NOTES (recorded, not hidden): the CIRL realized-net pins
-- (nDefer/nAct, the u=0.8 tie) stay where they are frozen —
-- test-cirl — and are NOT duplicated through the new surface; D's
-- degeneracy scope is belief/value-level plus the death schedule.
-- gConsult's MAP pins are SHAPE pins (render-string prefixes): the
-- MAP rate index is an emergent quantity with no frozen-artifact
-- derivation, and pinning an underived literal would violate the
-- pinned-literal rule. The stream tag rides as a world-published
-- FEATURE ("stream": 0=report, 1=verdict, 2=outcome, 3=comparison) —
-- HOSTS_PLAN 6.2's convention; "explained" is a role, not a type.
--
-- Canonical render strings committed here (freeze with this file):
-- UConst sentences render as ('uconst', ('c', '<valuegrid>', k));
-- UWalk sentences as ('uwalk', ('c', '<rategrid>', j)).
module Main (main) where

import Data.Bits (testBit)
import Data.List (isPrefixOf)
import GHC.Clock (getMonotonicTime)
import qualified Data.List.NonEmpty as NE
import Data.List.NonEmpty (NonEmpty ((:|)))
import Control.Monad (forM_)
import System.CPUTime (getCPUTime)
import System.Environment (lookupEnv)
import Data.Maybe (fromMaybe)
import System.Process (readProcessWithExitCode)
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief
import PropLang.Enumerate (Agent, Model, Obs, TauSpec, UFamily (..),
                           agentMeta, agentModels, allTerminals,
                           allUFamilies, emit, enumerateModels,
                           enumerateModelsIn, enumerateUModels,
                           latentMarginal, mkAgent, mkTauSpec, observe,
                           obsCarrier, obsSpace, renderModel, thetaSpace,
                           verdictKernel)
import PropLang.Eval (bernFast, vPre)
import PropLang.Membrane (Affordance (..), Choice (..), Pilot (..),
                          PureWorld (..), UPilot (..), UTickState (..),
                          UTickTrace (..), baseRung, membraneTickU,
                          mkAffId, noEcho, runMembrane, runMembraneU)
import PropLang.Syntax
import Wire (parseJson)
import WireU

main :: IO ()
main = defaultMain $ testGroup "proplang increment D (latent utility) oracle"
  [ g0Mandatory
  , gCensus
  , gRouting
  , gBudget
  , gDegeneracy
  , gHeadline
  , gConsult
  , gTauMix
  , gLedger
  , gOffPath
  , gO3
  , gDriver
  , gWire
  ]

-- ---------------------------------------------------------------------
-- shared helpers (the cirl/govhost idiom)
-- ---------------------------------------------------------------------

assertApprox :: String -> Double -> Double -> Double -> Assertion
assertApprox msg tol expected actual =
  assertBool (msg ++ ": expected " ++ show expected ++ " +- " ++ show tol
                  ++ ", got " ++ show actual)
             (abs (actual - expected) <= tol)

lg :: Double -> Double
lg = logBase 2

forceB :: Maybe (Belief a) -> Belief a
forceB = fromMaybe (error "conditioning died on a possible observation")

condBatch :: Kernel h Obs -> Belief h -> [Obs] -> Belief h
condBatch k = foldl (\b y -> forceB (cond b (Saw k y)))

-- ---------------------------------------------------------------------
-- g0 — the two mandatory opening fixtures, non-trivially (GREEN)
--
-- THE WORLD (fixture data): latent h uniform over the eight integers
-- {0..7} (as Doubles — binary-exact); outcomes y in {0,1}, n = 1;
-- terminal menu = the eight values with the match utility
-- u(a, h) = 1 iff a == h else 0; INTERIOR MENU OF FOUR decisions
-- {bit0, bit1, bit2, wait} with per-decision channels — bit_i's
-- channel answers h's i-th bit (a point-mass kernel), wait's is the
-- constant y = 0; interior utility uD(wait, .) = 0.01, uD(bit_i, .)
-- = 0; tick price 0.05.
--
-- HAND DERIVATION (from the frozen Eval.hs vPreAt, verbatim: est 0 =
-- vAct; est j = max over interior dd of [ E[uD(dd)] + sum over
-- outcome seqs P(seq | belief through dd's OWN channel) * est (j-1)
-- (belief | seq) ] - price, price OUTSIDE the max):
--
--   est0(uniform over 2^m survivors) = 2^-m:
--     u8 -> 1/8, u4 -> 1/4, u2 -> 1/2, point -> 1.
--   A FRESH bit halves the survivor set (y = 0/1 each w.p. 1/2); a
--   STALE bit (already determined by the posterior) is a point-mass
--   observation: posterior unchanged, the impossible branch weight 0.
--
--   Full menu M = {b0, b1, b2, wait} from u8 (fresh bits exist at
--   every stage down to a point):
--     est1(M, u8) = max(0 + 1/4 [fresh bit], 0.01 + 1/8 [wait])
--                   - 0.05                     = 1/4  - 0.05 = 0.20
--     est1(M, u4) = max(1/2, 0.01 + 1/4) - 0.05 = 0.45
--     est1(M, u2) = max(1,   0.01 + 1/2) - 0.05 = 0.95
--     est2(M, u8) = max(0 + est1(M,u4), 0.01 + est1(M,u8)) - 0.05
--                 = max(0.45, 0.21) - 0.05      = 0.40
--     est2(M, u4) = max(est1(M,u2), 0.01+0.45) - 0.05
--                 = 0.95 - 0.05                 = 0.90
--     est3(M, u8) = max(est2(M,u4), 0.01+0.40) - 0.05
--                 = 0.90 - 0.05                 = 0.85
--
--   Singleton faces (the same bit re-asked is stale from the second
--   stage on — the informational reason menus matter):
--     {b0}:  est1 = 1/4 - 0.05 = 0.20
--            est2 = 1/4 - 0.10 = 0.15   (second ask stale)
--            est3 = 1/4 - 0.15 = 0.10
--     {wait}: estj = 1/8 + j*(0.01 - 0.05) = 1/8 - 0.04 j
--            depth 1: 0.085; depth 2: 0.045; depth 3: 0.005
--
--   MANDATORY FIXTURE 1 (interior-menu max above the singleton),
--   non-trivially: at depth 1 the menu EQUALS its best face (the
--   fold's max — pinned with ==); at depths 2 and 3 the menu
--   STRICTLY exceeds every singleton face (0.40 > 0.15; 0.85 > 0.10)
--   because only the menu can ask a FRESH bit each stage — the
--   adaptive content a singleton cannot express.
--   MANDATORY FIXTURE 2 (recursion above depth 1): depths 2 and 3
--   pinned by hand; the depth chain 0.85 > 0.40 > 0.20 is strict.
-- ---------------------------------------------------------------------

data GD = GB0 | GB1 | GB2 | GWaitD
  deriving (Eq, Show)

g0H :: Space Double
g0H = mkSpace (0 :| [1, 2, 3, 4, 5, 6, 7])

g0Y :: Space Obs
g0Y = mkSpace (0 :| [1])

g0B :: Belief Double
g0B = uniform g0H

g0BitK :: Int -> Kernel Double Obs
g0BitK i = kernel g0H g0Y
  (\h -> point g0Y (if testBit (round h :: Int) i then 1 else 0))

g0WaitK :: Kernel Double Obs
g0WaitK = kernel g0H g0Y (\_ -> point g0Y 0)

g0Chan :: Chan GD Double Obs
g0Chan = mkChan $ \d -> case d of
  GB0    -> g0BitK 0
  GB1    -> g0BitK 1
  GB2    -> g0BitK 2
  GWaitD -> g0WaitK

g0UD :: Util GD Double
g0UD = mkUtil $ \d _ -> case d of GWaitD -> 0.01; _ -> 0

g0U :: Util Double Double
g0U = mkUtil $ \a h -> if a == h then 1 else 0

g0Acts :: NonEmpty Double
g0Acts = 0 :| [1, 2, 3, 4, 5, 6, 7]

g0Menu :: NonEmpty GD
g0Menu = GB0 :| [GB1, GB2, GWaitD]

g0Val :: Int -> NonEmpty GD -> Belief Double -> Double
g0Val d menu b = vPre d b g0Chan ([0, 1] :: [Obs]) g0UD menu g0U g0Acts 1 0.05

-- u4: bit0 known 0 — conditioned THROUGH the frozen kernel, so the
-- belief stays on the full 8-point space.
g0B4 :: Belief Double
g0B4 = forceB (cond g0B (Saw (g0BitK 0) 0))

g0Mandatory :: TestTree
g0Mandatory = testGroup "g0 mandatory opening fixtures, non-trivial (GREEN)"
  [ testCase "depth 1: menu 0.20; faces b0 0.20, wait 0.085" $ do
      assertApprox "menu"  1e-12 0.20  (g0Val 1 g0Menu g0B)
      assertApprox "b0"    1e-12 0.20  (g0Val 1 (GB0 :| []) g0B)
      assertApprox "wait"  1e-12 0.085 (g0Val 1 (GWaitD :| []) g0B)
  , testCase "depth 1: the menu equals the max of its faces (exact)" $
      assertEqual "max exercised, not defaulted"
        (maximum [ g0Val 1 (d :| []) g0B | d <- [GB0, GB1, GB2, GWaitD] ])
        (g0Val 1 g0Menu g0B)
  , testCase "order flip: the fold scans past first-listed losers" $
      assertEqual "menu reversed = menu"
        (g0Val 1 g0Menu g0B)
        (g0Val 1 (GWaitD :| [GB2, GB1, GB0]) g0B)
  , testCase "depth 2: menu 0.40 STRICTLY above every singleton face" $ do
      assertApprox "menu depth 2" 1e-12 0.40 (g0Val 2 g0Menu g0B)
      assertApprox "b0 depth 2 (stale second ask)" 1e-12 0.15
        (g0Val 2 (GB0 :| []) g0B)
      assertApprox "wait depth 2" 1e-12 0.045 (g0Val 2 (GWaitD :| []) g0B)
      assertBool "strict dominance (the adaptive content)"
        (g0Val 2 g0Menu g0B
           > maximum [ g0Val 2 (d :| []) g0B | d <- [GB0, GB1, GB2, GWaitD] ])
  , testCase "depth 3: menu 0.85 STRICTLY above every singleton face" $ do
      assertApprox "menu depth 3" 1e-12 0.85 (g0Val 3 g0Menu g0B)
      assertApprox "b0 depth 3" 1e-12 0.10 (g0Val 3 (GB0 :| []) g0B)
      assertApprox "wait depth 3" 1e-12 0.005 (g0Val 3 (GWaitD :| []) g0B)
      assertBool "strict dominance at depth 3"
        (g0Val 3 g0Menu g0B
           > maximum [ g0Val 3 (d :| []) g0B | d <- [GB0, GB1, GB2, GWaitD] ])
  , testCase "the depth chain is strict: 0.85 > 0.40 > 0.20" $ do
      assertBool "W3 > W2" (g0Val 3 g0Menu g0B > g0Val 2 g0Menu g0B)
      assertBool "W2 > W1" (g0Val 2 g0Menu g0B > g0Val 1 g0Menu g0B)
  , testCase "mid-belief pin: est2(M, u4) = 0.90" $
      assertApprox "menu depth 2 from the half-resolved belief" 1e-12 0.90
        (g0Val 2 g0Menu g0B4)
  ]

-- ---------------------------------------------------------------------
-- gCensus — the empty-census witnesses (GREEN; HOSTS_D_PACK section 9)
--
-- D adds sorts, faces and grids; nothing frozen reprices. Witnessed
-- exactly as H witnessed P5: the six per-sort price pins re-run
-- byte-for-byte (prodTable = ProdTable 10 2 1 1 7 1 unchanged), the
-- 1169 enumeration count, and — new here — the TauSpec door's
-- validation (the mkC discipline: an unpriceable spec is
-- unconstructible). mkAgent/enumerateModels byte-stability on the
-- frozen acceptance streams is carried by the nine frozen suites
-- staying green through this increment (red-run checks them).
-- ---------------------------------------------------------------------

gCGrid4 :: Grid
gCGrid4 = mkGrid "g4" (1 :| [2, 3, 4])

gCensus :: TestTree
gCensus = testGroup "gCensus empty-census witnesses (GREEN)"
  [ testCase "EXPR node cost: Get prices at lg 10" $
      let Bits v = bits (Get "t" :: Expr '[] Double)
      in assertApprox "nodeB" 1e-12 (lg 10) v
  , testCase "EXPR + grid mention: mkC sentence prices at lg 10 + lg 4" $
      case mkC gCGrid4 0 of
        Nothing -> assertFailure "mkC: index 0 off a 4-point grid"
        Just e  -> let Bits v = bits (e :: Expr '[] Double)
                   in assertApprox "nodeB + grid" 1e-12 (lg 10 + lg 4) v
  , testCase "STDNAME choice: Call IsEq prices at lg 10 + lg 7 + args" $
      let Bits v = bits (Call IsEq (Get "t" :* Get "t" :* ANil)
                           :: Expr '[] Bool)
      in assertApprox "nodeB + stdB + 2 Gets" 1e-12
           (lg 10 + lg 7 + 2 * lg 10) v
  , testCase "FN choice: Expect/FnInd prices at 2 lg 10 + 1" $
      let ev = event obsSpace (> 0)
          Bits v = bits (Expect (Var Z) (FnInd ev)
                           :: Expr '[B Obs] Double)
      in assertApprox "nodeB + Var(scope 1) + fnB" 1e-12
           (2 * lg 10 + 1) v
  , testCase "KER + STATS + carrier registry: ExpFam node prices at 0" $
      let Bits v = bits (ExpFam thetaSpace obsCarrier SId
                           :: Expr '[] (Kernel Double Obs))
      in assertApprox "kerB + carrierB + statsB" 1e-12 0 v
  , testCase "UTIL sort: USay (Var Z) prices at 0 + payload" $
      let Bits v = bits (USay (Var Z) :: Expr '[] (Util Double Double))
      in assertApprox "utilB + scope-2 Var" 1e-12 (lg 10 + 1) v
  , testCase "the frozen enumeration count stands: 1169" $
      length (enumerateModels allTerminals) @?= 1169
  , testCase "TauSpec door: weights must cover the grid exactly" $ do
      let tg = mkGrid "tau" (0.5 :| [1, 2])
      case mkTauSpec tg (0.5 :| [0.3, 0.2]) of
        Just _  -> pure ()
        Nothing -> assertFailure "a covering spec must construct"
      case mkTauSpec tg (0.5 :| [0.5]) of
        Nothing -> pure ()
        Just _  -> assertFailure "a short spec must not construct"
  ]

-- ---------------------------------------------------------------------
-- gRouting — the routing-closure VALUE pins (GREEN: frozen vPre over
-- pair beliefs; HOSTS_D_PACK section 4)
--
-- h = (ubar, theta_ask) pairs. Decisions: dAsk (verdict channel —
-- reads ubar only), dCompare (comparison channel — reads theta_ask
-- only, at the MEASURED-UNIT declared cost 0.15, rider 1: never
-- theta_ask-denominated). Deterministic channels keep every number
-- exact by hand.
--
-- R1 (zero-VoI, the O1 preposterior face): asking a verdict moves the
-- theta_ask MARGINAL not at all — posterior marginal == prior
-- marginal, 1e-12.
--
-- R2 (residual-bound): ubar KNOWN (= 1), theta_ask uniform over
-- {0.1, 0.9}; terminal menu {proceed: 0.4, ask-first: 1 - theta_ask}.
--   est0 = max(0.4, E[1 - theta_ask] = 0.5) = 0.5
--   dAsk branch    = -E[theta_ask] + est0(unchanged) = -0.5 + 0.5 = 0
--   dCompare branch = -0.15 + (1/2) est0(ta = 0.1: max(0.4, 0.9))
--                           + (1/2) est0(ta = 0.9: max(0.4, 0.1))
--                  = -0.15 + 0.45 + 0.20 = 0.5
--   faces (price 0.01): compare 0.49, ask -0.01 -> compare wins.
--
-- R3 (world-bound): ubar uniform {-1, 1}, theta_ask KNOWN (= 0.1);
-- terminal menu {proceed: ubar, block: 0}. est0 = 0.
--   dAsk branch    = -0.1 + (1/2)(1) + (1/2)(0) = 0.4
--   dCompare branch = -0.15 + 0 = -0.15
--   faces: ask 0.39, compare -0.16 -> the verdict-ask wins.
-- ---------------------------------------------------------------------

data RD = RAsk | RCompare
  deriving (Eq, Show)

rH :: Space (Double, Double)
rH = mkSpace ((-1, 0.1) :| [(-1, 0.9), (1, 0.1), (1, 0.9)])

rY :: Space Obs
rY = mkSpace (0 :| [1])

rAskK, rCompareK :: Kernel (Double, Double) Obs
rAskK     = kernel rH rY (\(u, _)  -> point rY (if u > 0 then 1 else 0))
rCompareK = kernel rH rY (\(_, ta) -> point rY (if ta > 0.5 then 1 else 0))

rChan :: Chan RD (Double, Double) Obs
rChan = mkChan (\d -> case d of RAsk -> rAskK; RCompare -> rCompareK)

-- rider 1 in the fixture: the comparison's cost is the DECLARED
-- measured-unit constant; the verdict-ask's is theta_ask itself
-- (permitted by the empty ledger cell — the stratification rule).
rUD :: Util RD (Double, Double)
rUD = mkUtil $ \d (_, ta) -> case d of
  RAsk     -> negate ta
  RCompare -> -0.15

gRouting :: TestTree
gRouting = testGroup "gRouting routing-closure value pins (GREEN)"
  [ testCase "R1 zero-VoI: a verdict moves the residual marginal not at all" $ do
      let prior = uniform rH
          taMass b = prob b (event rH (\(_, ta) -> ta > 0.5))
      forM_ [0, 1] $ \y -> do
        let post = forceB (cond prior (Saw rAskK y))
        assertApprox ("verdict y=" ++ show y) 1e-12
          (taMass prior) (taMass post)
  , testCase "R2 residual-bound: the comparison affordance wins" $ do
      -- ubar known: condition the uniform pair prior on a positive verdict
      let b2 = forceB (cond (uniform rH) (Saw rAskK 1))
          u2 = mkUtil $ \a (_, ta) ->
                 if a == (1 :: Int) then 0.4 else 1 - ta
          acts2 = 1 :| [3]
          face d = vPre 1 b2 rChan [0, 1] rUD (d :| []) u2 acts2 1 0.01
      assertApprox "compare face 0.49" 1e-12 0.49    (face RCompare)
      assertApprox "ask face -0.01"    1e-12 (-0.01) (face RAsk)
      assertBool "compare wins strictly" (face RCompare > face RAsk)
  , testCase "R3 world-bound: the verdict-ask wins" $ do
      -- theta_ask known: condition on the comparison saying LOW
      let b3 = forceB (cond (uniform rH) (Saw rCompareK 0))
          u3 = mkUtil $ \a (u, _) ->
                 if a == (1 :: Int) then u else 0
          acts3 = 1 :| [2]
          face d = vPre 1 b3 rChan [0, 1] rUD (d :| []) u3 acts3 1 0.01
      assertApprox "ask face 0.39"      1e-12 0.39    (face RAsk)
      assertApprox "compare face -0.16" 1e-12 (-0.16) (face RCompare)
      assertBool "ask wins strictly" (face RAsk > face RCompare)
  ]

-- ---------------------------------------------------------------------
-- gBudget — the section 10.11 measured obligation
--
-- The per-latent-agent architecture (rider 2) makes model counts
-- ADDITIVE, not multiplicative: world 3,977 + a few tens per utility
-- component. The dominant term is the world side, measurable NOW on
-- frozen surface (GREEN); the utility-side counts are exact pins
-- through the stubbed enumerator (RED). The wall-clock number is
-- printed for the Task-2 pack; the assertion bound is deliberately
-- generous (an order-of-magnitude tripwire, not a benchmark).
--
-- DECOMPOSITION ROWS (the second review's gating demand, 2026-07-09):
-- observe_batch removes only IPC — if the per-tick cost is engine,
-- 39k warm ticks are minutes of pure CPU per cold start and batching
-- fixes nothing. Measured here on the SAME world both ways: the
-- frozen govhost suite's small world (1241 models — the count the
-- gWire v2 handshake golden pins) run engine-only in-process, then
-- over the wire through the v1 driver. The difference is spawn +
-- codec + IPC; the engine share is what observe_batch CANNOT remove
-- and observe_counts (the count-collapse verb, drafted in gWire)
-- does.
-- ---------------------------------------------------------------------

budgetNames :: [Name]
budgetNames = [ "f" ++ show i | i <- [1 .. 39 :: Int] ]

budgetModels :: [Model]
budgetModels =
  enumerateModelsIn
    (mkNamespace ("t" :| budgetNames))
    [ (nm, mkGrid nm (0.5 :| [])) | nm <- budgetNames ]
    allTerminals

uGridD :: Grid
uGridD = mkGrid "ubar" (0.1 :| [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9])

rhoUGrid :: Grid
rhoUGrid = mkGrid "rho_u" (0.01 :| [0.02, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5])

gBudget :: TestTree
gBudget = testGroup "gBudget the enumeration budget, measured (10.11)"
  [ testCase "world side (GREEN): the governor-sized world is 3977" $
      length budgetModels @?= 3977
  , testCase "world side (GREEN): 50 frozen ticks, wall cost printed" $ do
      let w = PureWorld { wFeats    = const [("t", 1)]
                        , wEvidence = const (Just 1)
                        , wMenu     = const []
                        , wStep     = \s _ -> s } :: PureWorld ()
          ag = mkAgent budgetModels
      t0 <- getCPUTime
      case runMembrane w noEcho PilotIdle 50 () ag of
        Nothing        -> assertFailure "impossible evidence on tick 1"
        Just (_, tts)  -> length tts @?= 50
      t1 <- getCPUTime
      let ms = fromIntegral (t1 - t0) / (1e9 :: Double)
      putStrLn ("  [gBudget] 50 ticks x 3977 world models: "
                ++ show ms ++ " ms CPU")
      assertBool "order-of-magnitude tripwire (< 60 s CPU)" (ms < 60000)
  , testCase "decomposition (GREEN): engine-only ms/tick, 1241-model world" $ do
      let w = PureWorld { wFeats    = const [("t", 1), ("x", 1)]
                        , wEvidence = const (Just 1)
                        , wMenu     = const []
                        , wStep     = \s _ -> s } :: PureWorld ()
          ag = mkAgent smallModels
      length smallModels @?= 1241
      t0 <- getMonotonicTime
      case runMembrane w noEcho PilotIdle 200 () ag of
        Nothing       -> assertFailure "impossible evidence on tick 1"
        Just (_, tts) -> length tts @?= 200
      t1 <- getMonotonicTime
      let ms = (t1 - t0) * 1000 / 200
      putStrLn ("  [gBudget] engine-only, 1241 models: "
                ++ show ms ++ " ms/tick")
      assertBool "order-of-magnitude tripwire (< 1 s/tick)" (ms < 1000)
  , testCase "decomposition (GREEN): wire ms/tick, same world, v1 driver" $ do
      exe <- fromMaybe "proplang-govhost" <$> lookupEnv "GOVHOST_EXE"
      let input = unlines (smallHello : replicate 200 smallEvidence)
      t0 <- getMonotonicTime
      (_, out, _) <- readProcessWithExitCode exe [] input
      t1 <- getMonotonicTime
      length (lines out) @?= 201
      let ms = (t1 - t0) * 1000 / 200
      putStrLn ("  [gBudget] wire (spawn+codec+IPC incl.), 1241 models: "
                ++ show ms ++ " ms/tick")
      assertBool "order-of-magnitude tripwire (< 1 s/tick)" (ms < 1000)
  , testCase "utility side (RED): UConst enumerates one per value point" $
      length (enumerateUModels emit uGridD rhoUGrid [UConst]) @?= 9
  , testCase "utility side (RED): UConst+UWalk adds one per rate point" $
      length (enumerateUModels emit uGridD rhoUGrid allUFamilies) @?= 17
  ]

-- the frozen govhost suite's small world (GovHost.hs smallDecl /
-- handshakeLine, reproduced verbatim as fixture data), driven from
-- both sides of the wire by the decomposition rows above
smallModels :: [Model]
smallModels =
  enumerateModelsIn (mkNamespace ("t" :| ["x"]))
                    [("x", mkGrid "x" (0.5 :| []))]
                    allTerminals

smallHello :: String
smallHello =
  "{\"membrane\":1,\"world\":{\"namespace\":[\"t\",\"x\"],\
  \\"guards\":[{\"name\":\"x\",\"grid\":[0.5]}],\
  \\"menu\":[{\"id\":3,\"name\":\"ask\",\"slots\":[]},\
  \{\"id\":2,\"name\":\"block\",\"slots\":[]},\
  \{\"id\":1,\"name\":\"proceed\",\"slots\":[]}],\
  \\"utility\":{\"form\":\"table@1\",\"rows\":[\
  \{\"fire\":3,\"u\":[-0.02,-0.02]},\
  \{\"fire\":2,\"u\":[0,-0.5]},\
  \{\"fire\":1,\"u\":[-0.5,0]},\
  \{\"internal\":\"think\",\"u\":[-3,-3]}]},\
  \\"echo\":{\"last_action\":false,\"tick\":false,\
  \\"ticks_spent_thinking\":false}}}"

smallEvidence :: String
smallEvidence = "{\"tick\":{\"features\":{\"t\":1,\"x\":1},\"evidence\":1}}"

-- ---------------------------------------------------------------------
-- gDegeneracy — UConst-only reproduces the frozen CIRL facts (RED)
--
-- The expected side is recomputed HERE with frozen verbs only, in
-- test-cirl/Cirl.hs's exact shape (bk via condBatch emit; val via the
-- 10-arg vPre; pTick = 0.01, batch n = 3, terms = TOff :| [TProceed])
-- — derivation from the frozen artifact, never a parallel one. The
-- actual side runs the SAME quantities through the new utility-agent
-- surface: enumerateUModels emit (the CIRL worlds' channel) over the
-- 9-point value grid, UConst only, latentMarginal as the readout.
-- dl-uniform UConst hypotheses make the dl-prior uniform, so the
-- agent's posterior must equal bk k digit for digit.
-- ---------------------------------------------------------------------

data D2 = DAct | DDefer deriving (Eq, Show)
data T2 = TOff | TProceed deriving (Eq, Show)

stepH :: Double -> Double
stepH u = if u > 0.5 then 1 else -1

uTermC :: Util T2 Double
uTermC = mkUtil $ \a h -> case a of TProceed -> stepH h; TOff -> 0

immU :: Util D2 Double
immU = mkUtil $ \d h -> case d of DAct -> stepH h; DDefer -> 0

noiseC :: Kernel Double Obs
noiseC = kernel thetaSpace (carrierSpace obsCarrier)
           (\_ -> bernFast obsCarrier 0.5)

chanW, chanC :: Chan D2 Double Obs
chanW = mkChan (\d -> case d of DAct -> noiseC; DDefer -> emit)
chanC = mkChan (const noiseC)

termsC :: NonEmpty T2
termsC = TOff :| [TProceed]

pTickC :: Double
pTickC = 0.01

thetaPts :: [Double]
thetaPts = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]

bk :: Int -> Belief Double
bk k = condBatch emit (uniform thetaSpace) (replicate k 1)

valB :: Belief Double -> Chan D2 Double Obs -> D2 -> Double
valB b ch d = vPre 1 b ch ([0, 1] :: [Obs]) immU (d :| []) uTermC termsC 3 pTickC

marginB :: Belief Double -> Chan D2 Double Obs -> Double
marginB b ch = valB b ch DDefer - valB b ch DAct

voiB :: Belief Double -> Double
voiB b = marginB b chanW - marginB b chanC

e2u1 :: Belief Double -> Double
e2u1 b = expect b (applyUtil uTermC TProceed)

-- listening: COPIED from the frozen test-cirl/Cirl.hs:138-139 (the
-- copy-not-reconstruct rule, adopted at the r1 re-open — the
-- original transcription here conflated this predicate with the
-- value-decomposition pin's shape and was repaired under the
-- author's delegated ruling, 2026-07-09): after the agent defers
-- and the human presses three times, does the terminal act flip?
obeysB :: Belief Double -> Bool
obeysB b = e2u1 (condBatch emit b [0, 0, 0]) <= 0

-- the actual side: the new surface (RED through the stubs)
uAgent0 :: [UFamily] -> Agent
uAgent0 fams = mkAgent (enumerateUModels emit uGridD rhoUGrid fams)

feed :: Int -> [Obs] -> Agent -> Agent
feed n ys0 ag0 = go (take n (ys0 ++ repeat 1)) ag0
  where
    go []       ag = ag
    go (y : ys) ag = case observe [] y ag of
      Just (_, ag') -> go ys ag'
      Nothing       -> error "impossible verdict killed the agent"

lmConst :: Int -> Belief Double
lmConst k = latentMarginal (feed k (repeat 1) (uAgent0 [UConst]))

gDegeneracy :: TestTree
gDegeneracy = testGroup "gDegeneracy UConst-only == the frozen CIRL facts (RED)"
  [ testCase "bk reproduction at k in {0,2,4,12}, 9 points, 1e-12" $
      forM_ [0, 2, 4, 12] $ \k ->
        forM_ thetaPts $ \p ->
          assertApprox ("k=" ++ show k ++ " p=" ++ show p) 1e-12
            (prob (bk k) (is thetaSpace p))
            (prob (lmConst k) (is thetaSpace p))
  , testCase "asking dies at k=1 and stays dead (through the readout)" $ do
      assertBool "k=0: deference margin positive"
        (marginB (lmConst 0) chanW > 0)
      forM_ [1 .. 12] $ \k ->
        assertBool ("k=" ++ show k ++ ": margin non-positive")
          (marginB (lmConst k) chanW <= 0)
  , testCase "listening survives to k=3, dies at k=4" $ do
      forM_ [0 .. 3] $ \k ->
        assertBool ("k=" ++ show k ++ " obeys") (obeysB (lmConst k))
      forM_ [4 .. 12] $ \k ->
        assertBool ("k=" ++ show k ++ " disobeys")
          (not (obeysB (lmConst k)))
  , testCase "VoI decays below 1e-12 by k in {4,6,12}; positive at 0" $ do
      assertBool "voi(0) > 0" (voiB (lmConst 0) > 0)
      forM_ [4, 6, 12] $ \k ->
        assertBool ("voi(" ++ show k ++ ") <= 1e-12")
          (voiB (lmConst k) <= 1e-12)
  ]

-- ---------------------------------------------------------------------
-- gHeadline — the drift edge over the static twin (RE-SCOPED at the
-- r1 re-open, author's delegated ruling 2026-07-09; the original
-- k=12 floor was unsatisfiable — through this composition BOTH
-- families' VoI dies at k=4, measured in the Task-3 stop report;
-- drift's re-opened-deference mechanism is gConsult's flip pins).
-- Both rows' expected sides were verified BY EXECUTION against the
-- landed implementation before this re-freeze (the satisfiability
-- rule, adopted at the same re-open): drift VoI 0.1226 / 0.0293 /
-- 0.0080 vs static 0.1222 / 0.0289 / 0.0077 at k = 1 / 2 / 3; both
-- exactly 0 at k = 12.
-- ---------------------------------------------------------------------

gHeadline :: TestTree
gHeadline = testGroup "gHeadline the drift edge over the static twin (r1)"
  [ testCase "drift VoI strictly exceeds static at k in {1,2,3}" $
      forM_ [1, 2, 3] $ \k -> do
        let lmDrift = latentMarginal (feed k (repeat 1) (uAgent0 allUFamilies))
        assertBool ("k=" ++ show k)
          (voiB lmDrift > voiB (lmConst k))
  , testCase "both families' VoI is dead at k=12 (<= 1e-12)" $ do
      let lmDrift = latentMarginal (feed 12 (repeat 1) (uAgent0 allUFamilies))
      assertBool "drift"  (voiB lmDrift <= 1e-12)
      assertBool "static" (voiB (lmConst 12) <= 1e-12)
  ]

-- ---------------------------------------------------------------------
-- gConsult — the re-opened consult window (RED)
--
-- The verdict stream flips at t=60 (the owner changes their mind —
-- the shifted world run on the pointer). The drift-carrying agent
-- resumes deference within a bounded window (20 ticks); the static
-- agent never does. MAP pins are SHAPE pins (see the header note):
-- the drift agent's MAP is a UWalk sentence, the static agent's a
-- UConst one — render prefixes committed at this freeze.
-- ---------------------------------------------------------------------

consultStream :: [Obs]
consultStream = replicate 60 1 ++ replicate 30 0

agentAt :: [UFamily] -> Int -> Agent
agentAt fams t = feed t consultStream (uAgent0 fams)

defersAt :: [UFamily] -> Int -> Bool
defersAt fams t = marginB (latentMarginal (agentAt fams t)) chanW > 0

mapRender :: Agent -> String
mapRender ag = case top (agentMeta ag) 1 of
  [(i, _)] -> renderModel (agentModels ag !! i)
  _        -> error "top returned no MAP"

gConsult :: TestTree
gConsult = testGroup "gConsult the consult window re-opens under drift (RED)"
  [ testCase "at t=60 (pre-flip) the drift agent has stopped asking" $
      assertBool "no deference at the flip" (not (defersAt allUFamilies 60))
  , testCase "the drift agent resumes deference within 20 post-flip ticks" $
      assertBool "bounded window"
        (any (defersAt allUFamilies) [61 .. 80])
  , testCase "the static agent never resumes" $
      assertBool "static silence"
        (not (any (defersAt [UConst]) [61 .. 90]))
  , testCase "MAP shapes at t=90: drift says walk, static says const" $ do
      assertBool "drift MAP is a UWalk sentence"
        ("('uwalk'" `isPrefixOf` mapRender (agentAt allUFamilies 90))
      assertBool "static MAP is a UConst sentence"
        ("('uconst'" `isPrefixOf` mapRender (agentAt [UConst] 90))
  ]

-- ---------------------------------------------------------------------
-- gTauMix — verdictKernel == the independent finite tau-mixture (RED)
--
-- This group DEFINES the tau-owner's semantics (R-D9's realization):
-- P(approve | u) = sum_i w_i * sigma(u / tau_i), weights normalized
-- by their sum, sigma the standard logistic. The oracle computes the
-- mixture independently and pins the kernel pointwise at 1e-12.
-- ---------------------------------------------------------------------

gTauMix :: TestTree
gTauMix = testGroup "gTauMix the tau-marginalised owner (RED)"
  [ testCase "pointwise identity over the 9-point value grid" $ do
      let tg = mkGrid "tau" (0.5 :| [1, 2])
          ws = [0.5, 0.3, 0.2] :: [Double]
          spec = case mkTauSpec tg (0.5 :| [0.3, 0.2]) of
                   Just s  -> s
                   Nothing -> error "covering spec must construct"
          vk = verdictKernel uGridD spec
          sigma x = 1 / (1 + exp (negate x))
          expected u = sum (zipWith (\w tau -> w * sigma (u / tau))
                                    ws [0.5, 1, 2])
                         / sum ws
      forM_ thetaPts $ \u ->
        assertApprox ("u=" ++ show u) 1e-12
          (expected u)
          (prob (push (point thetaSpace u) vk) (is obsSpace 1))
  ]

-- ---------------------------------------------------------------------
-- shared driver fixtures (gLedger / gO3 / gDriver)
--
-- The stream tag rides as a world-published FEATURE: ("stream", c)
-- with 0=report, 1=verdict, 2=outcome, 3=comparison. The tick price
-- is the world-published "tick-price" feature (measured data). World
-- state = the remaining [(stream, evidence)] script.
-- ---------------------------------------------------------------------

type Script = [(Double, Maybe Obs)]

scriptWorld :: [Affordance] -> PureWorld Script
scriptWorld menu = PureWorld
  { wFeats    = \s -> case s of
      ((c, _) : _) -> [("stream", c), ("tick-price", 0.01)]
      []           -> [("stream", 0), ("tick-price", 0.01)]
  , wEvidence = \s -> case s of
      ((_, e) : _) -> e
      []           -> Nothing
  , wMenu     = const menu
  , wStep     = \s _ -> drop 1 s
  }

askGrid :: Grid
askGrid = mkGrid "theta_ask" (0.05 :| [0.1, 0.2, 0.4])

askSpace :: Space Double
askSpace = mkSpace (0.05 :| [0.1, 0.2, 0.4])

tauSpecD :: TauSpec
tauSpecD = case mkTauSpec (mkGrid "tau" (0.5 :| [1, 2]))
                          (0.5 :| [0.3, 0.2]) of
  Just s  -> s
  Nothing -> error "covering spec must construct"

-- the payload's fixture grids (priced data, like every fixture grid)
dCodeGrid, dStakeGrid :: Grid
dCodeGrid  = mkGrid "code" (1 :| [3, 4])
dStakeGrid = mkGrid "stake" ((-1) :| [0, 1])

dC :: Grid -> Int -> Expr '[Double, Double] Double
dC g j = case mkC g j of
  Just e  -> e
  Nothing -> error "fixture grid constant must construct"

-- the stake payload (r2 repair, author-delegated 2026-07-09; the
-- original Var (S Z) was action-degenerate, making information about
-- ubar worthless everywhere — stop report #2): proceed (code 1) pays
-- +1 if ubar > 0.5 else -1; every other action 0. Sayable: If / Gt /
-- Call IsEq / Var / grid constants only.
pilotSaid :: Expr '[Double, Double] Double
pilotSaid = If (Call IsEq (Var Z :* dC dCodeGrid 0 :* ANil))
               (If (Gt (Var (S Z)) (dC uGridD 4))
                   (dC dStakeGrid 2)
                   (dC dStakeGrid 0))
               (dC dStakeGrid 1)

pilotD :: UPilot
pilotD = UPilot
  { upSaid    = pilotSaid
  , upVerdict = mkChan (\d -> if abs (d - 3) < 0.5
                                then verdictKernel uGridD tauSpecD
                                else noiseC)
  , upOutcome = emit   -- O3's channel: P(good | ubar) = ubar, bern's shape
  , upDepth   = baseRung
  , upPrice   = "tick-price"
  }

worldAgent0 :: Agent
worldAgent0 = mkAgent (enumerateModels allTerminals)

pointerAgent0 :: Agent
pointerAgent0 =
  mkAgent (enumerateUModels (verdictKernel uGridD tauSpecD)
                            uGridD rhoUGrid [UConst])

askAgent0 :: Agent
askAgent0 =
  mkAgent (enumerateUModels
             (kernel askSpace (carrierSpace obsCarrier)
                     (\ta -> point (carrierSpace obsCarrier)
                                   (if ta > 0.15 then 1 else 0)))
             askGrid rhoUGrid [UConst])

menuD :: [Affordance]
menuD = [ Affordance (mkAffId 3) "ask" []
        , Affordance (mkAffId 4) "compare" []
        , Affordance (mkAffId 1) "proceed" [] ]

-- ---------------------------------------------------------------------
-- gLedger — the O1 pin family (RED; rider 2 / R-D13)
--
-- Under the DECLARED per-latent independence, a component whose
-- ledger row is empty on the running streams sits at its dl-prior
-- EXACTLY. UConst hypotheses share one dl, so the dl-prior is
-- uniform: after a 10-tick verdict-and-outcome-only episode, the
-- theta_ask agent's marginal is still 1/4 at each of its 4 grid
-- points, 1e-12 — an identity regression, not an empirical claim.
-- ---------------------------------------------------------------------

gLedger :: TestTree
gLedger = testGroup "gLedger the O1 empty-row pin family (RED)"
  [ testCase "theta_ask sits at its dl-prior after verdict+outcome ticks" $ do
      let script = concat (replicate 5 [(1, Just 1), (2, Just 0)])
      case runMembraneU (scriptWorld menuD) noEcho pilotD 10 script
             worldAgent0 (pointerAgent0 :| [askAgent0]) of
        Nothing -> assertFailure "the episode died on possible evidence"
        Just (_, uAgents, _) -> do
          let askOut = last (NE.toList uAgents)
              lm = latentMarginal askOut
          forM_ [0.05, 0.1, 0.2, 0.4] $ \p ->
            assertApprox ("theta_ask mass at " ++ show p) 1e-12 0.25
              (prob lm (is askSpace p))
  ]

-- ---------------------------------------------------------------------
-- gOffPath — the bit-price floor's identity half (RED; drafted from
-- UTILITY_RESEARCH_CROSSAUDIT.md G2 AFTER the Task-2 pack's first
-- delivery; RULED KEEP at the author's second review, 2026-07-09 —
-- "regressions exist for the day an edit invalidates a derivation
-- someone remembered as a theorem": the identity holds only under
-- the product-form architecture and drafting decision 1)
--
-- The research floor (Armstrong-Mindermann, the cross-audit's G2):
-- hypotheses whose likelihoods agree on every EMITTED observation
-- have likelihood ratio exactly 1 on all evidence, so their
-- posterior odds sit at their prior odds forever — on-path evidence
-- can never separate them; only the alphabet's pricing ranks them.
-- A second deference floor, distinct from gHeadline's: that one is a
-- posterior that never concentrates IN TIME, this one a posterior
-- that never concentrates ACROSS off-path rivals.
--
-- Realized with NO new surface: a latent-constant emission kernel
-- (noiseC — every hypothesis emits Bern(0.5) identically), so the
-- identity holds regardless of UWalk's internal semantics; the only
-- architectural fact assumed is drafting decision 1 (emission
-- factors through the declared kernel). The prior odds are READ FROM
-- the t=0 agent — the frozen prior IS 2^-dl via fromBits, so the
-- alphabet's pricing supplies the odds and no hand literal enters.
-- Two grains:
--   within-family: uconst\@2 vs uconst\@6 share one sentence length
--     (the frozen grid pricing charges lg 9 for ANY index of a
--     9-point grid — the gCensus mkC pin's rule), so the
--     equal-length pair's odds are 1: A&M's harmful-pair case — the
--     prior does no work, and no on-path evidence can either;
--   cross-family: uconst\@2 vs uwalk\@3 — the odds are whatever the
--     pricing sets at t=0, and 12 blind ticks leave them there,
--     digit for digit.
-- ---------------------------------------------------------------------

offAgent0 :: Agent
offAgent0 = mkAgent (enumerateUModels noiseC uGridD rhoUGrid allUFamilies)

offW :: Agent -> String -> Double
offW ag r =
  case [ w | (i, w) <- top (agentMeta ag) (length (agentModels ag))
           , renderModel (agentModels ag !! i) == r ] of
    [w] -> w
    ws  -> error ("gOffPath: " ++ show (length ws)
                  ++ " models render as " ++ r)

offOdds :: Agent -> String -> String -> Double
offOdds ag r1 r2 = offW ag r1 / offW ag r2

-- the canonical renders committed in this file's header
offConst2, offConst6, offWalk3 :: String
offConst2 = "('uconst', ('c', 'ubar', 2))"
offConst6 = "('uconst', ('c', 'ubar', 6))"
offWalk3  = "('uwalk', ('c', 'rho_u', 3))"

gOffPath :: TestTree
gOffPath = testGroup "gOffPath posterior odds pinned at prior odds (RED)"
  [ testCase "equal-length pair: odds 1 at t=0 and after 12 blind ticks" $ do
      assertApprox "prior odds" 1e-12 1
        (offOdds offAgent0 offConst2 offConst6)
      assertApprox "posterior odds" 1e-12 1
        (offOdds (feed 12 (repeat 1) offAgent0) offConst2 offConst6)
  , testCase "cross-family pair: 12 blind ticks leave the odds at prior" $ do
      let prior = offOdds offAgent0 offConst2 offWalk3
      assertBool "prior odds positive and finite"
        (prior > 0 && not (isInfinite prior))
      assertApprox "posterior == prior" 1e-12 prior
        (offOdds (feed 12 (repeat 1) offAgent0) offConst2 offWalk3)
  ]

-- ---------------------------------------------------------------------
-- gO3 — the bad-code paired world (RED; the author's example)
--
-- Verdicts approve; outcomes are bad. The outcome-first agent's
-- pointer posterior downweights ubar; the verdict-only agent is
-- fooled. Strict ordering pinned on the posterior MEAN — the
-- qualitative content, with no underived literal.
-- ---------------------------------------------------------------------

gO3 :: TestTree
gO3 = testGroup "gO3 the bad-code paired world (RED)"
  [ testCase "outcome-first mean(ubar) < verdict-only mean(ubar), strictly" $ do
      let both  = concat (replicate 6 [(1, Just 1), (2, Just 0)])
          vOnly = concat (replicate 6 [(1, Just 1), (0, Nothing)])
          run script = case runMembraneU (scriptWorld menuD) noEcho pilotD
                              12 script worldAgent0
                              (pointerAgent0 :| [askAgent0]) of
            Nothing -> error "episode died"
            Just (_, uAgents, _) ->
              expect (latentMarginal (NE.head uAgents)) id
      assertBool "strict downweighting"
        (run both < run vOnly)
  ]

-- ---------------------------------------------------------------------
-- gDriver — routing at the driver (RED; the live face of gRouting)
--
-- Where the decision is residual-bound the driver buys the
-- comparison affordance; where it is world-bound, the verdict-ask.
-- Asserted on affordance ids only — the numeric geometry is pinned
-- GREEN in gRouting; these rows bind the DRIVER to it.
-- ---------------------------------------------------------------------

sharpen :: Int -> Agent -> Agent
sharpen k = feed k (repeat 1)

gDriver :: TestTree
gDriver = testGroup "gDriver the driver buys the right information (RED)"
  [ testCase "residual-bound: the fired choice is the comparison (id 4)" $ do
      let wA = sharpen 40 worldAgent0
      case membraneTickU (scriptWorld menuD) noEcho pilotD
             (UTickState 0 0 Nothing) [(0, Nothing)]
             wA (sharpen 30 pointerAgent0 :| [askAgent0]) of
        Nothing -> assertFailure "tick died"
        Just (_, _, _, _, tt) ->
          utChoice tt @?= Fire (mkAffId 4) []
  , testCase "world-bound: the fired choice is the verdict-ask (id 3)" $ do
      -- r2 repair (author-delegated): the pointer is fed ONE approving
      -- verdict (the near-boundary belief a single verdict can flip —
      -- a fresh pointer cannot be, the tau-mixture's likelihood ratio
      -- is <= 1.43/tick) and the known exchange rate is small (0.01);
      -- prototype-verified margin 0.043 (stop report #2, section 3)
      let askSharp = mkAgent (enumerateUModels
                                (kernel askSpace (carrierSpace obsCarrier)
                                        (\_ -> point (carrierSpace obsCarrier) 0))
                                (mkGrid "theta_ask" (0.01 :| []))
                                rhoUGrid [UConst])
      case membraneTickU (scriptWorld menuD) noEcho pilotD
             (UTickState 0 0 Nothing) [(0, Nothing)]
             worldAgent0 (sharpen 1 pointerAgent0 :| [askSharp]) of
        Nothing -> assertFailure "tick died"
        Just (_, _, _, _, tt) ->
          utChoice tt @?= Fire (mkAffId 3) []
  ]

-- ---------------------------------------------------------------------
-- gWire — latent@1 codec goldens + the process row (RED)
--
-- These goldens DEFINE wire v2's syntax (HOSTS_D_PACK section 8):
-- the latent utility block, the stream tag, observe_batch,
-- observe_counts (the count-collapsed warm channel — the second
-- review's budget ruling), the v2 decision reply with its two
-- observability-only readouts, and the v2 handshake reply (v1's
-- shape + "ulatents": pointer + residuals). The gauge block carries
-- R-D7 AS AMENDED (2026-07-09): zero + dollar-slope — the scale is
-- spent by the accounting layer's measured-dollar term, so there is
-- no second anchor and the erstwhile "reference-bad" placeholder
-- never acquires a referent.
-- ---------------------------------------------------------------------

latentBlockStr :: String
latentBlockStr =
  "{\"form\":\"latent@1\",\"said\":[\"var\",1],\
  \\"residuals\":[{\"name\":\"theta_ask\",\"grid\":[0.05,0.1,0.2,0.4]},\
  \{\"name\":\"theta_bad\",\"grid\":[0.1,0.5,1]}],\
  \\"tau\":{\"points\":[0.5,1,2],\"weights\":[0.5,0.3,0.2]},\
  \\"price\":\"tick-price\",\
  \\"gauge\":{\"zero\":\"status-quo\",\"scale\":\"usd\"}}"

latentHello :: String
latentHello =
  "{\"membrane\":1,\"world\":{\"namespace\":[\"t\",\"x\"],\
  \\"guards\":[{\"name\":\"x\",\"grid\":[0.5]}],\
  \\"menu\":[{\"id\":3,\"name\":\"ask\",\"slots\":[]},\
  \{\"id\":4,\"name\":\"compare\",\"slots\":[]},\
  \{\"id\":1,\"name\":\"proceed\",\"slots\":[]}],\
  \\"utility\":" ++ latentBlockStr ++ ",\
  \\"echo\":{\"last_action\":false,\"tick\":false,\
  \\"ticks_spent_thinking\":false}}}"

gWire :: TestTree
gWire = testGroup "gWire latent@1 codec goldens (RED)"
  [ testCase "the latent block parses (parseLatentDecl)" $
      case parseJson latentBlockStr of
        Left e  -> assertFailure ("fixture json: " ++ e)
        Right j -> case parseLatentDecl j of
          Left e   -> assertFailure e
          Right ld -> do
            ldPriceName ld @?= "tick-price"
            length (ldResiduals ld) @?= 2
            map rgName (ldResiduals ld) @?= ["theta_ask", "theta_bad"]
            gdZero (ldGauge ld) @?= "status-quo"
            gdScale (ldGauge ld) @?= "usd"
  , testCase "the v2 handshake parses (parseLineU)" $
      case parseLineU latentHello of
        Left e                -> assertFailure e
        Right (MUHello _ ld)  -> tdPoints (ldTau ld) @?= [0.5, 1, 2]
        Right other           -> assertFailure ("wrong shape: " ++ show other)
  , testCase "a stream-tagged evidence tick parses" $
      case parseLineU "{\"tick\":{\"stream\":\"verdict\",\
                       \\"features\":{\"t\":1,\"x\":1},\"evidence\":1}}" of
        Left e                  -> assertFailure e
        Right (MUTick tag _)    -> tag @?= Just "verdict"
        Right other             -> assertFailure ("wrong shape: " ++ show other)
  , testCase "observe_batch parses to the tagged list" $
      case parseLineU "{\"observe_batch\":[\
                       \{\"stream\":\"verdict\",\"features\":{\"t\":1},\"evidence\":1},\
                       \{\"stream\":\"outcome\",\"features\":{\"t\":2},\"evidence\":0}]}" of
        Left e               -> assertFailure e
        Right (MUBatch xs)   -> map fst xs @?= [Just "verdict", Just "outcome"]
        Right other          -> assertFailure ("wrong shape: " ++ show other)
  , testCase "observe_counts parses to the collapsed row" $
      case parseLineU "{\"observe_counts\":{\"stream\":\"verdict\",\
                       \\"features\":{\"t\":1,\"x\":1},\
                       \\"counts\":{\"1\":30000,\"0\":9314}}}" of
        Left e                        -> assertFailure e
        Right (MUCounts tag fs n1 n0) -> do
          tag @?= Just "verdict"
          lookup "x" fs @?= Just 1
          (n1, n0) @?= (30000, 9314)
        Right other                   -> assertFailure ("wrong shape: " ++ show other)
  , testCase "the v2 decision reply renders (observability-only readouts)" $
      assertEqual "golden"
        ("{\"choice\":{\"fire\":3,\"slots\":{}},\"p1\":0.5,\
         \\"entropy_bits\":3.25,\"residual_mean\":0.42,\
         \\"sensitivity\":true}")
        (renderReplyU (RUChoice (Fire (mkAffId 3) []) 0.5 3.25 0.42 True))
  , testCase "process row: the driver answers a latent@1 handshake" $ do
      exe <- fromMaybe "proplang-govhost" <$> lookupEnv "GOVHOST_EXE"
      (_, out, _) <- readProcessWithExitCode exe [] (latentHello ++ "\n")
      case lines out of
        (l : _) -> assertEqual "v2 handshake reply"
          "{\"ok\":true,\"proto\":1,\"models\":1241,\
          \\"namespace_bits\":1,\"ulatents\":3}" l
        []      -> assertFailure "no reply line"
  ]
