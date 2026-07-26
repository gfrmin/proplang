{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- The EXACT acceptance oracle (Phase-1 of the exact re-founding;
-- successor of test/Acceptance.hs; repaired at the R1-R16 sitting).
--
-- Anchors are GENERATED from the executed reference (the generator
-- ships in-tree: ExactReference.hs — R14); streams are the frozen
-- streams BYTE-IDENTICAL. Exact quantities are asserted (==); Double
-- rows are reporting-edge displays (PropLang.Report), deterministic
-- under the pinned toolchain and asserted (==) — ruling R7.
--
-- Runtime status by design: GREEN against the exact surface (the
-- Phase-D overlay carries the SAT transcript; Phase-2 src replays
-- it); COMPILE-RED against the shipped Double src, attributable to
-- the missing exact surface.
--
-- THE AGENT CRITERION rides in t2: the batch-1 AND the composed
-- BATCH-3 preposterior are sentences of the 9+1 grammar, equal to
-- the engine route exactly (R9) — and both go through THE DOOR under
-- t2's own declared World (R5): no doorless env exists in this file.
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio ((%))

import Test.Tasty
import Test.Tasty.HUnit

import qualified Anchors
import OracleWorld
import Streams (buffer36, drift400, flat400, shifted160)

import PropLang.Belief
import PropLang.Enumerate
import PropLang.Eval
import PropLang.Report (entropyAgent)
import PropLang.Syntax

-- the test-1 policy: EU argmax under CL-3 (first-listed incumbent)
t1Act :: Rational -> String
t1Act p1 =
  fst (foldl' (\(b, bv) (c, cv) -> if cv > bv then (c, cv) else (b, bv))
        ("predict1", 2 * p1 - 1)
        [ ("predict0", 1 - 2 * p1), ("consult", 35 % 100) ])

hyps :: [Hyp]
hyps = enumerate oracleWorld fragFull

orDie :: Either String a -> a
orDie = either (\m -> error ("oracle run refused: " ++ m)) id

-- run the sentence engine over a stream, learning
runStream :: [Int] -> ([(Int, Rational, String, Double)], AgentS, Rational)
runStream ys =
  let step (ag, t, m, acc) y =
        let p1 = orDie (predictMassS (doorAt t) 1 ag)
            h = entropyAgent ag
            (mm, ag') = orDie (observeS (doorAt t) y ag)
        in (ag', t + 1, m * mm, (t, p1, t1Act p1, h) : acc)
      (agF, _, marg, accR) =
        foldl' step (sentenceAgent (wNs oracleWorld) hyps, 0 :: Int, 1, []) ys
  in (reverse accR, agF, marg)

margOver :: [FragProd] -> Bool -> [Int] -> Rational
margOver allowed learn ys =
  let hs = enumerate oracleWorld allowed
      step (ag, t, m) y =
        let (mm, ag') = orDie ((if learn then observeS else stepFrozenS)
                                 (doorAt t) y ag)
        in (ag', t + 1, m * mm)
      (_, _, m') = foldl' step (sentenceAgent (wNs oracleWorld) hs, 0 :: Int, 1) ys
  in m'

-- ---------------------------------------------------------------------
-- TEST 2: t2's OWN World (R5) — the deliberation world declares the
-- price feature; every env in this file passes a door
-- ---------------------------------------------------------------------

t2Ns :: Namespace
t2Ns = mkNamespace ("price" :| [])

t2Env :: Rational -> Vals env -> Env env
t2Env p vals = case mkEnvIn t2Ns [("price", p)] vals of
  Right e -> e
  Left m -> error ("t2 door (unreachable): " ++ m)

vActB :: Belief Rational -> Rational
vActB b =
  let eR = expect b (\th -> 2 * th - 1)
      eL = negate eR
  in if eR > eL then eR else eL   -- CL-3: L incumbent, R displaces on >

vThinkB :: Belief Rational -> Int -> Rational -> Rational
vThinkB b bufLen price =
  let batchN = min 3 bufLen
      seqs = foldl' (\ss _ -> [ s ++ [y] | s <- ss, y <- [0, 1] ]) [[]]
                    [1 .. batchN]
      run s = foldl' (\(bb, m) y ->
                case condK bb emitK y of
                  Just bb' -> (bb', m * predictMass bb emitK y)
                  Nothing -> (bb, 0))
                (b, 1) s
  in sum [ m * vActB bb | s <- seqs, let (bb, m) = run s ] - price

runDelibX :: Rational -> [Int] -> (Int, String)
runDelibX price buf0 = go (uniform egSpace) buf0 (0 :: Int)
  where
    go b buf ticks =
      let vA = vActB b
          think = [ vThinkB b (length buf) price | not (null buf) ]
      in case think of
           [vT] | vT > vA ->
             let b' = foldl' (\bb y -> case condK bb emitK y of
                       Just bb' -> bb'
                       Nothing -> bb) b (take 3 buf)
             in go b' (drop 3 buf) (ticks + 1)
           _ -> (ticks, finalAct b)
    finalAct b =
      let eR = expect b (\th -> 2 * th - 1)
          eL = negate eR
      in if eR > eL then "R" else "L"

-- shared sayable pieces (polymorphic in the env tail)
zeroE, oneE, twoE :: Expr env Rational
zeroE = cAtG obsAtoms 0
oneE = cAtG obsAtoms 1
twoE = addM oneE oneE

-- choice over the posterior bound at Z: If/Gt over two Expects (the
-- step-10 idiom — ruling 3's surviving route)
vActS :: Expr (B Rational ': env) Rational
vActS =
  let eR = Expect (Var Z) (Sub (Mul twoE (Var Z)) oneE)
      eL = Expect (Var Z) (Sub oneE (Mul twoE (Var Z)))
  in If (Gt eR eL) eR eL

mass1, mass0 :: Expr env (B Rational) -> Expr env Rational
mass1 b = Expect b (Var Z)
mass0 b = Expect b (Sub oneE (Var Z))

-- THE SAYABLE PREPOSTERIOR, batch 1 (one sentence; door-served price)
vThink1Sentence :: Expr '[K Rational Int, B Rational] Rational
vThink1Sentence =
  Sub (addM (Mul (mass1 b) (v 1)) (Mul (mass0 b) (v 0))) (Get "price")
  where
    b = Var (S Z)
    kv = Var Z
    v y = Cond b kv (cAtG obsAtoms y) vActS zeroE

-- THE SAYABLE PREPOSTERIOR, batch 3 (R9): the full composed sentence —
-- eight branches of nested Cond, masses by Expect, choice by
-- If/Gt-over-Expects, the price by Get. The de Bruijn spellings track
-- the kernel as the scope grows: Z, S Z, S (S Z).
vThink3Sentence :: Expr '[K Rational Int, B Rational] Rational
vThink3Sentence = Sub (lvl1 (Var (S Z)) (Var Z)) (Get "price")
  where
    lvl1 :: Expr '[K Rational Int, B Rational] (B Rational)
         -> Expr '[K Rational Int, B Rational] (K Rational Int)
         -> Expr '[K Rational Int, B Rational] Rational
    lvl1 b k = addM (Mul (mass1 b) (Cond b k oneE lvl2 zeroE))
                    (Mul (mass0 b) (Cond b k zeroE lvl2 zeroE))
    lvl2 :: Expr '[B Rational, K Rational Int, B Rational] Rational
    lvl2 = let b = Var Z
               k = Var (S Z)
           in addM (Mul (mass1 b) (Cond b k oneE lvl3 zeroE))
                   (Mul (mass0 b) (Cond b k zeroE lvl3 zeroE))
    lvl3 :: Expr '[B Rational, B Rational, K Rational Int, B Rational] Rational
    lvl3 = let b = Var Z
               k = Var (S (S Z))
           in addM (Mul (mass1 b) (Cond b k oneE vActS zeroE))
                   (Mul (mass0 b) (Cond b k zeroE vActS zeroE))

-- ---------------------------------------------------------------------
-- TEST 3's quarantined foil: the exact Beta tracker (test-side ONLY —
-- never part of the language; the brief's acceptance test 3 is the
-- comparison, so the foil runs live and its anchors are consumed)
-- ---------------------------------------------------------------------

forgetterLL :: Rational -> [Int] -> Double
forgetterLL gamma ys = negate (logBase 2 (fromRational prod))
  where
    (_, _, prod) = foldl' step (1, 1, 1 :: Rational) ys
    step (a, b, acc) y =
      let p = a / (a + b)
          term = if y == 1 then p else 1 - p
      in (gamma * a + fromIntegral y, gamma * b + fromIntegral (1 - y),
          acc * term)

-- ---------------------------------------------------------------------

main :: IO ()
main = defaultMain $ testGroup "exact acceptance (the re-founded oracle)"
  [ testGroup "the door (ruling 8: fail-closed, refusals named)"
      [ testCase "a full tick passes; missing/undeclared/duplicate are refused" $ do
          let d fs = case mkEnvIn (wNs oracleWorld) fs VNil
                            :: Either String (Env '[]) of
                Right _ -> Nothing
                Left m -> Just m
          d [("t", 3)] @?= Nothing
          d [] @?= Just "tick refused: missing declared [\"t\"]"
          d [("t", 3), ("x", 1)] @?= Just "tick refused: undeclared [\"x\"]"
          d [("t", 3), ("t", 4)] @?= Just "tick refused: duplicate [\"t\"]"
      , testCase "the engine refuses an under-specified tick (no dormancy)" $ do
          let ag = sentenceAgent (wNs oracleWorld) hyps
          case observeS [] 1 ag of
            Left m -> m @?= "tick refused: missing declared [\"t\"]"
            Right _ -> assertFailure "a doorless tick was served"
      ]
  , testGroup "t1 changing world"
      [ testCase "enumeration count" $ length hyps @?= 1169
      , testCase "probe rows: p1 exact" $ do
          let (timeline, _, _) = runStream shifted160
              probeTs = [ t | (t, _, _, _) <- Anchors.t1ProbeRowsX ]
              mine = [ r | r@(t, _, _, _) <- timeline, t `elem` probeTs ]
          assertEqual "row count" (length Anchors.t1ProbeRowsX) (length mine)
          mapM_ (\((t, p, _, _), (t', p', _, _)) -> do
                  assertEqual "t" t' t
                  assertEqual "p1 (exact)" p' p)
            (zip mine Anchors.t1ProbeRowsX)
      , testCase "probe rows: action" $ do
          let (timeline, _, _) = runStream shifted160
              probeTs = [ t | (t, _, _, _) <- Anchors.t1ProbeRowsX ]
              mine = [ r | r@(t, _, _, _) <- timeline, t `elem` probeTs ]
          assertEqual "row count" (length Anchors.t1ProbeRowsX) (length mine)
          mapM_ (\((t, _, a, _), (t', _, a', _)) -> do
                  assertEqual "t" t' t
                  assertEqual "action" a' a)
            (zip mine Anchors.t1ProbeRowsX)
      , testCase "probe rows: H display" $ do
          let (timeline, _, _) = runStream shifted160
              probeTs = [ t | (t, _, _, _) <- Anchors.t1ProbeRowsX ]
              mine = [ r | r@(t, _, _, _) <- timeline, t `elem` probeTs ]
          assertEqual "row count" (length Anchors.t1ProbeRowsX) (length mine)
          mapM_ (\((t, _, _, h), (t', _, _, h')) -> do
                  assertEqual "t" t' t
                  assertEqual "H (display)" h' h)
            (zip mine Anchors.t1ProbeRowsX)
      , testCase "consult ticks (exact list)" $ do
          let (timeline, _, _) = runStream shifted160
          [ t | (t, _, a, _) <- timeline, a == "consult" ]
            @?= Anchors.t1ConsultTicksX
      , testCase "MAP is the change-point guard; exact posterior" $ do
          let (_, agF, _) = runStream shifted160
              (tag, post) = mapS agF
              (i, j, k) = Anchors.t1MapIndicesX
          tag @?= ("guard", [i, j, k])
          post @?= Anchors.t1MapPosteriorX
      , testCase "cumulative marginal (exact)" $ do
          let (_, _, marg) = runStream shifted160
          marg @?= Anchors.t1MarginalX
      , testCase "entropy pre/post (display)" $ do
          let (timeline, _, _) = runStream shifted160
          [ h | (t, _, _, h) <- timeline, t == 59 ] @?= [Anchors.t1HPreX]
          maximum [ h | (t, _, _, h) <- timeline, t >= 60, t < 90 ]
            @?= Anchors.t1HPostMaxX
      ]
  , testGroup "t2 lazy genius (the agent criterion)"
      [ testCase "tick counts and final acts (exact prices)" $
          [ (p, n, a) | p <- [3 % 10, 5 % 100, 5 % 1000, 0]
          , let (n, a) = runDelibX p buffer36 ]
            @?= Anchors.t2RowsX
      , testCase "the batch-1 preposterior is ONE SENTENCE == the engine (door-served)" $ do
          let beliefs = uniform egSpace
                : [ b | y <- [1, 1, 0, 1]
                  , Just b <- [condK (uniform egSpace) emitK y] ]
          mapM_ (\(b, p) ->
                  assertEqual "sentence == engine (batch 1)"
                    (vThinkB b 1 p)
                    (evalx vThink1Sentence (t2Env p (emitK :. b :. VNil))))
            [ (b, p) | b <- beliefs, p <- [0, 5 % 1000, 5 % 100, 3 % 10] ]
      , testCase "the COMPOSED BATCH-3 preposterior is ONE SENTENCE == the engine (R9)" $ do
          let beliefs = uniform egSpace
                : [ b | y <- [1, 0]
                  , Just b <- [condK (uniform egSpace) emitK y] ]
          mapM_ (\(b, p) ->
                  assertEqual "sentence == engine (batch 3)"
                    (vThinkB b 3 p)
                    (evalx vThink3Sentence (t2Env p (emitK :. b :. VNil))))
            [ (b, p) | b <- beliefs, p <- [0, 5 % 100, 3 % 10] ]
      ]
  , testGroup "t3 forgetting trap"
      [ testCase "agent marginals over drift400/flat400 (exact)" $ do
          margOver fragFull True drift400 @?= Anchors.t3AgentDriftMargX
          margOver fragFull True flat400 @?= Anchors.t3AgentFlatMargX
      , testCase "the quarantined forgetter reproduces its anchors, and the RELATIONS hold (R10)" $ do
          let rows = [ (g, forgetterLL g drift400, forgetterLL g flat400)
                     | (g, _, _) <- Anchors.t3ForgetterRowsX ]
          rows @?= Anchors.t3ForgetterRowsX
          -- the brief's test-3 story, asserted from consumed anchors:
          assertBool "agent beats every forgetter on the drifting world"
            (all (\(_, d, _) -> d > Anchors.t3AgentDriftLLX)
                 Anchors.t3ForgetterRowsX)
          assertBool "a tuned forgetter beats the agent on the flat world"
            (any (\(_, _, f) -> f < Anchors.t3AgentFlatLLX)
                 Anchors.t3ForgetterRowsX)
      ]
  , testGroup "t4 deletion audit"
      [ testCase "frozen agent: the engine's 160-tick marginal == 2^-160 EXACTLY" $
          margOver fragFull False shifted160 @?= 1 % (2 ^ (160 :: Int))
      , testCase "full and no-if marginals (exact); no-get COINCIDES (R8)" $ do
          margOver fragFull True shifted160 @?= Anchors.t4MargFullX
          -- The fragment vocabulary has ONE ablation for both if and
          -- get (the guard family needs both), so noif and noget are
          -- THE SAME enumeration {consts, walks} and their anchors are
          -- byte-identical — an extensional COINCIDENCE recorded here,
          -- not two facts. Get's structural deletion proof is Phase
          -- 2's DROP_GET ablation (gate 7).
          Anchors.t4MargNoifX @?= Anchors.t4MargNogetX
          margOver [FBern, FWalk, FConst] True shifted160
            @?= Anchors.t4MargNoifX
      , testCase "drift250 full/nohmm marginals (exact)" $ do
          let d250 = take 250 drift400
          margOver fragFull True d250 @?= Anchors.t4MargFullDX
          margOver [FBern, FIf, FConst, FGuardHead] True d250
            @?= Anchors.t4MargNohmmX
      , testCase "deletion counts" $ do
          let (nf, nc, nb) = Anchors.t4CountsX
          length hyps @?= nf
          length (enumerate oracleWorld [FBern, FWalk, FIf, FGuardHead])
            @?= nc
          length (enumerate oracleWorld [FIf, FConst, FGuardHead]) @?= nb
      ]
  ]
