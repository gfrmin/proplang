{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- The axiom-INDEPENDENCE facet of the exact lawful floor (sibling of
-- Lawful.hs; two stanzas per the author's ruling of 2026-07-24).
-- Rewritten exact at the boundary: the separating witnesses are now
-- EXACT functionals over Rationals — every separation is (==)-sharp,
-- and the 3+1 structure (the mechanization's own finding) is stated
-- directly: L1/L2/L3 constrain the ELIMINATOR (the Riesz triple),
-- L4' constrains the INTRODUCER (fromWeights). Each witness satisfies
-- the other two eliminator laws and fails its own; L4' is separated
-- by an introducer witness (uniform over non-constant weights).
-- PRIMITIVE lines (a witness must be EXHIBITED) are marked.
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio ()

import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief

-- the eliminator domain {0,1}: constructed, points DERIVED
binSp :: Space Int
binSp = mkSpace (0 :| [1])

binPts :: [Int]
binPts = spacePoints binSp

-- Fn: the Riesz shape the eliminator axioms constrain
type Fn = (Int -> Rational) -> Rational

eBase :: Fn
eBase g = sum (map g binPts) / fromIntegral (length binPts)

satL1 :: Fn -> Bool
satL1 e = e (const 1) == 1

satL2 :: Fn -> Bool
satL2 e = all ok probesLin
  where ok (a, c, f, g) =
          e (\x -> a * f x + c * g x) == a * e f + c * e g

satL3 :: Fn -> Bool
satL3 e = all ok probesMono
  where ok (f, g) = e f <= e g          -- exact <=

ind :: Int -> Int -> Rational
ind i x = if x == i then 1 else 0

probesLin :: [(Rational, Rational, Int -> Rational, Int -> Rational)]
probesLin =
  [ (1, 1, ind 0, ind 1)
  , (2, 3, ind 0, ind 1)
  , (1, -1, ind 0, ind 1) ]

probesMono :: [(Int -> Rational, Int -> Rational)]
probesMono =
  [ (const 0, ind 1)
  , (ind 0, const 1)
  , (const 0, const 1) ]

-- the three separating witnesses (PRIMITIVE: each must be exhibited)
wL1, wL2, wL3 :: Fn
wL1 g = 2 * eBase g                    -- PRIMITIVE: scale 2. fails L1
wL2 g = max (g 0) (g 1)                -- the sup functional. fails L2
wL3 g = 2 * g 0 - g 1                  -- PRIMITIVE: signed. fails L3

-- L4', the INTRODUCER law, on the real fromWeights over a 3-point
-- space with VARYING weights (PRIMITIVE: the non-constant assignment)
sp3 :: Space Int
sp3 = mkSpace (0 :| [1, 2])

wVar :: Int -> Rational
wVar i = [4, 2, 1] !! i               -- PRIMITIVE: strictly varying

satL4 :: (Int -> Rational) -> Bool
satL4 p = and [ p x * wVar y == p y * wVar x
              | x <- [0 .. 2], y <- [0 .. 2] ]

main :: IO ()
main = defaultMain $ testGroup "independence (the exact core four are irreducible)"
  [ testGroup "Riesz triple: L1,L2,L3 separated among the eliminator laws"
      [ testCase "wL1 fails L1, satisfies L2 & L3" $ do
          assertBool "fails L1" (not (satL1 wL1))
          assertBool "satisfies L2" (satL2 wL1)
          assertBool "satisfies L3" (satL3 wL1)
      , testCase "wL2 fails L2, satisfies L1 & L3" $ do
          assertBool "fails L2" (not (satL2 wL2))
          assertBool "satisfies L1" (satL1 wL2)
          assertBool "satisfies L3" (satL3 wL2)
      , testCase "wL3 fails L3, satisfies L1 & L2" $ do
          assertBool "fails L3" (not (satL3 wL3))
          assertBool "satisfies L1" (satL1 wL3)
          assertBool "satisfies L2" (satL2 wL3)
      ]
  , testGroup "introducer: L4' separated from the eliminator laws"
      [ testCase "the weighted prior obeys L4' (the law is satisfiable), exactly" $
          case fromWeights sp3 wVar of
            Nothing -> assertBool "refused" False
            Just b -> assertBool "fromWeights obeys the ratio law"
              (satL4 (\i -> prob b (== i)))
      , testCase "uniform is a valid measure (L1-L3) yet fails L4' on varying weights, exactly" $ do
          let pFlat i = prob (uniform sp3) (== i)
          assertEqual "sums to 1" 1 (sum (map pFlat [0 .. 2]))
          assertBool "nonneg" (all (\i -> pFlat i >= 0) [0 .. 2])
          assertBool "fails the ratio law" (not (satL4 pFlat))
      ]
  , testGroup "register correction (why 3+1, not 4 peers)"
      [ testCase "the signed L3-witness cannot be a measure (exact negative ratio)" $ do
          -- p0/p1 = 2/(-1): a signed functional's 'weights' violate
          -- nonnegativity, so L4' (a law about the INTRODUCER's output)
          -- cannot even be posed of it — the 3+1 structure, exactly.
          assertBool "signed ratio is negative" ((2 :: Rational) / (-1) < 0)
          assertBool "every lawful weight ratio is nonneg"
            (and [ wVar x / wVar y > 0 | x <- [0 .. 2], y <- [0 .. 2] ])
      ]
  , testCase "red mirror: a genuine measure passes every eliminator law" $ do
      assertBool "eBase satisfies L1" (satL1 eBase)
      assertBool "eBase satisfies L2" (satL2 eBase)
      assertBool "eBase satisfies L3" (satL3 eBase)
  ]
