-- | The membrane wire, pure half (HOSTS_PLAN section 1-2;
-- membrane-wire.md is the normative statement; the frozen govhost
-- oracle is the arbiter). Implementation phase of boundary H
-- (govhost-freeze, f989c42).
--
-- One process, one agent, one world. JSON-lines over stdio; the wire
-- is the membrane's three flows plus a world declaration, all data.
-- Everything in this module is pure: the IO loop lives in Main.hs and
-- nowhere else (the Host.hs discipline). @step@ is fully testable from
-- the oracle without a process.
--
-- Codec contract (strict JSON subset, canonical rendering):
--
-- * rendering emits no whitespace outside strings; object keys keep
--   insertion order; a numerically integral value renders without a
--   decimal point (@1@, not @1.0@), any other value renders as
--   Haskell 'show' (shortest round-trip); strings escape only
--   @\"@, @\\@ and @\\n@.
-- * parsing accepts whitespace between tokens and exactly the subset
--   the renderer emits; unknown object keys are IGNORED (the
--   governor's own new-key negotiation doctrine) — they parse and
--   drop, never error.
module Wire
  ( -- * JSON subset
    Json (..)
  , parseJson
  , renderJson
    -- * wire messages
  , WorldDecl (..)
  , GuardDecl (..)
  , MenuItem (..)
  , UtilRow (..)
  , TickMsg (..)
  , Msg (..)
  , Reply (..)
  , parseLine
  , renderReply
    -- * the driver's pure half
  , World (..)
  , buildWorld
  , step
  ) where

import Data.Char (isDigit, isSpace)
import Data.List.NonEmpty (nonEmpty)

import PropLang.Enumerate (Agent, Obs, allTerminals, enumerateModelsIn,
                           mkAgent)
import PropLang.Membrane (Affordance (..), Choice (..), InternalAct (..),
                          Pilot (..), PureWorld (..), Slot (..),
                          TickTrace (..), affIdCode, mkAffId, noEcho,
                          runMembrane)
import PropLang.Syntax (Grid, Name, Util, mkGrid, mkNamespace, mkUtil,
                        nsSize)

-- ---------------------------------------------------------------------
-- JSON subset
-- ---------------------------------------------------------------------

-- | The wire's value grammar. No null-vs-absent distinction is ever
-- meaningful on this wire; absent keys are the only optionality.
data Json
  = JBool Bool
  | JNum Double
  | JStr String
  | JArr [Json]
  | JObj [(String, Json)]
  deriving (Eq, Show)

renderJson :: Json -> String
renderJson j = case j of
  JBool True  -> "true"
  JBool False -> "false"
  JNum x      -> renderNum x
  JStr s      -> renderStr s
  JArr xs     -> "[" ++ commas (map renderJson xs) ++ "]"
  JObj kvs    -> "{" ++ commas [renderStr k ++ ":" ++ renderJson v
                               | (k, v) <- kvs] ++ "}"
  where
    commas []       = ""
    commas [x]      = x
    commas (x : xs) = x ++ "," ++ commas xs

renderNum :: Double -> String
renderNum x
  | x == fromInteger r = show r
  | otherwise          = show x
  where
    r = round x :: Integer

renderStr :: String -> String
renderStr s = "\"" ++ concatMap esc s ++ "\""
  where
    esc '"'  = "\\\""
    esc '\\' = "\\\\"
    esc '\n' = "\\n"
    esc c    = [c]

-- recursive descent over the subset; whitespace tolerated between
-- tokens; total (Either)
parseJson :: String -> Either String Json
parseJson s0 = do
  (v, rest) <- pValue (skipWs s0)
  case skipWs rest of
    "" -> Right v
    r  -> Left ("trailing input: " ++ take 20 r)

skipWs :: String -> String
skipWs = dropWhile isSpace

pValue :: String -> Either String (Json, String)
pValue s = case s of
  't' : r | Just r' <- stripPre "rue" r  -> Right (JBool True, r')
  'f' : r | Just r' <- stripPre "alse" r -> Right (JBool False, r')
  '"' : r                                -> pStr r
  '[' : r                                -> pArr (skipWs r) []
  '{' : r                                -> pObj (skipWs r) []
  c : _ | c == '-' || isDigit c          -> pNum s
  _ -> Left ("expected a value at: " ++ take 20 s)
  where
    stripPre [] r = Just r
    stripPre (p : ps) (c : cs) | p == c = stripPre ps cs
    stripPre _ _ = Nothing

pStr :: String -> Either String (Json, String)
pStr r = do
  (s, rest) <- pRawStr r
  pure (JStr s, rest)

pRawStr :: String -> Either String (String, String)
pRawStr = go ""
  where
    go acc ('\\' : e : r) = case e of
      '"'  -> go ('"' : acc) r
      '\\' -> go ('\\' : acc) r
      'n'  -> go ('\n' : acc) r
      _    -> Left ("unsupported escape: \\" ++ [e])
    go acc ('"' : r) = Right (reverse acc, r)
    go acc (c : r)   = go (c : acc) r
    go _ []          = Left "unterminated string"

pNum :: String -> Either String (Json, String)
pNum s =
  let (chunk, rest) = span (\c -> isDigit c || c `elem` "-+.eE") s
  in case reads chunk :: [(Double, String)] of
       [(x, "")] -> Right (JNum x, rest)
       _         -> Left ("bad number: " ++ chunk)

pArr :: String -> [Json] -> Either String (Json, String)
pArr (']' : r) acc = Right (JArr (reverse acc), r)
pArr s acc = do
  (v, r1) <- pValue s
  case skipWs r1 of
    ',' : r2 -> pArr (skipWs r2) (v : acc)
    ']' : r2 -> Right (JArr (reverse (v : acc)), r2)
    r        -> Left ("expected , or ] at: " ++ take 20 r)

pObj :: String -> [(String, Json)] -> Either String (Json, String)
pObj ('}' : r) acc = Right (JObj (reverse acc), r)
pObj ('"' : r) acc = do
  (k, r1) <- pRawStr r
  case skipWs r1 of
    ':' : r2 -> do
      (v, r3) <- pValue (skipWs r2)
      case skipWs r3 of
        ',' : r4 -> pObj (skipWs r4) ((k, v) : acc)
        '}' : r4 -> Right (JObj (reverse ((k, v) : acc)), r4)
        rr       -> Left ("expected , or } at: " ++ take 20 rr)
    rr -> Left ("expected : at: " ++ take 20 rr)
pObj s _ = Left ("expected a key or } at: " ++ take 20 s)

-- ---------------------------------------------------------------------
-- wire messages
-- ---------------------------------------------------------------------

-- | A guard-family declaration: a Get-mentionable name plus its
-- threshold grid (HOSTS_PLAN 2.4: for the governor's one-hot
-- indicators, the singleton grid [0.5]).
data GuardDecl = GuardDecl Name [Double]
  deriving (Eq, Show)

-- | A published affordance: world-owned id, display name, typed slots
-- (name, grid points). The governor's three effectors carry no slots.
data MenuItem = MenuItem Int Name [(Name, [Double])]
  deriving (Eq, Show)

-- | One row of the utility step table: an affordance id (Right) or
-- the internal think row (Left ()), with (u(y=0), u(y=1)).
data UtilRow = UtilRow (Either () Int) (Double, Double)
  deriving (Eq, Show)

-- | The handshake's world declaration.
data WorldDecl = WorldDecl
  { wdNamespace :: [Name]
  , wdGuards    :: [GuardDecl]
  , wdMenu      :: [MenuItem]
  , wdUtility   :: [UtilRow]
  , wdEcho      :: (Bool, Bool, Bool)
  }
  deriving (Eq, Show)

-- | One tick. @tmMenu@ lists offered affordance ids in NORMATIVE
-- order (argmaxEU ties resolve first-listed, CL-3 — the governor's
-- ruled order is ask, block, proceed; R1 at H's pack).
-- @tmUtility@ is the per-tick profile override (a full replacement
-- table for this tick).
data TickMsg = TickMsg
  { tmFeatures :: [(Name, Double)]
  , tmEvidence :: Maybe Obs
  , tmMenu     :: Maybe [Int]
  , tmUtility  :: Maybe [UtilRow]
  }
  deriving (Eq, Show)

-- | A parsed request line.
data Msg = MHandshake WorldDecl | MTick TickMsg
  deriving (Eq, Show)

-- | A reply line. 'RTick' carries the decision part iff a menu was
-- offered and the evidence part iff evidence arrived; both absent is
-- the silent tick (agent unmoved, @{"ok":true}@).
data Reply
  = RHandshake Int Double                -- ^ models, namespace_bits
  | RTick (Maybe (Choice, Double, Double)) (Maybe (Obs, Double))
      -- ^ (choice, p1, entropy_bits); (observed, loss_bits)
  | RError String
  deriving (Eq, Show)

-- ---------------------------------------------------------------------
-- message interpretation (unknown keys ignored, by construction:
-- interpretation LOOKS UP the keys it knows and never enumerates)
-- ---------------------------------------------------------------------

jLookup :: String -> [(String, Json)] -> Maybe Json
jLookup = lookup

asObj :: String -> Json -> Either String [(String, Json)]
asObj _ (JObj kvs) = Right kvs
asObj what j       = Left (what ++ ": expected an object, got " ++ show j)

asArr :: String -> Json -> Either String [Json]
asArr _ (JArr xs) = Right xs
asArr what j      = Left (what ++ ": expected an array, got " ++ show j)

asStr :: String -> Json -> Either String String
asStr _ (JStr s) = Right s
asStr what j     = Left (what ++ ": expected a string, got " ++ show j)

asNum :: String -> Json -> Either String Double
asNum _ (JNum x) = Right x
asNum what j     = Left (what ++ ": expected a number, got " ++ show j)

asBool :: String -> Json -> Either String Bool
asBool _ (JBool b) = Right b
asBool what j      = Left (what ++ ": expected a bool, got " ++ show j)

asInt :: String -> Json -> Either String Int
asInt what j = do
  x <- asNum what j
  let r = round x :: Int
  if fromIntegral r == x
    then Right r
    else Left (what ++ ": expected an integer, got " ++ show x)

req :: String -> [(String, Json)] -> Either String Json
req k kvs = maybe (Left ("missing key: " ++ k)) Right (jLookup k kvs)

parseLine :: String -> Either String Msg
parseLine s = do
  j <- parseJson s
  kvs <- asObj "request" j
  case (jLookup "membrane" kvs, jLookup "tick" kvs) of
    (Just _, _)        -> MHandshake <$> (pWorldDecl =<< req "world" kvs)
    (_, Just t)        -> MTick <$> pTick t
    (Nothing, Nothing) -> Left "expected a handshake or a tick"

pWorldDecl :: Json -> Either String WorldDecl
pWorldDecl j = do
  kvs   <- asObj "world" j
  ns    <- mapM (asStr "namespace entry") =<< asArr "namespace"
             =<< req "namespace" kvs
  gs    <- mapM pGuard =<< asArr "guards" =<< req "guards" kvs
  menu  <- mapM pMenuItem =<< asArr "menu" =<< req "menu" kvs
  util  <- pUtilTable =<< req "utility" kvs
  echo  <- pEcho =<< req "echo" kvs
  pure (WorldDecl ns gs menu util echo)

pGuard :: Json -> Either String GuardDecl
pGuard j = do
  kvs <- asObj "guard" j
  nm  <- asStr "guard name" =<< req "name" kvs
  pts <- mapM (asNum "grid point") =<< asArr "grid" =<< req "grid" kvs
  pure (GuardDecl nm pts)

pMenuItem :: Json -> Either String MenuItem
pMenuItem j = do
  kvs   <- asObj "menu item" j
  aid   <- asInt "menu id" =<< req "id" kvs
  nm    <- asStr "menu name" =<< req "name" kvs
  slots <- mapM pSlot =<< asArr "slots" =<< req "slots" kvs
  pure (MenuItem aid nm slots)

pSlot :: Json -> Either String (Name, [Double])
pSlot j = do
  kvs <- asObj "slot" j
  nm  <- asStr "slot name" =<< req "name" kvs
  pts <- mapM (asNum "slot grid point") =<< asArr "grid" =<< req "grid" kvs
  pure (nm, pts)

pUtilTable :: Json -> Either String [UtilRow]
pUtilTable j = do
  kvs  <- asObj "utility" j
  form <- asStr "utility form" =<< req "form" kvs
  if form /= "table@1"
    then Left ("unsupported utility form: " ++ form)
    else mapM pUtilRow =<< asArr "utility rows" =<< req "rows" kvs

pUtilRow :: Json -> Either String UtilRow
pUtilRow j = do
  kvs <- asObj "utility row" j
  u   <- asArr "u" =<< req "u" kvs
  uv  <- case u of
    [a, b] -> (,) <$> asNum "u[0]" a <*> asNum "u[1]" b
    _      -> Left "u: expected exactly two entries"
  case (jLookup "fire" kvs, jLookup "internal" kvs) of
    (Just f, _) -> (\i -> UtilRow (Right i) uv) <$> asInt "fire" f
    (_, Just i) -> do
      nm <- asStr "internal" i
      if nm == "think"
        then Right (UtilRow (Left ()) uv)
        else Left ("unknown internal act: " ++ nm)
    _ -> Left "utility row: expected fire or internal"

pEcho :: Json -> Either String (Bool, Bool, Bool)
pEcho j = do
  kvs <- asObj "echo" j
  (,,) <$> (asBool "last_action" =<< req "last_action" kvs)
       <*> (asBool "tick" =<< req "tick" kvs)
       <*> (asBool "ticks_spent_thinking"
              =<< req "ticks_spent_thinking" kvs)

pTick :: Json -> Either String TickMsg
pTick j = do
  kvs   <- asObj "tick" j
  fkvs  <- asObj "features" =<< req "features" kvs
  feats <- mapM (\(k, v) -> (,) k <$> asNum ("feature " ++ k) v) fkvs
  ev    <- traverse (asInt "evidence") (jLookup "evidence" kvs)
  menu  <- traverse (\m -> mapM (asInt "menu id") =<< asArr "menu" m)
             (jLookup "menu" kvs)
  over  <- traverse pUtilTable (jLookup "utility" kvs)
  pure (TickMsg feats ev menu over)

-- ---------------------------------------------------------------------
-- reply rendering
-- ---------------------------------------------------------------------

renderReply :: Reply -> String
renderReply r = renderJson $ case r of
  RHandshake n b ->
    JObj [ ("ok", JBool True), ("proto", JNum 1)
         , ("models", JNum (fromIntegral n)), ("namespace_bits", JNum b) ]
  RTick Nothing Nothing -> JObj [("ok", JBool True)]
  RTick mc mo ->
    JObj (concat
      [ case mc of
          Nothing -> []
          Just (c, p, h) ->
            [ ("choice", choiceJson c), ("p1", JNum p)
            , ("entropy_bits", JNum h) ]
      , case mo of
          Nothing -> []
          Just (y, l) ->
            [ ("observed", JNum (fromIntegral y)), ("loss_bits", JNum l) ]
      ])
  RError e -> JObj [("error", JStr e)]

choiceJson :: Choice -> Json
choiceJson c = case c of
  Fire aid slots ->
    JObj [ ("fire", JNum (affIdCode aid))
         , ("slots", JObj [(nm, JNum v) | (nm, v) <- slots]) ]
  InternalFired Think -> JObj [("internal", JStr "think")]

-- ---------------------------------------------------------------------
-- the driver's pure half
-- ---------------------------------------------------------------------

-- | A built world: the enumerated agent's seed data plus everything a
-- tick needs. The agent itself is threaded separately (the one moving
-- part).
data World = World
  { wNamespaceBits :: Double            -- ^ the mention charge: 0 for a singleton
  , wModelCount    :: Int               -- ^ size of the enumeration
  , wAffordances   :: [(Int, Affordance)]  -- ^ declared menu, by id
  , wUtility       :: Util Choice Obs   -- ^ the step table, folded
  , wRows          :: [UtilRow]         -- ^ the declared rows (for validation)
  }

-- | Validate and build (membrane-wire.md section 2): namespace
-- nonempty and covering every guard name; every grid nonempty; menu
-- ids positive and unique; every menu id covered by a utility row and
-- the internal think row present; echo all-false (epoch 1). The host
-- gets THE agent — the terminal set is not on the wire.
buildWorld :: WorldDecl -> Either String (World, Agent, Reply)
buildWorld (WorldDecl ns gs menu rows echo) = do
  nsNE <- maybe (Left "empty-namespace") Right (nonEmpty ns)
  mapM_ (\(GuardDecl nm _) ->
           if nm `elem` ns then Right ()
           else Left ("guard-name-not-in-namespace: " ++ nm)) gs
  extras <- mapM (\(GuardDecl nm pts) -> (,) nm <$> gridOf nm pts) gs
  affs <- mapM buildAff menu
  let ids = [i | (i, _) <- affs]
  mapM_ (\i -> if i > 0 then Right ()
               else Left ("non-positive-affordance-id: " ++ show i)) ids
  if distinct ids then Right ()
    else Left "duplicate-affordance-id"
  mapM_ (\i -> if any (\(UtilRow k _) -> k == Right i) rows then Right ()
               else Left ("missing-utility-row: " ++ show i)) ids
  if any (\(UtilRow k _) -> k == Left ()) rows then Right ()
    else Left "missing-internal-row"
  case echo of
    (False, False, False) -> Right ()
    _                     -> Left "echo-unsupported-epoch-1"
  let namespace = mkNamespace nsNE
      models    = enumerateModelsIn namespace extras allTerminals
      nsB       = case nsSize namespace of
                    1 -> 0
                    k -> logBase 2 (fromIntegral k)
      w = World { wNamespaceBits = nsB
                , wModelCount    = length models
                , wAffordances   = affs
                , wUtility       = rowsToUtil rows
                , wRows          = rows
                }
  pure (w, mkAgent models, RHandshake (wModelCount w) nsB)
  where
    distinct xs = length xs == length (foldr insertNew [] xs)
    insertNew x acc = if x `elem` acc then acc else x : acc

gridOf :: Name -> [Double] -> Either String Grid
gridOf nm pts =
  maybe (Left ("empty-grid: " ++ nm)) (Right . mkGrid nm) (nonEmpty pts)

buildAff :: MenuItem -> Either String (Int, Affordance)
buildAff (MenuItem aid nm slots) = do
  ss <- mapM (\(snm, pts) -> Slot snm <$> gridOf snm pts) slots
  pure (aid, Affordance (mkAffId aid) nm ss)

-- fold the step table into the opaque world-data utility; ids resolve
-- through affIdCode (world-owned, stable). Unlisted fire ids are
-- unreachable for validated menus; they price at negative infinity so
-- the fold stays total without ever selecting them.
rowsToUtil :: [UtilRow] -> Util Choice Obs
rowsToUtil rows = mkUtil u
  where
    u (Fire aid _) y = pick (Right (round (affIdCode aid) :: Int)) y
    u (InternalFired Think) y = pick (Left ()) y
    pick k y = case [uv | UtilRow k' uv <- rows, k' == k] of
      ((u0, u1) : _) -> if y == 1 then u1 else u0
      []             -> -1 / 0

-- | One wire tick over the frozen loop: @runMembrane@ with @n = 1@
-- over a constant 'PureWorld' (wStep = const) — the frozen tick
-- arithmetic verbatim (HOSTS_PLAN 2.3). Total: impossible evidence
-- returns @RError "impossible-evidence"@ with the agent UNCHANGED; an
-- undeclared menu id or an override table missing an offered row is
-- an error reply, agent unchanged.
step :: World -> Agent -> TickMsg -> (Agent, Reply)
step w ag (TickMsg feats ev menu override) =
  case resolve of
    Left e -> (ag, RError e)
    Right (affs, u) ->
      let world = PureWorld { wFeats    = const feats
                            , wEvidence = const ev
                            , wMenu     = const affs
                            , wStep     = \s _ -> s
                            }
      in case runMembrane world noEcho (PilotEU u) 1 () ag of
           Nothing -> (ag, RError "impossible-evidence")
           Just (ag', ts) -> case ts of
             [tt] -> (ag', reply tt)
             _    -> (ag, RError "internal: one tick, one trace")
  where
    offered = maybe [] id menu
    resolve = do
      affs <- mapM (\i ->
                maybe (Left ("undeclared-affordance: " ++ show i)) Right
                      (lookup i (wAffordances w)))
              offered
      u <- case override of
        Nothing   -> Right (wUtility w)
        Just rows -> do
          mapM_ (\i -> if any (\(UtilRow k _) -> k == Right i) rows
                         then Right ()
                         else Left ("invalid-override: " ++ show i))
                offered
          if any (\(UtilRow k _) -> k == Left ()) rows
            then Right ()
            else Left "invalid-override: internal row"
          Right (rowsToUtil rows)
      pure (affs, u)
    reply tt =
      RTick (case menu of
               Nothing -> Nothing
               Just _  -> Just (ttChoice tt, ttP1 tt, ttEntropy tt))
            (case ev of
               Nothing -> Nothing
               Just y  -> Just (y, ttLossBits tt))
