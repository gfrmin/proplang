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
import Data.List (sort)

import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief (Belief, expect)
import PropLang.Lattice
  ( Owned, Region (..)
  , childrenOf, frontier, gammaBits, guardE, kraftSubtree, mkOwned
  , nodeLambda, nodeTheta, ownedNodes, regions, rootNode, scoreOwned
  , straddles
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
