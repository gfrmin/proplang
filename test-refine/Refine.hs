{-# LANGUAGE DataKinds #-}

-- | test-refine/Refine.hs -- boundary R, increment R1 (the joint
-- purchase increment: R-vocab + R-depth as one law, ruling R-R2).
-- Oracle rows per r-author-pack.md Part III.2; provenance R-D20
-- (every pinned formula copied from its frozen source, file:line in
-- the group comment, never re-derived); satisfiability transcripts
-- per R-D21 ride the pack before this file freezes.
--
-- TRANCHE 1 (this file, oracle-phase in progress): the lattice-law
-- groups -- design rows 2-7 and 11 -- pinned against the
-- PropLang.Lattice surface (stubs; every group is RUNTIME-RED until
-- implementation). Tranche 2 adds the host-layer groups (rows 1, 8,
-- 9, 12-17) with the membrane surface.
--
-- Test names are ASCII-only (the membrane's locale incident).
module Main (main) where

import Control.Exception (evaluate)
import Data.List (sort, sortOn)
import Data.List.NonEmpty (NonEmpty ((:|)))

import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief
  ( Belief, Bits (..), Evidence (Saw), cond, expect, fromBits, kernel
  , mkSpace, push
  )
import PropLang.Enumerate (Obs, obsSpace)
import PropLang.Lattice
  ( Owned, Region (..)
  , childrenOf, frontier, gammaBits, guardE, kraftSubtree, mkOwned
  , nodeLambda, nodeTheta, ownedNodes, regions, rootNode, scoreOwned
  , straddles
  )
import PropLang.Purchase
  ( PTick (..), PurchaseWorld (..), purchasePredictive, runPurchase
  )

-- point-mass probability through the expectation door (prob's own
-- definition shape, Belief.hs:175-176, without the Space argument
-- 'is' requires)
probAt :: Belief Double -> Double -> Double
probAt b t = expect b (\x -> if x == t then 1.0 else 0.0)

main :: IO ()
main = defaultMain $ testGroup
  "refine -- the joint purchase increment (R1)"
  [ g1ScorerCoherence
  , g2RegionGuard
  , g3ReleaseIdentity
  , g4FinenessChargedOnce
  , g5KraftComputability
  , g6CromwellDivergence
  , g7StakesBuyTheFrontier
  , g8PurchaseLogAndResidue
  , g9RecurringStakes
  , g10RefineVsThink
  , g11EmitKernelMotion
  , g12OrderPinAndReadDoor
  ]

-- ---------------------------------------------------------------------
-- shared fixture data
-- ---------------------------------------------------------------------

-- The stakes of the R0 evidence programs (r-author-pack I.4/I.6):
-- sRight = +1, sWrong = -9 => respond pays iff theta > 0.9. p* is
-- DERIVED from the stakes in-row, never a magic numeral.
stakes :: (Double, Double)
stakes = (1, -9)

pStar :: Double
pStar = let (sR, sW) = stakes in negate sW / (sR - sW)

-- An owned set spanning the threshold: the frontier expansion of the
-- root, outward, until one rung past p* is owned (built through the
-- lattice's own doors -- a probe reads declared data, the step-5
-- clause; no hand-written node lists).
ownedPastStar :: Owned
ownedPastStar = grow (mkOwned [rootNode])
  where
    grow o | any ((> pStar) . nodeTheta) (ownedNodes o) = o
           | otherwise =
               case filter ((> 0) . nodeLambda) (frontier o) of
                 []      -> o
                 (c : _) -> grow (mkOwned (c : ownedNodes o))

-- The same construction stopped one rung short (every owned theta
-- below p*): the root-only analog, METAREASONING_PLAN.md:191-193.
ownedBelowStar :: Owned
ownedBelowStar =
  mkOwned [ n | n <- ownedNodes ownedPastStar, nodeTheta n <= pStar ]

-- ---------------------------------------------------------------------
-- g1 -- scorer coherence (design rows 2-3; METAREASONING_PLAN.md:
-- 137-150: purchase-ORDER independence through ONE canonical scorer,
-- byte; scorer-vs-incremental agreement at tolerance, never byte)
-- ---------------------------------------------------------------------

g1ScorerCoherence :: TestTree
g1ScorerCoherence = testGroup "g1 scorer coherence"
  [ testCase "purchase-order independence is BYTE-identical through the canonical scorer" $ do
      let ns = ownedNodes ownedPastStar
          a  = scoreOwned (mkOwned ns) (17, 3)
          b  = scoreOwned (mkOwned (reverse ns)) (17, 3)
      let pa = [ probAt a (nodeTheta n) | n <- ns ]
          pb = [ probAt b (nodeTheta n) | n <- ns ]
      assertEqual "per-node posteriors, byte" pa pb
  , testCase "scorer is a pure function of the counts: (n1,n0) built as any interleaving" $ do
      -- the permanent counts carry no order: (5,2) is (5,2) however
      -- the seven observations arrived (the carried-state law,
      -- METAREASONING_PLAN.md:118-125)
      let o = ownedPastStar
      x <- evaluate (expect (scoreOwned o (5, 2)) id)
      y <- evaluate (expect (scoreOwned o (5, 2)) id)
      assertEqual "same counts, same posterior mean, byte" x y
  , testCase "scorer vs incremental cond route agrees at tolerance (never byte across the arithmetic seam)" $ do
      -- METAREASONING_PLAN.md:143-150: the live incremental path
      -- (per-evidence log-weight addition) cannot be IEEE-identical
      -- to the scorer's n1 * log th; agreement pinned at tolerance.
      -- GATE DERIVED FROM MEASUREMENT (the cl4 lesson): SAT probe
      -- measured max dev 1.665e-16 on the overlay realization; gate
      -- 1e-12 carries ~6000x headroom over the measured floor.
      let o    = ownedPastStar
          ths  = map nodeTheta (ownedNodes o)
          sp   = mkSpace (toNE ths)
          bern th = fromBits obsSpace
            (\y -> Bits (if y == (1 :: Obs)
                          then negate (logBase 2 th)
                          else negate (logBase 2 (1 - th))))
          km   = kernel sp obsSpace bern
          inc  = foldl (\b y -> maybe (error "cond total here") id
                                       (cond b (Saw km y)))
                       (scoreOwned o (0, 0))
                       (replicate 5 (1 :: Obs) ++ replicate 2 0)
          direct = scoreOwned o (5, 2)
          dev  = maximum [ abs (probAt inc th - probAt direct th)
                         | th <- ths ]
      assertBool ("max deviation " ++ show dev ++ " < 1e-12")
                 (dev < 1e-12)
  ]

-- ---------------------------------------------------------------------
-- g2 -- the region guard (design row 4; METAREASONING_PLAN.md:
-- 173-201 as amended R-R3: the rectangle bound, REGION granularity
-- for the straddle; r-author-pack I.6's 21/1000 the provenance)
-- ---------------------------------------------------------------------

g2RegionGuard :: TestTree
g2RegionGuard = testGroup "g2 the region guard"
  [ testCase "pessimistic never exceeds optimistic (placement ordering)" $ do
      let o = ownedPastStar
      sequence_
        [ do p <- evaluate (guardE True  o (n1, n0) stakes)
             q <- evaluate (guardE False o (n1, n0) stakes)
             assertBool ("pess <= opt at " ++ show (n1, n0)) (p <= q)
        | n1 <- [0, 1, 5, 20, 50], n0 <- [0, 1, 3] ]
  , testCase "the straddle IS the two placements bracketing zero" $ do
      let o = ownedPastStar
      sequence_
        [ do p <- evaluate (guardE True  o c stakes)
             q <- evaluate (guardE False o c stakes)
             s <- evaluate (straddles o c stakes)
             assertEqual ("straddle def at " ++ show c)
                         (p <= 0 && q > 0) s
        | c <- [ (n1, n0) | n1 <- [0 .. 30], n0 <- [0 .. 2] ] ]
  , testCase "capped-below-p* owned set: respond blocked at every evidence level 1..200" $ do
      -- the root-only law: it must purchase (METAREASONING_PLAN.md:
      -- 191-193; R0 A2b reproduced this on the prototype)
      let o = ownedBelowStar
      let rels = [ n | n <- [1 .. 200], guardE True o (n, 0) stakes > 0 ]
      assertEqual "releases" ([] :: [Int]) rels
  ]

-- ---------------------------------------------------------------------
-- g3 -- guard release (design row 5; METAREASONING_PLAN.md:298-302:
-- release at the first owned rung past the stakes threshold, under
-- the RULED gamma code (R-R1); the rung is DERIVED in-row from the
-- stakes -- no magic numeral; R0 A2's rung identity the evidence)
-- ---------------------------------------------------------------------

g3ReleaseIdentity :: TestTree
g3ReleaseIdentity = testGroup "g3 guard release"
  [ testCase "an owned rung past p* releases under all-correct evidence" $ do
      let o = ownedPastStar
      let rels = [ n | n <- [1 .. 2000], guardE True o (n, 0) stakes > 0 ]
      assertBool "some release exists" (not (null rels))
  , testCase "release is ENABLED by the rung past p*: the capped set stays blocked at the same evidence" $ do
      -- the law's text (METAREASONING_PLAN.md:193-194) read as
      -- ownership-enabling: the SAT run convicted the earlier
      -- mode-position form as an artifact of R0's unary-economics
      -- world -- under the ruled gamma code release precedes the
      -- mode's arrival at the deep rung (pack III.6)
      let o = ownedPastStar
          nRel = case [ n | n <- [1 .. 2000]
                          , guardE True o (n, 0) stakes > 0 ] of
                   (n : _) -> n
                   []      -> error "release exists by the previous row"
      blocked <- evaluate (guardE True ownedBelowStar (nRel, 0) stakes)
      assertBool ("capped-below-p* still blocked at n = " ++ show nRel)
                 (blocked <= 0)
      -- and the enabling rung is real: the two sets differ exactly
      -- by rungs past p*
      assertBool "the sets differ only past p*"
        (all ((<= pStar) . nodeTheta) (ownedNodes ownedBelowStar)
         && any ((> pStar) . nodeTheta) (ownedNodes o))
  ]

-- ---------------------------------------------------------------------
-- g4 -- lattice fineness charged once (design row 6;
-- METAREASONING_PLAN.md:303-305: the augmented mixture's prior
-- masses are exactly the 2^-dl Kraft terms and nothing else -- A8's
-- frozen tripwire extended to the frontier)
-- ---------------------------------------------------------------------

g4FinenessChargedOnce :: TestTree
g4FinenessChargedOnce = testGroup "g4 fineness charged once"
  [ testCase "prior masses are exactly the normalized 2^-gammaBits terms" $ do
      let o  = ownedPastStar
          ns = ownedNodes o
          b  = scoreOwned o (0, 0)
          z  = sum [ 2 ** negate (gammaBits n) | n <- ns ]
      sequence_
        [ do p <- evaluate (probAt b (nodeTheta n))
             let e = 2 ** negate (gammaBits n) / z
             assertBool ("node " ++ show n ++ ": |" ++ show p
                         ++ " - " ++ show e ++ "| < 1e-12")
                        (abs (p - e) < 1e-12)
        | n <- ns ]
  ]

-- ---------------------------------------------------------------------
-- g5 -- Kraft computability (design row 7; METAREASONING_PLAN.md:
-- 306-308: the guard's remainder mass is sound only if the ruled
-- code's subtree sums are computable -- closed form pinned against
-- enumerated partial sums, and the Kraft inequality holds)
-- ---------------------------------------------------------------------

g5KraftComputability :: TestTree
g5KraftComputability = testGroup "g5 Kraft computability"
  [ testCase "closed-form subtree sum dominates every enumerated partial sum and is approached by them" $ do
      let c      = case frontier (mkOwned [rootNode]) of
                       (x : _) -> x
                       []      -> error "the root has children by construction"
          -- subtree enumeration through the DECLARED door (childrenOf),
          -- per-level BFS with no re-accumulation (both earlier forms
          -- were convicted by the SAT run: the frontier-based expansion
          -- pulled sibling chains in via mkOwned's parent closure, and
          -- the append-based expansion double-counted levels)
          lvl 0 = [c]
          lvl d = concatMap childrenOf (lvl (d - 1 :: Int))
          levels = [ sum [ 2 ** negate (gammaBits n)
                         | n <- concat [ lvl d' | d' <- [0 .. d] ] ]
                   | d <- [1, 2, 3, 4] ]
      closed <- evaluate (kraftSubtree c)
      sequence_
        [ assertBool ("partial " ++ show s ++ " <= closed " ++ show closed)
                     (s <= closed + 1e-12)
        | s <- levels ]
      assertBool "partials increase toward the closed form"
                 (levels == sort levels)
  , testCase "the mixture satisfies Kraft: total mass over owned + regions <= 1" $ do
      let o = ownedPastStar
      t <- evaluate ( sum [ 2 ** negate (gammaBits n) | n <- ownedNodes o ]
                    + sum [ rMass r | r <- regions o ] )
      assertBool ("total " ++ show t ++ " <= 1") (t <= 1 + 1e-12)
  ]

-- ---------------------------------------------------------------------
-- g6 -- Cromwell divergence (design row 11; METAREASONING_PLAN.md:
-- 317, :360-364: cumulative price along ANY path to a degenerate
-- limit diverges -- the representation-independent statute; gamma's
-- sum of ~2 lg j diverges, the R-R1 ruling's safety clause)
-- ---------------------------------------------------------------------

g6CromwellDivergence :: TestTree
g6CromwellDivergence = testGroup "g6 Cromwell divergence"
  [ testCase "the outward path to theta -> 1: cumulative price is unbounded (witness: exceeds 100 bits and keeps growing)" $ do
      let path = iterate stepOut (mkOwned [rootNode])
          stepOut o = case filter ((> 0) . nodeLambda) (frontier o) of
            (c : _) -> mkOwned (c : ownedNodes o)
            []      -> o
          priceAt k = sum [ gammaBits n
                          | n <- ownedNodes (path !! k), nodeLambda n > 0 ]
      p200 <- evaluate (priceAt 200)
      p400 <- evaluate (priceAt 400)
      assertBool "past 100 bits by 200 rungs" (p200 > 100)
      assertBool "still growing" (p400 > p200 + 10)
  ]

-- ---------------------------------------------------------------------
-- tranche-2 shared fixtures (worlds are ECONOMICS + a stream, nothing
-- else — the alignment statement is the type: PurchaseWorld carries
-- stakes and a surcharge, no vocabulary, no grid, no depth)
-- ---------------------------------------------------------------------

toNE :: [a] -> NonEmpty a
toNE (x : xs) = x :| xs
toNE []       = error "fixture lists are non-empty by construction"

probAt2 :: Belief Obs -> Obs -> Double
probAt2 b y = expect b (\x -> if x == y then 1.0 else 0.0)

-- theta* ~ 0.97 as a deterministic stream, one zero per 33 ticks
-- (the R0 program-B world, r-author-pack I.5 — R-D20: copied, not
-- re-derived)
stream120 :: [Obs]
stream120 = [ if i `mod` 33 == 0 then 0 else 1 | i <- [1 :: Int .. 120] ]

-- grow the outward chain until a rung at or past the target lambda
growTo :: Double -> Owned
growTo lam = grow (mkOwned [rootNode])
  where
    grow o | any ((>= lam) . nodeLambda) (ownedNodes o) = o
           | otherwise =
               case filter ((> 0) . nodeLambda) (frontier o) of
                 []      -> o
                 (c : _) -> grow (mkOwned (c : ownedNodes o))

ownedDeep :: Owned
ownedDeep = growTo 8

-- value-greedy growth at fixed counts: repeatedly buy the frontier
-- candidate whose region carries the largest evidence-weighted mass
-- (mass x sup-likelihood over its interval) — the frontier mass that
-- MATTERS vanishes, which is the read-door row's premise. Pairs
-- frontier with regions by the declared index contract.
ownedFine :: (Int, Int) -> Int -> Owned
ownedFine (n1, n0) steps = iterate step ownedPastStar !! steps
  where
    step o =
      case sortOn (negate . weight) (zip (frontier o) (regions o)) of
        ((c, _) : _) -> mkOwned (c : ownedNodes o)
        []           -> o
    weight (_, Region lo hi m) =
      let mode | n1 + n0 == 0 = hi
               | otherwise = fromIntegral n1 / fromIntegral (n1 + n0)
          p = max lo (min hi mode)
      in m * (p ^^ n1 * (1 - p) ^^ n0)

boughtAny :: [PTick] -> Bool
boughtAny = any (not . null . ptBought)

-- ---------------------------------------------------------------------
-- g7 -- stakes buy the frontier (design row 1; METAREASONING_PLAN.md:
-- 288-290: u_wrong = -9 all-correct buys up the ladder and respond
-- fires; the SAME evidence under governor-scale stakes buys nothing)
-- ---------------------------------------------------------------------

g7StakesBuyTheFrontier :: TestTree
g7StakesBuyTheFrontier = testGroup "g7 stakes buy the frontier"
  [ testCase "high stakes: the agent purchases and respond fires" $ do
      let w  = PurchaseWorld (1, -9) (Just 0.5)
          ts = runPurchase w ownedBelowStar stream120
      assertBool "some purchase happens" (boughtAny ts)
      assertBool "respond fires" (any ((== "respond") . ptAct) ts)
  , testCase "the SAME evidence under governor-scale stakes buys nothing" $ do
      let w  = PurchaseWorld (0.01, -0.09) (Just 0.5)
          ts = runPurchase w ownedBelowStar stream120
      assertBool "no purchase" (not (boughtAny ts))
  ]

-- ---------------------------------------------------------------------
-- g8 -- the purchase log + the migration residue (design rows 8, 12;
-- METAREASONING_PLAN.md:309-310, :318-322. The residue row is
-- RESIDUE-TAGGED: its retirement condition is EXECUTABLE — does
-- refine ever pay under the frozen worlds' streams (:221-222) — and
-- one-sided (:222-226); the row retires as a discharged obligation
-- at the boundary that measures it, never by oracle amendment.)
-- ---------------------------------------------------------------------

g8PurchaseLogAndResidue :: TestTree
g8PurchaseLogAndResidue = testGroup "g8 purchase log and residue"
  [ testCase "every purchase tick prints the COMPLETE owned set (monotone superset chain)" $ do
      let ts = runPurchase (PurchaseWorld (1, -9) (Just 0.5))
                           ownedBelowStar stream120
          chainOk (prev, ok) t =
            ( ptOwned t
            , ok && all (`elem` ptOwned t) prev
                 && all (`elem` ptOwned t) (ptBought t) )
      assertBool "log complete at every tick"
                 (snd (foldl chainOk ([], True) ts))
  , testCase "no refine row => zero purchases, owned set byte-static (the tagged residue)" $ do
      let ts = runPurchase (PurchaseWorld (1, -9) Nothing)
                           ownedBelowStar stream120
      assertBool "no purchases ever" (not (boughtAny ts))
      assertBool "owned set never moves"
                 (all ((== map nodeTheta (ownedNodes ownedBelowStar))
                        . map nodeTheta . ptOwned) ts)
  ]

-- ---------------------------------------------------------------------
-- g9 -- recurring stakes and the success anchor (design rows 9, 16;
-- the R0 program-B world as oracle — B1/B3 r-author-pack I.5: the
-- joint law buys via the rung choice where myopic never would; and
-- R_SCOPE §2's governor anchor: 0.96 threshold cleared with NO host
-- declaration — the world type carries stakes and surcharge only)
-- ---------------------------------------------------------------------

g9RecurringStakes :: TestTree
g9RecurringStakes = testGroup "g9 recurring stakes and the success anchor"
  [ testCase "the recurring-stakes stream: the joint law buys and clears (p* = 0.95)" $ do
      -- surcharge 0.1: above the myopic per-tick gain (~0.015 at
      -- these stakes), below the stream value — the discriminating
      -- shape g < s < K*g, the B-world's law at this world's scale
      let w  = PurchaseWorld (0.05, -0.95) (Just 0.1)
          ts = runPurchase w ownedPastStar stream120
      assertBool "a purchase happens" (boughtAny ts)
      assertBool "respond fires after the purchase"
                 (any ((== "respond") . ptAct) ts)
  , testCase "one-tick-decisive world: no purchase (the myopic case is the CHOSEN rung, not a branch)" $ do
      let w  = PurchaseWorld (0.05, -0.95) (Just 0.1)
          ts = runPurchase w ownedPastStar (take 1 stream120)
      assertBool "no purchase on a one-tick stream" (not (boughtAny ts))
  , testCase "the governor anchor: 0.96 threshold cleared with no host declaration (p* = 0.96)" $ do
      let w  = PurchaseWorld (1, -24) (Just 0.5)
          ts = runPurchase w ownedPastStar stream120
          pastThreshold = any (any ((> 0.96) . nodeTheta) . ptBought) ts
      assertBool "a rung past 0.96 is bought" pastThreshold
      assertBool "respond fires" (any ((== "respond") . ptAct) ts)
  ]

-- ---------------------------------------------------------------------
-- g10 -- refine vs think under ONE law (design row 13;
-- METAREASONING_PLAN.md:323-325, as R-R2 re-grounds it: not an
-- arbitration between two mechanisms — one option space, one clock)
-- ---------------------------------------------------------------------

g10RefineVsThink :: TestTree
g10RefineVsThink = testGroup "g10 refine vs think"
  [ testCase "vocabulary-limited posterior: refine fires (evidence piled at the edge, cheap surcharge)" $ do
      let ts = runPurchase (PurchaseWorld (1, -9) (Just 0.01))
                           ownedBelowStar stream120
      assertBool "refine fires" (boughtAny ts)
  , testCase "evidence-limited posterior: no refine (fine vocabulary, three ticks of evidence)" $ do
      let ts = runPurchase (PurchaseWorld (1, -9) (Just 0.01))
                           ownedDeep (take 3 stream120)
      assertBool "no purchase" (not (boughtAny ts))
  ]

-- ---------------------------------------------------------------------
-- g11 -- emit-kernel motion (design row 14, MANDATORY per R-R3: the
-- R0 hand-built-kernel confession is the provenance. Two-route pin:
-- the engine's post-purchase predictive equals the explicit
-- fromBits-Bernoulli route at the same owned thetas — the Bernoulli
-- semantics copied from the fragment's frozen instance
-- (Enumerate.hs:473-474, p(y=1|th) = th), never re-derived.
-- Tolerance 1e-12: the overlay's routes coincide (measured 0.0), so
-- the overlay cannot discriminate this gate — it binds the REAL
-- engine's fragment route; 1e-12 is the one-lse-seam pattern (g4).)
-- ---------------------------------------------------------------------

g11EmitKernelMotion :: TestTree
g11EmitKernelMotion = testGroup "g11 emit-kernel motion"
  [ testCase "post-purchase predictive equals the explicit Bernoulli route at the owned thetas" $ do
      let o    = ownedPastStar
          c    = (17, 3)
          ths  = map nodeTheta (ownedNodes o)
          bern th = fromBits obsSpace
            (\y -> Bits (if y == (1 :: Obs)
                          then negate (logBase 2 th)
                          else negate (logBase 2 (1 - th))))
          route2 = push (scoreOwned o c)
                        (kernel (mkSpace (toNE ths)) obsSpace bern)
          route1 = purchasePredictive o c
          dev  = maximum [ abs (probAt2 route1 y - probAt2 route2 y)
                         | y <- [0, 1] ]
      assertBool ("max deviation " ++ show dev ++ " < 1e-12")
                 (dev < 1e-12)
  ]

-- ---------------------------------------------------------------------
-- g12 -- the option-order pin + the read door (design rows 17, 15).
-- The order, drawn once with both internal acts visible (R-R2):
-- wait head, externals, refine, think-deeper — an internal act fires
-- only by STRICTLY beating every external (CL-3 first-listed-wins;
-- AGENT_PLAN.md:787, :1320). The read-door row is the two-fidelities
-- convergence: as the frontier mass vanishes the guard IS the read
-- door's expectation (METAREASONING_PLAN.md:197-201); the guard's
-- type already forbids state out — this row pins the arithmetic
-- half. PROVISIONAL tolerance 1e-6, re-derived at the freeze.
-- ---------------------------------------------------------------------

g12OrderPinAndReadDoor :: TestTree
g12OrderPinAndReadDoor = testGroup "g12 order pin and read door"
  [ testCase "zero-stakes world: every tick is wait, zero purchases (ties break to inaction through the whole order)" $ do
      let ts = runPurchase (PurchaseWorld (0, 0) (Just 0))
                           ownedPastStar (take 20 stream120)
      assertBool "all wait" (all ((== "wait") . ptAct) ts)
      assertBool "no purchases" (not (boughtAny ts))
  , testCase "the guard brackets the read door and converges toward it under value growth" $ do
      -- the two-fidelities consistency (METAREASONING_PLAN.md:
      -- 197-201): the read door's expectation lies INSIDE the
      -- guard's bracket at every growth stage, and the bracket
      -- tightens strictly as value-greedy purchases shrink the
      -- evidence-weighted frontier mass. The envelope gate is
      -- MEASURED (SAT: dev(150) = 2.0e-3), not guessed — the first
      -- draft's 1e-6 was a plucked gate and the SAT run convicted
      -- it: frontier mass halves per DEPTH level while the
      -- purchases a level needs double, so a fixed tiny gate
      -- mistakes the convergence's shape (r-author-pack III.7).
      let c = (30, 2)
          devAt steps =
            let o = ownedFine c steps
                e = expect (scoreOwned o c)
                           (\th -> fst stakes * th
                                 + snd stakes * (1 - th))
                p = guardE True o c stakes
                q = guardE False o c stakes
            in (p <= e && e <= q, abs (p - e) `max` abs (q - e))
          (br10, d10)   = devAt 10
          (br50, d50)   = devAt 50
          (br150, d150) = devAt 150
      assertBool "bracket holds at every stage" (br10 && br50 && br150)
      assertBool ("strictly tightening: " ++ show (d10, d50, d150))
                 (d150 < d50 && d50 < d10)
      assertBool ("measured envelope: " ++ show d150 ++ " < 5e-3")
                 (d150 < 5e-3)
  ]
