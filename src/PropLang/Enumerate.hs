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
  , renderExpr
  , enumerateModels
  , enumerateModelsIn
  , modelBits
  , Obs
  , obsSpace, thetaSpace
#ifndef DROP_CARRIER_OBS
  , obsCarrier
#endif
  -- the scoring layer dies with the basis or with the carrier
  -- declaration (plan E9): delete expfam — or the declared output
  -- space — and sentences stay sayable but NOTHING can assign
  -- likelihood; the agent cannot exist
#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS)
  , emit
  , Agent
  , mkAgent
  , predictive
  , observe
  , agentMeta
  , agentModels
#ifndef DROP_UPILOT
  -- the latent-utility fragment's type surface (HOSTS_D_PACK Task 1;
  -- the arithmetic lands only after the author's freeze)
  , TauSpec
  , mkTauSpec
  , UFamily (..)
  , allUFamilies
  , enumerateUModels
  , verdictKernel
  , latentMarginal
#endif
#endif
  ) where

import Data.List (elemIndex)
import Data.List.NonEmpty (NonEmpty ((:|)), nonEmpty, toList)

import PropLang.Belief (Belief, Bits (Bits), Evidence (Saw), Kernel,
                        LogProb, Space, cond, fromBits, kernel, logPredict,
                        mkSpace, push, uniform)
import PropLang.Eval (Features, Vals (VNil), evalx, mkEnv)
#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS)
import PropLang.Eval (bernFast)
import PropLang.Syntax (carrierSpace)
#endif
import PropLang.Syntax (Carrier, Expr (..), Grid, Idx (..), Name,
                        Namespace, StdName (..), Args (..), Stats (..),
                        carrierName, gridName, gridSize, mkC, mkCarrier,
                        mkGrid, mkNamespace, nsSize)

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
-- rendering by match. Every hypothesis carries its description length,
-- charged at the derivation (design §5, plan R4): dl is relative to
-- the model fragment's own production grammar, not the policy
-- pricer's. Abstract to consumers.
data Model
  = MBern Bits (Expr '[] Double)
  | MHmm Bits (Expr '[] Double)

-- | Canonical rendering, byte-identical to the Python reference's repr,
-- e.g. @"('hmm', ('c', 'rho', 3))"@. The frozen tests assert MAP
-- programs against these exact strings.
renderModel :: Model -> String
renderModel (MBern _ p) = "('bern', " ++ renderExpr p ++ ")"
renderModel (MHmm _ e)  = "('hmm', " ++ renderExpr e ++ ")"

-- | Rendering is total over the grammar; only the model fragment's
-- shapes are ever asserted against the frozen oracle. Exported since
-- the expfam increment (additive) so the increment oracle can pin the
-- new nodes' strings.
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
#ifndef DROP_EXPFAM
  ExpFam _ car st -> "('expfam', '" ++ carrierName car ++ "', '"
                       ++ statsStr st ++ "')"
#endif
#ifndef DROP_USAY
  USay p     -> "('usay', " ++ renderExpr p ++ ")"
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
#ifndef DROP_LADDER
    stdNameStr VThinkK = "VThinkK"
#endif
#ifndef DROP_VPRE
    stdNameStr VPre = "VPre"
#endif
#if !defined(DROP_BERN) && !defined(DROP_EXPFAM)
    stdNameStr Bern {} = "bern"
#endif
    statsStr :: Stats c' -> String
    statsStr s = case s of
#ifndef DROP_SID
      SId -> "id"
#endif

-- The description length of a hypothesis: its ONLY prior contribution
-- (design §5), charged at the derivation and stored on the hypothesis
-- (plan R4).
modelBits :: Model -> Bits
modelBits (MBern dl _) = dl
modelBits (MHmm dl _)  = dl

-- | Enumerate the model fragment to depth 1 (the Cromwell frontier) from
-- the allowed terminal set. Order and count match the Python reference
-- (full set: 1169 sentences under the current grids): the constant
-- Bernoullis, then the walks, then the change-point sentences with the
-- threshold outermost. Since the membrane increment this is the
-- singleton-namespace, no-extra-guards case of 'enumerateModelsIn' —
-- one generator, one arithmetic, no drift; the frozen anchors keep it
-- honest and the membrane oracle pins the identity.
enumerateModels :: [Terminal] -> [Model]
enumerateModels = enumerateModelsIn (mkNamespace ("t" :| [])) []

-- | Namespace-relative enumeration (MEMBRANE_PLAN T1/M1; the namespace
-- law, spec §3): the model fragment with (a) the name-mention term
-- inside every guard charged @log2 |ns|@ against the world's declared
-- namespace, and (b) the guard family extended by the given extra
-- (name, threshold grid) pairs, in declaration order after the
-- built-in @("t", tau)@ family.
enumerateModelsIn :: Namespace -> [(Name, Grid)] -> [Terminal] -> [Model]
enumerateModelsIn ns extras allowed =
    consts ++ walks ++ concatMap guardFamily (("t", tauGrid) : extras)
  where
    has t = t `elem` allowed
    -- every constant enters through the grammar's only door; the
    -- index range IS the grid, so completeness is the frozen 1169
    -- count plus the hygiene dl pins (R8)
    onGrid g = [ e | k <- [0 .. gridSize g - 1], Just e <- [mkC g k] ]
    thetaCs = onGrid thetaGrid :: [Expr '[] Double]
    -- description lengths, charged at the derivation choice points
    -- (design §5; plan R4). The addition trees are term-for-term the
    -- arithmetic the parity-phase pricer produced — the anchors'
    -- byte-stability lives in these parentheses:
    --   mention  = constant-choice bit + grid index
    --   constant = model bit + mention(theta)
    --   walk     = model bit + rho index (no param-alternative bit,
    --              amended design.md §5)
    --   guard    = model bit + (if bit + guard head + two theta
    --              mentions), head = (Get bit + log2 |ns|) +
    --              mention(threshold grid) — the frozen dlChange with
    --              the namespace charge as data (0 while singleton)
    mention g = 1 + logBase 2 (fromIntegral (gridSize g))
    nsB :: Double
    nsB = case nsSize ns of
      1 -> 0
      k -> logBase 2 (fromIntegral k)
    dlConst, dlWalk :: Double
    dlConst  = 1 + mention thetaGrid
    dlWalk   = 1 + logBase 2 (fromIntegral (gridSize rhoGrid))
    dlGuard g = 1 + (((1 + ((1 + nsB) + mention g))
                      + mention thetaGrid) + mention thetaGrid)
    consts =
      [ MBern (Bits dlConst) e
      | has TBern, has TC, e <- thetaCs ]
    walks =
      [ MHmm (Bits dlWalk) e
      | has THmm, has TC, e <- onGrid rhoGrid ]
    -- the reference excludes the diagonal by index (k1 /= k2)
    guardFamily (nm, g) =
      [ MBern (Bits (dlGuard g)) (If (Gt (Get nm) tc) t1 t2)
      | has TBern, has TIf, has TC, has TGet, has TGt
      , tc <- onGrid g
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

#ifndef DROP_CARRIER_OBS
-- | The demonstration domain's declared carrier (EXPFAM_PLAN E4):
-- domain data like the grids, priced against the Syntax carrier
-- registry. The CPP flag is the deletion audit's carrier-declaration
-- ablation point (interface.md test E restricted to the code level:
-- delete the declaration and no expfam sentence can declare its
-- output space over observations).
obsCarrier :: Carrier Obs
obsCarrier = mkCarrier "obs" (0 :| [1])
#endif

thetaSpace :: Space Double
thetaSpace = mkSpace thetaPoints

#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS)
-- | The Bernoulli emission kernel theta -> Belief over the declared
-- obs carrier: since the expfam re-derivation (plan E7/Task 5) this IS
-- the derived name's fast form spread over the theta grid — one
-- arithmetic, no drift (test-expfam groups 4 and 7 pin the identity),
-- and the same float sequence the parity phase shipped.
emit :: Kernel Double Obs
emit = kernel thetaSpace (carrierSpace obsCarrier) (bernFast obsCarrier)

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
initHyp (MBern _ p) = HBern p
initHyp (MHmm _ e)  = HHmm (evalx e (mkEnv [] VNil)) (uniform thetaSpace)

-- One tick of one hypothesis at the given features: its predictive over
-- observations, and its absorb continuation (the walk conditions the
-- SAME one-step-pushed latent it predicted from, verb for verb as the
-- reference).
stepHyp :: Features -> HypState -> (Belief Obs, Obs -> Maybe HypState)
stepHyp feats h = case h of
  HBern p ->
    let th = evalx p (mkEnv feats VNil)
    in (bernFast obsCarrier th, \_ -> Just (HBern p))
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

#ifndef DROP_UPILOT
-- ---------------------------------------------------------------------
-- the latent-utility fragment (HOSTS_D_PACK §6/§9; increment D).
-- TYPE SURFACE ONLY at Task 1 (the prepost 2bf6c72 pattern): data
-- declarations are complete and real, arithmetic bodies are oracle-
-- phase stubs. The oracle (test-d/) compiles against these and runs
-- runtime-red; implementation lands only after the author's freeze.
-- ---------------------------------------------------------------------

-- | The declared owner-response apparatus (R-D9; residue grade III):
-- a tau grid plus DECLARED prior weights, marginalised inside
-- 'verdictKernel' and NEVER updated (Armstrong-Mindermann honored by
-- construction; the demand-gate that could ever change this is the
-- pack's promotion-proof table, not code). Abstract; built by the
-- validating constructor only.
data TauSpec = TauSpec Grid (NonEmpty Double)

-- | The one door into 'TauSpec': the declared weights must cover the
-- grid exactly (total, like 'mkC' — no partial spec is constructible).
mkTauSpec :: Grid -> NonEmpty Double -> Maybe TauSpec
mkTauSpec g ws
  | length (toList ws) == gridSize g = Just (TauSpec g ws)
  | otherwise                        = Nothing

-- | The utility fragment's generator sorts (the 'Terminal' analogue,
-- and the DROP_UWALK restricted-enumeration handle): 'UConst' = "the
-- utility parameter is grid constant c_k" (the MBern analogue);
-- 'UWalk' = "it drifts as a reflected walk at grid rate rho_u" (the
-- MHmm analogue — the hmm move on the pointer, enumerated as CONTENT;
-- HOSTS_PLAN 6.1).
data UFamily
  = UConst
#ifndef DROP_UWALK
  | UWalk
#endif
  deriving (Eq, Show)

allUFamilies :: [UFamily]
#ifndef DROP_UWALK
allUFamilies = [UConst, UWalk]
#else
allUFamilies = [UConst]
#endif

-- | Enumerate the utility fragment over a value grid and a drift-rate
-- grid from the allowed sorts, returning ordinary priced 'Model'
-- hypotheses (HOSTS_PLAN 6.2's sketch: 'Model' grows internally at
-- implementation; dl charged at the derivation like every sentence).
-- The emission the hypotheses' filtered states step through is the
-- DECLARED world channel (a kernel value, world data like the grids)
-- — 'verdictKernel' applied to a declared 'TauSpec' is the canonical
-- instance, and the frozen 'emit' is the CIRL worlds' degenerate one
-- (the degeneracy pins run through exactly that argument).
enumerateUModels :: Kernel Double Obs -> Grid -> Grid -> [UFamily] -> [Model]
enumerateUModels _ _ _ _ =
  error "enumerateUModels: unimplemented (oracle phase, HOSTS_D_PACK Task 1)"

-- | The tau-marginalised logistic owner over a declared VALUE grid:
-- a decision-free combinator u -> Belief over verdicts, the finite
-- mixture over the declared tau grid ('rw''s standard: total,
-- domain-independent). The value grid names the kernel's input
-- space — a kernel without a declared domain is unconstructible,
-- the mkC discipline at the channel.
verdictKernel :: Grid -> TauSpec -> Kernel Double Obs
verdictKernel _ _ =
  error "verdictKernel: unimplemented (oracle phase, HOSTS_D_PACK Task 1)"

-- | The meta-mixture readout onto the utility-parameter axis, built
-- from PUBLIC verbs only (no new Belief export — I1 intact): the
-- 'agentMeta' analogue for the pointer.
latentMarginal :: Agent -> Belief Double
latentMarginal _ =
  error "latentMarginal: unimplemented (oracle phase, HOSTS_D_PACK Task 1)"

#endif
#endif
-- end of the scoring layer (plan E9): everything from 'emit' down
-- requires the expfam basis and the declared obs carrier; without
-- them the model fragment still enumerates and renders — sentences
-- are sayable — but no likelihood can be assigned and no agent built.
