{-# LANGUAGE DataKinds #-}
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
-- The refine option is a row present only when the world declares
-- one; since the trampoline boundary (register R7, RULED at
-- trampoline-freeze-r0: the fold dies) its straddle gate and max-0
-- forgone are said IN-SENTENCE — If/Gt arms inside the one standing
-- chooseKS sentence — never folded host-side. The no-poisoned-value
-- line (X.5 ruling 3, candidate 5) holds as before: an absent
-- option is an absent row, never -Infinity.
module PropLang.Purchase
  ( PurchaseWorld (..)
  , PTick (..)
  , purchaseRows
  , runPurchase
  , runPurchaseS
  , purchasePredictive
  ) where

import Data.List.NonEmpty (NonEmpty ((:|)), nonEmpty)
import PropLang.Belief
  ( Belief, Space, fromWeights, kernel, mkSpace, push
  )
import PropLang.Eval (Features, Vals (..), evalx, mkEnvIn)
import PropLang.Lattice
  ( Node, Owned, frontier, guardE, mkOwned, nodeTheta, ownedNodes
  , scoreOwned
  )
import PropLang.Syntax

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
    --
    -- FROZEN-IN-PLACE at the #19 sitting (doctrine-sitting-r0,
    -- 2026-08-08): JP2-d6's RETIRE-UNTIL-N row returned here as
    -- scheduled and ruled — no live consumer arrives on any horn
    -- (zero src consumers outside this module; EV-JP4/JP8
    -- forecloses the JointWorld carry-over: the cap was the baked
    -- horizon, and the horizon is the declared stream's length).
    -- Deletion was DECLINED, not earned: it would owe the
    -- four-check proof, which was not run. This field and its one
    -- use (capM below) stay as the myopic face's pins; the five
    -- frozen fixture pins at 16 (test-dyadic four sites, test-f5
    -- one) are KEPT-AS-RECORD in the frozen suites.
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

-- | The tick loop of the joint law: one decision rule per tick over
-- [wait, respond, refine] in the pinned order, counts advanced by
-- the evidence, purchases by the region-derived criterion (the
-- VALUE-BASED candidate), the refine arm present only when priced
-- (its straddle gate said in-sentence; d6.1-d6.4; the
-- root-vocabulary deep-stakes deadlock of the max-0 clamp is the
-- BANKED observation, EXACT_PLAN 13.3 — re-executed against this
-- module at the dyadic close, documented by trampoline g5.4).
--
-- RE-LANDED at the trampoline implementation (register R7, RULED:
-- "the fold dies"): the body IS the sentence route, reached through
-- an INERT internal door — the frozen d6 suite's signature carries
-- no door, and trampoline g5's payload-independence row pins that
-- the door is R5 ceremony, not data (the sentence reads no
-- features). The door's shape is a COPY of the oracle's fixture
-- (test-trampoline/Trampoline.hs pNs/pFeats: a single neutral
-- declared name). The unwrap is total: the covering door cannot
-- refuse, and off-code dispatch is unreachable (both branches carry
-- the error text that says so).
runPurchase :: PurchaseWorld -> Owned -> [Int] -> [PTick]
runPurchase w owned0 obsStream =
  case runPurchaseS doorNs doorFeats w owned0 obsStream of
    Right ticks -> ticks
    Left m -> error ("runPurchase (unreachable: the door covers) " ++ m)
  where
    doorNs = mkNamespace ("door" :| [])
    doorFeats = [("door", 0)]

-- | The joint purchase law THROUGH THE ONE SENTENCE (the trampoline
-- boundary, EXACT_PLAN 13.3): the same law as 'runPurchase' with the
-- per-tick choice re-homed into a single standing chooseKS sentence —
-- wait head (a zero mention), respond (the bound pessimistic guard),
-- refine LAST (the straddle gate and the max-0 forgone both said as
-- If/Gt inside the sentence; the engine binds only the guard scalars
-- pess/opt/gain). The caller passes the door payload (namespace +
-- covering features), per R5: every evalx passes a door. Pinned
-- extensionally to 'runPurchase' by test-trampoline g5 (the d6-cell
-- transcripts, act-for-act).
-- | The standing per-tick sentence's ROWS, as data. Exported at the
-- completeness boundary's F5 increment so the sentence's PRICE is
-- readable through the pricing artifact (weightIn over
-- @chooseKS (purchaseRows w)@) — the agent criterion: the sentence,
-- not the engine, is the normative object, and its price is part of
-- its meaning. No new type, no behavior motion: 'runPurchaseS'
-- consumes exactly this construction.
purchaseRows :: PurchaseWorld
             -> NonEmpty ( Expr '[Rational, Rational, Rational] Rational
                         , Expr '[Rational, Rational, Rational] Rational )
purchaseRows w = rows
  where
    mintQ v = case mkC (mkGrid "k" (v :| [])) 0 of
      Just e  -> e
      Nothing -> error "purchaseRows: singleton mint (unreachable)"
    codeM i = case mkC (mkGrid "pacts" (0 :| [1, 2])) i of
      Just e  -> e
      Nothing -> error "purchaseRows: on-codebook index (unreachable)"

    zeroM = mintQ 0
    capM = mintQ (pwLadderCap w)
    pessV = Var Z
    optV = Var (S Z)
    gainV = Var (S (S Z))
    -- the straddle gate and the refine formula, said in-sentence:
    -- pess > 0 or opt <= 0 => the neutral zero row (never displaces
    -- the wait incumbent); straddle => cap*gain - s - forgone
    refineRow s =
      If (Gt pessV zeroM) zeroM
        (If (Gt optV zeroM)
            (Sub (Mul capM gainV) (mintQ s))
            zeroM)
    rows = case pwRefine w of
      Nothing -> (codeM 0, zeroM) :| [(codeM 1, pessV)]
      Just s  -> (codeM 0, zeroM) :| [(codeM 1, pessV), (codeM 2, refineRow s)]

runPurchaseS :: Namespace -> Features -> PurchaseWorld -> Owned
             -> [Int] -> Either String [PTick]
runPurchaseS ns feats w owned0 obsStream = go owned0 (0, 0) obsStream
  where
    st = pwStakes w
    policy = chooseKS (purchaseRows w)

    go _ _ [] = Right []
    go o (a, b) (y : ys) = do
      let c' = if y == (1 :: Int) then (a + 1, b) else (a, b + 1)
          pess = guardE True o c' st
          opt = guardE False o c' st
          (cand, gain) = bestCandidateS o c'
      env <- mkEnvIn ns feats (pess :. opt :. gain :. VNil)
      let code = evalx policy env
      case lookup code (zip (map fromIntegral [0 :: Int ..])
                            ["wait", "respond", "refine"]) of
        Just "refine" -> do
          let o' = mkOwned (cand : ownedNodes o)
          rest <- go o' c' ys
          pure (PTick "refine" [cand] (ownedNodes o') : rest)
        Just nm -> do
          rest <- go o c' ys
          pure (PTick nm [] (ownedNodes o) : rest)
        Nothing -> Left "runPurchaseS: off-code dispatch (unreachable)"

    -- the value-based candidate: the frontier node whose ownership
    -- most improves the guarded act value at the current counts
    -- (the law's engine data — the refine row's PAYLOAD, like the
    -- guard's supLike clip, never a tick-act choice; register R2)
    bestCandidateS o c' =
      let base = max 0 (guardE True o c' st)
          val c = max 0 (guardE True (mkOwned (c : ownedNodes o)) c' st)
                    - base
      in case frontier o of
           []       -> (errNoFrontierS, 0)
           (f : fs) -> foldl (\(bc, bv) c ->
                                let v = val c
                                in if v > bv then (c, v) else (bc, bv))
                             (f, val f) fs

    errNoFrontierS :: Node
    errNoFrontierS = error "the lattice frontier is never empty"

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
