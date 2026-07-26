{-# LANGUAGE GHC2021 #-}
-- test-dyadic/Dyadic.hs — the dyadic increment's oracle (the X.5
-- sitting's rulings 1-3 executed: dyadic-in-theta ADOPTED, the
-- pwLadderCap repair landing, the negInf departure).
--
-- Provenance discipline (R-D20, copy-not-reconstruct): every pinned
-- literal below either (a) COPIES a sealed quantity, citing
-- x5-author-pack.md at tag x5-sitting-r0 by section, or (b) is a
-- NEW-ROW hand derivation from the frozen formula text (the staged
-- diff, pack 3.6), with the derivation shown in the row's comment
-- (the pricing-row precedent: a hand-computable instance).
--
-- Force discipline (the step-2 clause): every comparison row's
-- frozen side is forced to normal form before the comparison (the
-- 'pin' helper), so a red is attributable to the implementation,
-- never to laziness the stub happens to shadow.
module Main (main) where

import Control.Exception (evaluate)
import Data.List (nub, sort, sortOn)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio (denominator, numerator, (%))
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief (mkSpace, points, weights)
import PropLang.Lattice
  ( Node, Owned, Region (..), childrenOf, frontier, gammaBits, guardE
  , kraftSubtree, mkOwned, nodeTheta, ownedNodes, regions, rootNode
  , scoreOwned, straddles
  )
import PropLang.Purchase
  ( PTick (..), PurchaseWorld (..), purchasePredictive, runPurchase
  )

-- the force-then-compare helper: one deepseq-equivalent per row
-- (show reaches every constructor of the pinned side).
pin :: (Eq a, Show a) => String -> a -> a -> Assertion
pin name expected actual = do
  _ <- evaluate (length (show expected))
  assertEqual name expected actual

-- the tree to depth k, generated through the declared doors only
-- (rootNode/childrenOf — the probe clause: probes read declared
-- data, never re-declare it).
treeToDepth :: Int -> [Node]
treeToDepth k = concat (take (k + 1) (iterate (concatMap childrenOf) [rootNode]))

-- the lower-/higher-theta child (the DEEP chain's step; GroundC's
-- hiChild reconstructed through the exported surface). Total with
-- an error arm: a lattice node has exactly two children.
loChild, hiChild :: Node -> Node
loChild n = case sortOn nodeTheta (childrenOf n) of
  (l : _) -> l
  []      -> error "loChild: a lattice node has exactly two children"
hiChild n = case sortOn nodeTheta (childrenOf n) of
  [_, h] -> h
  _      -> error "hiChild: a lattice node has exactly two children"

-- the DEEP pre-owned chain (x5 pack 3.6a: coordinate-native chain
-- to depth 6, thetas 3/4, 7/8, ..., 127/128).
deepChain :: [Node]
deepChain = take 6 (iterate hiChild (hiChild rootNode))

main :: IO ()
main = defaultMain (testGroup "dyadic" [ dCoord, dPrice, dRegion, dGuard, dSafety, dPurchase ])

-- d1 COORDINATE — the sayable dyadic rationals (ruling 1; staged
-- diff 3.6: theta = num/2^(depth+1), num odd, injective).
dCoord :: TestTree
dCoord = testGroup "d1 coordinate"
  [ testCase "d1.1 root theta is exactly 1/2" $
      pin "root" (1 % 2) (nodeTheta rootNode)
  , testCase "d1.2 root children thetas are exactly 1/4 and 3/4" $
      pin "children" [1 % 4, 3 % 4]
        (sort (map nodeTheta (childrenOf rootNode)))
  , testCase "d1.3 injectivity to depth 6: 127 nodes, 127 thetas" $ do
      let ns = treeToDepth 6
      pin "node count" (127 :: Int) (length ns)
      pin "distinct thetas" (127 :: Int) (length (nub (map nodeTheta ns)))
  , testCase "d1.4 sayability: every theta is odd/2^(depth+1)" $ do
      let ok th = odd (numerator th)
               && denominator th == 2 ^ (ilog2i (denominator th))
      pin "canonical dyadic form" True (all (ok . nodeTheta) (treeToDepth 6))
  , testCase "d1.5 mirror is positional: theta <-> 1-theta, same price" $ do
      let ns  = treeToDepth 6
          tab = sort [ (nodeTheta n, gammaBits n) | n <- ns ]
          mir = sort [ (1 - nodeTheta n, gammaBits n) | n <- ns ]
      pin "mirror closure" tab mir
  ]
  where
    ilog2i :: Integer -> Integer
    ilog2i m = if m <= 1 then 0 else 1 + ilog2i (m `div` 2)

-- d2 PRICE — gammaLen(depth+1) + depth (staged diff 3.6; hand
-- values: gammaLen 1=1, 2=3, 3=3, 4=5, 7=5 => depth 0:1, 1:4, 2:5,
-- 3:8, 6:11).
dPrice :: TestTree
dPrice = testGroup "d2 price"
  [ testCase "d2.1 prices at depths 0..3 are 1, 4, 5, 8" $ do
      pin "root" (1 :: Integer) (gammaBits rootNode)
      pin "depth 1" (4 :: Integer) (gammaBits (loChild rootNode))
      pin "depth 2" (5 :: Integer) (gammaBits (loChild (loChild rootNode)))
      pin "depth 3" (8 :: Integer)
        (gammaBits (loChild (loChild (loChild rootNode))))
  , testCase "d2.2 the economics table (COPY: x5 pack 3.5, sealed)" $ do
      -- min price over nodes within 1/200 of theta*, tree to depth 8
      -- (prices increase with depth, so depth 8 bounds the min):
      -- 1/2 -> 1, 3/4 -> 4, 9/10 -> 11, 24/25 -> 11, 4971/5000 -> 11
      let ns = treeToDepth 8
          minP tgt = minimum [ gammaBits n | n <- ns
                             , abs (nodeTheta n - tgt) <= 1 % 200 ]
      pin "theta 0.5"    (1 :: Integer) (minP (1 % 2))
      pin "theta 0.75"   (4 :: Integer) (minP (3 % 4))
      pin "theta 0.9"    (11 :: Integer) (minP (9 % 10))
      pin "theta 0.96"   (11 :: Integer) (minP (24 % 25))
      pin "theta 0.9942" (11 :: Integer) (minP (4971 % 5000))
  , testCase "d2.3 Kraft over the whole tree is EXACTLY 1 (3.6a's free fact)" $
      pin "kraft root subtree" (1 % 1) (kraftSubtree rootNode)
  , testCase "d2.4 the Kraft recursion: subtree = own + children subtrees" $ do
      let holds n = kraftSubtree n
                 == 1 % (2 ^ gammaBits n)
                  + sum (map kraftSubtree (childrenOf n))
          probeNodes = rootNode : childrenOf rootNode
                    ++ [loChild (loChild (loChild rootNode))]
      pin "recursion at root, children, a depth-3 node" True (all holds probeNodes)
  , testCase "d2.5 level masses (derived: 2^k nodes at 2^-(gammaLen(k+1)+k))" $ do
      -- level mass = 2^-gammaLen(k+1): k=0..6 ->
      -- 1/2, 1/8, 1/8, 1/32, 1/32, 1/32, 1/32
      let level :: Int -> [Node]
          level k = concat (take 1 (drop k (iterate (concatMap childrenOf) [rootNode])))
          mass :: Int -> Rational
          mass k = sum [ 1 % (2 ^ gammaBits n) | n <- level k ]
      pin "levels 0..6"
        [1 % 2, 1 % 8, 1 % 8, 1 % 32, 1 % 32, 1 % 32, 1 % 32]
        (map mass [0 .. 6])
  ]

-- d3 REGIONS — exact dyadic intervals, index-aligned with the
-- frontier (staged diff 3.6; hand: root's frontier = the two
-- depth-1 nodes, spans (0,1/2) and (1/2,1), masses
-- (1/2)*gammaTail(2) = (1/2)*(1/2) = 1/4 each).
dRegion :: TestTree
dRegion = testGroup "d3 regions"
  [ testCase "d3.1 root-only regions: (0,1/2,1/4) and (1/2,1,1/4)" $
      pin "regions" [Region 0 (1 % 2) (1 % 4), Region (1 % 2) 1 (1 % 4)]
        (regions (mkOwned [rootNode]))
  , testCase "d3.2 region i brackets frontier candidate i (the zip contract)" $ do
      let o  = mkOwned (rootNode : childrenOf rootNode)
          ok (c, r) = rLo r <= nodeTheta c && nodeTheta c <= rHi r
      pin "alignment" True (all ok (zip (frontier o) (regions o)))
  ]

-- d4 GUARD — hand-computed exact instances from the frozen rectangle
-- law (num0 + sum m*l*u) / (den0 + sum m*l); derivations in
-- comments, every quantity a small rational.
dGuard :: TestTree
dGuard = testGroup "d4 guard"
  [ testCase "d4.1 root-only, counts (0,0), stakes (1,-1): pess -1/4, opt 1/4" $ do
      -- own: w=1/2, u(1/2)=0 => num0=0, den0=1/2. Regions (d3.1):
      -- l=1 (no evidence), masses 1/4; pess u: min(-1,0)=-1 left,
      -- min(0,1)=0 right => num=-1/4, den=1 => -1/4. opt: 0,1 =>
      -- num=1/4 => 1/4.
      let o = mkOwned [rootNode]
      pin "pess" (-1 % 4) (guardE True o (0, 0) (1, -1))
      pin "opt" (1 % 4) (guardE False o (0, 0) (1, -1))
  , testCase "d4.2 that instance straddles" $
      pin "straddle" True (straddles (mkOwned [rootNode]) (0, 0) (1, -1))
  , testCase "d4.3 all-positive stakes (1,1): guard 1 exactly, no straddle" $ do
      -- u(theta) = 1 for every theta => both placements give 1.
      let o = mkOwned [rootNode]
      pin "pess" (1 % 1) (guardE True o (0, 0) (1, 1))
      pin "no straddle" False (straddles o (0, 0) (1, 1))
  , testCase "d4.4 root-only, counts (1,0), stakes (1,-1): pess -1/5, opt 2/5" $ do
      -- own: w = 1/2 * 1/2 = 1/4, u=0 => num0=0, den0=1/4.
      -- supLike: clip at 1 => left (0,1/2): like 1/2; right: 1.
      -- pess: num = 1/4*1/2*(-1) + 1/4*1*0 = -1/8; den = 1/4 + 1/8
      -- + 1/4 = 5/8 => -1/5. opt: num = 0 + 1/4*1*1 = 1/4 => 2/5.
      let o = mkOwned [rootNode]
      pin "pess" (-1 % 5) (guardE True o (1, 0) (1, -1))
      pin "opt" (2 % 5) (guardE False o (1, 0) (1, -1))
  ]

-- d5 GUARD SAFETY — the signing-review addendum's scheduled row:
-- the two-sided bound under a region system of Kraft mass exactly
-- 1 with nothing dropped, and interval NESTING under refinement
-- (its violation is GroundB's flipped straddle: the truncation
-- dropped mass, so no proper-prior guarantee applied).
dSafety :: TestTree
dSafety = testGroup "d5 guard safety"
  [ testCase "d5.1 nothing dropped: owned mass + region mass == 1" $ do
      let total :: Owned -> Rational
          total o = sum [ 1 % (2 ^ gammaBits n) | n <- ownedNodes o ]
                  + sum [ rMass r | r <- regions o ]
      pin "coarse system" (1 % 1) (total (mkOwned [rootNode]))
      pin "fine system" (1 % 1) (total (mkOwned (treeToDepth 5)))
  , testCase "d5.2 the guard interval NESTS under refinement (battery)" $ do
      let coarse = mkOwned [rootNode]
          fine   = mkOwned (treeToDepth 5)
          counts = [(0, 0), (3, 0), (1, 8), (0, 5), (20, 3)]
          stakes = [(1, -1), (1, -24), (1, -171), (1, -3)]
          nested c st = guardE True coarse c st <= guardE True fine c st
                     && guardE False fine c st <= guardE False coarse c st
      pin "nesting over 20 cells" True
        (and [ nested c st | c <- counts, st <- stakes ])
  ]

-- d6 PURCHASE — the joint law over the exact coordinate; recorded
-- quantities COPIED from x5 pack 3.6a (sealed); world economics
-- fully declared (pwLadderCap the landed X.3 repair).
dPurchase :: TestTree
dPurchase = testGroup "d6 purchase"
  [ testCase "d6.1 moderate cell (COPY 3.6a): wait 2 / respond 35 / refine 3, first respond @5" $ do
      let w = PurchaseWorld { pwStakes = (1, -1)
                            , pwRefine = Just (1 % 20)
                            , pwLadderCap = 16 }
          ticks = runPurchase w (mkOwned [rootNode])
                    (take 40 (cycle [1, 1, 0, 1, 0]))
          acts = zip [0 :: Int ..] (map ptAct ticks)
          n nm = length [ () | (_, a) <- acts, a == nm ]
      pin "wait count" (2 :: Int) (n "wait")
      pin "respond count" (35 :: Int) (n "respond")
      pin "refine count" (3 :: Int) (n "refine")
      pin "first respond" (Just 5 :: Maybe Int)
        (case [ t | (t, a) <- acts, a == "respond" ] of
           (t : _) -> Just t
           []      -> Nothing)
  , testCase "d6.2 DEEP t96 cell (COPY 3.6a): first respond @45, respond x15" $ do
      let w = PurchaseWorld { pwStakes = (1, -24)
                            , pwRefine = Just (1 % 20)
                            , pwLadderCap = 16 }
          ticks = runPurchase w (mkOwned (rootNode : deepChain))
                    (replicate 60 1)
          acts = zip [0 :: Int ..] (map ptAct ticks)
      pin "first respond" (Just 45 :: Maybe Int)
        (case [ t | (t, a) <- acts, a == "respond" ] of
           (t : _) -> Just t
           []      -> Nothing)
      pin "respond count" (15 :: Int)
        (length [ () | (_, a) <- acts, a == "respond" ])
  , testCase "d6.3 no refine row: STATIC vocabulary" $ do
      let w = PurchaseWorld { pwStakes = (1, -24)
                            , pwRefine = Nothing
                            , pwLadderCap = 16 }
          ticks = runPurchase w (mkOwned (rootNode : deepChain))
                    (replicate 60 1)
      pin "nothing bought" True (all (null . ptBought) ticks)
      pin "owned constant" (1 :: Int)
        (length (nub (map (length . ptOwned) ticks)))
  , testCase "d6.4 the cap is world economics: cap 0 kills refine, cap 16 buys" $ do
      -- cap 0: refineV = 0*gain - s - forgone <= -s < 0, never
      -- beats wait (derived from the fold's frozen text).
      let mk cap = PurchaseWorld { pwStakes = (1, -24)
                                 , pwRefine = Just (1 % 20)
                                 , pwLadderCap = cap }
          refines cap =
            length [ () | t <- runPurchase (mk cap)
                                 (mkOwned (rootNode : deepChain))
                                 (replicate 60 1)
                        , ptAct t == "refine" ]
      pin "cap 0" (0 :: Int) (refines 0)
      pin "cap 16 buys" True (refines 16 >= 1)
  , testCase "d6.5 scoreOwned exact posterior (hand: root+children, counts (1,0))" $ do
      -- weights: root 2^-1 * 1/2 = 1/4; children 2^-4 * {1/4, 3/4}
      -- = {1/64, 3/64}; total 5/16 => posterior [4/5, 1/20, 3/20]
      -- in canonical order (price, then theta).
      let b = purchaseScore
      pin "points" [1 % 2, 1 % 4, 3 % 4] (points b)
      pin "weights" [4 % 5, 1 % 20, 3 % 20] (weights b)
  , testCase "d6.6 purchasePredictive exact (hand: P(1) = 21/40)" $ do
      -- P(1) = 4/5 * 1/2 + 1/20 * 1/4 + 3/20 * 3/4 = 21/40.
      let b = purchasePredictive (mkSpace (0 :| [1]))
                (mkOwned (rootNode : childrenOf rootNode)) (1, 0)
      pin "points" [0, 1 :: Int] (points b)
      pin "masses" [19 % 40, 21 % 40] (weights b)
  ]
  where
    purchaseScore =
      scoreOwned (mkOwned (rootNode : childrenOf rootNode)) (1, 0)
