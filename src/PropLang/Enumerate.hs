{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

-- | The sentence fragment and the agent (typed-port-spec §6 as amended
-- at the step-3 sentence freeze): enumeration to the Cromwell frontier
-- (depth-1 in @if@; a parameter of the implementation, not the
-- language), and the belief-over-programs agent moved only by the
-- verbs. No adaptation code exists here — that is the point, and audit
-- gate 4 checks it.
--
-- SINCE THE STEP-3 DEMOLITION (AGENT_PLAN §7 step 3, the sentence
-- freeze): a hypothesis IS a sentence — its emission is a CODE of the
-- real grammar over its declared latent axis, priced by the DECLARED
-- production table ('FragSort' widths), and state-carrying hypotheses
-- carry a move code of the same grammar. The old parallel encoding
-- ('Model', 'Terminal', the hmm/bern representation) and the utility
-- fragment ('UFamily', 'TauSpec', the verdict kernel, the latent
-- accessors) were DELETED at that boundary; their surviving anchors
-- were ported to the step-3 oracle through this surface, bit-stable
-- (E-s1/E-s2, the pack's measurements).
--
-- The clock is externalized: callers pass the tick as an ordinary
-- feature @[("t", t)]@ (interface.md §5, the host's tick echo). There
-- is no @disabled@ knob: deletion audits ablate the grammar itself
-- (gate 7) or restrict the enumerated production set; they never mock.
module PropLang.Enumerate
  ( renderExpr
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
  -- THE STEP-3 SENTENCE SURFACE (a hypothesis becomes a sentence).
  -- Unguarded: sentences are sayable without the scoring layer,
  -- exactly as the fragment is.
  , FragSort (..)
  , FragProd (..)
  , fragSortOf
  , fragWidth
  , fragFull
  , Hyp (..)
#if !defined(DROP_CODE) && !defined(DROP_POS) && !defined(DROP_TOR)
  -- the enumerators UTTER the step-1 constructors (every sentence is a
  -- code; the walk move reads positions; bern's body reads the carrier
  -- through ToR) — they die with any of them, consumers-down (the
  -- strengthened ablation standard)
  , enumerateSentences
  , enumerateSentencesIn
  , enumerateSentencesGrid
#endif
  , filterTickFree
  -- the scoring layer dies with the basis or with the carrier
  -- declaration (plan E9): delete expfam — or the declared output
  -- space — and sentences stay sayable but NOTHING can assign
  -- likelihood; the agent cannot exist
#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS)
  , emit
  -- the reflected walk, for the step-1 oracle to compare its code form
  -- against (R-D20-i). Guarded exactly as its DEFINITION is — an
  -- unconditional export made the DROP_CARRIER_OBS ablation fail on
  -- 'walkOn' instead of 'obsCarrier', breaking the deletion audit's
  -- attribution check. The audit caught it; that is what it is for.
  , walkOn
  , Agent
  , sentenceAgent
  , predictive
  , observe
  , observeVia
  , observeCounts
  , agentMeta
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
import PropLang.Syntax (Carrier, Expr (..), Grid, Idx (..), K, Name,
                        Namespace, StdName (..), Args (..), Stats (..),
                        carrierName, gridName, gridSize, mkC, mkCarrier,
                        mkGrid, mkNamespace, nsSize)

-- ---------------------------------------------------------------------
-- the priced grids (data with prices, design §5 — the only numeric
-- content of the sentence fragment)
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
-- rendering
-- ---------------------------------------------------------------------

-- | Rendering is total over the grammar. Exported since the expfam
-- increment (additive) so increment oracles can pin node strings; the
-- step-3 goldens pin whole sentence renders (emission and move codes).
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
    statsStr :: Stats c' -> String
    statsStr s = case s of
#ifndef DROP_SID
      SId -> "id"
#endif

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

-- ---------------------------------------------------------------------
-- THE SENTENCE FRAGMENT (step 3: Model -> the emission CODE of the real
-- grammar; Terminal -> the declared production table. R-C1 ruling
-- (iii): per-tick denotation through Maybe — a code that refuses at an
-- OBSERVED tick asserted the impossible there and is refuted
-- permanently; on a silent tick, silence never refutes.)
-- ---------------------------------------------------------------------

-- | The fragment's four sorts. A sort's WIDTH is what the derivation
-- charges at its choice point (lg width) — declared data read by the
-- enumeration's pricer, never a hand-rolled literal (decision 8: the
-- table through bitsAt's own discipline from day one; E-s1 measured the
-- declared table bit-identical to the frozen charges, both fold
-- shapes).
data FragSort = MODEL | THETA | HEAD | RATE
  deriving (Eq, Show)

-- | The fragment's productions, each belonging to a sort. HEAD carries
-- ONE enumerable production under a declared width of 2 — a classified
-- exception in the SayableP lg-10 sense (the width is what is priced,
-- not the enumerated count; the D4 discipline: re-pricing is
-- adjudication, never grep), and a DEBT ROW, registered at the step-3
-- sitting: half the HEAD mass is a bit charged for an UNUTTERABLE
-- alternative — the frozen anchors' hand-rolled residue, preserved for
-- continuity and correctly classified, but a residue with a NAMED
-- HOME: the widths become honest when the table is re-derived at an
-- author boundary, or when the second head becomes utterable. Printed
-- here so it stays a residue rather than a habit (the brief's
-- grep-test calls an unprinted one a hand on the wheel).
data FragProd = FBern | FWalk | FConst | FIf | FGuardHead
  deriving (Eq, Show)

fragSortOf :: FragProd -> FragSort
fragSortOf FBern      = MODEL
fragSortOf FWalk      = MODEL
fragSortOf FConst     = THETA
fragSortOf FIf        = THETA
fragSortOf FGuardHead = HEAD

-- | The declared widths: MODEL 2, THETA 2, HEAD 2, RATE 1 (the E-s1
-- table, sentence-author-pack §5).
fragWidth :: FragSort -> Int
fragWidth MODEL = 2
fragWidth THETA = 2
fragWidth HEAD  = 2
fragWidth RATE  = 1

-- | The full production list; test 4's deletion rows enumerate declared
-- SUBSETS of it (the [Terminal] lists' port, D2 part 3).
fragFull :: [FragProd]
fragFull = [FBern, FWalk, FConst, FIf, FGuardHead]

-- | A hypothesis IS a sentence — transparent, because hypotheses are
-- world-declarable data (the deletion-test criterion): a derivation
-- charge, a latent axis, the per-tick emission code over that axis,
-- and — for state-carrying sentences — a transition code over the same
-- axis (D5 as ruled: this slot plus the filtered 'Belief' the agent
-- carries per hypothesis covers what the old hmm representation
-- carried; no new type). Stateless sentences declare a SINGLETON
-- latent axis, so the uniform initial latent is a point mass and every
-- predictive row stays bit-exact (no mixture arithmetic on a
-- degenerate axis).
data Hyp = Hyp
  { hypBits  :: Bits
  , hypSpace :: Space Double
  , hypEmit  :: Expr '[] (Maybe (K Double Obs))
  , hypMove  :: Maybe (Expr '[] (Maybe (K Double Double)))
  }

#if !defined(DROP_CODE) && !defined(DROP_POS) && !defined(DROP_TOR)
-- | The fragment over the built-in namespace and grids — the
-- 'enumerateModels' successor; 1169 hypotheses at 'fragFull', dl
-- multiset bit-identical to the frozen enumeration's (g1 pins it).
enumerateSentences :: [FragProd] -> [Hyp]
enumerateSentences = enumerateSentencesIn (mkNamespace ("t" :| [])) []

-- | Namespace-relative enumeration (the 'enumerateModelsIn' successor;
-- the membrane's 1241/1529 counts port against this).
enumerateSentencesIn :: Namespace -> [(Name, Grid)] -> [FragProd] -> [Hyp]
enumerateSentencesIn = enumerateSentencesGrid thetaPoints

-- | Emission-grid-relative enumeration (the 'enumerateModelsGrid'
-- successor; boundary E's grid relativity). Order and count match the
-- frozen reference (full set: 1169 sentences under the built-in
-- grids): the constant sentences, then the walks, then the
-- change-point sentences with the threshold outermost.
enumerateSentencesGrid :: NonEmpty Double -> Namespace -> [(Name, Grid)]
                       -> [FragProd] -> [Hyp]
enumerateSentencesGrid egPts ns extras allowed =
    consts ++ walks ++ concatMap guardFamily (("t", tauGrid) : extras)
  where
    eg = mkGrid "theta" egPts
    egSp = mkSpace egPts
    has t = t `elem` allowed
    wOf s = logBase 2 (fromIntegral (fragWidth s))
    nsB :: Double
    nsB = case nsSize ns of
      1 -> 0
      kk -> logBase 2 (fromIntegral kk)
    lgSize g = logBase 2 (fromIntegral (gridSize g))
    -- charges from the DECLARED table, tree-shaped (the E-s1 fold —
    -- the frozen parentheses of the old hand-rolled literals)
    dlConst = wOf MODEL + (wOf THETA + lgSize eg)
    dlWalk  = wOf MODEL + (wOf RATE + lgSize rhoGrid)
    dlGuard g = wOf MODEL
      + (((wOf THETA + ((wOf HEAD + nsB) + (wOf THETA + lgSize g)))
          + (wOf THETA + lgSize eg))
         + (wOf THETA + lgSize eg))
    cAt :: Grid -> Int -> Expr env Double
    cAt g k = case mkC g k of
      Just e  -> e
      Nothing -> error "enumerateSentencesGrid: on-grid index refused"
    -- the shape grid (COPY of test-code kGrid: 0/1/2/(n-1); valid for
    -- the 9-point emission grids all rows use)
    shGrid = mkGrid "k" (0 :| [1, 2, 8])
    k0 = cAt shGrid 0; k1 = cAt shGrid 1; k2 = cAt shGrid 2
    kLast = cAt shGrid 3
    bernBody th = Neg (Div (Log pb) (Log k2))
      where
        yv = ToR (Var Z)
        pb = If (Gt yv k0) th (Sub k1 th)
    consts =
      [ Hyp (Bits dlConst) sp (Code sp obsSpace (bernBody (cAt eg k))) Nothing
      | has FBern, has FConst, k <- [0 .. gridSize eg - 1]
      , let v = evalx (cAt eg k :: Expr '[] Double) (mkEnv [] VNil)
      , let sp = mkSpace (v :| []) ]
    walks =
      [ Hyp (Bits dlWalk) egSp (Code egSp obsSpace (bernBody (Var (S Z))))
            (Just (walkCode j))
      | has FWalk, has FConst, j <- [0 .. gridSize rhoGrid - 1] ]
    -- COPY of test-code/Code.hs:198-210 codeWalk; rho via cAt rhoGrid
    walkCode j = Code egSp egSp body
      where
        rho = cAt rhoGrid j
        eqE a b = Call IsEq (a :* b :* ANil)
        iv = Pos egSp (Var (S Z))
        jv = Pos egSp (Var Z)
        lo = If (Gt iv k0)    (Sub iv k1) (Add iv k1)
        hi = If (Gt kLast iv) (Add iv k1) (Sub iv k1)
        mass = Add (Add (If (eqE jv iv) (Sub k1 rho) k0)
                        (If (eqE jv lo) (Div rho k2) k0))
                   (If (eqE jv hi) (Div rho k2) k0)
        body = Neg (Div (Log mass) (Log k2))
    guardFamily (nm, g) =
      [ Hyp (Bits (dlGuard g)) gsp
            (Code gsp obsSpace (bernBody
               (If (Gt (Get nm) (cAt g t)) (cAt eg a) (cAt eg b))))
            Nothing
      | has FBern, has FIf, has FConst, has FGuardHead
      , t <- [0 .. gridSize g - 1]
      , a <- [0 .. gridSize eg - 1], b <- [0 .. gridSize eg - 1], a /= b ]
    gsp = mkSpace (0.5 :| [])
#endif

-- | THE LAW'S FIRST SCHEDULED APPLICATION (the step-2 rider): drop
-- candidates whose emission code is TICK-INDEPENDENTLY never-denoting
-- (a Get-free code refused once is refused always). A fast path, legal
-- iff pinned extensionally to carry-plus-per-tick-refutation — g3 pins
-- it in BOTH orientations; it never enters the alphabet, so it never
-- touches the prior.
filterTickFree :: [Hyp] -> [Hyp]
filterTickFree hs = [ h | h <- hs, not (deadStatic h) ]
  where
    deadStatic h =
      not (hasGet (hypEmit h))
        && case evalx (hypEmit h) (mkEnv [] VNil) of
             Nothing -> True
             Just _  -> False

-- tick-dependence: a code that reads no feature denotes identically at
-- every tick. Total; the wildcard covers the value-layer constructors
-- no emission code can carry a Get inside of (their payloads are
-- opaque to rendering and pricing alike).
hasGet :: Expr env t -> Bool
hasGet e0 = case e0 of
  Get _        -> True
  If c a b     -> hasGet c || hasGet a || hasGet b
  Gt a b       -> hasGet a || hasGet b
  Add a b      -> hasGet a || hasGet b
  Sub a b      -> hasGet a || hasGet b
  Mul a b      -> hasGet a || hasGet b
  Div a b      -> hasGet a || hasGet b
  Log a        -> hasGet a
  Exp a        -> hasGet a
  Neg a        -> hasGet a
#ifndef DROP_POS
  Pos _ e      -> hasGet e
#endif
#ifndef DROP_TOR
  ToR e        -> hasGet e
#endif
#ifndef DROP_CODE
  Code _ _ b   -> hasGet b
#endif
  Call _ as    -> goArgs as
  _            -> False
  where
    goArgs :: Args env ts -> Bool
    goArgs ANil      = False
    goArgs (a :* as) = hasGet a || goArgs as

#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS)
-- ---------------------------------------------------------------------
-- the scoring layer (plan E9): everything below requires the expfam
-- basis and the declared obs carrier; without them the sentence
-- fragment still enumerates and renders — sentences are sayable — but
-- no likelihood can be assigned and no agent built.
-- ---------------------------------------------------------------------

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
-- 'kernel' only ever applies 'step' to points of its own space.
-- SINCE STEP 3 this is the REFERENCE the walk code is pinned against
-- (test-code group 1, 567/567 bit-identical cells); the engine's own
-- stepping runs through the move CODES.
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
-- the agent: a belief over sentences, moved only by the verbs
-- ---------------------------------------------------------------------

-- Per-hypothesis filtered state: the sentence and its current latent
-- belief (a stateless sentence's singleton axis makes this a point
-- mass by construction).
data HypState = HSent Hyp (Belief Double)

-- | A belief over programs plus per-hypothesis filtered latent state.
data Agent = Agent [HypState] (Space Int) (Belief Int)

-- | The agent over sentences — the 'mkAgent' successor ('mkAgent' died
-- with 'Model' at the step-3 boundary). Meta-prior 2^(-hypBits)
-- through the only prior source; per-hypothesis filtered latents
-- initialize uniform on 'hypSpace' and move only by the verbs. Guarded
-- with the scoring layer: without the carrier declaration no agent can
-- be built (E9), and the deletion audit's attribution must keep
-- landing on 'obsCarrier'.
--
-- D8 (ruled at the step-3 sitting, 2026-07-15): a refusing sentence
-- holding positive meta mass at prediction time is CONDITIONED ON
-- DENOTATION — ordinary Bayes on the one event the language can
-- state, forced by coherence (a deficient mixture prices a Dutch
-- book; a fabricated likelihood is the sentinel's disease). The
-- conditioning is A READ, NOT AN UPDATE: the belief state is
-- untouched, the refuser keeps its meta mass, and the renormalisation
-- is local to the predictive query — wiring it as a belief update
-- would be refutation-by-prediction, forbidden (no observation
-- occurred; deliberation must never destroy beliefs). Step 5's
-- corollary is frozen with the ruling: push-at-assignment applies the
-- same semantics per assignment, and a refuser's mass is precisely
-- the probability that tomorrow's arrival shrinks the support — the
-- preposterior machinery already prices that as wait-and-see value,
-- so no guard is ever owed for it.
sentenceAgent :: [Hyp] -> Agent
sentenceAgent hs = case nonEmpty [0 .. length hs - 1] of
  Nothing  -> error "sentenceAgent: empty enumeration"
  Just ixs ->
    let isp = mkSpace ixs
    in Agent [ HSent h (uniform (hypSpace h)) | h <- hs ] isp
             (fromBits isp ((map hypBits hs) !!))

-- One tick of one sentence at the given features: its predictive over
-- observations, and its absorb continuation (a state-carrying sentence
-- conditions the SAME one-step-pushed latent it predicted from, verb
-- for verb as the reference). Maybe-valued because a code's denotation
-- is a per-tick fact (R-C1 ruling iii): Nothing = the sentence refuses
-- at this tick's features.
stepSent :: Features -> HypState
         -> Maybe (Belief Obs, Obs -> Maybe HypState)
stepSent feats (HSent hy lat) =
  case evalx (hypEmit hy) (mkEnv feats VNil) of
    Nothing -> Nothing
    Just k  ->
      let predLat = case hypMove hy of
            Nothing -> lat
            Just mv -> case evalx mv (mkEnv feats VNil) of
              Just mk -> push lat mk
              Nothing -> lat   -- move refusal: unexercised by any row
      in Just ( push predLat k
              , \y -> HSent hy <$> cond predLat (Saw k y) )

-- | The one-tick-ahead predictive: push of the meta-belief along the
-- per-sentence step kernel at the given features. Refusers with
-- positive mass are handled by ruling D8 (the haddock on
-- 'sentenceAgent'): condition on denotation — a READ, never an update.
predictive :: Features -> Agent -> Belief Obs
predictive feats (Agent hyps isp meta) =
  let steps = map (stepSent feats) hyps
  in case traverse (fmap fst) steps of
       Just bs -> push meta (kernel isp obsSpace (bs !!))
       Nothing ->
         -- D8: the refusers' mass is conditioned away by the same
         -- public cond arithmetic the evidence path uses — locally,
         -- for this query only; the agent's belief state is untouched
         let indSp = mkSpace (0 :| [1]) :: Space Int
             indK  = kernel isp indSp
                       (\i -> point indSp (case steps !! i of
                                             Just _  -> 1
                                             Nothing -> 0))
             meta' = case cond meta (Saw indK 1) of
                       Just m  -> m
                       Nothing -> error
                         "predictive: no sentence denotes at this tick"
             row i = case steps !! i of
                       Just (b, _) -> b
                       Nothing     -> point obsSpace 0
         in push meta' (kernel isp obsSpace row)

-- | One polling re-entry: returns the natural-log marginal likelihood of
-- the observation ('LogProb') and the conditioned agent. 'Nothing' =
-- impossible evidence (total, like 'PropLang.Belief.cond').
observe :: Features -> Obs -> Agent -> Maybe (LogProb, Agent)
observe feats y (Agent hyps isp meta) = do
  let stepped = map (stepSent feats) hyps
      row i = case stepped !! i of
                Just (b, _) -> b
                -- refusal at an OBSERVED tick: asserted the impossible
                -- there — likelihood exactly 0, said through public
                -- machinery (a point row on any OTHER observation has
                -- probability exactly 0 at y)
                Nothing -> point obsSpace (if y == 0 then 1 else 0)
      ev = Saw (kernel isp obsSpace row) y
      lp = logPredict meta ev
  meta' <- cond meta ev
  -- a refuted or refusing sentence keeps its state at zero meta mass
  -- (Cromwell at the meta level: exact zeros never resurrect)
  let hyps' = [ case st of
                  Just (_, absorb) -> maybe h id (absorb y)
                  Nothing          -> h
              | (h, st) <- zip hyps stepped ]
  pure (lp, Agent hyps' isp meta')

-- | The meta-belief over hypothesis indices (positions in the
-- enumeration the agent was built from).
agentMeta :: Agent -> Belief Int
agentMeta (Agent _ _ meta) = meta

-- | The count-collapsed warm verb (wire v2's @observe_counts@; the
-- second review's budget ruling): per-hypothesis likelihood
-- EXPONENTIATION from (n1, n0) — each sentence's predictive is
-- computed ONCE and its log-likelihood scaled by the counts, folded
-- into the meta-belief through one synthetic evidence (a kernel
-- whose emission probability at the observed token IS the max-scaled
-- collapsed likelihood — public verbs only, the Belief export list
-- untouched). EXACT for exchangeable (iid-emission) sentences; for
-- state-carrying ones this IS the declared warm-flattening
-- approximation — the latent is NOT advanced per collapsed tick,
-- printed rather than smuggled. The returned 'LogProb' re-adds the
-- max-scaling constant, so the collapsed EVIDENCE is exact exactly
-- where the posterior is. O(hypotheses), not O(ticks). The optional
-- kernel routes the collapse through a supplied emission (the outcome
-- channel), 'observeVia''s discipline. A sentence refusing at the
-- collapsed features gets observe's evidence-shaped zero across the
-- n1+n0 observed ticks (no frozen row exercises this; the semantics
-- is the observed-tick refusal rule, not a new mechanism).
observeCounts :: Maybe (Kernel Double Obs) -> Features -> Int -> Int
              -> Agent -> Maybe (LogProb, Agent)
observeCounts mk feats n1 n0 (Agent hyps isp meta) = do
  let predOf (HSent hy lat) =
        case evalx (hypEmit hy) (mkEnv feats VNil) of
          Nothing -> Nothing
          Just k  ->
            let predLat = case hypMove hy of
                  Nothing -> lat
                  Just mv -> case evalx mv (mkEnv feats VNil) of
                    Just mk' -> push lat mk'
                    Nothing  -> lat
            in Just (push predLat (case mk of Nothing -> k; Just kv -> kv))
      preds = map predOf hyps
      term n l = if n == 0 then 0 else fromIntegral n * l
      logL Nothing = term n1 negInfD + term n0 negInfD
      logL (Just pd) =
        let p1 = prob pd (is obsSpace 1)
            p0 = prob pd (is obsSpace 0)
            lg1 = if p1 > 0 then log p1 else negInfD
            lg0 = if p0 > 0 then log p0 else negInfD
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
  pure (LogProb (lp + m), Agent hyps isp meta')
  where
    negInfD = -1 / 0

-- | 'observe' through a SUPPLIED emission (the outcome channel's
-- verb): each sentence's current latent belief is pushed through the
-- given kernel for its predictive; state-carrying sentences advance
-- their latent exactly as in 'stepSent' — one evidence flow, a
-- different declared channel.
observeVia :: Kernel Double Obs -> Features -> Obs -> Agent
           -> Maybe (LogProb, Agent)
observeVia kv feats y (Agent hyps isp meta) = do
  let stepped = map via hyps
      preds = map fst stepped
      ev = Saw (kernel isp obsSpace (preds !!)) y
      lp = logPredict meta ev
  meta' <- cond meta ev
  hyps' <- traverse (\(_, absorb) -> absorb y) stepped
  pure (lp, Agent hyps' isp meta')
  where
    via (HSent hy lat) =
      let predLat = case hypMove hy of
            Nothing -> lat
            Just mv -> case evalx mv (mkEnv feats VNil) of
              Just mk -> push lat mk
              Nothing -> lat   -- move refusal: unexercised by any row
      in ( push predLat kv
         , \o -> HSent hy <$> cond predLat (Saw kv o) )

#endif
-- end of the scoring layer (plan E9): everything from 'emit' down
-- requires the expfam basis and the declared obs carrier; without
-- them the sentence fragment still enumerates and renders — sentences
-- are sayable — but no likelihood can be assigned and no agent built.
