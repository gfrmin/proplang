{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}

-- | The host boundary (Phase 2 of the exact re-founding;
-- exact-freeze-r0): the ONLY module in src/ whose types may mention
-- IO. 'draw' is CL-2 made compiler-checked. The wire (membrane-wire
-- v1 as amended through the exact boundary) is the pure session core
-- 'serveLine'; 'hostMain' is the line loop (gate 3).
--
-- WIRE CHANGES AT THIS BOUNDARY (each World-required or forced by a
-- deletion; the close pack records all):
--   * hello REQUIRES world.codebooks.theta (the emission codebook) —
--     the baked theta point-set left src (E3); codebooks.rho optional
--     (absent = no walk family); every guard family's codebook comes
--     from world.guards, which must COVER the namespace's guard use.
--   * the said forms "/", "log", "exp", "neg" are GONE with their
--     terminals (unknown form = bad hello, fail-closed); "+" parses
--     to the addM macro (priced at its expansion, like "=").
--   * ticks pass THE DOOR: features must cover the declared
--     namespace exactly (with the tick's assignment supplying the
--     writable names) — the 0.0-dormancy default is dead; an
--     under-specified tick is an error reply.
--   * obs_arity serves ANY K >= 2 through the exact K-ary route
--     (enumerateWithArity; the SevenSeats Mul-form) — the W3
--     capability carried, the K=2 coincidence pinned exactly.
--   * selection runs through Membrane.policyPick — the pairwise-
--     substituting fold, pinned to the policyPickKS sentence route
--     (opening ruling 3); the host fold is dead.
module PropLang.Host
  ( draw
#if !defined(DROP_CODE) && !defined(DROP_EXPECT) && !defined(DROP_COND)
  -- the wire session dies with the likelihood layer, the prevision,
  -- or conditioning — the agent's three load-bearing verbs
  , HostState
  , hostStart
  , serveLine
  , hostMain
#endif
  ) where

import Data.Word (Word64)
import Foreign.Marshal.Alloc (allocaBytes)
import Foreign.Ptr (Ptr, castPtr)
import Foreign.Storable (peek)
import System.IO (IOMode (ReadMode), hGetBuf, withBinaryFile)

import PropLang.Belief (Belief, points, spacePoints, weights)

#if !defined(DROP_CODE) && !defined(DROP_EXPECT) && !defined(DROP_COND)
import Data.Char (isDigit)
import Data.List (intercalate)
import Data.List.NonEmpty (NonEmpty ((:|)))
import System.IO (BufferMode (LineBuffering), hSetBuffering, isEOF, stdout)

import PropLang.Enumerate (AgentS, agentObsPoints, breadthEmpty,
                           enumerateWith, enumerateWithBreadth, fragFull,
                           mkBreadth, observeS, predictMassS, sentenceAgent)
import PropLang.Eval (Features, Vals (..), evalx, mkEnvIn)
import PropLang.Membrane (menuAssignments, predictiveBelief,
                          mintQ, policyPick, reindexUtility, substW)
import PropLang.Report (bitsView, entropyAgent)
import PropLang.Syntax
#endif

-- | The sole source of randomness, host-side, called AFTER the language
-- has finished constructing the belief. Used only to simulate worlds.
--
-- Sampling goes through the sealed reasoner's public read-only views
-- ('points'/'weights'): a cumulative walk in space order — the host cannot see log-weights any more than a program
-- can. Entropy comes from the operating system; src/ depends on base
-- only, so there is no in-process generator (and hence no seed) anywhere
-- in the language or its host boundary.
draw :: Belief a -> IO a
draw b = do
  u <- unitSample
  let walk _ [] = error "draw: belief over an empty space (unreachable)"
      walk _ [(x, _)] = x
      walk acc ((x, p) : rest) =
        let acc' = acc + p
        in if u <= acc' then x else walk acc' rest
  pure (walk 0 (zip (points b) (map fromRational (weights b))))

-- A uniform draw in [0, 1) from /dev/urandom.
unitSample :: IO Double
unitSample =
  withBinaryFile "/dev/urandom" ReadMode $ \h ->
    allocaBytes 8 $ \buf -> do
      n <- hGetBuf h buf 8
      if n /= 8
        then ioError (userError "draw: short read from /dev/urandom")
        else do
          w <- peek (castPtr buf :: Ptr Word64)
          pure (fromIntegral w / 2 ^^ (64 :: Int))

#if !defined(DROP_CODE) && !defined(DROP_EXPECT) && !defined(DROP_COND)
-- ------------------------- mini JSON -------------------------------
-- The wire is JSON-lines (membrane-wire.md §1); the reader below
-- covers the whole grammar the wire can utter, hand-rolled so no
-- dependency enters the frozen build plan. Rendering is canonical
-- (§1: insertion-order keys, integral values without a decimal
-- point, Haskell 'show' for the rest).

data J = JNum Double | JStr String | JBool Bool | JNull
       | JArr [J] | JObj [(String, J)]
  deriving (Eq, Show)

type P a = String -> Maybe (a, String)

skipWs :: String -> String
skipWs = dropWhile (`elem` " \t\r\n")

pJson :: P J
pJson s0 = case skipWs s0 of
  '{' : r -> pObj r
  '[' : r -> pArr r
  '"' : r -> do (str, r') <- pStr r; pure (JStr str, r')
  't' : 'r' : 'u' : 'e' : r -> pure (JBool True, r)
  'f' : 'a' : 'l' : 's' : 'e' : r -> pure (JBool False, r)
  'n' : 'u' : 'l' : 'l' : r -> pure (JNull, r)
  r -> pNum r

pStr :: P String
pStr s = go s ""
  where
    go ('\\' : c : r) acc = go r (unesc c : acc)
    go ('"' : r) acc = pure (reverse acc, r)
    go (c : r) acc = go r (c : acc)
    go [] _ = Nothing
    unesc c = case c of 'n' -> '\n'; 't' -> '\t'; x -> x

pNum :: P J
pNum s =
  let (tok, r) = span (\c -> isDigit c || c `elem` "-+.eE") s
  in case reads tok :: [(Double, String)] of
       [(d, "")] -> pure (JNum d, r)
       _         -> Nothing

pObj :: P J
pObj s0 = case skipWs s0 of
  '}' : r -> pure (JObj [], r)
  _ -> go s0 []
  where
    go s acc = case skipWs s of
      '"' : r -> do
        (k, r1) <- pStr r
        r2 <- case skipWs r1 of ':' : x -> pure x; _ -> Nothing
        (v, r3) <- pJson r2
        case skipWs r3 of
          ',' : r4 -> go r4 ((k, v) : acc)
          '}' : r4 -> pure (JObj (reverse ((k, v) : acc)), r4)
          _        -> Nothing
      _ -> Nothing

pArr :: P J
pArr s0 = case skipWs s0 of
  ']' : r -> pure (JArr [], r)
  _ -> go s0 []
  where
    go s acc = do
      (v, r) <- pJson s
      case skipWs r of
        ',' : r1 -> go r1 (v : acc)
        ']' : r1 -> pure (JArr (reverse (v : acc)), r1)
        _        -> Nothing

parseLine :: String -> Maybe J
parseLine l = case pJson l of
  Just (j, rest) | null (skipWs rest) -> Just j
  _ -> Nothing

oGet :: String -> J -> Maybe J
oGet k (JObj kvs) = lookup k kvs
oGet _ _ = Nothing

jNum :: J -> Maybe Double
jNum (JNum d) = Just d
jNum _ = Nothing

jStr :: J -> Maybe String
jStr (JStr s) = Just s
jStr _ = Nothing

-- ------------------------- rendering --------------------------------

rNum :: Double -> String
rNum d
  | d == fromIntegral (round d :: Integer) && abs d < 1e15 =
      show (round d :: Integer)
  | otherwise = show d

rAct :: Features -> String
rAct asg =
  "{" ++ commaSep [ "\"" ++ nm ++ "\": " ++ rNum (fromRational v)
                  | (nm, v) <- asg ] ++ "}"

commaSep :: [String] -> String
commaSep [] = ""
commaSep xs = foldr1 (\a b -> a ++ ", " ++ b) xs

errLine :: String -> String
errLine m = "{\"error\": \"" ++ m ++ "\"}"

-- ------------------------- the session ------------------------------

-- | The world as the handshake declared it (R4: the old Host 'World'
-- record is SUBSUMED — the declared codebooks build a Syntax-level
-- enumeration; this record keeps only what ticks need).
--
-- Type derivation (§8c forward rule): FENCE — host machinery, the
-- wire's own session state, outside the language (gate 3's module).
data SessionW = SessionW
  { swNs :: Namespace
  , swAtom :: Grid                 -- the obs atom codebook (derived
                                   -- from the declared carrier)
  , swMenu :: [(Name, Grid)]
  , swUSaid :: Maybe (Expr '[Rational, Rational] Rational)
  , swClock :: Maybe (Rational, Int)
    -- ^ the declared internal-act row: (price of think, batch) —
    -- the wire's clock (frozen membrane section 2, the trampoline
    -- boundary); Nothing means the shipped selection byte-identically
  }

data HostState = HostAwait | HostLive SessionW AgentS

-- | The pre-handshake state.
hostStart :: HostState
hostStart = HostAwait

-- | One wire line in, one reply line out — the ENTIRE protocol, pure.
serveLine :: HostState -> String -> (HostState, String)
serveLine st line = case parseLine line of
  Nothing -> (st, errLine "parse")
  Just j -> case st of
    HostAwait -> hello st j
    HostLive w ag -> case oGet "tick" j of
      Just t  -> tick w ag t
      Nothing -> (st, errLine "expected tick")

-- exact embed of a wire number (binary64 embeds exactly in Q)
jQ :: J -> Maybe Rational
jQ v = do
  d <- jNum v
  if isNaN d || isInfinite d then Nothing else Just (realToFrac d)

-- The handshake. Validation failures answer an error line and the
-- process stays on the handshake state.
hello :: HostState -> J -> (HostState, String)
hello st j = maybe (st, errLine "bad hello") id $ do
  w <- oGet "world" j
  JArr nsJ <- oGet "namespace" w
  ns <- mapM jStr nsJ
  JArr gsJ <- oGet "guards" w
  gs <- mapM pairGrid gsJ
  menu <- case oGet "menu" w of
    Just (JArr ms) -> mapM pairGrid ms
    _              -> Just []
  -- THE WORLD'S CODEBOOKS (E3: the emission codebook is world data;
  -- theta REQUIRED, rho optional — absent means no walk family)
  cbs <- oGet "codebooks" w
  thetaG <- pairGridNamed "theta" =<< oGet "theta" cbs
  mRhoG <- case oGet "rho" cbs of
    Nothing -> pure Nothing
    Just rj -> Just <$> pairGridNamed "rho" rj
  uSaidB <- case oGet "utility" w of
    Just u -> do
      JStr "said@1" <- oGet "form" u
      sexp <- oGet "said" u
      case oGet "cgrid" u of
        Nothing -> do
          prog <- parseSaid sexp
          pure (Just (prog, False))
        Just (JArr ptsJ) -> do
          pts <- mapM jQ ptsJ
          p0 : prest <- pure pts
          prog <- parseSaidIn pts (mkGrid "u" (p0 :| prest)) sexp
          pure (Just (prog, True))
        Just _ -> Nothing
    Nothing -> pure Nothing
  clockRow <- case oGet "clock" w of
    Nothing -> pure Nothing
    Just (JArr [row]) -> do
      JStr "think" <- oGet "name" row
      -- the internal name may not collide with any declared
      -- namespace name (frozen membrane section 2, the mandate-5
      -- repair): {"act": {"think": v}} and {"internal": "think"}
      -- never denote in one session — collision is a bad hello
      True <- pure ("think" `notElem` ns)
      pQ <- jQ =<< oGet "price" row
      JNum bN <- oGet "batch" row
      let bI = round bN :: Int
      True <- pure (fromIntegral bI == bN && bI >= 1)
      pure (Just (pQ, bI))
    Just _ -> Nothing
  arK <- case oGet "obs_arity" w of
    Nothing -> pure Nothing
    Just (JNum v) -> do
      True <- pure (not (isNaN v || isInfinite v))
      let r = round v :: Int
      True <- pure (fromIntegral r == v && r >= 2)
      pure (Just r)
    Just _ -> Nothing
  -- THE BREADTH KEY (the OB-19 heir; breadth-sitting-r0's authority):
  -- world data declaring the richer family's extent. The door PARSES
  -- the JSON shapes; mkBreadth is THE validator (the ladder as
  -- climbed) - a Nothing from it IS the refusal, fail-closed.
  brDecl <- case oGet "breadth" w of
    Nothing -> pure breadthEmpty
    Just bj -> do
      ps <- case oGet "pairs" bj of
        Nothing -> pure []
        Just (JArr pj) -> mapM pairIx pj
        Just _ -> Nothing
      nl <- case oGet "null" bj of
        Nothing -> pure False
        Just (JBool bv) -> pure bv
        Just _ -> Nothing
      mkBreadth (maybe 2 id arK) ps nl
  n0 : nrest <- pure ns
  let inNs nm = nm `elem` ns
  if not (all (inNs . fst) gs && all (inNs . fst) menu)
    then pure (st, errLine "names outside namespace")
    else do
      do
          let nsN = mkNamespace (n0 :| nrest)
              kA = maybe 2 id arK
              obsC = mkCarrier "obs" (0 :| [1 .. kA - 1])
              atomG = atomGridOfC obsC
              -- the ABSENT key is the plain route; a DECLARED arity
              -- (any K >= 2) is the K-ary route — declared-2 vs
              -- absent is the g2 coincidence, pinned EXACTLY in
              -- test-pin/Arity, never a branch on 2
              pop = case arK of
                Nothing -> enumerateWith nsN obsC thetaG gs mRhoG fragFull
                Just k -> enumerateWithBreadth brDecl k nsN obsC thetaG gs
                            mRhoG fragFull
              ag = sentenceAgent nsN pop
              uSaid = fmap fst uSaidB
              ubPart = case uSaidB of
                Just (prog, True) ->
                  ", \"utility_bits\": "
                  ++ show (bitsView (weightIn nsN prog))
                _ -> ""
              nsb = bitsView (1 / fromIntegral (length ns))
              reply = "{\"ok\": true, \"proto\": 1, \"models\": "
                      ++ show (length pop) ++ ", \"namespace_bits\": "
                      ++ show nsb ++ ubPart ++ "}"
          pure (HostLive (SessionW nsN atomG menu uSaid clockRow) ag, reply)
  where
    pairGrid g = do
      nm <- jStr =<< oGet "name" g
      grid <- pairGridNamed nm =<< oGet "grid" g
      pure (nm, grid)
    pairGridNamed nm (JArr vsJ) = do
      vs <- mapM jQ vsJ            -- jQ refuses NaN/inf AT THE DOOR
      v0 : vrest <- pure vs
      pure (mkGrid nm (v0 :| vrest))
    pairGridNamed _ _ = Nothing
    pairIx (JArr [xa, xb]) = (,) <$> jIx xa <*> jIx xb
    pairIx _ = Nothing
    jIx v = do
      JNum d <- pure v
      True <- pure (not (isNaN d || isInfinite d))
      let r = round d :: Int
      True <- pure (fromIntegral r == d)
      pure r

-- the obs atom codebook from a declared carrier (the same derivation
-- Enumerate uses; minted here for the session record)
atomGridOfC :: Carrier Int -> Grid
atomGridOfC c =
  case map fromIntegral (spacePoints (carrierSpace c)) of
    (p : ps) -> mkGrid (carrierName c ++ "-atoms") (p :| ps)
    [] -> error "atomGridOfC: empty carrier (unreachable: mkCarrier is NonEmpty)"

-- One tick under THE DOOR: the tick's features plus its assignment
-- must cover the declared namespace exactly; the choice runs through
-- the SENTENCES (policyPick when no clock is declared — the
-- substituting selection, issue #24's repair; pickWire's think-row
-- when the world declared its clock, the think row LAST); the
-- reported predictive reads at feats ++ act (post-choice,
-- pre-observation — R5's geometry); evidence folds at feats ++ act
-- (at feats ++ the wait head on an internal tick: inaction while
-- thinking, register R8); a refused door or impossible evidence is
-- an error reply and the agent is unmoved. A tick the internal act
-- wins replies {"internal": "think"} — nothing fires on the wire.
tick :: SessionW -> AgentS -> J -> (HostState, String)
tick w ag t = either (\m -> (HostLive w ag, errLine m)) id $ do
  feats <- note "bad tick" $ case oGet "features" t of
    Just (JObj kvs) -> mapM (\(k, v) -> (,) k <$> jQ v) kvs
    Nothing         -> Just []
    _               -> Nothing
  menuNames <- note "bad tick" $ case oGet "menu" t of
    Just (JArr ms) -> Just <$> mapM jStr ms
    Nothing        -> pure Nothing
    _              -> Nothing
  let evid = oGet "evidence" t >>= jQ
      writable = map fst (swMenu w)
  if any ((`elem` writable) . fst) feats
    then Left "feature/assignment collision"
    else do
      mOpts <- note "bad tick" $ case menuNames of
        Nothing -> Just Nothing
        Just nms -> do
          grids <- mapM (\nm -> (,) nm <$> lookup nm (swMenu w)) nms
          Just (Just (menuAssignments grids))
      -- Left act = an external assignment fires; Right waitH = the
      -- internal act won (the wait head rides along for the
      -- evidence fold)
      actOrThink <- case mOpts of
        Nothing -> Right (Left [])
        Just [] -> Right (Left [])
        Just opts@(o0 : _) -> case swUSaid w of
          -- no utility: the option space's head fires as a plain
          -- EXTERNAL act (Left = external per the legend above;
          -- repaired at breadth-freeze-r0 - the old comment read
          -- "wait: the option space's head", contradicting the legend
          -- three lines up; routed by the readout close, VII.3)
          Nothing -> Right (Left o0)
          Just u -> do
            scored <- mapM (\c -> do
                        b <- predictiveBelief (feats ++ c) ag
                        Right (c, b))
                      opts
            case swClock w of
              Nothing -> do
                picked <- policyPick (swNs w) feats (swAtom w) u scored
                Right (Left (maybe o0 fst picked))
              Just (price, d) -> do
                tv <- thinkValue d (swNs w) feats (swAtom w) u opts ag
                r <- pickWire (swNs w) feats (swAtom w) u scored price tv
                case r of
                  PickThink   -> Right (Right o0)
                  PickExt a _ -> Right (Left a)
      case actOrThink of
        Right waitH -> case evid of
          Nothing -> Right (HostLive w ag, "{\"internal\": \"think\"}")
          Just yQ -> do
            let y = round (fromRational yQ :: Double) :: Int
            (m, ag') <- observeS (feats ++ waitH) y ag
            Right ( HostLive w ag'
                  , "{" ++ commaSep [ "\"internal\": \"think\""
                                    , "\"observed\": " ++ show y
                                    , "\"loss_bits\": " ++ show (bitsView m)
                                    ] ++ "}" )
        Left act -> tickExternal w ag feats mOpts evid act

-- the external half of the tick (the pre-clock reply, byte-identical)
tickExternal :: SessionW -> AgentS -> Features -> Maybe [Features]
             -> Maybe Rational -> Features
             -> Either String (HostState, String)
tickExternal w ag feats mOpts evid act = do
      let full = feats ++ act
      decPart <- case mOpts of
        Nothing -> Right []
        Just _ -> do
          p1 <- predictMassS full 1 ag
          vec <- mapM (\j -> predictMassS full j ag) (agentObsPoints ag)
          let hB = entropyAgent ag
          Right ([ "\"act\": " ++ rAct act
                 , "\"p1\": " ++ show (fromRational p1 :: Double)
                 , "\"entropy_bits\": " ++ show hB ]
                 ++ readoutFields vec)
      case evid of
        Nothing
          | null decPart -> Right (HostLive w ag, "{\"ok\": true}")
          | otherwise ->
              Right (HostLive w ag, "{" ++ commaSep decPart ++ "}")
        Just yQ -> do
          let y = round (fromRational yQ :: Double) :: Int
          (m, ag') <- observeS full y ag
          let evPart = [ "\"observed\": " ++ show y
                       , "\"loss_bits\": " ++ show (bitsView m) ]
          Right ( HostLive w ag'
                , "{" ++ commaSep (decPart ++ evPart) ++ "}" )

-- The K-ary readout (#20): observability ONLY, the residual_mean /
-- sensitivity class of membrane-wire section 6.4. Telemetry on the
-- reply; no decision path reads it.
readoutFields :: [Rational] -> [String]
readoutFields vec = case vec of
  [] -> []
  (v0 : rest) ->
    [ "\"p0\": " ++ rQ v0
    , "\"argmax_code\": " ++ show jStar
    , "\"p_argmax\": " ++ rQ vStar
    , "\"p_codes\": [" ++ intercalate ", " (map rQ vec) ++ "]" ]
    where
      rQ q = show (fromRational q :: Double)
      step (bi, bv) (i, v) = if v > bv then (i, v) else (bi, bv)
      (jStar, vStar) = foldl step (0 :: Int, v0) (zip [1 ..] rest)

note :: String -> Maybe a -> Either String a
note m = maybe (Left m) Right

-- the wire policy's outcome: an external assignment or the internal act
data WirePick = PickExt Features (Belief Int) | PickThink

-- the wire policy at a declared clock: the SAME pairwise-substituting
-- fold picks the best external row (policyPick — one engine, clause 5
-- of chooseeu-sitting-r0), then the think row enters as the FINAL
-- challenger (bound value minus the declared price, think LAST,
-- displaces iff STRICTLY greater — the chooseKS order's convention,
-- pinned by the family's price-0 tie cell)
pickWire :: Namespace -> Features -> Grid
         -> Expr '[Rational, Rational] Rational
         -> [(Features, Belief Int)] -> Rational -> Rational
         -> Either String WirePick
pickWire ns feats atomG u cands price tv = do
  mBest <- policyPick ns feats atomG u cands
  case mBest of
    Nothing -> Right PickThink
    Just (bAsn, bB) -> do
      let uB :: forall e. Expr (Rational ': e) Rational
          uB = reindexUtility atomG u
          pick :: Expr '[Rational, B Int] Rational
          pick = If (Gt (Sub (Var Z) (mintQ price))
                        (Expect (Var (S Z)) (substW bAsn uB)))
                    (mintQ 1) (mintQ 0)
          cover = feats ++ [ p | p <- bAsn, fst p `notElem` map fst feats ]
      env <- mkEnvIn ns cover (tv :. bB :. VNil)
      pure (if evalx pick env == 1 then PickThink else PickExt bAsn bB)

-- the AgentS-level preposterior (the engine lookahead, a fast path;
-- future folds at feats ++ the wait head — inaction while thinking,
-- register R8)
thinkValue :: Int -> Namespace -> Features -> Grid
           -> Expr '[Rational, Rational] Rational
           -> [Features] -> AgentS -> Either String Rational
thinkValue d ns feats atomG u opts ag
  | d <= 0 = do
      scored <- mapM (\c -> do
                  b <- predictiveBelief (feats ++ c) ag
                  Right (c, b))
                opts
      best <- policyPick ns feats atomG u scored
      case best of
        Nothing -> Right 0
        Just (asn, b) -> do
          let uB :: forall e. Expr (Rational ': e) Rational
              uB = reindexUtility atomG u
              cover = feats ++ [ p | p <- asn
                               , fst p `notElem` map fst feats ]
          env <- mkEnvIn ns cover (b :. VNil)
          pure (evalx (Expect (Var Z) (substW asn uB)) env)
  | otherwise = do
      let waitH = case opts of
            (o : _) -> o
            []      -> []
          full = feats ++ waitH
      parts <- mapM (\y -> do
                 m <- predictMassS full y ag
                 if m == 0
                   then pure 0
                   else do
                     (_, ag') <- observeS full y ag
                     v <- thinkValue (d - 1) ns feats atomG u opts ag'
                     pure (m * v))
               (agentObsPoints ag)
      pure (sum parts)

-- said@1: the declaration parsed against the exact grammar's
-- wire-sayable forms — var, c, +, -, *, get, if, >, = . The forms
-- "/", "log", "exp", "neg" died with their terminals (unknown form =
-- refuse, fail-closed); "+" parses to the addM MACRO (priced at its
-- expansion, exactly as "=" parses to the If/Gt composition).
parseSaid :: J -> Maybe (Expr '[Rational, Rational] Rational)
parseSaid = parseSaidWith (\v -> mkC (mkGrid "k" (v :| [])) 0)

parseSaidIn :: [Rational] -> Grid -> J
            -> Maybe (Expr '[Rational, Rational] Rational)
parseSaidIn pts g = parseSaidWith (\v -> do
  i <- elemIndexQ v pts
  mkC g i)
  where
    elemIndexQ v = go 0
      where
        go _ [] = Nothing
        go i (x : xs) = if x == v then Just i else go (i + 1) xs

parseSaidWith :: (Rational -> Maybe (Expr '[Rational, Rational] Rational))
              -> J -> Maybe (Expr '[Rational, Rational] Rational)
parseSaidWith kc = pE
  where
    pE (JArr [JStr "var", JNum 0]) = Just (Var Z)
    pE (JArr [JStr "var", JNum 1]) = Just (Var (S Z))
    pE (JArr [JStr "c", v]) = kc =<< jQ v
    pE (JArr [JStr "+", a, b]) = addM <$> pE a <*> pE b
    pE (JArr [JStr "-", a, b]) = Sub <$> pE a <*> pE b
    pE (JArr [JStr "*", a, b]) = Mul <$> pE a <*> pE b
    pE (JArr [JStr "get", JStr nm]) = Just (Get nm)
    pE (JArr [JStr "if", c, t, e]) = If <$> pB c <*> pE t <*> pE e
    pE _ = Nothing
    pB (JArr [JStr ">", a, b]) = Gt <$> pE a <*> pE b
    pB (JArr [JStr "=", a, b]) = do
      x <- pE a
      y <- pE b
      oneE  <- mkC (mkGrid "k" (1 :| [])) 0
      zeroE <- mkC (mkGrid "k" (0 :| [])) 0
      let trueE  = Gt oneE zeroE
          falseE = Gt zeroE oneE
      pure (If (Gt x y) falseE (If (Gt y x) falseE trueE))
    pB _ = Nothing

-- | The executable's whole IO surface: the stdin/stdout line loop
-- over 'serveLine' (gate 3: the loop lives here and only here).
hostMain :: IO ()
hostMain = do
  -- THE TRANSPORT FIX (#18, transport-freeze-r0): line buffering so a
  -- pipe host sees each reply as it is written; test-transport pins it.
  hSetBuffering stdout LineBuffering
  go hostStart
  where
    go st = do
      end <- isEOF
      if end
        then pure ()
        else do
          l <- getLine
          let (st', reply) = serveLine st l
          putStrLn reply
          go st'
#endif
