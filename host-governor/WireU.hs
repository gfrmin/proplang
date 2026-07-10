{-# LANGUAGE DataKinds #-}

-- | WireU — the membrane wire's v2 surface (@latent\@1@), HOSTS_D_PACK
-- section 8. A PARALLEL module by necessity, not taste: Wire's v1
-- record types are sealed against additive fields by the frozen
-- govhost suite's record constructions (GovHost.hs:243 constructs
-- 'Wire.WorldDecl' exhaustively under -Werror), so v2 enters through
-- new types and new entry points and the v1 paths stay byte-identical.
--
-- ORACLE PHASE (HOSTS_D_PACK Task 1): this is type surface with
-- runtime stubs — the test-d wire goldens compile against it and run
-- red; the arithmetic lands only after the author's freeze. Like
-- host-governor/Wire.hs, this module is implementation surface
-- (ruling H-7): tracked, never manifest-frozen; gate 5 keeps it
-- honest by failing the frozen oracle if it drifts.
module WireU
  ( ResidualGrid (..)
  , TauDecl (..)
  , GaugeDecl (..)
  , LatentDecl (..)
  , ComparisonDecl (..)
  , MsgU (..)
  , ReplyU (..)
  , parseLatentDecl
  , parseLineU
  , helloFormU
  , renderReplyU
    -- * the v2 driver's pure half
  , WorldU
  , buildWorldU
  , helloReplyU
  , stepU
  , countsU
  ) where

import Data.List.NonEmpty (NonEmpty ((:|)), nonEmpty)
import Data.Maybe (fromMaybe)

import Wire (GuardDecl (..), Json (..), MenuItem (..), TickMsg (..),
             WorldDecl (..), parseJson, renderJson)

import PropLang.Belief (kernel)
import PropLang.Enumerate (Agent, allTerminals, allUFamilies,
                           enumerateModelsIn, enumerateUModels,
                           mkAgent, mkTauSpec, observeCounts, obsCarrier,
                           verdictKernel)
import PropLang.Eval (bernFast)
import PropLang.Membrane (Affordance (..), Choice (..), InternalAct (..),
                          Slot (..), UPilot (..), UTickState (..),
                          UTickTrace (..), affIdCode, baseRung,
                          membraneTickU, mkAffId, noEcho)
import PropLang.Syntax (Expr (..), Grid, Idx (..), Name, carrierSpace,
                        mkChan, mkGrid, mkNamespace, nsSize)
import PropLang.Belief (LogProb (LogProb), mkSpace)
import PropLang.Membrane (PureWorld (..))

-- | One declared residual component's grid (rider 1/R-D8: priced
-- world data over value-space; the invariance constant's site).
data ResidualGrid = ResidualGrid
  { rgName   :: String
  , rgPoints :: [Double]
  }
  deriving (Eq, Show)

-- | The declared owner-response spec (R-D9; grade-III residue): tau
-- points and DECLARED prior weights — marginalised, never updated.
data TauDecl = TauDecl
  { tdPoints  :: [Double]
  , tdWeights :: [Double]
  }
  deriving (Eq, Show)

-- | The declared affine gauge (R-D7 AS AMENDED at the second review,
-- 2026-07-09): affine freedom is two degrees and both are spent
-- before any second anchor could enter — the accounting layer's
-- measured-dollar payload term spends the SCALE ('gdScale' names the
-- measured unit whose slope is declared 1), and status-quo = 0
-- spends the ZERO. The erstwhile second anchor (u(reference-bad) =
-- -1) was either a tautology or a hand-set exchange rate for the
-- very component this boundary makes latent; it is DELETED, and may
-- return only as a redundancy CHECK, never as a fixing declaration.
data GaugeDecl = GaugeDecl
  { gdZero  :: String
  , gdScale :: String
  }
  deriving (Eq, Show)

-- | The @latent\@1@ utility block of a v2 world declaration: the USay
-- payload as an S-expression (parsed against the priced grammar at
-- implementation), the residual grids, the tau spec, the tick-price
-- FEATURE NAME (measured world data — never a declared constant,
-- rider 1's stratification), and the gauge.
data LatentDecl = LatentDecl
  { ldSaid      :: Json
  , ldResiduals :: [ResidualGrid]
  , ldTau       :: TauDecl
  , ldPriceName :: String
  , ldGauge     :: GaugeDecl
  }
  deriving (Eq, Show)

-- | A comparison (lottery) affordance's payload (HOSTS_D_PACK
-- section 4): two acts over measured outcomes, one at a declared
-- probability; its COST is measured units through the accounting
-- layer — never theta_ask (the stratification rule, checked by the
-- gRouting pins).
newtype ComparisonDecl = ComparisonDecl
  { cdLottery :: Json
  }
  deriving (Eq, Show)

-- | A v2 line: the handshake (v1 world declaration + the latent
-- block), a stream-tagged tick (report | verdict | outcome |
-- comparison — Nothing = untagged, the v1 reading), a batched
-- evidence array (@observe_batch@ — H's 39k-tick cost finding; a
-- wire addition, not an alphabet change), or a count-collapsed warm
-- row (@observe_counts@ — the second review's budget ruling:
-- stream tag, context features, and the (n1, n0) outcome counts.
-- Semantics are per-hypothesis likelihood exponentiation — EXACT for
-- exchangeable (iid-emission) families, and for state-carrying ones
-- (hmm / UWalk) it IS the declared warm-flattening approximation,
-- printed rather than smuggled. O(contexts x grid), not O(ticks):
-- batching removes round-trips, counts remove the ticks).
data MsgU
  = MUHello WorldDecl LatentDecl
  | MUTick (Maybe String) TickMsg
  | MUBatch [(Maybe String, TickMsg)]
  | MUCounts (Maybe String) [(String, Double)] Int Int
  deriving (Eq, Show)

-- | A v2 decision reply: choice, p1, entropy — plus the latent
-- readouts: the pointer marginal's mean ('latentMarginal' through the
-- wire) and the decision's sensitivity across the residual's support.
-- OBSERVABILITY-ONLY (consumer discipline, HOSTS_D_PACK section 8): no
-- adapter may branch on the last two fields; routing to elicitation
-- happens engine-side, by argmax over the declared menu.
data ReplyU
  = RUChoice Choice Double Double Double Bool
  | RUObserved Int Double
  | RUError String
  deriving (Eq, Show)

-- ---------------------------------------------------------------------
-- interpretation helpers (Wire.hs's idiom, module-local: look up the
-- keys you know, never enumerate — unknown keys drop, never error)
-- ---------------------------------------------------------------------

uObj :: String -> Json -> Either String [(String, Json)]
uObj _ (JObj kvs) = Right kvs
uObj what j       = Left (what ++ ": expected an object, got " ++ show j)

uArr :: String -> Json -> Either String [Json]
uArr _ (JArr xs) = Right xs
uArr what j      = Left (what ++ ": expected an array, got " ++ show j)

uStr :: String -> Json -> Either String String
uStr _ (JStr s) = Right s
uStr what j     = Left (what ++ ": expected a string, got " ++ show j)

uNum :: String -> Json -> Either String Double
uNum _ (JNum x) = Right x
uNum what j     = Left (what ++ ": expected a number, got " ++ show j)

uBool :: String -> Json -> Either String Bool
uBool _ (JBool b) = Right b
uBool what j      = Left (what ++ ": expected a bool, got " ++ show j)

uInt :: String -> Json -> Either String Int
uInt what j = do
  x <- uNum what j
  let r = round x :: Int
  if fromIntegral r == x
    then Right r
    else Left (what ++ ": expected an integer, got " ++ show x)

uReq :: String -> [(String, Json)] -> Either String Json
uReq k kvs = maybe (Left ("missing key: " ++ k)) Right (lookup k kvs)

-- | Parse a @latent\@1@ utility block (the gWire goldens are the
-- normative examples; membrane-wire.md section 6).
parseLatentDecl :: Json -> Either String LatentDecl
parseLatentDecl j = do
  kvs  <- uObj "latent block" j
  form <- uStr "utility form" =<< uReq "form" kvs
  if form /= "latent@1"
    then Left ("unsupported utility form: " ++ form)
    else do
      sd <- uReq "said" kvs
      rs <- mapM pResidual =<< uArr "residuals" =<< uReq "residuals" kvs
      ta <- pTau =<< uReq "tau" kvs
      pn <- uStr "price" =<< uReq "price" kvs
      ga <- pGauge =<< uReq "gauge" kvs
      pure (LatentDecl sd rs ta pn ga)

pResidual :: Json -> Either String ResidualGrid
pResidual j = do
  kvs <- uObj "residual" j
  nm  <- uStr "residual name" =<< uReq "name" kvs
  pts <- mapM (uNum "residual grid point") =<< uArr "grid"
           =<< uReq "grid" kvs
  pure (ResidualGrid nm pts)

pTau :: Json -> Either String TauDecl
pTau j = do
  kvs <- uObj "tau" j
  pts <- mapM (uNum "tau point") =<< uArr "points" =<< uReq "points" kvs
  ws  <- mapM (uNum "tau weight") =<< uArr "weights" =<< uReq "weights" kvs
  pure (TauDecl pts ws)

pGauge :: Json -> Either String GaugeDecl
pGauge j = do
  kvs <- uObj "gauge" j
  -- R-D7 as amended: zero + dollar-slope; no second anchor exists
  GaugeDecl <$> (uStr "gauge zero" =<< uReq "zero" kvs)
            <*> (uStr "gauge scale" =<< uReq "scale" kvs)

-- | Parse one v2 request line.
parseLineU :: String -> Either String MsgU
parseLineU s = do
  j <- parseJson s
  kvs <- uObj "request" j
  case ( lookup "membrane" kvs, lookup "tick" kvs
       , lookup "observe_batch" kvs, lookup "observe_counts" kvs ) of
    (Just _, _, _, _) -> do
      wj   <- uReq "world" kvs
      wkvs <- uObj "world" wj
      ld   <- parseLatentDecl =<< uReq "utility" wkvs
      wd   <- pWorldDeclU wkvs
      pure (MUHello wd ld)
    (_, Just t, _, _) -> uncurry MUTick <$> pTaggedTick t
    (_, _, Just b, _) ->
      MUBatch <$> (mapM pTaggedTick =<< uArr "observe_batch" b)
    (_, _, _, Just c) -> pCounts c
    _ -> Left "expected a handshake, a tick, observe_batch, or observe_counts"

-- | The dispatch seam (the Task-3 report review's fail-closed
-- ruling, 2026-07-10): the
-- DECLARED utility form routes the handshake. A line that names a
-- form is bound to the parser it named and can never fall through to
-- the other version's semantics; a line that names none is v1's, the
-- explicit default. Nothing = no form declared (not hello-shaped, or
-- a hello without a form string).
helloFormU :: String -> Maybe String
helloFormU s = case parseJson s of
  Left _  -> Nothing
  Right j -> do
    JObj kvs  <- Just j
    _         <- lookup "membrane" kvs
    JObj wkvs <- lookup "world" kvs
    JObj ukvs <- lookup "utility" wkvs
    JStr f    <- lookup "form" ukvs
    pure f

-- the v1 world block minus its utility table (the latent block
-- replaces it; wdUtility = [] by construction on this path)
pWorldDeclU :: [(String, Json)] -> Either String WorldDecl
pWorldDeclU kvs = do
  ns   <- mapM (uStr "namespace entry") =<< uArr "namespace"
            =<< uReq "namespace" kvs
  gs   <- mapM pGuardU =<< uArr "guards" =<< uReq "guards" kvs
  menu <- mapM pMenuItemU =<< uArr "menu" =<< uReq "menu" kvs
  echo <- pEchoU =<< uReq "echo" kvs
  pure (WorldDecl ns gs menu [] echo)

pGuardU :: Json -> Either String GuardDecl
pGuardU j = do
  kvs <- uObj "guard" j
  GuardDecl <$> (uStr "guard name" =<< uReq "name" kvs)
            <*> (mapM (uNum "grid point") =<< uArr "grid"
                   =<< uReq "grid" kvs)

pMenuItemU :: Json -> Either String MenuItem
pMenuItemU j = do
  kvs   <- uObj "menu item" j
  aid   <- uInt "menu id" =<< uReq "id" kvs
  nm    <- uStr "menu name" =<< uReq "name" kvs
  slots <- mapM pSlotU =<< uArr "slots" =<< uReq "slots" kvs
  pure (MenuItem aid nm slots)

pSlotU :: Json -> Either String (Name, [Double])
pSlotU j = do
  kvs <- uObj "slot" j
  (,) <$> (uStr "slot name" =<< uReq "name" kvs)
      <*> (mapM (uNum "slot grid point") =<< uArr "grid"
             =<< uReq "grid" kvs)

pEchoU :: Json -> Either String (Bool, Bool, Bool)
pEchoU j = do
  kvs <- uObj "echo" j
  (,,) <$> (uBool "last_action" =<< uReq "last_action" kvs)
       <*> (uBool "tick" =<< uReq "tick" kvs)
       <*> (uBool "ticks_spent_thinking"
              =<< uReq "ticks_spent_thinking" kvs)

pTaggedTick :: Json -> Either String (Maybe String, TickMsg)
pTaggedTick j = do
  kvs   <- uObj "tick" j
  tag   <- traverse (uStr "stream") (lookup "stream" kvs)
  fkvs  <- uObj "features" =<< uReq "features" kvs
  feats <- mapM (\(k, v) -> (,) k <$> uNum ("feature " ++ k) v) fkvs
  ev    <- traverse (uInt "evidence") (lookup "evidence" kvs)
  menu  <- traverse (\m -> mapM (uInt "menu id") =<< uArr "menu" m)
             (lookup "menu" kvs)
  pure (tag, TickMsg feats ev menu Nothing)

pCounts :: Json -> Either String MsgU
pCounts j = do
  kvs   <- uObj "observe_counts" j
  tag   <- traverse (uStr "stream") (lookup "stream" kvs)
  fkvs  <- uObj "features" =<< uReq "features" kvs
  feats <- mapM (\(k, v) -> (,) k <$> uNum ("feature " ++ k) v) fkvs
  ckvs  <- uObj "counts" =<< uReq "counts" kvs
  n1    <- maybe (Right 0) (uInt "counts 1") (lookup "1" ckvs)
  n0    <- maybe (Right 0) (uInt "counts 0") (lookup "0" ckvs)
  pure (MUCounts tag feats n1 n0)

-- | Render one v2 reply line (the RUChoice render is golden-pinned
-- byte-for-byte by the frozen oracle).
renderReplyU :: ReplyU -> String
renderReplyU r = renderJson $ case r of
  RUChoice c p h rm sens ->
    JObj [ ("choice", choiceJsonU c), ("p1", JNum p)
         , ("entropy_bits", JNum h), ("residual_mean", JNum rm)
         , ("sensitivity", JBool sens) ]
  RUObserved y l ->
    JObj [ ("observed", JNum (fromIntegral y)), ("loss_bits", JNum l) ]
  RUError e -> JObj [("error", JStr e)]

choiceJsonU :: Choice -> Json
choiceJsonU c = case c of
  Fire aid slots ->
    JObj [ ("fire", JNum (affIdCode aid))
         , ("slots", JObj [(nm, JNum v) | (nm, v) <- slots]) ]
  InternalFired Think -> JObj [("internal", JStr "think")]

-- ---------------------------------------------------------------------
-- the v2 driver's pure half (Main.hs threads the moving parts)
-- ---------------------------------------------------------------------

-- | A built latent world: the namespace charge and model count (the
-- v1 face of the reply), the declared menu, the pilot, and the
-- latent census. Agents (world + pointer + residuals) and the tick
-- state are threaded by the caller.
data WorldU = WorldU
  { wuNamespaceBits :: Double
  , wuModelCount    :: Int
  , wuULatents      :: Int
  , wuAffordances   :: [(Int, Affordance)]
  , wuPilot         :: UPilot
  }

-- the driver's declared defaults for the pointer (recorded in the
-- increment report: the pointer's value grid is the model fragment's
-- own theta geometry spoken as ubar; rates are the fragment's rho
-- points — the alphabet's grids, not new constants)
ubarGridU, rhoGridU :: Grid
ubarGridU = mkGrid "ubar"
  (0.1 :| [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9])
rhoGridU = mkGrid "rho_u"
  (0.01 :| [0.02, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5])

-- the said S-expression, parsed against the sayable surface. The
-- subset implemented covers the frozen goldens (["var", i]); richer
-- payload forms are ordinary implementation growth under the frozen
-- wire section, never silent: unknown forms error.
pSaid :: Json -> Either String (Expr '[Double, Double] Double)
pSaid j = case j of
  JArr [JStr "var", JNum 0] -> Right (Var Z)
  JArr [JStr "var", JNum 1] -> Right (Var (S Z))
  _ -> Left ("unsupported said form: " ++ show j)

-- | Validate the declaration pair and build the latent world: the
-- world agent over the declared namespace and guards (v1's own
-- enumeration), the pointer over the driver's declared ubar/rho
-- grids through the tau-owner, and one agent per declared residual —
-- each residual's channel is the SAME declared tau-owner over its
-- own grid (the comparison answer arrives through the responder
-- applied to the question, HOSTS_D_PACK section 4).
buildWorldU :: WorldDecl -> LatentDecl
            -> Either String (WorldU, Agent, NonEmpty Agent)
buildWorldU (WorldDecl ns gs menu _ echo) (LatentDecl sd rs ta pn _) = do
  nsNE <- maybe (Left "empty-namespace") Right (nonEmpty ns)
  mapM_ (\(GuardDecl nm _) ->
           if nm `elem` ns then Right ()
           else Left ("guard-name-not-in-namespace: " ++ nm)) gs
  extras <- mapM (\(GuardDecl nm pts) -> (,) nm <$> gridOfU nm pts) gs
  affs <- mapM buildAffU menu
  mapM_ (\(i, _) -> if i > 0 then Right ()
                    else Left ("non-positive-affordance-id: " ++ show i))
        affs
  case echo of
    (False, False, False) -> Right ()
    _                     -> Left "echo-unsupported-epoch-1"
  said <- pSaid sd
  tauG <- gridOfU "tau" (tdPoints ta)
  tws  <- maybe (Left "empty-tau-weights") Right (nonEmpty (tdWeights ta))
  spec <- maybe (Left "tau-weights-must-cover-the-grid") Right
                (mkTauSpec tauG tws)
  rGrids <- mapM (\(ResidualGrid nm pts) -> gridOfU nm pts) rs
  let namespace = mkNamespace nsNE
      models = enumerateModelsIn namespace extras allTerminals
      nsB = case nsSize namespace of
        1 -> 0
        k -> logBase 2 (fromIntegral k)
      vk = verdictKernel ubarGridU spec
      pointer = mkAgent (enumerateUModels vk ubarGridU rhoGridU
                                          allUFamilies)
      residAgents =
        [ mkAgent (enumerateUModels (verdictKernel g spec) g rhoGridU
                                    allUFamilies)
        | g <- rGrids ]
      askIds = [ affIdCode (mkAffId i)
               | (i, Affordance _ nm _) <- affs, nm == "ask" ]
      noiseK = kernel (mkSpace (0.5 :| []))
                      (carrierSpace obsCarrier)
                      (const (bernFast obsCarrier 0.5))
      pilot = UPilot
        { upSaid    = said
        , upVerdict = mkChan (\code -> if code `elem` askIds
                                         then vk else noiseK)
        , upOutcome = kernel (mkSpace (0.5 :| []))
                             (carrierSpace obsCarrier)
                             (bernFast obsCarrier)
        , upDepth   = baseRung
        , upPrice   = pn
        }
      w = WorldU { wuNamespaceBits = nsB
                 , wuModelCount    = length models
                 , wuULatents     = 1 + length residAgents
                 , wuAffordances  = affs
                 , wuPilot        = pilot
                 }
  pure (w, mkAgent models, pointer :| residAgents)

gridOfU :: Name -> [Double] -> Either String Grid
gridOfU nm pts =
  maybe (Left ("empty-grid: " ++ nm)) (Right . mkGrid nm) (nonEmpty pts)

buildAffU :: MenuItem -> Either String (Int, Affordance)
buildAffU (MenuItem aid nm slots) = do
  ss <- mapM (\(snm, pts) -> Slot snm <$> gridOfU snm pts) slots
  pure (aid, Affordance (mkAffId aid) nm ss)

-- | The v2 handshake reply: v1's shape plus the latent census.
helloReplyU :: WorldU -> String
helloReplyU w = renderJson $ JObj
  [ ("ok", JBool True), ("proto", JNum 1)
  , ("models", JNum (fromIntegral (wuModelCount w)))
  , ("namespace_bits", JNum (wuNamespaceBits w))
  , ("ulatents", JNum (fromIntegral (wuULatents w))) ]

streamCodeU :: Maybe String -> Either String Double
streamCodeU tag = case tag of
  Nothing           -> Right 0
  Just "report"     -> Right 0
  Just "verdict"    -> Right 1
  Just "outcome"    -> Right 2
  Just "comparison" -> Right 3
  Just other        -> Left ("unknown-stream: " ++ other)

-- | One wire tick over 'membraneTickU' (explicitly threaded state —
-- no counter resets, register 8.9/R-D11): the stream tag rides as
-- the world-published feature the driver reads; impossible evidence
-- answers an error with every moving part unchanged (R-D12).
stepU :: WorldU -> UTickState -> Agent -> NonEmpty Agent
      -> (Maybe String, TickMsg)
      -> (UTickState, Agent, NonEmpty Agent, String)
stepU w st wAg uAgs (tag, TickMsg feats ev menu _) =
  case resolved of
    Left e -> (st, wAg, uAgs, renderReplyU (RUError e))
    Right (affs, sc) ->
      let world = PureWorld { wFeats    = const (("stream", sc) : feats)
                            , wEvidence = const ev
                            , wMenu     = const affs
                            , wStep     = \s _ -> s
                            }
      in case membraneTickU world noEcho (wuPilot w) st () wAg uAgs of
           Nothing -> (st, wAg, uAgs,
                       renderReplyU (RUError "impossible-evidence"))
           Just (_, st', wAg', uAgs', tt) ->
             (st', wAg', uAgs', replyOf tt)
  where
    resolved = do
      sc <- streamCodeU tag
      affs <- mapM (\i -> maybe
                     (Left ("undeclared-affordance: " ++ show i)) Right
                     (lookup i (wuAffordances w)))
                   (fromMaybe [] menu)
      pure (affs, sc)
    replyOf tt = case (menu, ev) of
      (Nothing, Nothing) -> renderJson (JObj [("ok", JBool True)])
      (Just _, _) -> renderReplyU
        (RUChoice (utChoice tt) (utP1 tt) (utEntropy tt)
                  (utResidual tt) (utSensitivity tt))
      (Nothing, Just y) -> renderReplyU (RUObserved y (utLossBits tt))

-- | The count-collapsed warm row (wire v2's @observe_counts@),
-- routed per stream exactly as ticks are: verdict counts to the
-- pointer through its carried channel; outcome counts to the pointer
-- through the declared outcome emission; comparison counts to every
-- residual; report counts to the world agent.
countsU :: WorldU -> Agent -> NonEmpty Agent
        -> (Maybe String, [(Name, Double)], Int, Int)
        -> (Agent, NonEmpty Agent, String)
countsU w wAg uAgs@(pointer :| residuals) (tag, feats, n1, n0) =
  case streamCodeU tag of
    Left e -> (wAg, uAgs, renderReplyU (RUError e))
    Right sc -> case round sc :: Int of
      1 -> onPointer (observeCounts Nothing feats n1 n0 pointer)
      2 -> onPointer (observeCounts (Just (upOutcome (wuPilot w)))
                                    feats n1 n0 pointer)
      3 -> case traverse (observeCounts Nothing feats n1 n0) residuals of
        Nothing -> (wAg, uAgs, renderReplyU (RUError "impossible-evidence"))
        Just prs ->
          let bits = sum [ negate lp / log 2 | (LogProb lp, _) <- prs ]
          in (wAg, pointer :| map snd prs,
              renderReplyU (RUObserved (n1 + n0) bits))
      _ -> case observeCounts Nothing feats n1 n0 wAg of
        Nothing -> (wAg, uAgs, renderReplyU (RUError "impossible-evidence"))
        Just (LogProb lp, wAg') ->
          (wAg', uAgs,
           renderReplyU (RUObserved (n1 + n0) (negate lp / log 2)))
  where
    onPointer res = case res of
      Nothing -> (wAg, uAgs, renderReplyU (RUError "impossible-evidence"))
      Just (LogProb lp, p') ->
        (wAg, p' :| residuals,
         renderReplyU (RUObserved (n1 + n0) (negate lp / log 2)))
