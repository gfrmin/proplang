-- | PropLang.Purchase — the joint purchase law (boundary R,
-- increment R1; re-founded exact at the dyadic increment, the X.5
-- sitting's rulings 1-3 sealed at x5-sitting-r0).
--
-- Type-derivation audit (the step-6 clause):
--   'PurchaseWorld' — the world's ECONOMICS row and nothing else
--       (the alignment statement): stakes, an optional refine
--       surcharge, and the rung ladder's cap — ALL world-declared.
--       'pwLadderCap' lands the X.3 repair the record claimed
--       (x5 pack 3.4, ruling 2): the ladder's reach is world
--       economics the caller declares, never a baked constant.
--   'PTick' — unchanged seat: the purchase log is part of the
--       transcript; a tick row prints the act, what was bought,
--       and the complete owned set.
--
-- Option order (ruling R-R2, unchanged): wait is the head (A5,
-- ties break to inaction), externals follow, internal acts LAST.
-- An internal act fires only by strictly beating every external
-- option (CL-3 first-listed-wins preserved end to end).
--
-- The refine option is a Maybe ARM of the fold, present only when
-- the world declares a refine row AND the straddle fires — the
-- last skip-on-negInf sentinel left src with the exact re-founding
-- (X.5 ruling 3, candidate 5: no -Infinity in shipped source; an
-- absent option is absent, never a poisoned value).
module PropLang.Purchase
  ( PurchaseWorld (..)
  , PTick (..)
  , runPurchase
  , purchasePredictive
  ) where

import Data.List.NonEmpty (nonEmpty)
import PropLang.Belief
  ( Belief, Space, fromWeights, kernel, mkSpace, push
  )
import PropLang.Lattice
  ( Node, Owned, frontier, guardE, mkOwned, nodeTheta, ownedNodes
  , scoreOwned, straddles
  )

-- | The world's side of the purchase law: economics only, EXACT.
data PurchaseWorld = PurchaseWorld
  { pwStakes :: (Rational, Rational)
    -- ^ (sRight, sWrong): the respond stakes row, wire rationals
  , pwRefine :: Maybe Rational
    -- ^ Nothing = no refine row: STATIC vocabulary; Just s = the
    -- optional surcharge charged ABOVE the clock
  , pwLadderCap :: Rational
    -- ^ the rung ladder's reach when the clock is free — WORLD
    -- ECONOMICS, declared by the caller (the X.3 repair landed;
    -- the baked kLadder constant is dead)
  }
  deriving (Eq, Show)

-- | One transcript row: the act taken, the nodes bought this tick,
-- and the COMPLETE owned set after the tick.
data PTick = PTick
  { ptAct    :: String
  , ptBought :: [Node]
  , ptOwned  :: [Node]
  }
  deriving (Eq, Show)

-- | The pure tick loop of the joint law: one decision rule per tick
-- over [wait, respond, refine] in the pinned order, counts advanced
-- by the evidence, purchases by the region-derived criterion (the
-- VALUE-BASED candidate), the refine arm present only when priced
-- and straddling (d6.1-d6.4; the root-vocabulary deep-stakes
-- deadlock of the max-0 clamp is the BANKED observation,
-- EXACT_PLAN 13.3 — re-executed against this module at the
-- increment close, the trampoline boundary's design input).
runPurchase :: PurchaseWorld -> Owned -> [Int] -> [PTick]
runPurchase w owned0 obsStream = go owned0 (0, 0) obsStream
  where
    st = pwStakes w

    go :: Owned -> (Int, Int) -> [Int] -> [PTick]
    go _ _ [] = []
    go o (a, b) (y : ys) =
      let c' = if y == (1 :: Int) then (a + 1, b) else (a, b + 1)
          respondV = guardE True o c' st
          forgone  = max 0 respondV
          (cand, gain) = bestCandidate o c'
          mRefine = case pwRefine w of
            Just s | straddles o c' st ->
              Just (pwLadderCap w * gain - s - forgone)
            _ -> Nothing
          -- the pinned order: wait head, externals, internal acts
          -- LAST; strict-improvement first-listed fold (CL-3)
          chosen = foldl pick ("wait", 0)
                     (("respond", respondV)
                       : maybe [] (\v -> [("refine", v)]) mRefine)
          pick (bn, bv) (n2, v2) = if v2 > bv then (n2, v2) else (bn, bv)
      in case fst chosen of
           "refine" ->
             let o' = mkOwned (cand : ownedNodes o)
             in PTick "refine" [cand] (ownedNodes o') : go o' c' ys
           nm -> PTick nm [] (ownedNodes o) : go o c' ys

    -- the value-based candidate: the frontier node whose ownership
    -- most improves the guarded act value at the current counts
    bestCandidate :: Owned -> (Int, Int) -> (Node, Rational)
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

-- | The predictive after purchases: each owned hypothesis's
-- emission through the sentence fragment, weight form through the
-- sole introducer, the obs carrier DECLARED BY THE CALLER (E3) —
-- and now the theta column is the EXACT coordinate: no realToFrac,
-- no binary64 embed, the Bernoulli masses are the sayable rationals
-- themselves.
purchasePredictive :: Space Int -> Owned -> (Int, Int) -> Belief Int
purchasePredictive obsSp o c =
  case nonEmpty (map nodeTheta (ownedNodes o)) of
    Nothing  -> error "purchasePredictive: the owned set is never empty"
    Just pts ->
      push (scoreOwned o c) (kernel (mkSpace pts) obsSp bern)
  where
    bern th =
      case fromWeights obsSp
             (\y -> if y == (1 :: Int) then th else 1 - th) of
        Just b  -> b
        Nothing -> error "purchasePredictive: no mass (unreachable: interior theta)"
