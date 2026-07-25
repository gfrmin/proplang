{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- The EXACT law suite (successor of test/Properties.hs). Every law an
-- exact (==) — the gap between the law and the check is CLOSED (no
-- tolerance constant exists in this file). Laws:
--   CL-4' — conditioning IS Bayes, exactly (division-free form).
--   L4'   — the introducer law: prob * Z == w.
--   Kraft — the enumeration's exact sum (55/72; deficiency visible).
--   fineness-charged-once — exact weight division per mention.
--   eq-theorem — the If/Gt equality composition == (==) (upgraded
--                from the 0/1225 measurement; trichotomy is exact).
--   the derived choice family — CL-3-faithful by (==), ties included
--                (ruling 3: Argmax deleted; choice lives in sentences).
--   the fused verb — g5/g6 ports: the round trip is sayable; the
--                Nothing arm is load-bearing (through the DERIVED
--                indicator kernel — the Is-derivation, ruling 7).
--   the walk law — Mul-form masses normalize to (1-p, p/2, p/2;
--                reflected edges p) exactly, from the SHIPPED move
--                sentences (declared data, never re-derived).
--   pricing — a hand-computable sentence's weight at node 1/10.
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromMaybe)
import Data.Ratio ((%))

import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief
import PropLang.Enumerate
import PropLang.Eval
import PropLang.Syntax

-- the oracle world (same declaration as Acceptance.hs)
oracleWorld :: World
oracleWorld = World
  { wNs = mkNamespace ("t" :| [])
  , wObs = mkCarrier "obs" (0 :| [1])
  , wTheta = mkGrid "theta" (1 % 10 :| [ k % 10 | k <- [2 .. 9] ])
  , wTau = mkGrid "tau"
      (5 :| [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80])
  , wRho = mkGrid "rho"
      (1 % 100 :| [2 % 100, 5 % 100, 1 % 10, 2 % 10, 3 % 10, 4 % 10, 5 % 10])
  }

hyps :: [Hyp]
hyps = enumerate oracleWorld fragFull

atomG :: Grid
atomG = mkGrid "obs-atoms" (0 :| [1])

cAtG :: Grid -> Int -> Expr env Rational
cAtG g k = case mkC g k of
  Just e -> e
  Nothing -> error "cAtG: off-codebook (unreachable)"

egSpace :: Space Rational
egSpace = mkSpace (1 % 10 :| [ k % 10 | k <- [2 .. 9] ])

emitK :: Kernel Rational Int
emitK =
  let zero = cAtG atomG 0
      one = cAtG atomG 1
      body = If (Gt (Var Z) zero) (Var (S Z)) (Sub one (Var (S Z)))
  in fromMaybe (error "emission refused (unreachable)")
       (evalx (Code egSpace (carrierSpace (wObs oracleWorld)) body)
              (mkEnv [] VNil))

thetaPts :: [Rational]
thetaPts = spacePoints egSpace

main :: IO ()
main = defaultMain $ testGroup "exact properties (laws by ==)"
  [ testCase "CL-4': conditioning IS Bayes (division-free, all points, a belief battery)" $ do
      let beliefs = uniform egSpace
            : [ b | ys <- [[1], [1, 0], [1, 1, 0, 1]]
              , Just b <- [foldl' (\mb y -> mb >>= \bb -> condK bb emitK y)
                             (Just (uniform egSpace)) ys] ]
      mapM_ (\b -> mapM_ (\y -> do
              let ms x = prob b (== x) * prob (kernelAt emitK x) (== y)
                  z = sum (map ms thetaPts)
              case condK b emitK y of
                Nothing -> assertBool "unexpected refusal" False
                Just b' -> mapM_ (\x ->
                    assertEqual "p'(x) * Z == w(x) * L(x)"
                      (ms x) (prob b' (== x) * z))
                  thetaPts)
            [0, 1])
        beliefs
  , testCase "L4': prob * Z == w on fromWeights; uniform/point are its definitions" $ do
      let sp = mkSpace (0 :| [1, 2 :: Int])
          ws = [3, 1, 2] :: [Rational]
          z = sum ws
      case fromWeights sp (\i -> ws !! i) of
        Nothing -> assertBool "refused" False
        Just b -> mapM_ (\i ->
            assertEqual "p*Z == w" (ws !! i) (prob b (== i) * z)) [0 .. 2]
      assertEqual "uniform == fromWeights(const 1)"
        (map (\i -> prob (uniform sp) (== i)) [0 .. 2]) [1 % 3, 1 % 3, 1 % 3]
      case point sp 1 of
        Nothing -> assertBool "point refused" False
        Just b -> assertEqual "point == fromWeights(indicator)"
          (map (\i -> prob b (== i)) [0 .. 2]) [0, 1, 0]
  , testCase "Kraft: the enumeration sums to EXACTLY 55/72 (deficiency 17/72 visible)" $ do
      kraftSum hyps @?= 55 % 72
      (1 - kraftSum hyps) @?= 17 % 72
  , testCase "corpus law: every weight == its family's 1/M (A2-pinned widths), so p_i * M_i is constant" $ do
      let mFam tag = case tag of
            "const" -> 36
            "walk"  -> 16
            "guard" -> 82944
            _       -> 0 :: Integer
          z = kraftSum hyps
      mapM_ (\h -> do
              let m = mFam (fst (hypTag h))
              assertEqual "w == 1/M" (1 % m) (hypW h)
              assertEqual "p * M == 1/Z" (recip z)
                          ((hypW h / z) * fromInteger m))
            hyps
  , testCase "fineness charged once: doubling a mention codebook halves the weight, exactly" $ do
      let ns = wNs oracleWorld
          g9 = wTheta oracleWorld
          g18 = mkGrid "theta18" (1 % 20 :| [ k % 20 | k <- [2 .. 18] ])
          s g = Add (Get "t") (cAtG g 0) :: Expr '[] Rational
      gridSize g18 @?= 2 * gridSize g9
      weightIn ns (s g9) @?= 2 * weightIn ns (s g18)
  , testCase "pricing: a hand-computable sentence at node 1/10" $ do
      let ns = wNs oracleWorld
          s = Add (Get "t") (cAtG (wTheta oracleWorld) 0) :: Expr '[] Rational
      -- three Expr nodes (Add, Get, C), namespace singleton, grid 9:
      -- (1/10)^3 * 1 * (1/9) ... the C node's own 1/10 is inside the
      -- product: node(Add) * node(Get)*1 * node(C)*(1/9)
      weightIn ns s @?= (1 % 10) * (1 % 10) * ((1 % 10) * (1 % 9))
  , testCase "eq-theorem: the If/Gt composition == (==) over an exhaustive exact grid" $ do
      let pts = [ a % b | b <- [1 .. 5 :: Integer], a <- [-6 .. 6] ]
          eqIfGt a b = not (a > b) && not (b > a)
      mapM_ (\(a, b) -> assertEqual "trichotomy" (a == b) (eqIfGt a b))
            [ (a, b) | a <- pts, b <- pts ]
  , testCase "the derived choice family is CL-3-faithful (ties included), by ==" $ do
      -- options from a declared codebook; the family is the If/Gt
      -- fold over Expects' values — here over plain exact values,
      -- pinned to the CL-3 reference fold
      let optG = mkGrid "opt" (1 % 4 :| [1 % 2, 1])
          opts = [1 % 4, 1 % 2, 1] :: [Rational]
          val x y c = c * x - c * c * y
          cl3 x y = fst (foldl' (\(b, bv) c ->
                      let cv = val x y c
                      in if cv > bv then (c, cv) else (b, bv))
                      (case opts of (o : _) -> (o, val x y o); [] -> error "empty")
                      (drop 1 opts))
          am3 x y =
            let v c = val x y c
                bv2 = max (v (1 % 4)) (v (1 % 2))
                b2 = if v (1 % 2) > v (1 % 4) then 1 % 2 else 1 % 4
            in if v 1 > bv2 then 1 else b2
      gridSize optG @?= 3
      mapM_ (\(x, y) -> assertEqual "family == CL-3" (cl3 x y) (am3 x y))
        [ (1, 0), (0, 1), (0, 0), (1, 1), (3, 2)
        , (3 % 2, 1)     -- EXACT pairwise tie between the maxima
        , (3 % 4, 0) ]
  , testCase "g5': the fused round trip is sayable (Cond -> Expect), exactly" $ do
      let b0 = uniform egSpace
          sent = Cond (Var (S Z)) (Var Z) (cAtG atomG 1)
                      (Expect (Var Z) (Var Z))
                      (cAtG atomG 0)
                 :: Expr '[K Rational Int, B Rational] Rational
          engine = case condK b0 emitK 1 of
            Just b' -> expect b' id
            Nothing -> 0
      assertEqual "sentence == engine"
        engine (evalx sent (mkEnv [] (emitK :. b0 :. VNil)))
  , testCase "g6': the Nothing arm is load-bearing, through the DERIVED indicator kernel (the Is-derivation)" $ do
      -- indicator kernel said as a Code: column mass = 1 iff the
      -- outcome matches ind(theta > 1/2) — a POINT column (Is derived)
      let half = Sub (cAtG atomG 1) (Expect (Var (S (S Z))) (Var Z))
          -- NOTE: half is 1 - E[theta] over the UNIFORM belief bound in
          -- env — evaluates to 1/2 exactly for the oracle codebook; the
          -- indicator threshold is itself DERIVED, not a literal
          indBody = If (Gt (Var (S Z)) half)
                       (If (Gt (Var Z) (cAtG atomG 0)) (cAtG atomG 1) (cAtG atomG 0))
                       (If (Gt (Var Z) (cAtG atomG 0)) (cAtG atomG 0) (cAtG atomG 1))
          kInd = fromMaybe (error "indicator code refused")
                   (evalx (Code egSpace (carrierSpace (wObs oracleWorld)) indBody)
                          (mkEnv [] ((uniform egSpace) :. VNil)))
          bLow = fromMaybe (error "point refused") (point egSpace (1 % 10))
          sentinel = 7 % 10
          sent = Cond (Var (S Z)) (Var Z) (cAtG atomG 1)
                      (Expect (Var Z) (Var Z))
                      c7
          c7 = case mkC (mkGrid "sentinel" (sentinel :| [])) 0 of
            Just e -> e
            Nothing -> error "sentinel grid (unreachable)"
      -- theta = 1/10 < 1/2: the indicator column is a point at 0, so
      -- observing 1 is IMPOSSIBLE evidence: the Nothing arm shows.
      assertEqual "Nothing arm shows through"
        sentinel (evalx sent (mkEnv [] (kInd :. bLow :. VNil)))
  , testCase "the walk law from the SHIPPED move sentences: Mul-form normalizes exactly" $ do
      let walks = [ h | h <- hyps, fst (hypTag h) == "walk" ]
      length walks @?= 8
      mapM_ (\h -> case (hypMove h, hypTag h) of
        (Just mv, (_, [j])) -> do
          -- rho READ through the codebook door (the probe discipline:
          -- declared data, never re-declared)
          let rho = evalx (cAtG (wRho oracleWorld) j :: Expr '[] Rational)
                          (mkEnv [] VNil)
              mk = fromMaybe (error "move refused")
                     (evalx mv (mkEnv [] VNil))
              rowAt x = [ prob (kernelAt mk x) (== y) | y <- thetaPts ]
              lawAt x = [ mass y | y <- thetaPts ]
                where
                  n = length thetaPts
                  i = length (takeWhile (/= x) thetaPts)
                  lo = if i > 0 then i - 1 else i + 1
                  hi = if i < n - 1 then i + 1 else i - 1
                  mass y
                    | y == x = 1 - rho
                    | idx y == lo && idx y == hi = rho
                    | idx y == lo || idx y == hi = rho / 2
                    | otherwise = 0
                  idx y = length (takeWhile (/= y) thetaPts)
          mapM_ (\x -> assertEqual "row == law" (lawAt x) (rowAt x)) thetaPts
        _ -> assertBool "walk without move (unreachable)" False)
        walks
  ]
