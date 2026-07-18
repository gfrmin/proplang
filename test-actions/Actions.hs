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
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Enumerate (Obs, enumerateSentences, fragFull,
                           sentenceAgent)
import PropLang.Membrane (Pilot (..), PureWorld (..), TickTrace (..),
                          menuAssignments, runMembrane)
import PropLang.Syntax (Expr (..), mkC, mkGrid)

import Streams (drift400, shifted160)

main :: IO ()
main = defaultMain $ testGroup "actions -- an action is an assignment (step 5)"
  [ g1Options
  , g2Tick
  ]
  -- g3LadderPins RETIRED at the step-9 elimination freeze, exactly as
  -- this suite's header foretold ("until step 9 retires the constructor
  -- itself"): VThinkK and VThink are DELETED (D-f1; D-f10 retire-and-
  -- replace). The re-homed ladder price/identity pins had a named home
  -- ONLY until this boundary; the price pin dies with the sort, and the
  -- verb/worker identity is the D-f4 step-10 preposterior re-composition
  -- cluster ('Real a' wall).
  -- [J4 -- SUPERSEDED at reflexive-freeze-r0, 2026-07-18: the 'Real a'
  -- wall was not the obstacle. The verb/worker identity RETURNED at
  -- test-reflexive g3 as (composed sentence == sealed-engine worker):
  -- v_act bit-exact, v_think within the CL-4 gate over a 7.58e-17
  -- pull-through residue. No new production; the primitive stayed in its
  -- grave and the capability walked, exactly as promised below.]
  -- RETIRE-UNTIL-N, UNCONDITIONAL return
  -- (rider 2): step 10 LANDS the deliberation re-composition and the
  -- verb/worker identity pins return against it, or step 10 STALLS
  -- HONESTLY -- the return is not conditional on convenience. Return row
  -- on step 10's opening checklist. The VThinkK sort itself is
  -- DISCHARGED-PERMANENT (the primitive never returns); only the
  -- deliberation CAPABILITY returns, as a fresh composition oracle.

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
          -- RE-DERIVED (step 9, D-f1): the USent wrapper is GONE (UTIL
          -- sort deleted; PilotEU carries the utility RESIDUE directly,
          -- Expr '[Double, Double] Double). The 5/5/3 tie table reads
          -- Get "lever" (a feature; levers 10/20 -> 5, 30 -> 3;
          -- y-independent, so value-identical to the pre-step-9 USent).
          utilTie = If (Gt (Get "lever") (gkA 25))
                       (gkA 3) (gkA 5) :: Expr '[Double, Double] Double
          ag0 = sentenceAgent (enumerateSentences fragFull)
      case runMembrane predW { wMenu = const tieMenu }
             (PilotEU utilTie) 20 (0, shifted160) ag0 of
        Nothing -> assertFailure "tie world: impossible evidence"
        Just (_, trs) ->
          map ttAct trs @?= replicate 20 [("lever", 10)]
  , testCase "an all-tied EU hands the tie to wait (no new rule)" $ do
      let menu = [("lever", mkGrid "ea2" (7 :| [1, 9]))]
          constU = gkA 1 :: Expr '[Double, Double] Double  -- the constant residue
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
-- fixture: priced singleton-grid constants for g2's utility residues
-- (retained from the retired g3 block, which g2 depends on)
-- ---------------------------------------------------------------------

gkA :: Double -> Expr env Double
gkA v = case mkC (mkGrid "k" (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "actions fixture: singleton grid index 0 must construct"
