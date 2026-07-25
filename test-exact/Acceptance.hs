{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- The EXACT acceptance oracle (Phase-1 of the exact re-founding;
-- successor of test/Acceptance.hs, staged in test-exact/ until the
-- author's freeze swaps it into place and re-signs MANIFEST).
--
-- Anchors are GENERATED from the executed A1 reference (Anchors.hs
-- header); streams are the frozen streams BYTE-IDENTICAL. Exact
-- quantities are asserted with (==) — no tolerance exists for an
-- exact quantity; Double rows are reporting-edge displays, computed
-- deterministically under the pinned toolchain and asserted (==).
--
-- Runtime status by design: GREEN against the exact surface (the
-- Phase-D overlay carries the SAT transcript; Phase-2 src replays
-- it); COMPILE-RED against the shipped Double src, attributable to
-- the missing exact surface (the red transcript names the seam).
--
-- The AGENT CRITERION rides in group t2s: the batch-1 preposterior is
-- SAYABLE in the 10+1 grammar and the sentence route equals the
-- engine route exactly — deliberation lives in the language.
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio ((%))

import Test.Tasty
import Test.Tasty.HUnit

import qualified Anchors
import Streams (buffer36, drift400, flat400, shifted160)

import PropLang.Belief
import PropLang.Enumerate
import PropLang.Eval
import PropLang.Syntax

-- ---------------------------------------------------------------------
-- THE ORACLE WORLD (test-side world data — the E3-legal home; the
-- core below never names a point-set)
-- ---------------------------------------------------------------------

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

featsAt :: Int -> [(Name, Rational)]
featsAt t = case doorFeatures (wNs oracleWorld) [("t", fromIntegral t)] of
  Just fs -> fs
  Nothing -> error "door refused the oracle tick (unreachable)"

-- the test-1 policy: EU argmax under CL-3 (first-listed incumbent)
t1Act :: Rational -> String
t1Act p1 =
  fst (foldl' (\(b, bv) (c, cv) -> if cv > bv then (c, cv) else (b, bv))
        ("predict1", 2 * p1 - 1)
        [ ("predict0", 1 - 2 * p1), ("consult", 35 % 100) ])

-- run the sentence engine over a stream, learning
runStream :: [Int] -> ([(Int, Rational, String, Double)], AgentS, Rational)
runStream ys =
  let step (ag, t, m, acc) y =
        let p1 = predictive1S (featsAt t) ag
            h = entropyS ag
            (mm, ag') = observeS (featsAt t) y ag
        in (ag', t + 1, m * mm, (t, p1, t1Act p1, h) : acc)
      (agF, _, marg, accR) =
        foldl' step (sentenceAgent hyps, 0 :: Int, 1, []) ys
  in (reverse accR, agF, marg)

hyps :: [Hyp]
hyps = enumerate oracleWorld fragFull

margOver :: [FragProd] -> Bool -> [Int] -> Rational
margOver allowed learn ys =
  let hs = enumerate oracleWorld allowed
      step (ag, t, m) y =
        let (mm, ag') = (if learn then observeS else stepFrozenS)
                          (featsAt t) y ag
        in (ag', t + 1, m * mm)
      (_, _, m') = foldl' step (sentenceAgent hs, 0 :: Int, 1) ys
  in m'

-- ---------------------------------------------------------------------
-- TEST 2 machinery: the deliberation engine over the sealed exact
-- reasoner, with the emission kernel built FROM A SENTENCE
-- ---------------------------------------------------------------------

egSpace :: Space Rational
egSpace = case [ v | k <- [0 .. gridSize (wTheta oracleWorld) - 1]
               , Just e <- [mkC (wTheta oracleWorld) k]
               , let v = evalx (e :: Expr '[] Rational) (mkEnv [] VNil) ] of
  [] -> error "empty theta codebook (unreachable)"
  (p : ps) -> mkSpace (p :| ps)

atomG :: Grid
atomG = mkGrid "obs-atoms" (0 :| [1])

cAtG :: Grid -> Int -> Expr env Rational
cAtG g k = case mkC g k of
  Just e -> e
  Nothing -> error "cAtG: off-codebook (unreachable)"

emitK :: Kernel Rational Int
emitK =
  let zero = cAtG atomG 0
      one = cAtG atomG 1
      body = If (Gt (Var Z) zero) (Var (S Z)) (Sub one (Var (S Z)))
      sent = Code egSpace (carrierSpace (wObs oracleWorld)) body
  in case evalx sent (mkEnv [] VNil) of
       Just k -> k
       Nothing -> error "emission code refused (unreachable)"

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

-- THE SAYABLE PREPOSTERIOR (the agent-criterion row): batch-1 vThink
-- as ONE SENTENCE of the 10+1 grammar — Expect for the predictive
-- masses, the fused Cond for the posteriors, If/Gt-over-Expects for
-- the inner choice, Get for the world's price. No host fold.
vThink1Sentence :: Expr '[K Rational Int, B Rational] Rational
vThink1Sentence =
  Sub (Add (Mul m1 (v 1)) (Mul m0 (v 0))) (Get "price")
  where
    zero = cAtG atomG 0
    one = cAtG atomG 1
    two = Add one one
    b = Var (S Z)
    kv = Var Z
    m1 = Expect b (Var Z)
    m0 = Expect b (Sub one (Var Z))
    -- Cond binds the posterior at Var Z in the Just arm; the choice
    -- there is If/Gt over two Expects (the step-10 idiom, ruling 3)
    v y = Cond b kv (cAtG atomG y) inner zero
    inner =
      let post = Var Z
          eR = Expect post (Sub (Mul two (Var Z)) one)
          eL = Expect post (Sub one (Mul two (Var Z)))
      in If (Gt eR eL) eR eL

-- ---------------------------------------------------------------------

main :: IO ()
main = defaultMain $ testGroup "exact acceptance (the re-founded oracle)"
  [ testGroup "t1 changing world"
      [ testCase "enumeration count" $ length hyps @?= 1169
      , testCase "probe rows: p1 exact, action, H display" $ do
          let (timeline, _, _) = runStream shifted160
              probeTs = [ t | (t, _, _, _) <- Anchors.t1ProbeRowsX ]
              mine = [ r | r@(t, _, _, _) <- timeline, t `elem` probeTs ]
          assertEqual "row count" (length Anchors.t1ProbeRowsX) (length mine)
          mapM_ (\((t, p, a, h), (t', p', a', h')) -> do
                  assertEqual "t" t' t
                  assertEqual "p1 (exact)" p' p
                  assertEqual "action" a' a
                  assertEqual "H (display)" h' h)
            (zip mine Anchors.t1ProbeRowsX)
      , testCase "consult ticks (exact list)" $ do
          let (timeline, _, _) = runStream shifted160
          [ t | (t, _, a, _) <- timeline, a == "consult" ]
            @?= Anchors.t1ConsultTicksX
      , testCase "MAP is the change-point guard; exact posterior" $ do
          let (_, agF, _) = runStream shifted160
              (tag, post) = mapS agF
          tag @?= ("guard", [ i | i <- tupToList Anchors.t1MapIndicesX ])
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
  , testGroup "t2 lazy genius"
      [ testCase "tick counts and final acts (exact prices)" $
          [ (p, n, a) | (p, _) <- prices, let (n, a) = runDelibX p buffer36 ]
            @?= Anchors.t2RowsX
      , testCase "AGENT CRITERION: the batch-1 preposterior is sayable, and the sentence route == the engine route (exact)" $ do
          let beliefs = uniform egSpace
                : [ b | y <- [1, 1, 0, 1]
                  , Just b <- [condK (uniform egSpace) emitK y] ]
              psx = [0, 5 % 1000, 5 % 100, 3 % 10]
          mapM_ (\(b, p) ->
                  assertEqual "sentence == engine (batch 1)"
                    (vThinkB b 1 p)
                    (evalx vThink1Sentence
                       (mkEnv [("price", p)] (emitK :. b :. VNil))))
            [ (b, p) | b <- beliefs, p <- psx ]
      ]
  , testGroup "t3 forgetting trap"
      [ testCase "agent marginals over drift400/flat400 (exact)" $ do
          margOver fragFull True drift400 @?= Anchors.t3AgentDriftMargX
          margOver fragFull True flat400 @?= Anchors.t3AgentFlatMargX
      ]
  , testGroup "t4 deletion audit"
      [ testCase "frozen agent: marginal == 2^-160 EXACTLY" $ do
          Anchors.t4FrozenIsExactlyHalfPerTickX @?= True
          margOver fragFull False shifted160 @?= 1 % (2 ^ (160 :: Int))
      , testCase "full/noif/noget marginals (exact)" $ do
          margOver fragFull True shifted160 @?= Anchors.t4MargFullX
          margOver [FBern, FWalk, FConst] True shifted160
            @?= Anchors.t4MargNoifX
          margOver [FBern, FWalk, FConst] True shifted160
            @?= Anchors.t4MargNogetX
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
  where
    prices = [ (3 % 10, ()), (5 % 100, ()), (5 % 1000, ()), (0, ()) ]
    tupToList (a, b, c) = [a, b, c]
