{-# LANGUAGE DataKinds #-}

-- | The four acceptance tests, ported from tests_acceptance.py — the
-- FROZEN ORACLE (CLAUDE.md Phase 1). Frozen under MANIFEST.sha256 after
-- human review; from Phase 2 on, any diff to this file is a protocol
-- violation.
--
-- Every assertion is either (i) an assertion the Python test makes,
-- verbatim, or (ii) a measured anchor from the Python run, pinned per
-- the tolerance protocol in test/Anchors.hs: counts, actions, tick
-- counts and rendered programs EXACT; probabilities and entropies within
-- 'tolProb'; cumulative log-losses within 'tolBits'. A Phase-2 failure
-- of a pinned anchor is stop-and-report and a human-signed Phase-1
-- re-open — tolerances are part of the oracle and are never widened in
-- place.
--
-- The observation streams live in test/Streams.hs, ported bit-for-bit
-- (port the stream, not the RNG). The world's clock arrives as the
-- feature "t" (interface.md §5); utilities are world-supplied data,
-- passed as opaque 'Util' values, never baked into src/.
module Main (main) where

import Data.List.NonEmpty (NonEmpty (..))
import Data.Maybe (fromMaybe)
import System.Exit (ExitCode (..))
import System.Process (readProcessWithExitCode)
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief
import PropLang.Enumerate
import PropLang.Eval
import PropLang.Syntax

import Anchors
import Streams

main :: IO ()
main = defaultMain $ testGroup "proplang acceptance (frozen oracle)"
  [ testCase "test 1: the changing-world test" test1
  , testCase "test 2: the lazy-genius test" test2
  , testCase "test 3: the forgetting-factor trap" test3
  , testCase "test 4: the deletion audit" test4
  ]

-- ---------------------------------------------------------------------
-- shared helpers
-- ---------------------------------------------------------------------

ln2 :: Double
ln2 = log 2

assertApprox :: String -> Double -> Double -> Double -> Assertion
assertApprox msg tol expected actual =
  assertBool (msg ++ ": expected " ++ show expected ++ " +- " ++ show tol
                  ++ ", got " ++ show actual)
             (abs (actual - expected) <= tol)

-- | One polling re-entry: the tick arrives as the feature "t"; returns
-- the observation's log-loss contribution in bits and the moved agent.
stepAgent :: Int -> Obs -> Agent -> (Double, Agent)
stepAgent t y ag =
  case observe [("t", fromIntegral t)] y ag of
    Nothing              -> error ("impossible evidence at t=" ++ show t)
    Just (LogProb lp, a) -> (negate lp / ln2, a)

-- | Cumulative predictive log-loss (bits) of a fresh agent over a world
-- stream, plus the final agent.
runWorld :: [Terminal] -> [Obs] -> (Double, Agent)
runWorld terms ys =
  foldl' step (0, mkAgent (enumerateModels terms)) (zip [0 ..] ys)
  where
    step (acc, ag) (t, y) = let (b, ag') = stepAgent t y ag in (acc + b, ag')

-- | MAP program via the Python route: meta.top(1) -> index -> render.
mapProgram :: Agent -> IO (String, Double)
mapProgram ag = case top (agentMeta ag) 1 of
  (ix, p) : _ -> pure (renderModel (agentModels ag !! ix), p)
  []          -> assertFailure "agentMeta top returned no entries"

-- | Expected-utility action selection AS A PROGRAM (the verbs are
-- terminals; the policy is syntax evaluated by evalx) — the typed port
-- of tests_acceptance.POLICY_ACT: argmax over options of EU(option),
-- with the predictive belief and the world-supplied utility bound in the
-- typed environment.
argmaxEU :: Expr '[NonEmpty o, B y, Util o y] o
argmaxEU =
  Argmax (Var Z)
    (Call EU (Var (S (S Z)) :* Var (S (S (S Z))) :* Var Z :* ANil))

-- ---------------------------------------------------------------------
-- TEST 1: the changing-world test
-- ---------------------------------------------------------------------

data Act1 = Predict1 | Predict0 | Consult
  deriving (Eq, Show)

act1Name :: Act1 -> String
act1Name Predict1 = "predict1"
act1Name Predict0 = "predict0"
act1Name Consult  = "consult"

-- world/user-supplied utility (consult pays a flat 0.35)
util1 :: Util Act1 Obs
util1 = mkUtil $ \a y -> case a of
  Consult  -> 0.35
  Predict1 -> if y == 1 then 1.0 else -1.0
  Predict0 -> if y == 0 then 1.0 else -1.0

-- | The 160-tick timeline: (t, P(y=1), chosen action, meta-entropy).
runChangingWorld :: ([(Int, Double, Act1, Double)], Agent)
runChangingWorld = go 0 (mkAgent (enumerateModels allTerminals)) shifted160
  where
    acts = Predict1 :| [Predict0, Consult]
    go _ ag [] = ([], ag)
    go t ag (y : ys) =
      let pr = predictive [("t", fromIntegral t)] ag
          p1 = prob pr (is obsSpace 1)
          a  = evalx argmaxEU (mkEnv [] (acts :. pr :. util1 :. VNil))
          h  = entropyBits (agentMeta ag)
          (_, ag')     = stepAgent t y ag
          (rows, agF)  = go (t + 1) ag' ys
      in ((t, p1, a, h) : rows, agF)

test1 :: Assertion
test1 = do
  let (timeline, agF) = runChangingWorld
      actAt      = [ (t, a) | (t, a) <- zip [0 :: Int ..] (map trd timeline) ]
      trd (_, _, a, _) = a
      between lo hi = [ a | (t, a) <- actAt, lo <= t, t < hi ]
      hs    = map (\(_, _, _, h) -> h) timeline
      hPre  = hs !! 59
      hPost = maximum (take 30 (drop 60 hs))

  -- the Python test's own assertions, verbatim
  assertBool "confident (predict1) for t in [30,60)"
             (all (== Predict1) (between 30 60))
  assertBool "consults inside t in [60,80)"
             (Consult `elem` between 60 80)
  assertBool "recovers to predict0 for t in [130,160)"
             (all (== Predict0) (between 130 160))
  assertBool "entropy disperses (H_post > H_pre + 0.5)"
             (hPost > hPre + 0.5)

  -- pinned anchors (measured from the Python oracle)
  assertEqual "consult tick set (exact)"
              t1ConsultTicks [ t | (t, Consult) <- actAt ]
  assertApprox "H_pre(t=59)" tolProb t1HPre hPre
  assertApprox "H_post max over [60,90)" tolProb t1HPostMax hPost
  mapM_ (\(t, p, a, h) -> do
           let (_, p', a', h') = timeline !! t
           assertApprox ("P(y=1) at t=" ++ show t) tolProb p p'
           assertEqual ("action at t=" ++ show t) a (act1Name a')
           assertApprox ("H at t=" ++ show t) tolProb h h')
        t1ProbeRows

  -- MAP program is the exact change-point sentence at tau=60
  (mp, mpP) <- mapProgram agF
  assertEqual "MAP program (exact change-point sentence)" t1MapProgram mp
  assertApprox "MAP posterior" tolProb t1MapPosterior mpP

  -- grep the language module for change-detection machinery: none
  (rc, out, err) <- readProcessWithExitCode "python3"
    [ "audit/strip_comments.py", "--forbidden", "audit/forbidden.txt"
    , "src/PropLang/Belief.hs", "src/PropLang/Syntax.hs"
    , "src/PropLang/Eval.hs", "src/PropLang/Enumerate.hs"
    , "src/PropLang/Host.hs" ] ""
  assertEqual ("grep for forbidden mechanisms in src/: " ++ out ++ err)
              ExitSuccess rc

-- ---------------------------------------------------------------------
-- TEST 2: the lazy-genius test
-- ---------------------------------------------------------------------

data MetaAct = DoAct | DoThink
  deriving (Eq, Show)

data Dir = DirL | DirR
  deriving (Eq, Show)

dirName :: Dir -> String
dirName DirL = "L"
dirName DirR = "R"

-- the world-supplied stakes: +-(2*theta - 1)
stakes :: Util Dir Double
stakes = mkUtil $ \a th ->
  let v = 2 * th - 1 in case a of DirR -> v; DirL -> negate v

-- | The self-referential policy, verbatim shape from the Python test:
--
-- > ('argmax', 'METAACTS',
-- >   ('if', ('call', 'is_act', 'option'),
-- >          ('call', 'v_act',   'B'),
-- >          ('call', 'v_think', 'B', ('get', 'price'))))
--
-- Everything Python's stdlib closures captured (the EMIT kernel, the
-- outcome alphabet, the stakes, the act menu, the batch size) is passed
-- as an explicit typed argument; the price of a tick stays a FEATURE
-- read by @Get "price"@ (interface.md §1: prices are names).
policyThink :: Expr '[ NonEmpty MetaAct, MetaAct, B Double, K Double Obs
                     , [Obs], Util Dir Double, NonEmpty Dir, Int ] MetaAct
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

-- | One episode. The ONLY thing that varies across runs is the world's
-- per-tick price, delivered as a feature. No iteration cap, no
-- threshold: the loop runs while argmax says think; the clock, and only
-- the clock, terminates the regress.
runDeliberation :: Double -> [Obs] -> (Int, Dir)
runDeliberation price = go (0 :: Int) (uniform thetaSpace)
  where
    dirs = DirL :| [DirR]
    go ticks b buf =
      let metaacts = DoAct :| [DoThink | not (null buf)]
          batchN   = min 3 (length buf)
          env = mkEnv [("price", price)]
                  (metaacts :. DoAct :. b :. emit :. ([0, 1] :: [Obs])
                    :. stakes :. dirs :. batchN :. VNil)
      in case evalx policyThink env of
           DoAct   -> (ticks, evalx argmaxEU
                                (mkEnv [] (dirs :. b :. stakes :. VNil)))
           DoThink -> go (ticks + 1) (condBatch b (take 3 buf)) (drop 3 buf)
    condBatch = foldl' (\bb y ->
      fromMaybe (error "impossible evidence in batch")
                (cond bb (Saw emit y)))

test2 :: Assertion
test2 = do
  let runs = [ (p, runDeliberation p buffer36) | (p, _, _) <- t2Rows ]

  -- pinned anchors: exact tick counts and final acts at each price
  mapM_ (\((pA, tkA, fA), (_, (tk, f))) -> do
           assertEqual ("thinking ticks at price " ++ show pA) tkA tk
           assertEqual ("final act at price " ++ show pA) fA (dirName f))
        (zip t2Rows runs)

  -- the Python test's own assertion: dearer clock -> strictly fewer
  -- thinking ticks (with equality allowed only at the price-0 end,
  -- where information runs dry before the clock bites)
  case map (fst . snd) runs of
    [tHi, tMid, tLo, tNone] ->
      assertBool "t_hi < t_mid < t_lo <= t_none"
                 (tHi < tMid && tMid < tLo && tLo <= tNone)
    other -> assertFailure ("expected 4 runs, got " ++ show (length other))

-- ---------------------------------------------------------------------
-- TEST 3: the forgetting-factor trap
-- ---------------------------------------------------------------------

-- | THE TRAP (deliberately built, to be deleted): a Beta tracker with a
-- forgetting factor. Quarantined in this test file, exactly as it is
-- quarantined in tests_acceptance.py; it is not, and must never be,
-- part of the language or the agent (audit gate 4 enforces the grep).
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

test3 :: Assertion
test3 = do
  let (laD, agD) = runWorld allTerminals drift400
      (laF, _)   = runWorld allTerminals flat400
      fDrift = [ forgetterLogloss g drift400 | (g, _, _) <- t3ForgetterRows ]
      fFlat  = [ forgetterLogloss g flat400  | (g, _, _) <- t3ForgetterRows ]
      bestDrift = minimum fDrift
      bestFlat  = minimum fFlat

  -- pinned anchors: the full forgetter table and the agent's losses
  mapM_ (\((g, dA, fA), (d, f)) -> do
           assertApprox ("forgetter drift loss, gamma=" ++ show g) tolBits dA d
           assertApprox ("forgetter flat loss, gamma=" ++ show g) tolBits fA f)
        (zip t3ForgetterRows (zip fDrift fFlat))
  assertApprox "agent log-loss, drifting world" tolBits t3AgentDrift laD
  assertApprox "agent log-loss, stationary world" tolBits t3AgentFlat laF

  -- the Python test's own assertions: within 2% of the oracle-tuned best
  assertBool "matches/beats the best oracle-tuned forgetter on drift"
             (laD <= bestDrift + 0.02 * bestDrift)
  assertBool "matches/beats every forgetter on the stationary world"
             (laF <= bestFlat + 0.02 * bestFlat)

  -- the drift rate was inferred, as content
  (mp, _) <- mapProgram agD
  assertEqual "MAP program on the drifting world" t3MapProgram mp

-- ---------------------------------------------------------------------
-- TEST 4: the deletion audit
-- ---------------------------------------------------------------------

-- | The cond-deletion row, with no mock machinery: belief never moves,
-- so fold the stream REUSING the initial agent while the clock (an
-- ordinary feature) advances. Equivalent to the Python reference's
-- @Agent(models, disabled=("cond",))@: the meta stays the prior, every
-- hmm latent stays uniform, and time-indexed sentences still vary with
-- the passed tick.
frozenLogloss :: [Obs] -> Double
frozenLogloss ys =
  let ag0 = mkAgent (enumerateModels allTerminals)
  in sum [ fst (stepAgent t y ag0) | (t, y) <- zip [0 ..] ys ]

-- | One raises-by-type row: push/argmax deletion is a compile-time
-- fact. audit/ablation.sh (single source, also gate 7) checks three
-- things: the fixture compiles against the real grammar (positive
-- control), FAILS to compile under the DROP_* flag, and the compile
-- error names the deleted constructor. Bare "compilation failed" is not
-- a pass.
ablationRow :: String -> Assertion
ablationRow row = do
  (rc, out, err) <- readProcessWithExitCode "sh" ["audit/ablation.sh", row] ""
  assertEqual ("deletion audit (raises-by-type) row '" ++ row ++ "':\n"
               ++ out ++ err)
              ExitSuccess rc

test4 :: Assertion
test4 = do
  let drift250 = take 250 drift400
      llFrozen = frozenLogloss shifted160
      (llFull, _)  = runWorld allTerminals shifted160
      (llNoif, _)  = runWorld [TBern, THmm, TC, TGet, TGt] shifted160
      (llNoget, _) = runWorld [TBern, THmm, TC, TIf, TGt] shifted160
      (llFullD, _) = runWorld allTerminals drift250
      (llNohmm, _) = runWorld [TBern, TIf, TC, TGet, TGt] drift250

  assertEqual "full grammar enumerates 1169 hypotheses"
              t4NFull (length (enumerateModels allTerminals))

  -- cond: remove the update rule; belief never moves
  assertApprox "cond deleted: log-loss (bits)" tolBits t4LlFrozen llFrozen
  assertApprox "full grammar: log-loss (bits)" tolBits t4LlFull llFull
  assertBool "cond deletion costs > 10 bits" (llFrozen > llFull + 10)

  -- if: change-points become unsayable
  assertApprox "if deleted: log-loss (bits)" tolBits t4LlNoif llNoif
  assertBool "if deletion costs > 3 bits" (llNoif > llFull + 3)

  -- get: programs cannot read the world; closed loop broken
  assertApprox "get deleted: log-loss (bits)" tolBits t4LlNoget llNoget
  assertBool "get deletion costs > 3 bits" (llNoget > llFull + 3)

  -- rw/hmm: drift becomes unsayable
  assertApprox "full grammar, drifting world: log-loss (bits)"
               tolBits t4LlFullD llFullD
  assertApprox "hmm deleted: log-loss (bits)" tolBits t4LlNohmm llNohmm
  assertBool "hmm deletion costs > 3 bits" (llNohmm > llFullD + 3)

  -- c (priced grids): no sayable constants -> nothing sayable
  assertEqual "c deleted: hypothesis space empties"
              t4NNoc (length (enumerateModels [TBern, THmm, TIf, TGet, TGt]))

  -- bern: no emission vocabulary, no contact with data
  assertEqual "bern deleted: no program can generate data"
              t4NNobern (length (enumerateModels [TIf, TC, TGet, TGt]))

  -- push / argmax: unutterable by type (code-level ablation, gate 7)
  ablationRow "push"
  ablationRow "argmax"
