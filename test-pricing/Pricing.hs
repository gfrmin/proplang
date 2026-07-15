{-# LANGUAGE DataKinds #-}

-- | test-pricing/Pricing.hs — step 4's increment oracle (AGENT_PLAN §7
-- step 4: ONE PRICING MECHANISM, TWO DECLARED TABLES; pricing-author-
-- pack Parts I–II). Drafted under the author's standing pacing order
-- (2026-07-15, "dont wait for my word, unless you need my key"):
-- runtime-red against the step-4 type-surface stubs until the
-- implementation lands after the author's freeze; the register (pack
-- §4) goes to the author with its evidence executed, and nothing here
-- binds before his tag.
--
-- THE STEP: the model fragment's charge arithmetic leaves the
-- enumerator's ad-hoc where-bindings and becomes DECLARED CHARGE
-- TREES ('Charge' — the tree's shape IS the float order, the
-- E-s1/test-code doctrine) priced by THE MECHANISM ('chargeBits', the
-- one definition in src that turns declared widths into bits); under
-- register D-p1's recommended arm (B) the policy pricer routes
-- through the same mechanism over mirrored trees. NO price moves: the
-- step is structural, the alphabet delta is NONE, and every existing
-- frozen pin is the extensional gate (they all stay green through the
-- refactor — the suites are the ==).
--
-- GATE PROVENANCE (E-p1, executed 2026-07-15 BEFORE any row froze —
-- the evidence-programs-before-rulings line): the mechanism
-- reproduces BOTH fragments bit-for-bit — 15,790 charges (all three
-- populations' dl through mirrored trees; every emission and move
-- code under `bits` and under `bitsIn` at 2- and 3-name namespaces; a
-- hand corpus covering every priced constructor), ZERO bit-mismatches
-- (`ep1-transcript.txt`). == is therefore the gate on every identity
-- row below; no tolerance is owed anywhere in this suite.
--
-- THE ASSOCIATION FACT, stated honestly (the assoc probe, same date):
-- at TODAY'S leaf values the fragments' tree shapes coincide with
-- refolds bit-for-bit (measured 6/6 — every sort width is exactly one
-- bit and lg 16 = 4, so the prefixes are dyadic), while 204 of 1331
-- corpus-value triples DO move a bit under re-association. The
-- tree-as-data mechanism is chosen so correctness never depends on
-- that dyadic coincidence; the doctrine row below pins a measured
-- one-ulp example.
--
-- Every pinned hex carries provenance (R-D20-i): the ns0 dl hexes are
-- COPIES of the frozen test-sentence/Sentence.hs:250-253 pins; the
-- namespace-variant hexes were captured from the shipped enumerator
-- at 9d348eb (capture-transcript.txt), whose populations the frozen
-- g1/M1 rows pin; the doctrine hexes are the assoc probe's. Every
-- runtime-red row's asserted quantity has an executed R-D21
-- satisfiability line against the step-4 prototype overlay. Test
-- names are ASCII-only.
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Word (Word64)
import GHC.Float (castDoubleToWord64)
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief (Bits (..))
import PropLang.Enumerate (FragSort (..), Hyp (..), constCharge,
                           enumerateSentencesIn, fragFull, fragWidth,
                           guardCharge, tauPoints, thetaPoints, walkCharge)
import PropLang.Syntax (Charge (..), Grid, Namespace, ProdTable (..),
                        chargeBits, gridSize, mkGrid, mkNamespace,
                        prodTable)

main :: IO ()
main = defaultMain $ testGroup "pricing — one mechanism, two declared tables"
  [ g1Mechanism
  , g2Trees
  , g3Wiring
  , g4Tables
  ]

lg :: Double -> Double
lg = logBase 2

assertHexEq :: String -> Word64 -> Double -> Assertion
assertHexEq msg w actual =
  assertEqual (msg ++ " (bit)") w (castDoubleToWord64 actual)

-- the built-in grids, through the exported points (R-D20-i: the frozen
-- artifact itself supplies the values; nothing copied, nothing drifts)
thetaG, tauG :: Grid
thetaG = mkGrid "theta" thetaPoints
tauG   = mkGrid "tau" tauPoints

ns0, nsA, nsC :: Namespace
ns0 = mkNamespace ("t" :| [])
nsA = mkNamespace ("t" :| ["s2"])
nsC = mkNamespace ("t" :| ["z", "last_action"])

s2Grid, zGrid, laGrid :: Grid
s2Grid = mkGrid "s2c" (0.5 :| [])
zGrid  = mkGrid "zc" (0.25 :| [0.5, 0.75])
laGrid = mkGrid "lac" (0.5 :| [1.5])

-- ---------------------------------------------------------------------
-- g1: the mechanism's contract
-- ---------------------------------------------------------------------

g1Mechanism :: TestTree
g1Mechanism = testGroup "g1 chargeBits: the one width-to-bits evaluator"
  [ testCase "CW reads the declared table (all four fragment sorts)" $ do
      -- widths {2,2,2,1}: lg 2 = 1 and lg 1 = 0, both exact
      chargeBits fragWidth (CW MODEL) @?= 1
      chargeBits fragWidth (CW THETA) @?= 1
      chargeBits fragWidth (CW HEAD)  @?= 1
      chargeBits fragWidth (CW RATE)  @?= 0
  , testCase "CBits is content, bit-identical" $
      assertHexEq "CBits (lg 3)" (castDoubleToWord64 (lg 3))
                  (chargeBits fragWidth (CBits (lg 3)))
  , testCase "CSum is float addition at the tree's own shape" $
      -- the constant sentence's shape, priced by hand at the same
      -- association: wM + (wT + lg 9)
      assertHexEq "const-shaped sum" (castDoubleToWord64 (1 + (1 + lg 9)))
                  (chargeBits fragWidth
                     (CSum (CW MODEL) (CSum (CW THETA) (CBits (lg 9)))))
  , testCase "THE DOCTRINE ROW: the association is data — one ulp moves when the tree does" $ do
      -- measured (the assoc probe, 2026-07-15): a = 1, b = lg 3,
      -- c = lg 7 — corpus-typical leaves where ((a+b)+c) /= (a+(b+c))
      let left  = CSum (CSum (CBits 1) (CBits (lg 3))) (CBits (lg 7))
          right = CSum (CBits 1) (CSum (CBits (lg 3)) (CBits (lg 7)))
      assertHexEq "left association"  0x401591bba891f170
                  (chargeBits fragWidth left)
      assertHexEq "right association" 0x401591bba891f171
                  (chargeBits fragWidth right)
      assertBool "the shapes price differently"
                 (castDoubleToWord64 (chargeBits fragWidth left)
                    /= castDoubleToWord64 (chargeBits fragWidth right))
  ]

-- ---------------------------------------------------------------------
-- g2: the declared trees price at the frozen charges
-- ---------------------------------------------------------------------

g2Trees :: TestTree
g2Trees = testGroup "g2 the declared trees == the frozen charges"
  [ testCase "the ns0 trees hit the step-3 frozen hexes (Sentence.hs:250-253, COPIES)" $ do
      assertHexEq "constCharge theta" 0x4014ae00d1cfdeb4
                  (chargeBits fragWidth (constCharge thetaG))
      assertHexEq "walkCharge" 0x4010000000000000
                  (chargeBits fragWidth walkCharge)
      assertHexEq "guardCharge ns0 tau theta" 0x4030570068e7ef5a
                  (chargeBits fragWidth (guardCharge ns0 tauG thetaG))
  , testCase "the namespace-variant guard trees hit the captured hexes (9d348eb, the g1/M1-pinned populations)" $ do
      assertHexEq "nsA t-guard"  0x4031570068e7ef5a
                  (chargeBits fragWidth (guardCharge nsA tauG thetaG))
      assertHexEq "nsA s2-guard" 0x402aae00d1cfdeb4
                  (chargeBits fragWidth (guardCharge nsA s2Grid thetaG))
      assertHexEq "nsC t-guard"  0x4031ecc08321eb30
                  (chargeBits fragWidth (guardCharge nsC tauG thetaG))
      assertHexEq "nsC z-guard"  0x402f05013ab7ce0e
                  (chargeBits fragWidth (guardCharge nsC zGrid thetaG))
      assertHexEq "nsC la-guard" 0x402dd9810643d661
                  (chargeBits fragWidth (guardCharge nsC laGrid thetaG))
  ]

-- ---------------------------------------------------------------------
-- g3: the wiring pin — the enumerator prices EXACTLY the declared trees
-- ---------------------------------------------------------------------

g3Wiring :: TestTree
g3Wiring = testGroup "g3 hypBits IS chargeBits of the declared tree"
  [ testCase "all three populations, sentence by sentence, ==" $ do
      let popOf ns extras =
            ( enumerateSentencesIn ns extras fragFull
            , replicate 9 (constCharge thetaG)
                ++ replicate 8 walkCharge
                ++ concatMap
                     (\(_, g) -> replicate (gridSize g * 72)
                                   (guardCharge ns g thetaG))
                     (("t", tauG) : extras) )
          check nm (hs, ts) = do
            assertEqual (nm ++ " population/tree counts")
                        (length hs) (length ts)
            mapM_ (\(i, h, t) ->
                     assertEqual (nm ++ " sentence " ++ show i ++ " (bit)")
                       (castDoubleToWord64 (unB (hypBits h)))
                       (castDoubleToWord64 (chargeBits fragWidth t)))
                  (zip3 [0 :: Int ..] hs ts)
          unB (Bits d) = d
      check "ns0" (popOf ns0 [])
      check "nsA" (popOf nsA [("s2", s2Grid)])
      check "nsC" (popOf nsC [("z", zGrid), ("last_action", laGrid)])
  ]

-- ---------------------------------------------------------------------
-- g4: the tables as declared data (green at birth)
-- ---------------------------------------------------------------------

g4Tables :: TestTree
g4Tables = testGroup "g4 the two declared tables"
  [ testCase "prodTable, the P5 single site, six fields (re-homes the retired gP5 pin; typed-port-spec section 3)" $ do
      prodExpr prodTable    @?= 19
      prodFn prodTable      @?= 2
      prodStats prodTable   @?= 1
      prodKer prodTable     @?= 2
      prodStdName prodTable @?= 6
      prodUtil prodTable    @?= 1
  -- the fragment table's four widths are pinned where they were
  -- declared: test-sentence g4 (frozen). Not duplicated here —
  -- copy-not-reconstruct cuts both ways.
  ]
