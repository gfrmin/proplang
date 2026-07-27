{-# LANGUAGE DataKinds #-}
-- THE JOINT-PREPOSTERIOR INCREMENT ORACLE (the completeness
-- boundary's second increment; charter EXACT_PLAN 14.8, register
-- JP1-JP9; the design measured at EV-JP0..JP5, pack Parts IX-X).
-- RED BY DESIGN against the stub surface (runJointW returns Left,
-- jointPolicyWeight errors) until the implementation lands after
-- the author's freeze.
--
-- R-D20 copy table:
--   t2RowsX, buffer36        <- test/Anchors.hs, test/Streams.hs
--                               (IMPORTED, never re-declared)
--   egSpace, emitK           <- test/OracleWorld.hs (IMPORTED)
--   the transcript partition <- test-trampoline g3.3's law: a t2
--                               transcript is thinks then the final
--                               external — replicate n "think"
--                               ++ [final] derives the full pinned
--                               transcript from the frozen rows
--   d61 stream               <- test-dyadic/Dyadic.hs:218
--   the DP cell transcripts  <- test-completeness/opening/
--                               jp4-dp-run.txt / jp5-sayable-route-
--                               run.txt (counts and first-fire
--                               ticks; contiguity asserted by these
--                               rows' own structure and proven at
--                               the SAT run)
--   g-jp6's price literal    <- the frozen weightIn executed over
--                               the drafted 3-row chooser (the
--                               derivation transcript rides pack
--                               Part X's record): 1 % 3^42
--   tNs                      <- test-trampoline/Trampoline.hs:117
--   pin (the forced-expected helper) <- test-dyadic/Dyadic.hs:38-41
--
-- The ruling's discipline (CR2, carried forward): every
-- price-mentioning row derives from the pricing artifact
-- post-deletion; no row inherits a pre-deletion number.

module Main (main) where

import Control.Exception (evaluate)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio ((%))
import Test.Tasty
import Test.Tasty.HUnit

import Data.List (sortOn)
import qualified Data.Map as M
import PropLang.Eval (Vals (..), evalx, mkEnvIn)
import PropLang.Lattice (childrenOf, guardE, mkOwned, nodeTheta,
                         rootNode)
import PropLang.Membrane (EpisodeShape (..), ExtOpt (..),
                          JointWorld (..), jointPolicyWeight,
                          runJointW)
import PropLang.Syntax
import Anchors (t2RowsX)
import OracleWorld (egSpace, emitK)
import Streams (buffer36)

pin :: (Eq a, Show a) => String -> a -> a -> Assertion
pin name expected actual = do
  _ <- evaluate (length (show expected))
  assertEqual name expected actual

tNs :: Namespace
tNs = mkNamespace ("price" :| [])

-- the declared worlds (the cells the design measured)

t2World :: Rational -> JointWorld
t2World p = JointWorld { jwExts = [OLeft, ORight], jwThink = True
                       , jwPrice = p, jwBatch = 3, jwRefine = Nothing
                       , jwStakes = (1, -1), jwShape = DecideOnce }

habitatWorld :: Rational -> JointWorld
habitatWorld p = JointWorld { jwExts = [OWait, ORespond]
                            , jwThink = True, jwPrice = p, jwBatch = 3
                            , jwRefine = Just (1 % 20)
                            , jwStakes = (1, -1), jwShape = DecideOnce }

dpWorld :: (Rational, Rational) -> JointWorld
dpWorld st = JointWorld { jwExts = [OWait, ORespond], jwThink = False
                        , jwPrice = 0, jwBatch = 1
                        , jwRefine = Just (1 % 20)
                        , jwStakes = st, jwShape = Standing }

d61buf :: [Int]
d61buf = take 36 (cycle [1, 1, 0, 1, 0])

main :: IO ()
main = defaultMain $ testGroup "jointprep (the reflexive increment: one menu, one chooser, everywhere)"
  [ testGroup "g-jp1 anchors by declaration (menus are world data; t2 declares [L,R] and keeps its frozen behavior)"
      [ testCase ("g-jp1." ++ show i ++ " price " ++ show p) $
          pin "the t2 transcript, derived from the frozen rows via the g3.3 partition law"
              (Right (replicate n "think" ++ [final]))
              (runJointW tNs egSpace emitK (t2World p) buffer36)
      | (i, (p, n, final)) <- zip [1 :: Int ..] t2RowsX ]
  , testGroup "g-jp2 the phantom cure (the base evaluates THE MENU; honest VoI of an unimprovable menu is zero)"
      [ testCase ("g-jp2 habitat price " ++ show p) $
          pin "wait at tick 0 (EV-JP1's measured cure)"
              (Right ["wait"])
              (runJointW tNs egSpace emitK (habitatWorld p) d61buf)
      | p <- [0, 1 % 20, 3 % 10] ]
  , testGroup "g-jp3 the deadlock cured (the DP: just-in-time chain, no spree, honest decline)"
      [ testCase "g-jp3.1 (1,-24) 60-stream: wait 44, refine 6 just-in-time, respond 10" $
          pin "the full transcript (EV-JP6's both-children optimum; dominance over the hi-spine probe verified: V0 0.6064... > 0.5212...)"
              (Right (replicate 44 "wait" ++ replicate 6 "refine"
                      ++ replicate 10 "respond"))
              (runJointW tNs egSpace emitK (dpWorld (1, -24))
                         (replicate 60 1))
      , testCase "g-jp3.2 (1,-24) 120-stream: respond 69, NO SPREE" $
          pin "the full transcript (EV-JP6; V0 24.9357... > 24.7828...)"
              (Right (replicate 44 "wait" ++ replicate 7 "refine"
                      ++ replicate 69 "respond"))
              (runJointW tNs egSpace emitK (dpWorld (1, -24))
                         (replicate 120 1))
      , testCase "g-jp3.3 (1,-171) 120-stream: the honest decline" $
          pin "all wait (no chain pays at these stakes within the horizon)"
              (Right (replicate 120 "wait"))
              (runJointW tNs egSpace emitK (dpWorld (1, -171))
                         (replicate 120 1))
      ]
  , testGroup "g-jp4 liveness (structural, both shapes)"
      [ testCase "g-jp4.1 standing: |transcript| == |stream| (the clock is the episode)" $
          mapM_ (\(st, len) ->
                   case runJointW tNs egSpace emitK (dpWorld st)
                                  (replicate len 1) of
                     Left m -> assertFailure m
                     Right tr -> pin ("stakes " ++ show st ++ " len "
                                      ++ show len) len (length tr))
                [ ((1, -24), 60), ((1, -24), 120), ((1, -171), 120)
                , ((1, -1), 40) ]
      , testCase "g-jp4.2 decide-once: the final row is an external (F4's law on the joint menu)" $
          mapM_ (\w ->
                   case runJointW tNs egSpace emitK w buffer36 of
                     Left m -> assertFailure m
                     Right tr -> assertBool "final external"
                       (case reverse tr of
                          (a : _) -> a `elem` ["wait", "L", "R", "respond"]
                          [] -> False))
                ([ t2World p | (p, _, _) <- t2RowsX ]
                 ++ [ habitatWorld 0 ])
      ]
  , testGroup "g-jp5 the sayable-route pin (the reference recomputes the values by the quoted formulas and chooses via evalx; EV-JP5's identity as a standing row)"
      [ testCase "g-jp5.1 the DP cells against the sentence-choosing reference" $
          mapM_ (\(st, len) ->
                   pin ("stakes " ++ show st)
                       (refJoint st (replicate len 1))
                       (runJointW tNs egSpace emitK (dpWorld st)
                                  (replicate len 1)))
                [ ((1, -24), 60), ((1, -24), 120) ]
      ]
  , testGroup "g-jp6 the price rows (jointPolicyWeight reads src; the ruling's re-derivation discipline)"
      [ testCase "g-jp6.1 the 3-row joint chooser's weight, DP world" $
          pin "1 % 3^42 (derived from the frozen weightIn over the drafted construction)"
              (1 % 109418989131512359209)
              (jointPolicyWeight (dpWorld (1, -24)))
      , testCase "g-jp6.2 the t2 world's chooser prices identically (same 3-row form)" $
          pin "the same literal (menus of equal arity, the same sentence shape)"
              (1 % 109418989131512359209)
              (jointPolicyWeight (t2World 0))
      ]
  ]

-- ---------------------------------------------------------------
-- the g-jp5 reference: the finite-horizon DP with EVERY choice made
-- by evalx of the shipped-form chooser (COPY of the EV-JP5 program,
-- transcript test-completeness/opening/jp5-sayable-route-run.txt;
-- formulas: V(o,t) = best[wait 0 + V; respond pess + V;
-- refine -s + V(o+c)], V(:,T) = 0; chain extensions, high spine)
-- ---------------------------------------------------------------

refJoint :: (Rational, Rational) -> [Int] -> Either String [String]
refJoint st stream = Right (fst (refSolve st (1 % 20) stream))

refSolve :: (Rational, Rational) -> Rational -> [Int]
         -> ([String], Rational)
refSolve st s stream0 = (runFrom [] 0, tblGet [] total)
  where
    total = length stream0
    countsAt = scanl (\(a, b2) y ->
                        if y == (1 :: Int) then (a + 1, b2)
                                           else (a, b2 + 1))
                     (0, 0) stream0
    cAt t = case drop (t + 1) countsAt of
      (c : _) -> c
      []      -> (total, 0)
    nodeAt path = go2 rootNode path
      where
        go2 n [] = n
        go2 n (hi : rest) = case sortOn nodeTheta (childrenOf n) of
          [lo, hi2] -> go2 (if hi then hi2 else lo) rest
          _ -> n
    ownedOf path = mkOwned (rootNode : [ nodeAt (take i path)
                                       | i <- [1 .. length path] ])
    depthCap = 7 :: Int
    paths = concat [ allP n | n <- [0 .. depthCap] ]
    allP :: Int -> [[Bool]]
    allP 0 = [[]]
    allP n = [ b2 : p2 | p2 <- allP (n - 1), b2 <- [False, True] ]
    pessOf path t = guardE True (ownedOf path) (cAt t) st
    pick vs = either error id (chooseIdxRef vs)
    at i xs = case drop i xs of
      (x : _) -> x
      []      -> error "refSolve: index (unreachable)"
    tbl = M.fromList [ ((path, d), val path d)
                     | d <- [0 .. total], path <- paths ]
    tblGet p2 d2 = M.findWithDefault 0 (p2, d2) tbl
    val path d
      | d <= (0 :: Int) = 0
      | otherwise =
          let t = total - d
              waitV = tblGet path (d - 1)
              respV = pessOf path t + tblGet path (d - 1)
              refVs = [ (-s) + tblGet (path ++ [b2]) (d - 1)
                      | length path < depthCap, b2 <- [False, True] ]
              vs = waitV : respV : refVs
          in at (pick vs) vs
    runFrom path t
      | t >= total = []
      | otherwise =
          let d = total - t
              waitV = tblGet path (d - 1)
              respV = pessOf path t + tblGet path (d - 1)
              refs = [ (path ++ [b2], (-s) + tblGet (path ++ [b2]) (d - 1))
                     | length path < depthCap, b2 <- [False, True] ]
              refRow = case refs of
                [] -> []
                _  -> [ at (pick (map snd refs)) refs ]
              vs = [waitV, respV] ++ map snd refRow
              nms = ["wait", "respond"] ++ [ "refine" | not (null refRow) ]
              nm = at (pick vs) nms
          in case nm of
               "refine" -> case refRow of
                 ((p2, _) : _) -> "refine" : runFrom p2 (t + 1)
                 [] -> error "refSolve: refine row (unreachable)"
               _ -> nm : runFrom path (t + 1)

-- THE SENTENCE CHOOSES (EV-JP5's identity, the reference's own
-- route): evalx of the shipped-form chooseKS over env-bound values
chooseIdxRef :: [Rational] -> Either String Int
chooseIdxRef vs = case vs of
  [v0, v1] -> do
    env <- mkEnvIn refNs [("door", 0)] (v0 :. v1 :. VNil)
    decode (evalx refPolicy2 env)
  [v0, v1, v2] -> do
    env <- mkEnvIn refNs [("door", 0)] (v0 :. v1 :. v2 :. VNil)
    decode (evalx refPolicy3 env)
  [v0, v1, v2, v3] -> do
    env <- mkEnvIn refNs [("door", 0)] (v0 :. v1 :. v2 :. v3 :. VNil)
    decode (evalx refPolicy4 env)
  _ -> Left "chooseIdxRef: unhandled arity (the reference's cells use 2..4)"
  where
    decode code = case lookup code (zip (map fromIntegral [0 :: Int ..])
                                        [0 ..]) of
      Just i  -> Right i
      Nothing -> Left "chooseIdxRef: off-code (unreachable)"

refNs :: Namespace
refNs = mkNamespace ("door" :| [])

refCodeM :: Int -> Expr env Rational
refCodeM i = case mkC (mkGrid "jacts" (0 :| [1, 2])) i of
  Just e  -> e
  Nothing -> error "refCodeM (unreachable)"

refPolicy3 :: Expr '[Rational, Rational, Rational] Rational
refPolicy3 = chooseKS ((refCodeM 0, Var Z)
                   :| [ (refCodeM 1, Var (S Z))
                      , (refCodeM 2, Var (S (S Z))) ])

refPolicy2 :: Expr '[Rational, Rational] Rational
refPolicy2 = chooseKS ((refCodeM 0, Var Z) :| [(refCodeM 1, Var (S Z))])

refCodeM4 :: Int -> Expr env Rational
refCodeM4 i = case mkC (mkGrid "jacts" (0 :| [1, 2, 3])) i of
  Just e  -> e
  Nothing -> error "refCodeM4 (unreachable)"

refPolicy4 :: Expr '[Rational, Rational, Rational, Rational] Rational
refPolicy4 = chooseKS ((refCodeM4 0, Var Z)
                   :| [ (refCodeM4 1, Var (S Z))
                      , (refCodeM4 2, Var (S (S Z)))
                      , (refCodeM4 3, Var (S (S (S Z)))) ])
