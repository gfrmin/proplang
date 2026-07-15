{-# LANGUAGE DataKinds #-}

-- The sayable action-dependent preposterior (PREPOSTERIOR_PLAN P4/P9;
-- reflexive-closure doctrine): this fixture DOES NOT COMPILE until the
-- Task 2 freeze lands STDNAME's seventh member, VPre — that compile
-- failure is the row's red (the inversion), and per the canonized
-- fixture-proof habit its red is DEMONSTRATED to be the missing
-- constructor by type-checking this file against the drafted future
-- surface before the freeze. Once it compiles, main runs:
--
--   1. price: a Call VPre sentence of ten Var arguments costs
--      node + lg 6 + 10 * (node + lg 10) under the six-member
--      alphabet (1e-12; the step-3 re-pricing: STDNAME 7 -> 6 (Bern left the stdlib at the step-3 freeze; P5 pin re-pricing under the recorded delegation, D4 adjudication)) — the pin whose stdB movement
--      the author's two frozen literal amendments accompanied at r0;
--   2. identity at the syntax layer: the verb == the exported worker,
--      and the degenerate verb == the frozen VThinkK verb (==);
--   3. doctrine: decision 1 of both worlds, driven by evalx of ONE
--      first-order policy sentence (argmax over the published menu,
--      IsEq dispatch, per-branch singleton menus and depths as typed
--      env values — the batchN precedent; the tick's price read by
--      Get "price"), reproduces the oracle's pins: probe in W at
--      s=0.05, safe in W at s=0.4, safe in the control W0.
--
-- Pins duplicated from test-prepost/Prepost.hs carry the same
-- provenance (Task-1 intended-behavior pins; margins in the pack).
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromMaybe)
import System.Exit (exitFailure)

import PropLang.Belief
import PropLang.Enumerate (Obs, emit, obsCarrier, thetaSpace)
import PropLang.Eval
import PropLang.Syntax

data Dir = DirL | DirR
  deriving (Eq, Show)

stakes :: Util Dir Double
stakes = mkUtil $ \a th ->
  let v = 2 * th - 1 in case a of DirR -> v; DirL -> negate v

dirs :: NonEmpty Dir
dirs = DirL :| [DirR]

data D1 = Safe | Probe
  deriving (Eq, Show)

noise :: Kernel Double Obs
noise = kernel thetaSpace (carrierSpace obsCarrier)
               (\_ -> bernFast obsCarrier 0.5)

immW :: Double -> Util D1 Double
immW s = mkUtil $ \d _ -> case d of Safe -> s; Probe -> 0

chanW, chanC :: Chan D1 Double Obs
chanW = mkChan $ \d -> case d of Safe -> noise; Probe -> emit
chanC = mkChan (const noise)

condBatch :: Kernel Double Obs -> Belief Double -> [Obs] -> Belief Double
condBatch k = foldl' (\bb y ->
  fromMaybe (error "impossible evidence in batch") (cond bb (Saw k y)))

b0 :: Belief Double
b0 = condBatch emit (uniform thetaSpace) [1]

-- | The decision policy AS ONE SENTENCE: argmax over the published
-- decision menu; each branch values its decision by Call VPre at that
-- decision's SINGLETON menu (bound in the env), the price read by
-- Get "price". Argmax's options argument evaluates in the OUTER
-- environment (Var Z — the frozen policyThink shape); the value body
-- is in the extended environment, after Argmax binds the decision:
--   S Z    menu     :: NonEmpty D1
--   S^2 Z  Safe     :: D1          (IsEq witness)
--   S^3 Z  depth    :: Int
--   S^4 Z  belief   :: B Double
--   S^5 Z  channel  :: Chan D1 Double Obs
--   S^6 Z  outcomes :: [Obs]
--   S^7 Z  imm      :: Util D1 Double
--   S^8 Z  dsSafe   :: NonEmpty D1  (singleton Safe)
--   S^9 Z  dsProbe  :: NonEmpty D1  (singleton Probe)
--   S^10 Z stakes   :: Util Dir Double
--   S^11 Z acts     :: NonEmpty Dir
--   S^12 Z n        :: Int
policyPre :: Expr '[ NonEmpty D1, D1, Int, B Double, Chan D1 Double Obs
                   , [Obs], Util D1 Double, NonEmpty D1, NonEmpty D1
                   , Util Dir Double, NonEmpty Dir, Int ] D1
policyPre =
  Argmax (Var Z)
    (If (Call IsEq (Var Z :* Var (S (S Z)) :* ANil))
        (branch (Var (S (S (S (S (S (S (S (S Z))))))))))
        (branch (Var (S (S (S (S (S (S (S (S (S Z))))))))))))
  where
    vDepth = Var (S (S (S Z)))
    vB     = Var (S (S (S (S Z))))
    vChan  = Var (S (S (S (S (S Z)))))
    vYs    = Var (S (S (S (S (S (S Z))))))
    vImm   = Var (S (S (S (S (S (S (S Z)))))))
    vU     = Var (S (S (S (S (S (S (S (S (S (S Z))))))))))
    vActs  = Var (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))
    vN     = Var (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))
    branch vDs =
      Call VPre (vDepth :* vB :* vChan :* vYs :* vImm :* vDs
                        :* vU :* vActs :* vN :* Get "price" :* ANil)

-- the sentence-driven decision for a world and a safe-pay
decideS :: Chan D1 Double Obs -> Double -> D1
decideS ch s =
  evalx policyPre
    (mkEnv [("price", 0.01)]
       ((Safe :| [Probe]) :. Safe :. (1 :: Int) :. b0 :. ch
         :. ([0, 1] :: [Obs]) :. immW s :. (Safe :| []) :. (Probe :| [])
         :. stakes :. dirs :. (3 :: Int) :. VNil))

lg :: Double -> Double
lg = logBase 2

unBits :: Bits -> Double
unBits (Bits x) = x

-- a canonical ten-Var VPre sentence for the price pin
priceSentence :: Expr '[ Int, B Double, Chan D1 Double Obs, [Obs]
                       , Util D1 Double, NonEmpty D1, Util Dir Double
                       , NonEmpty Dir, Int, Double ] Double
priceSentence =
  Call VPre (Var Z :* Var (S Z) :* Var (S (S Z)) :* Var (S (S (S Z)))
           :* Var (S (S (S (S Z)))) :* Var (S (S (S (S (S Z)))))
           :* Var (S (S (S (S (S (S Z))))))
           :* Var (S (S (S (S (S (S (S Z)))))))
           :* Var (S (S (S (S (S (S (S (S Z))))))))
           :* Var (S (S (S (S (S (S (S (S (S Z)))))))))
           :* ANil)

-- the verb through the evaluator, mirroring the oracle's val1
verbVal :: Chan D1 Double Obs -> Double -> D1 -> Double
verbVal ch s d =
  evalx (Call VPre (Var Z :* Var (S Z) :* Var (S (S Z))
                  :* Var (S (S (S Z))) :* Var (S (S (S (S Z))))
                  :* Var (S (S (S (S (S Z)))))
                  :* Var (S (S (S (S (S (S Z))))))
                  :* Var (S (S (S (S (S (S (S Z)))))))
                  :* Var (S (S (S (S (S (S (S (S Z))))))))
                  :* Var (S (S (S (S (S (S (S (S (S Z)))))))))
                  :* ANil))
        (mkEnv [] ((1 :: Int) :. b0 :. ch :. ([0, 1] :: [Obs]) :. immW s
                    :. (d :| []) :. stakes :. dirs :. (3 :: Int)
                    :. (0.01 :: Double) :. VNil))

-- the degenerate verb against the frozen VThinkK verb, both sentences
muteU :: Util () Double
muteU = mkUtil (\_ _ -> 0)

degenVerb :: Int -> Double -> Double
degenVerb d p =
  evalx (Call VPre (Var Z :* Var (S Z) :* Var (S (S Z))
                  :* Var (S (S (S Z))) :* Var (S (S (S (S Z))))
                  :* Var (S (S (S (S (S Z)))))
                  :* Var (S (S (S (S (S (S Z))))))
                  :* Var (S (S (S (S (S (S (S Z)))))))
                  :* Var (S (S (S (S (S (S (S (S Z))))))))
                  :* Var (S (S (S (S (S (S (S (S (S Z)))))))))
                  :* ANil))
        (mkEnv [] ((d :: Int) :. b0 :. mkChan (const emit)
                    :. ([0, 1] :: [Obs]) :. muteU :. (() :| [])
                    :. stakes :. dirs :. (3 :: Int) :. (p :: Double)
                    :. VNil))

frozenVerb :: Int -> Double -> Double
frozenVerb d p =
  evalx (Call VThinkK (Var Z :* Var (S Z) :* Var (S (S Z))
                     :* Var (S (S (S Z))) :* Var (S (S (S (S Z))))
                     :* Var (S (S (S (S (S Z)))))
                     :* Var (S (S (S (S (S (S Z))))))
                     :* Var (S (S (S (S (S (S (S Z))))))) :* ANil))
        (mkEnv [] ((d :: Int) :. b0 :. emit :. ([0, 1] :: [Obs])
                    :. stakes :. dirs :. (3 :: Int) :. (p :: Double)
                    :. VNil))

check :: String -> Bool -> IO Bool
check msg ok = do
  putStrLn ((if ok then "ok   " else "FAIL ") ++ msg)
  pure ok

main :: IO ()
main = do
  rs <- sequence
    [ check "price: Call VPre = node + lg 6 + ten Var mentions" $
        abs (unBits (bits priceSentence)
             - (lg 19 + lg 6 + 10 * (lg 19 + lg 10))) <= 1e-12
    , check "identity: the verb == the exported worker" $
        all (\ (ch, s, d) -> verbVal ch s d
               == vPre 1 b0 ch ([0, 1] :: [Obs]) (immW s) (d :| [])
                       stakes dirs 3 0.01)
            [ (ch, s, d) | (ch, s) <- [(chanW, 0.05), (chanW, 0.4)
                                      , (chanC, 0.05)]
                         , d <- [Safe, Probe] ]
    , check "identity: the degenerate verb == the frozen VThinkK verb" $
        all (\ (d, p) -> degenVerb d p == frozenVerb d p)
            [ (d, p) | d <- [1, 2, 3], p <- [0.05, 0] ]
    , check "doctrine: the sentence-driven decisions reproduce the pins" $
        decideS chanW 0.05 == Probe
          && decideS chanW 0.4 == Safe
          && decideS chanC 0.05 == Safe
    ]
  if and rs then putStrLn "sayable: all checks pass" else exitFailure
