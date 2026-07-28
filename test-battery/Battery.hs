{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
-- THE CERTIFICATION BATTERY (the completeness boundary's third act;
-- charter EXACT_PLAN 14.1/14.2/14.6; opened pack Part XVI).
--
-- PIN-FREEZE form (the step-2 precedent as amended at step 10 and
-- ratified for capability pins): every family row pins the SHIPPED
-- joint loop to an independent exact reference — no implementation
-- is owed, the suite arrives green, and the red half is discharged
-- by seeded-defect demonstration against the committed mutant pool
-- (audit/mutants/, M42-M63 at this increment's close), recorded in
-- the increment's pack with a COMMITTED per-row kill matrix.
--
-- THE FAMILY DERIVES FROM DECLARED AXES (14.1's law; the
-- sweep-universe clause): the axes below are the declaration, the
-- family is their product, the residual is PRINTED by a row, never
-- absorbed. The four t2 acceptance anchors fall out of the walk as
-- four MEMBERS (g-b1.2 pins them against frozen Anchors.t2RowsX).
--
-- R-D20 provenance (copies, never re-derivations):
--   thetaG9                <- test/ExactReference.hs:40 (thetaG)
--   condThetaG             <- test/ExactReference.hs:187 (condTheta;
--                             thetaG generalized to the declared grid)
--   vActG                  <- test/ExactReference.hs:193 (vAct; same)
--   vThinkG                <- test/ExactReference.hs:199 (vThink;
--                             batch/grid generalized, price passed)
--   refDelib               <- test/ExactReference.hs:213 (runDelib;
--                             batch 3 / take 3 generalized to the
--                             declared batch, transcript form)
--   argmaxCL3              <- test/ExactReference.hs:155
--   the kernel sentence    <- test/OracleWorld.hs:60-68 (emitK's
--                             body, quoted over the declared space)
--   tNs                    <- test-jointprep/JointPrep.hs:70
--   prices                 <- Anchors.t2RowsX (read, never re-typed)
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio ((%))
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief (Kernel, Space, mkSpace, uniform)
import PropLang.Eval (Vals (..), evalx, mkEnvIn)
import PropLang.Enumerate (corpusBodies)
import PropLang.Lattice (mkOwned, rootNode)
import PropLang.Membrane (EpisodeShape (..), ExtOpt (..),
                          JointWorld (..), bestExtJ, jointPrepost,
                          runJointW)
import PropLang.Syntax
import Anchors (t2RowsX)
import OracleWorld (egSpace, emitK, obsAtoms, cAtG, oracleWorld)
import Streams (buffer36)

type Q = Rational

pin :: (Eq a, Show a) => String -> a -> a -> Assertion
pin lbl a b = assertEqual lbl a b

tNs :: Namespace
tNs = mkNamespace ("price" :| [])

-- =====================================================================
-- THE DECLARED AXES (the family = their product; nothing else)
-- =====================================================================

thetaG9 :: [Q]
thetaG9 = [1 % 10, 2 % 10, 3 % 10, 4 % 10, 5 % 10, 6 % 10, 7 % 10, 8 % 10, 9 % 10]

gridAxis :: [(String, [Q])]
gridAxis =
  [ ("g9", thetaG9)                                   -- the frozen grid
  , ("g5", [1 % 6, 2 % 6, 3 % 6, 4 % 6, 5 % 6])
  , ("g3", [1 % 4, 2 % 4, 3 % 4])
  ]

priceAxis :: [Q]
priceAxis = [ p | (p, _, _) <- t2RowsX ]              -- read, never re-typed

batchAxis :: [Int]
batchAxis = [1, 2, 3]

streamAxis :: [(String, [Int])]
streamAxis =
  [ ("buffer36", buffer36)
  , ("alt36", take 36 (cycle [1, 0]))
  ]

-- =====================================================================
-- The shipped side: space + kernel DERIVED from a declared grid by the
-- one quoted sentence (OracleWorld.hs:60-68); for the frozen grid the
-- imported egSpace/emitK are used AS IS (a probe reads declared data)
-- =====================================================================

spaceKOf :: String -> [Q] -> (Space Q, Kernel Q Int)
spaceKOf "g9" pts | pts == thetaG9 = (egSpace, emitK)
                  | otherwise = error "spaceKOf: the g9 name is bound to the frozen grid (mandate 4c: the borrow is a function of the POINTS; the name is only its label)" 
spaceKOf _ pts = (sp, k)
  where
    sp = case pts of
      []       -> error "spaceKOf: empty grid (unreachable: axes declared)"
      (p : ps) -> mkSpace (p :| ps)
    zero = cAtG obsAtoms 0
    one = cAtG obsAtoms 1
    body = If (Gt (Var Z) zero) (Var (S Z)) (Sub one (Var (S Z)))
    -- the copy evaluates under tNs/("price",0) where the original
    -- uses wNs/("t",0): inert (the body reads only its binders),
    -- declared here per mandate 6a
    sent = Code sp (carrierSpace (wObs oracleWorld)) body
    k = case mkEnvIn tNs [("price", 0)] VNil of
      Left m -> error ("spaceKOf door (unreachable): " ++ m)
      Right env -> case evalx sent env of
        Just k2 -> k2
        Nothing -> error "spaceKOf: emission code refused (unreachable)"

t2WorldB :: Q -> Int -> JointWorld
t2WorldB p n = JointWorld
  { jwExts = [OLeft, ORight], jwPrice = p, jwBatch = n
  , jwRefine = Nothing, jwDepth = 7
  , jwStakes = (1, -1), jwShape = DecideOnce }

dpWorldB :: (Q, Q) -> JointWorld
dpWorldB st = JointWorld
  { jwExts = [OWait, ORespond], jwPrice = 0, jwBatch = 1
  , jwRefine = Nothing, jwDepth = 7
  , jwStakes = st, jwShape = Standing }

-- =====================================================================
-- The independent reference (R-D20 copies, generalized as headed)
-- =====================================================================

argmaxCL3 :: [(a, Q)] -> (a, Q)
argmaxCL3 [] = error "argmaxCL3: empty"
argmaxCL3 ((a0, v0) : r) = foldl' step (a0, v0) r
  where step (b, bv) (c, cv) = if cv > bv then (c, cv) else (b, bv)

condThetaG :: [Q] -> [Q] -> Int -> ([Q], Q)
condThetaG grid b y =
  let ms = [ w * (if y == 1 then th else 1 - th) | (w, th) <- zip b grid ]
      z = sum ms
  in (map (/ z) ms, z)

vActG :: [Q] -> [Q] -> Q
vActG grid b = snd (argmaxCL3 [ ("L", eL), ("R", eR) ])
  where
    eR = sum [ w * (2 * th - 1) | (w, th) <- zip b grid ]
    eL = negate eR

vThinkG :: [Q] -> [Q] -> Int -> Int -> Q -> Q
vThinkG grid b batch bufLen price = total - price
  where
    batchN = min batch bufLen
    seqs = foldl' (\ss _ -> [ s ++ [y] | s <- ss, y <- [0, 1] ]) [[]]
                  [1 .. batchN]
    total = sum
      [ mass * vActG grid bb
      | s <- seqs
      , let (bb, mass) = foldl'
              (\(bAcc, mAcc) y -> let (b', m) = condThetaG grid bAcc y
                                  in (b', mAcc * m))
              (b, 1) s ]

refDelib :: [Q] -> Q -> Int -> [Int] -> [String]
refDelib grid price batch buf0 =
  go (map (const (1 % fromIntegral (length grid))) grid) buf0
  where
    go b buf =
      let acts = ("act", vActG grid b)
               : [ ("think", vThinkG grid b batch (length buf) price)
                 | not (null buf) ]
          (choice, _) = argmaxCL3 acts
      in if choice == "act"
           then [finalAct b]
           else
             let b' = fst (foldl' (\(bb, m) y ->
                             let (b2, mm) = condThetaG grid bb y
                             in (b2, m * mm))
                           (b, 1 :: Q) (take batch buf))
             in "think" : go b' (drop batch buf)
    finalAct b = fst (argmaxCL3 [ ("L", eL b), ("R", eR b) ])
    eR b = sum [ w * (2 * th - 1) | (w, th) <- zip b grid ]
    eL b = negate (eR b)

-- =====================================================================
-- The rows
-- =====================================================================

familyCells :: [(String, [Q], Q, Int, String, [Int])]
familyCells =
  [ (gn, grid, p, n, sn, stream)
  | (gn, grid) <- gridAxis
  , p <- priceAxis
  , n <- batchAxis
  , (sn, stream) <- streamAxis
  ]

main :: IO ()
main = defaultMain $ testGroup "battery (the certification: executed interpolation over the declared closure)"
  [ testGroup "g-b1 the family rows (shipped == independent reference, exact, per cell)"
      [ testCase (concat ["g-b1.1 [", gn, " p=", show p, " n=", show n, " ", sn, "]"]) $
          let (sp, k) = spaceKOf gn grid
          in pin "transcript" (Right (refDelib grid p n stream))
                 (runJointW tNs sp k (t2WorldB p n) stream)
      | (gn, grid, p, n, sn, stream) <- familyCells ]
  , testCase "g-b1.2 the four anchors fall out of the walk (== frozen t2RowsX)" $
      mapM_ (\(p, nThinks, final) ->
               pin ("anchor p=" ++ show p)
                   (Right (replicate nThinks "think" ++ [final]))
                   (runJointW tNs egSpace emitK (t2WorldB p 3) buffer36))
            t2RowsX
  , testGroup "g-b2 the law rows (the EU commitment itself, exact)"
      [ testCase "g-b2.1 VoI >= 0 at the root of every family cell (jointPrepost >= bestExtJ)" $
          mapM_ (\(gn, grid, p, n, sn, stream) ->
                   let (sp, k) = spaceKOf gn grid
                       w = t2WorldB p n
                       feats = [("price", p)]
                       owned = mkOwned [rootNode]
                       d = min n (length stream)
                       b0 = uniform sp
                   in case (jointPrepost tNs feats w k d b0 owned (0, 0),
                            bestExtJ tNs feats w b0 owned (0, 0)) of
                        (Right pre, Right base) ->
                          assertBool (concat ["VoI<0 at [", gn, " p=", show p,
                                              " n=", show n, " ", sn, "]"])
                                     (pre >= base)
                        (Left m, _) -> assertFailure m
                        (_, Left m) -> assertFailure m)
                familyCells
      , testCase "g-b2.2 scale invariance: the standing act stream is stake-scale-invariant (x2, x5)" $
          mapM_ (\(sn, stream) ->
                   let tr st = case runJointW tNs egSpace emitK (dpWorldB st) stream of
                         Right t -> pure t
                         Left m -> assertFailure ("refusal is not invariance (mandate 4a): " ++ m) >> pure []
                   in do t1 <- tr (1, -24)
                         t2 <- tr (2, -48)
                         t5 <- tr (5, -120)
                         pin ("x2 " ++ sn) t1 t2
                         pin ("x5 " ++ sn) t1 t5)
                streamAxis
      ]
  , testGroup "g-b3 the docketed rows (the jp close's UNREACHED verdicts, given reach)"
      [ testCase "g-b3.1 the standing tie stream, refine declared: stakes (0,0) tie every tick at the DP's act site, wait wins by declaration order" $
          pin "all-wait (CL-3: the first-listed external is the tie's winner; the mint keeps refine strictly dominated so only the wait/respond tie decides)"
              (Right (replicate 40 "wait"))
              (runJointW tNs egSpace emitK
                 ((dpWorldB (0, 0)) { jwRefine = Just (1 % 20) })
                 (replicate 40 1))
      , testCase "g-b3.2 the standing tie stream, refine absent: the same tie at the plain act site" $
          pin "all-wait (the mint-free standing route's menu order; its reversal is a pool candidate at this increment's close)"
              (Right (replicate 40 "wait"))
              (runJointW tNs egSpace emitK (dpWorldB (0, 0)) (replicate 40 1))
      , testCase "g-b3.3 the partial-tail-batch cell (the M47 knife-edge: VoI(1)=0 < p=1/20 < VoI(3)=36/625 at the post-think belief; R-D21 probe in opening/)" $
          let stream = take 4 buffer36
          in pin "think once, then act (the min gates the tail: one remaining obs prices deliberation at VoI(1)-p < 0)"
                 (Right (refDelib thetaG9 (1 % 20) 3 stream))
                 (runJointW tNs egSpace emitK (t2WorldB (1 % 20) 3) stream)
      ]
  , testGroup "g-b4 the enumeration-gate reach rows (OB-21: the corpus GENERATOR's gates, which the intension predicate is blind to)"
      [ testCase "g-b4.1 If arrives at budget 6 and not before (two-sided; the boundary quoted from the frozen 55-pin's name: 'If needs >= 6 nodes')" $ do
          let ns6 = mkNamespace ("t" :| [])
              g2 = mkGrid "theta2" (1 % 10 :| [9 % 10])
              isIf e = case e of { If {} -> True; _ -> False }
          assertBool "budget-5 corpus nonempty (mandate 1b: an empty corpus must not green the gate)"
                     (not (null (corpusBodies ns6 [g2] 5)))
          assertBool "no If body at budget 5 (the gate's green side)"
                     (not (any isIf (corpusBodies ns6 [g2] 5)))
          assertBool "an If body at budget 6 (the gate's live side)"
                     (any isIf (corpusBodies ns6 [g2] 6))
      ]
  , testCase "residual (RECORD row - a printer cannot fail by design, the F6 precedent; the discipline is EXACT_PLAN 14.1: the residual is PRINTED, never absorbed)" $ do
      mapM_ putStrLn
        [ "RESIDUAL axes not walked by this family:"
        , "  - refine/purchase economics on the decide-once face (jwRefine = Nothing here;"
        , "    the standing DP face is pinned by test-jointprep g-jp3/g-jp5 and g-b2.2/g-b3.1)"
        , "  - K>2 obs arities and the guard/tau/rho families (the t1/t3 faces)"
        , "  - stream lengths beyond 36/40; adversarial compositions beyond the two declared"
        , "  - batch depths beyond 3; grids beyond {9,5,3} points"
        , "  - the mint-level differential cell: DRAFTED, awaiting its knife-edge construction"
        , "    (the battery sitting's docket; the M47 cell SHIPPED as g-b3.3 - mandate 3b's repair)"
        ]
      assertBool "residual printed" True
  ]
