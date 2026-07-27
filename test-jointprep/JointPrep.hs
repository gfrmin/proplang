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
import PropLang.Lattice (Node, childrenOf, guardE, mkOwned, nodeTheta,
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
      [ testCase "g-jp3.1 (1,-24) 60-stream: wait 45, refine 5 just-in-time, respond 10" $
          pin "the full transcript (EV-JP4/JP5, byte-identical routes)"
              (Right (replicate 45 "wait" ++ replicate 5 "refine"
                      ++ replicate 10 "respond"))
              (runJointW tNs egSpace emitK (dpWorld (1, -24))
                         (replicate 60 1))
      , testCase "g-jp3.2 (1,-24) 120-stream: respond 69, NO SPREE" $
          pin "the full transcript"
              (Right (replicate 45 "wait" ++ replicate 6 "refine"
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
refSolve st s stream0 = goRun [] 0
  where
    total = length stream0
    path = refSpine rootNode (7 :: Int)
    chains = [] : [ reverse (take k path) | k <- [1 .. 7] ]
    candidates ch = case ch of
      [] -> childrenOf rootNode
      (top : _) -> childrenOf top
    memo = M.fromList [ ((ch, t), value ch t)
                      | t <- [0 .. total], ch <- chains ]
    vOf ch t = M.findWithDefault 0 (ch, t) memo
    pessAt ch c = guardE True (mkOwned (rootNode : ch)) c st
    value ch t
      | t >= total = 0
      | otherwise =
          let c = (t + 1, 0)
              wait = vOf ch (t + 1)
              resp = pessAt ch c + vOf ch (t + 1)
              refs = [ (-s) + vOf (cand : ch) (t + 1)
                     | cand <- candidates ch, (cand : ch) `elem` chains ]
          in maximum (wait : resp : refs)
    goRun ch t
      | t >= total = ([], 0)
      | otherwise =
          let c = (t + 1, 0)
              wait = vOf ch (t + 1)
              resp = pessAt ch c + vOf ch (t + 1)
              refs = [ ((-s) + vOf (cand : ch) (t + 1), cand)
                     | cand <- candidates ch, (cand : ch) `elem` chains ]
              -- THE SENTENCE CHOOSES (EV-JP5's identity): evalx of
              -- the shipped-form chooseKS over env-bound values
              code = case refs of
                [] -> case mkEnvIn refNs [("door", 0)]
                             (wait :. resp :. VNil) of
                  Right env -> evalx refPolicy2 env
                  Left m -> error m
                _  -> let refv = maximum (map fst refs)
                      in case mkEnvIn refNs [("door", 0)]
                                 (wait :. resp :. refv :. VNil) of
                           Right env -> evalx refPolicy3 env
                           Left m -> error m
              cn = case lookup code (zip (map fromIntegral
                                           [0 :: Int ..])
                                         ["wait", "respond", "refine"]) of
                Just nm -> nm
                Nothing -> error "off-code (unreachable)"
              ch' = case cn of
                "refine" -> snd (maximum refs) : ch
                _ -> ch
              step = case cn of
                "respond" -> pessAt ch c
                "refine"  -> -s
                _         -> 0
              (rest, tot) = goRun ch' (t + 1)
          in (cn : rest, step + tot)

refSpine :: Node -> Int -> [Node]
refSpine n k = case sortOn nodeTheta (childrenOf n) of
  [_, hi] | k > 0 -> hi : refSpine hi (k - 1)
  _ -> []

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
