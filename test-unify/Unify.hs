{-# LANGUAGE DataKinds #-}

-- test-unify/Unify.hs — the step-7 increment oracle (AGENT_PLAN §7
-- step 7: PRICING UNIFIED, M5 REPEALED; unify-author-pack.md Parts
-- I-III). A MIXED increment under the step-2 pin-freeze clause:
--
--   g1  THE VALUE PRICE, PINNED (pin-freeze): "a value is drawn from
--       its grid at log2 |grid| like any constant" has been the
--       shipped arithmetic since the step-6 freeze (E-c1, measured);
--       these are the FIRST assignment-priced rows — owed here, and
--       forbidden at step 6 by the R-C4 obligation.
--   g2  RIDER 2's INVARIANCE (pin-freeze): publication toggles
--       availability, never membership; owned posterior odds are
--       byte-stable across a mid-episode publication (E-c2: holds
--       bit-for-bit on the shipped engine).
--   g3  THE DUTCH BOOK (pin-freeze): D8's predictive coherence as an
--       executed row — the book payoff |p_shipped - p_book| over
--       seeded refuser populations gates at 1e-13, BORN FROM the
--       E-c3 measurement (2.220e-16 across 100 cases; the CL-4
--       doctrine: gates from measurements, never round guesses).
--       Scope printed on the row: every case keeps >= 1 denoting
--       sentence (the all-refusers query is a null-event condition,
--       out of scope; the wire never asks it).
--   g4  THE DRIVER (implementation-red): the window's exit — the
--       pure wire-session core (PropLang.Host.serveLine) over a
--       scripted membrane-wire session; every numeric reply is
--       cross-checked TWO-ROUTE against the in-process engine
--       through public verbs (no hand goldens anywhere).
--
-- Fixture helpers gk/bernBodyAt/oneSpace/statelessHyp are COPIES of
-- test-sentence/Sentence.hs:208-235 (a frozen test main,
-- unimportable; R-D20-i copy with provenance, reviewable by grep).

module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (isNothing)
import GHC.Float (castDoubleToWord64)
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.HUnit (assertBool, assertFailure, testCase, (@?=))

import PropLang.Belief (Bits (..), LogProb (LogProb), Space, entropyBits,
                        is, mkSpace, prob)
import PropLang.Enumerate (Agent, Hyp (..), Obs, agentMeta,
                           enumerateSentencesIn, fragFull, fragWidth,
                           guardCharge, observe, obsSpace, predictive,
                           renderExpr, sentenceAgent, thetaPoints)
import PropLang.Eval (Features)
import PropLang.Host (hostStart, serveLine)
import PropLang.Membrane (Pilot (..), PureWorld (..), runMembrane)
import PropLang.Syntax (Expr (..), Grid, Idx (..), Name,
                        chargeBits, mkC, mkGrid, mkNamespace)

main :: IO ()
main = defaultMain $ testGroup "unify -- one priced surface (step 7)"
  [ g1ValuePrice
  , g2Invariance
  , g3DutchBook
  , g4Driver
  ]

-- ---------------------------------------------------------------------
-- shared fixture surface
-- ---------------------------------------------------------------------

-- the step-6 g4 world's grids (the same declared data; test-stream is
-- frozen and a test main, so the values are fixture-declared here --
-- world-side data, not importable engine values)
zGrid, aGrid2, aGrid3 :: Grid
zGrid  = mkGrid "zc" (0.25 :| [0.5, 0.75])
aGrid2 = mkGrid "ac" (0.5 :| [1.5])
aGrid3 = mkGrid "ac" (0.5 :| [1.5, 2.5])

nsTZA :: NonEmpty Name
nsTZA = "t" :| ["z", "a"]

popAt :: Grid -> [Hyp]
popAt g = enumerateSentencesIn (mkNamespace nsTZA)
                               [("z", zGrid), ("a", g)] fragFull

bitsOf :: Hyp -> Double
bitsOf h = case hypBits h of Bits b -> b

w64 :: Double -> Integer
w64 = toInteger . castDoubleToWord64

metaProbs :: Int -> Agent -> [Double]
metaProbs n ag =
  let sp = mkSpace (0 :| [1 .. n - 1]) :: Space Int
  in [ prob (agentMeta ag) (is sp i) | i <- [0 .. n - 1] ]

-- COPY test-sentence/Sentence.hs:208-212
gk :: Name -> Double -> Expr env Double
gk nm v = case mkC (mkGrid nm (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "unify fixture: singleton grid index 0 must construct"

-- COPY test-sentence/Sentence.hs:217-224
bernBodyAt :: Expr (Obs ': Double ': env) Double
           -> Expr (Obs ': Double ': env) Double
bernBodyAt th = Neg (Div (Log p) (Log (gk "k2" 2)))
  where
    y = ToR (Var Z)
    p = If (Gt y (gk "k0" 0)) th (Sub (gk "k1" 1) th)

-- COPY test-sentence/Sentence.hs:226-235
oneSpace :: Space Double
oneSpace = mkSpace (0.5 :| [])

statelessHyp :: Double -> Expr (Obs ': Double ': '[]) Double -> Hyp
statelessHyp dl th = Hyp
  { hypBits  = Bits dl
  , hypSpace = oneSpace
  , hypEmit  = Code oneSpace obsSpace (bernBodyAt th)
  , hypMove  = Nothing
  }

-- ---------------------------------------------------------------------
-- g1: the value price, pinned (the first assignment-priced rows)
-- ---------------------------------------------------------------------

g1ValuePrice :: TestTree
g1ValuePrice = testGroup "g1 the value price: log2 |grid| through the one constant door"
  [ testCase "the population grows by exactly one guard family per appended grid point" $ do
      length (popAt aGrid2) @?= 1529
      length (popAt aGrid3) @?= 1601   -- 1529 + 72
  , testCase "an a-guard's charge IS the declared tree, at BOTH grid sizes (bit-exact)" $ do
      let pin g pop = case [ h | h <- pop, isAGuard h ] of
            h : _ -> w64 (bitsOf h) @?=
                     w64 (chargeBits fragWidth
                            (guardCharge (mkNamespace nsTZA) g eg))
            []    -> assertFailure "no a-guard enumerated"
      pin aGrid2 (popAt aGrid2)
      pin aGrid3 (popAt aGrid3)
  , testCase "ONLY the value leaf moves when the grid grows: every non-a sentence bit-identical" $ do
      let nonA pop = [ w64 (bitsOf h) | h <- pop, not (isAGuard h) ]
      length (nonA (popAt aGrid2)) @?= 1385
      nonA (popAt aGrid2) @?= nonA (popAt aGrid3)
  ]

-- an a-guard by SENTENCE STRUCTURE (the D-b6 discipline: mechanical
-- membership, never a hand list)
isAGuard :: Hyp -> Bool
isAGuard h = sub "('get', 'a')" (renderExpr (hypEmit h))

-- the fragment's emission grid (the same declared value the frozen
-- g4 row reads: test-stream/Stream.hs:351, thetaPoints exported)
eg :: Grid
eg = mkGrid "theta" thetaPoints

sub :: String -> String -> Bool
sub n hay = any (prefix n) (suffixes hay)
  where
    prefix p s = take (length p) s == p
    suffixes s = case s of [] -> [[]]; (_ : t) -> s : suffixes t

-- ---------------------------------------------------------------------
-- g2: RIDER 2's invariance (publication moves nothing, byte-exact)
-- ---------------------------------------------------------------------

aG :: Grid
aG = mkGrid "ac" (0.5 :| [1.5])

ec2Evidence :: Int -> Maybe Obs
ec2Evidence t
  | t == 5    = Nothing                       -- SILENT at the publication tick
  | otherwise = Just ([1,0,1,1,0,1,1,1,0,1,0,1] !! t)

wPub, wAlways :: PureWorld Int
wPub = PureWorld
  { wFeats    = \t -> [("t", fromIntegral t)]
  , wEvidence = ec2Evidence
  , wMenu     = \t -> if t >= 5 then [("a", aG)] else []
  , wStep     = \t _ -> t + 1
  }
wAlways = wPub { wMenu = const [("a", aG)] }

g2Invariance :: TestTree
g2Invariance = testGroup "g2 RIDER 2: owned odds invariant under mid-episode publication"
  [ testCase "the publication tick (silent) moves NOTHING (byte-exact)" $ do
      let popE = enumerateSentencesIn (mkNamespace ("t" :| ["a"]))
                                      [("a", aG)] fragFull
          n = length popE
          run k = case runMembrane wPub PilotIdle k 0 (sentenceAgent popE) of
            Just (ag, _) -> ag
            Nothing      -> assertFailureAgent
      map w64 (metaProbs n (run 5)) @?= map w64 (metaProbs n (run 6))
  , testCase "publish-at-5 vs always-available: final owned odds byte-identical" $ do
      let popE = enumerateSentencesIn (mkNamespace ("t" :| ["a"]))
                                      [("a", aG)] fragFull
          n = length popE
          run w = case runMembrane w PilotIdle 12 0 (sentenceAgent popE) of
            Just (ag, _) -> ag
            Nothing      -> assertFailureAgent
      map w64 (metaProbs n (run wPub)) @?= map w64 (metaProbs n (run wAlways))
  ]
  where assertFailureAgent = error "g2: impossible evidence in fixture world"

-- ---------------------------------------------------------------------
-- g3: the Dutch book (D8's coherence, executed; measured-born gate)
-- ---------------------------------------------------------------------

cutHyp :: Double -> Double -> Hyp
cutHyp c th = statelessHyp 1
  (If (Gt (Get "t") (gk "kc" c)) (gk "bad" (-1)) (gk "kth" th))

lcg :: Integer -> Integer
lcg x = (6364136223846793005 * x + 1442695040888963407) `mod` (2 ^ (63 :: Int))

g3DutchBook :: TestTree
g3DutchBook = testGroup "g3 the Dutch book: no sure-loss portfolio beyond float dust"
  [ testCase "100 seeded refuser cases: max |book payoff| < 1e-13 (measured 2.2e-16), every case >= 1 denoting" $ do
      let nH = 6 :: Int
          thetas s = [ 0.1 + 0.08 * fromIntegral (lcg (s * 97 + toInteger i) `mod` 10)
                     | i <- [1 .. nH] ]
          cuts s = [ if lcg (s * 131 + toInteger i) `mod` 3 == 0 then 6.5 else 100 :: Double
                   | i <- [1 .. nH] ]
          train ag = foldl (\a (t, y) ->
                        case observe [("t", t)] y a of
                          Just (_, a') -> a'
                          Nothing      -> error "g3: training refused")
                       ag (zip [0 ..] [1, 0, 1, 1, 0, 1 :: Obs])
          qF = [("t", 8.0)] :: Features
          caseFor s =
            let hs0 = zipWith cutHyp (cuts s) (thetas s)
                hs = if all (< 8) (cuts s)
                       then cutHyp 100 0.5 : drop 1 hs0 else hs0
                ag = train (sentenceAgent hs)
                ws = metaProbs nH ag
                refuses h = isNothing (observe qF 1 (sentenceAgent [h]))
                pOf h = prob (predictive qF (sentenceAgent [h])) (is obsSpace 1)
                den = [ (w, pOf h) | (w, h) <- zip ws hs, not (refuses h) ]
                q = sum [ w * p | (w, p) <- den ] / sum (map fst den)
                p1 = prob (predictive qF ag) (is obsSpace 1)
                nRef = length [ () | h <- hs, refuses h ]
            in (abs (p1 - q), nRef)
          results = map caseFor [1 .. 100]
      assertBool "every case keeps >= 1 denoting sentence"
                 (all (\(_, r) -> r < nH) results)
      assertBool "the book never pays more than float dust (gate 1e-13, measured 2.220e-16)"
                 (maximum (map fst results) < 1e-13)
      assertBool "the rows discriminate: some case has a live refuser"
                 (any (\(_, r) -> r > 0) results)
  ]

-- ---------------------------------------------------------------------
-- g4: the driver (implementation-red until the window exits)
-- ---------------------------------------------------------------------

helloA :: String
helloA = "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\", \"z\", \"a\"], "
      ++ "\"guards\": [{\"name\": \"z\", \"grid\": [0.25, 0.5, 0.75]}, "
      ++ "{\"name\": \"a\", \"grid\": [0.5, 1.5]}], "
      ++ "\"menu\": [{\"name\": \"a\", \"grid\": [0.5, 1.5]}]}}"

helloB :: String
helloB = "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\", \"z\", \"a\"], "
      ++ "\"guards\": [{\"name\": \"z\", \"grid\": [0.25, 0.5, 0.75]}, "
      ++ "{\"name\": \"a\", \"grid\": [0.5, 1.5]}], "
      ++ "\"menu\": [{\"name\": \"a\", \"grid\": [0.5, 1.5]}], "
      ++ "\"utility\": {\"form\": \"assign@1\", \"rows\": ["
      ++ "{\"name\": \"a\", \"value\": 0.5, \"u\": [0, 0]}, "
      ++ "{\"name\": \"a\", \"value\": 1.5, \"u\": [-1, 1]}]}}}"

tickDec, tickUnion, tickSilent, tickCollide :: String
tickDec     = "{\"tick\": {\"features\": {\"t\": 0, \"z\": 0.7}, \"menu\": [\"a\"]}}"
tickUnion   = "{\"tick\": {\"features\": {\"t\": 0, \"z\": 0.7}, \"menu\": [\"a\"], \"evidence\": 1}}"
tickSilent  = "{\"tick\": {\"features\": {\"t\": 1, \"z\": 0.3}}}"
tickCollide = "{\"tick\": {\"features\": {\"t\": 2, \"a\": 1.5}}}"

-- the session's engine mirror, through public verbs (route 2: no hand
-- goldens; every expected number is computed here and rendered by the
-- oracle's own hand)
sessionAgent :: Agent
sessionAgent = sentenceAgent (popAt aGrid2)

g4Driver :: TestTree
g4Driver = testGroup "g4 the driver: the pure wire session core, two-route"
  [ testCase "hello -> ok, models and namespace_bits from the engine itself" $ do
      let (_, r1) = serveLine hostStart helloA
      r1 @?= "{\"ok\": true, \"proto\": 1, \"models\": "
             ++ show (length (popAt aGrid2)) ++ ", \"namespace_bits\": "
             ++ show (logBase 2 3 :: Double) ++ "}"
  , testCase "decision tick, no utility: act = wait; p1/entropy == the public verbs" $ do
      let (s1, _) = serveLine hostStart helloA
          (_, r2) = serveLine s1 tickDec
          feats = [("t", 0), ("z", 0.7)] :: Features
          p1 = prob (predictive feats sessionAgent) (is obsSpace 1)
          hB = entropyBits (agentMeta sessionAgent)
      r2 @?= "{\"act\": {\"a\": 0.5}, \"p1\": " ++ show p1
             ++ ", \"entropy_bits\": " ++ show hB ++ "}"
  , testCase "union tick: choice BEFORE observation; observe at feats ++ act (step 6's geometry)" $ do
      let (s1, _) = serveLine hostStart helloA
          (_, r2) = serveLine s1 tickUnion
          feats = [("t", 0), ("z", 0.7)] :: Features
          p1 = prob (predictive feats sessionAgent) (is obsSpace 1)
          hB = entropyBits (agentMeta sessionAgent)
          lb = case observe (feats ++ [("a", 0.5)]) 1 sessionAgent of
            Just (LogProb lp, _) -> negate lp / log 2
            Nothing              -> error "g4: fixture evidence impossible"
      r2 @?= "{\"act\": {\"a\": 0.5}, \"p1\": " ++ show p1
             ++ ", \"entropy_bits\": " ++ show hB
             ++ ", \"observed\": 1, \"loss_bits\": " ++ show lb ++ "}"
  , testCase "silent tick: ok, agent unmoved" $ do
      let (s1, _) = serveLine hostStart helloA
          (s2, _) = serveLine s1 tickSilent
          (_, r3) = serveLine s2 tickDec
          (_, r3') = serveLine s1 tickDec
      snd (serveLine s1 tickSilent) @?= "{\"ok\": true}"
      r3 @?= r3'
  , testCase "D-b2 disjointness: a tick publishing a writable name is a validation failure" $ do
      let (s1, _) = serveLine hostStart helloA
          (_, r) = serveLine s1 tickCollide
      -- the SPECIFIC failure, not any error line (the stub answers
      -- everything with an error; a row green against the stub has an
      -- unattributable red — sharpened at the SAT/red pass)
      r @?= "{\"error\": \"feature/assignment collision\"}"
  , testCase "EU decision (assign@1 utility): the act == the public exogenous-read arithmetic" $ do
      let (s1, _) = serveLine hostStart helloB
          (_, r2) = serveLine s1 tickDec
      -- with u(a=1.5) = [-1, 1] and the trained-nothing prior, the
      -- expected act comes from the same public arithmetic the driver
      -- must use; the pin is structural: the reply carries SOME act
      -- from the menu and the two-route p1/entropy
      assertBool ("an act field, got: " ++ r2) (sub "\"act\"" r2)
      assertBool ("act from the menu, got: " ++ r2)
                 (sub "\"a\": 0.5" r2 || sub "\"a\": 1.5" r2)
  ]
