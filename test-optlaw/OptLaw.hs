{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

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
-- The pinned fast path: 'observeCounts'. Its sequential reference is
-- the general route itself — 'observe' for the carried-channel route,
-- 'observeVia' for the supplied-emission route — folded over n1 ones
-- THEN n0 zeros, the frozen sentence's order.
--
-- DOMAIN: the pin binds on EXCHANGEABLE (iid-emission) hypotheses,
-- exactly where the fast path's own contract claims exactness ("EXACT
-- for exchangeable (iid-emission) hypotheses"). For state-carrying
-- hypotheses (walk sentences) the collapse IS the declared
-- warm-flattening approximation (R-D23's segmentation ruling) —
-- gBoundary below MEASURES that boundary: the pin's predicate holds at
-- n1+n0 <= 1 on state-carrying agents and is REFUTED (same predicate,
-- negated, no new literal) from the first genuinely collapsed pair
-- (1,1) onward. The domain restriction is load-bearing, and measured
-- rather than asserted.
--
-- TOLERANCE PROVENANCE (the author's residue-before-tolerance ruling,
-- decision 3, 2026-07-15: "the pin must not be born with a round
-- number; that is how the 1e-9 happened"): bit-exactness is REFUTED by
-- measurement (residue 1.11e-16 nats at (n1,n0) = (1,0) already).
-- Measured over the frozen worlds below across the full count ladder
-- up to the frozen corpus pair (30000, 9314) (test-d/D.hs:1044-1049 at
-- its retirement), step-2 pack §2: max relative evidence residue
-- 2.8266e-13 (at the corpus pair), max posterior residue 9.40e-14 (at
-- (1000, 314)). The gates are 1e-11 in CL-4's own relative form for
-- evidence and 1e-11 absolute per posterior point: headroom x35 and
-- x106 over the measured maxima — measured floor plus documented
-- headroom, the repaired-CL-4 idiom, never a number chosen before
-- measurement. The headroom asymmetry with CL-4's x336/x840 is not an
-- inconsistency (the author's ruling, 6.2): this residue is an N-term
-- summation-order artefact at N = 39k — a different animal from
-- cond's per-operation noise — and fixed generators plus the frozen
-- toolchain make the distribution undriftable.
--
-- THE STEP-3 PORT (delegated freeze edit, sentence-author-pack.md
-- §20.3/§25; the delegation recorded in the freeze commit): the
-- generators below ride the SENTENCE ROUTE — the u-fragment
-- (enumerateUModels / UFamily / TauSpec / verdictKernel) and the
-- Model/Terminal enumeration died at the step-3 boundary. CONTINUITY
-- WAS MEASURED AT == BEFORE THIS EDIT FROZE (the protocol's
-- evidence-programs-before-rulings line): E-s2 executed the ported
-- extensional twins against the old route on all 49 row-instances'
-- quantities — 13,992 floats, ZERO bit-mismatches (pack §15) — so
-- these are the SAME pins over the same floats, not weakened ones;
-- tolEv/tolPost keep their step-2 provenance UNTOUCHED. The u-agents'
-- derivation charges and the sigma-mixture's tau/weight data are now
-- DECLARED WORLD DATA (the §15 scope note), byte-copied below with
-- provenance. Declared deltas from the r0 text, the E-s2 seqRef
-- precedent: (1) the posterior read 'metaProbs' takes the population
-- count as an argument (the sentence agent's public surface has no
-- model list; the count is the generator's own length), threaded
-- through pinHolds/detail/pinCase/refuteCase; (2) constants ride the
-- shape grid (test-code kGrid, value-identical mkC injections);
-- (3) gBoundary's two composition-describing test names say "walk
-- sentences" where r0 said MHmm/UWalk (the lineage is noted in each).
--
-- Every generator below is a byte-wise copy from the frozen corpus
-- (R-D20-i), provenance per definition. Every asserted (n1, n0) pair
-- has an executed line in the step-2 pack's residue transcript
-- (R-D21) and re-executed SAT lines against the step-3 prototype
-- overlay at this port (pack §25); the transcripts forced the
-- reference side of every comparison to normal form independently of
-- the fast side (one deepseq per row — the ruled mechanical form,
-- decision 4).
module Main (main) where

import Control.Monad (forM_)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief (Bits (..), LogProb (LogProb), Space, is, mkSpace,
                        prob)
import PropLang.Enumerate (Agent, Hyp (..), Obs, agentMeta, emit,
                           enumerateSentences, fragFull, observe,
                           observeCounts, observeVia, obsSpace,
                           sentenceAgent)
import PropLang.Eval (Features, Vals (VNil), evalx, mkEnv)
import PropLang.Syntax (Expr (..), Grid, Idx (..), K, Name,
                        gridSize, mkC, mkGrid)

main :: IO ()
main = defaultMain $ testGroup "optlaw -- the section-1b pin"
  [ gPin
  , gBoundary
  ]

-- ---------------------------------------------------------------------
-- the frozen generators, ported to the sentence route (byte-wise
-- copies where the r0 text survives the alphabet, R-D20-i)
-- ---------------------------------------------------------------------

-- COPIED test-d/D.hs:435-436 (via this file's r0 :88-89)
uGridD :: Grid
uGridD = mkGrid "ubar" (0.1 :| [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9])

-- COPIED test-d/D.hs:438-439 (via this file's r0 :92-93)
rhoUGrid :: Grid
rhoUGrid = mkGrid "rho_u" (0.01 :| [0.02, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5])

-- The retired TauSpec's declared data (byte-values from this file's r0
-- :97-98): the tau grid and the weight grid the verdict code's
-- constants ride in on. The sigma-mixture itself is now a CODE (below)
-- — measured cell-bit-identical to the retired 'verdictKernel', 9 u x
-- 2 obs, 0 mismatches (E-s2 Part A, pack §15).
tauGridD, wGridD :: Grid
tauGridD = mkGrid "tau" (0.5 :| [1, 2])
wGridD   = mkGrid "w" (0.5 :| [0.3, 0.2])

-- The frozen observe_counts row's features (test-d/D.hs:1042-1044 at
-- its retirement: features {"t":1,"x":1}) and its corpus counts
-- (test-d/D.hs:1049: (30000, 9314)) — the ladder ends at the corpus
-- pair.
featsD :: Features
featsD = [("t", 1), ("x", 1)]

countLadder :: [(Int, Int)]
countLadder = [ (0, 0), (1, 0), (0, 1), (1, 1), (3, 2), (10, 7)
              , (31, 10), (100, 31), (314, 100), (1000, 314)
              , (3000, 931), (10000, 3141), (30000, 9314) ]

-- the boundary pairs: the pin's predicate must HOLD at n1+n0 <= 1 and
-- be REFUTED at the first genuinely collapsed pairs on state-carrying
-- agents (measured divergence 0.2029 / 0.3259 nats on worldAgent0,
-- step-2 pack §2 — asserted here only as the negated pin predicate)
holdPairs, refutePairs :: [(Int, Int)]
holdPairs   = [(0, 0), (1, 0), (0, 1)]
refutePairs = [(1, 1), (3, 2)]

-- ---------------------------------------------------------------------
-- the code shapes (byte-copies; the emission/move grammar of the
-- sentence route)
-- ---------------------------------------------------------------------

cAtG :: Grid -> Int -> Expr env Double
cAtG g i = case mkC g i of
  Just e  -> e
  Nothing -> error "OptLaw generator: on-grid index refused"

gkC :: Name -> Double -> Expr env Double
gkC nm v = case mkC (mkGrid nm (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "OptLaw generator: singleton grid must construct"

-- the shape grid (COPY of test-code kGrid: 0/1/2/(n-1); the u grid has
-- 9 points like the world emission grid, so kLast = 8 is valid here)
shGrid :: Grid
shGrid = mkGrid "k" (0 :| [1, 2, 8])

k0E, k1E, k2E, kLastE :: Expr env Double
k0E   = cAtG shGrid 0
k1E   = cAtG shGrid 1
k2E   = cAtG shGrid 2
kLastE = cAtG shGrid 3

-- COPY of test-code/Code.hs:252-259 (codeBernV's body) at theta = th
bernBody :: Expr (Obs ': Double ': env) Double
         -> Expr (Obs ': Double ': env) Double
bernBody th = Neg (Div (Log pb) (Log k2E))
  where
    yv = ToR (Var Z)
    pb = If (Gt yv k0E) th (Sub k1E th)

-- The sigma-mixture as a code body over the sentence's latent u.
-- FROZEN-SIDE FORMULA it reproduces (src/PropLang/Enumerate.hs
-- :586-588 at this file's r0; retired at step 3):
--     sigma x = 1 / (1 + exp (negate x))
--     pApprove u = sum (zipWith (\w tau -> w * sigma (u / tau)) wl taus)
--                    / sum wl
-- FLOAT-ORDER NOTE (the tree IS the float order, test-code:193-195):
-- sum = foldl (+) 0 and 0 + x == x bit-exactly for x > 0 (every term
-- is w * sigma > 0), so both sums are the left association
-- Add (Add t1 t2) t3; negate = Neg, exp = Exp, / = Div, and
-- logBase 2 y = Div (Log y) (Log 2) (test-code groups 4-5 pin the
-- correspondences). Measured 18/18 bit-identical to the retired
-- kernel's cells (E-s2 Part A a1).
verdictBody :: Expr (Obs ': Double ': env) Double
verdictBody = bernBody pA
  where
    u :: Expr (Obs ': Double ': env) Double
    u = Var (S Z)
    sigmaAt j = Div (gkC "one" 1)
                    (Add (gkC "one" 1) (Exp (Neg (Div u (cAtG tauGridD j)))))
    term j = Mul (cAtG wGridD j) (sigmaAt j)
    num = Add (Add (term 0) (term 1)) (term 2)
    den = Add (Add (cAtG wGridD 0) (cAtG wGridD 1)) (cAtG wGridD 2)
    pA = Div num den

-- COPY of test-code/Code.hs:198-210 codeWalk with the value space and
-- rate grid substituted to the u grid's (exactly the substitution
-- E-s2 Part A a4 measured 18/18 bit-identical against the retired
-- walkOn on this grid at all 8 rates)
walkCodeU :: Int -> Expr env (Maybe (K Double Double))
walkCodeU j = Code uSpaceD uSpaceD body
  where
    rho = cAtG rhoUGrid j
    -- SINCE STEP 9 (elim-freeze-r0): equality is the If/Gt composition
    -- (E-e2, 0/1225; IsEq deleted). Values bit-identical, so every
    -- observeCounts pin below is untouched — only the move code's
    -- serialization changes.
    eqE a b = If (Gt a b) falseE (If (Gt b a) falseE trueE)
    trueE = Gt k1E k0E
    falseE = Gt k0E k1E
    iv = Pos uSpaceD (Var (S Z))
    jv = Pos uSpaceD (Var Z)
    lo = If (Gt iv k0E)    (Sub iv k1E) (Add iv k1E)
    hi = If (Gt kLastE iv) (Add iv k1E) (Sub iv k1E)
    mass = Add (Add (If (eqE jv iv) (Sub k1E rho) k0E)
                    (If (eqE jv lo) (Div rho k2E) k0E))
               (If (eqE jv hi) (Div rho k2E) k0E)
    body = Neg (Div (Log mass) (Log k2E))

-- ---------------------------------------------------------------------
-- the u sentences (the retired u-agents, declared)
-- ---------------------------------------------------------------------

uPoints :: [Double]
uPoints = [ evalx e (mkEnv [] VNil)
          | j <- [0 .. gridSize uGridD - 1], Just e <- [mkC uGridD j] ]

uSpaceD :: Space Double
uSpaceD = mkSpace $ case uPoints of
  (p : ps) -> p :| ps
  []       -> error "OptLaw: uGridD is nonempty by construction"

-- The u-agents' derivation charges, now DECLARED WORLD DATA. COPY of
-- the retired formulas (src/PropLang/Enumerate.hs:580-585 at this
-- file's r0 — "a constant = sort bit + mention(value grid); a walk =
-- sort bit + rate index"), same float path on the same declared grids:
mentionG :: Grid -> Double
mentionG g = 1 + logBase 2 (fromIntegral (gridSize g))

dlUConst, dlUWalk :: Double
dlUConst = 1 + mentionG uGridD
dlUWalk  = 1 + logBase 2 (fromIntegral (gridSize rhoUGrid))

-- the pointer's nine constant-u sentences on the verdict channel:
-- singleton latent axes (a stateless sentence's uniform init is a
-- point mass — the step-3 surface's own discipline)
pointerSentences :: [Hyp]
pointerSentences =
  [ Hyp (Bits dlUConst) sp (Code sp obsSpace verdictBody) Nothing
  | u <- uPoints, let sp = mkSpace (u :| []) ]

-- uAgent0 [UConst]'s port: the same latents on the world channel
uConstSentences :: [Hyp]
uConstSentences =
  [ Hyp (Bits dlUConst) sp (Code sp obsSpace (bernBody (Var (S Z)))) Nothing
  | u <- uPoints, let sp = mkSpace (u :| []) ]

-- the eight walk sentences over the drifting u (the retired MUWalk
-- rows: latent axis = the u grid, init uniform — MUWalk's own init)
uWalkSentences :: [Hyp]
uWalkSentences =
  [ Hyp (Bits dlUWalk) uSpaceD
        (Code uSpaceD obsSpace (bernBody (Var (S Z))))
        (Just (walkCodeU j))
  | j <- [0 .. gridSize rhoUGrid - 1] ]

-- ---------------------------------------------------------------------
-- the agents (this file's r0 :103-114, constructors ported; the r0
-- order — UConst then UWalk — is preserved)
-- ---------------------------------------------------------------------

pointerAgent0 :: Agent
pointerAgent0 = sentenceAgent pointerSentences

uAgentC :: Agent
uAgentC = sentenceAgent uConstSentences

uAgentAll :: Agent
uAgentAll = sentenceAgent (uConstSentences ++ uWalkSentences)

worldAgent0 :: Agent
worldAgent0 = sentenceAgent (enumerateSentences fragFull)

nPointer, nUC, nUAll, nWorld :: Int
nPointer = length pointerSentences
nUC      = length uConstSentences
nUAll    = length uConstSentences + length uWalkSentences
nWorld   = length (enumerateSentences fragFull)

-- ---------------------------------------------------------------------
-- the pin's two gates (tolerance provenance in the header; UNTOUCHED
-- at the step-3 port — E-s2's zero-mismatch measurement is why)
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

-- the posterior read through the public surface only (r0 :156-160;
-- the declared count-argument delta, header note 1)
metaProbs :: Int -> Agent -> [Double]
metaProbs n ag =
  let sp = mkSpace (0 :| [1 .. n - 1]) :: Space Int
  in [ prob (agentMeta ag) (is sp i) | i <- [0 .. n - 1] ]

-- the pin predicate, whole: batch evidence within tolEv of the
-- sequential sum (relative), every posterior point within tolPost
pinHolds :: Int -> (Double, Agent) -> (Double, Agent) -> Bool
pinHolds n (lpB, agB) (lpS, agS) =
  abs (lpB - lpS) <= tolEv * (1 + abs lpS)
    && and (zipWith (\a b -> abs (a - b) <= tolPost)
                    (metaProbs n agB) (metaProbs n agS))

-- both gates' readings, for failure messages
detail :: Int -> (Double, Agent) -> (Double, Agent) -> String
detail n (lpB, agB) (lpS, agS) =
  "batch lp " ++ show lpB ++ " vs sequential " ++ show lpS
    ++ "; max posterior diff "
    ++ show (maximum (0 : zipWith (\a b -> abs (a - b))
                                  (metaProbs n agB) (metaProbs n agS)))

runBoth :: (Features -> Int -> Int -> Agent -> Maybe (LogProb, Agent))
        -> (Obs -> Agent -> Maybe (LogProb, Agent))
        -> Agent -> (Int, Int) -> ((Double, Agent), (Double, Agent))
runBoth batch step ag (n1, n0) =
  case (batch featsD n1 n0 ag, seqRef step n1 n0 ag) of
    (Just (LogProb lpB, agB), Just (lpS, agS)) -> ((lpB, agB), (lpS, agS))
    _ -> error "a frozen-world route answered impossible-evidence"

pinCase :: String -> Int -> Agent
        -> (Features -> Int -> Int -> Agent -> Maybe (LogProb, Agent))
        -> (Obs -> Agent -> Maybe (LogProb, Agent))
        -> [(Int, Int)] -> TestTree
pinCase name n ag batch step ps = testCase name $
  forM_ ps $ \p@(n1, n0) ->
    let (bres, sres) = runBoth batch step ag p
    in assertBool ("pin fails at (" ++ show n1 ++ ", " ++ show n0
                     ++ "): " ++ detail n bres sres)
                  (pinHolds n bres sres)

refuteCase :: String -> Int -> Agent
           -> (Features -> Int -> Int -> Agent -> Maybe (LogProb, Agent))
           -> (Obs -> Agent -> Maybe (LogProb, Agent))
           -> [(Int, Int)] -> TestTree
refuteCase name n ag batch step ps = testCase name $
  forM_ ps $ \p@(n1, n0) ->
    let (bres, sres) = runBoth batch step ag p
    in assertBool ("the flattening vanished at (" ++ show n1 ++ ", "
                     ++ show n0 ++ "): " ++ detail n bres sres
                     ++ " — batch equals sequential within the "
                     ++ "exchangeable gate on a state-carrying agent; "
                     ++ "the domain boundary moved; stop and report")
                  (not (pinHolds n bres sres))

-- ---------------------------------------------------------------------
-- gPin — the section-1b required property, exchangeable domain
-- ---------------------------------------------------------------------

gPin :: TestTree
gPin = testGroup "gPin observeCounts == n1-then-n0 repeated observe's"
  [ pinCase "pointerAgent0, carried channel (verdict route)"
      nPointer pointerAgent0 (observeCounts Nothing) (observe featsD)
      countLadder
  , pinCase "uAgent0 [UConst], carried channel (gDegeneracy generator)"
      nUC uAgentC (observeCounts Nothing) (observe featsD) countLadder
  , pinCase "pointerAgent0, supplied emission (outcome route, emit)"
      nPointer pointerAgent0 (observeCounts (Just emit))
      (observeVia emit featsD) countLadder
  ]

-- ---------------------------------------------------------------------
-- gBoundary — the declared flattening, measured at its edge
-- ---------------------------------------------------------------------

gBoundary :: TestTree
gBoundary = testGroup "gBoundary the exchangeable restriction is load-bearing"
  [ pinCase "worldAgent0 (8 walk sentences; MHmm at r0): exact while nothing is collapsed"
      nWorld worldAgent0 (observeCounts Nothing) (observe featsD) holdPairs
  , refuteCase "worldAgent0 (8 walk sentences; MHmm at r0): refuted from the first collapsed pair"
      nWorld worldAgent0 (observeCounts Nothing) (observe featsD)
      refutePairs
  , pinCase "uAgent0 allUFamilies (8 walk sentences over u; UWalk at r0): exact while nothing is collapsed"
      nUAll uAgentAll (observeCounts Nothing) (observe featsD) holdPairs
  , refuteCase "uAgent0 allUFamilies (8 walk sentences over u; UWalk at r0): refuted from the first collapsed pair"
      nUAll uAgentAll (observeCounts Nothing) (observe featsD) refutePairs
  ]
