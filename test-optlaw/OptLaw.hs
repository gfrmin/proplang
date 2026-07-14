-- | test-optlaw/OptLaw.hs — step 2's increment oracle (AGENT_PLAN §7
-- step 2, scope PINNED 2026-07-15 decision 3): THE OPTIMISATION LAW,
-- ENFORCED. This suite is the pin for the §1b audit table's one
-- unpinned row.
--
-- The law (COPIED from AGENT_PLAN.md:113-115, R-D20-i):
--
--   "Any evaluator fast path is legal iff a property pins it,
--    extensionally, to the general route. Enforced, never trusted. It
--    buys speed, never semantics — and it never enters the alphabet,
--    so it never touches the prior."
--
-- The required property (COPIED from AGENT_PLAN.md:135, R-D20-i):
--
--   "observeCounts == n1 then n0 repeated observe's becomes a REQUIRED
--    property."
--
-- The pinned fast path: 'observeCounts' (src/PropLang/Enumerate.hs:680
-- as built; the section-1b table's cite :649 is stale). Its sequential
-- reference is the general route itself — 'observe' (Enumerate.hs:476)
-- for the carried-channel route, 'observeVia' (Enumerate.hs:722) for
-- the supplied-emission route — folded over n1 ones THEN n0 zeros, the
-- frozen sentence's order.
--
-- DOMAIN: the pin binds on EXCHANGEABLE (iid-emission) hypotheses,
-- exactly where the fast path's own contract claims exactness
-- (Enumerate.hs:667: "EXACT for exchangeable (iid-emission)
-- hypotheses"). For state-carrying hypotheses (hmm / UWalk) the
-- collapse IS the declared warm-flattening approximation
-- (Enumerate.hs:667-670; R-D23's segmentation ruling) — gBoundary
-- below MEASURES that boundary: the pin's predicate holds at n1+n0 <=
-- 1 on state-carrying agents and is REFUTED (same predicate, negated,
-- no new literal) from the first genuinely collapsed pair (1,1)
-- onward. The domain restriction is load-bearing, and now measured
-- rather than asserted.
--
-- TOLERANCE PROVENANCE (the author's residue-before-tolerance ruling,
-- decision 3, 2026-07-15: "the pin must not be born with a round
-- number; that is how the 1e-9 happened"): bit-exactness is REFUTED by
-- measurement (residue 1.11e-16 nats at (n1,n0) = (1,0) already).
-- Measured over the frozen worlds below across the full count ladder
-- up to the frozen corpus pair (30000, 9314) (test-d/D.hs:1044-1049),
-- step-2 pack §2: max relative evidence residue 2.8266e-13 (at the
-- corpus pair), max posterior residue 9.40e-14 (at (1000, 314)). The
-- gates are 1e-11 in CL-4's own relative form for evidence and 1e-11
-- absolute per posterior point: headroom x35 and x106 over the
-- measured maxima — measured floor plus documented headroom, the
-- repaired-CL-4 idiom, never a number chosen before measurement.
--
-- Every generator below is a byte-wise copy from the frozen corpus
-- (R-D20-i), provenance per definition. Every asserted (n1, n0) pair
-- has an executed line in the step-2 pack's residue transcript
-- (R-D21); the transcript forced the reference side of every
-- comparison to normal form independently of the fast side (one
-- deepseq per row — the ruled mechanical form, decision 4).
module Main (main) where

import Control.Monad (forM_)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief (LogProb (LogProb), Space, is, mkSpace, prob)
import PropLang.Enumerate (Agent, Obs, TauSpec, UFamily (..), agentMeta,
                           agentModels, allTerminals, allUFamilies, emit,
                           enumerateModels, enumerateUModels, mkAgent,
                           mkTauSpec, observe, observeCounts, observeVia,
                           verdictKernel)
import PropLang.Eval (Features)
import PropLang.Syntax (Grid, mkGrid)

main :: IO ()
main = defaultMain $ testGroup "optlaw — the section-1b pin"
  [ gPin
  , gBoundary
  ]

-- ---------------------------------------------------------------------
-- the frozen generators (byte-wise copies, R-D20-i)
-- ---------------------------------------------------------------------

-- COPIED test-d/D.hs:435-436
uGridD :: Grid
uGridD = mkGrid "ubar" (0.1 :| [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9])

-- COPIED test-d/D.hs:438-439
rhoUGrid :: Grid
rhoUGrid = mkGrid "rho_u" (0.01 :| [0.02, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5])

-- COPIED test-d/D.hs:754-758
tauSpecD :: TauSpec
tauSpecD = case mkTauSpec (mkGrid "tau" (0.5 :| [1, 2]))
                          (0.5 :| [0.3, 0.2]) of
  Just s  -> s
  Nothing -> error "covering spec must construct"

-- COPIED test-d/D.hs:588-589
uAgent0 :: [UFamily] -> Agent
uAgent0 fams = mkAgent (enumerateUModels emit uGridD rhoUGrid fams)

-- COPIED test-d/D.hs:793-794
worldAgent0 :: Agent
worldAgent0 = mkAgent (enumerateModels allTerminals)

-- COPIED test-d/D.hs:796-799
pointerAgent0 :: Agent
pointerAgent0 =
  mkAgent (enumerateUModels (verdictKernel uGridD tauSpecD)
                            uGridD rhoUGrid [UConst])

-- The frozen observe_counts row's features (test-d/D.hs:1042-1044:
-- features {"t":1,"x":1}) and its corpus counts (test-d/D.hs:1049:
-- (30000, 9314)) — the count ladder ends at the corpus pair.
featsD :: Features
featsD = [("t", 1), ("x", 1)]

countLadder :: [(Int, Int)]
countLadder = [ (0, 0), (1, 0), (0, 1), (1, 1), (3, 2), (10, 7)
              , (31, 10), (100, 31), (314, 100), (1000, 314)
              , (3000, 931), (10000, 3141), (30000, 9314) ]

-- the boundary pairs: the pin's predicate must HOLD at n1+n0 <= 1 and
-- be REFUTED at the first genuinely collapsed pairs on state-carrying
-- agents (measured divergence 0.2029 / 0.3259 nats on worldAgent0,
-- pack §2 — asserted here only as the negated pin predicate)
holdPairs, refutePairs :: [(Int, Int)]
holdPairs   = [(0, 0), (1, 0), (0, 1)]
refutePairs = [(1, 1), (3, 2)]

-- ---------------------------------------------------------------------
-- the pin's two gates (tolerance provenance in the header)
-- ---------------------------------------------------------------------

tolEv, tolPost :: Double
tolEv   = 1e-11   -- relative, CL-4's form; measured max 2.8266e-13
tolPost = 1e-11   -- absolute per posterior point; measured max 9.40e-14

-- the sequential reference: n1 ones THEN n0 zeros (the frozen order),
-- log-evidence accumulated tick by tick
seqRef :: (Obs -> Agent -> Maybe (LogProb, Agent))
       -> Int -> Int -> Agent -> Maybe (Double, Agent)
seqRef step n1 n0 = go (replicate n1 1 ++ replicate n0 0) 0
  where
    go []       acc ag = Just (acc, ag)
    go (y : ys) acc ag = case step y ag of
      Just (LogProb lp, ag') ->
        let acc' = acc + lp in acc' `seq` go ys acc' ag'
      Nothing -> Nothing

-- the posterior read through the public surface only
metaProbs :: Agent -> [Double]
metaProbs ag =
  let n = length (agentModels ag)
      sp = mkSpace (0 :| [1 .. n - 1]) :: Space Int
  in [ prob (agentMeta ag) (is sp i) | i <- [0 .. n - 1] ]

-- the pin predicate, whole: batch evidence within tolEv of the
-- sequential sum (relative), every posterior point within tolPost
pinHolds :: (Double, Agent) -> (Double, Agent) -> Bool
pinHolds (lpB, agB) (lpS, agS) =
  abs (lpB - lpS) <= tolEv * (1 + abs lpS)
    && and (zipWith (\a b -> abs (a - b) <= tolPost)
                    (metaProbs agB) (metaProbs agS))

-- both gates' readings, for failure messages
detail :: (Double, Agent) -> (Double, Agent) -> String
detail (lpB, agB) (lpS, agS) =
  "batch lp " ++ show lpB ++ " vs sequential " ++ show lpS
    ++ "; max posterior diff "
    ++ show (maximum (0 : zipWith (\a b -> abs (a - b))
                                  (metaProbs agB) (metaProbs agS)))

runBoth :: (Features -> Int -> Int -> Agent -> Maybe (LogProb, Agent))
        -> (Obs -> Agent -> Maybe (LogProb, Agent))
        -> Agent -> (Int, Int) -> ((Double, Agent), (Double, Agent))
runBoth batch step ag (n1, n0) =
  case (batch featsD n1 n0 ag, seqRef step n1 n0 ag) of
    (Just (LogProb lpB, agB), Just (lpS, agS)) -> ((lpB, agB), (lpS, agS))
    _ -> error "a frozen-world route answered impossible-evidence"

pinCase :: String -> Agent
        -> (Features -> Int -> Int -> Agent -> Maybe (LogProb, Agent))
        -> (Obs -> Agent -> Maybe (LogProb, Agent))
        -> [(Int, Int)] -> TestTree
pinCase name ag batch step ps = testCase name $
  forM_ ps $ \p@(n1, n0) ->
    let (bres, sres) = runBoth batch step ag p
    in assertBool ("pin fails at (" ++ show n1 ++ ", " ++ show n0
                     ++ "): " ++ detail bres sres)
                  (pinHolds bres sres)

refuteCase :: String -> Agent
           -> (Features -> Int -> Int -> Agent -> Maybe (LogProb, Agent))
           -> (Obs -> Agent -> Maybe (LogProb, Agent))
           -> [(Int, Int)] -> TestTree
refuteCase name ag batch step ps = testCase name $
  forM_ ps $ \p@(n1, n0) ->
    let (bres, sres) = runBoth batch step ag p
    in assertBool ("the flattening vanished at (" ++ show n1 ++ ", "
                     ++ show n0 ++ "): " ++ detail bres sres
                     ++ " — batch equals sequential within the "
                     ++ "exchangeable gate on a state-carrying agent; "
                     ++ "the domain boundary moved; stop and report")
                  (not (pinHolds bres sres))

-- ---------------------------------------------------------------------
-- gPin — the section-1b required property, exchangeable domain
-- ---------------------------------------------------------------------

gPin :: TestTree
gPin = testGroup "gPin observeCounts == n1-then-n0 repeated observe's"
  [ pinCase "pointerAgent0, carried channel (verdict route)"
      pointerAgent0 (observeCounts Nothing) (observe featsD) countLadder
  , pinCase "uAgent0 [UConst], carried channel (gDegeneracy generator)"
      (uAgent0 [UConst]) (observeCounts Nothing) (observe featsD)
      countLadder
  , pinCase "pointerAgent0, supplied emission (outcome route, emit)"
      pointerAgent0 (observeCounts (Just emit)) (observeVia emit featsD)
      countLadder
  ]

-- ---------------------------------------------------------------------
-- gBoundary — the declared flattening, measured at its edge
-- ---------------------------------------------------------------------

gBoundary :: TestTree
gBoundary = testGroup "gBoundary the exchangeable restriction is load-bearing"
  [ pinCase "worldAgent0 (8 MHmm): exact while nothing is collapsed"
      worldAgent0 (observeCounts Nothing) (observe featsD) holdPairs
  , refuteCase "worldAgent0 (8 MHmm): refuted from the first collapsed pair"
      worldAgent0 (observeCounts Nothing) (observe featsD) refutePairs
  , pinCase "uAgent0 allUFamilies (8 UWalk): exact while nothing is collapsed"
      (uAgent0 allUFamilies) (observeCounts Nothing) (observe featsD)
      holdPairs
  , refuteCase "uAgent0 allUFamilies (8 UWalk): refuted from the first collapsed pair"
      (uAgent0 allUFamilies) (observeCounts Nothing) (observe featsD)
      refutePairs
  ]
