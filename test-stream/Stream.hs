{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

-- The step-6 increment oracle DRAFT (AGENT_PLAN §7 step 6: actions in
-- the feature stream, no lag) — runtime-red against the shipped
-- step-5 membrane, drafted on the register's recommended rulings
-- (stream-author-pack.md §7/§13) and 6b's surviving rule; CONTINGENT
-- on the sitting until the author freezes it.
--
-- What this suite pins:
--   g1  THE APPEND (D-b1): observe sees feats ++ chosen assignment —
--       pinned by an IN-ROW second route (a hand fold through public
--       verbs only), never a captured golden; plus the name-blindness
--       continuity row (E-b1's mechanism, enforced forever).
--   g2  THE SCORING RULE (D-b3, 6b's survivor): runMembrane's choice
--       equals the PUBLIC exogenous-read arithmetic — per-candidate
--       predictive at (feats ++ candidate), current weights, the EU
--       verb, the Argmax tie discipline. Extensional and enforced: an
--       evidential implementation fails this row on this world.
--   g3  THE g4SELF RETURN (D-a6/D-b6): the C-world re-declared with
--       its action in the stream — MAP mentions the action name
--       decisively; the exogenous control hands the MAP to the
--       changepoint story BY STRUCTURE (the retired group's own
--       standard, 2f524e3:test-membrane/Membrane.hs:429-452).
--   g4  RIDER 2, fixture-side: the completed-namespace population
--       (1529 — the same arithmetic the retired C-world pinned) and
--       the action-guard charge equal to the DECLARED tree through
--       the one mechanism (both sides imported, R-D20-i). The tree
--       carries mention arithmetic ONLY — this row is also the
--       negative pin on RIDER 2's obligation: NO assignment price
--       exists anywhere in this suite.
--   g5  SILENT TICKS (D-b7): observation-gated — a silent tick moves
--       nothing, an observed tick's evidence is scored at the
--       appended features.
--   g6  THE DECISION-SIDE UNIVERSAL PROPERTIES (the author's note at
--       this drafting, 2026-07-16): utility affine-invariance and
--       generative argmax-optimality, as QuickCheck properties over
--       the PUBLIC scoring arithmetic — composed with g2's bridge
--       row they hold of runMembrane's own decisions. (The note's
--       other two rows are registered with named homes: VoI
--       non-negativity at step 9's boundary, the executed Dutch-book
--       check at step 7's — pack §15.)
--
-- Fixtures: test-stream/gen_fixtures.py (seed inline), sanity line
-- reproduced at the fixture block. The control stream is the FROZEN
-- test/Streams.hs shifted160, imported (probe-discipline: a probe
-- reads declared data and never re-declares a value it could import).
module Main (main) where

import Data.List (isInfixOf)
import Data.List.NonEmpty (NonEmpty ((:|)), toList)

import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck (choose, forAll, testProperty)

import PropLang.Belief (Bits (..), LogProb (LogProb), top)
import PropLang.Enumerate (Agent, Hyp (..), Obs, agentMeta,
                           enumerateSentences, enumerateSentencesIn,
                           fragFull, fragWidth, observe, predictive,
                           renderExpr, sentenceAgent, thetaPoints,
                           guardCharge)
import PropLang.Eval (Features, Vals (..), evalx, mkEnv)
import PropLang.Membrane (Pilot (..), PureWorld (..), TickTrace (..),
                          menuAssignments, runMembrane)
import PropLang.Belief (expect)
import PropLang.Syntax (B, Expr (..), Grid,
                        Idx (..), Name,
                        chargeBits, mkC, mkGrid, mkNamespace)

import Streams (shifted160)

main :: IO ()
main = defaultMain $ testGroup "stream -- actions in the feature stream (step 6)"
  [ g1Append
  , g2Scoring
  , g3SelfSignature
  , g4Rider2
  , g5Silent
  , g6Properties
  ]

ln2 :: Double
ln2 = log 2

-- ---------------------------------------------------------------------
-- the world: the C-world re-declared (D-b6). Three declared names —
-- the completed namespace includes the writable one (RIDER 2).
-- ---------------------------------------------------------------------

zGrid :: Grid
zGrid = mkGrid "zc" (0.25 :| [0.5, 0.75])   -- the retired C-world's own

aGrid :: Grid
aGrid = mkGrid "ac" (0.5 :| [1.5])          -- wait = 0.5 (first point)

modelsS :: [Hyp]
modelsS = enumerateSentencesIn (mkNamespace ("t" :| ["z", "a"]))
                               [("z", zGrid), ("a", aGrid)] fragFull

cWorld :: [Obs] -> PureWorld Int
cWorld ys = PureWorld
  { wFeats    = \t -> [("t", fromIntegral t), ("z", zC !! t)]
  , wEvidence = \t -> Just (ys !! t)
  , wMenu     = const [("a", aGrid)]
  , wStep     = \t _ -> t + 1
  }

-- the scripted explorer (the retired group's own words: the test's
-- claim is the posterior's, not the policy's)
cPilot :: Pilot
cPilot = PilotThreshold "z" 0.5 [("a", 1.5)] [("a", 0.5)]

runOrFail :: Maybe a -> IO a
runOrFail (Just x) = pure x
runOrFail Nothing  = assertFailure "runMembrane: impossible evidence"

-- ---------------------------------------------------------------------
-- the second route, in-row: public verbs only. euAt is the EU verb at
-- one candidate's own predictive; argmaxBy mirrors the Argmax
-- evaluator's exact tie discipline (src/PropLang/Eval.hs:105-115 —
-- strict > displaces, first-listed wins).
-- ---------------------------------------------------------------------

-- RE-DERIVED at the step-8 outcome freeze (R-D22): EU's evaluation
-- features are an ARGUMENT now (feats ++ candidate — the same value
-- the fold passes); the residue code is 0 for assignment worlds.
-- SINCE STEP 9: the EU verb died; EU is the public 'expect' over the
-- utility residue (bit-identical: pre-step-9 'Call EU' was exactly
-- 'expect pr (\\y -> uAt (feats++a) u 0 y)' — 'Var Z' the code 0,
-- 'Var (S Z)' the outcome).
euAt :: B Obs -> Expr '[Double, Double] Double -> Features -> Features -> Double
euAt pr u feats a =
  expect pr (\y -> evalx u (mkEnv (feats ++ a) (0 :. realToFrac y :. VNil)))

argmaxBy :: (a -> Double) -> NonEmpty a -> a
argmaxBy val (o0 :| os) = go o0 (val o0) os
  where
    go best _ [] = best
    go best bv (c : rest) =
      let cv = val c
      in if cv > bv then go c cv rest else go best bv rest

-- the public exogenous-read choice at one tick (D-b3's arithmetic,
-- stated where it can be enforced)
exoChoice :: Agent -> Features -> [(Name, Grid)] -> Expr '[Double, Double] Double
          -> Features
exoChoice ag feats menu u =
  argmaxBy (\a -> euAt (predictive (feats ++ a) ag) u feats a)
           (menuAssignments menu)

-- hand fold of the step-6 tick: choose (scripted or EU), observe at
-- the APPENDED features, thread the agent; returns per-tick
-- (choice, lossBits)
handFold :: (Agent -> Features -> Features) -> [Obs] -> Int -> Agent
         -> Maybe [(Features, Double)]
handFold pick ys n ag0 = go 0 ag0
  where
    go t ag
      | t >= n = Just []
      | otherwise = do
          let feats = [("t", fromIntegral t), ("z", zC !! t)]
              c = pick ag feats
          (LogProb lp, ag') <- observe (feats ++ c) (ys !! t) ag
          rest <- go (t + 1) ag'
          pure ((c, negate lp / ln2) : rest)

scriptPick :: Agent -> Features -> Features
scriptPick _ feats =
  if maybe 0 id (lookup "z" feats) > 0.5 then [("a", 1.5)] else [("a", 0.5)]

-- ---------------------------------------------------------------------
-- g1: the append (D-b1)
-- ---------------------------------------------------------------------

g1Append :: TestTree
g1Append = testGroup "g1 the append: observe sees feats ++ assignment"
  [ testCase "the tick's losses ARE the appended-features losses (in-row second route)" $ do
      (_, trs) <- runOrFail (runMembrane (cWorld ySelf) cPilot 160 0
                               (sentenceAgent modelsS))
      folded <- runOrFail (pure (handFold scriptPick ySelf 160
                                          (sentenceAgent modelsS)))
      case folded of
        Nothing -> assertFailure "hand fold: impossible evidence"
        Just cl -> do
          map ttLossBits trs @?= map snd cl
          map ttAct trs @?= map fst cl
  , testCase "name-blindness continuity: an ns0 agent's losses ignore the append (E-b1's mechanism, enforced)" $ do
      (_, trs) <- runOrFail (runMembrane (cWorld ySelf) cPilot 160 0
                               (sentenceAgent (enumerateSentences fragFull)))
      -- the bare fold: observe at the world's features ONLY — equal
      -- because no ns0 code Gets a writable name (dormancy)
      let bare = go (0 :: Int) (sentenceAgent (enumerateSentences fragFull))
          go t ag | t >= 160 = Just []
                  | otherwise = do
                      let feats = [("t", fromIntegral t), ("z", zC !! t)]
                      (LogProb lp, ag') <- observe feats (ySelf !! t) ag
                      rest <- go (t + 1) ag'
                      pure (negate lp / ln2 : rest)
      case bare of
        Nothing -> assertFailure "bare fold: impossible evidence"
        Just ls -> map ttLossBits trs @?= ls
  ]

-- ---------------------------------------------------------------------
-- g2: the scoring rule (D-b3 — 6b's survivor, extensional)
--
-- THE PINNED RESOLUTION, as ruled at the step-6 sitting (2026-07-16;
-- pack Part V section 32), with the author's two clauses:
--   1. SCOPE: what 6b convicted is THIS evidential rule — naive
--      joint-conditioning through a phase-blind action channel — in
--      this world class; the falsifier owed no steelman, and a
--      fragment extension making actions modelable stays an OPEN
--      alphabet question, guarded by the primitivity two-sided
--      entry gate.
--   2. THE STRUCTURAL READING: exogenous-read is functionally an
--      intervention semantics at decision time — the contemplated
--      action enters only as input, its incoming arrows severed —
--      achieved with NO do-operator in the language, just the D8
--      read at augmented features. A6 stands epistemic (learning
--      conditions on everything, including the agent's own record,
--      world-first per D-b2); decision-time reads are exogenous.
-- ---------------------------------------------------------------------

-- RE-DERIVED at the step-8 outcome freeze (R-D22): uSelf IS
-- payUtil 1 0 — a=1.5 -> 2y-1, a=0.5 -> 0, as a sentence over
-- Get "a" (same extension on the menu; a sentence cannot error
-- off-menu, and the pinned runs never leave it)
uSelf :: Expr '[Double, Double] Double
uSelf = payUtil 1.0 0.0

-- the action-RESPONSIVE world (the discriminating fixture the first
-- SAT/red pass forced: in the C-world the script made the action a
-- deterministic function of z, so bare-features scoring could proxy
-- per-assignment scoring through the z channel and the row could not
-- red — pack Part III). Here the world answers y from the PREVIOUS
-- tick's action ("actions have no return values": consequences only
-- ever arrive inside a later tick), the state carries what the agent
-- last did, and no published sensor proxies it.
rWorld :: PureWorld (Int, Double)
rWorld = PureWorld
  { wFeats    = \(t, _) -> [("t", fromIntegral t)]
  , wEvidence = \(t, la) -> Just (if la > 1.0 then yHi !! t else yLo !! t)
  , wMenu     = const [("a", aGrid)]
  , wStep     = \(t, _) c -> (t + 1, maybe 0.5 id (lookup "a" c))
  }

-- the sticky training script (blocks of ten): the appended a explains
-- y because consecutive actions agree, and no t-guard can fit eight
-- alternating blocks
blockPick :: Agent -> Features -> Features
blockPick _ feats =
  let t = floor (maybe 0 id (lookup "t" feats)) :: Int
  in if even (t `div` 10) then [("a", 1.5)] else [("a", 0.5)]

-- the fold over rWorld: thread (t, lastA, agent), observe at the
-- appended features
rFold :: (Agent -> Features -> Features) -> Int -> Int -> Double -> Agent
      -> Maybe [(Features, Agent)]
rFold pick n t0 la0 ag0 = go t0 la0 ag0
  where
    go t la ag
      | t >= n = Just []
      | otherwise = do
          let feats = [("t", fromIntegral t)]
              c = pick ag feats
              y = if la > 1.0 then yHi !! t else yLo !! t
          (_, ag') <- observe (feats ++ c) y ag
          rest <- go (t + 1) (maybe 0.5 id (lookup "a" c)) ag'
          pure ((c, ag') : rest)

g2Scoring :: TestTree
g2Scoring = testGroup "g2 the scoring rule: exogenous-read, pinned to the public arithmetic"
  [ testCase "runMembrane's choices == per-assignment predictive EU at current weights, every tick" $ do
      -- phase 1 (shared, public verbs): 100 sticky-scripted ticks
      -- teach P(y | a) through the appended stream
      trained <- case rFold blockPick 100 0 0.5 (sentenceAgent modelsS) of
        Just steps@(_ : _) -> pure (snd (last steps))
        _ -> assertFailure "g2 training fold: impossible evidence"
      -- t = 90..99 is a waiting block, so the loop resumes at
      -- (100, 0.5) — the state the fold ended in
      (_, trs) <- runOrFail (runMembrane rWorld (PilotEU uSelf) 60
                               (100, 0.5) trained)
      folded <- case rFold (\ag feats ->
                              exoChoice ag feats [("a", aGrid)] uSelf)
                           160 100 0.5 trained of
        Just steps -> pure (map fst steps)
        Nothing -> assertFailure "g2 decision fold: impossible evidence"
      map ttAct trs @?= folded
  ]

-- ---------------------------------------------------------------------
-- g3: the self-signature returns (interface.md §8 C; ruling D-a6)
-- ---------------------------------------------------------------------

mapOfAgent :: [(Int, Double)] -> IO (String, Double)
mapOfAgent ranked = case ranked of
  (ix, p) : _ -> pure (renderExpr (hypEmit (modelsS !! ix)), p)
  []          -> assertFailure "agentMeta top returned no entries"

-- the action-mentioning FAMILY's posterior mass: sibling a-guards
-- (thresholds x theta pairs) split the story's mass among
-- near-identical sentences, so the family, not any single sentence,
-- is the decisive unit (the SAT measurement that revised this row:
-- self 0.600, control 5.2e-21 -- pack Part III)
aFamilyMass :: [(Int, Double)] -> Double
aFamilyMass ranked =
  sum [ p | (i, p) <- ranked
      , "('get', 'a')" `isInfixOf` renderExpr (hypEmit (modelsS !! i)) ]

-- COPY test-membrane/Membrane.hs:172-173 (R-D20-i: the frozen literal
-- cannot be imported from a test main; copied byte-wise, provenance
-- here, reviewable by grep)
t1RenderGoldenM :: String
t1RenderGoldenM = "('code', ('neg', ('/', ('log', ('if', ('>', ('tor', ('var', 0)), ('c', 'k', 0)), ('if', ('>', ('get', 't'), ('c', 'tau', 11)), ('c', 'theta', 0), ('c', 'theta', 8)), ('-', ('c', 'k', 1), ('if', ('>', ('get', 't'), ('c', 'tau', 11)), ('c', 'theta', 0), ('c', 'theta', 8))))), ('log', ('c', 'k', 2)))))"

g3SelfSignature :: TestTree
g3SelfSignature = testGroup "g3 self-signature (C): the action-in-stream story wins only when it should"
  [ testCase "C: MAP mentions ('get', 'a'), decisively" $ do
      (agF, _) <- runOrFail (runMembrane (cWorld ySelf) cPilot 160 0
                               (sentenceAgent modelsS))
      let ranked = top (agentMeta agF) (length modelsS)
      (m, _) <- mapOfAgent ranked
      assertBool ("MAP mentions ('get', 'a'): " ++ m)
                 ("('get', 'a')" `isInfixOf` m)
      -- the family carries the MAJORITY of the posterior (measured
      -- 0.600 at the SAT run; the bar is the majority statement, not
      -- a tuned floor)
      assertBool ("a-family mass > 0.5, got " ++ show (aFamilyMass ranked))
                 (aFamilyMass ranked > 0.5)
  , testCase "C0 control: the exogenous story wins, BY STRUCTURE" $ do
      (agF, _) <- runOrFail (runMembrane (cWorld shifted160) cPilot 160 0
                               (sentenceAgent modelsS))
      let ranked = top (agentMeta agF) (length modelsS)
      (m, _) <- mapOfAgent ranked
      m @?= t1RenderGoldenM
      assertBool ("control MAP must not mention the action: " ++ m)
                 (not ("('get', 'a')" `isInfixOf` m))
      -- and the whole family is DEAD, not merely beaten (measured
      -- 5.2e-21; the bar leaves nine orders of margin)
      assertBool ("control a-family mass < 1e-12, got "
                  ++ show (aFamilyMass ranked))
                 (aFamilyMass ranked < 1e-12)
  ]

-- ---------------------------------------------------------------------
-- g4: RIDER 2, fixture-side (mention prices over the completed
-- namespace; NO assignment-priced row exists in this suite)
-- ---------------------------------------------------------------------

g4Rider2 :: TestTree
g4Rider2 = testGroup "g4 RIDER 2: the completed namespace, mention prices only"
  [ testCase "the 3-name population is 1529 (9 + 8 + (16+3+2)*72)" $
      length modelsS @?= 1529
  , testCase "an action-guard's charge IS the declared tree through the one mechanism" $ do
      -- the a-guard block starts after consts(9) + walks(8) +
      -- t-guards(16*72) + z-guards(3*72); both sides IMPORTED
      let aIx = 9 + 8 + 16 * 72 + 3 * 72
          eg = mkGrid "theta" thetaPoints
          want = chargeBits fragWidth
                   (guardCharge (mkNamespace ("t" :| ["z", "a"])) aGrid eg)
      case hypBits (modelsS !! aIx) of Bits got -> got @?= want
  ]

-- ---------------------------------------------------------------------
-- g5: silent ticks are observation-gated (D-b7)
-- ---------------------------------------------------------------------

g5Silent :: TestTree
g5Silent = testGroup "g5 silent ticks: nothing folds without an observation"
  [ testCase "silent ticks lose 0 bits; observed ticks score at the appended features" $ do
      let silentW = (cWorld ySelf)
            { wEvidence = \t -> if odd t then Nothing else Just (ySelf !! t) }
      -- 20 ticks: the window contains observed ACTED ticks (t=14,16
      -- act under the script) — the first red pass caught an 8-tick
      -- window whose acted ticks were all silent, leaving the row
      -- unable to red (pack Part III)
      (_, trs) <- runOrFail (runMembrane silentW cPilot 20 0
                               (sentenceAgent modelsS))
      map ttLossBits [tr | tr <- trs, odd (ttT tr)] @?= replicate 10 0
      -- the observed ticks equal a fold that skips the silent ones
      let go t ag | t >= (20 :: Int) = Just []
                  | otherwise = do
                      let feats = [("t", fromIntegral t), ("z", zC !! t)]
                          c = scriptPick ag feats
                      if odd t
                        then go (t + 1) ag
                        else do
                          (LogProb lp, ag') <- observe (feats ++ c)
                                                       (ySelf !! t) ag
                          rest <- go (t + 1) ag'
                          pure (negate lp / ln2 : rest)
      case go 0 (sentenceAgent modelsS) of
        Nothing -> assertFailure "silent fold: impossible evidence"
        Just ls -> map ttLossBits [tr | tr <- trs, even (ttT tr)] @?= ls
  ]

-- ---------------------------------------------------------------------
-- g6: the decision-side universal properties (the author's note at
-- this drafting). Both are properties of the PUBLIC scoring
-- arithmetic; g2's bridge row ties runMembrane's decisions to that
-- arithmetic, so together they hold of the loop itself.
-- ---------------------------------------------------------------------

-- a deterministic trained state (40 ticks of the self world) so EU
-- gaps are generically nonzero and the properties bite
trainedS :: Agent
trainedS = go (0 :: Int) (sentenceAgent modelsS)
  where
    go t ag
      | t >= 40 = ag
      | otherwise =
          let feats = [("t", fromIntegral t), ("z", zC !! t)]
              c = scriptPick ag feats
          in case observe (feats ++ c) (ySelf !! t) ag of
               Just (_, ag') -> go (t + 1) ag'
               Nothing       -> error "trainedS: impossible evidence"

probeFeats :: Features
probeFeats = [("t", 40), ("z", zC !! 40)]

payUtil :: Double -> Double -> Expr '[Double, Double] Double
payUtil vHi vLo =
  If (Gt (Get "a") (gkS 1))
     (Mul (gkS vHi) (Sub (Mul (gkS 2) (Var (S Z))) (gkS 1)))
     (gkS vLo)

gkS :: Double -> Expr env Double
gkS v = case mkC (mkGrid "k" (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "stream fixture: singleton grid index 0 must construct"

-- alpha*u + beta AS A SENTENCE (the affine property's second route)
affineU :: Double -> Double -> Expr '[Double, Double] Double -> Expr '[Double, Double] Double
affineU alpha beta p =
  Add (Mul (gkS alpha) p) (gkS beta)

g6Properties :: TestTree
g6Properties = testGroup "g6 decision-side universal properties"
  [ testProperty "utility affine-invariance: argmax(alpha*u + beta) == argmax(u), alpha > 0" $
      forAll (choose (0.01, 100 :: Double)) $ \alpha ->
      forAll (choose (-100, 100 :: Double)) $ \beta ->
      forAll (choose (-2, 2 :: Double)) $ \vHi ->
      forAll (choose (-2, 2 :: Double)) $ \vLo ->
        let u  = payUtil vHi vLo
            u' = affineU alpha beta u
        in exoChoice trainedS probeFeats [("a", aGrid)] u
             == exoChoice trainedS probeFeats [("a", aGrid)] u'
  , testProperty "generative argmax-optimality: the choice attains the max, first-listed among ties" $
      forAll (choose (-2, 2 :: Double)) $ \vHi ->
      forAll (choose (-2, 2 :: Double)) $ \vLo ->
        let u = payUtil vHi vLo
            opts = menuAssignments [("a", aGrid)]
            eu a = euAt (predictive (probeFeats ++ a) trainedS) u probeFeats a
            c = exoChoice trainedS probeFeats [("a", aGrid)] u
            best = maximum (map eu (toList opts))
        in eu c == best
             && [c] == take 1 [o | o <- toList opts, eu o == best]
  ]

-- ---------------------------------------------------------------------
-- fixtures (generated + sanity-checked by test-stream/gen_fixtures.py,
-- seed 20260716 inline there; sanity: n(a=1.5)=75/160,
-- P(y=1|a=1.5)=0.880, P(y=1|a=0.5)=0.165, action crossings=76 — the
-- action is not a cheap function of time)
-- ---------------------------------------------------------------------

zC :: [Double]
zC =
  [ 0.29, 0.114, 0.269, 0.421, 0.126, 0.919, 0.323, 0.812, 0.271, 0.998
  , 0.079, 0.757, 0.403, 0.254, 0.638, 0.38, 0.843, 0.274, 0.498, 0.228
  , 0.609, 0.46, 0.646, 0.155, 0.201, 0.065, 0.509, 0.876, 0.666, 0.501
  , 0.062, 0.553, 0.216, 0.968, 0.808, 0.157, 0.928, 0.734, 0.066, 0.555
  , 0.915, 0.559, 0.979, 0.209, 0.627, 0.898, 0.627, 0.906, 0.022, 0.944
  , 0.467, 0.705, 0.462, 0.752, 0.001, 0.509, 0.57, 0.481, 0.526, 0.124
  , 0.458, 0.779, 0.098, 0.153, 0.006, 0.371, 0.968, 0.507, 0.961, 0.396
  , 0.475, 0.089, 0.584, 0.275, 0.256, 0.278, 0.166, 0.285, 0.864, 0.118
  , 0.966, 0.869, 0.105, 0.471, 0.359, 0.936, 0.787, 0.997, 0.988, 0.558
  , 0.337, 0.739, 0.924, 0.107, 0.23, 0.901, 0.77, 0.167, 0.643, 0.398
  , 0.017, 0.271, 0.327, 0.643, 0.866, 0.797, 0.927, 0.597, 0.242, 0.254
  , 0.46, 0.882, 0.649, 0.291, 0.332, 0.004, 0.07, 0.733, 0.047, 0.648
  , 0.724, 0.731, 0.113, 0.431, 0.732, 0.266, 0.08, 0.398, 0.324, 0.848
  , 0.929, 0.183, 0.02, 0.839, 0.973, 0.844, 0.311, 0.897, 0.325, 0.191
  , 0.314, 0.146, 0.248, 0.551, 0.599, 0.532, 0.126, 0.01, 0.006, 0.604
  , 0.922, 0.737, 0.919, 0.704, 0.074, 0.057, 0.163, 0.046, 0.189, 0.283
  ]

ySelf :: [Int]
ySelf =
  [ 0, 0, 0, 0, 1, 1, 0, 1, 0, 1
  , 1, 1, 0, 0, 1, 0, 1, 0, 0, 0
  , 1, 0, 1, 0, 0, 0, 1, 1, 1, 0
  , 0, 1, 1, 1, 0, 0, 1, 1, 0, 1
  , 1, 1, 0, 0, 1, 1, 1, 1, 0, 1
  , 0, 1, 0, 1, 0, 1, 1, 0, 1, 0
  , 0, 1, 0, 0, 0, 0, 1, 1, 1, 0
  , 0, 1, 1, 0, 0, 0, 0, 1, 1, 0
  , 1, 1, 1, 0, 0, 1, 1, 0, 1, 0
  , 0, 1, 1, 0, 0, 1, 1, 0, 0, 0
  , 0, 0, 1, 1, 1, 1, 1, 0, 1, 0
  , 0, 1, 1, 0, 1, 0, 0, 1, 1, 1
  , 1, 0, 0, 0, 1, 0, 0, 0, 0, 1
  , 1, 0, 0, 1, 1, 1, 0, 1, 0, 1
  , 0, 0, 0, 1, 1, 0, 1, 0, 0, 1
  , 1, 1, 1, 1, 1, 0, 1, 0, 0, 0
  ]

yHi :: [Int]
yHi =
  [ 1, 1, 0, 1, 0, 1, 1, 1, 1, 1
  , 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  , 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  , 1, 1, 1, 1, 0, 1, 1, 1, 1, 1
  , 1, 1, 0, 1, 1, 1, 1, 1, 1, 1
  , 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  , 1, 1, 1, 0, 1, 1, 1, 1, 0, 1
  , 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  , 1, 1, 1, 1, 1, 1, 1, 0, 1, 0
  , 0, 0, 1, 1, 1, 1, 1, 1, 1, 0
  , 1, 1, 1, 1, 0, 1, 1, 1, 1, 1
  , 1, 1, 1, 1, 1, 0, 1, 1, 1, 1
  , 1, 1, 1, 0, 1, 1, 1, 1, 1, 1
  , 0, 1, 0, 1, 1, 1, 1, 1, 1, 1
  , 1, 1, 1, 0, 1, 1, 1, 1, 0, 1
  , 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  ]

yLo :: [Int]
yLo =
  [ 0, 1, 0, 1, 0, 0, 0, 1, 0, 0
  , 0, 0, 0, 1, 0, 0, 0, 0, 0, 0
  , 1, 1, 1, 0, 0, 0, 0, 0, 0, 0
  , 1, 0, 0, 0, 0, 0, 0, 0, 1, 0
  , 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
  , 0, 0, 0, 0, 0, 0, 1, 0, 0, 0
  , 0, 0, 0, 0, 0, 1, 1, 0, 0, 0
  , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  , 0, 0, 1, 0, 0, 0, 0, 0, 0, 1
  , 0, 1, 0, 0, 0, 0, 0, 0, 0, 0
  , 0, 0, 0, 0, 1, 1, 0, 0, 0, 0
  , 0, 1, 0, 0, 0, 0, 0, 0, 0, 0
  , 0, 0, 0, 0, 0, 1, 0, 0, 0, 0
  , 0, 0, 0, 1, 0, 1, 0, 0, 0, 0
  , 0, 0, 0, 0, 0, 0, 0, 0, 1, 0
  , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  ]
