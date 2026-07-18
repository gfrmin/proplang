{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}

-- | The host boundary (typed-port-spec §2/§6): the ONLY module in src/
-- whose types may mention IO. 'draw' is CL-2 made compiler-checked — the
-- language cannot utter it, because uttering it would change the
-- evaluator's type.
--
-- SINCE THE STEP-7 FREEZE (unify-freeze-r0): THE DRIVER RETURNS — the
-- host-less window ("no runnable host until the step-5/7 host rework",
-- stated at the step-3 demolition; "no driver returns until 7") exits
-- here. The ENTIRE wire protocol (membrane-wire.md v1 as amended
-- through step 7) is the PURE session core 'serveLine'; 'hostMain' is
-- the stdin/stdout line loop over it, and the `proplang-host`
-- executable is that loop behind a front door (app/Main.hs). The
-- engine is reached ONLY through the public verbs; the decision fold
-- copies the pinned exogenous-read shape (Membrane.interpretPilot's
-- PilotEU arm; test-stream g2's public arithmetic — the §1b register
-- row names this loop as the pin's SECOND citing consumer). The
-- implementation is the E-c-verified overlay of the step-7 oracle
-- phase, transcribed node for node under unify-freeze-r0.
module PropLang.Host
  ( draw
#if !defined(DROP_CARRIER_OBS) && !defined(DROP_ARGMAX)
  -- the wire session dies with the scoring layer or with argmax
  -- (no scoring, no agent; no argmax, no choice flow) — the same
  -- deletion coupling the membrane's agent-facing surface records
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

import PropLang.Belief (Belief, top)

#if !defined(DROP_CARRIER_OBS) && !defined(DROP_ARGMAX)
import Data.Char (isDigit)
import Data.List.NonEmpty (NonEmpty ((:|)))
import qualified Data.List.NonEmpty as NE
import System.IO (isEOF)

import PropLang.Belief (LogProb (LogProb), entropyBits, expect, is, prob)
import PropLang.Enumerate (Agent, Obs, agentMeta, enumerateSentencesIn,
                           fragFull, observe, obsSpace, predictive,
                           sentenceAgent)
import PropLang.Eval (Features, Vals (..), evalx, mkEnv)
import PropLang.Membrane (menuAssignments)
import PropLang.Syntax (Expr (..), Grid, Idx (..), Name,
                        mkC, mkGrid, mkNamespace)
#endif

-- | The sole source of randomness, host-side, called AFTER the language
-- has finished constructing the belief. Used only to simulate worlds.
--
-- Sampling goes through the sealed reasoner's public diagnostics ('top'
-- ranks every point with its probability): a cumulative walk over the
-- ranked points is the same categorical draw as the reference's walk in
-- space order — the host cannot see log-weights any more than a program
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
  pure (walk 0 (top b maxBound))

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

#if !defined(DROP_CARRIER_OBS) && !defined(DROP_ARGMAX)
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
  "{" ++ commaSep [ "\"" ++ nm ++ "\": " ++ rNum v | (nm, v) <- asg ] ++ "}"

commaSep :: [String] -> String
commaSep [] = ""
commaSep xs = foldr1 (\a b -> a ++ ", " ++ b) xs

errLine :: String -> String
errLine m = "{\"error\": \"" ++ m ++ "\"}"

-- ------------------------- the session ------------------------------

-- The world as the handshake declared it: the writable names with
-- their grids (the step-5 shape), and the utility as THE PRINCIPAL'S
-- DECLARATION (step 8, said@1: a priced sentence parsed against the
-- grammar — a POINT-MASS PRIOR over the program shape, the ruled
-- doctrine; assign@1 died here with Util, on its printed date).
data World = World
  { wMenuGrids :: [(Name, Grid)]
  , wUSaid     :: Maybe (Expr '[Double, Double] Double)
  }

-- | The wire session state (membrane-wire v1 as amended through step
-- 7). Opaque; a session starts at 'hostStart'.
--
-- Type derivation (§8c audit, step 7): FENCE — host machinery, the
-- wire's own state machine, outside the language (the membrane
-- harness class; gate 3's module).
data HostState = HostAwait | HostLive World Agent

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

-- The handshake (membrane-wire §2 as repaired at step 7): namespace,
-- guards, menu (names and grids), optional assign@1 utility.
-- Validation failures answer an error line and the process stays on
-- the handshake state.
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
  uSaid <- case oGet "utility" w of
    Just u -> do
      JStr "said@1" <- oGet "form" u
      sexp <- oGet "said" u
      prog <- parseSaid sexp        -- FAIL-CLOSED: unparseable => bad hello
      pure (Just prog)
    Nothing -> pure Nothing
  n0 : nrest <- pure ns
  -- RIDER 2's validation: every guard and writable name inside the
  -- declared (completed, immutable) namespace
  let inNs nm = nm `elem` ns
  if not (all (inNs . fst) gs && all (inNs . fst) menu)
    then pure (st, errLine "names outside namespace")
    else do
      let nsN = mkNamespace (n0 :| nrest)
          pop = enumerateSentencesIn nsN gs fragFull
          ag = sentenceAgent pop
          nsb = logBase 2 (fromIntegral (length ns) :: Double)
          reply = "{\"ok\": true, \"proto\": 1, \"models\": "
                  ++ show (length pop) ++ ", \"namespace_bits\": "
                  ++ show nsb ++ "}"
      pure (HostLive (World menu uSaid) ag, reply)
  where
    pairGrid g = do
      nm <- jStr =<< oGet "name" g
      JArr vsJ <- oGet "grid" g
      vs <- mapM jNum vsJ
      -- D-f8 (A), RIDER 1 (the pin on the door): a NaN or infinite grid
      -- point is a DECLARATION-TIME validation failure -- the world's
      -- declared carrier must denote, and it must fail at the HELLO, not
      -- mid-episode (R-C1 refuses ill-formedness at construction, not
      -- merely at the read). A hello carrying such a point is bad hello,
      -- full stop; 'reads' can produce +/-Infinity (e.g. 1e999). The
      -- gridLookup guard stays as defence-in-depth for the read site.
      True <- pure (all (\v -> not (isNaN v || isInfinite v)) vs)
      v0 : vrest <- pure vs
      pure (nm, mkGrid nm (v0 :| vrest))

-- One tick (membrane-wire §3): the frozen loop's order — the choice
-- is computed from the predictive BEFORE the observation moves the
-- agent; evidence folds at feats ++ act (step 6's geometry); a tick
-- with neither menu nor evidence is silent and the agent is unmoved.
tick :: World -> Agent -> J -> (HostState, String)
tick w ag t = maybe (HostLive w ag, errLine "bad tick") id $ do
  feats <- case oGet "features" t of
    Just (JObj kvs) -> mapM (\(k, v) -> (,) k <$> jNum v) kvs
    Nothing         -> Just []
    _               -> Nothing
  menuNames <- case oGet "menu" t of
    Just (JArr ms) -> Just <$> mapM jStr ms
    Nothing        -> pure Nothing
    _              -> Nothing
  let evid = oGet "evidence" t >>= jNum
      writable = map fst (wMenuGrids w)
  -- D-b2 disjointness: a tick may not publish a writable name
  if any ((`elem` writable) . fst) feats
    then pure (HostLive w ag, errLine "feature/assignment collision")
    else do
      let mOpts = do
            nms <- menuNames
            grids <- mapM (\nm -> (,) nm <$> lookup nm (wMenuGrids w)) nms
            pure (menuAssignments grids)
          act = case mOpts of
            Nothing   -> []
            Just opts -> choose (wUSaid w) feats ag opts
          p1 = prob (predictive feats ag) (is obsSpace 1)
          hB = entropyBits (agentMeta ag)
          decPart = case mOpts of
            Nothing -> []
            Just _  -> [ "\"act\": " ++ rAct act
                       , "\"p1\": " ++ show p1
                       , "\"entropy_bits\": " ++ show hB ]
      case evid of
        Nothing
          | null decPart -> pure (HostLive w ag, "{\"ok\": true}")
          | otherwise ->
              pure (HostLive w ag, "{" ++ commaSep decPart ++ "}")
        Just yD -> do
          let y = round yD :: Obs
          case observe (feats ++ act) y ag of
            Nothing -> pure (HostLive w ag, errLine "impossible evidence")
            Just (LogProb lp, ag') ->
              let evPart = [ "\"observed\": " ++ show y
                           , "\"loss_bits\": " ++ show (negate lp / log 2) ]
              in pure ( HostLive w ag'
                      , "{" ++ commaSep (decPart ++ evPart) ++ "}" )

-- the pinned exogenous-read choice (COPY of the shape at
-- src/PropLang/Membrane.hs interpretPilot PilotEU / test-stream g2's
-- public arithmetic): candidate EU at predictive (feats ++ a), current
-- weights; strict > displaces, first-listed wins ties (= wait). No
-- utility rows => wait (the option space's head). SINCE STEP 9: the EU
-- is the public 'expect' verb over the utility residue (bit-identical
-- to the pre-step-9 'Call EU' = 'expect b (\y -> uAt fs u 0 y)').
choose :: Maybe (Expr '[Double, Double] Double) -> Features -> Agent
       -> NonEmpty Features -> Features
choose Nothing _ _ opts = NE.head opts
choose (Just u) feats ag opts =
  let euAt a = expect (predictive (feats ++ a) ag)
                      (\y -> evalx u (mkEnv (feats ++ a)
                                       (0 :. realToFrac y :. VNil)))
      c0 :| cs = opts
      go best _bv [] = best
      go best bv (c : rest) =
        let cv = euAt c
        in if cv > bv then go c cv rest else go best bv rest
  in go c0 (euAt c0) cs

-- said@1: the declaration parsed against the residue-scope grammar
-- subset (var, c, add, sub, mul, if, gt, eq, get) — a SENTENCE,
-- priced like any sentence; anything else refuses (fail-closed, the
-- ruled doctrine)
parseSaid :: J -> Maybe (Expr '[Double, Double] Double)
parseSaid = pE
  where
    pE (JArr [JStr "var", JNum 0]) = Just (Var Z)
    pE (JArr [JStr "var", JNum 1]) = Just (Var (S Z))
    pE (JArr [JStr "c", JNum v]) = mkC (mkGrid "k" (v :| [])) 0
    pE (JArr [JStr "+", a, b]) = Add <$> pE a <*> pE b
    pE (JArr [JStr "-", a, b]) = Sub <$> pE a <*> pE b
    pE (JArr [JStr "*", a, b]) = Mul <$> pE a <*> pE b
    pE (JArr [JStr "get", JStr nm]) = Just (Get nm)
    pE (JArr [JStr "if", c, t, e]) = If <$> pB c <*> pE t <*> pE e
    pE _ = Nothing
    pB (JArr [JStr ">", a, b]) = Gt <$> pE a <*> pE b
    -- SINCE STEP 9: '=' is the If/Gt composition (E-e2; IsEq deleted):
    -- x == y iff neither x > y nor y > x. trueE/falseE are constant
    -- guards over singleton grids (the same 'mkC' door 'c' uses).
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
hostMain = go hostStart
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
