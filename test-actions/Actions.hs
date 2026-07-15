{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

-- | test-actions/Actions.hs — step 5's increment oracle (AGENT_PLAN §7
-- step 5: ACTIONS BECOME FEATURES; actions-author-pack Parts I–II).
-- Drafted after the sitting pre-ruled D-a1..D-a6 (Part II §8), under
-- the standing pacing order; nothing binds before the tag.
--
-- THE STEP: an action is an assignment of values to the names the
-- agent controls. `Menu = [(Name, Grid)]` (a synonym); an action is a
-- FULL assignment over the menu (ruling D-a1); `wait` = every action
-- name at the FIRST point of its grid (§5c) — the HEAD of the option
-- space BY CONSTRUCTION, so CL-3's first-listed-wins hands ties to
-- inaction with zero new rules. The five action types, the echo path,
-- the Rung machinery, and THE SENTINEL (the membrane's fabricated
-- internal option — not the deliberation verbs, which live until step
-- 9) are deleted. Actions do NOT enter the feature stream here (step
-- 6); RIDER 2's negative obligation holds: NO row below prices an
-- assignment or a writable-name mention.
--
-- WAIT AT FULL STRENGTH (the sitting's order): first-points-not-zero
-- kills the dormancy conflation STRUCTURALLY — wait is a POSITION in
-- a declared order, never a magnitude — which is §5c's whole content
-- in one fixture (g1/g2's first-point-7 rows below).
--
-- THE REPLACEMENT-SURFACE FORM (this step's protocol note, pack Part
-- III): unlike steps 1–4 the new Membrane surface REPLACES types, so
-- this suite is COMPILE-red against the pre-freeze src — demonstrated
-- to be exactly the missing surface (the compile-red-fixture clause's
-- proof), type-correct and 100% SAT against the prototype overlay
-- (`scratchpad/step5/proto`); the runtime-red run under stanza flags
-- lands at Phase B when the delegated edits flip the surface to
-- stubs, in the same signature that re-opens test-membrane.
--
-- GATE PROVENANCE (E-a1 + E-a2, executed 2026-07-16 BEFORE any row
-- froze): the rebuilt membrane vs the shipped route, two-route from
-- birth — ZERO diff over 2,958 lines (620 tick rows: choices,
-- predictives, entropies, losses, all hex; plus both 1,169-point
-- final posteriors). The sentinel's death is behavior-neutral
-- MEASURED; the TIE row's CL-3 continuity is MEASURED at a genuine
-- 5/5/3 tie; the D-a2 one-name B-world port is exact (adoption at
-- t=10 bit-identical). == and exact structural equality gate every
-- row below; no tolerance is owed anywhere except the re-homed
-- ladder price pin, which keeps its own frozen 1e-12.
--
-- THE RE-HOMED LADDER PINS (g3): test-ladder retires at this freeze
-- with its pins LISTED (pack Part I §3, the step-4 clause's first
-- scheduled application); the VThinkK price pin and the verb/worker
-- identity pins re-home here as COPIES of the retiring fixture's
-- exact expressions (test-ladder/fixture/Sayable.hs:42-53 the
-- Dir/stakes/dirs data, :169-176 priceSentence, :185-213 the
-- verb/vt/worker rows — R-D20-i, grep-reviewable) until step 9
-- retires the constructor itself. Test names are ASCII-only.
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)), toList)
import Data.Maybe (fromMaybe)
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief (Belief, Bits (..), Evidence (Saw), cond, uniform)
import PropLang.Enumerate (Obs, emit, enumerateSentences, fragFull,
                           sentenceAgent, thetaSpace)
import PropLang.Eval (Vals (..), evalx, mkEnv, vThinkK)
import PropLang.Membrane (Pilot (..), PureWorld (..), TickTrace (..),
                          menuAssignments, runMembrane)
import PropLang.Syntax (Args (..), B, Expr (..), Idx (..), K,
                        StdName (..), Util, bits, mkGrid, mkUtil)

import Streams (drift400, shifted160)

main :: IO ()
main = defaultMain $ testGroup "actions — an action is an assignment (step 5)"
  [ g1Options
  , g2Tick
  , g3LadderPins
  ]

lg :: Double -> Double
lg = logBase 2

-- ---------------------------------------------------------------------
-- g1: the option space (menuAssignments' contract)
-- ---------------------------------------------------------------------

g1Options :: TestTree
g1Options = testGroup "g1 the option space: full assignments, wait at the head"
  [ testCase "Cartesian product in declaration order; the head IS wait" $ do
      let menu = [ ("a", mkGrid "ga" (1 :| [2]))
                 , ("b", mkGrid "gb" (10 :| [20])) ]
      toList (menuAssignments menu)
        @?= [ [("a", 1), ("b", 10)], [("a", 1), ("b", 20)]
            , [("a", 2), ("b", 10)], [("a", 2), ("b", 20)] ]
  , testCase "the empty menu's sole option is the empty assignment" $
      toList (menuAssignments []) @?= [[]]
  , testCase "wait is a POSITION in a declared order, never a magnitude" $ do
      -- first-points-not-zero: the dormancy conflation is dead
      -- structurally (S5c's whole content in one fixture)
      let menu = [("lever", mkGrid "ea2" (7 :| [1, 9]))]
      case menuAssignments menu of
        w :| _ -> w @?= [("lever", 7)]
  ]

-- ---------------------------------------------------------------------
-- g2: the tick (behavioral; goldens from E-a1's two-route transcript)
-- ---------------------------------------------------------------------

-- the prediction-only world shape (the frozen parity worlds', ported)
predW :: PureWorld (Int, [Obs])
predW = PureWorld
  { wFeats    = \(t, _) -> [("t", fromIntegral t)]
  , wEvidence = \(_, ys) -> case ys of { y : _ -> Just y; [] -> Nothing }
  , wMenu     = const []
  , wStep     = \(t, ys) _ -> (t + 1, drop 1 ys)
  }

g2Tick :: TestTree
g2Tick = testGroup "g2 the tick: ties, wait, totality without the sentinel"
  [ testCase "THE TIE ROW: a genuine EU tie picks the first-listed, every tick (CL-3, measured continuity)" $ do
      -- utilities 5/5/3 independent of y — the E-a1 tie world; the
      -- shipped route picked its first-listed counterpart on every
      -- tick (ea1-diff empty), and this row pins the ported half
      let tieMenu = [("lever", mkGrid "tie" (10 :| [20, 30]))]
          utilTie = mkUtil $ \asg (_ :: Obs) ->
            case lookup "lever" asg of
              Just 10 -> 5.0
              Just 20 -> 5.0
              Just 30 -> 3.0
              _       -> error "tie fixture: off-menu assignment"
          ag0 = sentenceAgent (enumerateSentences fragFull)
      case runMembrane predW { wMenu = const tieMenu }
             (PilotEU utilTie) 20 (0, shifted160) ag0 of
        Nothing -> assertFailure "tie world: impossible evidence"
        Just (_, trs) ->
          map ttAct trs @?= replicate 20 [("lever", 10)]
  , testCase "an all-tied EU hands the tie to wait (no new rule)" $ do
      let menu = [("lever", mkGrid "ea2" (7 :| [1, 9]))]
          constU = mkUtil (\_ (_ :: Obs) -> 1.0)
          ag0 = sentenceAgent (enumerateSentences fragFull)
      case runMembrane predW { wMenu = const menu }
             (PilotEU constU) 3 (0, shifted160) ag0 of
        Nothing -> assertFailure "tied world: impossible evidence"
        Just (_, trs) -> map ttAct trs @?= replicate 3 [("lever", 7)]
  , testCase "PilotIdle takes wait every tick (the head, by construction)" $ do
      let menu = [("lever", mkGrid "ea2" (7 :| [1, 9]))]
          ag0 = sentenceAgent (enumerateSentences fragFull)
      case runMembrane predW { wMenu = const menu }
             PilotIdle 3 (0, shifted160) ag0 of
        Nothing -> assertFailure "idle world: impossible evidence"
        Just (_, trs) -> map ttAct trs @?= replicate 3 [("lever", 7)]
  , testCase "the menuless world runs: totality without the sentinel" $ do
      -- zero writable names: the sole option is the empty assignment;
      -- nothing fabricated remains to make the option space nonempty
      let ag0 = sentenceAgent (enumerateSentences fragFull)
      case runMembrane predW PilotIdle 10 (0, drift400) ag0 of
        Nothing -> assertFailure "menuless world: impossible evidence"
        Just (_, trs) -> map ttAct trs @?= replicate 10 []
  ]

-- ---------------------------------------------------------------------
-- g3: the re-homed ladder pins (COPIES of the retiring fixture's
-- exact expressions; provenance in the header)
-- ---------------------------------------------------------------------

-- COPY test-ladder/fixture/Sayable.hs:42-53
data Dir = DirL | DirR
  deriving (Eq, Show)

stakes :: Util Dir Double
stakes = mkUtil $ \a th ->
  let v = 2 * th - 1 in case a of DirR -> v; DirL -> negate v

dirs :: NonEmpty Dir
dirs = DirL :| [DirR]

-- COPY test-ladder/fixture/Sayable.hs:116-118
condBatch :: Belief Double -> [Obs] -> Belief Double
condBatch = foldl' (\bb y ->
  fromMaybe (error "impossible evidence in batch") (cond bb (Saw emit y)))

-- COPY test-ladder/fixture/Sayable.hs:169-176 (the canonical
-- eight-Var VThinkK sentence for the price pin)
priceSentence :: Expr '[ Int, B Double, K Double Obs, [Obs]
                       , Util Dir Double, NonEmpty Dir, Int, Double ] Double
priceSentence =
  Call VThinkK (Var Z :* Var (S Z) :* Var (S (S Z)) :* Var (S (S (S Z)))
              :* Var (S (S (S (S Z)))) :* Var (S (S (S (S (S Z)))))
              :* Var (S (S (S (S (S (S Z))))))
              :* Var (S (S (S (S (S (S (S Z))))))) :* ANil)

-- a short deterministic batch for b3 (the retiring fixture used
-- buffer36's first three; the VALUES are irrelevant to the identity
-- pins — both sides of each == receive the same belief)
b3Batch :: [Obs]
b3Batch = [1, 0, 1]

g3LadderPins :: TestTree
g3LadderPins = testGroup "g3 the re-homed ladder pins (until step 9 retires the name)"
  [ testCase "price: Call VThinkK = node + lg 6 + eight Var mentions (Sayable.hs:205, the step-3 re-priced form)" $
      assertBool "price pin (1e-12, the fixture's own gate)"
        (abs (unBits (bits priceSentence)
              - (lg 19 + lg 6 + 8 * (lg 19 + lg 8))) <= 1e-12)
  , testCase "identity: the verb at depth 1 == the frozen VThink verb" $
      assertBool "verb@1 == VThink over both beliefs, all four prices"
        (all (\(b, p) -> verb (1 :: Int) b 3 p == vt b 3 p)
             [ (b, p) | b <- [u0, b3], p <- [0.3, 0.05, 0.005, 0] ])
  , testCase "identity: the verb == the exported worker at depths 1..3" $
      assertBool "verb k == vThinkK k, k in 1..3"
        (all (\k -> verb k b3 3 0.05
                      == vThinkK k b3 emit ([0, 1] :: [Obs])
                                 stakes dirs 3 0.05)
             [1, 2, 3])
  ]
  where
    unBits (Bits x) = x
    u0 = uniform thetaSpace
    b3 = condBatch u0 b3Batch
    -- COPY test-ladder/fixture/Sayable.hs:185-201 (verb and vt)
    verb k b n p =
      evalx (Call VThinkK (Var Z :* Var (S Z) :* Var (S (S Z))
                         :* Var (S (S (S Z))) :* Var (S (S (S (S Z))))
                         :* Var (S (S (S (S (S Z)))))
                         :* Var (S (S (S (S (S (S Z))))))
                         :* Var (S (S (S (S (S (S (S Z)))))))
                         :* ANil))
            (mkEnv [] (k :. b :. emit :. ([0, 1] :: [Obs]) :. stakes
                         :. dirs :. n :. p :. VNil))
    vt b n p =
      evalx (Call VThink (Var Z :* Var (S Z) :* Var (S (S Z))
                        :* Var (S (S (S Z))) :* Var (S (S (S (S Z))))
                        :* Var (S (S (S (S (S Z)))))
                        :* Var (S (S (S (S (S (S Z)))))) :* ANil))
            (mkEnv [] (b :. emit :. ([0, 1] :: [Obs]) :. stakes :. dirs
                         :. n :. p :. VNil))
