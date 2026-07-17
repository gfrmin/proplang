{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

-- | The membrane increment's oracle (MEMBRANE_PLAN Task 1; interface.md
-- §1–§3, §5 with §8's tests A, B, C and E's slot-grid row). Authored
-- runtime-red against the type-surface stubs, before any
-- implementation, per the canonized increment protocol; on the author's
-- Task 2 signature this file is as frozen as test/.
--
-- Anchor policy: group 1 (parity) reuses the FROZEN anchors — the
-- membrane re-expresses the frozen worlds and must reproduce
-- test/Anchors.hs values under test/Anchors.hs tolerances, plus one
-- bit-for-bit identity (Double ==) between the membrane fold and a
-- verbatim replica of the frozen accumulation. New-world tolerances
-- are the E12 conventions: cross-path comparisons 1e-9 relative in the
-- CL-4 shape, closed-form pins 1e-12, price pins 1e-12 absolute.
--
-- Recorded scope limits (visible for the freeze review):
--
-- * EVIDENCE routes through the frozen 'observe' with the explained
--   name's readings supplied by the world ('wEvidence'); declaring and
--   PRICING the explained name inside the namespace is future scope —
--   ruling M5 scopes the priced namespace to Get-mentionable names,
--   and no approved group prices an evidence-name declaration.
-- * A world's namespace is DECLARED for the episode; a dormant sensor
--   (test A) is a declared name whose readings have not yet appeared,
--   so its appearance changes no price mid-episode. Mid-episode
--   namespace growth (M1's re-weighting exercised within one run) is
--   future scope; M1 is pinned here ACROSS worlds (group 6).
-- * Menu order convention: external instantiations in publication
--   order, then the internal acts — a world's tie-break precedence
--   (CL-3 first-listed-wins) is its publication order.
--
-- Fixture provenance: every stream literal below is the output of
-- test-membrane/gen_fixtures.py (seeds inline there), which also runs
-- the pre-freeze sanity simulation proving each discriminator
-- discriminates BOTH ways (the ExpFam group-6 lesson): the
-- self-signature world's MAP is the last_action sentence at posterior
-- 0.947 while the exogenous control's MAP is the t-changepoint at
-- 0.627 mentioning no echo name; the dormant sentence rides at its
-- prior ratio to 1.4e-15 until its sensor speaks, then lands MAP at
-- 0.432 from a 1.3e-4 prior; the grown affordance's EU clears the
-- incumbent by 0.34 the tick it appears.
--
-- THE STEP-3 PORT (delegated freeze edit, sentence-author-pack.md
-- SS20.3/SS25; the delegation recorded in the freeze commit): the
-- ACTION rows stay for step 5 — their agent constructions ride the
-- SENTENCE ROUTE (enumerateSentences / enumerateSentencesIn under
-- sentenceAgent; Model/Terminal died at the step-3 boundary). The
-- MODEL-FRAGMENT group (r0 group 6: renders/dls/order, the 1241/1529
-- counts, M1) RETIRED in favor of the step-3 oracle's g1 ports (they
-- were degeneracy pins by another name — the pack SS2 ruling). MAP
-- identity rows follow ruling D2: old render strings survive only as
-- provenance labels in comments; the pinned renders are the FRESH
-- sentence goldens, byte-copied from test-sentence/Sentence.hs
-- (frozen at the same signature; R-D20-i). Every quantity anchor
-- (losses, probes, posteriors, prior ratios) is representation-
-- independent and UNCHANGED. Rows touching the ported constructions
-- are runtime-red until the step-3 implementation lands — the
-- increment discipline; the namespace-pricing, slot-pricing, M5, and
-- deletion/grep rows never touch the doomed names and stay green.
--
-- THE STEP-5 PORT (delegated freeze edit, actions-author-pack.md
-- SS13-SS14; the delegation = the author's approval of the
-- replacement-surface form, 2026-07-16): ACTIONS BECOME FEATURES.
-- The action rows ride the Menu/assignment surface (rulings D-a1
-- full assignments, D-a2 one-name B-world); every quantity anchor is
-- UNCHANGED and the port was measured behavior-neutral BEFORE this
-- edit froze (E-a1: zero diff over 2,958 two-route lines, incl. the
-- tie row). The echo rows and the M5 guardian RETIRED (their
-- subjects died; the guardian's safety argument: M5 is repealed only
-- at 7, and RIDER 2's no-action-pricing obligation is itself the
-- guard through the interregnum). g4Self's action rows are
-- RETIRE-UNTIL-6 (the self-signature deliverable returns when
-- actions enter the feature stream; the step-6 opening checklist
-- carries the return row — scheduled, not remembered). The three
-- ablation rows are DISCHARGED-PERMANENT with their fixtures. Rows
-- touching the ported constructions are runtime-red until the step-5
-- implementation lands.
module Main (main) where

import Data.List (isInfixOf)
import Data.List.NonEmpty (NonEmpty ((:|)))
import System.Exit (ExitCode (..))
import System.Process (readProcessWithExitCode)
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck (Property, choose, counterexample, forAll,
                              testProperty)

import PropLang.Belief (Bits (Bits), LogProb (LogProb), top)
import PropLang.Enumerate (Hyp (..), Obs, enumerateSentences,
                           enumerateSentencesIn, fragFull, observe,
                           renderExpr, agentMeta, sentenceAgent)
import PropLang.Eval (Features)
import PropLang.Membrane (Pilot (..), PureWorld (..), TickTrace (..),
                          runMembrane)
import PropLang.Syntax (Expr (..), Grid, Idx (..), KnownScope, Name,
                        Namespace, USent (..), bits, bitsIn, mkC, mkGrid,
                        mkNamespace)

import Anchors (t1MapPosterior, t1ProbeRows, t3AgentDrift,
                tolBits, tolProb)
import Streams (drift400, shifted160)

main :: IO ()
main = defaultMain $ testGroup "membrane oracle (Task 1, runtime-red)"
  [ g1Parity, g2Dormant, g3Menu, g5Names
  , g7SlotPrice, g8Rows ]

-- ---------------------------------------------------------------------
-- helpers (tolerance shapes are the frozen E12 conventions)
-- ---------------------------------------------------------------------

ln2 :: Double
ln2 = log 2

lg :: Double -> Double
lg = logBase 2

unBits :: Bits -> Double
unBits (Bits d) = d

assertApprox :: String -> Double -> Double -> Double -> Assertion
assertApprox msg tol expected actual =
  assertBool (msg ++ ": expected " ++ show expected ++ " +- " ++ show tol
                  ++ ", got " ++ show actual)
             (abs (actual - expected) <= tol)

-- the CL-4 relative shape: |lhs - rhs| <= tol * (1 + |rhs|)
assertRel :: String -> Double -> Double -> Double -> Assertion
assertRel msg tol expected actual =
  assertBool (msg ++ ": expected " ++ show expected ++ " (rel " ++ show tol
                  ++ "), got " ++ show actual)
             (abs (actual - expected) <= tol * (1 + abs expected))

traceAt :: [TickTrace] -> Int -> IO TickTrace
traceAt trs t = case [tr | tr <- trs, ttT tr == t] of
  tr : _ -> pure tr
  []     -> assertFailure ("no trace at t=" ++ show t)

runOrFail :: Maybe a -> IO a
runOrFail (Just x) = pure x
runOrFail Nothing  = assertFailure "runMembrane: impossible evidence"

-- MAP program via the frozen route: meta.top -> index -> render
-- (the step-3 port generalizes the element type; the body is untouched)
mapOfAgent :: (a -> String) -> [(Int, Double)] -> [a] -> IO (String, Double)
mapOfAgent rend ranked ms = case ranked of
  (ix, p) : _ -> pure (rend (ms !! ix), p)
  []          -> assertFailure "agentMeta top returned no entries"

-- posterior mass of one model index, through the public diagnostics
massOf :: [(Int, Double)] -> Int -> IO Double
massOf ranked i = case [p | (ix, p) <- ranked, ix == i] of
  p : _ -> pure p
  []    -> assertFailure ("no mass entry for model index " ++ show i)

sub :: String -> String -> Bool
sub needle hay = needle `isInfixOf` hay

-- the sentence render: a hypothesis's face is its emission code
renderHyp :: Hyp -> String
renderHyp = renderExpr . hypEmit

-- FRESH RENDER GOLDENS (ruling D2), BYTE-COPIES of the step-3
-- oracle's t1RenderGolden / t3RenderGolden / t3MoveGolden
-- (test-sentence/Sentence.hs, frozen at the same signature —
-- R-D20-i copy-not-reconstruct, grep-checkable). Provenance labels:
-- the retired anchors these rows pinned at r0 were t1MapProgram
-- (the tau-11 change-point) and t3MapProgram (the rho-index-3 hmm).
t1RenderGoldenM :: String
t1RenderGoldenM = "('code', ('neg', ('/', ('log', ('if', ('>', ('tor', ('var', 0)), ('c', 'k', 0)), ('if', ('>', ('get', 't'), ('c', 'tau', 11)), ('c', 'theta', 0), ('c', 'theta', 8)), ('-', ('c', 'k', 1), ('if', ('>', ('get', 't'), ('c', 'tau', 11)), ('c', 'theta', 0), ('c', 'theta', 8))))), ('log', ('c', 'k', 2)))))"

t3RenderGoldenM :: String
t3RenderGoldenM = "('code', ('neg', ('/', ('log', ('if', ('>', ('tor', ('var', 0)), ('c', 'k', 0)), ('var', 1), ('-', ('c', 'k', 1), ('var', 1)))), ('log', ('c', 'k', 2)))))"

t3MoveGoldenM :: String
t3MoveGoldenM = "('code', ('neg', ('/', ('log', ('+', ('+', ('if', ('call', 'IsEq', ('pos', ('var', 0)), ('pos', ('var', 1))), ('-', ('c', 'k', 1), ('c', 'rho', 3)), ('c', 'k', 0)), ('if', ('call', 'IsEq', ('pos', ('var', 0)), ('if', ('>', ('pos', ('var', 1)), ('c', 'k', 0)), ('-', ('pos', ('var', 1)), ('c', 'k', 1)), ('+', ('pos', ('var', 1)), ('c', 'k', 1)))), ('/', ('c', 'rho', 3), ('c', 'k', 2)), ('c', 'k', 0))), ('if', ('call', 'IsEq', ('pos', ('var', 0)), ('if', ('>', ('c', 'k', 3), ('pos', ('var', 1))), ('+', ('pos', ('var', 1)), ('c', 'k', 1)), ('-', ('pos', ('var', 1)), ('c', 'k', 1)))), ('/', ('c', 'rho', 3), ('c', 'k', 2)), ('c', 'k', 0)))), ('log', ('c', 'k', 2)))))"

-- ---------------------------------------------------------------------
-- worlds: a pure evidence stream behind the membrane
-- ---------------------------------------------------------------------

-- prediction-only world: publishes the tick, reads the stream its
-- state carries, offers nothing (the frozen worlds' shape; M10)
predWorld :: PureWorld (Int, [Obs])
predWorld = PureWorld
  { wFeats    = \(t, _) -> [("t", fromIntegral t)]
  , wEvidence = \(_, ys) -> case ys of { y : _ -> Just y; [] -> Nothing }
  , wMenu     = const []
  , wStep     = \(t, ys) _ -> (t + 1, drop 1 ys)
  }

-- ---------------------------------------------------------------------
-- group 1: membrane parity (T2/M10 — the load-bearing group)
-- ---------------------------------------------------------------------

-- verbatim replica of the frozen accumulation (test/Acceptance.hs
-- stepAgent/runWorld): observe at [("t", t)], negate lp / ln2, foldl'
handLoss :: [Obs] -> Double
handLoss ys = fst (foldl' step (0, sentenceAgent (enumerateSentences fragFull))
                          (zip [0 :: Int ..] ys))
  where
    step (acc, ag) (t, y) =
      case observe [("t", fromIntegral t)] y ag of
        Nothing              -> error ("impossible evidence at t=" ++ show t)
        Just (LogProb lp, a) -> (acc + negate lp / ln2, a)

-- the t1 world's lever, ported (D-a2's discipline): ONE writable
-- name, grid points in the OLD PUBLICATION ORDER (1=predict1,
-- 2=predict0, 3=consult) so CL-3 ties break identically — E-a1's tie
-- row measured exactly this continuity
t1Menu :: [(Name, Grid)]
t1Menu = [("opt", mkGrid "t1opt" (1 :| [2, 3]))]

-- the frozen util1 spoken over the membrane's option space (the whole
-- space, internal acts included — one action space, one valuation)
-- the frozen util1M over assignments (the -2.0 internal arm has no
-- counterpart: the sentinel is dead, and E-a1 measured its removal
-- behavior-neutral — the arm was strictly dominated)
-- RE-DERIVED at the step-8 outcome freeze (R-D22; the same
-- extension over the pinned runs): the utility is a PRICED SENTENCE
-- reading the option through Get "opt" — the assignment is among the
-- features at every evaluation site (the step-6 append; the step-8
-- doctrine). Dispatch: opt=1 -> 2y-1; opt=2 -> 1-2y; opt=3 -> 0.35.
-- (The old host function ERRORED off-menu; a sentence cannot — the
-- pinned runs never leave the menu, so the extension is identical
-- where the goldens live.)
util1M :: USent
util1M = USent
  (If (Gt (Get "opt") (gkM 2.5)) (gkM 0.35)
      (If (Gt (Get "opt") (gkM 1.5))
          (Sub (gkM 1) (Mul (gkM 2) (Var (S Z))))
          (Sub (Mul (gkM 2) (Var (S Z))) (gkM 1))))

gkM :: Double -> Expr env Double
gkM v = case mkC (mkGrid "k" (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "t1 fixture: singleton grid index 0 must construct"

choiceName1 :: Features -> String
choiceName1 asg = case lookup "opt" asg of
  Just 1 -> "predict1"
  Just 2 -> "predict0"
  Just 3 -> "consult"
  _      -> "?"

g1Parity :: TestTree
g1Parity = testGroup "membrane parity: frozen worlds, frozen anchors"
  [ testCase "t3 drift: membrane fold == frozen fold, bit for bit" $ do
      (_, trs) <- runOrFail (runMembrane predWorld
                               PilotIdle 400 (0, drift400)
                               (sentenceAgent (enumerateSentences fragFull)))
      let membLoss = foldl' (+) 0 (map ttLossBits trs)
      assertEqual "cumulative log-loss (bits), exact Double equality"
                  (handLoss drift400) membLoss
  , testCase "t3 drift: membrane loss lands on the frozen anchor" $ do
      (_, trs) <- runOrFail (runMembrane predWorld
                               PilotIdle 400 (0, drift400)
                               (sentenceAgent (enumerateSentences fragFull)))
      assertApprox "t3 agent log-loss" tolBits t3AgentDrift
                   (foldl' (+) 0 (map ttLossBits trs))
  , testCase "t3 drift: MAP program == the fresh sentence goldens" $ do
      (agF, _) <- runOrFail (runMembrane predWorld
                               PilotIdle 400 (0, drift400)
                               (sentenceAgent (enumerateSentences fragFull)))
      -- D2: the identity the r0 anchor (t3MapProgram, the rho-3 hmm)
      -- carried is pinned by the fresh emission AND move goldens
      let msW = enumerateSentences fragFull
      case top (agentMeta agF) (length msW) of
        (ix, _) : _ -> do
          renderHyp (msW !! ix) @?= t3RenderGoldenM
          fmap renderExpr (hypMove (msW !! ix)) @?= Just t3MoveGoldenM
        [] -> assertFailure "agentMeta top returned no entries"
  , testCase "t1 probes: P(y=1), action, meta-entropy at the frozen rows" $ do
      (_, trs) <- runOrFail (runMembrane predWorld { wMenu = const t1Menu }
                               (PilotEU util1M) 160 (0, shifted160)
                               (sentenceAgent (enumerateSentences fragFull)))
      mapM_ (\(t, p1a, act, ha) -> do
               tr <- traceAt trs t
               assertApprox ("P(y=1) at t=" ++ show t) tolProb p1a (ttP1 tr)
               assertApprox ("meta-entropy at t=" ++ show t) tolProb ha
                            (ttEntropy tr)
               choiceName1 (ttAct tr) @?= act)
            t1ProbeRows
  , testCase "t1 end MAP: program (fresh golden, D2) and posterior anchor" $ do
      (agF, _) <- runOrFail (runMembrane predWorld { wMenu = const t1Menu }
                               (PilotEU util1M) 160 (0, shifted160)
                               (sentenceAgent (enumerateSentences fragFull)))
      let msW = enumerateSentences fragFull
      (m, p) <- mapOfAgent renderHyp
                  (top (agentMeta agF) (length msW)) msW
      m @?= t1RenderGoldenM
      assertApprox "t1 MAP posterior" tolProb t1MapPosterior p
  ]

-- ---------------------------------------------------------------------
-- group 2: the dormant sensor (interface.md §8 A)
-- ---------------------------------------------------------------------

nsA :: Namespace
nsA = mkNamespace ("t" :| ["s2"])

s2Grid :: Grid
s2Grid = mkGrid "s2c" (0.5 :| [])

modelsA :: [Hyp]
modelsA = enumerateSentencesIn nsA [("s2", s2Grid)] fragFull

-- s2 exists from tick 40; before that the name is declared but silent
aWorld :: PureWorld Int
aWorld = PureWorld
  { wFeats    = \t -> ("t", fromIntegral t)
                      : [("s2", fromIntegral (s2A !! t)) | t >= 40]
  , wEvidence = \t -> Just (yA !! t)
  , wMenu     = const []
  , wStep     = \t _ -> t + 1
  }

-- index arithmetic of the fragment's enumeration order: 9 constants,
-- 8 walks, 16*72 t-guards, then the s2-guard block; within a guard
-- family, threshold outermost, then (k1, k2) with k2 skipping k1
s2GuardIx :: Int -> Int -> Int
s2GuardIx k1 k2 = 9 + 8 + 16 * 72 + k1 * 8 + (if k2 > k1 then k2 - 1 else k2)

g2Dormant :: TestTree
g2Dormant = testGroup "dormant sensor (A): declared, silent, then heard"
  [ testCase "pre-appearance: the dormant sentence rides at its prior ratio" $ do
      (ag, _) <- runOrFail (runMembrane aWorld PilotIdle 39 0
                              (sentenceAgent modelsA))
      let ranked = top (agentMeta ag) (length modelsA)
      mapM_ (\(k1, k2) -> do
               let gIx = s2GuardIx k1 k2
               if length modelsA <= gIx
                 then assertFailure "enumeration lacks the s2-guard block"
                 else do
                   mg <- massOf ranked gIx
                   mt <- massOf ranked k2
                   let dlG = unBits (hypBits (modelsA !! gIx))
                       dlT = unBits (hypBits (modelsA !! k2))
                   assertRel ("posterior ratio, pair " ++ show (k1, k2))
                             1e-9 (2 ** (dlT - dlG)) (mg / mt))
            [(7, 2), (0, 5), (4, 8)]
  , testCase "post-appearance: evidence flows, MAP mentions the sensor" $ do
      (agF, _) <- runOrFail (runMembrane aWorld PilotIdle 120 0
                               (sentenceAgent modelsA))
      (m, p) <- mapOfAgent renderHyp
                  (top (agentMeta agF) (length modelsA)) modelsA
      assertBool ("MAP mentions ('get', 's2'): " ++ m)
                 (sub "('get', 's2')" m)
      assertBool ("MAP posterior >= 0.2, got " ++ show p) (p >= 0.2)
  , testCase "the winning sentence started below a thousandth of the mass" $ do
      (agF, _) <- runOrFail (runMembrane aWorld PilotIdle 120 0
                               (sentenceAgent modelsA))
      let rankedEnd = top (agentMeta agF) (length modelsA)
          ranked0 = top (agentMeta (sentenceAgent modelsA)) (length modelsA)
      case rankedEnd of
        (ix, _) : _ -> do
          p0 <- massOf ranked0 ix
          assertBool ("prior mass of the eventual MAP <= 1e-3, got "
                      ++ show p0) (p0 <= 1e-3)
        [] -> assertFailure "empty posterior ranking"
  ]

-- ---------------------------------------------------------------------
-- group 3: the growing menu (interface.md §8 B)
-- ---------------------------------------------------------------------

speedGrid :: Grid
speedGrid = mkGrid "speed" (0.2 :| [0.4, 0.6, 0.8])

-- the B lever, ported per ruling D-a2: ONE name; hold IS
-- move-at-its-first-point (the world says what inaction looks like
-- on its own lever, S5c verbatim); menu growth = the per-tick menu's
-- grid gaining points at t=10 (a world's own declaration; no pricing
-- implications until 6/7)
bMenuAt :: Int -> [(Name, Grid)]
bMenuAt t = if t >= 10
              then [("move", mkGrid "bmove" (0 :| [0.2, 0.4, 0.6, 0.8]))]
              else [("move", mkGrid "bmove" (0 :| []))]

-- the affordance "move" is published from tick 10; evidence is twenty
-- ones over the FROZEN fragment (menu growth is not namespace growth —
-- ruling M5)
bWorld :: PureWorld Int
bWorld = PureWorld
  { wFeats    = \t -> [("t", fromIntegral t)]
  , wEvidence = const (Just 1)
  , wMenu     = bMenuAt
  , wStep     = \t _ -> t + 1
  }

-- RE-DERIVED at the step-8 outcome freeze (R-D22): move=0 -> the
-- hold pay; move=v>0 -> v*(2y-1) = Get "move" * (2y-1). Same
-- extension over the pinned runs (the grids' points are 0, 0.8).
utilB :: Double -> USent
utilB holdPay = USent
  (If (Gt (Get "move") (gkM 0))
      (Mul (Get "move") (Sub (Mul (gkM 2) (Var (S Z))) (gkM 1)))
      (gkM holdPay))

g3Menu :: TestTree
g3Menu = testGroup "growing menu (B): adopted iff expected utility says so"
  [ testCase "B1: the new affordance is adopted the tick it appears" $ do
      (_, trs) <- runOrFail (runMembrane bWorld
                               (PilotEU (utilB 0.2)) 20 0
                               (sentenceAgent (enumerateSentences fragFull)))
      -- the E-a1 goldens: hold (the first point) for ten ticks, then
      -- move at 0.8 from the tick the grid grows
      map ttAct trs @?=
        (replicate 10 [("move", 0)]
         ++ replicate 10 [("move", 0.8)])
  , testCase "B2: a dominated affordance is never adopted (same call)" $ do
      (_, trs) <- runOrFail (runMembrane bWorld
                               (PilotEU (utilB 0.9)) 20 0
                               (sentenceAgent (enumerateSentences fragFull)))
      map ttAct trs @?= replicate 20 [("move", 0)]
  -- THE M5 GUARDIAN RETIRED at the step-5 freeze (its safety
  -- argument, stated so no future reader reconstructs it: the
  -- guardian's subject — slot-priced action vocabulary vs
  -- Get-mentionable names — becomes unobservable at 5; M5 itself is
  -- repealed only at 7; and the interregnum is safe precisely
  -- because RIDER 2's negative obligation — no action pricing
  -- anywhere in steps 5-6 — is itself the guard until the repeal
  -- lands with its invariance fixture. Law-without-tripwire for two
  -- steps is fine only because the door the law guards does not
  -- exist yet.)
  ]

-- ---------------------------------------------------------------------
-- group 4 (the self-signature, interface.md SS8 C) RETIRE-UNTIL-6
-- (ruling D-a6, the step-5 freeze): the deliverable NEEDS the action
-- visible to the hypotheses, and actions enter the feature stream at
-- STEP 6 — the echo that carried them died here, and a port now
-- would pin vacuous behavior (the confound 6b exists to falsify).
-- THE RETURN IS SCHEDULED, NOT REMEMBERED: the step-6 opening
-- checklist carries the g4Self-return row (AGENT_PLAN SS7 step 6, the
-- delegated edit at this freeze) — a deferred obligation living only
-- in this comment would be the R6 disease wearing a new hat (the
-- author's words). The retired world's fixtures (the yC/zC streams,
-- the threshold pilot, the echoed world, its 1529-sentence space)
-- are reconstructible byte-wise from this file's history (the step-3
-- port carries them; gen_fixtures.py regenerates and
-- sanity-simulates them).
-- ---------------------------------------------------------------------

-- the 3-name pricing namespace (formerly the C-world's; kept beside
-- its surviving consumer — the g5 bitsIn row. The "last_action" NAME
-- is historical fixture data, ruling D-a5: worlds may name features
-- anything, and a 3-name world's arithmetic is name-blind.)
nsC :: Namespace
nsC = mkNamespace ("t" :| ["z", "last_action"])

-- ---------------------------------------------------------------------
-- group 5: CL-6 and the namespace pricer (T1/M1 at the policy sort)
-- ---------------------------------------------------------------------

ns0 :: Namespace
ns0 = mkNamespace ("t" :| [])

eqPriced :: KnownScope env => Expr env t -> Bool
eqPriced e = unBits (bits e) == unBits (bitsIn ns0 e)

propNsPrice :: Property
propNsPrice =
  forAll (choose (2, 12 :: Int)) $ \k ->
    let ns = mkNamespace ("t" :| ["n" ++ show i | i <- [2 .. k]])
        got = unBits (bitsIn ns (Get "t" :: Expr '[] Double))
        want = lg 19 + lg (fromIntegral k)
    in counterexample ("k=" ++ show k ++ " got " ++ show got)
         (abs (got - want) <= 1e-12)

g5Names :: TestTree
g5Names = testGroup "one namespace: echo names ordinary, prices per world"
  [ testCase "a 3-name world prices Get at lg 19 + lg 3" $
      assertApprox "bitsIn nsC (Get last_action)" 1e-12 (lg 19 + lg 3)
        (unBits (bitsIn nsC (Get "last_action" :: Expr '[] Double)))
  , testCase "a 2-name world prices Get at lg 19 + 1" $
      assertApprox "bitsIn nsA (Get s2)" 1e-12 (lg 19 + 1)
        (unBits (bitsIn nsA (Get "s2" :: Expr '[] Double)))
  , testProperty "k published names charge lg k at every mention" propNsPrice
  , testCase "the frozen registry is the singleton special case (==)" $ do
      assertBool "Get" (eqPriced (Get "t" :: Expr '[] Double))
      assertBool "Gt" (eqPriced (Gt (Get "t") (Get "t") :: Expr '[] Bool))
      assertBool "If"
        (eqPriced (If (Gt (Get "t") (Get "t")) (Get "t") (Get "t")
                     :: Expr '[] Double))
      assertBool "Argmax"
        (eqPriced (Argmax (Var Z) (Get "t")
                     :: Expr '[NonEmpty Double] Double))
  -- (the echoFeatures and lastActionCode rows RETIRED at the step-5
  -- freeze with their subjects: the echo path was the agent echoing
  -- ITSELF, and it is gone whole. What survives is world-side: a
  -- world remains free, under CL-1-at-the-echo, to measure the
  -- agent's latency from outside the membrane and publish it as an
  -- ordinary feature — the capability that ruling protected was
  -- never the self-report.)
  ]

-- ---------------------------------------------------------------------
-- group 6 (the model fragment under a namespace) RETIRED at the
-- step-3 freeze in favor of the step-3 oracle's g1 ports (the pack
-- SS2 ruling: they were degeneracy pins by another name): the
-- renders/dls/order identity died with the Model representation; the
-- 1241/1529 counts, the namespace-relative charges, and M1's
-- re-pricing are pinned in test-sentence/ g1 through the sentence
-- route, from the declared production table.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- group 7: slot instantiation is grid-constant utterance (ruling M4)
-- ---------------------------------------------------------------------

g7SlotPrice :: TestTree
g7SlotPrice = testGroup "slot pricing: the charge sits at the C node"
  [ testCase "naming a slot point costs the node plus the slot's grid" $
      case mkC speedGrid 3 of
        Nothing -> assertFailure "mkC refused an on-grid index"
        Just c  -> assertApprox "bits of a speed constant" 1e-12
                     (lg 19 + lg 4) (unBits (bits (c :: Expr '[] Double)))
  , testCase "a finer slot grid charges exactly its extra bit" $ do
      let fine = mkGrid "speed8" (0.1 :| [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8])
      case (mkC speedGrid 0, mkC fine 0) of
        (Just c4, Just c8) ->
          assertApprox "lg 8 - lg 4" 1e-12 1
            (unBits (bits (c8 :: Expr '[] Double))
             - unBits (bits (c4 :: Expr '[] Double)))
        _ -> assertFailure "mkC refused an on-grid index"
  ]

-- ---------------------------------------------------------------------
-- group 8: deletion rows and the grep clauses (Q4/M6/M7)
-- ---------------------------------------------------------------------

shellRow :: String -> [String] -> Assertion
shellRow cmd args = do
  (code, out, err) <- readProcessWithExitCode cmd args ""
  case code of
    ExitSuccess   -> pure ()
    ExitFailure _ -> assertFailure (cmd ++ " " ++ unwords args
                                    ++ ":\n" ++ out ++ err)

srcFiles :: [String]
srcFiles = map ("src/PropLang/" ++)
  ["Belief.hs", "Syntax.hs", "Eval.hs", "Enumerate.hs", "Host.hs",
   "Membrane.hs"]

g8Rows :: TestTree
g8Rows = testGroup "deletion rows and grep clauses"
  -- (the slot-grid, affordance, and echo ablation rows are
  -- DISCHARGED-PERMANENT at the step-5 freeze, with their fixtures
  -- and their runner: the deletions they proved possible became the
  -- deletions that happened — three more instances of the category,
  -- after UseBern and the Rung half of UseLadder.)
  [ testCase "no subscription machinery anywhere in src (S8 A grep)" $
      shellRow "python3" (["audit/strip_comments.py", "--forbidden",
                           "test-membrane/no-subscription.txt"] ++ srcFiles)
  , testCase "the membrane is pure: no IO token (gate-3 mirror)" $
      shellRow "python3" ["audit/strip_comments.py", "--word", "IO",
                          "src/PropLang/Membrane.hs"]
  , testCase "no forbidden tokens in the new module (gate-4 mirror)" $
      -- gate 4's frozen scan names five files, so a new src module
      -- would escape the frozen semantic list entirely; this row
      -- closes that hole with the SAME frozen list, read-only
      shellRow "python3" ["audit/strip_comments.py", "--forbidden",
                          "audit/forbidden.txt",
                          "src/PropLang/Membrane.hs"]
  ]

-- ---------------------------------------------------------------------
-- fixtures (generated + sanity-simulated by test-membrane/gen_fixtures.py)
-- ---------------------------------------------------------------------

-- world A sensor readings, valid from tick 40 (rng seed 101)
s2A :: [Int]
s2A =
  [ 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0
  , 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0
  , 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1
  , 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0
  , 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1
  , 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1
  ]

-- world A explained readings: fair coin to tick 39, then 0.85/0.15 on
-- s2 (rng seed 101, same stream as s2A)
yA :: [Obs]
yA =
  [ 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1
  , 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0
  , 1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1
  , 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1
  , 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0
  , 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1
  ]

