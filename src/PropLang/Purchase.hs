-- | PropLang.Purchase — the joint purchase law (boundary R,
-- increment R1): ONE decision rule pricing external acts and the two
-- internal acts (refine, think-deeper) by one clock (ruling R-R2).
--
-- Type-derivation audit (the step-6 clause):
--   'PurchaseWorld' — the world's ECONOMICS row and nothing else
--       (the alignment statement, WIRE_PLAN §5): stakes and an
--       optional refine surcharge. No vocabulary, no grid, no depth
--       — epistemics never cross the wire in either direction.
--   'PTick' — METAREASONING_PLAN.md:309-310 and §8:336-338: the
--       purchase log is part of the transcript; a tick row prints
--       the act, what was bought, and the complete owned set.
--
-- Option order (ruling R-R2 / R_SCOPE §2, drawn ONCE with both
-- internal acts visible): wait is the head (A5, ties break to
-- inaction), the world's external options follow, and the internal
-- acts sit LAST — refine then think-deeper. An internal act fires
-- only by strictly beating every external option (CL-3
-- first-listed-wins preserved end to end). Row g12 pins this.
--
-- Prices: refine costs the clock (act-now EU forgone, endogenous —
-- METAREASONING_PLAN.md:205-215, no new number) plus the world's
-- optional surcharge; think-deeper costs the clock per rung (the
-- step-10 composition's Get "price", the same law at the depth
-- object). A world with NO refine row keeps a static vocabulary —
-- the tagged migration residue (:218-226), one-sided retirement
-- license, retired when the executable condition fires.
--
-- ORACLE-PHASE STUBS: raising bodies are the red mechanism; none
-- survives the increment.
module PropLang.Purchase
  ( PurchaseWorld (..)
  , PTick (..)
  , runPurchase
  , purchasePredictive
  ) where

import PropLang.Belief (Belief)
import PropLang.Enumerate (Obs)
import PropLang.Lattice (Node, Owned)

-- | The world's side of the purchase law: economics only.
data PurchaseWorld = PurchaseWorld
  { pwStakes :: (Double, Double)
    -- ^ (sRight, sWrong): the respond stakes row (utility as world
    -- data, said at the tick's features — the step-8 reading)
  , pwRefine :: Maybe Double
    -- ^ Nothing = no refine row: STATIC vocabulary (the tagged
    -- migration residue); Just s = the optional surcharge charged
    -- ABOVE the clock (class-1 interface data)
  }
  deriving (Eq, Show)

-- | One transcript row: the act taken, the nodes bought this tick
-- (empty when none), and the COMPLETE owned set after the tick (the
-- purchase log printed, never summarized).
data PTick = PTick
  { ptAct    :: String
  , ptBought :: [Node]
  , ptOwned  :: [Node]
  }
  deriving (Eq, Show)

-- | The pure tick loop of the joint law: one decision rule per tick
-- over [wait, respond, refine, think-deeper] in the pinned order,
-- counts advanced by the evidence, purchases by the region-derived
-- criterion (R-R3: region-level straddle; the purchase's own
-- granularity is implementation freedom), depth by the rung law.
runPurchase :: PurchaseWorld -> Owned -> [Obs] -> [PTick]
runPurchase = stub "runPurchase"

-- | The predictive after purchases: each owned hypothesis's emission
-- comes from its own code through the sentence fragment — vocabulary
-- motion moves the kernel (row g11; the R0 hand-built-kernel
-- confession is this door's provenance).
purchasePredictive :: Owned -> (Int, Int) -> Belief Obs
purchasePredictive = stub "purchasePredictive"

-- oracle-phase red mechanism (no forbidden token, no IO)
stub :: String -> a
stub name = error ("R1 oracle phase: " ++ name ++ " not implemented")
