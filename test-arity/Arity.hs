-- test-arity: the W3 increment oracle — observation arity declarable
-- at the handshake (wire boundary, WIRE_PLAN.md section 3 W3; OB-5;
-- issue #9's arity half — the grid half died with ruling R-W1).
--
-- THE DESIGN OF RECORD is wire-author-pack.md Part VII. One optional
-- hello key `"obs_arity": K` (finite, integral, K >= 2, else bad
-- hello) declares the CODOMAIN of the observation channel — atoms
-- 0..K-1 — under R-W1's ruled line: "the wire may declare the codomain
-- of observation — what the channel can emit — never the support of
-- belief about the channel's law." The law stays in-language: at
-- arity K a sentence distinguishes one POSITIVE atom j in {1..K-1}
-- (atom 0 is the null emission; grounds in Part VII.1) at rate theta:
--
--     P(y = j) = theta;   P(y /= j) = (1-theta)/(K-1) uniformly.
--
-- Zero alphabet productions: the family is enumerator data, its
-- bodies sentences of the shipped grammar, its atom mention priced
-- log2(K-1) against the declared codomain (the M1 namespace law's
-- shape — 0 while singleton, so the default's prices cannot move).
--
-- ENUMERATION ORDER (a declared fresh coordinate, D2): within each
-- family the distinguished atom j is the OUTERMOST loop, ascending;
-- inside j the family keeps the shipped order (consts: theta grid
-- order; walks: rho grid order; guards: threshold, then a, then b).
-- Families keep the shipped block order: consts, walks, then guard
-- families per name. g4/g5/g6 read (j, theta) off indices under this
-- declaration — the rows pin the coordinate as well as the values.
--
-- RED/GREEN AT THE STUB PHASE (attribution): the arity rows (g2a-g2b
-- via enumerateSentencesArity, g2c via obsSpaceAt, g3, g4, g5, g6,
-- g7a/b/d via the honored key, g7c via validation, g8) are RED
-- against the oracle-phase stubs. The default re-pin rows (g1a, g1b)
-- are GREEN by design — they guard the shipped path through the
-- seam; their red is demonstrated by the seeded-defect runner
-- (ablation/run.sh: the spread divisor K-1 -> K reds g1b, g2b, g4a
-- while g4b Cromwell stays green — attribution partitioned, the R1
-- run.sh precedent).
--
-- COPIES, NEVER RE-DERIVED (R-D20-i provenance):
--   helloLine/tickLine/runAll/field  test-measure/Measure.hs:75-116
--   the four population pins          test-measure/Measure.hs:193-197
--     (1169 Enumerate.hs enumerateSentences haddock; 1241
--      test-sentence/Sentence.hs:287; 1529/1601 test-unify/Unify.hs
--      :125-126) and their hello worlds test-measure/Measure.hs:207-213
--   w64                               test-unify/Unify.hs:84-85
--   the error-line format             src/PropLang/Host.hs:195-196
--   the meta-prior law                sentenceAgent haddock
--     ("Meta-prior 2^(-hypBits) through the only prior source") —
--     g6 reads hypBits off the enumerated sentences themselves
--   the charge-tree pin doctrine      test-pricing (step 4: the
--     oracle pins the trees; the arithmetic row states the M1 law,
--     Enumerate.hs guardCharge nsB — "0 while singleton")
--
-- GATES FROM MEASUREMENT (R-D21 satisfiability transcripts, pack
-- Part VII.5; the CL-4 discipline — a gate is born from a
-- measurement): g4a 1e-12 from a measured floor of 5.551e-16 over
-- every (K, j, theta, y) cell at K in {3,5,10}; g6 1e-12 from a
-- measured floor of 1.110e-16; g5b's bound 0.125 = 2x the measured
-- uniform-stream top mass 6.2024e-2 (deterministic fixture); g5a's
-- render literal is derived from the frozen renderExpr executed on
-- the overlay realization (the renderer is the frozen artifact, so
-- the literal is a copy, not a parallel derivation — R-D20-i).
module Main (main) where

import Data.List (intercalate, isPrefixOf, sort, tails)
import Data.List.NonEmpty (NonEmpty ((:|)))
import GHC.Float (castDoubleToWord64)

import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief (Bits (Bits), is, prob, spacePoints, top)
import PropLang.Enumerate (Agent, FragProd (..), Hyp (..), agentMeta,
                           constCharge, constChargeA,
                           enumerateSentencesArity, enumerateSentencesIn,
                           fragFull, fragWidth, guardCharge, guardChargeA,
                           observe, obsSpace, obsSpaceAt, predictive,
                           renderExpr, sentenceAgent, sentenceAgentK,
                           thetaPoints, walkCharge, walkChargeA)
import PropLang.Host (HostState, hostStart, serveLine)
import PropLang.Syntax (chargeBits, mkGrid, mkNamespace)

main :: IO ()
main = defaultMain $ testGroup "arity (wire boundary W3)"
  [ g1DefaultPin
  , g2Coincidence
  , g3Pricing
  , g4Law
  , g5Behavior
  , g6ClosedForm
  , g7Wire
  , g8Ablation
  ]

-- ---------------------------------------------------------------------
-- wire-line builders (COPY test-measure/Measure.hs:75-116, extended
-- with the raw-injected obs_arity key so malformed values are sayable)
-- ---------------------------------------------------------------------

helloLineK :: Maybe String -> [String] -> [(String, [Double])]
           -> [(String, [Double])] -> String
helloLineK ar ns gs menu =
  "{\"world\": {\"namespace\": [" ++ intercalate ", " (map show ns)
  ++ "], \"guards\": [" ++ intercalate ", " (map pair gs) ++ "]"
  ++ (if null menu
      then ""
      else ", \"menu\": [" ++ intercalate ", " (map pair menu) ++ "]")
  ++ maybe "" (\a -> ", \"obs_arity\": " ++ a) ar
  ++ "}}"
  where
    pair (nm, vs) = "{\"name\": " ++ show nm ++ ", \"grid\": ["
                    ++ intercalate ", " (map show vs) ++ "]}"

helloLine :: [String] -> [(String, [Double])] -> [(String, [Double])]
          -> String
helloLine = helloLineK Nothing

tickLine :: [(String, Double)] -> Maybe Int -> Maybe [String] -> String
tickLine feats ev menu =
  "{\"tick\": {\"features\": {"
  ++ intercalate ", " [ show k ++ ": " ++ show v | (k, v) <- feats ] ++ "}"
  ++ maybe "" (\y -> ", \"evidence\": " ++ show y) ev
  ++ maybe "" (\ms -> ", \"menu\": [" ++ intercalate ", " (map show ms) ++ "]") menu
  ++ "}}"

runAll :: HostState -> [String] -> (HostState, [String])
runAll st0 = go st0 []
  where
    go st acc []       = (st, reverse acc)
    go st acc (l : ls) =
      let (st', r) = serveLine st l
      in length r `seq` go st' (r : acc) ls

field :: String -> String -> Maybe Double
field k s =
  case [ drop (length pat) t | t <- tails s, pat `isPrefixOf` t ] of
    rest : _ -> Just (read (takeWhile (`notElem` ",}") rest))
    []       -> Nothing
  where pat = "\"" ++ k ++ "\": "

w64 :: Double -> Integer
w64 = toInteger . castDoubleToWord64

-- ---------------------------------------------------------------------
-- fixtures
-- ---------------------------------------------------------------------

ns1 :: [String]
ns1 = ["t"]

thetas :: [Double]
thetas = let (t0 :| ts) = thetaPoints in t0 : ts

-- the shipped binary universe (the frozen reference route)
shipPop :: [Hyp]
shipPop = enumerateSentencesIn (mkNamespace ("t" :| [])) [] fragFull

-- the arity route at K
arityPop :: Int -> [Hyp]
arityPop k = enumerateSentencesArity k thetaPoints
               (mkNamespace ("t" :| [])) [] fragFull

-- a single sentence's predictive mass at atom y, through public verbs
-- only (a singleton agent's predictive IS its emission predictive)
probOf :: Int -> Hyp -> [(String, Double)] -> Int -> Double
probOf k h fs y =
  prob (predictive fs (sentenceAgentK (obsSpaceAt k) [h]))
       (is (obsSpaceAt k) y)

probOfShip :: Hyp -> [(String, Double)] -> Int -> Double
probOfShip h fs y =
  prob (predictive fs (sentenceAgent [h])) (is obsSpace y)

-- fold an evidence stream (features carry the tick echo, the wire's
-- geometry) into an agent; impossible evidence is a fixture bug
train :: Agent -> [Int] -> Agent
train ag0 ys = go ag0 (zip [1 :: Int ..] ys)
  where
    go ag [] = ag
    go ag ((t, y) : rest) =
      case observe [("t", fromIntegral t)] y ag of
        Just (_, ag') -> go ag' rest
        Nothing       -> error "test-arity train: impossible evidence"

-- full posterior by index, through the public diagnostics
posterior :: Agent -> Int -> [(Int, Double)]
posterior ag n = top (agentMeta ag) n

-- ---------------------------------------------------------------------
-- g1: the default re-pin (the optimisation law's re-pin, this
-- increment's seam guarded on the shipped side)
-- ---------------------------------------------------------------------

g1DefaultPin :: TestTree
g1DefaultPin = testGroup "g1 the default is untouched (populations + wire bytes)"
  [ testCase "the four pinned populations through the wire (COPY test-measure/Measure.hs:207-213)" $ do
      let hellos =
            [ (1169, helloLine ["t"] [] [])
            , (1241, helloLine ["t", "s2"] [("s2", [0.5])] [])
            , (1529, helloLine ["t", "z", "a"]
                       [("z", [0.25, 0.5, 0.75]), ("a", [0.5, 1.5])] [])
            , (1601, helloLine ["t", "z", "a"]
                       [("z", [0.25, 0.5, 0.75]), ("a", [0.5, 1.5, 2.5])] [])
            ]
      mapM_ (\(n, l) -> field "models" (snd (serveLine hostStart l))
                          @?= Just (fromIntegral (n :: Int)))
            hellos
  , testCase "declared obs_arity 2 is byte-equal to the absent key (hello + 6-tick stream)" $ do
      let world ar = helloLineK ar ["t", "risk", "m"]
                       [("risk", [0.5])] [("m", [0.0, 1.0])]
          stream =
            [ tickLine [("t", 1), ("risk", 1)] (Just 1) Nothing
            , tickLine [("t", 2), ("risk", 0)] (Just 0) Nothing
            , tickLine [("t", 3), ("risk", 1)] (Just 1) (Just ["m"])
            , tickLine [("t", 4)] Nothing (Just ["m"])
            , tickLine [("t", 5), ("risk", 0)] (Just 0) (Just ["m"])
            , tickLine [("t", 6)] Nothing Nothing
            ]
          (_, rAbsent) = runAll hostStart (world Nothing : stream)
          (_, rTwo)    = runAll hostStart (world (Just "2") : stream)
      rTwo @?= rAbsent
  ]

-- ---------------------------------------------------------------------
-- g2: the coincidence pin (the section-1b shape: the arity route at
-- K=2 is pinned extensionally to the shipped route — a theorem the
-- suite enforces, never a trusted branch)
-- ---------------------------------------------------------------------

g2Coincidence :: TestTree
g2Coincidence = testGroup "g2 arity-2 coincides with the shipped route (extensional, bit-exact)"
  [ testCase "g2a count and dl multiset bit-equal (w64)" $ do
      let a2 = arityPop 2
      length a2 @?= length shipPop
      sort (map (w64 . unBits . hypBits) a2)
        @?= sort (map (w64 . unBits . hypBits) shipPop)
  , testCase "g2b paired emissions pointwise bit-equal at both guard branches (w64)" $ do
      let a2 = arityPop 2
          probes = [[("t", 0)], [("t", 50)]]
          cells = [ (i, fs, y) | i <- [0 .. length shipPop - 1]
                  , fs <- probes, y <- [0, 1] ]
      mapM_ (\(i, fs, y) ->
               w64 (probOf 2 (a2 !! i) fs y)
                 @?= w64 (probOfShip (shipPop !! i) fs y))
            cells
  , testCase "g2c obsSpaceAt 2 is obsSpace, point for point" $
      spacePoints (obsSpaceAt 2) @?= spacePoints obsSpace
  ]

unBits :: Bits -> Double
unBits (Bits b) = b

-- ---------------------------------------------------------------------
-- g3: pricing (the namespace law's twin: the atom mention is priced
-- log2(K-1) against the declared codomain — 0 while singleton)
-- ---------------------------------------------------------------------

g3Pricing :: TestTree
g3Pricing = testGroup "g3 the atom mention priced against the declared codomain"
  [ testCase "g3a at K=5 a cat const's dl IS its declared tree AND shipped + log2 4 (w64)" $ do
      let eg = mkGrid "theta" thetaPoints
      h0 <- case arityPop 5 of
        h : _ -> pure h
        []    -> assertFailure "empty arity-5 enumeration"
      w64 (unBits (hypBits h0))
        @?= w64 (chargeBits fragWidth (constChargeA 5 eg))
      w64 (unBits (hypBits h0))
        @?= w64 (chargeBits fragWidth (constCharge eg) + logBase 2 4)
  , testCase "g3a-walk/guard: the K trees carry the same mention term (w64)" $ do
      let eg = mkGrid "theta" thetaPoints
          ns = mkNamespace ("t" :| [])
          g  = mkGrid "tau" (5 :| [10])
      w64 (chargeBits fragWidth (walkChargeA 5))
        @?= w64 (chargeBits fragWidth walkCharge + logBase 2 4)
      w64 (chargeBits fragWidth (guardChargeA 5 ns g eg))
        @?= w64 (chargeBits fragWidth (guardCharge ns g eg) + logBase 2 4)
  , testCase "g3b a wider codomain strictly reprices the mention (K = 3 < 5 < 9)" $ do
      let eg = mkGrid "theta" thetaPoints
          dl k = chargeBits fragWidth (constChargeA k eg)
      assertBool "dl 3 < dl 5" (dl 3 < dl 5)
      assertBool "dl 5 < dl 9" (dl 5 < dl 9)
  , testCase "g3c at K=2 the mention is free: the K tree prices bit-equal the shipped tree (w64)" $ do
      let eg = mkGrid "theta" thetaPoints
          ns = mkNamespace ("t" :| [])
          g  = mkGrid "tau" (5 :| [10])
      w64 (chargeBits fragWidth (constChargeA 2 eg))
        @?= w64 (chargeBits fragWidth (constCharge eg))
      w64 (chargeBits fragWidth (walkChargeA 2))
        @?= w64 (chargeBits fragWidth walkCharge)
      w64 (chargeBits fragWidth (guardChargeA 2 ns g eg))
        @?= w64 (chargeBits fragWidth (guardCharge ns g eg))
  ]

-- ---------------------------------------------------------------------
-- g4: the law's shape (masses match Part VII.1's closed form; Cromwell)
-- ---------------------------------------------------------------------

g4Law :: TestTree
g4Law = testGroup "g4 the K-ary emission law"
  [ testCase "g4a masses are (theta at j, spread elsewhere) at K in {3,5,10} (gate 1e-12, floor 5.6e-16)" $
      mapM_ (\k -> do
        let consts = take ((k - 1) * length thetas) (arityPop k)
        mapM_ (\(i, h) -> do
          let j  = 1 + i `div` length thetas
              th = thetas !! (i `mod` length thetas)
          mapM_ (\y -> do
            let want = if y == j then th
                       else (1 - th) / fromIntegral (k - 1)
                got = probOf k h [("t", 0)] y
            assertBool ("K=" ++ show k ++ " j=" ++ show j
                        ++ " theta=" ++ show th ++ " y=" ++ show y
                        ++ ": |" ++ show got ++ " - " ++ show want
                        ++ "| > 1e-12")
                       (abs (got - want) <= 1e-12))
            [0 .. k - 1])
          (zip [0 ..] consts))
        [3, 5, 10]
  , testCase "g4b Cromwell: no atom is refuted a priori (every mass strictly positive)" $
      mapM_ (\k -> do
        let consts = take ((k - 1) * length thetas) (arityPop k)
        mapM_ (\h -> mapM_ (\y ->
                 assertBool "zero mass atom" (probOf k h [("t", 0)] y > 0))
                 [0 .. k - 1])
              consts)
        [3, 5, 10]
  ]

-- ---------------------------------------------------------------------
-- g5: behavior (the W1/W0 paired-worlds pin, HOSTS_PLAN section 4.3's
-- registered shape re-executed against the shipped grammar)
-- ---------------------------------------------------------------------

g5Behavior :: TestTree
g5Behavior = testGroup "g5 concentration vs scatter at K=4"
  [ testCase "g5a a stream concentrated on atom 2 makes MAP the (j=2, theta=0.9) sentence" $ do
      let pop = arityPop 4
          ag  = train (sentenceAgentK (obsSpaceAt 4) pop)
                      (replicate 40 2)
      case posterior ag (length pop) of
        (ix, p) : _ -> do
          -- index 17 under the declared order: consts block, j=2
          -- (second j block), theta=0.9 (last grid point): (2-1)*9+8
          ix @?= 17
          renderExpr (hypEmit (pop !! ix)) @?= g5aRender
          assertBool ("MAP mass " ++ show p ++ " not dominant")
                     (p > 0.5)
          assertBool "MAP emission does not concentrate on atom 2"
                     (probOf 4 (pop !! ix) [("t", 41)] 2 >= 0.85)
        [] -> assertFailure "no posterior entries"
  , testCase "g5b a uniform stream leaves every sentence below 0.125; strict discrimination" $ do
      let pop = arityPop 4
          agU = train (sentenceAgentK (obsSpaceAt 4) pop)
                      (take 40 (cycle [0, 1, 2, 3]))
          agC = train (sentenceAgentK (obsSpaceAt 4) pop)
                      (replicate 40 2)
          topU = case posterior agU (length pop) of
                   (_, p) : _ -> p
                   []         -> 1
          topC = case posterior agC (length pop) of
                   (_, p) : _ -> p
                   []         -> 0
      -- gate derived from measurement (VII.5): the uniform stream's
      -- top mass measures 6.2024...e-2 (deterministic fixture); the
      -- bound is 2x the measurement — any spurious concentration
      -- regression at least doubles the scattered-world MAP before
      -- this fires, while the concentrated world's MAP sits above 0.5
      assertBool ("uniform-stream top mass " ++ show topU ++ " >= 0.125")
                 (topU < 0.125)
      assertBool "no strict discrimination between the paired worlds"
                 (topC > topU)
  ]

-- the g5a render literal: derived from the FROZEN renderExpr executed
-- on the overlay realization at the SAT sitting (pack Part VII.5) —
-- the renderer is the frozen artifact, so this is a copy, not a
-- parallel derivation (R-D20-i). The placeholder below is replaced by
-- the derived string at the SAT sitting, before the freeze seals this
-- file; the red run proves the row red on the stub either way (the
-- enumeration errors before the compare is reached).
g5aRender :: String
g5aRender = "('code', ('neg', ('/', ('log', ('if', ('if', ('>', ('tor', ('var', 0)), ('c', 'atom', 2)), ('>', ('c', 'k', 0), ('c', 'k', 1)), ('if', ('>', ('c', 'atom', 2), ('tor', ('var', 0))), ('>', ('c', 'k', 0), ('c', 'k', 1)), ('>', ('c', 'k', 1), ('c', 'k', 0)))), ('c', 'theta', 8), ('/', ('-', ('c', 'k', 1), ('c', 'theta', 8)), ('c', 'km1', 0)))), ('log', ('c', 'k', 2)))))"

-- ---------------------------------------------------------------------
-- g6: conjugacy as oracle (exact discrete Bayes over the (j, theta)
-- grid vs the engine, K=3, consts only)
-- ---------------------------------------------------------------------

g6ClosedForm :: TestTree
g6ClosedForm = testGroup "g6 the K=3 categorical closed form"
  [ testCase "hand Bayes over (j, theta) matches agentMeta (gate 1e-12, floor 1.1e-16)" $ do
      let pop = enumerateSentencesArity 3 thetaPoints
                  (mkNamespace ("t" :| [])) [] [FBern, FConst]
          n = length pop
      n @?= 2 * length thetas
      let ys = [1, 1, 2, 0, 1] :: [Int]
          ag = train (sentenceAgentK (obsSpaceAt 3) pop) ys
          -- prior read off the enumerated sentences themselves
          -- (R-D20: 2^(-hypBits), the sentenceAgent haddock's law)
          pri = [ 2 ** negate (unBits (hypBits h)) | h <- pop ]
          lik i = let j  = 1 + i `div` length thetas
                      th = thetas !! (i `mod` length thetas)
                  in product [ if y == j then th else (1 - th) / 2
                             | y <- ys ]
          raw = [ p * lik i | (i, p) <- zip [0 ..] pri ]
          z = sum raw
          hand = map (/ z) raw
          got = posterior ag n
      mapM_ (\(ix, p) ->
               assertBool ("index " ++ show ix ++ ": |" ++ show p
                           ++ " - " ++ show (hand !! ix) ++ "| > 1e-12")
                          (abs (p - hand !! ix) <= 1e-12))
            got
  ]

-- ---------------------------------------------------------------------
-- g7: the wire (the key honored, validated, and diagnosed)
-- ---------------------------------------------------------------------

g7Wire :: TestTree
g7Wire = testGroup "g7 the handshake key on the wire"
  [ testCase "g7a obs_arity 4 => models == (K-1) * 1169 == 3507" $
      field "models" (snd (serveLine hostStart
                             (helloLineK (Just "4") ns1 [] [])))
        @?= Just 3507
  , testCase "g7b y=3 is evidence at K=4 (finite loss); y=7 is impossible" $ do
      let (st1, _) = serveLine hostStart (helloLineK (Just "4") ns1 [] [])
          (st2, r1) = serveLine st1 (tickLine [("t", 1)] (Just 3) Nothing)
      case field "loss_bits" r1 of
        Just lb -> assertBool "loss not finite" (not (isNaN lb || isInfinite lb))
        Nothing -> assertFailure ("no loss_bits in " ++ r1)
      let (_, r2) = serveLine st2 (tickLine [("t", 2)] (Just 7) Nothing)
      -- COPY of the error-line format, src/PropLang/Host.hs:195-196
      assertBool ("expected impossible evidence, got " ++ r2)
                 ("impossible evidence" `isPrefixOf` drop (length "{\"error\": \"") r2)
  , testCase "g7c malformed declarations fail closed at the hello (1, 2.5, 1e999)" $
      mapM_ (\bad ->
        assertBool ("obs_arity " ++ bad ++ " accepted")
                   ("bad hello" `isPrefixOf`
                      drop (length "{\"error\": \"")
                           (snd (serveLine hostStart
                                   (helloLineK (Just bad) ns1 [] [])))))
        ["1", "2.5", "1e999"]
  , testCase "g7d the p1 diagnostic is P(atom 1) at the declared codomain" $ do
      let hello = helloLineK (Just "4") ["t", "m"] [] [("m", [0.0])]
          ticks = [ tickLine [("t", fromIntegral i)] (Just y) Nothing
                  | (i, y) <- zip [1 :: Int ..] [1, 2, 1] ]
          (st, _) = runAll hostStart (hello : ticks)
          (_, r) = serveLine st (tickLine [("t", 4)] Nothing (Just ["m"]))
          -- the mirrored agent, library-side: the SAME world — the
          -- wire's namespace is [t, m], and p1 is computed at the
          -- tick's FEATURES, never at feats ++ act (Host.hs tick: the
          -- choice is read from the predictive; the diagnostic is
          -- pre-act). The SAT sitting caught both: a mirror on
          -- namespace [t] repriced every guard mention and diverged
          -- structurally (VII.5)
          pop = enumerateSentencesArity 4 thetaPoints
                  (mkNamespace ("t" :| ["m"])) [] fragFull
          ag = train (sentenceAgentK (obsSpaceAt 4) pop) [1, 2, 1]
          want = prob (predictive [("t", 4)] ag) (is (obsSpaceAt 4) 1)
      case field "p1" r of
        Just p  -> w64 p @?= w64 want
        Nothing -> assertFailure ("no p1 in " ++ r)
  ]

-- ---------------------------------------------------------------------
-- g8: ablation, data form (the family is world-data-gated — the
-- deletable-and-declarable criterion; no production entered the
-- alphabet, so the deletion rows are enumeration restrictions and the
-- key's absence, exactly the test-4 fixture shape)
-- ---------------------------------------------------------------------

g8Ablation :: TestTree
g8Ablation = testGroup "g8 restricted enumeration at K=4"
  [ testCase "no FBern => only walks survive: (K-1) * 8" $
      length (enumerateSentencesArity 4 thetaPoints
                (mkNamespace ("t" :| [])) []
                [ p | p <- fragFull, p /= FBern ])
        @?= 3 * 8
  , testCase "no FGuardHead => consts + walks: (K-1) * 17" $
      length (enumerateSentencesArity 4 thetaPoints
                (mkNamespace ("t" :| [])) []
                [ p | p <- fragFull, p /= FGuardHead ])
        @?= 3 * 17
  , testCase "the key's absence IS the family's deletion (the shipped 1169, g1a's row)" $
      length shipPop @?= 1169
  ]
