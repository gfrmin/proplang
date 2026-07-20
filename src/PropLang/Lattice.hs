-- | PropLang.Lattice — the dyadic log-odds lattice and the region
-- guard (boundary R, the joint purchase increment R1).
--
-- Type-derivation audit (the step-6 clause — every type on a frozen
-- surface carries its one-line derivation from the brief):
--   'Node'   — METAREASONING_PLAN.md:49-60: the theta vocabulary is
--              the dyadic log-odds lattice; a point IS a dyadic
--              rational in log-odds, nothing more.
--   'Owned'  — :68-74: the agent lazily materializes the
--              decision-relevant part of a FIXED priced space; the
--              owned set is that materialized part, a set of nodes.
--   'Region' — :173-201 as amended by R-R3 (r-author-pack Part II):
--              the guard's unit is the frontier REGION — interval
--              bounds and a Kraft mass, the rectangle bound's data.
--
-- The lattice is priced by Elias-gamma on extent (ruling R-R1,
-- derived: coordinate consistency, universality, corroborated
-- economics — r-author-pack Part II). 'gammaBits' is THE one frozen
-- formula, feeding the Charge algebra's CBits case: no new
-- arithmetic site (P5 single-site discipline; r-author-pack I.7).
-- The extent field is the SYMMETRIC magnitude — an extent node's own
-- |j|; a gap node keys on the magnitude of the extent whose gap it
-- refines — so mirror nodes cost the same (the root's symmetry is
-- the lattice's founding invariant; the floor form broke it and the
-- SAT window caught the break, r-author-pack III.6).
module PropLang.Lattice
  ( Node
  , rootNode
  , nodeLambda
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
import PropLang.Belief (Belief, Bits (..), fromBits, mkSpace)

-- | A lattice node: log-odds lambda = num / 2^depth, in lowest terms
-- (depth == 0 or num odd — the canonical dyadic representation).
-- Constructor unexported: nodes arise from 'rootNode', 'childrenOf'
-- and 'frontier' only, so every reachable node is lattice-lawful by
-- construction.
data Node = Node
  { nNum   :: Integer
  , nDepth :: Int
  }
  deriving (Eq, Ord, Show)

-- | The unique symmetric point: log-odds 0, theta = 1/2.
rootNode :: Node
rootNode = Node 0 0

nodeLambda :: Node -> Double
nodeLambda (Node p k) = fromInteger p / (2 ^^ k)

nodeTheta :: Node -> Double
nodeTheta n = 1 / (1 + 2 ** negate (nodeLambda n))

thetaAtLambda :: Double -> Double
thetaAtLambda lam = 1 / (1 + 2 ** negate lam)

-- Elias-gamma length of a positive integer.
gammaLen :: Integer -> Double
gammaLen m = 2 * fromIntegral (ilog2 m) + 1

ilog2 :: Integer -> Int
ilog2 m | m <= 1    = 0
        | otherwise = 1 + ilog2 (m `div` 2)

-- The code's extent field: symmetric magnitude (module header).
extentMag :: Node -> Integer
extentMag (Node p 0) = abs p
extentMag n          = ceiling (abs (nodeLambda n))

-- | THE frozen pricing formula (R-R1): the (extent, depth, position)
-- triple — sign + gamma(|extent|+1) + gamma(depth+1) + (depth-1)
-- position bits for depth >= 1. Extent ~2 lg j (the ruling's
-- economics), depth linear (fineness charged once per halving),
-- position uniform within the level.
gammaBits :: Node -> Double
gammaBits n@(Node _ k) =
  1 + gammaLen (extentMag n + 1) + gammaLen (fromIntegral k + 1)
    + fromIntegral (max 0 (k - 1))

-- | The two tree children of a node (outward extension / inward
-- halving — the candidate generator's unit, pack III.5). Exported so
-- probes enumerate subtrees through the declared door (the step-5
-- probe clause; the g5 SAT run's finding).
childrenOf :: Node -> [Node]
childrenOf (Node p 0)
  | p == 0    = [Node 1 0, Node (-1) 0]
  | p > 0     = [Node (p + 1) 0, Node (2 * p - 1) 1]
  | otherwise = [Node (p - 1) 0, Node (2 * p + 1) 1]
childrenOf (Node p k) = [Node (2 * p - 1) (k + 1), Node (2 * p + 1) (k + 1)]

parentOf :: Node -> Maybe Node
parentOf (Node 0 0) = Nothing
parentOf (Node p 0) = Just (Node (if p > 0 then p - 1 else p + 1) 0)
parentOf (Node p 1) =
  let j = (p - 1) `div` 2
  in Just (Node (if nodeLambda (Node p 1) > 0 then j + 1 else j) 0)
parentOf (Node p k) =
  let a = (p + 1) `div` 2
      b = (p - 1) `div` 2
  in Just (Node (if odd a then a else b) (k - 1))

-- theta span of a node's subtree (contiguous by the tree's
-- construction, pack III.5: an extension child at j spans everything
-- beyond theta(j-1); a gap node spans its dyadic sub-interval).
spanOf :: Node -> (Double, Double)
spanOf (Node 0 0) = (0, 1)
spanOf (Node p 0)
  | p > 0     = (nodeTheta (Node (p - 1) 0), 1)
  | otherwise = (0, nodeTheta (Node (p + 1) 0))
spanOf n@(Node _ k) =
  let lam = nodeLambda n
      w   = 2 ^^ negate k
  in (thetaAtLambda (lam - w), thetaAtLambda (lam + w))

-- | A finite owned set of lattice nodes (the materialized part of
-- the fixed priced space). Abstract: 'mkOwned' is the only door in,
-- so canonical code order is a representation invariant, not a
-- caller obligation.
newtype Owned = Owned [Node]
  deriving (Eq, Show)

-- | Canonical closure: dedupe, close under tree parents (the root is
-- always owned), canonical code order — every constructible Owned is
-- lawful; totality by construction, no Maybe on the door.
mkOwned :: [Node] -> Owned
mkOwned ns =
  Owned (sortOn (\c -> (gammaBits c, nodeLambda c))
           (nub (concatMap ancestry (rootNode : ns))))
  where
    ancestry n = n : maybe [] ancestry (parentOf n)

ownedNodes :: Owned -> [Node]
ownedNodes (Owned ns) = ns

-- | Frontier candidates: the children (outward extension and inward
-- halving) of owned nodes that are not themselves owned — finite,
-- canonical code order (METAREASONING_PLAN.md:89-91).
frontier :: Owned -> [Node]
frontier (Owned ns) =
  sortOn (\c -> (gammaBits c, nodeLambda c))
    (nub [ c | n <- ns, c <- childrenOf n, c `notElem` ns ])

-- | A frontier region: the unowned interval it opens, with its
-- subtree Kraft mass (the rectangle bound's mass term). CONTRACT:
-- 'regions' aligns index-wise with 'frontier' — the i-th region is
-- the i-th candidate's subtree (probes pair them by zip).
data Region = Region
  { rLoTheta :: Double
  , rHiTheta :: Double
  , rMass    :: Double
  }
  deriving (Eq, Show)

regions :: Owned -> [Region]
regions o =
  [ Region lo hi (kraftSubtree c)
  | c <- frontier o, let (lo, hi) = spanOf c ]

-- sum_{m >= m0} 2^-gammaLen(m), exact by octaves: octave b (the
-- integers [2^b, 2^(b+1))) contributes 2^b * 2^-(2b+1) = 2^-(b+1).
gammaTail :: Integer -> Double
gammaTail m0 =
  let b0   = ilog2 m0
      full = 2 ^^ negate (b0 + 1)
      pre  = fromInteger (m0 - 2 ^ b0) * 2 ^^ negate (2 * b0 + 1)
      rest = 2 ^^ negate (b0 + 1)
  in (full - pre) + rest

-- | Kraft mass of the subtree at (and below) a node, closed form
-- (row g5 pins it against enumerated partials):
--   gap node (extent-mag e, depth k >= 1): depth k+d has 2^d nodes
--   costing sign + gamma(e+1) + gamma(k+d+1) + (k+d-1); the position
--   count cancels the position bits per level, so the sum telescopes
--   to 2^-(1+gamma(e+1)) * 2^(1-k) * gammaTail(k+1) — exact.
--   extent node j0: the outward chain plus each extent's inner-gap
--   subtree; the chain truncates at +2000 extents (undercount only —
--   conservative for the Kraft row; transcribed at III.6).
kraftSubtree :: Node -> Double
kraftSubtree n@(Node _ k)
  | k >= 1 =
      2 ** negate (1 + gammaLen (extentMag n + 1))
        * (2 ^^ (1 - k)) * gammaTail (fromIntegral k + 1)
  | otherwise = extChain (extentMag n)

extChain :: Integer -> Double
extChain j0 =
  sum [ 2 ** negate (1 + gammaLen (j + 1) + 1) + gapMassAt j
      | j <- [j0 .. j0 + 2000] ]
  where
    -- extent j's gap child keys on magnitude j (the gap it refines):
    -- its subtree mass is the k = 1 gap closed form anchored at j
    gapMassAt j = 2 ** negate (1 + gammaLen (j + 1)) * gammaTail 2

-- | The canonical scorer: the posterior over an owned set given the
-- permanent counts (n1, n0), a pure function of (dl, n1, n0) per
-- node, built through the sealed reasoner's own prior door
-- ('fromBits': dl + n1*(-log2 th) + n0*(-log2 (1-th)) per node) —
-- one construction, one normalization, canonical code order
-- (METAREASONING_PLAN.md:143-150; ruling R5's scope, r-author-pack
-- I.7). The n1 weight term is the row-10 ablation's marked anchor.
scoreOwned :: Owned -> (Int, Int) -> Belief Double
scoreOwned o (n1, n0) =
  case nonEmpty (map nodeTheta (ownedNodes o)) of
    Nothing  -> error "scoreOwned: the owned set is never empty (root closure)"
    Just pts ->
      fromBits (mkSpace pts)
        (\th -> Bits ( bitsAt th
                     + fromIntegral n1 * negate (logBase 2 th)
                     + fromIntegral n0 * negate (logBase 2 (1 - th)) ))
  where
    bitsAt th =
      case [ gammaBits n | n <- ownedNodes o, nodeTheta n == th ] of
        (b : _) -> b
        []      -> error "scoreOwned: theta not in the owned set"

likeAt :: Int -> Int -> Double -> Double
likeAt n1 n0 th = th ^^ n1 * (1 - th) ^^ n0

-- sup over an interval of the Bernoulli likelihood (unimodal at
-- n1/(n1+n0); the sup is the value at the clip point).
supLike :: Int -> Int -> (Double, Double) -> Double
supLike n1 n0 (a, b) =
  let m | n1 + n0 == 0 = b
        | otherwise    = fromIntegral n1 / fromIntegral (n1 + n0)
      p = max a (min b m)
  in likeAt n1 n0 p

uOf :: (Double, Double) -> Double -> Double
uOf (sR, sW) th = sR * th + sW * (1 - th)

-- | The region guard's expectation under a placement: True =
-- pessimistic, False = optimistic — every region placed at
-- (sup-likelihood, endpoint-extremum utility), the rectangle bound
-- that IS the law's text (METAREASONING_PLAN.md:177-181), region
-- form per R-R3. Stakes as (sRight, sWrong); utility linear, so
-- endpoint evaluation is the Bernoulli-instance license (:181-186).
guardE :: Bool -> Owned -> (Int, Int) -> (Double, Double) -> Double
guardE pess o (n1, n0) st =
  let ws   = [ (2 ** negate (gammaBits n) * likeAt n1 n0 th, th)
             | n <- ownedNodes o, let th = nodeTheta n ]
      num0 = sum [ w * uOf st th | (w, th) <- ws ]
      den0 = sum [ w | (w, _) <- ws ]
      pick (Region a b m) =
        let l  = supLike n1 n0 (a, b)
            us = [uOf st a, uOf st b]
            u  = if pess then minimum us else maximum us
        in (m * l * u, m * l)
      parts = map pick (regions o)
  in (num0 + sum (map fst parts)) / (den0 + sum (map snd parts))

-- | The straddle: pessimistic <= 0 < optimistic — the owned decision
-- is not robust to admissible placements of unowned mass; the agent
-- buys or abstains, never responds (the criterion's derivation,
-- R_SCOPE section 3 as amended).
straddles :: Owned -> (Int, Int) -> (Double, Double) -> Bool
straddles o c st = guardE True o c st <= 0 && guardE False o c st > 0
