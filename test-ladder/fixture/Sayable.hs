{-# LANGUAGE DataKinds #-}

-- The sayable rung valuation (LADDER_PLAN L3/L4; reflexive-closure
-- doctrine): this fixture DOES NOT COMPILE until the Task 2 freeze
-- lands STDNAME's sixth member, VThinkK — that compile failure is the
-- row's red, the deletion audit's inversion, and it is what lets the
-- pre-freeze tree keep every frozen suite green while the sayable
-- surface stays red. Once it compiles, main runs its own assertions:
--
--   1. price: a Call VThinkK sentence of eight Var arguments costs
--      node + lg 7 + 8 * (node + lg 8) under the seven-member alphabet
--      (1e-12) — the pin whose stdB movement the author's one-literal
--      amendment of the frozen expfam pin accompanies;
--   2. identity at the syntax layer: the verb at depth 1 == the frozen
--      VThink verb (exact), and the verb == the exported worker at
--      depths 1..3 (one arithmetic, no drift);
--   3. doctrine: the full lazy-genius episode, driven each tick by
--      evalx of ONE first-order policy sentence (argmax over the
--      published options, nested IsEq dispatch, depths as typed env
--      values — the frozen batchN precedent; the tick's price read by
--      Get "price"), reproduces the oracle's direction-1 pins: ticks,
--      acts, and rung sequences at all four frozen price points.
--
-- Pins duplicated from test-ladder/Ladder.hs carry the same
-- provenance: tick counts and acts are the frozen t2Rows values; rung
-- sequences are the Task-1 intended-behavior pins.
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)), toList)
import Data.Maybe (fromMaybe)
import System.Exit (exitFailure)

import PropLang.Belief
import PropLang.Enumerate (Obs, emit, thetaSpace)
import PropLang.Eval
import PropLang.Membrane (ladderRungs, rungDepth)
import PropLang.Syntax

import Streams (buffer36)

data Dir = DirL | DirR
  deriving (Eq, Show)

dirName :: Dir -> String
dirName DirL = "L"
dirName DirR = "R"

stakes :: Util Dir Double
stakes = mkUtil $ \a th ->
  let v = 2 * th - 1 in case a of DirR -> v; DirL -> negate v

dirs :: NonEmpty Dir
dirs = DirL :| [DirR]

-- the menu as spoken by the policy: the act, then the rungs
-- shallow-first (CL-3 at the menu)
data LOpt = LAct | LRung1 | LRung2 | LRung3
  deriving (Eq, Show)

-- | The ladder policy AS ONE SENTENCE — the frozen policyThink shape
-- extended to the rung menu: argmax over the published options; the
-- act branch values by VAct; each rung branch by VThinkK at its depth,
-- the depth arriving as a typed env value (the batchN precedent) and
-- the price as the feature "t2's honest clock", Get "price".
--
-- Argmax's options argument evaluates in the OUTER environment (the
-- frozen policyThink shape: Var Z there); the value body below is in
-- the extended environment, after Argmax binds the option at Z:
--   S Z            options   :: NonEmpty LOpt
--   S^2 Z          LAct      :: LOpt      (IsEq witnesses)
--   S^3 Z          LRung1    :: LOpt
--   S^4 Z          LRung2    :: LOpt
--   S^5 Z          LRung3    :: LOpt
--   S^6 Z          belief    :: B Double
--   S^7 Z          kernel    :: K Double Obs
--   S^8 Z          outcomes  :: [Obs]
--   S^9 Z          stakes    :: Util Dir Double
--   S^10 Z         acts      :: NonEmpty Dir
--   S^11 Z         batch n   :: Int
--   S^12 Z         depth 1   :: Int
--   S^13 Z         depth 2   :: Int
--   S^14 Z         depth 3   :: Int
policyLadder :: Expr '[ NonEmpty LOpt, LOpt, LOpt, LOpt, LOpt
                      , B Double, K Double Obs, [Obs]
                      , Util Dir Double, NonEmpty Dir
                      , Int, Int, Int, Int ] LOpt
policyLadder =
  Argmax (Var Z)
    (If (Call IsEq (Var Z :* Var (S (S Z)) :* ANil))
        (Call VAct (vB :* vU :* vActs :* ANil))
        (If (Call IsEq (Var Z :* Var (S (S (S Z))) :* ANil))
            (rungBranch vD1)
            (If (Call IsEq (Var Z :* Var (S (S (S (S Z)))) :* ANil))
                (rungBranch vD2)
                (rungBranch vD3))))
  where
    vB    = Var (S (S (S (S (S (S Z))))))
    vK    = Var (S (S (S (S (S (S (S Z)))))))
    vYs   = Var (S (S (S (S (S (S (S (S Z))))))))
    vU    = Var (S (S (S (S (S (S (S (S (S Z)))))))))
    vActs = Var (S (S (S (S (S (S (S (S (S (S Z))))))))))
    vN    = Var (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))
    vD1   = Var (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))
    vD2   = Var (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))
    vD3   = Var (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))
    rungBranch vd =
      Call VThinkK (vd :* vB :* vK :* vYs :* vU :* vActs :* vN
                       :* Get "price" :* ANil)

chosenAct :: Belief Double -> Dir
chosenAct b =
  if expect b (applyUtil stakes DirR) > expect b (applyUtil stakes DirL)
    then DirR else DirL

condBatch :: Belief Double -> [Obs] -> Belief Double
condBatch = foldl' (\bb y ->
  fromMaybe (error "impossible evidence in batch") (cond bb (Saw emit y)))

-- the episode, driven by the sentence: publish options by remaining
-- buffer (the dryness clause), evaluate the ONE policy program, fire
runEpisode :: Double -> (Int, Dir, [Int])
runEpisode p = go 0 [] (uniform thetaSpace) buffer36
  where
    depths = map rungDepth (toList (ladderRungs (mkGrid "depth" (2 :| [3]))))
    (d1, d2, d3) = case depths of
      [x, y, z] -> (x, y, z)
      _         -> error "unexpected rung menu"
    rungOf k | k == d1 = LRung1
             | k == d2 = LRung2
             | otherwise = LRung3
    depthOf o = case o of
      LRung1 -> d1
      LRung2 -> d2
      LRung3 -> d3
      LAct   -> 0
    go ticks ks b buf
      | null buf = (ticks, chosenAct b, reverse ks)
      | otherwise =
          let n = min 3 (length buf)
              opts = LAct :| [ rungOf k | k <- depths
                             , 3 * k <= length buf ]
              env = mkEnv [("price", p)]
                      (opts :. LAct :. LRung1 :. LRung2 :. LRung3
                        :. b :. emit :. ([0, 1] :: [Obs]) :. stakes :. dirs
                        :. n :. d1 :. d2 :. d3 :. VNil)
          in case evalx policyLadder env of
               LAct -> (ticks, chosenAct b, reverse ks)
               o    -> let k = depthOf o
                       in go (ticks + k) (k : ks)
                             (condBatch b (take (3 * k) buf))
                             (drop (3 * k) buf)

-- direction-1 pins (provenance in the module header)
pins :: [(Double, Int, String, [Int])]
pins =
  [ (0.3,   1,  "L", [1])
  , (0.05,  3,  "L", [1, 1, 1])
  , (0.005, 12, "L", [3, 3, 3, 3])
  , (0.0,   12, "L", [3, 3, 3, 3])
  ]

lg :: Double -> Double
lg = logBase 2

unBits :: Bits -> Double
unBits (Bits x) = x

-- a canonical eight-Var VThinkK sentence for the price pin
priceSentence :: Expr '[ Int, B Double, K Double Obs, [Obs]
                       , Util Dir Double, NonEmpty Dir, Int, Double ] Double
priceSentence =
  Call VThinkK (Var Z :* Var (S Z) :* Var (S (S Z)) :* Var (S (S (S Z)))
              :* Var (S (S (S (S Z)))) :* Var (S (S (S (S (S Z)))))
              :* Var (S (S (S (S (S (S Z))))))
              :* Var (S (S (S (S (S (S (S Z))))))) :* ANil)

check :: String -> Bool -> IO Bool
check msg ok = do
  putStrLn ((if ok then "ok   " else "FAIL ") ++ msg)
  pure ok

main :: IO ()
main = do
  let u = uniform thetaSpace
      b3 = condBatch u (take 3 buffer36)
      verb k b n p =
        evalx (Call VThinkK (Var Z :* Var (S Z) :* Var (S (S Z))
                           :* Var (S (S (S Z))) :* Var (S (S (S (S Z))))
                           :* Var (S (S (S (S (S Z)))))
                           :* Var (S (S (S (S (S (S Z))))))
                           :* Var (S (S (S (S (S (S (S Z)))))))
                           :* ANil))
              (mkEnv [] (k :. b :. emit :. ([0, 1] :: [Obs]) :. stakes
                           :. dirs :. n :. p :. VNil))
      vt b n p =
        evalx (Call VThink (Var Z :* Var (S Z) :* Var (S (S Z))
                          :* Var (S (S (S Z))) :* Var (S (S (S (S Z))))
                          :* Var (S (S (S (S (S Z)))))
                          :* Var (S (S (S (S (S (S Z)))))) :* ANil))
              (mkEnv [] (b :. emit :. ([0, 1] :: [Obs]) :. stakes :. dirs
                           :. n :. p :. VNil))
  rs <- sequence
    [ check "price: Call VThinkK = node + lg 7 + eight Var mentions" $
        abs (unBits (bits priceSentence)
             - (lg 19 + lg 7 + 8 * (lg 19 + lg 8))) <= 1e-12
    , check "identity: the verb at depth 1 == the frozen VThink verb" $
        all (\ (b, p) -> verb (1 :: Int) b 3 p == vt b 3 p)
            [ (b, p) | b <- [u, b3], p <- [0.3, 0.05, 0.005, 0] ]
    , check "identity: the verb == the exported worker at depths 1..3" $
        all (\k -> verb k b3 3 0.05
                     == vThinkK k b3 emit ([0, 1] :: [Obs])
                                stakes dirs 3 0.05)
            [1, 2, 3]
    , check "doctrine: the sentence-driven episode reproduces the pins" $
        all (\ (p, tk, a, ks) ->
               let (tk', a', ks') = runEpisode p
               in tk == tk' && a == dirName a' && ks == ks')
            pins
    ]
  if and rs then putStrLn "sayable: all checks pass" else exitFailure
