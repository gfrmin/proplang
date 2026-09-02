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
  , DelibWorld (..)
  , policyPick
  , policyPickKS
  , preposteriorV
  , runTrampoline
  , ExtOpt (..)
  , EpisodeShape (..)
  , JointWorld (..)
  , runJointW
  , jointPolicyWeight
  , bestExtJ
  , jointPrepost
    -- the syntax-transport helpers (typed renaming, the priced
    -- mention, the substitution expansion, the one-env binder) —
    -- exported for the Host's wire policy route (pickWire /
    -- thinkValue), the same one-sentence law at the membrane
  , weakenE
  , withRows
  , mintQ
  , substW
  ) where

import Data.List (sortOn)
import Data.List.NonEmpty (NonEmpty ((:|)))
import qualified Data.Map as M
import PropLang.Lattice (Owned, childrenOf, frontier, guardE, mkOwned,
                         nodeTheta, ownedNodes, rootNode)

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

-- ------------------- the trampoline surface (EXACT_PLAN 13) --------
-- Type derivations (the step-6 forward rule):
--   DelibWorld — the deliberation world's ECONOMICS row and nothing
--       else (the PurchaseWorld precedent, charter 13.2: "priced by
--       the world's declared clock"): dwPrice is the clock row's
--       value, door-served as the world's "price" feature (the
--       frozen t2 idiom, test/Acceptance.hs:79-80); dwBatch is the
--       think act's fold depth, descending from the frozen batch
--       law `min 3 bufLen` (test/Acceptance.hs:95 — the t2 lineage
--       charter 13.4 invokes for the differential's anchors). The
--       evidence stream is NOT here: it is world dynamics, passed
--       separately exactly as runPurchase takes its obs stream.
--
-- The internal act this surface serves is the t2 lineage's think
-- (the batch-fold deliberation of the frozen acceptance test);
-- charter 13.2's other internal act (refine, the vocabulary
-- purchase) runs through the same one-sentence law in Purchase
-- (runPurchaseS). Their UNIFICATION on a single tick's menu is the
-- boundary register's R9.
--
-- | The deliberation world: the clock row (price, batch) — declared
-- economics, nothing else.
data DelibWorld = DelibWorld
  { dwPrice :: Rational
  , dwBatch :: Int
  }
  deriving (Eq, Show)

-- typed de Bruijn renaming (syntax transport, the reindexUtility
-- precedent): total, sort-preserving; C re-minted through the door.
renameE :: (forall s. Idx env s -> Idx env' s) -> Expr env t -> Expr env' t
renameE r e = case e of
  C g k _ -> reMint g k
  Get nm -> Get nm
  Var ix -> Var (r ix)
  If c a b -> If (renameE r c) (renameE r a) (renameE r b)
  Gt a b -> Gt (renameE r a) (renameE r b)
  Sub a b -> Sub (renameE r a) (renameE r b)
  Mul a b -> Mul (renameE r a) (renameE r b)
  Expect b body -> Expect (renameE r b) (renameE (underR r) body)
  Cond b k y j n -> Cond (renameE r b) (renameE r k) (renameE r y)
                         (renameE (underR r) j) (renameE r n)
  Code d c body -> Code d c (renameE (underR (underR r)) body)

underR :: (forall s. Idx env s -> Idx env' s)
       -> Idx (u ': env) s2 -> Idx (u ': env') s2
underR _ Z = Z
underR r (S i) = S (r i)

weakenE :: Expr env t -> Expr (u ': env) t
weakenE = renameE S

-- a priced mention through the singleton mint (the parseSaid
-- precedent, Host.hs:396)
mintQ :: Rational -> Expr env Rational
mintQ v = case mkC (mkGrid "k" (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "mintQ: singleton mint (unreachable: index 0)"

-- substitute the OPTION'S OWN VALUES for its writable reads: the
-- expansion that lets every option's utility coexist inside ONE
-- standing sentence (non-writable Gets stay door-served)
substW :: Features -> Expr env t -> Expr env t
substW asn e = case e of
  C g k _ -> reMint g k
  Get nm -> case lookup nm asn of
    Just v  -> mintQ v
    Nothing -> Get nm
  Var ix -> Var ix
  If c a b -> If (substW asn c) (substW asn a) (substW asn b)
  Gt a b -> Gt (substW asn a) (substW asn b)
  Sub a b -> Sub (substW asn a) (substW asn b)
  Mul a b -> Mul (substW asn a) (substW asn b)
  Expect b body -> Expect (substW asn b) (substW asn body)
  Cond b k y j n -> Cond (substW asn b) (substW asn k) (substW asn y)
                         (substW asn j) (substW asn n)
  Code d c body -> Code d c (substW asn body)

-- bind every candidate's belief in one env; one value row per
-- option (Expect over ITS belief of ITS substituted utility)
withRows :: (forall e. Expr (Rational ': e) Rational)
         -> [(Features, Belief Int)]
         -> (forall env. Vals env -> [Expr env Rational] -> r) -> r
withRows _ [] k = k VNil []
withRows uB ((asn, b) : rest) k =
  withRows uB rest (\vals rows ->
    k (b :. vals) (Expect (Var Z) (substW asn uB) : map weakenE rows))

-- | The wire-menu ONE-SENTENCE selection (chooseEU's K-ary
-- successor): same signature, same CL-3 semantics, but the whole
-- menu compared inside a single standing sentence (chooseKS) with
-- every candidate's belief bound in one env — the charter's single
-- chooser. The option-code grid is MINTED from the declared
-- candidate list (mkGrid over 0..K-1 — the atomGridOfC precedent:
-- derived at build from declared data, never a baked point-set);
-- the winning code decodes by ==-table against the same list (a
-- tag read — register R3). chooseEU remains the frozen binary
-- special case.
policyPick :: Namespace -> Features -> Grid
           -> Expr '[Rational, Rational] Rational
           -> [(Features, Belief Int)]
           -> Either String (Maybe (Features, Belief Int))
policyPick ns feats atomG u cands = case cands of
  [] -> Right Nothing
  ((asn0, _) : _) ->
    let n = length cands
        codeG = mkGrid "options" (0 :| map fromIntegral [1 .. n - 1])
        codeM :: forall e2. Ix -> Expr e2 Rational
        codeM i = case mkC codeG i of
          Just e  -> e
          Nothing -> error "policyPick: on-codebook index (unreachable)"
        uB :: forall e. Expr (Rational ': e) Rational
        uB = reindexUtility atomG u
        cover = feats ++ [ p | p <- asn0, fst p `notElem` map fst feats ]
    in withRows uB cands (\vals rows ->
         case zipWith (\i row -> (codeM i, row)) [0 ..] rows of
           [] -> Right Nothing
           (r0 : rs) -> do
             env <- mkEnvIn ns cover vals
             let code = evalx (chooseKS (r0 :| rs)) env
             case lookup code (zip (gridPoints codeG) cands) of
               Just picked -> Right (Just picked)
               Nothing -> Left "policyPick: off-code dispatch (unreachable)")

-- | THE ONE-SENTENCE REFERENCE SEAT (the selection increment's
-- type surface; chooseeu-sitting-r0 clause 2, amendment 2: the
-- reference stays IN THE LIBRARY — exported, zero host consumers,
-- pinned).  Type derivation (the §8c forward rule): policyPick's
-- exact signature — this binding is the NORMATIVE one-sentence
-- chooseKS selection under its own name, so the fold that becomes
-- policyPick's body can be pinned to it extensionally (the
-- optimisation law; g2's successor one level up).
-- ORACLE-PHASE STUB: at the increment's implementation this carries
-- policyPick's chooseKS sentence body verbatim, and policyPick
-- becomes the pairwise-substituting fold pinned to it.  Until then
-- every comparison row in test-selection/ is red through this
-- refusal — total, attributable, compile-enabling.
policyPickKS :: Namespace -> Features -> Grid
             -> Expr '[Rational, Rational] Rational
             -> [(Features, Belief Int)]
             -> Either String (Maybe (Features, Belief Int))
policyPickKS _ _ _ _ _ =
  Left "policyPickKS: oracle-phase stub (selection increment)"

-- the sayable act-choice value (the vActS shape, evaluated — the
-- sentence route; the comparison lives in evalx)
actValueS :: Namespace -> Features -> Belief Rational
          -> Either String Rational
actValueS ns feats b = do
  let oneM = mintQ 1
      twoM = addM oneM oneM
      eR = Expect (Var Z) (Sub (Mul twoM (Var Z)) oneM)
      eL = Expect (Var Z) (Sub oneM (Mul twoM (Var Z)))
      vS :: Expr '[B Rational] Rational
      vS = If (Gt eR eL) eR eL
  env <- mkEnvIn ns feats (b :. VNil)
  pure (evalx vS env)

-- | The engine's preposterior lookahead (price-free total): the
-- value of one think at batch depth d — a FAST PATH under the
-- optimisation law, pinned in-increment to the frozen sayable route
-- (vThinkB == vThink3Sentence, test/Acceptance.hs) by test-trampoline
-- g3.4.
preposteriorV :: Namespace -> Features -> Int -> Belief Rational
              -> K Rational Int -> Either String Rational
preposteriorV ns feats d b k
  | d <= 0 = actValueS ns feats b
  | otherwise = do
      parts <- mapM
        (\y -> case condK b k y of
           Just b' -> do
             v <- preposteriorV ns feats (d - 1) b' k
             pure (predictMass b k y * v)
           Nothing -> pure 0)
        [0, 1]
      pure (sum parts)

-- | The closed-loop trampoline over the frozen t2 substrate (theta
-- space + emission kernel + the world's evidence stream, passed
-- separately like runPurchase's): ONE policy evaluation per tick
-- over the standing sentence [L, R, think], internal act LAST
-- (CL-3 ties to inaction); think folds the world's batch and
-- re-enters. Returns the per-tick chosen-option transcript — the
-- carrier is the frozen artifact's own (Anchors.t2RowsX's String
-- act column): "think" rows then the final act.
runTrampoline :: Namespace -> Space Rational -> K Rational Int
              -> DelibWorld -> [Int] -> Either String [String]
runTrampoline ns sp k w buf0 = go (uniform sp) buf0
  where
    price = dwPrice w
    feats = [("price", price)]
    oneM = mintQ 1
    twoM = addM oneM oneM
    eR = Expect (Var (S Z)) (Sub (Mul twoM (Var Z)) oneM)
    eL = Expect (Var (S Z)) (Sub oneM (Mul twoM (Var Z)))
    thinkRow = Sub (Var Z) (Get "price")
    codeG = mkGrid "acts" (0 :| [1, 2])
    codeM i = case mkC codeG i of
      Just e  -> e
      Nothing -> error "runTrampoline: on-codebook index (unreachable)"
    policy :: Expr '[Rational, B Rational] Rational
    policy = chooseKS ((codeM 0, eL) :| [(codeM 1, eR), (codeM 2, thinkRow)])
    go b buf = do
      tv <- preposteriorV ns feats (min (dwBatch w) (length buf)) b k
      env <- mkEnvIn ns feats (tv :. b :. VNil)
      let code = evalx policy env
      case lookup code [(0, "L"), (1, "R"), (2, "think")] of
        Just "think" -> do
          let b' = foldl (\bb y -> case condK bb k y of
                            Just bb2 -> bb2
                            Nothing  -> bb)
                         b (take (dwBatch w) buf)
          rest <- go b' (drop (dwBatch w) buf)
          pure ("think" : rest)
        Just a  -> pure [a]
        Nothing -> Left "runTrampoline: off-code dispatch (unreachable)"


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


-- =====================================================================
-- THE JOINT SURFACE (the completeness boundary's joint-preposterior
-- increment; stubs land at the oracle phase, red-attributable —
-- the trampoline precedent. Bodies arrive only after the author's
-- freeze; every row of test-jointprep/ is red against these.)
--
-- Type-derivation audit (the step-6 clause; each type WITH its line;
-- citations repaired at the mandate round, pack Part XII):
--   'ExtOpt'       — the declared external option sort: constructors
--                    from EV-CR1 P1's measured menu (wait head,
--                    L/R/respond externals); menus are world data
--                    per the step-5 shape (membrane-wire: names and
--                    grids, nothing else); order/incumbency is
--                    R-R2/R_SCOPE section 2's option-order pin with
--                    CL-3 first-listed ties.
--   'EpisodeShape' — JP5's episode-shape law: the two shipped faces'
--                    episode forms (decide-once = the t2 lineage,
--                    standing = the purchase lineage), DECLARED.
--                    The decide-once null external ("wait") is the
--                    null COMMITMENT and shares only the string with
--                    the standing loop's per-tick idleness (the
--                    mandate-5 sense line; rows citing "waits" name
--                    the sense).
--   'JointWorld'   — the field union of the two shipped world faces
--                    per EV-CR1 P4's wire pin, with two RESOLUTIONS
--                    cited: pwLadderCap does not carry over — the
--                    cap was the baked horizon and the horizon is
--                    the declared stream's length (EV-JP4/JP8); and
--                    the charter's P4 restatement adds THE DECLARED
--                    LOOKAHEAD DEPTH (jwDepth — JP10's object,
--                    declared world data, never an engine constant).
--                    No think-presence field: deliberation is never
--                    excludable by declaration (the charter's own
--                    law; the mandate-4 finding deleted the Bool).
-- =====================================================================

data ExtOpt = OWait | OLeft | ORight | ORespond
  deriving (Eq, Show)

data EpisodeShape = DecideOnce | Standing
  deriving (Eq, Show)

data JointWorld = JointWorld
  { jwExts   :: [ExtOpt]
    -- ^ the declared external menu; order = incumbency (the R-R2
    -- option-order pin, CL-3 ties to the first listed)
  , jwPrice  :: Rational
  , jwBatch  :: Int
  , jwRefine :: Maybe Rational
  , jwDepth  :: Int
    -- ^ the refine lookahead's declared exploration depth (JP10:
    -- declared world data — the kLadder lesson; the direction is
    -- neutral-by-dominance, EV-JP6)
  , jwStakes :: (Rational, Rational)
  , jwShape  :: EpisodeShape
  }
  deriving (Eq, Show)

-- | The scalar one-env binder (withRows' scalar sibling): binds a
-- value list into one env with a Var row per value, order preserved,
-- KnownScope threaded so the bound sentence can also be PRICED.
withQVals :: [Rational]
          -> (forall env. KnownScope env
              => Vals env -> [Expr env Rational] -> r)
          -> r
withQVals [] k = k VNil []
withQVals (v : rest) k =
  withQVals rest (\vals vars -> k (v :. vals) (Var Z : map weakenE vars))

-- | THE ONE CHOOSER, EVERYWHERE (pack Part X): every choice the
-- joint loop makes — the tick's menu, every Bellman backup, the
-- refine payload — is evalx of the standing chooseKS sentence over
-- env-bound values; the winner returns as an INDEX (a tag read,
-- register R3). The engine keeps arithmetic and the clock; it never
-- compares.
chooseIdx :: Namespace -> Features -> [Rational] -> Either String Int
chooseIdx ns feats vs = case vs of
  [] -> Left "chooseIdx: the declared menu is empty"
  (_ : _) ->
    let n = length vs
        codeG = mkGrid "jacts" (0 :| map fromIntegral [1 .. n - 1])
        cM :: forall e2. Int -> Expr e2 Rational
        cM i = case mkC codeG i of
          Just e  -> e
          Nothing -> error "chooseIdx: on-codebook index (unreachable)"
    in withQVals vs (\vals vars -> do
         env <- mkEnvIn ns feats vals
         let rows = zipWith (\i v -> (cM i, v)) [0 ..] vars
         code <- case rows of
           (r0 : rs) -> Right (evalx (chooseKS (r0 :| rs)) env)
           []        -> Left "chooseIdx: no rows (unreachable)"
         case lookup code (zip (gridPoints codeG) [0 ..]) of
           Just i  -> Right i
           Nothing -> Left "chooseIdx: off-code dispatch (unreachable)")

-- the external option's value (the sentence route where the belief
-- speaks: eL/eR are COPIES of runTrampoline's bodies)
extValJ :: Namespace -> Features -> Belief Rational -> Owned
        -> (Int, Int) -> (Rational, Rational) -> ExtOpt
        -> Either String Rational
extValJ ns feats b owned c st e = case e of
  OWait    -> Right 0
  ORespond -> Right (guardE True owned c st)
  OLeft    -> evalOne (Expect (Var Z) (Sub oneM (Mul twoM (Var Z))))
  ORight   -> evalOne (Expect (Var Z) (Sub (Mul twoM (Var Z)) oneM))
  where
    oneM = mintQ 1
    twoM = addM oneM oneM
    evalOne body = do
      env <- mkEnvIn ns feats (b :. VNil)
      pure (evalx (body :: Expr '[Belief Rational] Rational) env)

extName :: ExtOpt -> String
extName OWait = "wait"
extName OLeft = "L"
extName ORight = "R"
extName ORespond = "respond"

-- the best EXTERNAL value of the declared menu (the base-fix,
-- EV-JP1): the argmax through the one chooser, its value by index
bestExtJ :: Namespace -> Features -> JointWorld -> Belief Rational
         -> Owned -> (Int, Int) -> Either String Rational
bestExtJ ns feats w b owned c = do
  vs <- mapM (extValJ ns feats b owned c (jwStakes w)) (jwExts w)
  i <- chooseIdx ns feats vs
  case drop i vs of
    (v : _) -> Right v
    []      -> Left "bestExtJ: index out of range (unreachable)"

-- | The base-fix preposterior (EV-JP1's measured form), exported for
-- the VoI law rows (the EV-CR4 lineage re-executed on the joint
-- surface, EV-JP8): the hypothetical obs move BOTH the belief and
-- the guard counts; the base is the best external OF THE DECLARED
-- MENU.
jointPrepost :: Namespace -> Features -> JointWorld
             -> Kernel Rational Int -> Int -> Belief Rational
             -> Owned -> (Int, Int) -> Either String Rational
jointPrepost ns feats w k d b owned c
  | d <= 0 = bestExtJ ns feats w b owned c
  | otherwise = do
      parts <- mapM
        (\y -> case condK b k y of
           Just b' -> do
             v <- jointPrepost ns feats w k (d - 1) b' owned
                    (if y == (1 :: Int)
                       then (fst c + 1, snd c) else (fst c, snd c + 1))
             pure (predictMass b k y * v)
           Nothing -> pure 0)
        [0, 1]
      pure (sum parts)

-- | The one joint loop: both episode shapes, both internal acts
-- declarable on one tick's menu, every choice through evalx (the
-- one-chooser-everywhere law, pack Part X).
runJointW :: Namespace -> Space Rational -> Kernel Rational Int
          -> JointWorld -> [Int] -> Either String [String]
runJointW ns sp k w stream = case jwShape w of
  DecideOnce -> goOnce (uniform sp) (mkOwned [rootNode]) (0, 0) stream
  -- the standing shape carries no think row THIS increment: an
  -- engine-scope line (the composed standing tick is register JP4),
  -- never a world declaration — deliberation is not excludable
  Standing -> standingDP ns w stream
  where
    feats = [("price", jwPrice w)]
    st = jwStakes w
    bump (a, b2) y = if y == (1 :: Int) then (a + 1, b2) else (a, b2 + 1)
    prepostJ d b owned c = jointPrepost ns feats w k d b owned c
    goOnce b owned c buf = do
      extVs <- mapM (extValJ ns feats b owned c st) (jwExts w)
      thinkVs <- if not (null buf)
        then do
          tv <- prepostJ (min (jwBatch w) (length buf)) b owned c
          pure [tv - jwPrice w]
        else pure []
      refVs <- case jwRefine w of
        Nothing -> pure []
        Just s -> case frontier owned of
          [] -> pure []
          fs -> do
            cvs <- mapM (\cand -> do
                     bv <- bestExtJ ns feats w b
                             (mkOwned (cand : ownedNodes owned)) c
                     pure (bv - s)) fs
            ci <- chooseIdx ns feats cvs
            case drop ci cvs of
              (v : _) -> pure [v]
              []      -> Left "runJointW: refine payload (unreachable)"
      let vs = extVs ++ thinkVs ++ refVs
          names = map extName (jwExts w)
               ++ [ "think" | not (null thinkVs) ]
               ++ [ "refine" | not (null refVs) ]
      i <- chooseIdx ns feats vs
      nm <- case drop i names of
        (n0 : _) -> Right n0
        []       -> Left "runJointW: name index (unreachable)"
      case nm of
        "think" -> do
          let ys = take (jwBatch w) buf
              b' = foldl (\bb y -> case condK bb k y of
                            Just bb2 -> bb2
                            Nothing  -> bb) b ys
              c' = foldl bump c ys
          rest <- goOnce b' owned c' (drop (jwBatch w) buf)
          pure ("think" : rest)
        "refine" -> case jwRefine w of
          Nothing -> Left "runJointW: refine without a mint (unreachable)"
          Just _ -> case frontier owned of
            [] -> Left "runJointW: empty frontier (unreachable)"
            fs -> do
              cvs <- mapM (\cand -> do
                       bv <- bestExtJ ns feats w b
                               (mkOwned (cand : ownedNodes owned)) c
                       pure bv) fs
              ci <- chooseIdx ns feats cvs
              cand <- case drop ci fs of
                (c0 : _) -> Right c0
                []       -> Left "runJointW: candidate index (unreachable)"
              rest <- goOnce b (mkOwned (cand : ownedNodes owned)) c buf
              pure ("refine" : rest)
        external -> pure [external]

-- the standing-shape finite-horizon DP (EV-JP4/JP5's measured form,
-- generalized to BOTH children per extension): states are descending
-- paths from the root (False = low-theta child, True = high), the
-- clock is the declared stream, counts precomputed from it; every
-- backup and the tick's act go through chooseIdx (a Left from the
-- chooser is unreachable here — the door covers — and is carried as
-- the runPurchase-precedent error text). The depth bound is the
-- DECLARED jwDepth (JP10, ruled at jp-freeze-r0: depth is world
-- data; the pre-ruling draft of this sentence said "the depth bound
-- 7 ... rules its final form before the implementation lands" —
-- repaired at the close, the prophecy applied byte-for-byte first).
standingDP :: Namespace -> JointWorld -> [Int] -> Either String [String]
standingDP ns w stream = case jwRefine w of
  Nothing -> Right (goPlain 0)
  Just s  -> Right (goS s [] 0)
  where
    feats = [("price", jwPrice w)]
    st = jwStakes w
    total = length stream
    countsAt = scanl (\(a, b2) y ->
                        if y == (1 :: Int) then (a + 1, b2)
                                           else (a, b2 + 1))
                     (0, 0) stream
    cAt t = case drop (t + 1) countsAt of
      (c : _) -> c
      []      -> error "standingDP: clock index (unreachable)"
    nodeAt path = go2 rootNode path
      where
        go2 n [] = n
        go2 n (hi : rest) =
          case sortOn nodeTheta (childrenOf n) of
            [lo, hi2] -> go2 (if hi then hi2 else lo) rest
            _ -> error "standingDP: a lattice node has two children (unreachable)"
    chainNodes path = [ nodeAt (take i path) | i <- [1 .. length path] ]
    ownedOf path = mkOwned (rootNode : chainNodes path)
    depthCap = jwDepth w
    paths = concat [ allPaths n | n <- [0 .. depthCap] ]
    allPaths :: Int -> [[Bool]]
    allPaths 0 = [[]]
    allPaths n = [ b2 : p2 | p2 <- allPaths (n - 1), b2 <- [False, True] ]
    pessOf path t = guardE True (ownedOf path) (cAt t) st
    pick vs = either (\m -> error ("standingDP (unreachable: the door covers) " ++ m))
                     id (chooseIdx ns feats vs)
    at i xs = case drop i xs of
      (x : _) -> x
      []      -> error "standingDP: index (unreachable)"
    -- the value table, built ONCE, knotted lazily (Data.Map lazy);
    -- every backup's max is the sentence's argmax read back by index
    goS s path0 t0 = runFrom path0 t0
      where
        tbl = M.fromList [ ((path, d), val path d)
                         | d <- [0 .. total], path <- paths ]
        nxt p2 d2 = M.findWithDefault 0 (p2, d2) tbl
        val path d
          | d <= 0 = 0
          | otherwise =
              let t = total - d
                  extRow e = case e of
                    OWait    -> nxt path (d - 1)
                    ORespond -> pessOf path t + nxt path (d - 1)
                    _ -> error "standingDP: the standing belief face is register JP4"
                  refVs = [ (-s) + nxt (path ++ [b2]) (d - 1)
                          | length path < depthCap, b2 <- [False, True] ]
                  vs = map extRow (jwExts w) ++ refVs
              in at (pick vs) vs
        runFrom path t
          | t >= total = []
          | otherwise =
              let d = total - t
                  extRow e = case e of
                    OWait    -> nxt path (d - 1)
                    ORespond -> pessOf path t + nxt path (d - 1)
                    _ -> error "standingDP: the standing belief face is register JP4"
                  extVs = map extRow (jwExts w)
                  refs = [ (path ++ [b2], (-s) + nxt (path ++ [b2]) (d - 1))
                         | length path < depthCap, b2 <- [False, True] ]
                  refRow = case refs of
                    [] -> []
                    _  -> [ at (pick (map snd refs)) refs ]
                  vs = extVs ++ map snd refRow
                  nms = map extName (jwExts w)
                     ++ [ "refine" | not (null refRow) ]
                  nm = at (pick vs) nms
              in case nm of
                   "refine" -> case refRow of
                     ((p2, _) : _) -> "refine" : runFrom p2 (t + 1)
                     [] -> error "standingDP: refine row (unreachable)"
                   _ -> nm : runFrom path (t + 1)
    goPlain t
      | t >= total = []
      | otherwise =
          let extRow e = case e of
                OWait    -> 0
                ORespond -> pessOf [] t
                _ -> error "standingDP: the standing belief face is register JP4"
              vs = map extRow (jwExts w)
              nm = at (pick vs) (map extName (jwExts w))
          in nm : goPlain (t + 1)

-- | The standing sentence's price for a declared world: the chooser
-- built from the declaration's arity, priced through the frozen
-- weightIn (price rows read src — the F5 lesson).
jointPolicyWeight :: JointWorld -> Rational
jointPolicyWeight w =
  let n = length (jwExts w)
        + (case jwShape w of DecideOnce -> 1; Standing -> 0)
          -- think's row: always on the decide-once menu (never
          -- excludable); absent from the standing menu this
          -- increment (the JP4 engine-scope line)
        + (case jwRefine w of Just _ -> 1; Nothing -> 0)
      doorNs = mkNamespace ("door" :| [])
      codeG = mkGrid "jacts" (0 :| map fromIntegral [1 .. n - 1])
      cM :: forall e2. Int -> Expr e2 Rational
      cM i = case mkC codeG i of
        Just e  -> e
        Nothing -> error "jointPolicyWeight: on-codebook index (unreachable)"
  in withQVals (replicate n 0) (\_ vars ->
       case zipWith (\i v -> (cM i, v)) [0 ..] vars of
         (r0 : rs) -> weightIn doorNs (chooseKS (r0 :| rs))
         []        -> error "jointPolicyWeight: empty menu (unreachable)")
