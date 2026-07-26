-- | PropLang.Lattice — the dyadic-in-theta lattice and the region
-- guard (the X.5 sitting's ruling 1, sealed at x5-sitting-r0: the
-- R-R1 re-open, dyadic-in-theta ADOPTED; the staged diff is
-- x5-author-pack.md 3.6, this module is that diff landing).
--
-- ORACLE PHASE (dyadic increment): the bodies below are
-- compile-enabling STUBS — total, deliberately wrong — so that
-- test-dyadic/ runs RED against this surface before the freeze
-- seals it (the increment protocol's two-run structure). The
-- implementation replaces the stub bodies after the author's
-- freeze tag; the type surface is the increment's drafted surface.
--
-- Type-derivation audit (the step-6 clause — every type on a frozen
-- surface carries its one-line derivation):
--   'Node'   — ruling 1 (x5 record) via 3.5 ground 1: a lattice
--              point IS a sayable dyadic rational — num odd,
--              theta = num/2^(depth+1); the coordinate lives where
--              the language lives (the Rational sort).
--   'Owned'  — unchanged seat (METAREASONING_PLAN.md:68-74): the
--              materialized part of the FIXED priced space.
--   'Region' — unchanged seat (R-R3, region form), fields now
--              Rational: the rectangle bound's data, exact.
--
-- Pricing (3.5 ground 2, universality with its object renamed): the
-- MENTION of a dyadic rational of depth k costs
-- gammaLen(k+1) + k — Elias-gamma on the one remaining integer
-- (depth) times uniform position within the level. Integer-valued;
-- mirror-positional (same depth, same price — the founding symmetry
-- survives exactly). Kraft over the tree is EXACTLY 1 (3.6a's free
-- fact): the extent chain, the +2000 truncation, and ground M3's
-- entire apparatus cease to exist.
module PropLang.Lattice
  ( Node
  , rootNode
  , nodeTheta
  , gammaBits
  , childrenOf
  , Owned
  , mkOwned
  , ownedNodes
  , frontier
  , regions
  , Region (..)
  , kraftSubtree
  , scoreOwned
  , guardE
  , straddles
  ) where

import Data.List (nub, sortOn)
import Data.List.NonEmpty (nonEmpty)
import Data.Ratio ((%))
import PropLang.Belief (Belief, fromWeights, mkSpace)

-- | A lattice node: theta = num / 2^(depth+1), num ODD — the
-- canonical dyadic form, injective by construction (ground M6 dies
-- structurally). Constructor unexported: nodes arise from
-- 'rootNode', 'childrenOf' and 'frontier' only.
data Node = Node
  { nNum   :: Integer
  , nDepth :: Int
  }
  deriving (Eq, Ord, Show)

-- | The root: depth 0, theta = 1/2 — the unique symmetric point.
rootNode :: Node
rootNode = Node 1 0

-- | The EXACT coordinate (ruling 1): num/2^(depth+1), a sayable
-- rational. STUB: constant 1/3 (non-dyadic, wrong for EVERY node,
-- interior so downstream masses stay positive and total).
nodeTheta :: Node -> Rational
nodeTheta (Node _ _) = 1 % 3

-- Elias-gamma length of a positive integer (integer-valued).
gammaLen :: Integer -> Integer
gammaLen m = 2 * fromIntegral (ilog2 m) + 1

ilog2 :: Integer -> Int
ilog2 m | m <= 1    = 0
        | otherwise = 1 + ilog2 (m `div` 2)

-- | THE pricing formula (3.6): gammaLen(depth+1) + depth, integer,
-- mirror-safe — the sign bit died with the signed extents. STUB:
-- constant 2 (wrong at every depth).
gammaBits :: Node -> Integer
gammaBits (Node _ k) = 2 + 0 * gammaLen (fromIntegral k + 1)

-- | The two dyadic refinements of a node — the only generator
-- besides the root, so num stays odd by construction.
childrenOf :: Node -> [Node]
childrenOf (Node p k) = [Node (2 * p - 1) (k + 1), Node (2 * p + 1) (k + 1)]

parentOf :: Node -> Maybe Node
parentOf (Node _ 0) = Nothing
parentOf (Node p k) =
  let a = (p + 1) `div` 2
      b = (p - 1) `div` 2
  in Just (Node (if odd a then a else b) (k - 1))

-- theta span of a node's subtree: the exact dyadic interval
-- ((num-1)/2^(depth+1), (num+1)/2^(depth+1)). STUB: the inverted
-- interval (1, 0), so no candidate lies in its own region.
spanOf :: Node -> (Rational, Rational)
spanOf (Node _ _) = (1, 0)

-- | A finite owned set (the materialized part of the fixed priced
-- space). Abstract: 'mkOwned' is the only door in.
newtype Owned = Owned [Node]
  deriving (Eq, Show)

-- | Canonical closure: dedupe, close under tree parents (the root
-- is always owned), canonical code order (price, then theta).
mkOwned :: [Node] -> Owned
mkOwned ns =
  Owned (sortOn (\c -> (gammaBits c, nodeTheta c))
           (nub (concatMap ancestry (rootNode : ns))))
  where
    ancestry n = n : maybe [] ancestry (parentOf n)

ownedNodes :: Owned -> [Node]
ownedNodes (Owned ns) = ns

-- | Frontier candidates: children of owned nodes not themselves
-- owned — finite, canonical code order.
frontier :: Owned -> [Node]
frontier (Owned ns) =
  sortOn (\c -> (gammaBits c, nodeTheta c))
    (nub [ c | n <- ns, c <- childrenOf n, c `notElem` ns ])

-- | A frontier region: the unowned dyadic interval it opens, with
-- its subtree Kraft mass — the rectangle bound's data, EXACT.
-- CONTRACT: 'regions' aligns index-wise with 'frontier'.
data Region = Region
  { rLo   :: Rational
  , rHi   :: Rational
  , rMass :: Rational
  }
  deriving (Eq, Show)

regions :: Owned -> [Region]
regions o =
  [ Region lo hi (kraftSubtree c)
  | c <- frontier o, let (lo, hi) = spanOf c ]

-- exact gamma tail: sum_{m >= m0} 2^-gammaLen(m), by octaves —
-- octave b contributes 2^b * 2^-(2b+1) = 2^-(b+1). STUB inside
-- 'kraftSubtree'.
gammaTailQ :: Integer -> Rational
gammaTailQ m0 =
  let b0   = ilog2 m0
      full = 1 % (2 ^ (b0 + 1))
      pre  = fromInteger (m0 - 2 ^ b0) * (1 % (2 ^ (2 * b0 + 1)))
      rest = 1 % (2 ^ (b0 + 1))
  in (full - pre) + rest

-- | Kraft mass of the subtree at (and below) a node, exact closed
-- form: 2^-depth * gammaTail(depth+1) — the position count cancels
-- the position bits per level, the sum telescopes, NOTHING is
-- truncated (Kraft over the whole tree is exactly 1). STUB: 0.
kraftSubtree :: Node -> Rational
kraftSubtree (Node _ _) = 0 * gammaTailQ 1

-- | The canonical scorer: the posterior over an owned set given the
-- permanent counts, through the sealed reasoner's own prior door —
-- mass = 2^-gammaBits * th^n1 * (1-th)^n0 per node, EXACT, keyed on
-- the (injective) exact theta. Belief Rational: no realToFrac, no
-- Double anywhere.
scoreOwned :: Owned -> (Int, Int) -> Belief Rational
scoreOwned o (n1, n0) =
  case nonEmpty (map nodeTheta (ownedNodes o)) of
    Nothing  -> error "scoreOwned: the owned set is never empty (root closure)"
    Just pts ->
      case fromWeights (mkSpace pts)
             (\th -> massAt th * th ^ n1 * (1 - th) ^ n0) of
        Just b  -> b
        Nothing -> error "scoreOwned: no mass (unreachable: interior thetas)"
  where
    massAt th =
      case [ gammaBits n | n <- ownedNodes o, nodeTheta n == th ] of
        (g : _) -> 1 % (2 ^ g)
        []      -> error "scoreOwned: theta not in the owned set"

likeQ :: Int -> Int -> Rational -> Rational
likeQ n1 n0 th = th ^ n1 * (1 - th) ^ n0

-- sup over an interval of the Bernoulli likelihood (unimodal at
-- n1/(n1+n0) — a RATIONAL clip point; the sup is exact).
supLike :: Int -> Int -> (Rational, Rational) -> Rational
supLike n1 n0 (a, b) =
  let m | n1 + n0 == 0 = b
        | otherwise    = fromIntegral n1 % fromIntegral (n1 + n0)
      p = max a (min b m)
  in likeQ n1 n0 p

uOf :: (Rational, Rational) -> Rational -> Rational
uOf (sR, sW) th = sR * th + sW * (1 - th)

-- | The region guard's expectation under a placement: True =
-- pessimistic, False = optimistic — every region placed at
-- (sup-likelihood, endpoint-extremum utility), the rectangle bound,
-- all comparisons EXACT: the guard is a theorem-grade bound, not a
-- float estimate. STUB: a size-decreasing pessimistic value and its
-- negation — wrong everywhere, and it VIOLATES interval nesting
-- under refinement, so the guard-safety row's red is demonstrated.
guardE :: Bool -> Owned -> (Int, Int) -> (Rational, Rational) -> Rational
guardE pess o (n1, n0) st =
  let z    = 0 * uOf st (supLike n1 n0 (spanOf rootNode))
      size = fromIntegral (length (ownedNodes o))
  in z + (if pess then 15 % 2 - size else size - 15 % 2)

-- | The straddle: pessimistic <= 0 < optimistic — the owned
-- decision is not robust to admissible placements of unowned mass.
straddles :: Owned -> (Int, Int) -> (Rational, Rational) -> Bool
straddles o c st = guardE True o c st <= 0 && guardE False o c st > 0
