-- test-said/Said.hs — the W4 oracle: wire completeness for said@1
-- (WIRE_PLAN §3 W4 (a)+(b) as ruled; (c) STRUCK by R-W2).
--
-- Design of record: wire-author-pack.md Part VIII (survey VIII.2,
-- design VIII.3, the OB-8 narrowing VIII.4, measurement VIII.5).
-- (a) parseSaid extends to the full priced grammar: "/" -> Div,
--     "log" -> Log, "exp" -> Exp, "neg" -> Neg. Nothing else: "<"
--     composes as swapped ">" (a SUCCESSFUL composition, so the
--     primitivity gate's mirror forbids the codeword), unknown forms
--     keep refusing (fail-closed).
-- (b) the OPTIONAL "cgrid" key in the utility block (the W3 routing
--     shape, forced by test-outcome g4's byte-pin — survey row 3):
--     ABSENT = the shipped path byte-identically (fresh singleton
--     constants, no bits in the reply); DECLARED = every ["c", v]
--     must sit ON the grid (fail-closed), NaN/inf points bad hello
--     (D-f8), and the hello reply gains "utility_bits": bitsIn nsN
--     program — the frozen arithmetic end to end (R-D20: this oracle
--     prices by CALLING the frozen bitsIn on mirror expressions,
--     never by re-deriving the arithmetic).
--
-- Red/green partition (oracle phase, against the shipped W3 host —
-- no stubs: the red IS the shipped wire refusing/under-answering):
--   RED   g1a-1..4 (new forms refuse), g1b (composite behavior),
--         g2a (utility_bits missing), g2c (singleton cgrid route),
--         g2d (the Sub-wrap pricing delta), g3a-d (the cgrid door
--         is not yet a door), g4 (log-utility EU)
--   GREEN g1c (unknown form refuses — must SURVIVE the extension),
--         g1d-i ("<" refuses — the no-new-form pin), g1d-ii (the
--         swapped-Gt composition says less-than TODAY), g2b (the
--         absent-key route byte-equal the shipped reply — the
--         optimisation-law re-pin)
--
-- R-D20 copy table (byte-wise copies, reviewable by grep):
--   world fixture (ns/guards/menu)  <- test-outcome/Outcome.hs:216-222
--   hello-reply expected literal    <- test-outcome/Outcome.hs:238-240
--   two-route EU act arithmetic     <- test-outcome/Outcome.hs:241-253
--   uAt (the retired bridge's copy) <- test-outcome/Outcome.hs:63-64
--   w64                             <- test-outcome/Outcome.hs:84-85
--   measured operator increments    <- wire-author-pack.md VIII.5
-- Gates: g2d's |delta - (log2 20 + log2 3)| gate is 1e-12, derived
-- from the VIII.5 measurement (subtraction-level fp divergence
-- observed at the last ulp, ~9e-16); floor re-measured at SAT.
--
-- Test names ASCII-only (the membrane locale incident).
{-# LANGUAGE DataKinds #-}
module Main (main) where

import Data.List (isInfixOf, isPrefixOf, tails)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.HUnit (assertBool, assertFailure, testCase, (@?=))

import PropLang.Belief (Bits (..), expect)
import PropLang.Enumerate (Agent, enumerateSentencesIn, fragFull,
                           predictive, sentenceAgent)
import PropLang.Eval (Features, Vals (..), evalx, mkEnv)
import PropLang.Host (hostStart, serveLine)
import PropLang.Syntax (Expr (..), Grid, Idx (..), Namespace, bitsIn,
                        mkC, mkGrid, mkNamespace)

-- uAt: a copy of the retired bridge (R-D20-i; provenance
-- test-outcome/Outcome.hs:63-64, itself the copy of the deleted
-- Eval.uAt).
uAt :: Features -> Expr '[Double, Double] Double -> Double -> Double -> Double
uAt fs u a y = evalx u (mkEnv fs (a :. y :. VNil))

main :: IO ()
main = defaultMain $ testGroup "said -- wire completeness (W4: the full priced grammar, priced on the wire)"
  [ g1Parse
  , g2Pricing
  , g3Door
  , g4Behavior
  ]

-- ---------------------------------------------------------------------
-- shared fixture surface (the outcome-g4 world, copied)
-- ---------------------------------------------------------------------

-- world fixture copied from test-outcome/Outcome.hs:216-222 (R-D20)
worldHead :: String
worldHead = "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\", \"z\", \"a\"], "
    ++ "\"guards\": [{\"name\": \"z\", \"grid\": [0.25, 0.5, 0.75]}, "
    ++ "{\"name\": \"a\", \"grid\": [0.5, 1.5]}], "
    ++ "\"menu\": [{\"name\": \"a\", \"grid\": [0.5, 1.5]}], "

helloWith :: String -> String
helloWith ublock = worldHead ++ "\"utility\": " ++ ublock ++ "}}"

zG, aG :: Grid
zG = mkGrid "zc" (0.25 :| [0.5, 0.75])
aG = mkGrid "ac" (0.5 :| [1.5])

pop3 :: Int
pop3 = length (enumerateSentencesIn (mkNamespace ("t" :| ["z", "a"]))
                                    [("z", zG), ("a", aG)] fragFull)

ag3 :: Agent
ag3 = sentenceAgent (enumerateSentencesIn (mkNamespace ("t" :| ["z", "a"]))
                                          [("z", zG), ("a", aG)] fragFull)

-- the shipped reply for this world (copied literal construction,
-- test-outcome/Outcome.hs:238-240)
shippedReply :: String
shippedReply = "{\"ok\": true, \"proto\": 1, \"models\": "
    ++ show pop3 ++ ", \"namespace_bits\": "
    ++ show (logBase 2 3 :: Double) ++ "}"

-- the priced-route reply: the shipped shape + the utility_bits key
-- (design VIII.3: appended last; the number is the frozen bitsIn's)
pricedReply :: Double -> String
pricedReply ub = "{\"ok\": true, \"proto\": 1, \"models\": "
    ++ show pop3 ++ ", \"namespace_bits\": "
    ++ show (logBase 2 3 :: Double) ++ ", \"utility_bits\": "
    ++ show ub ++ "}"

tickDec :: String
tickDec = "{\"tick\": {\"features\": {\"t\": 0, \"z\": 0.7}, \"menu\": [\"a\"]}}"

ns3 :: Namespace
ns3 = mkNamespace ("t" :| ["z", "a"])

-- field: reply-field reader (R-D20 copy, test-measure/Measure.hs:75-116
-- via test-arity/Arity.hs:134-140)
field :: String -> String -> Maybe Double
field k s =
  case [ drop (length pat) t | t <- tails s, pat `isPrefixOf` t ] of
    rest : _ -> Just (read (takeWhile (`notElem` ",}") rest))
    []       -> Nothing
  where pat = "\"" ++ k ++ "\": "

cg :: Grid
cg = mkGrid "u" (0 :| [1, 2])

cAt :: Grid -> Int -> Expr env Double
cAt g i = case mkC g i of
  Just e  -> e
  Nothing -> error "said fixture: on-grid index must construct"

unB :: Bits -> Double
unB (Bits b) = b

okPrefix :: String -> Bool
okPrefix = ("{\"ok\": true" `isPrefixOf`)

badHello :: String
badHello = "{\"error\": \"bad hello\"}"

actField :: String -> String -> Bool
actField v r = ("\"act\": {\"a\": " ++ v ++ "}") `isInfixOf` r

-- ---------------------------------------------------------------------
-- g1: the parse extension (a); the no-new-form pins
-- ---------------------------------------------------------------------

g1Parse :: TestTree
g1Parse = testGroup "g1 the parse extension: the full priced grammar reaches the wire"
  [ testCase "g1a-1 a division parses: [\"/\", var1, c2] hello is ok" $ do
      let (_, r) = serveLine hostStart
            (helloWith "{\"form\": \"said@1\", \"said\": [\"/\", [\"var\", 1], [\"c\", 2]]}")
      assertBool ("ok reply, got: " ++ r) (okPrefix r)
  , testCase "g1a-2 a log parses: [\"log\", [\"exp\", var1]] hello is ok" $ do
      let (_, r) = serveLine hostStart
            (helloWith "{\"form\": \"said@1\", \"said\": [\"log\", [\"exp\", [\"var\", 1]]]}")
      assertBool ("ok reply, got: " ++ r) (okPrefix r)
  , testCase "g1a-3 an exp parses: [\"exp\", var0] hello is ok" $ do
      let (_, r) = serveLine hostStart
            (helloWith "{\"form\": \"said@1\", \"said\": [\"exp\", [\"var\", 0]]}")
      assertBool ("ok reply, got: " ++ r) (okPrefix r)
  , testCase "g1a-4 a neg parses: [\"neg\", var1] hello is ok" $ do
      let (_, r) = serveLine hostStart
            (helloWith "{\"form\": \"said@1\", \"said\": [\"neg\", [\"var\", 1]]}")
      assertBool ("ok reply, got: " ++ r) (okPrefix r)
  , testCase "g1b the composite -log-scored utility decides like the public arithmetic (two-route)" $ do
      -- u = neg(log(exp(y)) / c2) = -y/2: all four new forms in one
      -- program; the act must match the mirror EU (arithmetic copied
      -- from test-outcome/Outcome.hs:241-253)
      let (s1, _) = serveLine hostStart
            (helloWith ("{\"form\": \"said@1\", \"said\": [\"neg\", [\"/\", "
                        ++ "[\"log\", [\"exp\", [\"var\", 1]]], [\"c\", 2]]]}"))
          (_, r) = serveLine s1 tickDec
          uMir = Neg (Div (Log (Exp (Var (S Z)))) (cAt (mkGrid "k" (2 :| [])) 0))
                   :: Expr '[Double, Double] Double
          feats = [("t", 0), ("z", 0.7)] :: Features
          euA a = expect (predictive (feats ++ a) ag3)
                         (\y -> uAt (feats ++ a) uMir 0 (fromIntegral y))
          expected = if euA [("a", 1.5)] > euA [("a", 0.5)]
                       then "1.5" else "0.5"
      assertBool ("act matches the public arithmetic, got: " ++ r)
                 (actField expected r)
  , testCase "g1c an unknown form still FAILS CLOSED: [\"sqrt\", var1] is a bad hello" $ do
      let (_, r) = serveLine hostStart
            (helloWith "{\"form\": \"said@1\", \"said\": [\"sqrt\", [\"var\", 1]]}")
      r @?= badHello
  , testCase "g1d-i the less-than codeword does NOT exist: [\"<\", a, b] is a bad hello" $ do
      -- the primitivity gate's mirror: a successful composition
      -- forbids the codeword; this pin must SURVIVE the extension
      let (_, r) = serveLine hostStart
            (helloWith ("{\"form\": \"said@1\", \"said\": [\"if\", [\"<\", [\"var\", 1], [\"c\", 1]], "
                        ++ "[\"c\", 1], [\"c\", 0]]}"))
      r @?= badHello
  , testCase "g1d-ii less-than is SAID by the swap TODAY: [\">\", c1, var1] decides as the mirror y<1 utility" $ do
      let (s1, _) = serveLine hostStart
            (helloWith ("{\"form\": \"said@1\", \"said\": [\"if\", [\">\", [\"c\", 1], [\"var\", 1]], "
                        ++ "[\"c\", 1], [\"c\", 0]]}"))
          (_, r) = serveLine s1 tickDec
          one = cAt (mkGrid "k" (1 :| [])) 0
          zero = cAt (mkGrid "k" (0 :| [])) 0
          uMir = If (Gt one (Var (S Z))) one zero
                   :: Expr '[Double, Double] Double
          feats = [("t", 0), ("z", 0.7)] :: Features
          euA a = expect (predictive (feats ++ a) ag3)
                         (\y -> uAt (feats ++ a) uMir 0 (fromIntegral y))
          expected = if euA [("a", 1.5)] > euA [("a", 0.5)]
                       then "1.5" else "0.5"
      assertBool ("act matches the swapped-Gt mirror, got: " ++ r)
                 (actField expected r)
  ]

-- ---------------------------------------------------------------------
-- g2: the pricing route (b); the absent-key re-pin
-- ---------------------------------------------------------------------

-- the measured program (VIII.5): if (get a > c1) then c2*y - c1 else c0
progMeasuredJson :: String
progMeasuredJson = "[\"if\", [\">\", [\"get\", \"a\"], [\"c\", 1]], "
    ++ "[\"-\", [\"*\", [\"c\", 2], [\"var\", 1]], [\"c\", 1]], [\"c\", 0]]"

progMeasured :: Expr '[Double, Double] Double
progMeasured = If (Gt (Get "a") (cAt cg 1))
                  (Sub (Mul (cAt cg 2) (Var (S Z))) (cAt cg 1))
                  (cAt cg 0)

g2Pricing :: TestTree
g2Pricing = testGroup "g2 the pricing route: the declared cgrid prices through the one arithmetic"
  [ testCase "g2a the priced hello reply carries utility_bits == the frozen bitsIn (byte-pinned)" $ do
      let (_, r) = serveLine hostStart
            (helloWith ("{\"form\": \"said@1\", \"cgrid\": [0, 1, 2], \"said\": "
                        ++ progMeasuredJson ++ "}"))
      r @?= pricedReply (unB (bitsIn ns3 progMeasured))
  , testCase "g2b the ABSENT key is the shipped reply, byte-equal (the optimisation-law re-pin)" $ do
      let (_, r) = serveLine hostStart
            (helloWith ("{\"form\": \"said@1\", \"said\": " ++ progMeasuredJson ++ "}"))
      r @?= shippedReply
  , testCase "g2c a singleton cgrid prices 0-bit constants and decides byte-equal the absent route" $ do
      let cg1 = mkGrid "u" (0.2 :| [])
          uMir = Sub (Var (S Z)) (Mul (cAt cg1 0) (Get "a"))
                   :: Expr '[Double, Double] Double
          said = "[\"-\", [\"var\", 1], [\"*\", [\"c\", 0.2], [\"get\", \"a\"]]]"
          (sP, rP) = serveLine hostStart
            (helloWith ("{\"form\": \"said@1\", \"cgrid\": [0.2], \"said\": " ++ said ++ "}"))
          (sA, _) = serveLine hostStart
            (helloWith ("{\"form\": \"said@1\", \"said\": " ++ said ++ "}"))
          (_, tP) = serveLine sP tickDec
          (_, tA) = serveLine sA tickDec
      rP @?= pricedReply (unB (bitsIn ns3 uMir))
      tP @?= tA
  , testCase "g2d the Sub-wrap delta == 2 x log2 20 + log2 3 (gate 1e-12, floor measured at SAT)" $ do
      let ub s = do
            let (_, r) = serveLine hostStart
                  (helloWith ("{\"form\": \"said@1\", \"cgrid\": [0, 1, 2], \"said\": " ++ s ++ "}"))
            case field "utility_bits" r of
              Just v  -> pure v
              Nothing -> assertFailure ("utility_bits present, got: " ++ r)
      b0 <- ub "[\"var\", 1]"
      b1 <- ub "[\"-\", [\"c\", 0], [\"var\", 1]]"
      -- the wrap adds the Sub node head (log2 20) AND the constant's
      -- whole price: its own node head (log2 20) plus its content on
      -- the 3-point cgrid (log2 3) — the VIII.5 Div-increment row's
      -- shape (10.228818690495881 measured, = log2 20 + the operand's
      -- full bits); the first draft forgot the constant's node head
      -- and the SAT run convicted it (repaired in-window)
      let expectedDelta = 2 * logBase 2 20 + logBase 2 3
      assertBool ("delta " ++ show (b1 - b0) ++ " vs " ++ show expectedDelta)
                 (abs ((b1 - b0) - expectedDelta) < 1e-12)
  ]

-- ---------------------------------------------------------------------
-- g3: the door (fail-closed at the declaration, D-f8)
-- ---------------------------------------------------------------------

g3Door :: TestTree
g3Door = testGroup "g3 the cgrid door: validation at the HELLO, fail-closed"
  [ testCase "g3a an off-grid constant FAILS CLOSED: c 0.3 against cgrid [0,1,2]" $ do
      let (_, r) = serveLine hostStart
            (helloWith "{\"form\": \"said@1\", \"cgrid\": [0, 1, 2], \"said\": [\"c\", 0.3]}")
      r @?= badHello
  , testCase "g3b a non-finite cgrid point FAILS CLOSED AT DECLARATION (D-f8): [0.5, 1e999]" $ do
      let (_, r) = serveLine hostStart
            (helloWith "{\"form\": \"said@1\", \"cgrid\": [0.5, 1e999], \"said\": [\"c\", 0.5]}")
      r @?= badHello
  , testCase "g3c an empty cgrid FAILS CLOSED: []" $ do
      let (_, r) = serveLine hostStart
            (helloWith "{\"form\": \"said@1\", \"cgrid\": [], \"said\": [\"var\", 1]}")
      r @?= badHello
  , testCase "g3d a constant-free program under a declared cgrid prices lawfully" $ do
      let (_, r) = serveLine hostStart
            (helloWith "{\"form\": \"said@1\", \"cgrid\": [0, 1, 2], \"said\": [\"var\", 1]}")
      r @?= pricedReply (unB (bitsIn ns3 (Var (S Z) :: Expr '[Double, Double] Double)))
  ]

-- ---------------------------------------------------------------------
-- g4: behavior through the extended grammar (two-route)
-- ---------------------------------------------------------------------

g4Behavior :: TestTree
g4Behavior = testGroup "g4 behavior: a log-shaped utility routes through EU like the public verbs"
  [ testCase "g4a the priced log-utility's act == the mirror EU argmax (first-listed keeps ties)" $ do
      -- u = log(exp(y) + c1): monotone in y, safe at y in {0, 1}
      let (s1, _) = serveLine hostStart
            (helloWith ("{\"form\": \"said@1\", \"cgrid\": [0, 1, 2], \"said\": "
                        ++ "[\"log\", [\"+\", [\"exp\", [\"var\", 1]], [\"c\", 1]]]}"))
          (_, r) = serveLine s1 tickDec
          uMir = Log (Add (Exp (Var (S Z))) (cAt cg 1))
                   :: Expr '[Double, Double] Double
          feats = [("t", 0), ("z", 0.7)] :: Features
          euA a = expect (predictive (feats ++ a) ag3)
                         (\y -> uAt (feats ++ a) uMir 0 (fromIntegral y))
          expected = if euA [("a", 1.5)] > euA [("a", 0.5)]
                       then "1.5" else "0.5"
      assertBool ("act matches the public arithmetic, got: " ++ r)
                 (actField expected r)
  ]
