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
-- The refine-before-think RELATIVE order is a fresh declared choice
-- in the alphabet-residue class: pinned, arbitrary unless derived
-- (freeze rider 1, 2026-07-21). The durable-good rationale — at an
-- EU tie, buy the permanent vocabulary over the per-tick
-- deliberation product — is recorded AS RATIONALE, not derivation;
-- a future boundary may derive or overturn it (the prefix code sat
-- in this class for nine days before R-R1 derived it).
--
-- Prices: refine costs the clock (act-now EU forgone, endogenous —
-- METAREASONING_PLAN.md:205-215, no new number) plus the world's
-- optional surcharge; think-deeper costs the clock per rung (the
-- step-10 composition's Get "price", the same law at the depth
-- object). A world with NO refine row keeps a static vocabulary —
-- the tagged migration residue (:218-226), one-sided retirement
-- license, retired when the executable condition fires.
--
-- The overlay's rung ladder (free clock when acting now forfeits
-- nothing) is the shipped realization; the full rung LAW over
-- arbitrary priced depth is the choice machinery this cap
-- approximates — its refinement is R1 implementation freedom bounded
-- by the frozen rows (the myopic one-tick case, the recurring-stakes
-- buy, the order pin).
module PropLang.Purchase
  ( PurchaseWorld (..)
  , PTick (..)
  , runPurchase
  , purchasePredictive
  ) where

import Data.List.NonEmpty (nonEmpty)
import PropLang.Belief
  ( Belief, Bits (..), fromBits, kernel, mkSpace, push
  )
import PropLang.Enumerate (Obs, obsSpace)
import PropLang.Lattice
  ( Node, Owned, frontier, guardE, mkOwned, nodeTheta, ownedNodes
  , scoreOwned, straddles
  )

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

-- the rung ladder's reach when the clock is free (respond blocked
-- => act-now EU forgone is zero, so deliberating costs nothing and
-- the ladder climbs to its cap; module header note)
kLadder :: Double
kLadder = 16

-- | The pure tick loop of the joint law: one decision rule per tick
-- over [wait, respond, refine, think-deeper] in the pinned order,
-- counts advanced by the evidence, purchases by the region-derived
-- criterion (R-R3: region-level straddle; the purchase's own
-- granularity is implementation freedom — realized here as the
-- VALUE-BASED candidate, the frontier node whose ownership most
-- improves the guarded act value; cheapest-first fails, the cheap
-- rungs are the worthless ones, pack III.7), depth by the rung law.
runPurchase :: PurchaseWorld -> Owned -> [Obs] -> [PTick]
runPurchase w owned0 obsStream = go owned0 (0, 0) obsStream
  where
    st = pwStakes w

    go :: Owned -> (Int, Int) -> [Obs] -> [PTick]
    go _ _ [] = []
    go o (a, b) (y : ys) =
      let c' = if y == (1 :: Obs) then (a + 1, b) else (a, b + 1)
          respondV = guardE True o c' st
          forgone  = max 0 respondV
          (cand, gain) = bestCandidate o c'
          refineV = case pwRefine w of
            Nothing -> negInf
            Just s
              | straddles o c' st -> kLadder * gain - s - forgone
              | otherwise         -> negInf
          -- the pinned order: wait head, externals, internal acts
          -- LAST; strict-improvement first-listed fold (CL-3)
          chosen = foldl pick ("wait", 0)
                     [ ("respond", respondV), ("refine", refineV) ]
          pick (bn, bv) (n2, v2) = if v2 > bv then (n2, v2) else (bn, bv)
      in case fst chosen of
           "refine" ->
             let o' = mkOwned (cand : ownedNodes o)
             in PTick "refine" [cand] (ownedNodes o') : go o' c' ys
           nm -> PTick nm [] (ownedNodes o) : go o c' ys

    negInf = -1 / 0

    -- the value-based candidate: the frontier node whose ownership
    -- most improves the guarded act value at the current counts
    bestCandidate :: Owned -> (Int, Int) -> (Node, Double)
    bestCandidate o c' =
      let base = max 0 (guardE True o c' st)
          val c = max 0 (guardE True (mkOwned (c : ownedNodes o)) c' st)
                    - base
      in case frontier o of
           []       -> (errNoFrontier, 0)
           (f : fs) -> foldl (\(bc, bv) c ->
                                let v = val c
                                in if v > bv then (c, v) else (bc, bv))
                             (f, val f) fs

    errNoFrontier :: Node
    errNoFrontier = error "the lattice frontier is never empty"

-- | The predictive after purchases: each owned hypothesis's emission
-- comes from its own code through the sentence fragment — vocabulary
-- motion moves the kernel (row g11; the R0 hand-built-kernel
-- confession is this door's provenance). The Bernoulli form is the
-- fragment's frozen instance (Enumerate.hs emit/bernFast:
-- p(y=1|th) = th), reached through the sealed reasoner's own doors.
purchasePredictive :: Owned -> (Int, Int) -> Belief Obs
purchasePredictive o c =
  case nonEmpty (map nodeTheta (ownedNodes o)) of
    Nothing  -> error "purchasePredictive: the owned set is never empty"
    Just pts ->
      push (scoreOwned o c) (kernel (mkSpace pts) obsSpace bern)
  where
    bern th = fromBits obsSpace
      (\y -> Bits (if y == (1 :: Obs)
                    then negate (logBase 2 th)
                    else negate (logBase 2 (1 - th))))
