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
  , enumerateModelsGrid
  , modelBits
  , Obs
  , obsSpace, thetaSpace
  -- the declared grids, exported for the step-1 oracle (AGENT_PLAN, boundary
  -- agent-boundary-r1). R-D20-i mandates that an oracle row claiming a frozen
  -- quantity be checked against THE FROZEN ARTIFACT, never against a parallel
  -- derivation of it — so test-code compares its code form to `walkOn`
  -- ITSELF, not to a transcription. Exporting is strictly safer than copying:
  -- no drift is possible.
  , thetaPoints, rhoPoints
#ifndef DROP_CARRIER_OBS
  , obsCarrier
#endif
  -- the scoring layer dies with the basis or with the carrier
  -- declaration (plan E9): delete expfam — or the declared output
  -- space — and sentences stay sayable but NOTHING can assign
  -- likelihood; the agent cannot exist
#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS)
  , emit
  -- the reflected walk, for the step-1 oracle to compare its code form
  -- against (R-D20-i). Guarded exactly as its DEFINITION is (:349) — an
  -- unconditional export made the DROP_CARRIER_OBS ablation fail on
  -- 'walkOn' instead of 'obsCarrier', breaking the deletion audit's
  -- attribution check. The audit caught it; that is what it is for.
  , walkOn
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
  , latentName
  , latentPoints
  , latentChannel
  , observeVia
  , observeCounts
#endif
#endif
  ) where

import Data.List (elemIndex)
import Data.List.NonEmpty (NonEmpty ((:|)), nonEmpty, toList)

import PropLang.Belief (Belief, Bits (Bits), Evidence (Saw), Kernel,
                        LogProb (LogProb), Space, cond, fromBits, is,
                        kernel, logPredict, mkSpace, point, prob, push,
                        uniform)
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

tauGrid, rhoGrid :: Grid
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
-- Since boundary E the emission hypotheses carry their value space —
-- the theta grid as declared world data, the MUConst/MUWalk pattern
-- (one shape, two instantiations); the walk additionally carries the
-- point list its reflected steps index.
data Model
  = MBern Bits (Expr '[] Double) (Space Double)
  | MHmm Bits (Expr '[] Double) (Space Double) (NonEmpty Double)
#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS) && !defined(DROP_UPILOT)
  -- the latent-utility sorts (increment D): a utility hypothesis
  -- carries the DECLARED emission channel it steps through (world
  -- data, the enumerateUModels argument) and its value space (the
  -- evaluated grid) — the sentence is still the only content
  | MUConst Bits (Expr '[] Double) (Kernel Double Obs) (Space Double)
            (NonEmpty Double) Name
#ifndef DROP_UWALK
  | MUWalk Bits (Expr '[] Double) (Kernel Double Obs) (Space Double)
           (NonEmpty Double) Name
#endif
#endif

-- | Canonical rendering, byte-identical to the Python reference's repr,
-- e.g. @"('hmm', ('c', 'rho', 3))"@. The frozen tests assert MAP
-- programs against these exact strings.
renderModel :: Model -> String
renderModel (MBern _ p _)  = "('bern', " ++ renderExpr p ++ ")"
renderModel (MHmm _ e _ _) = "('hmm', " ++ renderExpr e ++ ")"
#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS) && !defined(DROP_UPILOT)
renderModel (MUConst _ e _ _ _ _)  = "('uconst', " ++ renderExpr e ++ ")"
#ifndef DROP_UWALK
renderModel (MUWalk _ e _ _ _ _) = "('uwalk', " ++ renderExpr e ++ ")"
#endif
#endif

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
#ifndef DROP_CODE
  -- the Space payloads are opaque and priced 0; the RENDERED form carries
  -- only the code length's body, which is the whole of the content
  Code _ _ b -> "('code', " ++ renderExpr b ++ ")"
#endif
#ifndef DROP_POS
  Pos _ e'   -> "('pos', " ++ renderExpr e' ++ ")"
#endif
#ifndef DROP_TOR
  ToR e'     -> "('tor', " ++ renderExpr e' ++ ")"
#endif
  Add a b    -> "('+', " ++ renderExpr a ++ ", " ++ renderExpr b ++ ")"
  Sub a b    -> "('-', " ++ renderExpr a ++ ", " ++ renderExpr b ++ ")"
  Mul a b    -> "('*', " ++ renderExpr a ++ ", " ++ renderExpr b ++ ")"
  Div a b    -> "('/', " ++ renderExpr a ++ ", " ++ renderExpr b ++ ")"
  Log a      -> "('log', " ++ renderExpr a ++ ")"
  Exp a      -> "('exp', " ++ renderExpr a ++ ")"
  Neg a      -> "('neg', " ++ renderExpr a ++ ")"
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
modelBits (MBern dl _ _)  = dl
modelBits (MHmm dl _ _ _) = dl
#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS) && !defined(DROP_UPILOT)
modelBits (MUConst dl _ _ _ _ _)  = dl
#ifndef DROP_UWALK
modelBits (MUWalk dl _ _ _ _ _) = dl
#endif
#endif

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
enumerateModelsIn = enumerateModelsGrid thetaPoints

-- | Emission-grid-relative enumeration (boundary E): the theta grid is
-- world data like every other grid on the wire, and
-- 'enumerateModelsIn' is this function at the built-in linear grid —
-- byte-identical by construction. The grid is priced where it is
-- mentioned, so a declared grid of another size buys another model
-- count at another price; the handshake prints what was bought.
enumerateModelsGrid :: NonEmpty Double -> Namespace -> [(Name, Grid)]
                    -> [Terminal] -> [Model]
enumerateModelsGrid egPts ns extras allowed =
    consts ++ walks ++ concatMap guardFamily (("t", tauGrid) : extras)
  where
    eg = mkGrid "theta" egPts
    egSpace = mkSpace egPts
    has t = t `elem` allowed
    -- every constant enters through the grammar's only door; the
    -- index range IS the grid, so completeness is the frozen 1169
    -- count plus the hygiene dl pins (R8)
    onGrid g = [ e | k <- [0 .. gridSize g - 1], Just e <- [mkC g k] ]
    thetaCs = onGrid eg :: [Expr '[] Double]
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
    dlConst  = 1 + mention eg
    dlWalk   = 1 + logBase 2 (fromIntegral (gridSize rhoGrid))
    dlGuard g = 1 + (((1 + ((1 + nsB) + mention g))
                      + mention eg) + mention eg)
    consts =
      [ MBern (Bits dlConst) e egSpace
      | has TBern, has TC, e <- thetaCs ]
    walks =
      [ MHmm (Bits dlWalk) e egSpace egPts
      | has THmm, has TC, e <- onGrid rhoGrid ]
    -- the reference excludes the diagonal by index (k1 /= k2)
    guardFamily (nm, g) =
      [ MBern (Bits (dlGuard g)) (If (Gt (Get nm) tc) t1 t2) egSpace
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

-- The reflected walk on a value grid at a grid-priced rate: a
-- decision-free combinator, total and domain-independent (design §9).
-- Mass is a total function of grid POSITIONS: a point with no position
-- has mass 0, i.e. infinite description length through 'fromBits' —
-- the measure's own off-support statement, the same road every
-- non-neighbor grid point already travels. No error site (R8);
-- 'kernel' only ever applies 'step' to points of its own space. One
-- shape, every instantiation (boundary E): the hmm family walks on its
-- carried emission grid exactly as the utility fragment's UWalk walks
-- on its declared value grid.
walkOn :: Space Double -> NonEmpty Double -> Double -> Kernel Double Double
walkOn vs vpts rho = kernel vs vs step
  where
    pts = toList vpts
    n = length pts
    mass (Just i) (Just j) =
      (if j == i then 1 - rho else 0)
        + (if j == lo then rho / 2 else 0)
        + (if j == hi then rho / 2 else 0)
      where
        lo = if i > 0 then i - 1 else i + 1
        hi = if i < n - 1 then i + 1 else i - 1
    mass _ _ = 0
    step v =
      let mi = elemIndex v pts
      in fromBits vs
           (\p -> Bits (negate (logBase 2 (mass mi (elemIndex p pts)))))

-- ---------------------------------------------------------------------
-- the agent: a belief over programs, moved only by the verbs
-- ---------------------------------------------------------------------

-- Per-hypothesis filtered state: Bernoulli sentences are stateless
-- (their carried value space serves the supplied-kernel verbs); a
-- walk carries its value space and points, its rate, and its current
-- latent belief.
data HypState
  = HBern (Space Double) (Expr '[] Double)
  | HHmm (Space Double) (NonEmpty Double) Double (Belief Double)
#ifndef DROP_UPILOT
  -- a utility hypothesis's filtered state: the carried channel, the
  -- value space, and (constant) the value / (walk) rate + latent
  | HUConst (Kernel Double Obs) (Space Double) Double
#ifndef DROP_UWALK
  | HUWalk (Kernel Double Obs) (Space Double) (NonEmpty Double) Double
           (Belief Double)
#endif
#endif

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
initHyp (MBern _ p sp)    = HBern sp p
initHyp (MHmm _ e sp pts) =
  HHmm sp pts (evalx e (mkEnv [] VNil)) (uniform sp)
#ifndef DROP_UPILOT
initHyp (MUConst _ e k vs _ _)  = HUConst k vs (evalx e (mkEnv [] VNil))
#ifndef DROP_UWALK
initHyp (MUWalk _ e k vs pts _) =
  HUWalk k vs pts (evalx e (mkEnv [] VNil)) (uniform vs)
#endif
#endif

-- One tick of one hypothesis at the given features: its predictive over
-- observations, and its absorb continuation (the walk conditions the
-- SAME one-step-pushed latent it predicted from, verb for verb as the
-- reference).
stepHyp :: Features -> HypState -> (Belief Obs, Obs -> Maybe HypState)
stepHyp feats h = case h of
  HBern sp p ->
    let th = evalx p (mkEnv feats VNil)
    in (bernFast obsCarrier th, \_ -> Just (HBern sp p))
  HHmm sp pts rho lat ->
    let predLat = push lat (walkOn sp pts rho)
    in ( push predLat emit
       , \y -> HHmm sp pts rho <$> cond predLat (Saw emit y) )
#ifndef DROP_UPILOT
  HUConst k vs v ->
    (push (point vs v) k, \_ -> Just (HUConst k vs v))
#ifndef DROP_UWALK
  HUWalk k vs pts rho lat ->
    let predLat = push lat (walkOn vs pts rho)
    in ( push predLat k
       , \y -> HUWalk k vs pts rho <$> cond predLat (Saw k y) )
#endif
#endif

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
enumerateUModels k vg rg fams =
    [ MUConst (Bits dlUConst) e k vspace vpoints (gridName vg)
    | UConst <- fams, e <- onGrid vg ]
#ifndef DROP_UWALK
    ++ [ MUWalk (Bits dlUWalk) e k vspace vpoints (gridName vg)
       | UWalk <- fams, e <- onGrid rg ]
#endif
  where
    -- the derivation charges, in the model fragment's own shape
    -- (enumerateModelsIn's arithmetic, instantiated on the declared
    -- grids): a constant = sort bit + mention(value grid); a walk =
    -- sort bit + rate index (no param-alternative bit, the dlWalk
    -- precedent)
    onGrid g = [ e | j <- [0 .. gridSize g - 1], Just e <- [mkC g j] ]
    mention g = 1 + logBase 2 (fromIntegral (gridSize g))
    dlUConst = 1 + mention vg
#ifndef DROP_UWALK
    dlUWalk  = 1 + logBase 2 (fromIntegral (gridSize rg))
#endif
    vals = [ evalx e (mkEnv [] VNil) | e <- onGrid vg ]
    vpoints = case nonEmpty vals of
      Just ne -> ne
      Nothing -> error "enumerateUModels: grids are nonempty by construction"
    vspace = mkSpace vpoints

-- | The tau-marginalised logistic owner over a declared VALUE grid:
-- a decision-free combinator u -> Belief over verdicts, the finite
-- mixture over the declared tau grid ('rw''s standard: total,
-- domain-independent). The value grid names the kernel's input
-- space — a kernel without a declared domain is unconstructible,
-- the mkC discipline at the channel.
verdictKernel :: Grid -> TauSpec -> Kernel Double Obs
verdictKernel vg (TauSpec tg ws) =
    kernel vspace (carrierSpace obsCarrier)
           (bernFast obsCarrier . pApprove)
  where
    onGrid g = [ e | j <- [0 .. gridSize g - 1], Just e <- [mkC g j] ]
    taus = [ evalx e (mkEnv [] VNil) | e <- onGrid tg ]
    wl = toList ws
    sigma x = 1 / (1 + exp (negate x))
    pApprove u =
      sum (zipWith (\w tau -> w * sigma (u / tau)) wl taus) / sum wl
    vspace = mkSpace $ case nonEmpty [ evalx e (mkEnv [] VNil)
                                     | e <- onGrid vg ] of
      Just ne -> ne
      Nothing -> error "verdictKernel: grids are nonempty by construction"

-- | The meta-mixture readout onto the utility-parameter axis, built
-- from PUBLIC verbs only (no new Belief export — I1 intact): the
-- 'agentMeta' analogue for the pointer.
latentMarginal :: Agent -> Belief Double
latentMarginal (Agent _ hyps isp meta) =
  case [ vs | h <- hyps, vs <- hypVSpace h ] of
    vs : _ -> push meta (kernel isp vs (valueBelief . (hyps !!)))
    []     -> error "latentMarginal: the agent carries no utility hypotheses"
  where
    hypVSpace h = case h of
      HUConst _ vs _ -> [vs]
#ifndef DROP_UWALK
      HUWalk _ vs _ _ _ -> [vs]
#endif
      _ -> []
    valueBelief h = case h of
      HUConst _ vs v -> point vs v
#ifndef DROP_UWALK
      HUWalk _ _ _ _ lat -> lat
#endif
      _ -> error "latentMarginal: mixed agent (world hypothesis has no value axis)"

-- The declarations a utility agent was BUILT FROM, read back for the
-- driver (observability of world data, not of belief internals — the
-- Belief export list is untouched, I1/I2 intact): the value grid's
-- name (the name-keyed pricing surface, rider 1's upPrice mechanism),
-- its points, and the carried emission channel. Total on any agent
-- holding at least one utility hypothesis; the driver never builds
-- the pair machinery without one.
firstU :: Agent -> Model
firstU (Agent ms _ _ _) =
  case [ m | m@MUConst {} <- ms ] of
    m : _ -> m
    []    ->
#ifndef DROP_UWALK
      case [ m | m@MUWalk {} <- ms ] of
        m : _ -> m
        []    -> error "latent accessors: no utility hypotheses"
#else
      error "latent accessors: no utility hypotheses"
#endif

latentName :: Agent -> Name
latentName ag = case firstU ag of
  MUConst _ _ _ _ _ nm -> nm
#ifndef DROP_UWALK
  MUWalk _ _ _ _ _ nm  -> nm
#endif
  _ -> error "latent accessors: no utility hypotheses"

latentPoints :: Agent -> NonEmpty Double
latentPoints ag = case firstU ag of
  MUConst _ _ _ _ pts _ -> pts
#ifndef DROP_UWALK
  MUWalk _ _ _ _ pts _  -> pts
#endif
  _ -> error "latent accessors: no utility hypotheses"

latentChannel :: Agent -> Kernel Double Obs
latentChannel ag = case firstU ag of
  MUConst _ _ k _ _ _ -> k
#ifndef DROP_UWALK
  MUWalk _ _ k _ _ _  -> k
#endif
  _ -> error "latent accessors: no utility hypotheses"

-- | The count-collapsed warm verb (wire v2's @observe_counts@; the
-- second review's budget ruling): per-hypothesis likelihood
-- EXPONENTIATION from (n1, n0) — each hypothesis's predictive is
-- computed ONCE and its log-likelihood scaled by the counts, folded
-- into the meta-belief through one synthetic evidence (a kernel
-- whose emission probability at the observed token IS the max-scaled
-- collapsed likelihood — public verbs only, the Belief export list
-- untouched). EXACT for exchangeable (iid-emission) hypotheses; for
-- state-carrying ones (hmm / UWalk) this IS the declared
-- warm-flattening approximation — the latent is NOT advanced per
-- collapsed tick, printed rather than smuggled. The returned
-- 'LogProb' re-adds the max-scaling constant, so the collapsed
-- EVIDENCE is exact exactly where the posterior is: the rescale is
-- per-call and tracked, never visible downstream — prequential bits
-- read off a counts-collapsed stream carry no scaling artifact (the
-- Task-3 report review's evidence-scaling question, answered by
-- transcript 2026-07-10). O(hypotheses), not
-- O(ticks). The optional kernel routes the collapse through a
-- supplied emission (the outcome channel), 'observeVia''s
-- discipline.
observeCounts :: Maybe (Kernel Double Obs) -> Features -> Int -> Int
              -> Agent -> Maybe (LogProb, Agent)
observeCounts mk feats n1 n0 (Agent ms hyps isp meta) = do
  let predOf h = case mk of
        Nothing -> fst (stepHyp feats h)
        Just kv -> case h of
          HBern sp p ->
            push (point sp (evalx p (mkEnv feats VNil))) kv
          HHmm sp pts rho lat -> push (push lat (walkOn sp pts rho)) kv
          HUConst _ vs v -> push (point vs v) kv
#ifndef DROP_UWALK
          HUWalk _ vs pts rho lat -> push (push lat (walkOn vs pts rho)) kv
#endif
      preds = map predOf hyps
      logL pd =
        let p1 = prob pd (is obsSpace 1)
            p0 = prob pd (is obsSpace 0)
            lg1 = if p1 > 0 then log p1 else negInfD
            lg0 = if p0 > 0 then log p0 else negInfD
            term n l = if n == 0 then 0 else fromIntegral n * l
        in term n1 lg1 + term n0 lg0
      lls = map logL preds
      m = maximum lls
      scaled = [ if m > negInfD then exp (ll - m) else 0 | ll <- lls ]
      synthSp = mkSpace (True :| [False])
      synth = kernel isp synthSp $ \i ->
        let l = scaled !! i
        in fromBits synthSp
             (\b -> Bits (negate (logBase 2 (if b then l else 1 - l))))
      ev = Saw synth True
      LogProb lp = logPredict meta ev
  meta' <- cond meta ev
  pure (LogProb (lp + m), Agent ms hyps isp meta')
  where
    negInfD = -1 / 0

-- | 'observe' through a SUPPLIED emission (the outcome channel's
-- verb, HOSTS_D_PACK §8: outcome ticks condition the pointer through
-- their own declared kernel, not the hypothesis's carried one). Each
-- hypothesis's current latent belief is pushed through the given
-- kernel for its predictive; walks advance their latent exactly as in
-- 'stepHyp' — one evidence flow, a different declared channel.
observeVia :: Kernel Double Obs -> Features -> Obs -> Agent
           -> Maybe (LogProb, Agent)
observeVia kv feats y (Agent ms hyps isp meta) = do
  let stepped = map via hyps
      preds = map fst stepped
      ev = Saw (kernel isp obsSpace (preds !!)) y
      lp = logPredict meta ev
  meta' <- cond meta ev
  hyps' <- traverse (\(_, absorb) -> absorb y) stepped
  pure (lp, Agent ms hyps' isp meta')
  where
    via h = case h of
      HBern sp p ->
        let th = evalx p (mkEnv feats VNil)
        in (push (point sp th) kv, \_ -> Just (HBern sp p))
      HHmm sp pts rho lat ->
        let predLat = push lat (walkOn sp pts rho)
        in ( push predLat kv
           , \o -> HHmm sp pts rho <$> cond predLat (Saw kv o) )
      HUConst k vs v ->
        (push (point vs v) kv, \_ -> Just (HUConst k vs v))
#ifndef DROP_UWALK
      HUWalk k vs pts rho lat ->
        let predLat = push lat (walkOn vs pts rho)
        in ( push predLat kv
           , \o -> HUWalk k vs pts rho <$> cond predLat (Saw kv o) )
#endif

#endif
#endif
-- end of the scoring layer (plan E9): everything from 'emit' down
-- requires the expfam basis and the declared obs carrier; without
-- them the model fragment still enumerates and renders — sentences
-- are sayable — but no likelihood can be assigned and no agent built.
