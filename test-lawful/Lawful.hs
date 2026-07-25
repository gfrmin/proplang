{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- THE EXACT LAWFUL FLOOR (satisfaction half; sibling suite:
-- Independence.hs). Rewritten at the exact boundary under the
-- author's ruling of 2026-07-25: "never freeze incorrect code" — the
-- Double floor (u = 2^-53, tol, near) is superseded and never froze;
-- its STRUCTURE is ported (4 axioms + 4 conformance theorems, the
-- corrected labels), its numerics are exact. EVERY assertion IS (==)
-- OR EXACT (<=): no tolerance constant exists in this file — the gap
-- between the law and the check is closed.
--
-- The 4 AXIOMS (the floor):
--   L1  normalization      E[1] == 1
--   L2  linearity          E[a f + c g] == a E[f] + c E[g]
--   L3  monotonicity       f <= g pointwise => E[f] <= E[g]
--   L4' the introducer law prob(fromWeights w) * Z == w   (per point)
-- The 4 CONFORMANCE THEOREMS (proved OF the implementation, never
-- installed as definitions — the Savage-shape lesson):
--   T1  prob == E[indicator]
--   T2  uniform/point ARE fromWeights definitions (ruling #7)
--   T3  conditioning IS Bayes (division-free identity)
--   T4  push obeys the tower  E_push[f] == E[E_k[f]]
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio ((%))

import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief

-- the floor's space and belief battery: DECLARED weights (never
-- random; the QuickCheck-seed lesson), including a zero weight and
-- skewed masses
sp5 :: Space Int
sp5 = mkSpace (0 :| [1, 2, 3, 4])

pts :: [Int]
pts = spacePoints sp5

wBatts :: [[Rational]]
wBatts =
  [ [1, 1, 1, 1, 1]
  , [3, 1, 2, 5, 7]
  , [1 % 2, 1 % 3, 1 % 5, 1 % 7, 1 % 11]
  , [0, 1, 2, 0, 4]          -- zero weights are lawful (mass absent)
  , [82944, 16, 36, 1, 55]
  ]

beliefs :: [Belief Int]
beliefs = [ b | ws <- wBatts
          , Just b <- [fromWeights sp5 (\i -> ws !! i)] ]

-- declared probe functions (exact)
fA, fB :: Int -> Rational
fA x = fromIntegral x * (2 % 3) - 1
fB x = fromIntegral (x * x) % 7

main :: IO ()
main = defaultMain $ testGroup "the exact lawful floor (satisfaction)"
  [ testGroup "axioms"
      [ testCase "L1 normalization: E[1] == 1, every belief" $
          mapM_ (\b -> expect b (const 1) @?= 1) beliefs
      , testCase "L2 linearity: exact, declared probes" $
          mapM_ (\b -> mapM_ (\(a, c) ->
                  assertEqual "E[a f + c g] == a E f + c E g"
                    (a * expect b fA + c * expect b fB)
                    (expect b (\x -> a * fA x + c * fB x)))
                [ (1, 1), (2, 3), (1, -1), (-5 % 7, 11 % 3) ])
            beliefs
      , testCase "L3 monotonicity: exact <=" $
          mapM_ (\b -> do
              let f x = fA x
                  g x = fA x + fB x + 1 % 9   -- g > f pointwise (fB >= 0)
              assertBool "E f <= E g (exact)" (expect b f <= expect b g))
            beliefs
      , testCase "L4' the introducer law: prob * Z == w, per point, every battery" $
          mapM_ (\ws -> case fromWeights sp5 (\i -> ws !! i) of
              Nothing -> assertBool "unexpected refusal" (all (<= 0) ws)
              Just b -> do
                let z = sum ws
                mapM_ (\i -> assertEqual "p*Z == w"
                        (ws !! i) (prob b (== i) * z)) pts
                -- the ratio corollary, division-free
                mapM_ (\(i, j) -> assertEqual "p_i w_j == p_j w_i"
                        (prob b (== i) * (ws !! j))
                        (prob b (== j) * (ws !! i)))
                  [ (i, j) | i <- pts, j <- pts ])
            wBatts
      ]
  , testGroup "conformance theorems"
      [ testCase "T1 prob == the weight mass at matching points (INDEPENDENT route: the read-only views, never expect - the mandate-1 repair of the Savage-shaped restatement)" $
          mapM_ (\b -> mapM_ (\i ->
                  assertEqual "prob == view-summed mass"
                    (sum [ w | (x, w) <- zip (points b) (weights b)
                         , x == i ])
                    (prob b (== i)))
                pts)
            beliefs
      , testCase "T2 uniform/point ARE fromWeights (ruling #7)" $ do
          assertEqual "uniform"
            (map (\i -> prob (uniform sp5) (== i)) pts)
            (map (const (1 % 5)) pts)
          case point sp5 3 of
            Nothing -> assertBool "point refused" False
            Just b -> assertEqual "point"
              (map (\i -> prob b (== i)) pts) [0, 0, 0, 1, 0]
      , testCase "T3 conditioning IS Bayes (division-free)" $ do
          let k = kernel sp5 (mkSpace (0 :| [1 :: Int]))
                    (\x -> case fromWeights (mkSpace (0 :| [1]))
                                 (\y -> if y == 1
                                          then fromIntegral x + 1
                                          else 5 - fromIntegral x) of
                      Just col -> col
                      Nothing -> error "column (unreachable)")
          mapM_ (\b -> mapM_ (\y -> do
                  let m i = prob b (== i) * prob (kernelAt k i) (== y)
                      z = sum (map m pts)
                  case condK b k y of
                    Nothing -> assertBool "refusal" (z <= 0)
                    Just b' -> mapM_ (\i ->
                        assertEqual "p' * Z == p * L"
                          (m i) (prob b' (== i) * z))
                      pts)
                [0, 1])
            beliefs
      , testCase "T4 push obeys the tower, exactly" $ do
          let cod = mkSpace (0 :| [1, 2 :: Int])
              k = kernel sp5 cod
                    (\x -> case fromWeights cod
                                 (\y -> fromIntegral (x + y + 1)) of
                      Just col -> col
                      Nothing -> error "column (unreachable)")
          mapM_ (\b ->
              assertEqual "E_push[f] == E[E_k[f]]"
                (expect b (\x -> expect (kernelAt k x) fA))
                (expect (push b k) fA))
            beliefs
      ]
  ]
