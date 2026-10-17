{-# LANGUAGE BangPatterns #-}
-- bench/BenchFoldDepth.hs — the fold-depth cost instrument (bench r01).
--
-- WHAT THIS MEASURES. How the per-tick cost of the language AS SERVED
-- grows with session length under exact rational arithmetic. The wire
-- is driven exactly as a host drives it: one 'serveLine' pure session
-- per cell (hello, then T ticks), the hello declaring every codebook,
-- every tick passing the door with features + menu + evidence. Nothing
-- under src/PropLang is touched; the harness is a CLIENT of the
-- library (the test suites' refAgent precedent).
--
-- TWO ROUTES, two processes (so neither pollutes the other's heap):
--   --route 1  wall ns + CPU ns per tick around `serveLine st line`
--              with the reply forced to normal form; windowed medians at
--              log-spaced starts (100 ticks per window); VmRSS at each
--              window, VmHWM (peak) at the end.
--   --route 2  the same wire session, un-timed, PLUS a MIRROR of the
--              engine's exact state built from exported verbs only
--              (Enumerate.observeS's own steps re-executed bench-side
--              via Belief.push/condK/predictMass and Eval.evalx on the
--              enumerated Hyp list — a COPY of `observeS`/`tickPred`
--              in src/PropLang/Enumerate.hs at 94fd4eb, cited per
--              R-D20-i by binding name). Every tick the mirror's
--              marginal, rendered exactly as the wire renders it
--              (`show (bitsView m)`), is asserted EQUAL to the reply's
--              loss_bits string; a mismatch aborts the cell. At each
--              window the mirror reports the belief state's bit-size:
--              sum over the meta weight vector of bits(num)+bits(den)
--              (the UNNORMALIZED weights the engine carries), the max
--              per-hypothesis size, and the walk latents' bit-size
--              (sum over every latent belief's weight vector).
--              Rational values are canonical (Data.Ratio reduces at
--              every operation), so a value-identical mirror has a
--              bit-identical representation; the per-tick pin is what
--              makes the identity checked rather than argued.
--
-- SEEDS. The synthetic world's randomness is a bench-side SplitMix64
-- (hand-rolled, constants stated) seeded per cell; the language sees
-- only the wire. The host's own `draw` door reads /dev/urandom and is
-- not seed-pinnable, and this instrument never calls it (the wire's
-- decisions are exact argmaxes; no draw is on the served path).
--
-- BUILD STAMP (OB-32): the instrument prints its own identity.
module Main (main) where

import Control.DeepSeq (force)
import Control.Exception (evaluate)
import Control.Monad (forM_, unless, when)
import Data.Array.IO (IOUArray, getElems, newArray, writeArray)
import Data.IORef
import Data.List (isInfixOf)
import Data.Maybe (fromMaybe, isJust)
import GHC.Clock (getMonotonicTimeNSec)
import System.CPUTime (getCPUTime)
import System.Directory (createDirectoryIfMissing)
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO
import Text.Printf (hPrintf, printf)

import BenchLib
import PropLang.Host (HostState, hostStart, serveLine)
import PropLang.Report (bitsView)

-- ---------------------------------------------------------------------
-- main
-- ---------------------------------------------------------------------

data Opts = Opts
  { oProfile :: String, oTicks :: Int, oSeed :: Int, oRoute :: Int
  , oOut :: FilePath, oRaw :: Maybe FilePath, oBudgetS :: Maybe Double }

parseOpts :: [String] -> Opts -> Opts
parseOpts [] o = o
parseOpts ("--profile" : v : r) o = parseOpts r o { oProfile = v }
parseOpts ("--ticks" : v : r) o = parseOpts r o { oTicks = read v }
parseOpts ("--seed" : v : r) o = parseOpts r o { oSeed = read v }
parseOpts ("--route" : v : r) o = parseOpts r o { oRoute = read v }
parseOpts ("--out" : v : r) o = parseOpts r o { oOut = v }
parseOpts ("--raw" : v : r) o = parseOpts r o { oRaw = Just v }
parseOpts ("--budget-s" : v : r) o = parseOpts r o { oBudgetS = Just (read v) }
parseOpts (x : _) _ = error ("unknown argument: " ++ x)

usage :: String
usage = "bench-fold-depth --profile {P1,P2,P2real,P2realDy,P2realNC,P3,S1,S0,P2nw,P3wide} --ticks N --seed S \
        \--route {1,2} [--out DIR] [--raw DIR] [--budget-s SECONDS]"

main :: IO ()
main = do
  args <- getArgs
  when (null args) (putStrLn usage >> exitFailure)
  let o = parseOpts args (Opts "" 0 0 0 "bench/results" Nothing Nothing)
  p <- case [ q | q <- profiles, pName q == oProfile o ] of
    (q : _) -> pure q
    [] -> putStrLn usage >> exitFailure
  when (oTicks o < windowLen) (putStrLn "ticks must be >= 100" >> exitFailure)
  createDirectoryIfMissing True (oOut o)
  hSetBuffering stdout LineBuffering
  let cell = printf "%s-T%d-s%d-route%d" (pName p) (oTicks o) (oSeed o) (oRoute o)
      outPath = oOut o ++ "/" ++ cell ++ ".csv"
  h <- openFile outPath WriteMode
  hSetBuffering h LineBuffering
  stamp h
  stamp stdout
  hPrintf h "# cell=%s profile=%s ticks=%d seed=%d route=%d\n"
    (cell :: String) (pName p) (oTicks o) (oSeed o) (oRoute o)
  hPrintf h "# argv=%s\n" (unwords args)
  hPrintf h "# hello=%s\n" (helloLine p)
  hPrintf h "# tick-mode=%s\n" (show (pTickMode p))
  let (st1, r1) = serveLine hostStart (helloLine p)
  unless ("\"ok\": true" `isInfixOf` r1) $ do
    hPutStrLn stderr ("hello REFUSED: " ++ r1)
    exitFailure
  hPrintf h "# hello-reply=%s\n" r1
  hPrintf h "# models=%s\n" (fromMaybe "?" (scalarField "models" r1))
  -- THE POPULATION ASSERTION (derive-and-assert; the one-generator law).
  -- The profile predicts its own population from its declaration and the
  -- engine reports what it actually enumerated; a disagreement means the
  -- profile is not measuring the world it claims to, so the cell dies here
  -- rather than writing a plausible number for the wrong world.
  let predicted = predictedModels p
      reported = scalarField "models" r1 >>= \x -> case reads x of
                   [(v, "")] -> Just (v :: Int)
                   _ -> Nothing
  case reported of
    Just m | m /= predicted -> do
      hPutStrLn stderr ("POPULATION MISMATCH for " ++ pName p
                        ++ ": declaration predicts " ++ show predicted
                        ++ ", engine enumerated " ++ show m)
      exitFailure
    Nothing -> do
      hPutStrLn stderr ("hello reply carried no readable models field: " ++ r1)
      exitFailure
    _ -> hPrintf h "# models-assert=OK predicted=%d\n" predicted
  let ticks = genTicks p (oSeed o) (oTicks o)
  case oRoute o of
    1 -> route1 o p h st1 ticks
    2 -> route2 o p h st1 ticks
    _ -> putStrLn usage >> exitFailure
  hClose h
  putStrLn ("wrote " ++ outPath)

-- ROUTE 1: timed wire session
route1 :: Opts -> Profile -> Handle -> HostState -> [Tick] -> IO ()
route1 o p h st1 ticks = do
  hPutStrLn h "# route1 columns: window_start,window_end,median_wall_ns,mean_wall_ns,p90_wall_ns,min_wall_ns,median_cpu_ns,vmrss_kb_at_end"
  -- per-tick timings live in UNBOXED arrays (no boxed cons cells for
  -- the GC to scan as the session grows: a 10^5-tick session held as
  -- lists measurably inflated its own late windows in the sanity cell)
  wallArr <- newArray (1, oTicks o) 0 :: IO (IOUArray Int Double)
  cpuArr <- newArray (1, oTicks o) 0 :: IO (IOUArray Int Double)
  rssRef <- newIORef ([] :: [(Int, Int)])
  rawH <- case oRaw o of
    Nothing -> pure Nothing
    Just d -> do
      createDirectoryIfMissing True d
      rh <- openFile (d ++ "/" ++ printf "%s-T%d-s%d-route1.tsv" (pName p) (oTicks o) (oSeed o)) WriteMode
      hSetBuffering rh (BlockBuffering Nothing)
      hPutStrLn rh "tick\twall_ns\tcpu_ns"
      pure (Just rh)
  tStart <- getMonotonicTimeNSec
  let ws = windowStarts (oTicks o)
      wEnds = [ (s + windowLen - 1, s) | s <- ws ]
      loop !st !i (t : rest) = do
        let line = tickLine p (tFeats t) (tEv t)
        c0 <- getCPUTime
        w0 <- getMonotonicTimeNSec
        let (st', reply) = serveLine st line
        _ <- evaluate (force reply)
        w1 <- getMonotonicTimeNSec
        c1 <- getCPUTime
        when ("\"error\"" `isInfixOf` reply) $ do
          hPutStrLn stderr ("tick " ++ show i ++ " ERROR reply: " ++ reply)
          exitFailure
        let dw = fromIntegral (w1 - w0) :: Double
            dc = fromIntegral (c1 - c0) / 1000 :: Double   -- ps -> ns
        writeArray wallArr i dw
        writeArray cpuArr i dc
        forM_ rawH (\rh -> hPrintf rh "%d\t%.0f\t%.0f\n" i dw dc)
        when (isJust (lookup i wEnds)) $ do
          rss <- procStatusKb "VmRSS"
          modifyIORef' rssRef ((i, rss) :)
          now <- getMonotonicTimeNSec
          hPrintf stdout "  tick %d reached at %.1fs (window median pending)\n"
            i (fromIntegral (now - tStart) / 1e9 :: Double)
        now <- getMonotonicTimeNSec
        let elapsed = fromIntegral (now - tStart) / 1e9 :: Double
        case oBudgetS o of
          Just b | elapsed > b && not (null rest) -> do
            hPrintf h "# TRUNCATED at tick %d: wall budget %.0fs exceeded (elapsed %.1fs)\n" i b elapsed
            hPrintf stdout "TRUNCATED at tick %d (budget %.0fs)\n" i b
            pure i
          _ -> loop st' (i + 1) rest
      loop _ i [] = pure (i - 1)
  done <- loop st1 (1 :: Int) ticks
  tEnd <- getMonotonicTimeNSec
  forM_ rawH hClose
  walls <- take done <$> getElems wallArr
  cpus <- take done <$> getElems cpuArr
  rsss <- readIORef rssRef
  let wsDone = windowStarts done
  forM_ wsDone $ \s -> do
    let seg = take windowLen (drop (s - 1) walls)
        segC = take windowLen (drop (s - 1) cpus)
        e = s + windowLen - 1
        rss = fromMaybe (-1) (lookup e rsss)
    hPrintf h "%d,%d,%.0f,%.0f,%.0f,%.0f,%.0f,%d\n" s e (median seg)
      (sum seg / fromIntegral (length seg)) (quantile 0.9 seg) (minimum seg)
      (median segC) rss
  hwm <- procStatusKb "VmHWM"
  hPrintf h "# summary ticks_done=%d ticks_requested=%d total_wall_s=%.3f peak_rss_kb=%d\n"
    done (oTicks o) (fromIntegral (tEnd - tStart) / 1e9 :: Double) hwm
  hPrintf stdout "summary ticks_done=%d total_wall_s=%.3f peak_rss_kb=%d\n"
    done (fromIntegral (tEnd - tStart) / 1e9 :: Double) hwm

-- ROUTE 2: wire session + mirror, un-timed; per-tick pin; bits at windows
route2 :: Opts -> Profile -> Handle -> HostState -> [Tick] -> IO ()
route2 o p h st1 ticks = do
  hPutStrLn h "# route2 columns: tick,meta_bits_total,meta_bits_max,meta_n,latent_bits_total,latent_n,marginal_bits(num+den)"
  when (pTickMode p /= EvidenceAndMenu) $ do
    hPutStrLn h "# route2 on a no-evidence profile: the belief never moves; bits sampled from the prior"
  tStart <- getMonotonicTimeNSec
  let ws = windowStarts (oTicks o)
      sampleAt = ws ++ [ s + windowLen - 1 | s <- ws ]
      emit :: Int -> Mirror -> Maybe Rational -> IO ()
      emit i m mg = do
        let BitSample mt mm mn lt ln = mirrorBits m
        hPrintf h "%d,%d,%d,%d,%d,%d,%d\n" i mt mm mn lt ln (maybe 0 qbits mg)
      loop !st !m !pins !i (t : rest) = do
        let line = tickLine p (tFeats t) (tEv t)
            (st', reply) = serveLine st line
        _ <- evaluate (force reply)
        when ("\"error\"" `isInfixOf` reply) $ do
          hPutStrLn stderr ("tick " ++ show i ++ " ERROR reply: " ++ reply)
          exitFailure
        (m', pins', mg) <- case tEv t of
          Nothing -> pure (m, pins, Nothing)
          Just y -> do
            let act = fromMaybe [] (actField reply)
                full = tFeats t ++ act
            case mirrorStep full y m of
              Left e -> do
                hPutStrLn stderr ("tick " ++ show i ++ " mirror refused: " ++ e)
                exitFailure
              Right (marg, mm) -> do
                let mine = show (bitsView marg)
                    theirs = fromMaybe "<none>" (scalarField "loss_bits" reply)
                when (mine /= theirs) $ do
                  hPutStrLn stderr ("tick " ++ show i ++ " PIN FAILED: mirror loss_bits "
                                    ++ mine ++ " vs wire " ++ theirs ++ " reply=" ++ reply)
                  hPrintf h "# PIN FAILED at tick %d\n" i
                  exitFailure
                pure (mm, pins + 1, Just marg)
        when (i `elem` sampleAt) $ do
          emit i m' mg
          now <- getMonotonicTimeNSec
          hPrintf stdout "  tick %d sampled at %.1fs\n" i (fromIntegral (now - tStart) / 1e9 :: Double)
        now <- getMonotonicTimeNSec
        let elapsed = fromIntegral (now - tStart) / 1e9 :: Double
        case oBudgetS o of
          Just b | elapsed > b && not (null rest) -> do
            hPrintf h "# TRUNCATED at tick %d: wall budget %.0fs exceeded (elapsed %.1fs)\n" i b elapsed
            hPrintf stdout "TRUNCATED at tick %d (budget %.0fs)\n" i b
            pure (i, pins')
          _ -> loop st' m' pins' (i + 1) rest
      loop _ _ pins i [] = pure (i - 1, pins)
  let m0 = mirrorStart p
      BitSample _ _ mn0 _ _ = mirrorBits m0
  hPrintf h "# mirror population=%d\n" mn0
  emit (0 :: Int) m0 Nothing
  (done, pins) <- loop st1 m0 (0 :: Int) (1 :: Int) ticks
  tEnd <- getMonotonicTimeNSec
  hPrintf h "# summary ticks_done=%d ticks_requested=%d pins_checked=%d total_wall_s=%.3f\n"
    done (oTicks o) pins (fromIntegral (tEnd - tStart) / 1e9 :: Double)
  hPrintf stdout "summary ticks_done=%d pins_checked=%d total_wall_s=%.3f\n"
    done pins (fromIntegral (tEnd - tStart) / 1e9 :: Double)
