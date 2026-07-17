{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

-- | test-sentence/Sentence.hs — step 3's increment oracle (AGENT_PLAN
-- §7 step 3: A HYPOTHESIS BECOMES A SENTENCE; sentence-author-pack
-- Parts I–III). Drafted AFTER the sitting ruled D1–D7 (Part II §9,
-- Part III §16), runtime-red against the type-surface stubs
-- (Enumerate.hs, the step-3 surface section) until the implementation
-- lands after the author's freeze.
--
-- THE STEP (ruled D1, option A — clean demolition): 'Model' -> the
-- emission CODE of the real grammar; 'Terminal' -> the declared
-- production table ('FragProd'/'fragWidth'). Delete 'Bern', 'THmm',
-- 'Model', 'Terminal' at this boundary; every falsified anchor PORTS
-- here (the §8 ruling: "PORT the anchors — they ARE the proof").
--
-- LINEAGE (D3 rider 3): the four acceptance tests survive the death of
-- the file that housed them as NAMED brief-§12 deliverables —
--   g1c = test 1, the changing-world deliverable
--   g1d = test 2, the lazy-genius deliverable
--   g1e = test 3, the agent-vs-forgetter deliverable
--   g1f = test 4, the deletion-table deliverable
-- Anchor VALUES are imported from the frozen test/Anchors.hs (which
-- survives this step untouched) — R-D20-i in its strongest form: the
-- frozen artifact itself supplies the numbers; nothing is copied, so
-- nothing can drift.
--
-- MAP IDENTITY (D2 as ruled): position is a FRESH coordinate of the
-- new enumeration (goldens below are new artifacts); continuity is
-- carried by dl + posterior mass + THE COLLISION-PROOF IDENTITY: the
-- MAP component's predictive at frozen checkpoints, captured from the
-- old route pre-demolition (pack §11, corrected §14 — the drift400
-- capture defect was convicted by the author's verification and the
-- corrected PREFIX-REPLAY values are what g1 pins). Old render strings
-- appear only as provenance labels; fresh renders are new goldens.
-- METHOD GROUND (§14): per-hypothesis latent filtering is independent
-- of the mixture weights — 'observe' advances each hypothesis's
-- filtered state on its own and the meta-belief only reweights — so a
-- singleton agent on the MAP hypothesis, prefix-replayed to t, carries
-- exactly the mixture component's filtered state at t.
--
-- THE FILTER PIN (g3 — the optimisation law's first scheduled
-- application, pre-registered at the step-2 freeze): filtering
-- TICK-INDEPENDENT codes at enumeration is legal iff pinned,
-- extensionally, to carry-plus-per-tick-refutation (step-1 ruling 4's
-- charter, code-task2-author-pack.md:394-401). Both orientations EACH
-- CARRY THEIR OWN ROW in the fixture population (the sitting's
-- confirmation, 2026-07-15): a code lawful early and ill-formed late
-- is neither pre-killed nor kept past its kill tick — the filter
-- classifies it untouchable and BOTH routes carry it to its death
-- tick; ill-formed early and lawful late is dead from its first
-- observed tick, in both routes. GATE PROVENANCE (residue measured on
-- the oracle-phase prototype BEFORE any gate froze — the step-2
-- discipline, 2026-07-15): on the SHIPPED population the filter drops
-- nothing, the routes are the same population, and the trajectory row
-- pins ==. On populations where the filter ACTUALLY drops mass, == is
-- REFUTED by measurement — THE MECHANISM, named so a future reader of
-- a 5-ulp residue suspects the normaliser's history and never the
-- filter: the two routes renormalise from DIFFERENT PRIOR
-- POPULATIONS, so identical algebra runs through different division
-- sequences and drifts by ulps (max relative predictive residue
-- 1.2115e-16, max absolute posterior residue 1.4433e-15). GATES RULED
-- AT THE SITTING (2026-07-15), the repaired-CL-4 idiom over the
-- measured floors: 1e-14 relative on the predictive, 1e-13 absolute
-- per posterior point — the pre-ruling's own else-branch firing as
-- designed (== was conditional on bit-identity reproducing; it failed
-- for the structural reason above), and the defect scale the pin
-- exists to catch sits twelve orders above the gate.
--
-- D8, RULED AT THE SITTING (2026-07-15): the positive-mass-refuser
-- predictive is CONDITION ON DENOTATION, and the ground is not the
-- builder's "only public-verb-expressible option found" but
-- COHERENCE: a prevision on the world's declared carrier must be
-- total and sum to one — a deficient mixture prices a Dutch book,
-- "the sentence doesn't speak" is not a point of the carrier, and
-- fabricating a likelihood for it is the sentinel's disease.
-- Conditioning on denotation is ordinary Bayes on the one event the
-- language can state, and it satisfies the tower property against
-- step-1 ruling 4: today's renormalised predictive equals the
-- expectation of tomorrow's post-refutation posterior — the semantics
-- ANTICIPATES the refutation that arrival will execute. Two
-- precisions frozen into the ruling: (1) the conditioning is A READ,
-- NOT AN UPDATE — the belief state is untouched, the refuser keeps
-- its meta mass, and the renormalisation is local to the predictive
-- query; wiring it as a belief update would be refutation-by-
-- prediction, forbidden — no observation occurred, and deliberation
-- must never destroy beliefs. (2) The per-assignment corollary,
-- frozen now though step 5 first reaches it: push-at-assignment
-- applies the same semantics PER ASSIGNMENT — a sentence refusing
-- under a contemplated assignment is conditioned out of that
-- assignment's predictive and harmed nowhere else; and the refuser's
-- mass is not lost to the agent either way — it is precisely the
-- probability that tomorrow's arrival shrinks the support, which the
-- preposterior machinery already prices as wait-and-see value. No new
-- mechanism, no guard.
--
-- SILENCE NEVER REFUTES (g2 — the code-freeze-r0 obligation row,
-- AGENT_PLAN.md:869-878): a hypothesis is refuted only at ticks where
-- its code's observation channel actually carried an observation. The
-- eval half is frozen (test-code group 7); these are the integration
-- rows.
--
-- Every pinned hex below carries provenance to the artifact it was
-- derived from (R-D20-i); every runtime-red row's asserted quantity
-- has an executed satisfiability-transcript line against the
-- oracle-phase prototype, frozen-side deepseq'd (R-D21 as sharpened).
-- Test names are ASCII-only (the membrane's locale incident).
module Main (main) where

import Data.List.NonEmpty (NonEmpty (..))
import Data.Maybe (fromMaybe)
import Data.Word (Word64)
import GHC.Float (castDoubleToWord64)
import System.Exit (ExitCode (..))
import System.Process (readProcessWithExitCode)
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief (Bits (..), Evidence (..), LogProb (..),
                        Space, cond, entropyBits, is, mkSpace,
                        prob, top, uniform)
import PropLang.Enumerate (Agent, FragProd (..), FragSort (..), Hyp (..),
                           Obs, agentMeta, emit, enumerateSentences,
                           enumerateSentencesIn, filterTickFree, fragFull,
                           fragSortOf, fragWidth, obsSpace, predictive,
                           observe, renderExpr, sentenceAgent, thetaSpace)
import PropLang.Eval (Features, evalx, mkEnv, Vals (..))
import PropLang.Syntax (Args (..), B, Expr (..), Idx (..), K, Name,
                        StdName (..), USent (..), mkC, mkGrid,
                        mkNamespace)

import Anchors
import Streams

main :: IO ()
main = defaultMain $ testGroup "sentence -- a hypothesis becomes a sentence (step 3)"
  [ g1Enumeration
  , g1cChangingWorld
  , g1dLazyGenius
  , g1eForgetterTrap
  , g1fDeletionTable
  , g2SilentTick
  , g3FilterPin
  , g4DeclaredTable
  , g5Ablations
  ]

-- ---------------------------------------------------------------------
-- helpers
-- ---------------------------------------------------------------------

ln2 :: Double
ln2 = log 2

lg :: Double -> Double
lg = logBase 2

assertApprox :: String -> Double -> Double -> Double -> Assertion
assertApprox msg tol expected actual =
  assertBool (msg ++ ": expected " ++ show expected ++ " +- " ++ show tol
                  ++ ", got " ++ show actual)
             (abs (actual - expected) <= tol)

-- bit-exact pin against a hex-pinned double (provenance per use site)
assertHexEq :: String -> Word64 -> Double -> Assertion
assertHexEq msg w actual =
  assertBool (msg ++ ": pinned bits " ++ show w ++ ", got " ++ show actual
                  ++ " (bits " ++ show (castDoubleToWord64 actual) ++ ")")
             (w == castDoubleToWord64 actual)

-- COPIED test/Acceptance.hs:61-65 (lineage: the polling re-entry),
-- the enumeration call re-based on the sentence surface
stepAgentS :: Int -> Obs -> Agent -> (Double, Agent)
stepAgentS t y ag =
  case observe [("t", fromIntegral t)] y ag of
    Nothing              -> error ("impossible evidence at t=" ++ show t)
    Just (LogProb lp, a) -> (negate lp / ln2, a)

-- COPIED test/Acceptance.hs:69-73, [Terminal] -> [FragProd] (D2 part 3)
runWorldS :: [FragProd] -> [Obs] -> (Double, Agent)
runWorldS prods ys =
  foldl' step (0, sentenceAgent (enumerateSentences prods)) (zip [0 ..] ys)
  where
    step (acc, ag) (t, y) = let (b, ag') = stepAgentS t y ag in (acc + b, ag')

-- MAP via the public route: top -> index. POSITION IS FRESH (D2): the
-- index lands in this oracle's own enumeration list, never the old one.
mapOf :: Agent -> (Int, Double)
mapOf ag = case top (agentMeta ag) 1 of
  (ix, p) : _ -> (ix, p)
  []          -> error "agentMeta top returned no entries"

-- the collision-proof identity (§14, corrected): the MAP component's
-- one-tick-ahead predictive AT t via singleton PREFIX-replay
compPredAt :: Hyp -> [Obs] -> Int -> Double
compPredAt h ys t =
  let sgl = foldl' (\ag (tt, y) -> snd (stepAgentS tt y ag))
                   (sentenceAgent [h])
                   (zip [0 ..] (take t ys))
  in prob (predictive [("t", fromIntegral t)] sgl) (is obsSpace 1)

unBitsD :: Bits -> Double
unBitsD (Bits d) = d

-- fixture constants ride in on singleton declared grids (world data
-- with prices; the E-s2 idiom — mkC carries the VALUE, the evaluator
-- reads it with no lookup, so floats are grid-independent)
gk :: Name -> Double -> Expr env Double
gk nm v = case mkC (mkGrid nm (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "sentence fixture: singleton grid index 0 must construct"

-- the bern-code body shape at a theta subtree (COPY of the frozen
-- test-code/Code.hs:252-259 codeBernV body; delta: th is a subtree,
-- not a grid index — same evaluator arithmetic either way, measured
-- bit-exact by E-s2)
bernBodyAt :: Expr (Obs ': Double ': env) Double
           -> Expr (Obs ': Double ': env) Double
bernBodyAt th = Neg (Div (Log p) (Log (gk "k2" 2)))
  where
    y = ToR (Var Z)
    p = If (Gt y (gk "k0" 0)) th (Sub (gk "k1" 1) th)

-- a one-point latent axis for stateless fixture sentences (the type
-- surface's rule: stateless sentences declare a singleton axis)
oneSpace :: Space Double
oneSpace = mkSpace (0.5 :| [])

-- a stateless fixture hypothesis at a declared price
statelessHyp :: Double -> Expr (Obs ': Double ': '[]) Double -> Hyp
statelessHyp dl th = Hyp
  { hypBits  = Bits dl
  , hypSpace = oneSpace
  , hypEmit  = Code oneSpace obsSpace (bernBodyAt th)
  , hypMove  = Nothing
  }

-- a healthy constant-theta fixture (lawful at every tick)
healthyHyp :: Hyp
healthyHyp = statelessHyp 1 (gk "th7" 0.7)

-- ---------------------------------------------------------------------
-- g1 (enumeration): counts and the dl multiset from the DECLARED table
-- ---------------------------------------------------------------------

-- the three family charges, pinned from the frozen artifact (E-s1,
-- pack §5: per-family hex measured FROM the frozen formulas
-- Enumerate.hs:304-313 at the frozen grids; sum pinned at
-- code-task2-author-pack.md:300)
dlConstHex, dlWalkHex, dlGuardHex, dlSumHex :: Word64
dlConstHex = 0x4014ae00d1cfdeb4
dlWalkHex  = 0x4010000000000000
dlGuardHex = 0x4030570068e7ef5a
dlSumHex   = 0x40d27582567af28a

g1Enumeration :: TestTree
g1Enumeration = testGroup "g1 enumeration: the fragment as sentences"
  [ testCase "fragFull enumerates 1169 sentences (t4NFull, frozen)" $
      length (enumerateSentences fragFull) @?= t4NFull
  , testCase "dl multiset: 9 consts + 8 walks + 1152 guards, bit-exact" $ do
      let ws = map (castDoubleToWord64 . unBitsD . hypBits)
                   (enumerateSentences fragFull)
          n w = length (filter (== w) ws)
      n dlConstHex @?= 9
      n dlWalkHex  @?= 8
      n dlGuardHex @?= 1152
      length ws @?= 1169
  , testCase "dl sum, bit-exact (the step-1 pack pin)" $
      assertHexEq "sum of the 1169 charges" dlSumHex
        (foldl' (+) 0 (map (unBitsD . hypBits) (enumerateSentences fragFull)))
  , testCase "declared guards extend the enumeration: 1241 and 1529 (membrane port)" $ do
      -- COPIED test-membrane/Membrane.hs:229-236,357-366 (generators)
      let nsA = mkNamespace ("t" :| ["s2"])
          s2Grid = mkGrid "s2c" (0.5 :| [])
          nsC = mkNamespace ("t" :| ["z", "last_action"])
          zGrid = mkGrid "zc" (0.25 :| [0.5, 0.75])
          laGrid = mkGrid "lac" (0.5 :| [1.5])
      length (enumerateSentencesIn nsA [("s2", s2Grid)] fragFull) @?= 1241
      length (enumerateSentencesIn nsC [("z", zGrid), ("last_action", laGrid)]
                                   fragFull) @?= 1529
  , testCase "namespace re-pricing is order-free (M1 port; position is fresh)" $ do
      -- COPIED formulas test-membrane/Membrane.hs:490-507 (the frozen
      -- dlChange tree; provenance to fd70162 recorded there). Ported
      -- as VALUE-COUNT rows because the new enumeration's order is a
      -- fresh coordinate (D2): under a 2-name world every t-guard costs
      -- frozen + 1; the s2-guard family carries 72 sentences at the
      -- pinned formula value.
      let nsA = mkNamespace ("t" :| ["s2"])
          s2Grid = mkGrid "s2c" (0.5 :| [])
          hsA = map (unBitsD . hypBits)
                    (enumerateSentencesIn nsA [("s2", s2Grid)] fragFull)
          tGuardA = 1 + (1 + ((1 + 1) + (1 + lg 16))) + (1 + lg 9) + (1 + lg 9)
          s2GuardA = 1 + (1 + ((1 + 1) + (1 + 0))) + (1 + lg 9) + (1 + lg 9)
          countNear v = length (filter (\d -> abs (d - v) <= 1e-12) hsA)
      countNear tGuardA @?= 1152
      countNear s2GuardA @?= 72
  ]

-- ---------------------------------------------------------------------
-- g1c: TEST 1 — the changing-world deliverable (brief §12; lineage:
-- test/Acceptance.hs test1, ported; anchors imported from the frozen
-- test/Anchors.hs)
-- ---------------------------------------------------------------------

-- RE-DERIVED at the step-8 outcome freeze (R-D22; THE ACCEPTANCE
-- LINEAGE ROW — brief §12 test 1, the changing-world deliverable).
-- The lineage is the DELIVERABLE's, never the calculator's: the
-- Python oracle's `util(a, y)` (tests_acceptance.py:74-76 — Savage's
-- R(a,s) = u(a(s)) installed as a definition, AGENT_PLAN:43) becomes
-- a PRICED SENTENCE over the residue code. Same extension at the
-- three codes; the timeline, the consult ticks, the MAP identity and
-- every golden below are UNMOVED — which is the deliverable's own
-- claim, now carried by an ontology that does not hide a calculator.
predict1C, predict0C, consultC :: Double
predict1C = 0; predict0C = 1; consultC = 2

act1Name :: Double -> String
act1Name c
  | c == predict1C = "predict1"
  | c == predict0C = "predict0"
  | otherwise      = "consult"

gkS :: Double -> Expr env Double
gkS v = case mkC (mkGrid "k" (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "sentence fixture: singleton grid index 0 must construct"

-- RE-DERIVED from test/Acceptance.hs:104-108 (the lineage's utility):
--   consult (2) -> 0.35; predict1 (0) -> 2y-1; predict0 (1) -> 1-2y
util1 :: USent
util1 = USent
  (If (Gt (Var Z) (gkS 1.5)) (gkS 0.35)
      (If (Gt (Var Z) (gkS 0.5))
          (Sub (gkS 1) (Mul (gkS 2) (Var (S Z))))
          (Sub (Mul (gkS 2) (Var (S Z))) (gkS 1))))

-- RE-DERIVED from test/Acceptance.hs:86-89: the doctrinal argmax-EU
-- program over option CODES; EU's evaluation features are an argument
-- (empty here — this world publishes no feature the utility reads)
argmaxEU :: Real y => Expr '[NonEmpty Double, B y, USent, Features] Double
argmaxEU =
  Argmax (Var Z)
    (Call EU (Var (S (S Z)) :* Var (S (S (S Z)))
              :* Var (S (S (S (S Z)))) :* Var Z :* ANil))

-- COPIED test/Acceptance.hs:111-123, the agent re-based on sentences
runChangingWorld :: ([(Int, Double, Double, Double)], Agent)
runChangingWorld = go 0 (sentenceAgent (enumerateSentences fragFull)) shifted160
  where
    acts = predict1C :| [predict0C, consultC]
    go _ ag [] = ([], ag)
    go t ag (y : ys) =
      let pr = predictive [("t", fromIntegral t)] ag
          p1 = prob pr (is obsSpace 1)
          a  = evalx argmaxEU (mkEnv [] (acts :. pr :. util1
                                          :. ([] :: Features) :. VNil))
          h  = entropyBits (agentMeta ag)
          (_, ag')     = stepAgentS t y ag
          (rows, agF)  = go (t + 1) ag' ys
      in ((t, p1, a, h) : rows, agF)

-- the shifted160 MAP identity (pack §11, capture 2026-07-15): mass and
-- component-predictive hexes captured from the OLD route pre-demolition
t1MassHex :: Word64
t1MassHex = 0x3fe46d1521f5f3cc
t1CompPre, t1CompPost :: Word64
t1CompPre  = 0x3feccccccccccccc   -- P(y=1|t) for t in {0,59,60}
t1CompPost = 0x3fb999999999999b   -- P(y=1|t) for t in {61,159,160}

-- FRESH GOLDEN (new artifact, D2; filled from the oracle-phase
-- prototype run, proto-run 2026-07-15 — the transcript proves this
-- frozen text): the render of the MAP sentence's emission code. The
-- old tau-11 guard (provenance label: t1MapProgram in Anchors) is
-- VISIBLE as the theta subtree — lineage on the artifact's face.
t1RenderGolden :: String
t1RenderGolden = "('code', ('neg', ('/', ('log', ('if', ('>', ('tor', ('var', 0)), ('c', 'k', 0)), ('if', ('>', ('get', 't'), ('c', 'tau', 11)), ('c', 'theta', 0), ('c', 'theta', 8)), ('-', ('c', 'k', 1), ('if', ('>', ('get', 't'), ('c', 'tau', 11)), ('c', 'theta', 0), ('c', 'theta', 8))))), ('log', ('c', 'k', 2)))))"

g1cChangingWorld :: TestTree
g1cChangingWorld = testGroup "g1c test 1: the changing-world deliverable"
  [ testCase "timeline: python assertions + probe rows + consult ticks + entropy" $ do
      let (timeline, _) = runChangingWorld
          actAt = zip [0 :: Int ..] (map (\(_, _, a, _) -> a) timeline)
          between lo hi = [ a | (t, a) <- actAt, lo <= t, t < hi ]
          hs    = map (\(_, _, _, h) -> h) timeline
          hPre  = hs !! 59
          hPost = maximum (take 30 (drop 60 hs))
      assertBool "confident (predict1) for t in [30,60)"
                 (all (== predict1C) (between 30 60))
      assertBool "consults inside t in [60,80)"
                 (consultC `elem` between 60 80)
      assertBool "recovers to predict0 for t in [130,160)"
                 (all (== predict0C) (between 130 160))
      assertBool "entropy disperses (H_post > H_pre + 0.5)"
                 (hPost > hPre + 0.5)
      assertEqual "consult tick set (exact)"
                  t1ConsultTicks [ t | (t, a) <- actAt, a == consultC ]
      assertApprox "H_pre(t=59)" tolProb t1HPre hPre
      assertApprox "H_post max over [60,90)" tolProb t1HPostMax hPost
      mapM_ (\(t, p, a, h) -> do
               let (_, p', a', h') = timeline !! t
               assertApprox ("P(y=1) at t=" ++ show t) tolProb p p'
               assertEqual ("action at t=" ++ show t) a (act1Name a')
               assertApprox ("H at t=" ++ show t) tolProb h h')
            t1ProbeRows
  , testCase "MAP identity: dl + mass + component predictive (collision-proof)" $ do
      let (_, agF) = runChangingWorld
          (ix, p) = mapOf agF
          h = enumerateSentences fragFull !! ix
      assertHexEq "MAP dl (a t-guard sentence)" dlGuardHex (unBitsD (hypBits h))
      assertApprox "MAP posterior vs the Python anchor" tolProb t1MapPosterior p
      assertHexEq "MAP posterior mass (captured pre-demolition)" t1MassHex p
      mapM_ (\t -> assertHexEq ("component P(y=1|t=" ++ show t ++ ")")
                     (if t <= 60 then t1CompPre else t1CompPost)
                     (compPredAt h shifted160 t))
            [0, 59, 60, 61, 159, 160]
      assertEqual "fresh render golden (new artifact)"
                  t1RenderGolden (renderExpr (hypEmit h))
  , testCase "no change-detection machinery in src/ (audit grep, verbatim)" $ do
      (rc, out, err) <- readProcessWithExitCode "python3"
        [ "audit/strip_comments.py", "--forbidden", "audit/forbidden.txt"
        , "src/PropLang/Belief.hs", "src/PropLang/Syntax.hs"
        , "src/PropLang/Eval.hs", "src/PropLang/Enumerate.hs"
        , "src/PropLang/Host.hs" ] ""
      assertEqual ("grep for forbidden mechanisms in src/: " ++ out ++ err)
                  ExitSuccess rc
  ]

-- ---------------------------------------------------------------------
-- g1d: TEST 2 — the lazy-genius deliverable (brief §12; lineage:
-- test/Acceptance.hs test2, VERBATIM port — the deliberation ladder
-- touches no doomed name; only its housing file dies)
-- ---------------------------------------------------------------------

data MetaAct = DoAct | DoThink
  deriving (Eq, Show)

-- RE-DERIVED at the step-8 outcome freeze (R-D22; THE ACCEPTANCE
-- LINEAGE ROW — brief §12 test 2, the lazy-genius deliverable): Dir
-- becomes the residue CODE (L = 0, R = 1, the lineage's own listing
-- order) and the stakes become a PRICED SENTENCE. Same extension at
-- both codes; the tick counts and final acts are UNMOVED.
dirLC, dirRC :: Double
dirLC = 0; dirRC = 1

dirName :: Double -> String
dirName c = if c > 0.5 then "R" else "L"

-- RE-DERIVED from test/Acceptance.hs:187-188: R -> 2*theta-1,
-- L -> 1-2*theta
stakes :: USent
stakes = USent
  (If (Gt (Var Z) (gkS 0.5))
      (Sub (Mul (gkS 2) (Var (S Z))) (gkS 1))
      (Sub (gkS 1) (Mul (gkS 2) (Var (S Z)))))

-- COPIED test/Acceptance.hs:201-217
policyThink :: Expr '[ NonEmpty MetaAct, MetaAct, B Double, K Double Obs
                     , [Obs], USent, NonEmpty Double, Int ] MetaAct
policyThink =
  Argmax (Var Z)
    (If (Call IsEq (Var Z :* Var (S (S Z)) :* ANil))
        (Call VAct (Var (S (S (S Z)))
                 :* Var (S (S (S (S (S (S Z))))))
                 :* Var (S (S (S (S (S (S (S Z)))))))
                 :* ANil))
        (Call VThink (Var (S (S (S Z)))
                   :* Var (S (S (S (S Z))))
                   :* Var (S (S (S (S (S Z)))))
                   :* Var (S (S (S (S (S (S Z))))))
                   :* Var (S (S (S (S (S (S (S Z)))))))
                   :* Var (S (S (S (S (S (S (S (S Z))))))))
                   :* Get "price"
                   :* ANil)))

-- COPIED test/Acceptance.hs:223-239
runDeliberation :: Double -> [Obs] -> (Int, Double)
runDeliberation price = go (0 :: Int) (uniform thetaSpace)
  where
    dirs = dirLC :| [dirRC]
    go ticks b buf =
      let metaacts = DoAct :| [DoThink | not (null buf)]
          batchN   = min 3 (length buf)
          env = mkEnv [("price", price)]
                  (metaacts :. DoAct :. b :. emit :. ([0, 1] :: [Obs])
                    :. stakes :. dirs :. batchN :. VNil)
      in case evalx policyThink env of
           DoAct   -> (ticks, evalx argmaxEU
                                (mkEnv [] (dirs :. b :. stakes
                                           :. ([] :: Features) :. VNil)))
           DoThink -> go (ticks + 1) (condBatch b (take 3 buf)) (drop 3 buf)
    condBatch = foldl' (\bb y ->
      fromMaybe (error "impossible evidence in batch")
                (cond bb (Saw emit y)))

g1dLazyGenius :: TestTree
g1dLazyGenius = testGroup "g1d test 2: the lazy-genius deliverable"
  [ testCase "tick counts and final acts at the four prices (exact)" $ do
      let runs = [ (p, runDeliberation p buffer36) | (p, _, _) <- t2Rows ]
      mapM_ (\((pA, tkA, fA), (_, (tk, f))) -> do
               assertEqual ("thinking ticks at price " ++ show pA) tkA tk
               assertEqual ("final act at price " ++ show pA) fA (dirName f))
            (zip t2Rows runs)
      case map (fst . snd) runs of
        [tHi, tMid, tLo, tNone] ->
          assertBool "t_hi < t_mid < t_lo <= t_none"
                     (tHi < tMid && tMid < tLo && tLo <= tNone)
        other -> assertFailure ("expected 4 runs, got " ++ show (length other))
  ]

-- ---------------------------------------------------------------------
-- g1e: TEST 3 — the agent-vs-forgetter deliverable (brief §12;
-- lineage: test/Acceptance.hs test3, ported)
-- ---------------------------------------------------------------------

-- COPIED test/Acceptance.hs:268-277 (THE TRAP, quarantined here exactly
-- as it was quarantined there; never part of the language)
forgetterLogloss :: Double -> [Obs] -> Double
forgetterLogloss gamma = go 1.0 1.0 0.0
  where
    go _ _ ll [] = ll
    go a b ll (y : ys) =
      let p   = a / (a + b)
          ll' = ll - logBase 2 (if y == 1 then p else 1 - p)
          a'  = gamma * a + fromIntegral y
          b'  = gamma * b + fromIntegral (1 - y)
      in go a' b' ll' ys

-- the drift400 MAP identity (pack §11 + §14 CORRECTED checkpoints:
-- prefix-replay component predictives — the one state-carrying MAP,
-- exactly the case dl+mass cannot fingerprint)
t3MassHex :: Word64
t3MassHex = 0x3fd9aa282d25f732
t3CompHexes :: [(Int, Word64)]
t3CompHexes =
  [ (0,   0x3fe0000000000000)   -- the prior predictive, lawful at t=0
  , (59,  0x3fe6224fd8b10b00)
  , (60,  0x3fe4d05627e6c256)
  , (61,  0x3fe576c8a9a98a5e)
  , (399, 0x3fd6c69b6db19fad)
  , (400, 0x3fd9437c705edf8a)   -- section-11's one true value, relabeled
  ]

-- the walk's emission is the identity-emission code over the latent
-- axis (('var', 1) = the latent context); identical across the eight
-- walks — the RATE lives in the move code, whose golden pins it
t3RenderGolden :: String
t3RenderGolden = "('code', ('neg', ('/', ('log', ('if', ('>', ('tor', ('var', 0)), ('c', 'k', 0)), ('var', 1), ('-', ('c', 'k', 1), ('var', 1)))), ('log', ('c', 'k', 2)))))"

-- filled from the prototype run 2026-07-15; ('c','rho',3) — the
-- inferred drift rate — appears on the artifact's face, three times
-- (the diagonal and the two reflections); ('c','k',3) is the shape
-- grid's n-1 point
t3MoveGolden :: String
t3MoveGolden = "('code', ('neg', ('/', ('log', ('+', ('+', ('if', ('call', 'IsEq', ('pos', ('var', 0)), ('pos', ('var', 1))), ('-', ('c', 'k', 1), ('c', 'rho', 3)), ('c', 'k', 0)), ('if', ('call', 'IsEq', ('pos', ('var', 0)), ('if', ('>', ('pos', ('var', 1)), ('c', 'k', 0)), ('-', ('pos', ('var', 1)), ('c', 'k', 1)), ('+', ('pos', ('var', 1)), ('c', 'k', 1)))), ('/', ('c', 'rho', 3), ('c', 'k', 2)), ('c', 'k', 0))), ('if', ('call', 'IsEq', ('pos', ('var', 0)), ('if', ('>', ('c', 'k', 3), ('pos', ('var', 1))), ('+', ('pos', ('var', 1)), ('c', 'k', 1)), ('-', ('pos', ('var', 1)), ('c', 'k', 1)))), ('/', ('c', 'rho', 3), ('c', 'k', 2)), ('c', 'k', 0)))), ('log', ('c', 'k', 2)))))"

g1eForgetterTrap :: TestTree
g1eForgetterTrap = testGroup "g1e test 3: the agent-vs-forgetter deliverable"
  [ testCase "log-losses: the full forgetter table and the agent (anchors)" $ do
      let (laD, _) = runWorldS fragFull drift400
          (laF, _) = runWorldS fragFull flat400
          fDrift = [ forgetterLogloss g drift400 | (g, _, _) <- t3ForgetterRows ]
          fFlat  = [ forgetterLogloss g flat400  | (g, _, _) <- t3ForgetterRows ]
      mapM_ (\((g, dA, fA), (d, f)) -> do
               assertApprox ("forgetter drift loss, gamma=" ++ show g) tolBits dA d
               assertApprox ("forgetter flat loss, gamma=" ++ show g) tolBits fA f)
            (zip t3ForgetterRows (zip fDrift fFlat))
      assertApprox "agent log-loss, drifting world" tolBits t3AgentDrift laD
      assertApprox "agent log-loss, stationary world" tolBits t3AgentFlat laF
      assertBool "matches/beats the best oracle-tuned forgetter on drift"
                 (laD <= minimum fDrift + 0.02 * minimum fDrift)
      assertBool "matches/beats every forgetter on the stationary world"
                 (laF <= minimum fFlat + 0.02 * minimum fFlat)
  , testCase "MAP identity on drift: dl + mass + prefix-replay predictives" $ do
      let (_, agD) = runWorldS fragFull drift400
          (ix, p) = mapOf agD
          h = enumerateSentences fragFull !! ix
      assertHexEq "MAP dl (a walk sentence; provenance label: t3MapProgram)"
                  dlWalkHex (unBitsD (hypBits h))
      assertHexEq "MAP posterior mass (captured pre-demolition)" t3MassHex p
      mapM_ (\(t, w) -> assertHexEq ("component P(y=1|t=" ++ show t ++ ")")
                          w (compPredAt h drift400 t))
            t3CompHexes
      assertEqual "fresh render golden (new artifact)"
                  t3RenderGolden (renderExpr (hypEmit h))
      assertEqual "fresh move-code golden (the rate is pinned here)"
                  (Just t3MoveGolden) (fmap renderExpr (hypMove h))
  ]

-- ---------------------------------------------------------------------
-- g1f: TEST 4 — the deletion-table deliverable (brief §12; lineage:
-- test/Acceptance.hs test4, ported; [Terminal] lists -> declared
-- production subsets, D2 part 3. Mapping recorded: no-TIf -> drop FIf;
-- no-TGet AND no-TGt -> drop FGuardHead (both kill exactly the guard
-- family — the frozen anchors t4LlNoif == t4LlNoget agree); no-THmm ->
-- drop FWalk; no-TC -> drop FConst; no-TBern (with no walk either, the
-- frozen list) -> drop both MODEL productions.)
-- ---------------------------------------------------------------------

-- COPIED test/Acceptance.hs:316-319, re-based: belief never moves, the
-- clock still advances
frozenLoglossS :: [Obs] -> Double
frozenLoglossS ys =
  let ag0 = sentenceAgent (enumerateSentences fragFull)
  in sum [ fst (stepAgentS t y ag0) | (t, y) <- zip [0 ..] ys ]

-- COPIED test/Acceptance.hs:327-332 (the frozen audit script is
-- untouched by this step; its rows are CPP-level and survive)
ablationRow :: String -> Assertion
ablationRow row = do
  (rc, out, err) <- readProcessWithExitCode "sh" ["audit/ablation.sh", row] ""
  assertEqual ("deletion audit (raises-by-type) row '" ++ row ++ "':\n"
               ++ out ++ err)
              ExitSuccess rc

without :: [FragProd] -> [FragProd]
without doomed = [ p | p <- fragFull, p `notElem` doomed ]

g1fDeletionTable :: TestTree
g1fDeletionTable = testGroup "g1f test 4: the deletion-table deliverable"
  [ testCase "the deletion table over declared production subsets" $ do
      let drift250 = take 250 drift400
          llFrozen = frozenLoglossS shifted160
          (llFull, _)  = runWorldS fragFull shifted160
          (llNoif, _)  = runWorldS (without [FIf]) shifted160
          (llNohead, _) = runWorldS (without [FGuardHead]) shifted160
          (llFullD, _) = runWorldS fragFull drift250
          (llNowalk, _) = runWorldS (without [FWalk]) drift250
      assertApprox "cond deleted: log-loss (bits)" tolBits t4LlFrozen llFrozen
      assertApprox "full grammar: log-loss (bits)" tolBits t4LlFull llFull
      assertBool "cond deletion costs > 10 bits" (llFrozen > llFull + 10)
      assertApprox "if deleted: log-loss (bits)" tolBits t4LlNoif llNoif
      assertBool "if deletion costs > 3 bits" (llNoif > llFull + 3)
      assertApprox "guard head deleted (old no-get row): log-loss (bits)"
                   tolBits t4LlNoget llNohead
      assertBool "guard-head deletion costs > 3 bits" (llNohead > llFull + 3)
      assertApprox "full grammar, drifting world: log-loss (bits)"
                   tolBits t4LlFullD llFullD
      assertApprox "walk deleted: log-loss (bits)" tolBits t4LlNohmm llNowalk
      assertBool "walk deletion costs > 3 bits" (llNowalk > llFullD + 3)
  , testCase "emptiness rows: no constants / no model productions" $ do
      assertEqual "const production deleted: hypothesis space empties"
                  t4NNoc (length (enumerateSentences (without [FConst])))
      assertEqual "both model productions deleted: nothing generates data"
                  t4NNobern
                  (length (enumerateSentences (without [FBern, FWalk])))
  , testCase "push / argmax: unutterable by type (frozen audit rows, verbatim)" $ do
      ablationRow "push"
      ablationRow "argmax"
  ]

-- ---------------------------------------------------------------------
-- g2: SILENCE NEVER REFUTES (the code-freeze-r0 obligation rows;
-- AGENT_PLAN.md:869-878 quoted in the header)
-- ---------------------------------------------------------------------

-- (a) ill-formed at t=0, lawful at t >= 1: theta(t) < 0 exactly at
-- t=0 makes Log p = NaN there — the code refuses to denote; an
-- observation ARRIVES at t=0, so the hypothesis asserted the
-- impossible there and is dead from tick 0, lawful later ticks
-- notwithstanding (the eval half of this claim is frozen: test-code
-- group 7 rows 6a/6b)
illAtZeroHyp :: Hyp
illAtZeroHyp = statelessHyp 1
  (If (Gt (Get "t") (gk "k0" 0)) (gk "th7" 0.7) (gk "bad" (-1)))

-- (b) ill-formed exactly at t=5 while the channel is SILENT at t=5:
-- survives, because silence never refutes
illAtFiveHyp :: Hyp
illAtFiveHyp = statelessHyp 1
  (If (Call IsEq (Get "t" :* gk "k5" 5 :* ANil))
      (gk "bad" (-1)) (gk "th7" 0.7))

-- ten observed ticks; for (b) the fold SKIPS t=5 (host-level silence:
-- no observe call arrives that tick, features still advance)
g2Stream :: [Obs]
g2Stream = [1, 1, 0, 1, 1, 1, 0, 1, 1, 0]

posteriorOf :: Agent -> Int -> Int -> Double
posteriorOf ag n i =
  let sp = mkSpace (0 :| [1 .. n - 1]) :: Space Int
  in prob (agentMeta ag) (is sp i)

g2SilentTick :: TestTree
g2SilentTick = testGroup "g2 silence never refutes (integration half)"
  [ testCase "(a) ill-formed at an OBSERVED t=0: dead from tick 0 onward" $ do
      let ag0 = sentenceAgent [illAtZeroHyp, healthyHyp]
          agsAfter = scanl (\ag (t, y) -> snd (stepAgentS t y ag)) ag0
                           (zip [0 ..] g2Stream)
      -- evidence still flows (the healthy hypothesis carries the mixture)
      mapM_ (\ag -> assertBool "posterior of the refuted sentence is exactly 0"
                      (posteriorOf ag 2 0 == 0))
            (drop 1 agsAfter)
  , testCase "(b) ill-formed at a SILENT t=5: survives t=5 regardless" $ do
      let ag0 = sentenceAgent [illAtFiveHyp, healthyHyp]
          observed = [ (t, y) | (t, y) <- zip [0 ..] g2Stream, t /= (5 :: Int) ]
          agF = foldl' (\ag (t, y) -> snd (stepAgentS t y ag)) ag0 observed
          -- the control: an always-lawful twin with the SAME likelihoods
          -- at every OBSERVED tick
          ag0' = sentenceAgent [healthyHyp { hypBits = Bits 1 }, healthyHyp]
          agF' = foldl' (\ag (t, y) -> snd (stepAgentS t y ag)) ag0' observed
      assertBool "the intermittent sentence survives (posterior > 0)"
                 (posteriorOf agF 2 0 > 0)
      assertEqual "and its posterior equals the always-lawful twin's, bit for bit"
                  (castDoubleToWord64 (posteriorOf agF' 2 0))
                  (castDoubleToWord64 (posteriorOf agF 2 0))
  ]

-- ---------------------------------------------------------------------
-- g3: THE FILTER PIN (the optimisation law's first scheduled
-- application; gate provenance in the header)
-- ---------------------------------------------------------------------

-- tick-INDEPENDENT never-denoting: Get-free, theta < 0 at every tick —
-- exactly what the filter is chartered to drop at enumeration
tickFreeIllHyp :: Hyp
tickFreeIllHyp = statelessHyp 1 (gk "bad" (-1))

-- tick-DEPENDENT, both orientations (the filter must touch NEITHER):
-- ill-early/lawful-late (= g2's illAtZeroHyp) and the author's added
-- reverse row, lawful-early/ill-late
lawfulThenIllHyp :: Hyp
lawfulThenIllHyp = statelessHyp 1
  (If (Gt (Get "t") (gk "k2c" 2)) (gk "bad" (-1)) (gk "th7" 0.7))

g3Candidates :: [Hyp]
g3Candidates =
  enumerateSentences fragFull
    ++ [tickFreeIllHyp, illAtZeroHyp, lawfulThenIllHyp]

g3Checkpoints :: [Int]
g3Checkpoints = [0, 20, 40, 60, 80, 100, 120, 140, 159]

g3FilterPin :: TestTree
g3FilterPin = testGroup "g3 the enumeration filter, pinned to the general route"
  [ testCase "the filter drops exactly the tick-independent refuser (both orientations kept)" $ do
      let kept = filterTickFree g3Candidates
      length kept @?= length g3Candidates - 1
      -- the shipped population is untouched (the fast path's real
      -- shipped effect is a no-op on the 1169 lawful sentences)
      length (filterTickFree (enumerateSentences fragFull)) @?= 1169
  , testCase "shipped population: the filter is extensionally a no-op, bit-exact" $ do
      -- on the 1169 lawful sentences the filter drops nothing, so the
      -- two routes are the SAME population and the trajectories pin at
      -- == with no caveat — the shipped fast path's own pin
      let agFast = sentenceAgent (filterTickFree (enumerateSentences fragFull))
          agSlow = sentenceAgent (enumerateSentences fragFull)
          walk ag = scanl (\a (t, y) -> snd (stepAgentS t y a)) ag
                          (zip [0 ..] shifted160)
          fasts = walk agFast
          slows = walk agSlow
      mapM_ (\t -> do
               let pF = prob (predictive [("t", fromIntegral t)] (fasts !! t))
                             (is obsSpace 1)
                   pS = prob (predictive [("t", fromIntegral t)] (slows !! t))
                             (is obsSpace 1)
               assertEqual ("predictive P(y=1) at checkpoint t=" ++ show t
                              ++ " (bit)")
                           (castDoubleToWord64 pF) (castDoubleToWord64 pS))
            g3Checkpoints
  , testCase "fixture population: filter ~ carry+refute at the measured-floor gates" $ do
      -- WHERE THE FILTER ACTUALLY DROPS MASS the routes normalize over
      -- different candidate counts — THE MECHANISM: the two
      -- normalisers carry different prior populations, so identical
      -- algebra runs through different division sequences and drifts
      -- by ulps; a future reader of a 5-ulp residue here suspects the
      -- normaliser's history, never the filter. == is REFUTED by
      -- measurement (the oracle-phase probe, 2026-07-15: max relative
      -- predictive residue 1.2115e-16 = 5 ulps at t=80; max absolute
      -- posterior residue 1.4433e-15; several checkpoints bit-exact).
      -- GATES RULED AT THE SITTING (2026-07-15), the repaired-CL-4
      -- idiom over the measured floors: 1e-14 relative on the
      -- predictive (headroom x83), 1e-13 absolute per posterior point
      -- (headroom x69) — the pre-ruling's own else-branch firing as
      -- designed (== was conditional on bit-identity reproducing; it
      -- failed structurally), and the defect scale the pin exists to
      -- catch sits twelve orders above the gate.
      -- Posterior rows start at the first OBSERVED checkpoint: at t=0
      -- (pre-observation) the carried route's dropped sentence still
      -- holds its prior mass BY DESIGN — refutation needs evidence —
      -- so a posterior comparison there is a category error (D8's
      -- read-not-update distinction in test form); the t=0 PREDICTIVE
      -- row stands (condition-on-denotation renormalizes — a READ
      -- that destroys no belief — and measured bit-equal there).
      let tolG3Pred = 1e-14
          tolG3Post = 1e-13
          fastList = filterTickFree g3Candidates
          nF = length fastList
          nS = length g3Candidates
          droppedIx = 1169    -- tickFreeIllHyp's position in g3Candidates
          s2 i = if i < droppedIx then i else i + 1
          walk ag = scanl (\a (t, y) -> snd (stepAgentS t y a)) ag
                          (zip [0 ..] shifted160)
          fasts = walk (sentenceAgent fastList)
          slows = walk (sentenceAgent g3Candidates)
      mapM_ (\t -> do
               let pF = prob (predictive [("t", fromIntegral t)] (fasts !! t))
                             (is obsSpace 1)
                   pS = prob (predictive [("t", fromIntegral t)] (slows !! t))
                             (is obsSpace 1)
               assertBool ("predictive residue at t=" ++ show t ++ ": "
                             ++ show (abs (pF - pS)))
                          (abs (pF - pS) <= tolG3Pred * (1 + abs pS))
               assertBool ("the dropped sentence is refuted from the first "
                             ++ "observed tick (exact zero), t=" ++ show t)
                          (t == 0
                             || posteriorOf (slows !! t) nS droppedIx == 0)
               assertBool ("posterior residue at t=" ++ show t)
                          (t == 0
                             || and [ abs (posteriorOf (fasts !! t) nF i
                                             - posteriorOf (slows !! t) nS (s2 i))
                                        <= tolG3Post
                                    | i <- [0 .. nF - 1] ]))
            g3Checkpoints
  , testCase "reverse orientation: lawful early, ill-formed late -- carried to its death tick by BOTH routes" $ do
      -- lawfulThenIllHyp refuses from t=3 on; the filter classified it
      -- UNTOUCHABLE (it reads t), so BOTH routes carry it through its
      -- lawful ticks and BOTH kill it at its first refusing observed
      -- tick — exact zeros, route-independent, no tolerance
      let fastL = filterTickFree g3Candidates
          nF = length fastL
          nS = length g3Candidates
          walk ag = scanl (\a (t, y) -> snd (stepAgentS t y a)) ag
                          (zip [0 ..] (take 6 shifted160))
          fasts = walk (sentenceAgent fastL)
          slows = walk (sentenceAgent g3Candidates)
      assertBool "alive through its lawful ticks, carried route (posterior > 0 at t<=2)"
                 (posteriorOf (slows !! 3) nS (nS - 1) > 0)
      assertBool "alive through its lawful ticks, filter route (posterior > 0 at t<=2)"
                 (posteriorOf (fasts !! 3) nF (nF - 1) > 0)
      assertBool "dead from its first refusing observed tick, carried route (exactly 0 at t>=3)"
                 (all (\ag -> posteriorOf ag nS (nS - 1) == 0) (drop 4 slows))
      assertBool "dead from its first refusing observed tick, filter route (exactly 0 at t>=3)"
                 (all (\ag -> posteriorOf ag nF (nF - 1) == 0) (drop 4 fasts))
  , testCase "forward orientation: ill-formed at t=0, lawful after -- killed at its first observed tick by BOTH routes" $ do
      -- illAtZeroHyp refuses exactly at t=0 (each orientation carries
      -- its own row in the fixture population — the sitting's
      -- confirmation): the filter must classify it untouchable (it
      -- reads t), the prior holds its mass PRE-observation by design
      -- (refutation needs evidence — the category-error clause above,
      -- D8's read-not-update in test form), and the t=0 observation
      -- kills it exactly, in both routes; its lawful later ticks
      -- cannot resurrect it (Cromwell holds at the meta level)
      let fastL = filterTickFree g3Candidates
          nF = length fastL
          nS = length g3Candidates
          fwdS = nS - 2       -- illAtZeroHyp's position in g3Candidates
          fwdF = nF - 2       -- and after the filter (order preserved)
          walk ag = scanl (\a (t, y) -> snd (stepAgentS t y a)) ag
                          (zip [0 ..] (take 6 shifted160))
          fasts = walk (sentenceAgent fastL)
          slows = walk (sentenceAgent g3Candidates)
      assertBool "prior mass pre-observation, carried route (t=0, before any evidence)"
                 (posteriorOf (slows !! 0) nS fwdS > 0)
      assertBool "prior mass pre-observation, filter route"
                 (posteriorOf (fasts !! 0) nF fwdF > 0)
      assertBool "dead from the t=0 observation on, carried route (exactly 0)"
                 (all (\ag -> posteriorOf ag nS fwdS == 0) (drop 1 slows))
      assertBool "dead from the t=0 observation on, filter route (exactly 0)"
                 (all (\ag -> posteriorOf ag nF fwdF == 0) (drop 1 fasts))
  ]

-- ---------------------------------------------------------------------
-- g4: THE DECLARED TABLE + the Cromwell consonance row
-- ---------------------------------------------------------------------

g4DeclaredTable :: TestTree
g4DeclaredTable = testGroup "g4 the declared table prices the fragment"
  [ testCase "the table IS the declaration: widths 2/2/2/1, five productions" $ do
      fragWidth MODEL @?= 2
      fragWidth THETA @?= 2
      -- HEAD's 2 over one utterable production is a REGISTERED DEBT
      -- (step-3 sitting): a bit charged for an unutterable
      -- alternative; named home — table re-derivation at an author
      -- boundary, or a second utterable head
      fragWidth HEAD  @?= 2
      fragWidth RATE  @?= 1
      map fragSortOf fragFull @?= [MODEL, MODEL, THETA, THETA, HEAD]
  , testCase "the real pricer reproduces the frozen charges from the table, bit-exact" $ do
      -- the three family trees, table-driven (COPY of E-s1's
      -- tree-matched fold, pack §5 — itself the frozen parentheses of
      -- Enumerate.hs:304-313; lg width replaces every hand literal)
      let wM = lg (fromIntegral (fragWidth MODEL))
          wT = lg (fromIntegral (fragWidth THETA))
          wH = lg (fromIntegral (fragWidth HEAD))
          wR = lg (fromIntegral (fragWidth RATE))
          treeConst = wM + (wT + lg 9)
          treeWalk  = wM + (wR + lg 8)
          treeGuard = wM + (((wT + ((wH + 0) + (wT + lg 16)))
                             + (wT + lg 9)) + (wT + lg 9))
      assertHexEq "const family from the table" dlConstHex treeConst
      assertHexEq "walk family from the table" dlWalkHex treeWalk
      assertHexEq "guard family from the table" dlGuardHex treeGuard
      -- and the enumeration's own hypBits agree with the table trees
      let ws = map (castDoubleToWord64 . unBitsD . hypBits)
                   (enumerateSentences fragFull)
      assertBool "every enumerated charge is one of the three family values"
                 (all (`elem` [ castDoubleToWord64 treeConst
                              , castDoubleToWord64 treeWalk
                              , castDoubleToWord64 treeGuard ]) ws)
  , testCase "Cromwell lives in the mixture, not the member (the consonance row)" $ do
      -- a CERTAINTY kernel is sayable (test-code transcript row 5 made
      -- it so): theta = 1 gives a hard-zero column at y=0, and the
      -- code DENOTES; one contrary observation is a permanent zero —
      -- ruling 4's semantics applied to itself (AGENT_PLAN.md:873-878)
      let dogmatic = statelessHyp 1 (gk "one" 1)
      assertBool "the dogmatic sentence denotes (a certainty kernel is sayable)"
                 (case evalx (hypEmit dogmatic) (mkEnv [("t", 0)] VNil) of
                    Just _  -> True
                    Nothing -> False)
      let ag0 = sentenceAgent [dogmatic, healthyHyp]
          (_, ag1) = stepAgentS 0 1 ag0     -- confirming tick: it rides
          p1 = posteriorOf ag1 2 0
          (_, ag2) = stepAgentS 1 0 ag1     -- one contrary observation
          agsOn = scanl (\ag (t, y) -> snd (stepAgentS t y ag)) ag2
                        (zip [2 ..] [1, 1, 1, 1 :: Obs])
      assertBool "rides while confirmed (posterior grows past its prior)"
                 (p1 > 0.5)
      assertBool "one contrary observation: permanent zero, forever after"
                 (all (\ag -> posteriorOf ag 2 0 == 0) agsOn)
  ]

-- ---------------------------------------------------------------------
-- g5: increment-local ablation fixtures for Code / Pos / ToR
-- (decision 9; the CPP hooks are wired at Syntax.hs:38-44 — these rows
-- buy the fixtures. Increment-local runner: frozen audit scripts never
-- grow rows.)
-- ---------------------------------------------------------------------

g5Row :: String -> Assertion
g5Row row = do
  (rc, out, err) <- readProcessWithExitCode
                      "sh" ["test-sentence/ablation/run.sh", row] ""
  assertEqual ("step-3 ablation row '" ++ row ++ "' (compiles green, "
               ++ "fails under DROP_, error names the constructor):\n"
               ++ out ++ err)
              ExitSuccess rc

g5Ablations :: TestTree
g5Ablations = testGroup "g5 the step's own productions carry their ablations"
  [ testCase "code: delete the likelihood door and no hypothesis is utterable" $
      g5Row "code"
  , testCase "pos: delete the position reader and the walk is unsayable" $
      g5Row "pos"
  , testCase "tor: delete the value reader and every statistic dies" $
      g5Row "tor"
  ]
