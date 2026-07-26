{-# LANGUAGE DataKinds #-}
-- test-trampoline/Trampoline.hs — the trampoline boundary's oracle.
-- OPENED by the author's instruction of 2026-07-26 ("open the
-- trampoline boundary") — the ruling that ruling 8 (x5 record)
-- requires, its condition met at dyadic-freeze-r1; the instruction
-- is recorded verbatim in trampoline-author-pack.md Part I, and the
-- freeze tag is its custody attestation (the V-cancellation lesson:
-- no boundary decision is a custody fact until its tag exists).
--
-- THE CLOSED-LOOP LAZY GENIUS (13.4's drafted rows, frozen here):
--   g1  the K-ary choice macro (chooseKS) — CL-3 as ONE sentence
--   g2  composition: policyPick == chooseEU (the shipped selection
--       is the new sentence's special case, extensional ==)
--   g3  the price-only differential (the headline): the SAME
--       trampoline loop against worlds differing ONLY in the
--       declared clock price — think-counts MOVE, both count
--       vectors asserted against the frozen artifact itself
--       (Anchors.t2RowsX imported, never re-derived), plus the
--       partition identity (one policy evaluation per tick) and
--       the preposterior fast path's in-increment pin (section 1b)
--   g5  R1's buy/stay shapes as trampoline rows: the d6-cell
--       transcripts reproduced act-for-act through the ONE
--       sentence (runPurchaseS == runPurchase — the retirement pin
--       for the last host fold)
--   g6  the wire rows: OB-22a (positive hello over pipes), OB-22b
--       (utility_bits == bitsView (weightIn ns prog)), OB-23 (the
--       namespace-immutability live pin), and the clock row's
--       smoke (the internal act crosses the wire)
--
-- Gate E4 (the single chooser) is a GATE, not an oracle row: its
-- scriptable half is staged in test-trampoline/freeze/, its red is
-- the seeded-defect demonstration in the pack (the pin-freeze
-- clause's shape), exactly as the charter drafted.
--
-- RED PARTITION (two-run triptych): g1-g3, g5, g6.4 are runtime-red
-- against the oracle-phase stubs in src (implementation rows);
-- g6.1-g6.3 pin SHIPPED capabilities and their red is the
-- seeded-defect demonstration recorded in the pack (the step-10
-- "or capability" amendment's form).
--
-- R-D20 copy table (byte-wise copies, reviewable by grep):
--   pin helper                    <- test-dyadic/Dyadic.hs:38-41
--   argmaxCL3 (reference fold)    <- test/ExactReference.hs:154-157
--   tNs (the declared t2 world)   <- test/Acceptance.hs:79-80
--   vActB (the engine act value)  <- test/Acceptance.hs:87-91
--   vThinkB (the engine route)    <- test/Acceptance.hs:93-103
--   hiChild + deepChain (hi half) <- test-dyadic/Dyadic.hs:52-64
--   d6.1 moderate-cell quantities <- test-dyadic/Dyadic.hs:213-227
--   d6.2 DEEP-cell quantities     <- test-dyadic/Dyadic.hs:228-240
--   hello fixture base            <- test-transport/Transport.hs:70-76
--     (second guard row + utility DROPPED, codebooks row ADDED per
--      membrane-wire section 2 — the deltas disclosed, not silent)
--   pipe harness (inlined spawn/exchange; waitForProcess dropped,
--     terminateProcess used)      <- test-transport/Transport.hs:100-115
--   enumeration call shape        <- src/PropLang/Host.hs:288-295
--   utility_bits formula          <- membrane-wire.md:394 (identity
--                                    table; Host.hs:300-302)
--   cgrid parse build (grid "u")  <- src/PropLang/Host.hs:266-268
--   singleton-mention mint        <- src/PropLang/Host.hs:396
--
-- The differential's expectation is IMPORTED (Anchors.t2RowsX,
-- buffer36, egSpace, emitK): the frozen artifact itself is the
-- expectation — transport's own R-D20 limit form.
--
-- Test names ASCII-only (the membrane locale incident).
module Main (main) where

import Control.Exception (evaluate)
import Data.List (isInfixOf, mapAccumL, sortOn)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio ((%))
import System.Directory (findExecutable)
import System.IO (BufferMode (LineBuffering), hClose, hGetLine,
                  hPutStrLn, hSetBuffering)
import System.Process (CreateProcess (..), StdStream (CreatePipe, Inherit),
                       createProcess, proc, terminateProcess)
import System.Timeout (timeout)

import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.HUnit (Assertion, assertBool, assertEqual,
                         assertFailure, testCase)

import qualified Anchors
import OracleWorld (egSpace, emitK)
import Streams (buffer36)

import PropLang.Belief (Belief, condK, expect, points, predictMass,
                        uniform, weights)
import PropLang.Enumerate (enumerateWith, fragFull)
import PropLang.Eval (Env, Features, Vals (..), evalx, mkEnvIn)
import PropLang.Host (hostStart, serveLine)
import PropLang.Lattice (mkOwned, rootNode, Node, childrenOf, nodeTheta)
import PropLang.Membrane (DelibWorld (..), chooseEU, menuAssignments,
                          policyPick, preposteriorV, runTrampoline)
import PropLang.Purchase (PTick (..), PurchaseWorld (..), runPurchase,
                          runPurchaseS)
import PropLang.Report (bitsView)
import PropLang.Syntax
import PropLang.Belief (fromWeights, mkSpace)

-- pin: force the frozen side to normal form, then compare (one
-- deepseq per comparison row). COPY test-dyadic/Dyadic.hs:38-41.
pin :: (Eq a, Show a) => String -> a -> a -> Assertion
pin name expected actual = do
  _ <- evaluate (length (show expected))
  assertEqual name expected actual

-- CL-3 argmax: first-listed incumbent, strict > displaces.
-- COPY test/ExactReference.hs:154-157.
argmaxCL3 :: [(a, Rational)] -> (a, Rational)
argmaxCL3 []             = error "argmaxCL3: empty"
argmaxCL3 ((a0, v0) : r) = foldl' step (a0, v0) r
  where step (b, bv) (c, cv) = if cv > bv then (c, cv) else (b, bv)

-- t2's OWN declared world. COPY test/Acceptance.hs:79-80.
tNs :: Namespace
tNs = mkNamespace ("price" :| [])

-- the engine act value. COPY test/Acceptance.hs:87-91 (byte-wise,
-- expect and all — the mandate-1 repair: the first draft re-derived
-- this body and R-D20 forbids exactly that).
vActB :: Belief Rational -> Rational
vActB b =
  let eR = expect b (\th -> 2 * th - 1)
      eL = negate eR
  in if eR > eL then eR else eL   -- CL-3: L incumbent, R displaces on >

-- the engine route of the preposterior (price folded in). COPY
-- test/Acceptance.hs:93-103.
vThinkB :: Belief Rational -> Int -> Rational -> Rational
vThinkB b bufLen price =
  let batchN = min 3 bufLen
      seqs = foldl' (\ss _ -> [ s ++ [y] | s <- ss, y <- [0, 1] ]) [[]]
                    [1 .. batchN]
      run s = foldl' (\(bb, m) y ->
                case condK bb emitK y of
                  Just bb' -> (bb', m * predictMass bb emitK y)
                  Nothing -> (bb, 0))
                (b, 1) s
  in sum [ m * vActB bb | s <- seqs, let (bb, m) = run s ] - price

-- the higher-theta child + the DEEP pre-owned chain (the hiChild
-- half of the pair). COPY test-dyadic/Dyadic.hs:52-64.
hiChild :: Node -> Node
hiChild n = case sortOn nodeTheta (childrenOf n) of
  [_, h] -> h
  _      -> error "hiChild: a lattice node has exactly two children"

deepChain :: [Node]
deepChain = take 6 (iterate hiChild (hiChild rootNode))

-- a priced mention through the singleton mint (the parseSaid
-- precedent, src/PropLang/Host.hs:396); total on the singleton.
cQ :: Rational -> Expr env Rational
cQ v = case mkC (mkGrid "k" (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "cQ: singleton mint (unreachable: index 0)"

-- the shared door for sentence-only rows (t2's declared shape)
envT :: Rational -> Either String (Env '[])
envT p = mkEnvIn tNs [("price", p)] VNil

evalT :: Expr '[] Rational -> Rational
evalT e = case envT 0 of
  Right env -> evalx e env
  Left m -> error ("envT (unreachable: the door covers) " ++ m)

-- ---------------------------------------------------------------------
-- g1 — the K-ary choice macro
-- ---------------------------------------------------------------------

g1 :: TestTree
g1 = testGroup "g1 chooseKS (the one-sentence CL-3 tournament)"
  [ testCase "g1.1 hand battery: singleton, tie-to-incumbent, mid-list winner, negatives" $ do
      pin "singleton returns its own code" 7
        (evalT (chooseKS ((cQ 7, cQ 5) :| [])))
      pin "a tie keeps the incumbent (first-listed)" 3
        (evalT (chooseKS ((cQ 3, cQ 1) :| [(cQ 4, cQ 1)])))
      pin "strict displacement, winner mid-list" 5
        (evalT (chooseKS ((cQ 1, cQ 0) :| [(cQ 5, cQ 9), (cQ 3, cQ 7)])))
      pin "negative values: the less-negative incumbent survives" 2
        (evalT (chooseKS ((cQ 2, cQ (-1)) :| [(cQ 6, cQ (-3))])))
  , testCase "g1.2 chooseKS == the CL-3 reference fold (K in 2..4, ties included)" $ do
      let codes = [7, 11, 13, 17] :: [Rational]
          batteries =
            [ [0, 1], [1, 0], [1, 1]
            , [0, 2, 1], [2, 0, 1], [1, 2, 2], [5, 5, 5]
            , [0, 3, 3, 1], [4, 1, 4, 2], [-2, -1, -3, -1]
            ]
          runOne vs =
            let rows = zip codes vs
                sent = case [ (cQ c, cQ v) | (c, v) <- rows ] of
                  (r0 : rs) -> chooseKS (r0 :| rs)
                  []        -> error "runOne: battery rows are nonempty"
            in (evalT sent, fst (argmaxCL3 rows))
      mapM_ (\vs -> let (got, want) = runOne vs
                    in pin ("battery " ++ show vs) want got)
            batteries
  ]

-- ---------------------------------------------------------------------
-- g2 — composition: chooseEU is the new sentence's special case
-- ---------------------------------------------------------------------

-- comparable image of a selection result
normSel :: Either String (Maybe (Features, Belief Int))
        -> Either String (Maybe (Features, [Int], [Rational]))
normSel = fmap (fmap (\(f, b) -> (f, points b, weights b)))

-- The pin's SCOPE is the wire's utility convention (the narrowed
-- degenerate latent: option code bound to 0; utilities read the
-- outcome and non-writable world features). A utility reading a
-- WRITABLE name is a fold artifact under the shipped chooseEU (both
-- sides of every comparison are served the CHALLENGER's assignment,
-- so action-dependent utilities degenerate to ties) — the finding,
-- its demonstration, and the one-sentence route's repair are the
-- boundary pack's register item, not an oracle row.
g2 :: TestTree
g2 = testGroup "g2 policyPick == chooseEU (extensional on the wire convention)"
  [ testCase "g2.1 two- and three-candidate batteries, tie included" $ do
      let ns = mkNamespace ("m" :| [])
          nsW = mkNamespace ("w" :| ["m"])
          g2g = mkGrid "m" (0 :| [1])
          g3g = mkGrid "m" (0 :| [1, 2])
          atomG = mkGrid "obs-atoms" (0 :| [1])
          u = Var (S Z)
          uW = Mul (Get "w") (Var (S Z))
          uTie = Mul (cQ 0) (Var (S Z))
          bOf w1 = case fromWeights (mkSpace ((0 :: Int) :| [1]))
                          (\y -> if y == 1 then w1 else 1 - w1) of
            Just b  -> b
            Nothing -> error "bOf: lawful weights (unreachable)"
          cands2 = zip (menuAssignments [("m", g2g)]) [bOf (1 % 2), bOf (3 % 4)]
          cands3 = zip (menuAssignments [("m", g3g)])
                       [bOf (1 % 2), bOf (3 % 4), bOf (1 % 4)]
      pin "2 candidates" (normSel (chooseEU ns [] atomG u cands2))
                         (normSel (policyPick ns [] atomG u cands2))
      pin "3 candidates" (normSel (chooseEU ns [] atomG u cands3))
                         (normSel (policyPick ns [] atomG u cands3))
      pin "tie battery (uTie: every EU 0, incumbent survives)"
          (normSel (chooseEU ns [] atomG uTie cands2))
          (normSel (policyPick ns [] atomG uTie cands2))
      pin "a world-feature utility (Get of a NON-writable, door-served)"
          (normSel (chooseEU nsW [("w", 1 % 3)] atomG uW cands2))
          (normSel (policyPick nsW [("w", 1 % 3)] atomG uW cands2))
      pin "the winner is CL-3's (challenger m=1 on strict >)"
          (Right (Just ([("m", 1)], [0, 1], [1 % 4, 3 % 4])))
          (normSel (policyPick ns [] atomG u cands2))
  , testCase "g2.3 the substitution witness: a writable-reading utility DIVERGES from the fold (pins the R4 draft; kills any policyPick = chooseEU delegation)" $ do
      -- fold (challenger-served env): both sides read the
      -- challenger's m, so with cands [(m=0, E[y]=3/4), (m=1,
      -- E[y]=1/4)] the challenger's value 1*1/4 < 1*3/4 and the
      -- incumbent m=0 stays; substitution values each option at its
      -- OWN m: [0, 1/4] and m=1 wins. Both behaviors asserted — the
      -- divergence IS the row (the sitting may strike it under R4).
      let ns = mkNamespace ("m" :| [])
          g2g = mkGrid "m" (0 :| [1])
          atomG = mkGrid "obs-atoms" (0 :| [1])
          uRW = Mul (Get "m") (Var (S Z))
          bOf w1 = case fromWeights (mkSpace ((0 :: Int) :| [1]))
                          (\y -> if y == 1 then w1 else 1 - w1) of
            Just b  -> b
            Nothing -> error "bOf: lawful weights (unreachable)"
          cands = zip (menuAssignments [("m", g2g)]) [bOf (3 % 4), bOf (1 % 4)]
      pin "the fold keeps the head (the challenger-served degeneracy)"
          (Right (Just ([("m", 0)], [0, 1], [1 % 4, 3 % 4])))
          (normSel (chooseEU ns [] atomG uRW cands))
      pin "the sentence route picks the option's OWN value (substitution)"
          (Right (Just ([("m", 1)], [0, 1], [3 % 4, 1 % 4])))
          (normSel (policyPick ns [] atomG uRW cands))
  , testCase "g2.2 four candidates with a mid-list duplicate value" $ do
      let ns = mkNamespace ("m" :| [])
          g4g = mkGrid "m" (0 :| [1, 2, 3])
          atomG = mkGrid "obs-atoms" (0 :| [1])
          u = Var (S Z)
          bOf w1 = case fromWeights (mkSpace ((0 :: Int) :| [1]))
                          (\y -> if y == 1 then w1 else 1 - w1) of
            Just b  -> b
            Nothing -> error "bOf: lawful weights (unreachable)"
          -- EUs by belief alone: [1/2, 3/4, 3/4, 1/12] — the dup
          -- pair mid-list; CL-3 keeps the FIRST of the pair
          cands = zip (menuAssignments [("m", g4g)])
                      [bOf (1 % 2), bOf (3 % 4), bOf (3 % 4), bOf (1 % 12)]
      pin "4 candidates (dup EU mid-list: first of the pair wins)"
          (normSel (chooseEU ns [] atomG u cands))
          (normSel (policyPick ns [] atomG u cands))
  ]

-- ---------------------------------------------------------------------
-- g3 — the price-only differential (the headline)
-- ---------------------------------------------------------------------

g3 :: TestTree
g3 = testGroup "g3 the price-only differential (the closed-loop lazy genius)"
  [ testCase "g3.1 think-counts and final acts == the frozen artifact itself (Anchors.t2RowsX)" $ do
      let base = DelibWorld { dwPrice = 0, dwBatch = 3 }
          run p = case runTrampoline tNs egSpace emitK base { dwPrice = p } buffer36 of
            Right tr -> ( p
                        , length (filter (== "think") tr)
                        , case reverse tr of
                            (a : _) -> a
                            []      -> "EMPTY" )
            Left m -> (p, -1, m)
      pin "the differential (worlds differ ONLY in dwPrice, by construction)"
          Anchors.t2RowsX
          [ run p | (p, _, _) <- Anchors.t2RowsX ]
  , testCase "g3.2 the free-clock rung climb: the full buffer in batches (derived, never hand-written)" $ do
      let base = DelibWorld { dwPrice = 0, dwBatch = 3 }
      case runTrampoline tNs egSpace emitK base buffer36 of
        Left m -> assertFailure m
        Right tr ->
          pin "thinks at price 0 = |buffer| / batch"
              (length buffer36 `div` dwBatch base)
              (length (filter (== "think") tr))
  , testCase "g3.3 the transcript partition (the single-evaluation identity's scriptable half; the loop-structure half is implementation-review law)" $ do
      let base = DelibWorld { dwPrice = 0, dwBatch = 3 }
          check p = case runTrampoline tNs egSpace emitK base { dwPrice = p } buffer36 of
            Left m -> assertFailure m
            Right tr -> do
              assertBool "transcript nonempty" (not (null tr))
              let (pre, lastRow) = case reverse tr of
                    (a : rs) -> (reverse rs, a)
                    []       -> ([], "EMPTY")
              assertBool "every pre-final tick is a think row"
                         (all (== "think") pre)
              assertBool "the final tick is an external act"
                         (lastRow `elem` ["L", "R"])
              pin "|transcript| == thinks + 1"
                  (length (filter (== "think") tr) + 1) (length tr)
      mapM_ check [3 % 10, 5 % 100, 5 % 1000, 0]
  , testCase "g3.4 the preposterior fast path is PINNED to the frozen route (section 1b, in-increment)" $ do
      -- chain: preposteriorV == vThinkB(price 0) here; vThinkB ==
      -- the ONE-SENTENCE route in the frozen acceptance suite
      -- (test/Acceptance.hs:262-279) — the pin composes.
      let beliefs = uniform egSpace
            : [ b | y <- [1, 1, 0, 1]
              , Just b <- [condK (uniform egSpace) emitK y] ]
      mapM_ (\(b, d) ->
              pin ("belief fold, batch " ++ show d)
                  (Right (vThinkB b d 0))
                  (preposteriorV tNs [("price", 0)] d b emitK))
        [ (b, d) | b <- beliefs, d <- [1, 2, 3] ]
      -- the door payload is R5 ceremony, not an input: the total is
      -- price-FREE, so a differently-served price changes nothing
      -- (the mandate-6 independence point)
      pin "served-price independence (the payload is a door, not data)"
          (preposteriorV tNs [("price", 0)] 3 (uniform egSpace) emitK)
          (preposteriorV tNs [("price", 3 % 10)] 3 (uniform egSpace) emitK)
  ]

-- ---------------------------------------------------------------------
-- g5 — R1's buy/stay shapes through the ONE sentence
-- ---------------------------------------------------------------------

-- the R5 door payload for the purchase rows: a NEUTRAL declared
-- name (the sentence reads no features; "door" avoids overloading
-- the wire's clock row — the mandate-5 repair)
pNs :: Namespace
pNs = mkNamespace ("door" :| [])

pFeats :: Features
pFeats = [("door", 0)]

g5 :: TestTree
g5 = testGroup "g5 the purchase shapes through the sentence (the last host fold's pin)"
  [ testCase "g5.1 recurring-stakes buy: the d6.1 moderate cell act-for-act (COPY test-dyadic/Dyadic.hs:213-227)" $ do
      let w = PurchaseWorld { pwStakes = (1, -1)
                            , pwRefine = Just (1 % 20)
                            , pwLadderCap = 16 }
          stream = take 40 (cycle [1, 1, 0, 1, 0])
      case runPurchaseS pNs pFeats w (mkOwned [rootNode]) stream of
        Left m -> assertFailure m
        Right ticks -> do
          let acts = zip [0 :: Int ..] (map ptAct ticks)
              n nm = length [ () | (_, a) <- acts, a == nm ]
          pin "wait count" (2 :: Int) (n "wait")
          pin "respond count" (35 :: Int) (n "respond")
          pin "refine count" (3 :: Int) (n "refine")
          pin "first respond" (Just 5 :: Maybe Int)
            (case [ t | (t, a) <- acts, a == "respond" ] of
               (t : _) -> Just t
               []      -> Nothing)
          pin "act-for-act == runPurchase (the retirement pin)"
            (map ptAct (runPurchase w (mkOwned [rootNode]) stream))
            (map ptAct ticks)
          -- the door payload is R5 ceremony (the sentence reads no
          -- features): a different declared payload, same transcript
          pin "door-payload independence"
            (Right ticks)
            (runPurchaseS (mkNamespace ("w" :| [])) [("w", 7)]
               w (mkOwned [rootNode]) stream)
  , testCase "g5.2 the myopic stay: the d6.2 DEEP cell (COPY test-dyadic/Dyadic.hs:228-240)" $ do
      let w = PurchaseWorld { pwStakes = (1, -24)
                            , pwRefine = Just (1 % 20)
                            , pwLadderCap = 16 }
          stream = replicate 60 1
          owned = mkOwned (rootNode : deepChain)
      case runPurchaseS pNs pFeats w owned stream of
        Left m -> assertFailure m
        Right ticks -> do
          let acts = zip [0 :: Int ..] (map ptAct ticks)
          pin "first respond" (Just 45 :: Maybe Int)
            (case [ t | (t, a) <- acts, a == "respond" ] of
               (t : _) -> Just t
               []      -> Nothing)
          pin "respond count" (15 :: Int)
            (length [ () | (_, a) <- acts, a == "respond" ])
          pin "transcript == runPurchase (full rows)"
            (runPurchase w owned stream) ticks
  , testCase "g5.4 the banked deadlock cell DOCUMENTED (13.3 branch (b)): root-only vocabulary, deep stakes, 60 all-correct ticks, zero refines" $ do
      -- the GroundC observation (re-executed at the dyadic close)
      -- reproduced through the ONE sentence: the max-0 clamp zeroes
      -- every single-step gain, refine never fires, the agent waits
      -- forever — the myopic single-step candidate's HONEST
      -- behavior, now an oracle row (register R1 drafts (b); the
      -- (a) route re-enters only with a measurement)
      let w = PurchaseWorld { pwStakes = (1, -24)
                            , pwRefine = Just (1 % 20)
                            , pwLadderCap = 16 }
          stream = replicate 60 1
      case runPurchaseS pNs pFeats w (mkOwned [rootNode]) stream of
        Left m -> assertFailure m
        Right ticks -> do
          pin "wait 60 / respond 0 / refine 0 (the deadlock, verbatim)"
              (replicate 60 "wait") (map ptAct ticks)
          pin "== runPurchase (the fold agrees: the behavior is the law's)"
              (runPurchase w (mkOwned [rootNode]) stream) ticks
  , testCase "g5.3 the wait head owns ties through the sentence (stakes (0,0): every guard exactly 0)" $ do
      let w = PurchaseWorld { pwStakes = (0, 0)
                            , pwRefine = Just (1 % 20)
                            , pwLadderCap = 16 }
          stream = take 5 (cycle [1, 0])
      case runPurchaseS pNs pFeats w (mkOwned [rootNode]) stream of
        Left m -> assertFailure m
        Right ticks -> do
          pin "all wait (ties break to inaction, in-sentence)"
              (replicate 5 "wait") (map ptAct ticks)
          pin "== runPurchase" (runPurchase w (mkOwned [rootNode]) stream)
              ticks
  ]

-- ---------------------------------------------------------------------
-- g6 — the wire rows
-- ---------------------------------------------------------------------

-- hello base copied from test-transport/Transport.hs:70-76, with the
-- codebooks row REQUIRED by membrane-wire.md section 2 added (theta
-- mandatory; the fail-closed refusal side is transport t1's pin —
-- this suite pins the ACCEPTANCE side, OB-22a).
helloCB :: String
helloCB = "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\", \"z\", \"a\"], "
    ++ "\"guards\": [{\"name\": \"z\", \"grid\": [0.25, 0.5, 0.75]}], "
    ++ "\"menu\": [{\"name\": \"a\", \"grid\": [0.5, 1.5]}], "
    ++ "\"codebooks\": {\"theta\": [0.25, 0.5, 0.75]}}}"

-- the t2-lineage wire world: bern family, the L/R menu, the said
-- utility move*(2y-1), and the clock row (the trampoline's wire
-- form, staged install; price 0 => the internal act wins tick one).
-- SITTING FLAG (mandate 2): the utility reads the writable "move" —
-- the R4-pending semantics — but every assertion below is
-- INSENSITIVE to that ruling (at the uniform first tick both
-- readings give the externals EU 0, and think wins strictly).
helloClock :: String
helloClock = "{\"membrane\": 1, \"world\": {\"namespace\": [\"move\"], "
    ++ "\"guards\": [], "
    ++ "\"menu\": [{\"name\": \"move\", \"grid\": [-1, 1]}], "
    ++ "\"codebooks\": {\"theta\": [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]}, "
    ++ "\"utility\": {\"form\": \"said@1\", \"said\": [\"*\", [\"get\", \"move\"], "
    ++ "[\"-\", [\"+\", [\"var\", 1], [\"var\", 1]], [\"c\", 1]]]}, "
    ++ "\"clock\": [{\"name\": \"think\", \"price\": 0, \"batch\": 1}]}}"

g6 :: TestTree
g6 = testGroup "g6 the wire rows (OB-22, OB-23, the clock)"
  [ testCase "g6.1 OB-22a: a codebook-bearing hello is ACCEPTED over pipes (models from the library route)" $ do
      -- the expected count through the library (call shape COPY
      -- src/PropLang/Host.hs:288-295)
      let nsN = mkNamespace ("t" :| ["z", "a"])
          obsC = mkCarrier "obs" (0 :| [1])
          thetaG = mkGrid "theta" (1 % 4 :| [1 % 2, 3 % 4])
          gs = [("z", mkGrid "z" (1 % 4 :| [1 % 2, 3 % 4]))]
          nModels = length (enumerateWith nsN obsC thetaG gs Nothing fragFull)
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
      hPutStrLn hin helloCB
      mreply <- timeout (5 * 1000 * 1000) (hGetLine hout)
      hClose hin
      terminateProcess ph
      case mreply of
        Nothing -> assertFailure "no hello reply within the window"
        Just reply -> do
          assertBool ("accepted: " ++ reply) ("\"ok\": true" `isInfixOf` reply)
          assertBool ("models: " ++ reply)
            (("\"models\": " ++ show nModels) `isInfixOf` reply)
  , testCase "g6.2 OB-22b: utility_bits == bitsView (weightIn ns prog) (COPY membrane-wire.md:394)" $ do
      let helloU = "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\", \"z\", \"a\"], "
            ++ "\"guards\": [{\"name\": \"z\", \"grid\": [0.25, 0.5, 0.75]}], "
            ++ "\"menu\": [{\"name\": \"a\", \"grid\": [0.5, 1.5]}], "
            ++ "\"codebooks\": {\"theta\": [0.25, 0.5, 0.75]}, "
            ++ "\"utility\": {\"form\": \"said@1\", "
            ++ "\"said\": [\"*\", [\"c\", 0.5], [\"var\", 1]], "
            ++ "\"cgrid\": [0.5, 1.5]}}}"
          (_, reply) = serveLine hostStart helloU
          -- the declared program, hand-built to the parse spec (the
          -- cgrid mint builds grid "u" — COPY Host.hs:266-268)
          nsN = mkNamespace ("t" :| ["z", "a"])
          prog :: Expr '[Rational, Rational] Rational
          prog = case mkC (mkGrid "u" (1 % 2 :| [3 % 2])) 0 of
            Just c05 -> Mul c05 (Var (S Z))
            Nothing  -> error "prog: on-codebook index (unreachable)"
          expected = "\"utility_bits\": " ++ show (bitsView (weightIn nsN prog))
      assertBool ("reply carries the identity: " ++ reply
                  ++ " want " ++ expected)
        (expected `isInfixOf` reply)
  , testCase "g6.3 OB-23: owned posterior odds invariant under mid-episode publication (membrane-wire.md section 2)" $ do
      let evTick t y = "{\"tick\": {\"features\": {\"t\": " ++ show (t :: Int)
            ++ ", \"z\": 0.5}, \"menu\": [\"a\"], \"evidence\": " ++ show (y :: Int) ++ "}}"
          decTick t = "{\"tick\": {\"features\": {\"t\": " ++ show (t :: Int)
            ++ ", \"z\": 0.25}, \"menu\": [\"a\"]}}"
          evs = zip [0 ..] [1, 0, 1, 1]
          sessA = helloCB : [ evTick t y | (t, y) <- evs ]
          -- session B interleaves PUBLICATION events (decision
          -- ticks: menu published, no evidence) mid-episode
          sessB = helloCB : concat
            [ [ decTick (100 + t), evTick t y ] | (t, y) <- evs ]
          repliesOf ls = snd (mapAccumL serveLine hostStart ls)
          evRepliesA = case repliesOf sessA of
            (_ : rs) -> rs
            []       -> []
          evRepliesB = case repliesOf sessB of
            (_ : rs) -> [ r | (i, r) <- zip [(0 :: Int) ..] rs, odd i ]
            []       -> []
      assertBool "session A serves its evidence ticks"
        (all ("loss_bits" `isInfixOf`) evRepliesA)
      pin "the evidence replies are BYTE-EQUAL under interleaved publication"
          evRepliesA evRepliesB
  , testCase "g6.4 the clock row crosses the wire: at price 0 the first decision reply is the internal act" $ do
      let (st1, r1) = serveLine hostStart helloClock
          tick = "{\"tick\": {\"features\": {}, \"menu\": [\"move\"]}}"
          (_, r2) = serveLine st1 tick
      assertBool ("clock hello accepted: " ++ r1)
        ("\"ok\": true" `isInfixOf` r1)
      assertBool ("the internal act crosses: " ++ r2)
        ("\"internal\": \"think\"" `isInfixOf` r2)
      -- evidence on an internal tick folds (at feats ++ the wait
      -- head — register R8); the reply carries the fold's record
      let (_, r3) = serveLine st1 tick
          tickEv = "{\"tick\": {\"features\": {}, \"menu\": [\"move\"], \"evidence\": 1}}"
          (_, r4) = serveLine st1 tickEv
      assertBool ("stateless recheck: " ++ r3)
        ("\"internal\": \"think\"" `isInfixOf` r3)
      assertBool ("evidence folds on the internal tick: " ++ r4)
        ("\"internal\": \"think\"" `isInfixOf` r4
         && "\"observed\": 1" `isInfixOf` r4
         && "loss_bits" `isInfixOf` r4)
  ]

main :: IO ()
main = defaultMain (testGroup "the trampoline boundary (EXACT_PLAN 13)"
  [ g1, g2, g3, g5, g6 ])
