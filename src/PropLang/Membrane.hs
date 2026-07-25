{-# LANGUAGE DataKinds #-}
{-# LANGUAGE EmptyCase #-}
{-# LANGUAGE GADTs #-}
-- The membrane (Phase 2 of the exact re-founding; exact-freeze-r0).
-- Carried doctrines: ACTIONS ARE FEATURES (step 5 — the writable
-- names and their codebooks are the world's Menu; wait is every name
-- at its codebook's head, the option space's first element by
-- construction); actions enter the tick's stream with no lag (step 6
-- — evidence folds at feats ++ act); the scoring rule is
-- EXOGENOUS-READ (a candidate's EU reads the predictive at augmented
-- features with weights and latents untouched by the contemplation).
--
-- NEW AT THIS BOUNDARY — THE RE-HOMED SELECTION (opening ruling 3):
-- every candidate value is an Expect SENTENCE and every comparison is
-- the binary If/Gt choice sentence, iterated (CL-3: the challenger
-- displaces iff strictly greater); the host carries beliefs between
-- evaluations and never decides. The Double era's host-side fold
-- (its §1b classification deferred at step 6 and never resolved) is
-- DEAD — no fast path remains here to pin.
--
-- THE DOOR'S GEOMETRY (R5's consequence, recorded for the close
-- sitting): every intra-tick read carries a FULL assignment (the door
-- demands exact namespace coverage), so the per-candidate EU reads at
-- feats ++ candidate, and the reported predictive is at feats ++ act
-- — post-choice, pre-observation. Choice still precedes observation;
-- dormant reads died with the 0.0 default. Menu-less worlds (the
-- frozen oracle's) are byte-unchanged: feats alone covers.
--
-- Type derivations (§8c forward rule):
--   Menu      — the writable names with declared codebooks (step 5).
--   PureWorld — the test-side world harness (features now exact).
--   Pilot     — a simulated principal's declared policy.
--   TickTrace — a REPORT record: the loop is exact, the trace fields
--               are edge displays (PropLang.Report).
module PropLang.Membrane
  ( Menu
  , PureWorld (..)
  , Pilot (..)
  , TickTrace (..)
  , gridPoints
  , menuAssignments
  , reindexUtility
  , chooseEU
  , predictiveBelief
  , runEpisode
  ) where

import Data.List.NonEmpty (NonEmpty ((:|)))

import PropLang.Belief
import PropLang.Enumerate
import PropLang.Eval
import PropLang.Report (bitsView, entropyAgent)
import PropLang.Syntax

type Menu = [(Name, Grid)]

data PureWorld s = PureWorld
  { wFeats :: s -> Features
  , wEvidence :: s -> Maybe Int
  , wMenu :: s -> Menu
  , wStep :: s -> Features -> s
  }

data Pilot
  = PilotIdle
  | PilotEU (Expr '[Rational, Rational] Rational)

data TickTrace = TickTrace
  { ttT :: Int
  , ttP1 :: Double
  , ttEntropy :: Double
  , ttAct :: Features
  , ttLossBits :: Double
  }

-- | A codebook's points, read through the one door (the C pattern —
-- declared data, never re-typed).
gridPoints :: Grid -> [Rational]
gridPoints g =
  [ v | k <- [0 .. gridSize g - 1], Just (C _ _ v) <- [mkC g k] ]

-- | Every full assignment of the menu (the step-5 shape): the
-- cartesian product of the declared codebooks, declaration order; the
-- empty menu's one assignment is wait.
menuAssignments :: Menu -> [Features]
menuAssignments = foldr row [[]]
  where
    row (nm, g) rest = [ (nm, v) : asn | v <- gridPoints g, asn <- rest ]

-- | Re-mint a mention through the door (total on mentions that came
-- FROM the door — the source expression's own invariant).
reMint :: Grid -> Ix -> Expr env Rational
reMint g k = case mkC g k of
  Just e -> e
  Nothing -> error "reMint: off-codebook (unreachable: source was on-codebook)"

-- | The wire's utility convention is a sentence over
-- [option-code, outcome] with Var Z the option code, bound to the
-- CONSTANT 0 (the dispositions-sitting fact). Under Expect the
-- outcome binds at Z, so the utility REINDEXES: the option code
-- becomes an explicit mention of the obs zero atom (the convention
-- made visible as syntax); the outcome moves to Z. A total structural
-- map over the wire-sayable grammar — host-side syntax transport,
-- like the parser that built the sentence.
reindexUtility :: Grid
               -> Expr '[Rational, Rational] Rational
               -> Expr (Rational ': env) Rational
reindexUtility atomG = go
  where
    zeroM :: Expr env' Rational
    zeroM = reMint atomG 0
    go :: Expr '[Rational, Rational] Rational
       -> Expr (Rational ': env') Rational
    go e = case e of
      C g k _ -> reMint g k
      Get nm -> Get nm
      Var Z -> zeroM
      Var (S Z) -> Var Z
      Var (S (S ix)) -> case ix of {}
      If c a b -> If (goB c) (go a) (go b)
      Sub a b -> Sub (go a) (go b)
      Mul a b -> Mul (go a) (go b)
      Expect {} -> error "reindexUtility: Expect is not wire-sayable (unreachable)"
      Cond {} -> error "reindexUtility: Cond is not wire-sayable (unreachable)"
    goB :: Expr '[Rational, Rational] Bool
        -> Expr (Rational ': env') Bool
    goB e = case e of
      Gt a b -> Gt (go a) (go b)
      If c a b -> If (goB c) (goB a) (goB b)
      Var ix -> case ix of
        S (S ix') -> case ix' of {}
      Cond {} -> error "reindexUtility: Cond is not wire-sayable (unreachable)"

-- | THE SELECTION: CL-3 as the binary choice sentence, iterated. The
-- door serves the sentence the same features the candidates were
-- scored under (exact coverage of the declared namespace).
chooseEU :: Namespace -> Features -> Grid
         -> Expr '[Rational, Rational] Rational
         -> [(Features, Belief Int)]
         -> Either String (Maybe (Features, Belief Int))
chooseEU ns feats atomG u cands = case cands of
  [] -> Right Nothing
  (c0 : rest) -> Just <$> foldl' step (Right c0) rest
  where
    uB :: Expr (Rational ': env) Rational
    uB = reindexUtility atomG u
    pick :: Expr '[B Int, B Int] Rational
    pick =
      let vC = Expect (Var Z) uB
          vI = Expect (Var (S Z)) uB
      in If (Gt vC vI) (reMint atomG 1) (reMint atomG 0)
    step acc chal@(cFeats, bC) = do
      inc@(_, bI) <- acc
      env <- mkEnvIn ns (feats' cFeats) (bC :. bI :. VNil)
      pure (if evalx pick env == 1 then chal else inc)
      where
        -- the sentence reads no features, but the door's law is
        -- coverage: serve it the challenger's own scored assignment
        feats' c = mergeCover c
    mergeCover c = feats ++ [ p | p <- c, fst p `notElem` map fst feats ]

-- | The predictive BELIEF over the obs carrier at given features —
-- the EXOGENOUS-READ (weights and latents untouched): a derived,
-- normalized view of the per-outcome exact masses.
predictiveBelief :: Features -> AgentS -> Either String (Belief Int)
predictiveBelief feats ag = do
  let pts = agentObsPoints ag
  ms <- mapM (\y -> predictMassS feats y ag) pts
  case pts of
    [] -> Left "predictive: empty obs carrier (unreachable)"
    (p : ps) ->
      case fromWeights (mkSpace (p :| ps))
             (\y -> sum [ m | (y', m) <- zip pts ms, y' == y ]) of
        Just b -> Right b
        Nothing -> Left "predictive: no mass (every hypothesis refused)"

-- | One library episode over a pure world (the frozen loop's order,
-- under the door's geometry): candidates scored EXOGENOUSLY at
-- feats ++ candidate; the winner chosen through the sentences; the
-- trace's predictive read at feats ++ act (post-choice,
-- pre-observation); evidence folded at feats ++ act. Left on any
-- door refusal (fail-closed).
runEpisode :: World -> Pilot -> PureWorld s -> s -> Int
           -> Either String [TickTrace]
runEpisode w pilot pw s0 nTicks =
  go s0 (sentenceAgent ns (enumerate w fragFull)) 0 []
  where
    ns = wNs w
    atomG = atomGridOf (wObs w)
    go _ _ t acc | t >= nTicks = Right (reverse acc)
    go s ag t acc = do
      let feats = wFeats pw s
          menu = wMenu pw s
          cands = menuAssignments menu
      act <- case pilot of
        PilotIdle -> Right (waitOf menu)
        PilotEU u -> do
          scored <- mapM (\c -> do
                      b <- predictiveBelief (feats ++ c) ag
                      Right (c, b))
                    cands
          picked <- chooseEU ns feats atomG u scored
          Right (maybe (waitOf menu) fst picked)
      let full = feats ++ act
      p1 <- predictMassS full 1 ag
      let h = entropyAgent ag
      (loss, ag') <- case wEvidence pw s of
        Nothing -> Right (1, ag)
        Just y -> observeS full y ag
      let tr = TickTrace t (fromRational p1) h act (bitsView loss)
      go (wStep pw s full) ag' (t + 1) (tr : acc)
    -- wait: every menu name at its codebook's head (step 5, structural)
    waitOf menu = case menuAssignments menu of
      (w0 : _) -> w0
      [] -> []
