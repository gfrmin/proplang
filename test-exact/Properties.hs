{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
-- The EXACT law suite (successor of test/Properties.hs; repaired at
-- the R1-R16 sitting). Every law an exact (==); no tolerance constant
-- exists in this file. THE B2 REPAIR governs its shape: every
-- compensating pin EVALUATES THE GRAMMAR — the eq-theorem row builds
-- If/Gt sentences and runs evalx; the choice-family row builds the
-- If/Gt-over-Expects sentences; a pin that never touches a sentence
-- is a green that cannot fail, and none ships here.
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromMaybe)
import Data.Ratio ((%))

import Test.Tasty
import Test.Tasty.HUnit

import OracleWorld

import PropLang.Belief
import PropLang.Enumerate
import PropLang.Eval
import PropLang.Syntax

hyps :: [Hyp]
hyps = enumerate oracleWorld fragFull

thetaPts :: [Rational]
thetaPts = spacePoints egSpace

-- a probe WORLD for value batteries: the battery points are a
-- declared codebook (test-side world data), mentioned — never typed
-- into sentences by hand
probeG :: Grid
probeG = mkGrid "probe"
  (-3 :| [-1 % 2, 0, 1 % 7, 1 % 10, 1 % 2, 1, 9 % 10, 82944 % 55])

probeEnv :: Vals env -> Env env
probeEnv vals = case mkEnvIn (mkNamespace ("u" :| [])) [("u", 0)] vals of
  Right e -> e
  Left m -> error ("probe door (unreachable): " ++ m)

main :: IO ()
main = defaultMain $ testGroup "exact properties (laws by ==)"
  [ testCase "CL-4': conditioning IS Bayes (division-free, all points, a belief battery)" $ do
      let beliefs = uniform egSpace
            : [ b | ys <- [[1], [1, 0], [1, 1, 0, 1]]
              , Just b <- [foldl (\mb y -> mb >>= \bb -> condK bb emitK y)
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
  , testCase "Kraft: the enumeration sums to EXACTLY 55/72" $
      kraftSum hyps @?= 55 % 72
  , testCase "corpus law: every weight == its family's 1/M (A2-pinned widths)" $ do
      let mFam tag = case tag of
            "const" -> 36
            "walk"  -> 16
            "guard" -> 82944
            _       -> 0 :: Integer
      mapM_ (\h -> assertEqual "w == 1/M"
              (1 % mFam (fst (hypTag h))) (hypW h))
            hyps
  , testCase "fineness charged once: doubling a mention codebook halves the weight, exactly" $ do
      let ns = wNs oracleWorld
          g9 = wTheta oracleWorld
          g18 = mkGrid "theta18" (1 % 20 :| [ k % 20 | k <- [2 .. 18] ])
          s g = Sub (Get "t") (cAtG g 0) :: Expr '[] Rational
      gridSize g18 @?= 2 * gridSize g9
      weightIn ns (s g9) @?= 2 * weightIn ns (s g18)
  , testCase "pricing: a hand-computable sentence at node 1/9 (the 9/1 table)" $ do
      let ns = wNs oracleWorld
          s = Sub (Get "t") (cAtG (wTheta oracleWorld) 0) :: Expr '[] Rational
      -- three Expr nodes (Sub, Get, C), namespace singleton, grid 9:
      -- node(Sub) * node(Get)*1 * node(C)*(1/9)
      weightIn ns s @?= (1 % 9) * (1 % 9) * ((1 % 9) * (1 % 9))
  , testCase "eq-THEOREM: the If/Gt SENTENCE == (==), evalx over mention pairs (B2 repair)" $ do
      -- the equality composition AS A SENTENCE over codebook mentions,
      -- evaluated by the grammar's own Gt/If — a wrong Gt reds this row
      let n = gridSize probeG
          eqSent i j =
            let a = cAtG probeG i
                b = cAtG probeG j
                trueE = Gt (cAtG probeG 6) (cAtG probeG 2)   -- 1 > 0
                falseE = Gt (cAtG probeG 2) (cAtG probeG 6)  -- 0 > 1
            in If (Gt a b) falseE (If (Gt b a) falseE trueE)
          valAt i = case mkC probeG i of
            Just (C _ _ v) -> v
            _ -> error "probe read (unreachable)"
      mapM_ (\(i, j) ->
              assertEqual "sentence-eq == (==)"
                (valAt i == valAt j)
                (evalx (eqSent i j) (probeEnv VNil)))
        [ (i, j) | i <- [0 .. n - 1], j <- [0 .. n - 1] ]
  , testCase "the derived CHOICE SENTENCES are CL-3-faithful, ties included (B2 repair)" $ do
      -- the per-K argmax family AS SENTENCES: values are Expects over
      -- an env-bound belief, options are codebook mentions, the fold
      -- is If/Gt — evaluated by evalx and pinned to the CL-3 reference
      -- fold over the SAME evalx'd values
      let optG = mkGrid "opt" (1 % 4 :| [1 % 2, 1])
          oneE = cAtG obsAtoms 1
          -- value of option c: E_b[c * (2*theta - 1)] — the mass x
          -- value shape (Mul's preposterior keep, exercised)
          vOf :: Int -> Expr '[B Rational] Rational
          vOf i = Expect (Var Z)
                    (Mul (cAtG optG i)
                         (Sub (Mul (addM oneE oneE) (Var Z)) oneE))
          am3 :: Expr '[B Rational] Rational
          am3 = If (Gt (vOf 2) bv2) (cAtG optG 2) b2
            where
              bv2 = If (Gt (vOf 1) (vOf 0)) (vOf 1) (vOf 0)
              b2 = If (Gt (vOf 1) (vOf 0)) (cAtG optG 1) (cAtG optG 0)
          env b = probeEnv (b :. VNil)
          optAt i = case mkC optG i of
            Just (C _ _ v) -> v
            _ -> error "opt read (unreachable)"
          cl3 b = fst (foldl (\(w, wv) i ->
                    let cv = evalx (vOf i) (env b)
                    in if cv > wv then (optAt i, cv) else (w, wv))
                    (optAt 0, evalx (vOf 0) (env b)) [1, 2])
          beliefs = uniform egSpace       -- E[2th-1] == 0: ALL TIE
            : [ b | ys <- [[1], [0], [1, 1], [0, 1, 0, 0]]
              , Just b <- [foldl (\mb y -> mb >>= \bb -> condK bb emitK y)
                             (Just (uniform egSpace)) ys] ]
      mapM_ (\b -> assertEqual "choice sentence == CL-3 reference"
                     (cl3 b) (evalx am3 (env b)))
            beliefs
      -- the full-tie case pinned explicitly: uniform belief values all
      -- options at 0; the first-listed (1/4) must win on both routes
      assertEqual "full tie -> first-listed"
        (1 % 4) (evalx am3 (env (uniform egSpace)))
  , testCase "g5': the fused round trip is sayable (Cond -> Expect), exactly" $ do
      let b0 = uniform egSpace
          sent = Cond (Var (S Z)) (Var Z) (cAtG obsAtoms 1)
                      (Expect (Var Z) (Var Z))
                      (cAtG obsAtoms 0)
                 :: Expr '[K Rational Int, B Rational] Rational
          engine = case condK b0 emitK 1 of
            Just b' -> expect b' id
            Nothing -> 0
      assertEqual "sentence == engine"
        engine (evalx sent (probeEnv (emitK :. b0 :. VNil)))
  , testCase "g6': the Nothing arm is load-bearing, through the DERIVED indicator kernel" $ do
      let half = Sub (cAtG obsAtoms 1) (Expect (Var (S (S Z))) (Var Z))
          indBody = If (Gt (Var (S Z)) half)
                       (If (Gt (Var Z) (cAtG obsAtoms 0))
                           (cAtG obsAtoms 1) (cAtG obsAtoms 0))
                       (If (Gt (Var Z) (cAtG obsAtoms 0))
                           (cAtG obsAtoms 0) (cAtG obsAtoms 1))
          kInd = fromMaybe (error "indicator code refused")
                   (evalx (Code egSpace (carrierSpace (wObs oracleWorld)) indBody)
                          (probeEnv (uniform egSpace :. VNil)))
          bLow = fromMaybe (error "point refused") (point egSpace (1 % 10))
          sentinelG = mkGrid "sentinel" (7 % 10 :| [])
          sent = Cond (Var (S Z)) (Var Z) (cAtG obsAtoms 1)
                      (Expect (Var Z) (Var Z))
                      (cAtG sentinelG 0)
      -- theta = 1/10 < 1/2: the indicator column is a point at 0;
      -- observing 1 is IMPOSSIBLE evidence — the Nothing arm shows
      assertEqual "Nothing arm shows through"
        (7 % 10) (evalx sent (probeEnv (kInd :. bLow :. VNil)))
  , testCase "R1 rider: an OFF-CODEBOOK outcome is impossible evidence — the Nothing arm, pinned" $ do
      let b0 = uniform egSpace
          offG = mkGrid "off" (7 % 2 :| [])   -- 7/2 matches NO obs atom
          sent = Cond (Var (S Z)) (Var Z) (cAtG offG 0)
                      (Expect (Var Z) (Var Z))
                      (cAtG obsAtoms 0)
                 :: Expr '[K Rational Int, B Rational] Rational
      assertEqual "off-codebook outcome -> all-zero column -> Nothing arm"
        0 (evalx sent (probeEnv (emitK :. b0 :. VNil)))
  , testCase "the walk law from the SHIPPED move sentences: Mul-form normalizes exactly" $ do
      let walks = [ h | h <- hyps, fst (hypTag h) == "walk" ]
      length walks @?= 8
      mapM_ (\h -> case (hypMove h, hypTag h) of
        (Just mv, (_, [j])) -> do
          let rho = case mkC (wRho oracleWorld) j :: Maybe (Expr '[] Rational) of
                Just (C _ _ v) -> v
                _ -> error "rho read (unreachable)"
              mk = fromMaybe (error "move refused")
                     (evalx mv (probeEnv VNil))
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
