{-# LANGUAGE DataKinds #-}

-- The said utility (CIRL_PLAN C3/C9 as ruled; reflexive-closure
-- doctrine at the pointer): this fixture DOES NOT COMPILE until the
-- Task 2 freeze lands the UTIL sort's sole codeword, USay — that
-- compile failure is the row's red (the inversion), and per the
-- canonized fixture-proof habit its red is DEMONSTRATED to be the
-- missing constructor by type-checking this file against the drafted
-- future surface before the freeze. Once it compiles, main runs:
--
--   1. price: USay pays 0 sort bits (sole codeword at a declared UTIL
--      hole — the ExpFam maneuver) + its two-variable program as EXPR:
--      the `worth` saying = 11 nodes + 2 scope-2 Var mentions + 5
--      four-point grid mentions (1e-12, derived from bits against the
--      drafted surface — never a parallel derivation);
--   2. price: the off-switch sentence — Call VPre under lg 6 with
--      (the step-3 re-pricing: STDNAME 7 -> 6 (Bern left the stdlib at the step-3 freeze; P5 pin re-pricing under the recorded delegation, D4 adjudication))
--      eight scope-8 Var mentions and TWO said utilities in the Util
--      slots (1e-12, the dedicated price sentence);
--   3. the bridge (E7 at the pointer, ==): the said utility IS its
--      host form — applyUtil of evalx (USay worth) equals both the
--      closed evaluation of `worth` and the host step, pointwise over
--      menu codes x the full grid;
--   4. doctrine: utilities are featureless and clockless — a Get
--      inside a USay reads the absent-name 0.0 even when the OUTER
--      environment carries that feature (the closed-subprogram
--      compile fact, exercised);
--   5. doctrine: the sentence-driven episode reproduces the oracle's
--      pins — the said agent defers at k=0 and acts at k=1.
--
-- Pins duplicated from test-cirl/Cirl.hs carry the same provenance
-- (Task-1 intended-behavior pins; margins in CIRL_PLAN T4).
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromMaybe)
import System.Exit (exitFailure)

import PropLang.Belief
import PropLang.Enumerate (Obs, emit, obsCarrier, thetaSpace)
import PropLang.Eval
import PropLang.Syntax

-- the worth grid: the four constants a sayable step utility mentions
gW :: Grid
gW = mkGrid "worth" (0.5 :| [1, -1, 0])

cAt :: Int -> Expr env Double
cAt k = fromMaybe (error "worth grid: off-grid index") (mkC gW k)

-- | The utility, SAID (env convention as ruled: Var Z the option code,
-- Var (S Z) the latent): +1 if the option is live and the latent
-- clears the middle, -1 if live and it does not, 0 if the option is
-- the off/defer code. ONE saying serves both Util slots — the interior
-- immediate over {act=1, defer=0} and the terminal over
-- {off=0, proceed=1}.
worth :: Expr '[Double, Double] Double
worth = If (Gt (Var Z) (cAt 0))
           (If (Gt (Var (S Z)) (cAt 0)) (cAt 1) (cAt 2))
           (cAt 3)

-- RE-DERIVED at the step-8 outcome freeze (R-D22): USay now
-- EVALUATES TO SYNTAX (USent) — the wrapper died; the bridge runs
-- through uAt, the one environment-carrying site.
uSaid :: USent
uSaid = evalx (USay worth) (mkEnv [] VNil)

hostWorth :: Double -> Double -> Double
hostWorth a u = if a > 0.5 then (if u > 0.5 then 1 else -1) else 0

-- the coded world (Double-coded menus so the said utility applies)
noise :: Kernel Double Obs
noise = kernel thetaSpace (carrierSpace obsCarrier)
               (\_ -> bernFast obsCarrier 0.5)

chanS :: Chan Double Double Obs
chanS = mkChan (\d -> if d > 0.5 then noise else emit)

termCodes :: NonEmpty Double
termCodes = 0 :| [1]     -- off first-listed (CL-3, the safety tie-break)

condBatch :: Kernel Double Obs -> Belief Double -> [Obs] -> Belief Double
condBatch k = foldl' (\bb y ->
  fromMaybe (error "impossible evidence in batch") (cond bb (Saw k y)))

bk :: Int -> Belief Double
bk k = condBatch emit (uniform thetaSpace) (replicate k 1)

-- | The off-switch value sentence: Call VPre with the SAID utility in
-- both Util slots; everything else arrives as typed env values (the
-- batchN precedent), the price read from the world by Get "price".
--   Z      depth    :: Int
--   S Z    belief   :: B Double
--   S^2 Z  channel  :: Chan Double Double Obs
--   S^3 Z  outcomes :: [Obs]
--   S^4 Z  menu     :: NonEmpty Double  (the decision's singleton)
--   S^5 Z  terminal :: NonEmpty Double
--   S^6 Z  batch    :: Int
type SentEnv = '[Int, B Double, Chan Double Double Obs, [Obs],
                 NonEmpty Double, NonEmpty Double, Int]

valSentence :: Expr SentEnv Double
valSentence =
  Call VPre (Var Z :* Var (S Z) :* Var (S (S Z))
           :* Var (S (S (S Z)))
           :* USay worth
           :* Var (S (S (S (S Z))))
           :* USay worth
           :* Var (S (S (S (S (S Z)))))
           :* Var (S (S (S (S (S (S Z))))))
           :* Get "price"
           :* ANil)

valS :: Belief Double -> Double -> Double
valS b d =
  evalx valSentence
        (mkEnv [("price", 0.01)]
               ((1 :: Int) :. b :. chanS :. ([0, 1] :: [Obs])
                 :. (d :| []) :. termCodes :. (3 :: Int) :. VNil))

-- | The dedicated price sentence (the SayableP arrangement): all eight
-- non-utility arguments as Vars in an env of exactly those eight, the
-- two Util slots carrying the said utility — so the pin decomposes as
-- node + lg 6 + eight scope-8 Var mentions + two said-utility subtrees.
type PriceEnv = '[Int, B Double, Chan Double Double Obs, [Obs],
                  NonEmpty Double, NonEmpty Double, Int, Double]

priceSentence :: Expr PriceEnv Double
priceSentence =
  Call VPre (Var Z :* Var (S Z) :* Var (S (S Z))
           :* Var (S (S (S Z)))
           :* USay worth
           :* Var (S (S (S (S Z))))
           :* USay worth
           :* Var (S (S (S (S (S Z)))))
           :* Var (S (S (S (S (S (S Z))))))
           :* Var (S (S (S (S (S (S (S Z)))))))
           :* ANil)

-- the said agent's decision: defer (code 0) must strictly earn it? No —
-- mirroring the oracle's marginD: defer displaces act iff strictly
-- better (act is the incumbent, CL-3 reading of the coded pair)
defersS :: Belief Double -> Bool
defersS b = valS b 0 > valS b 1

lg :: Double -> Double
lg = logBase 2

unBits :: Bits -> Double
unBits (Bits x) = x

check :: String -> Bool -> IO Bool
check msg ok = do
  putStrLn ((if ok then "ok   " else "FAIL ") ++ msg)
  pure ok

main :: IO ()
main = do
  rs <- sequence
    [ check "price: USay = 0 sort bits + the two-variable program as EXPR" $
        abs (unBits (bits (USay worth :: Expr '[] USent))
             - (11 * lg 19 + 2 * lg 2 + 5 * lg 4)) <= 1e-12
    , check "price: the off-switch sentence under lg 6 + two said utilities" $
        abs (unBits (bits priceSentence)
             - (lg 19 + lg 6 + 8 * (lg 19 + lg 8)
                + 2 * (11 * lg 19 + 2 * lg 2 + 5 * lg 4))) <= 1e-12
    , check "bridge: the said utility == its closed evaluation (exact)" $
        all (\(a, h) -> uAt [] uSaid a h
                          == evalx worth (mkEnv [] (a :. h :. VNil)))
            [ (a, h) | a <- [0, 1]
                     , h <- [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9] ]
    , check "bridge: the said utility == the host step (exact)" $
        all (\(a, h) -> uAt [] uSaid a h == hostWorth a h)
            [ (a, h) | a <- [0, 1]
                     , h <- [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9] ]
    , check "doctrine RE-DERIVED (step 8, the repeal): Get inside a utility reads the PASSED features -- and 0.0 at empty" $
        let uClock = evalx (USay (Get "price"))
                           (mkEnv [("price", 99)] VNil)
        in uAt [] uClock 1 0.9 == 0.0            -- the closed face survives
           && uAt [("price", 99)] uClock 1 0.9 == 99.0  -- the repeal's face
    , check "doctrine: the said agent defers at k=0 and acts at k=1" $
        defersS (bk 0) && not (defersS (bk 1))
    ]
  if and rs then putStrLn "sayable: all checks pass" else exitFailure
