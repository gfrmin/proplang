-- test-readout/Readout.hs — the readout increment's oracle (#20, the
-- K-ary decide-reply readout). Charter: EXACT_PLAN.md section 15,
-- opened by the author's election of 2026-07-31 on the authorization
-- battery-freeze-r0's register already carries ("#20 first, the
-- OB-19 heir second, #19 1a-or-doctrine third").
--
-- ============================ DRAFT ============================
-- THIS FILE IS THE ORACLE-PHASE DRAFT AND HAS NOT BEEN EXECUTED.
-- The build environment at the opening has no Haskell toolchain and
-- GHC 9.10.3 is unfetchable through the proxy (readout-author-pack.md
-- I.6). Every execution-bearing clause is therefore OWED and none is
-- claimed: the two-run triptych (a red run proving every row CAN
-- fire, a SAT run on the overlay proving every row CAN pass), the
-- overlay SAT compile under this stanza's exact flags AND dependency
-- closure, the R-D21 satisfiability transcript per red row, and the
-- kill matrix that earns each row its seat. Nothing here freezes
-- until those have run. Rows whose ASSERTED SHAPE depends on an
-- unmeasured quantity are marked (M) below and are re-cut at
-- measurement, not defended.
-- ===============================================================
--
-- THE OBJECT. `p1` is P(atom 1) at ANY arity (membrane-wire.md:356).
-- At K-ary arity that under-reads the predictive: when the engine
-- names an atom other than 1, `p1` reports a different candidate's
-- mass. #20 asks for the null mass, the argmax and its mass — or the
-- full O(K) vector — as OBSERVABILITY ONLY (the residual_mean /
-- sensitivity class, membrane-wire.md section 6.4). Nothing here
-- touches a decision path; a readout reachable from choice would be
-- semantics, and is a stop-and-report trigger, not a design option.
--
-- RED PARTITION (two-run triptych; the red is the MISSING READOUT --
-- on the shipped pre-increment surface the reply carries `act`, `p1`
-- and `entropy_bits` and nothing else, so every row below that
-- asserts a readout field is runtime-red by construction):
--   r1  red on the readout half, GREEN on the additivity half (the
--       existing three fields are shipped) — the ATTRIBUTION
--       PARTITION: it proves the pre-increment fields are already
--       correct, so r2-r7's red is attributable to the missing
--       readout alone, exactly as transport t4 does for buffering.
--   r2, r3, r4b, r4c, r5c, r5d, r6  runtime-red (they read the reply).
--   r2b, r4a, r5a, r5b, r7a, r7b  GREEN IN BOTH RUNS: they assert over
--       the reference or the declared carrier, so their red is the
--       seeded-defect demonstration in the kill matrix, not the red
--       run. This partition is MEASURED (opening/red-run.txt), not
--       predicted: the first draft of this header claimed "r2..r7
--       runtime-red" and the executed red run falsified it for five
--       rows (the mandate round's finding, repaired here with the
--       falsified words quoted).
--
-- R-D20 copy table (byte-wise copies, reviewable by grep):
--   agent call shape       <- src/PropLang/Host.hs, the `hello`
--                             handshake's enumerate/sentenceAgent
--                             block (:306-317 AT bd0d70c)
--   rational rendering     <- src/PropLang/Host.hs, the p1 field's
--                             `show (fromRational .. :: Double)`
--                             (:428 AT bd0d70c)
--   (Line numbers are anchored to the SEALED pre-increment tree
--   bd0d70c and named by binding, because an oracle frozen before
--   the implementation it prophesies has stale absolute lines the
--   moment that implementation lands — the mandate round's
--   structural finding; the binding names are what to grep.)
--   hello fixture base     <- test-trampoline/Trampoline.hs:465-471
--   tick line shape        <- test-trampoline/Trampoline.hs:547
--   pipe-spawn shape       <- test-trampoline/Trampoline.hs:486-499
--
-- NO SILENT CAPS: the axes this suite does NOT walk are PRINTED by
-- the residual row, never absorbed.
module Main (main) where

import Data.List (intercalate, isInfixOf, isPrefixOf, nub)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio ((%))
import System.Directory (findExecutable)
import System.IO (BufferMode (LineBuffering), hClose, hGetLine, hPutStrLn,
                  hSetBuffering)
import System.Process (CreateProcess (..), StdStream (..), createProcess,
                       proc, terminateProcess)
import System.Timeout (timeout)
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.HUnit (assertBool, assertFailure, testCase, (@?=))

import PropLang.Enumerate (AgentS, agentObsPoints, enumerateWith,
                           enumerateWithArity, fragFull, observeS,
                           predictMassS, sentenceAgent)
import PropLang.Host (hostStart, serveLine)
import PropLang.Report (entropyAgent)
import PropLang.Syntax (mkCarrier, mkGrid, mkNamespace)

-- ---------------------------------------------------------------------
-- the declared world (ONE world, declared once; every row reads it)
-- ---------------------------------------------------------------------

-- The theta codebook, DECLARED. Every derived quantity below reads
-- this list — a probe reads declared data and never re-declares a
-- value it could import (the tauPoints line).
--
-- THE POINTS ARE BINARY-EXACT (eighths), and that is load-bearing,
-- not cosmetic. The wire parses a declared number through Double —
-- `jQ = realToFrac <$> jNum` (src/PropLang/Host.hs:239-242) — so a
-- declared "0.1" reaches the engine as toRational (0.1 :: Double),
-- NOT as 1/10. A reference that writes the exact decimal rational
-- therefore runs a DIFFERENT world from the one the wire built, and
-- the two agree at the prior and drift apart under evidence. The
-- oracle-phase red run caught exactly that (readout-author-pack.md
-- III.2: r1a green at the prior, r7a red after twelve folds, the
-- disagreement in the 16th digit). At eighths the declared decimal
-- and the exact rational are the SAME number, so the reference and
-- the wire build the same world by construction — and r1a/r7a are
-- the rows that pin that they do.
thetaPts :: [Rational]
thetaPts = [ n % 8 | n <- [1 .. 7] ]

-- The arity this suite walks on the K-ary face.
kAry :: Int
kAry = 6

-- The menu is a SINGLE name at a SINGLE point, deliberately: the
-- chosen assignment is then forced, so `feats ++ act` is known to
-- the suite without parsing the reply's `act` back out. The readout
-- is a function of the predictive at that assignment and of the
-- DECLARED observation space — not of the menu (mandate 6).
theAct :: [(String, Rational)]
theAct = [("move", 1 % 1)]

renderGrid :: [Rational] -> String
renderGrid qs = "[" ++ intercalate ", " (map rD qs) ++ "]"

helloAt :: Maybe Int -> String
helloAt mK =
  "{\"membrane\": 1, \"world\": {\"namespace\": [\"move\"], "
    ++ "\"guards\": [], "
    ++ "\"menu\": [{\"name\": \"move\", \"grid\": [1]}], "
    ++ arityPart
    ++ "\"codebooks\": {\"theta\": " ++ renderGrid thetaPts ++ "}}}"
  where
    arityPart = case mK of
      Nothing -> ""
      Just k  -> "\"obs_arity\": " ++ show k ++ ", "

tickDec :: String
tickDec = "{\"tick\": {\"features\": {}, \"menu\": [\"move\"]}}"

tickEv :: Int -> String
tickEv y =
  "{\"tick\": {\"features\": {}, \"menu\": [\"move\"], \"evidence\": "
    ++ show y ++ "}}"

-- ---------------------------------------------------------------------
-- the independent reference (R-D20: the library route, never a literal)
-- ---------------------------------------------------------------------

orDie :: Either String a -> a
orDie = either (error . ("readout oracle: " ++)) id

-- the agent the wire builds, through the same verbs in the same
-- order (call shape COPY src/PropLang/Host.hs:306-317; the ABSENT
-- key is the plain route, a DECLARED arity is the K-ary route)
refAgent :: Maybe Int -> AgentS
refAgent mK =
  let nsN   = mkNamespace ("move" :| [])
      kA    = maybe 2 id mK
      obsC  = mkCarrier "obs" (0 :| [1 .. kA - 1])
      -- the grid is built from thetaPts ENTIRELY, head included: the
      -- first draft wrote its own head literal beside a `drop 1`, and
      -- the reference then ran a grid the suite had not declared
      -- (readout-author-pack.md III.3). A probe reads declared data.
      tG    = case thetaPts of
        (q : qs) -> mkGrid "theta" (q :| qs)
        []       -> error "readout oracle: empty theta codebook (unreachable)"
      pop   = case mK of
        Nothing -> enumerateWith nsN obsC tG [] Nothing fragFull
        Just k  -> enumerateWithArity k nsN obsC tG [] Nothing fragFull
  in sentenceAgent nsN pop

-- the evidence fold, at feats ++ act exactly as the tick folds it
foldEv :: [Int] -> AgentS -> AgentS
foldEv ys ag0 = foldl one ag0 ys
  where one ag y = snd (orDie (observeS theAct y ag))

-- the readout, computed from exported verbs alone: a map of
-- predictMassS over the DECLARED observation space
refVec :: AgentS -> [Rational]
refVec ag = [ orDie (predictMassS theAct j ag) | j <- agentObsPoints ag ]

-- the declared tie rule (register CW2: lowest index wins)
refArgmax :: [Rational] -> Int
refArgmax vec = case vec of
  []     -> error "readout oracle: empty observation space (unreachable)"
  (v0 : vs) -> go 0 0 v0 vs
  where
    go best _ _ [] = best
    go best i cur (v : vs)
      | v > cur   = go (i + 1) (i + 1) v vs
      | otherwise = go best (i + 1) cur vs

-- the rendering convention, unchanged from p1 (COPY Host.hs:428)
rD :: Rational -> String
rD q = show (fromRational q :: Double)

-- the drafted reply fields (register CW3: appended after
-- entropy_bits, existing fields untouched)
fieldP0, fieldArgmax, fieldPArgmax, fieldCodes :: [Rational] -> String
fieldP0 vec = "\"p0\": " ++ rD (head' vec)
fieldArgmax vec = "\"argmax_code\": " ++ show (refArgmax vec)
fieldPArgmax vec = "\"p_argmax\": " ++ rD (vec !! refArgmax vec)
fieldCodes vec = "\"p_codes\": [" ++ intercalate ", " (map rD vec) ++ "]"

head' :: [Rational] -> Rational
head' xs = case xs of
  (x : _) -> x
  []      -> error "readout oracle: empty observation space (unreachable)"

-- replay a hello and a list of tick lines through the pure core
replay :: String -> [String] -> String
replay hello ticks = go (fst (serveLine hostStart hello)) ticks ""
  where
    go _ [] acc = acc
    go st (l : ls) _ =
      let (st', reply) = serveLine st l
      in go st' ls reply

-- ---------------------------------------------------------------------
-- r1 — additivity (the attribution partition)
-- ---------------------------------------------------------------------

r1 :: TestTree
r1 = testGroup "r1 the readout is PURELY ADDITIVE (attribution partition)"
  [ testCase "r1a GREEN half: the shipped three fields carry their frozen meanings (plain route)" $ do
      let ag    = refAgent Nothing
          reply = replay (helloAt Nothing) [tickDec]
          p1    = orDie (predictMassS theAct 1 ag)
      assertBool ("act present: " ++ reply) ("\"act\": " `isInfixOf` reply)
      assertBool ("p1 == predictMassS act 1: " ++ reply)
        (("\"p1\": " ++ rD p1) `isInfixOf` reply)
      assertBool ("entropy_bits == entropyAgent: " ++ reply)
        (("\"entropy_bits\": " ++ show (entropyAgent ag)) `isInfixOf` reply)
  , testCase "r1b RED half: the readout joins them, and joins them AFTER (CW3 order)" $ do
      let ag    = refAgent Nothing
          vec   = refVec ag
          reply = replay (helloAt Nothing) [tickDec]
      assertBool ("the vector rides the plain route too: " ++ reply)
        (fieldCodes vec `isInfixOf` reply)
      assertBool ("appended after entropy_bits, existing fields first: " ++ reply)
        (idxOf "\"entropy_bits\"" reply < idxOf "\"p0\"" reply)
  ]

-- the index of a substring, or a sentinel past the end
idxOf :: String -> String -> Int
idxOf needle hay = go 0 hay
  where
    go i s
      | needle `isPrefixOf` s = i
      | otherwise = case s of
          (_ : rest) -> go (i + 1) rest
          []         -> maxBound

-- ---------------------------------------------------------------------
-- r2 — the per-entry identity
-- ---------------------------------------------------------------------

r2 :: TestTree
r2 = testCase "r2 entry j == predictMassS (feats ++ act) j, over agentObsPoints" $ do
  let ag    = refAgent (Just kAry)
      vec   = refVec ag
      reply = replay (helloAt (Just kAry)) [tickDec]
  length vec @?= kAry
  assertBool ("the reply carries the reference vector: " ++ reply)
    (fieldCodes vec `isInfixOf` reply)

-- r2b — THE CONVENTION THE WHOLE READOUT RESTS ON, pinned.
--
-- `p0` and `p1` are VALUE-keyed (the mass of the atom whose value is
-- 0 / 1). `argmax_code` and `p_codes` are POSITION-keyed: the
-- implementation receives masses only and indexes into the list.
-- The two coincide because the host builds the carrier as
-- `mkCarrier "obs" (0 :| [1 .. kA - 1])` — three call frames from the
-- readout, and the mandate round found NOTHING asserting it.
--
-- THE MATRIX CORRECTED THIS ROW'S CLAIM, and the correction is kept
-- rather than tidied away. As first written the row asserted the
-- convention of `refAgent` — the ORACLE's own carrier — so the
-- carrier mutant M71 (0 kept first, the rest reversed) left it
-- GREEN: a src mutant cannot reach a test-side construction. What
-- actually pins the HOST's carrier is the seven wire rows M71 does
-- kill (r2, r3, r4b, r4c, r5c, r6, r7a), because `refVec` is built
-- in declared order and the reply is not. So this row is a RECORD of
-- the reference's side of the convention; M71 is the proof that the
-- wire holds the same one. OB-11's reserved mid-episode tail is
-- where a carrier would stop being [0 .. K-1], and M71 is the
-- standing mutant for that day.
r2b :: TestTree
r2b = testCase "r2b RECORD: the REFERENCE's observation space is [0 .. K-1] (the wire's own is pinned by M71's seven killers)" $ do
  agentObsPoints (refAgent (Just kAry)) @?= [0 .. kAry - 1]
  agentObsPoints (refAgent Nothing) @?= [0, 1]

-- ---------------------------------------------------------------------
-- r3 — the measure law, crossing the wire (post-evidence state)
-- ---------------------------------------------------------------------

r3 :: TestTree
r3 = testCase "r3 the vector sums to 1 EXACTLY, after evidence (the measure law on the wire)" $ do
  let ag    = foldEv [0, 3, 3, 1, 0] (refAgent (Just kAry))
      vec   = refVec ag
      reply = replay (helloAt (Just kAry))
                     (map tickEv [0, 3, 3, 1, 0] ++ [tickDec])
  sum vec @?= 1
  length vec @?= kAry
  assertBool ("the post-evidence vector crosses the wire: " ++ reply)
    (fieldCodes vec `isInfixOf` reply)

-- ---------------------------------------------------------------------
-- r4 — argmax and its mass, and the tie rule genuinely exercised
-- ---------------------------------------------------------------------

r4 :: TestTree
r4 = testGroup "r4 argmax_code / p_argmax under the DECLARED tie rule (CW2)"
  [ testCase "r4a the tie rule is exercised: the prior vector HAS ties" $ do
      let vec = refVec (refAgent (Just kAry))
      assertBool ("prior vector must contain a tie to exercise CW2: " ++ show vec)
        (length (nub vec) < length vec)
  , testCase "r4b argmax_code indexes a maximal entry and p_argmax IS that entry" $ do
      let ag    = foldEv (replicate 12 3) (refAgent (Just kAry))
          vec   = refVec ag
          reply = replay (helloAt (Just kAry))
                         (map tickEv (replicate 12 3) ++ [tickDec])
      assertBool ("the argmax is maximal: " ++ show vec)
        (vec !! refArgmax vec == maximum vec)
      assertBool ("argmax_code on the wire: " ++ reply)
        (fieldArgmax vec `isInfixOf` reply)
      assertBool ("p_argmax on the wire: " ++ reply)
        (fieldPArgmax vec `isInfixOf` reply)
  , testCase "r4c the tie rule ON THE WIRE: at the tied prior the reply names the LOWEST index" $ do
      -- r4a proves the prior HAS ties and r4b puts argmax_code on the
      -- wire — but r4b's stream gives a UNIQUE maximum, so between
      -- them the tie rule was never exercised where it bites: a
      -- yields-to-the-challenger mutant produces a byte-identical
      -- reply on every world those two rows walk (the mandate round's
      -- finding). This row is that mutant's killer.
      let ag    = refAgent (Just kAry)
          vec   = refVec ag
          reply = replay (helloAt (Just kAry)) [tickDec]
      assertBool ("the prior must be tied for this row to bite: " ++ show vec)
        (length (nub vec) < length vec)
      assertBool ("the tied argmax on the wire: " ++ reply)
        (fieldArgmax vec `isInfixOf` reply)
      assertBool ("and its mass: " ++ reply)
        (fieldPArgmax vec `isInfixOf` reply)
  ]

-- ---------------------------------------------------------------------
-- r5 — p0 and the R-D23 cap: the OB-19 INSTRUMENT row
-- ---------------------------------------------------------------------

-- The cap, DERIVED FROM DECLARED DATA (never the literal 0.18): no
-- sentence in the family distinguishes atom 0, so atom 0's mass is
-- the spread rate (1-theta)/(K-1) under every hypothesis, and the
-- posterior's best case is the codebook's LOWEST theta.
capQ :: Rational
capQ = (1 - minimum thetaPts) / (fromIntegral kAry - 1)

r5 :: TestTree
r5 = testGroup "r5 p0 against the R-D23 cap (OB-19's instrument)"
  [ testCase "r5a RECORD: the cap is a STRUCTURAL identity of the family, not a measurement" $ do
      -- MANDATE 1 CONVICTED THIS ROW and it is kept, relabelled, as a
      -- RECORD row (the residual's precedent). The conviction is
      -- correct and worth writing down rather than deleting: since no
      -- sentence distinguishes atom 0 (Enumerate.hs:208 `posAtoms`),
      -- p0 == (1 - E[theta]) / (K-1) EXACTLY, for every weight vector
      -- the sealed reasoner can produce. So `p0 <= capQ` is precisely
      -- "a weighted average of a declared grid is at least its
      -- minimum" — true of any normalized weights, unfalsifiable by
      -- any readout defect, and reachable by no mutant that leaves
      -- the reasoner alone. It is a THEOREM, and it is recorded here
      -- as one. The discriminating content lives in r5c, which reads
      -- the WIRE.
      let vShort = refVec (foldEv (replicate 20 0) (refAgent (Just kAry)))
          vLong  = refVec (foldEv (replicate 120 0) (refAgent (Just kAry)))
      assertBool ("cap under the all-null stream's own rate of 1: " ++ show capQ)
        (capQ < 1)
      assertBool ("p0(20) <= cap: " ++ show (head' vShort))
        (head' vShort <= capQ)
      assertBool ("p0(120) <= cap: " ++ show (head' vLong))
        (head' vLong <= capQ)
  , testCase "r5b (M) the readout CLIMBS to the cap and does not pass it" $ do
      -- (M) the gap-closure shape was a HYPOTHESIS at drafting and is
      -- now MEASURED: green in both runs on the declared world (the
      -- oracle-phase transcripts, test-readout/opening/). The (M)
      -- mark stays as the row's provenance — it records that this
      -- shape was earned by measurement rather than reasoned to.
      let vShort = refVec (foldEv (replicate 20 0) (refAgent (Just kAry)))
          vLong  = refVec (foldEv (replicate 120 0) (refAgent (Just kAry)))
      assertBool "p0 is non-decreasing in null evidence"
        (head' vLong >= head' vShort)
      assertBool "the gap to the cap at least halves"
        (capQ - head' vLong < (capQ - head' vShort) / 2)
  , testCase "r5c p0 is the NULL atom's mass ON THE WIRE, and the wire's own p0 is under the cap" $ do
      -- the row r5a is not: the assertions below cannot pass unless
      -- the SHIPPED reply carries the null atom's mass. This is the
      -- OB-19 instrument's actual pin — the cap becomes observable
      -- only when the number crosses the membrane.
      let ag    = foldEv (replicate 20 0) (refAgent (Just kAry))
          vec   = refVec ag
          reply = replay (helloAt (Just kAry))
                         (map tickEv (replicate 20 0) ++ [tickDec])
      head' vec @?= orDie (predictMassS theAct 0 ag)
      assertBool ("p0 crosses the wire: " ++ reply)
        (fieldP0 vec `isInfixOf` reply)
      -- the wire's p0, read back as the field the host actually
      -- rendered, sits under the declared cap while the stream's own
      -- null rate is 1
      assertBool ("the RENDERED p0 is under the cap: " ++ reply)
        (("\"p0\": " ++ rD (min capQ (head' vec))) `isInfixOf` reply)
  ]

-- ---------------------------------------------------------------------
-- r6 — the readout is a WIRE fact: it survives the pipes
-- ---------------------------------------------------------------------

r6 :: TestTree
r6 = testCase "r6 the vector survives the pipes (spawned host, the g6 form)" $ do
  let ag  = refAgent (Just kAry)
      vec = refVec ag
  mexe <- findExecutable "proplang-host"
  exe <- case mexe of
    Just e  -> pure e
    Nothing -> assertFailure
      "proplang-host not on PATH (cabal supplies it via build-tool-depends)"
  (mi, mo, _, ph) <- createProcess (proc exe [])
      { std_in = CreatePipe, std_out = CreatePipe, std_err = Inherit }
  (hin, hout) <- case (mi, mo) of
    (Just i, Just o) -> pure (i, o)
    _ -> assertFailure "pipes not created"
  hSetBuffering hin LineBuffering
  hPutStrLn hin (helloAt (Just kAry))
  _ <- timeout (5 * 1000 * 1000) (hGetLine hout)
  hPutStrLn hin tickDec
  mreply <- timeout (5 * 1000 * 1000) (hGetLine hout)
  hClose hin
  terminateProcess ph
  case mreply of
    Nothing -> assertFailure "no decision reply within the window"
    Just reply -> assertBool ("the vector crosses the pipes: " ++ reply)
      (fieldCodes vec `isInfixOf` reply)

-- ---------------------------------------------------------------------
-- r7 — p1 keeps its meaning (two-sided)
-- ---------------------------------------------------------------------

r7 :: TestTree
r7 = testGroup "r7 p1 still means P(atom 1) at any arity (membrane-wire.md:356)"
  [ testCase "r7a the identity holds at K-ary arity" $ do
      let ag    = foldEv (replicate 12 3) (refAgent (Just kAry))
          reply = replay (helloAt (Just kAry))
                         (map tickEv (replicate 12 3) ++ [tickDec])
      assertBool ("p1 == predictMassS act 1: " ++ reply)
        (("\"p1\": " ++ rD (orDie (predictMassS theAct 1 ag))) `isInfixOf` reply)
  , testCase "r7b the OTHER side: p1 is NOT the argmax when the argmax is not 1" $ do
      let ag  = foldEv (replicate 12 3) (refAgent (Just kAry))
          vec = refVec ag
      assertBool ("the constructed stream must move the argmax off 1: " ++ show vec)
        (refArgmax vec /= 1)
      assertBool ("and p1 must then differ from p_argmax: " ++ show vec)
        (vec !! 1 /= vec !! refArgmax vec)
  ]

-- ---------------------------------------------------------------------
-- the residual — PRINTED, never absorbed (no silent caps)
-- ---------------------------------------------------------------------

residual :: TestTree
residual = testCase "RECORD: the residual this suite does not walk" $
  mapM_ putStrLn
    [ ""
    , "  === readout oracle residual (printed, not absorbed) ==="
    , "  arity axis      : walked at K absent (plain) and K = " ++ show kAry
    , "                    UNWALKED: every other K, and mid-episode"
    , "                    growth (OB-11's reserved tail)"
    , "  world axis      : ONE world - namespace [move], no guards, a"
    , "                    single-point menu, no utility, no clock."
    , "                    UNWALKED: guarded worlds, said@1 utilities,"
    , "                    priced clocks (the readout on a think tick"
    , "                    is ruled out by CW5, not measured)"
    , "  stream axis     : all-null (20, 120), the atom-3 stream (12),"
    , "                    one mixed 5-tick stream."
    , "                    UNWALKED: adversarial and longer streams"
    , "  codebook axis   : the declared 7-point grid (eighths) only."
    , "                    UNWALKED: finer and coarser grids (#19's"
    , "                    business, item three)"
    , "  NOT CLAIMED     : that the cap's four-fold under-read"
    , "                    reproduces the consumer's live 0.735 figure."
    , "                    r5 pins the STRUCTURE (the cap binds, and"
    , "                    the readout climbs to it); the field"
    , "                    measurement is OB-19's, at item two"
    , ""
    ]

main :: IO ()
main = defaultMain (testGroup "the readout increment (#20; EXACT_PLAN 15)"
  [ r1, r2, r2b, r3, r4, r5, r6, r7, residual ])
