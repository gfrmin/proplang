-- bench/ProbeStateBits.hs — the #24 sitting r2, probe A2: the qbits
-- falsifier the sitting ordered before any acceptance band is filled.
--
-- THE QUESTION (the verdict, 2026-09-02): does the folded posterior
-- state carry O(t) bits (denominator growth from multiplying
-- per-tick likelihoods as exact rationals) where the decision
-- problem's own sufficient statistic needs O(log t)?  If linear, the
-- bench's alpha_3p measured an ARITHMETIC REPRESENTATION, not the
-- decision problem, and the band must not be filled on it.
--
-- THE MEASUREMENT: fold the route-2 mirror through the wire exactly
-- as BenchTest's t5 does (the fold below copies the binding
-- `foldMirror`, bench/BenchTest.hs at the r2 round, seed 7 — the
-- same fold t5c proves equal (Rational ==) to the ENGINE's own
-- metaPosterior, so the mirror's weights ARE the engine's state).
-- At each checkpoint t: max and total qbits over the raw meta
-- weights, the same over the normalized weights, and the CONTROL —
-- the sufficient statistic's own cost (per-outcome counts plus t:
-- sum ibits count + ibits t).  Classification is read off the
-- per-interval slope: linear doubles the total with t; logarithmic
-- adds a constant.
module Main (main) where

import Data.List (sort)
import Data.Maybe (fromMaybe)
import System.IO (BufferMode (LineBuffering), hSetBuffering, stdout)
import Text.Printf (printf)

import BenchLib
import PropLang.Host (hostStart, serveLine)

-- per-outcome counts, the sufficient statistic of a const-family
-- guard/emission world: (y, occurrences)
countsAdd :: Int -> [(Int, Int)] -> [(Int, Int)]
countsAdd y cs = case lookup y cs of
  Just n  -> (y, n + 1) : [ p | p <- cs, fst p /= y ]
  Nothing -> (y, 1) : cs

ssBits :: Int -> [(Int, Int)] -> Int
ssBits t cs = ibits (fromIntegral t) + sum [ ibits (fromIntegral n) | (_, n) <- cs ]

runProfile :: Profile -> [Int] -> IO ()
runProfile p checkpoints = do
  let tMax = maximum checkpoints
      ticks = genTicks p 7 tMax
      st0 = fst (serveLine hostStart (helloLine p))
      go _ _ _ _ [] = pure ()
      go st m i cs (t : rest) = do
        let (stN, reply) = serveLine st (tickLine p (tFeats t) (tEv t))
        case tEv t of
          Nothing -> go stN m i cs rest
          Just y -> do
            let act = fromMaybe [] (actField reply)
            case mirrorStep (tFeats t ++ act) y m of
              Left e -> error ("probe: fold refused: " ++ e)
              Right (_, mN@(Mirror _ ws _)) -> do
                let i' = i + 1
                    cs' = countsAdd y cs
                if i' `elem` checkpoints
                  then do
                    let nws = mirrorMetaNormalized mN
                        qs = map qbits ws
                        nqs = map qbits nws
                    (printf "%-9s t=%-5d raw: max=%-8d total=%-10d  normalized: max=%-8d total=%-10d  ss-control=%d\n"
                            (pName p) i' (maximum qs) (sum qs)
                            (maximum nqs) (sum nqs) (ssBits i' cs') :: IO ())
                    go stN mN i' cs' rest
                  else go stN mN i' cs' rest
  go st0 (mirrorStart p) (0 :: Int) [] ticks

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  putStrLn "ProbeStateBits (the #24 sitting r2, A2) — qbits of the folded state vs t"
  putStrLn "(the mirror's weights == the engine's metaPosterior, Rational ==, by t5c)"
  putStrLn ""
  runProfile profileP1 [100, 200, 400, 800, 1600]
  putStrLn ""
  let p2nc = case [ q | q <- profiles, pName q == "P2realNC" ] of
        (q : _) -> q
        []      -> error "probe: no P2realNC profile"
  runProfile p2nc (sort [100, 200, 400])
  putStrLn ""
  putStrLn "reading: total qbits doubling with t = O(t) state (the arithmetic"
  putStrLn "representation grows without bound while the ss-control row shows"
  putStrLn "the DECISION-relevant state is O(log t)); constant increments = O(log t)."
