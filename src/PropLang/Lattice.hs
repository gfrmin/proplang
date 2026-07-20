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
--
-- ORACLE-PHASE STUBS: bodies that raise are the red mechanism
-- (runtime-red against a compile-enabling surface); they are
-- replaced in the implementation phase and none survives the
-- increment.
module PropLang.Lattice
  ( Node
  , rootNode
  , nodeLambda
  , nodeTheta
  , gammaBits
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

import PropLang.Belief (Belief)

-- | A lattice node: log-odds lambda = num / 2^depth, in lowest terms
-- (depth == 0 or num odd — the canonical dyadic representation).
-- Constructor unexported: nodes arise from 'rootNode' and 'frontier'
-- only, so every reachable node is lattice-lawful by construction.
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

-- | THE frozen pricing formula (R-R1: Elias-gamma on extent, plus
-- the refinement-path cost). Its pinned values derive at the freeze
-- from the prototype under the ruled code (R-D21), never here.
gammaBits :: Node -> Double
gammaBits = stub "gammaBits"

-- | A finite owned set of lattice nodes (the materialized part of
-- the fixed priced space). Abstract: 'mkOwned' is the only door in,
-- so canonical code order is a representation invariant, not a
-- caller obligation.
newtype Owned = Owned [Node]
  deriving (Eq, Show)

mkOwned :: [Node] -> Owned
mkOwned = stub "mkOwned"

ownedNodes :: Owned -> [Node]
ownedNodes (Owned ns) = ns

-- | Frontier candidates: the children (outward extension and inward
-- halving) of owned nodes that are not themselves owned — finite,
-- canonical code order (METAREASONING_PLAN.md:89-91).
frontier :: Owned -> [Node]
frontier = stub "frontier"

-- | A frontier region: the unowned interval it opens, with its
-- subtree Kraft mass (the rectangle bound's mass term).
data Region = Region
  { rLoTheta :: Double
  , rHiTheta :: Double
  , rMass    :: Double
  }
  deriving (Eq, Show)

regions :: Owned -> [Region]
regions = stub "regions"

-- | Closed-form Kraft sum of the unowned subtree below a node,
-- under the ruled gamma pricing (row 7 pins closed form against
-- enumerated partial sums).
kraftSubtree :: Node -> Double
kraftSubtree = stub "kraftSubtree"

-- | The canonical scorer: the posterior over an owned set given the
-- permanent counts (n1, n0), a pure function of (dl, n1, n0) per
-- node, built through the sealed reasoner's own prior door
-- ('fromBits': dl + n1*(-log2 th) + n0*(-log2 (1-th)) per node) —
-- one construction, one normalization, canonical code order
-- (METAREASONING_PLAN.md:143-150; ruling R5's scope, r-author-pack
-- I.7).
scoreOwned :: Owned -> (Int, Int) -> Belief Double
scoreOwned = stub "scoreOwned"

-- | The region guard's expectation under a placement: False =
-- optimistic, True = pessimistic — every region placed at
-- (sup-likelihood, endpoint-extremum utility), the rectangle bound
-- that IS the law's text (METAREASONING_PLAN.md:177-181), region
-- form per R-R3. Stakes as (sRight, sWrong); utility linear, so
-- endpoint evaluation is the Bernoulli-instance license (:181-186).
guardE :: Bool -> Owned -> (Int, Int) -> (Double, Double) -> Double
guardE = stub "guardE"

-- | The straddle: pessimistic <= 0 < optimistic — the owned decision
-- is not robust to admissible placements of unowned mass; the agent
-- buys or abstains, never responds (the criterion's derivation,
-- R_SCOPE section 3 as amended).
straddles :: Owned -> (Int, Int) -> (Double, Double) -> Bool
straddles = stub "straddles"

-- oracle-phase red mechanism (no forbidden token, no IO)
stub :: String -> a
stub name = error ("R1 oracle phase: " ++ name ++ " not implemented")
