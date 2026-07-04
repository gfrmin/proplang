{-# LANGUAGE GADTs #-}

-- | The frozen property suite (typed-port-spec §5): the two invariants
-- types cannot see, pinned by QuickCheck against the PUBLIC Belief API
-- only. Frozen under MANIFEST.sha256 after human review.
--
-- 1. CL-4, conjugacy equivalence — stated extensionally: 'cond' must
--    agree with Bayes' theorem computed through the public accessors
--    ('expect' / 'prob' / 'push' / 'point'). Any Phase-2 conjugate fast
--    path behind the opaque Belief handle is legal iff this property
--    still passes: the fast path buys speed, never semantics.
--
-- 2. Fineness charged once — refining a grid redistributes (nearly) the
--    same predictive mass over more, individually costlier sentences;
--    the entire charge is the prior route (design.md §5). Tolerance
--    delta = 0.02 bits/observation, calibrated against the Python
--    oracle (observed maximum 0.0025 bits/obs on the shifted-world and
--    iid streams, 9-point vs midpoint-refined 17-point theta grid —
--    8x headroom). Per the tolerance protocol, delta is part of the
--    oracle and is never widened in place.
module Main (main) where

import qualified Data.List.NonEmpty as NE
import Data.Maybe (fromMaybe)
import Test.Tasty
import Test.Tasty.QuickCheck

import PropLang.Belief

main :: IO ()
main = defaultMain $ testGroup "proplang properties (frozen oracle)"
  [ testProperty "CL-4: cond agrees with extensional Bayes (Saw evidence)"
                 propCl4Saw
  , testProperty "CL-4: cond agrees with extensional Bayes (Is evidence)"
                 propCl4Is
  , testProperty "fineness charged once: predictive mass invariant under grid refinement"
                 propFineness
  ]

ln2 :: Double
ln2 = log 2

-- ---------------------------------------------------------------------
-- generators (finite spaces over Int points; all masses strictly
-- positive, so conditioning is always possible)
-- ---------------------------------------------------------------------

genSpaceSize :: Gen Int
genSpaceSize = chooseInt (2, 6)

genObsSize :: Gen Int
genObsSize = chooseInt (2, 4)

genBits :: Int -> Gen [Double]
genBits n = vectorOf n (choose (0, 8))

-- ---------------------------------------------------------------------
-- CL-4: cond == Bayes, computed only through the public accessors
-- ---------------------------------------------------------------------

-- | Saw evidence: posterior expectation of f must equal
-- E[lik . f] / E[lik], with the likelihood recovered publicly as
-- lik x = prob (push (point x) k) (is o).
propCl4Saw :: Property
propCl4Saw =
  forAll genSpaceSize $ \n ->
  forAll genObsSize $ \m ->
  forAll (genBits n) $ \pb ->
  forAll (vectorOf n (genBits m)) $ \kb ->
  forAll (chooseInt (0, m - 1)) $ \o ->
  forAll (vectorOf n (choose (-10, 10))) $ \fv ->
    let sp  = mkSpace (NE.fromList [0 .. n - 1])
        osp = mkSpace (NE.fromList [0 .. m - 1])
        b   = fromBits sp (\x -> Bits (pb !! x))
        k   = kernel sp osp (\x -> fromBits osp (\y -> Bits (kb !! x !! y)))
        lik x = prob (push (point sp x) k) (is osp o)
        f x = fv !! x
        rhs = expect b (\x -> lik x * f x) / expect b lik
    in case cond b (Saw k o) of
         Nothing -> counterexample
           "cond returned Nothing on strictly-positive-mass evidence" False
         Just b' ->
           let lhs = expect b' f
           in counterexample ("cond: " ++ show lhs ++ " vs Bayes: " ++ show rhs)
                (abs (lhs - rhs) <= 1e-9 * (1 + abs rhs))

-- | Is evidence: conditioning on a declared event must equal the
-- renormalized restriction.
propCl4Is :: Property
propCl4Is =
  forAll genSpaceSize $ \n ->
  forAll (genBits n) $ \pb ->
  forAll (sublistOf [0 .. n - 1] `suchThat` (not . null)) $ \sub ->
  forAll (vectorOf n (choose (-10, 10))) $ \fv ->
    let sp = mkSpace (NE.fromList [0 .. n - 1])
        b  = fromBits sp (\x -> Bits (pb !! x))
        e  = event sp (`elem` sub)
        f x = fv !! x
        ind x = if x `elem` sub then 1 else 0
        rhs = expect b (\x -> ind x * f x) / prob b e
    in case cond b (Is e) of
         Nothing -> counterexample
           "cond returned Nothing on a nonempty positive-mass event" False
         Just b' ->
           let lhs = expect b' f
           in counterexample ("cond: " ++ show lhs ++ " vs Bayes: " ++ show rhs)
                (abs (lhs - rhs) <= 1e-9 * (1 + abs rhs))

-- ---------------------------------------------------------------------
-- fineness charged once
-- ---------------------------------------------------------------------

-- the reference theta grid and its midpoint refinement
grid9 :: [Double]
grid9 = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]

grid17 :: [Double]
grid17 = [ 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5
         , 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9 ]

-- | Cumulative predictive log-loss (bits) of a bern-constant ensemble
-- over a grid, priced exactly as the reference model fragment prices a
-- constant sentence: 1 (MODEL choice) + 1 (PARAM choice) + log2 n (grid
-- index) bits, through 'fromBits' — the only prior source.
ensembleLogloss :: [Double] -> [Int] -> Double
ensembleLogloss grid ys = fst (foldl' step (0, prior) ys)
  where
    n    = length grid
    sp   = mkSpace (NE.fromList [0 .. n - 1])
    osp  = mkSpace (NE.fromList [0, 1])
    prior = fromBits sp (\_ -> Bits (2 + logBase 2 (fromIntegral n)))
    bern th = fromBits osp
      (\y -> Bits (negate (logBase 2 (if y == 1 then th else 1 - th))))
    k = kernel sp osp (\i -> bern (grid !! i))
    step (ll, b) y =
      let LogProb lp = logPredict b (Saw k y)
          b' = fromMaybe (error "impossible evidence in ensemble") (cond b (Saw k y))
      in (ll - lp / ln2, b')

-- | Refine the theta grid 9 -> 17 points: the cumulative predictive
-- mass on any Bernoulli stream moves by less than 0.02 bits per
-- observation. There is no separate fineness-penalty axis; the grid's
-- log2 n enters through the prior and nowhere else.
propFineness :: Property
propFineness =
  forAll (chooseInt (50, 200)) $ \tLen ->
  forAll (choose (0.05, 0.95)) $ \theta ->
  forAll (vectorOf tLen (choose (0, 1))) $ \us ->
    let ys  = [ if u < (theta :: Double) then 1 else 0 :: Int | u <- us ]
        l9  = ensembleLogloss grid9 ys
        l17 = ensembleLogloss grid17 ys
    in counterexample
         ("9-pt: " ++ show l9 ++ " bits, 17-pt: " ++ show l17
          ++ " bits over " ++ show tLen ++ " obs")
         (abs (l9 - l17) <= 0.02 * fromIntegral tLen)
