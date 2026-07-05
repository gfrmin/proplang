{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

-- | The model fragment and the agent (typed-port-spec §6): enumeration to
-- the Cromwell frontier (depth-1 in @if@; a parameter of the
-- implementation, not the language), and the belief-over-programs agent
-- moved only by the verbs. No adaptation code exists here — that is the
-- point, and audit gate 4 checks it.
--
-- The clock is externalized: callers pass the tick as an ordinary feature
-- @[("t", t)]@ (interface.md §5, the host's tick echo) — a deliberate,
-- reviewed deviation from the Python reference's internal @self.t@.
-- There is no @disabled@ knob: deletion audits ablate the grammar itself
-- (gate 7) or restrict enumeration; they never mock.
--
-- A hypothesis's parameter IS a sentence of the real grammar
-- ("PropLang.Syntax") and is evaluated by the real evaluator with the
-- tick features — hypotheses are programs, not a parallel encoding.
module PropLang.Enumerate
  ( Terminal(..)
  , allTerminals
  , Model
  , renderModel
  , enumerateModels
  , Obs
  , obsSpace, thetaSpace, emit
  , Agent
  , mkAgent
  , predictive
  , observe
  , agentMeta
  , agentModels
  ) where

import Data.List (elemIndex)
import Data.List.NonEmpty (NonEmpty ((:|)), nonEmpty, toList)

import PropLang.Belief (Belief, Bits (Bits), Evidence (Saw), Kernel,
                        LogProb, Space, cond, fromBits, kernel, logPredict,
                        mkSpace, push, uniform)
import PropLang.Eval (Features, Vals (VNil), evalx, mkEnv)
import PropLang.Syntax (Expr (..), Grid, Idx (..), StdName (..),
                        Args (..), bits, gridName, gridSize, mkC, mkGrid)

-- | The model-fragment terminals, for restricted enumeration in the
-- deletion audit (deleting a terminal = enumerating without it).
data Terminal = TBern | THmm | TIf | TGt | TGet | TC
  deriving (Eq, Show)

allTerminals :: [Terminal]
allTerminals = [TBern, THmm, TIf, TGt, TGet, TC]

-- ---------------------------------------------------------------------
-- the priced grids (data with prices, design §5 — the only numeric
-- content of the model fragment)
-- ---------------------------------------------------------------------

thetaPoints :: NonEmpty Double
thetaPoints = 0.1 :| [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]

tauPoints :: NonEmpty Double
tauPoints = 5 :| [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80]

rhoPoints :: NonEmpty Double
rhoPoints = 0.01 :| [0.02, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5]

thetaGrid, tauGrid, rhoGrid :: Grid
thetaGrid = mkGrid "theta" thetaPoints
tauGrid   = mkGrid "tau" tauPoints
rhoGrid   = mkGrid "rho" rhoPoints

-- ---------------------------------------------------------------------
-- hypotheses as programs
-- ---------------------------------------------------------------------

-- | A model-fragment sentence (a hypothesis): a Bernoulli emission whose
-- parameter is a closed sentence of the grammar, or a latent reflected
-- walk whose rate constant IS the sentence it is (R8 — Python's
-- @('hmm', ('c', 'rho', k))@ literally): rate value by evaluation,
-- rendering by match. The walk's description length is charged at the
-- derivation (design §5), so it rides along. Abstract to consumers.
data Model
  = MBern (Expr '[] Double)
  | MHmm Bits (Expr '[] Double)

-- | Canonical rendering, byte-identical to the Python reference's repr,
-- e.g. @"('hmm', ('c', 'rho', 3))"@. The frozen tests assert MAP
-- programs against these exact strings.
renderModel :: Model -> String
renderModel (MBern p)  = "('bern', " ++ renderExpr p ++ ")"
renderModel (MHmm _ e) = "('hmm', " ++ renderExpr e ++ ")"

-- Rendering is total over the grammar; only the model fragment's shapes
-- are ever asserted against the oracle.
renderExpr :: Expr env t -> String
renderExpr e0 = case e0 of
  C g k _    -> "('c', '" ++ gridName g ++ "', " ++ show k ++ ")"
  Get nm     -> "('get', '" ++ nm ++ "')"
  If c t e   -> "('if', " ++ renderExpr c ++ ", " ++ renderExpr t ++ ", "
                  ++ renderExpr e ++ ")"
  Gt a b     -> "('>', " ++ renderExpr a ++ ", " ++ renderExpr b ++ ")"
  Var ix     -> "('var', " ++ show (idxInt ix) ++ ")"
#ifndef DROP_PUSH
  Push a b   -> "('push', " ++ renderExpr a ++ ", " ++ renderExpr b ++ ")"
#endif
  CondE a b  -> "('cond', " ++ renderExpr a ++ ", " ++ renderExpr b ++ ")"
  Expect a _ -> "('expect', " ++ renderExpr a ++ ")"
#ifndef DROP_ARGMAX
  Argmax o v -> "('argmax', " ++ renderExpr o ++ ", " ++ renderExpr v ++ ")"
#endif
  Call sn as -> "('call', '" ++ stdNameStr sn ++ "'" ++ renderArgs as ++ ")"
  where
    idxInt :: Idx env' t' -> Int
    idxInt Z     = 0
    idxInt (S i) = 1 + idxInt i
    renderArgs :: Args env' ts -> String
    renderArgs ANil      = ""
    renderArgs (a :* as) = ", " ++ renderExpr a ++ renderArgs as
    stdNameStr :: StdName args t' -> String
    stdNameStr EU     = "EU"
    stdNameStr IsEq   = "IsEq"
    stdNameStr VAct   = "VAct"
    stdNameStr VThink = "VThink"

-- The description length of a hypothesis: its ONLY prior contribution
-- (design §5). Bernoulli sentences carry the grammar's price; the hmm's
-- dl is charged at the derivation (one MODEL choice bit + the grid
-- index — no PARAM-alternative bit, per the amended design.md §5) and
-- stored on the hypothesis.
modelBits :: Model -> Bits
modelBits (MBern p)   = 1 + bits p
modelBits (MHmm dl _) = dl

-- | Enumerate the model fragment to depth 1 (the Cromwell frontier) from
-- the allowed terminal set. Order and count match the Python reference
-- (full set: 1169 sentences under the current grids): the constant
-- Bernoullis, then the walks, then the change-point sentences with the
-- threshold outermost.
enumerateModels :: [Terminal] -> [Model]
enumerateModels allowed = consts ++ walks ++ changePoints
  where
    has t = t `elem` allowed
    -- every constant enters through the grammar's only door; the
    -- index range IS the grid, so completeness is the frozen 1169
    -- count plus the hygiene dl pins (R8)
    onGrid g = [ e | k <- [0 .. gridSize g - 1], Just e <- [mkC g k] ]
    thetaCs = onGrid thetaGrid :: [Expr '[] Double]
    consts =
      [ MBern e
      | has TBern, has TC, e <- thetaCs ]
    walks =
      [ MHmm (Bits (1 + logBase 2 (fromIntegral (gridSize rhoGrid)))) e
      | has THmm, has TC, e <- onGrid rhoGrid ]
    -- the reference excludes the diagonal by index (k1 /= k2)
    changePoints =
      [ MBern (If (Gt (Get "t") tc) t1 t2)
      | has TBern, has TIf, has TC, has TGet, has TGt
      , tc <- onGrid tauGrid
      , (k1, t1) <- indexed thetaCs
      , (k2, t2) <- indexed thetaCs
      , k1 /= k2 ]
    indexed = zip [0 :: Int ..]

-- ---------------------------------------------------------------------
-- the demonstration domain
-- ---------------------------------------------------------------------

-- | Observations of the demonstration domain ({0,1}).
type Obs = Int

obsSpace :: Space Obs
obsSpace = mkSpace (0 :| [1])

thetaSpace :: Space Double
thetaSpace = mkSpace thetaPoints

-- | The Bernoulli emission kernel theta -> Belief over {0,1}, built from
-- the only prior source (description lengths of the two outcomes).
emit :: Kernel Double Obs
emit = kernel thetaSpace obsSpace bernBelief

bernBelief :: Double -> Belief Obs
bernBelief th =
  fromBits obsSpace
    (\y -> Bits (negate (logBase 2 (if y == 1 then th else 1 - th))))

-- The reflected walk on the theta grid at a grid-priced rate: a
-- decision-free combinator, total and domain-independent (design §9).
-- Mass is a total function of grid POSITIONS: a point with no position
-- has mass 0, i.e. infinite description length through 'fromBits' —
-- the measure's own off-support statement, the same road every
-- non-neighbor grid point already travels. No error site (R8);
-- 'kernel' only ever applies 'step' to points of its own space.
walkKernel :: Double -> Kernel Double Double
walkKernel rho = kernel thetaSpace thetaSpace step
  where
    pts = toList thetaPoints
    n = length pts
    mass (Just i) (Just j) =
      (if j == i then 1 - rho else 0)
        + (if j == lo then rho / 2 else 0)
        + (if j == hi then rho / 2 else 0)
      where
        lo = if i > 0 then i - 1 else i + 1
        hi = if i < n - 1 then i + 1 else i - 1
    mass _ _ = 0
    step th =
      let mi = elemIndex th pts
      in fromBits thetaSpace
           (\p -> Bits (negate (logBase 2 (mass mi (elemIndex p pts)))))

-- ---------------------------------------------------------------------
-- the agent: a belief over programs, moved only by the verbs
-- ---------------------------------------------------------------------

-- Per-hypothesis filtered state: Bernoulli sentences are stateless; a
-- walk carries its rate and its current latent belief.
data HypState
  = HBern (Expr '[] Double)
  | HHmm Double (Belief Double)

-- | A belief over programs plus per-hypothesis filtered latent state.
data Agent = Agent [Model] [HypState] (Space Int) (Belief Int)

-- | The meta-prior is 2^(-description length), through the only prior
-- source. The frozen signature admits no failure value, so an empty
-- enumeration mirrors the reference's raise (unreachable from the
-- frozen suites, which take lengths before ever folding an agent).
mkAgent :: [Model] -> Agent
mkAgent ms = case nonEmpty [0 .. length ms - 1] of
  Nothing  -> error "mkAgent: empty model enumeration"
  Just ixs ->
    let dls = map modelBits ms
        isp = mkSpace ixs
    in Agent ms (map initHyp ms) isp (fromBits isp (dls !!))

-- The walk's rate is read by evaluating its rate sentence — a closed
-- constant of the real grammar, so the read is total and the parity
-- phase's off-grid error site is gone (R8).
initHyp :: Model -> HypState
initHyp (MBern p)  = HBern p
initHyp (MHmm _ e) = HHmm (evalx e (mkEnv [] VNil)) (uniform thetaSpace)

-- One tick of one hypothesis at the given features: its predictive over
-- observations, and its absorb continuation (the walk conditions the
-- SAME one-step-pushed latent it predicted from, verb for verb as the
-- reference).
stepHyp :: Features -> HypState -> (Belief Obs, Obs -> Maybe HypState)
stepHyp feats h = case h of
  HBern p ->
    let th = evalx p (mkEnv feats VNil)
    in (bernBelief th, \_ -> Just (HBern p))
  HHmm rho lat ->
    let predLat = push lat (walkKernel rho)
    in ( push predLat emit
       , \y -> HHmm rho <$> cond predLat (Saw emit y) )

-- | The one-tick-ahead predictive: push of the meta-belief along the
-- per-hypothesis step kernel at the given features.
predictive :: Features -> Agent -> Belief Obs
predictive feats (Agent _ hyps isp meta) =
  let preds = map (fst . stepHyp feats) hyps
  in push meta (kernel isp obsSpace (preds !!))

-- | One polling re-entry: returns the natural-log marginal likelihood of
-- the observation ('LogProb') and the conditioned agent. 'Nothing' =
-- impossible evidence (total, like 'PropLang.Belief.cond').
observe :: Features -> Obs -> Agent -> Maybe (LogProb, Agent)
observe feats y (Agent ms hyps isp meta) = do
  let stepped = map (stepHyp feats) hyps
      preds = map fst stepped
      ev = Saw (kernel isp obsSpace (preds !!)) y
      lp = logPredict meta ev
  meta' <- cond meta ev
  hyps' <- traverse (\(_, absorb) -> absorb y) stepped
  pure (lp, Agent ms hyps' isp meta')

-- | The meta-belief over hypothesis indices (positions in 'agentModels').
agentMeta :: Agent -> Belief Int
agentMeta (Agent _ _ _ meta) = meta

agentModels :: Agent -> [Model]
agentModels (Agent ms _ _ _) = ms
