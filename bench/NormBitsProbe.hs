-- bench/NormBitsProbe.hs — an executed witness for one sentence of the
-- report (PROPOSED 4.i): does exact re-normalisation bound the belief
-- state's bit-size? At depths t the probe folds the mirror on P1/P2/P3
-- (seed 1, the wire's acts) and prints, side by side, the total bits of
-- the UNNORMALISED meta weights the engine carries and the total bits of
-- the same weights NORMALISED (w/z, reduced) — the `metaPosterior` view.
-- Run: ghc -O1 -isrc -ibench bench/NormBitsProbe.hs -o nbp && ./nbp
module Main (main) where

import Data.Maybe (fromMaybe)
import Text.Printf (printf)

import BenchLib
import PropLang.Host (HostState, hostStart, serveLine)

main :: IO ()
main = do
  putStrLn "profile  tick  unnormalised_meta_bits  normalised_meta_bits  ratio"
  mapM_ run [(profileP1, [100, 300, 1000, 3000]), (profileP2, [30, 100, 300]), (profileP3, [10, 30, 100])]
  where
    run (p, depths) = go p (fst (serveLine hostStart (helloLine p))) (mirrorStart p) (genTicks p 1 (maximum depths)) 1 depths
    go :: Profile -> HostState -> Mirror -> [Tick] -> Int -> [Int] -> IO ()
    go _ _ _ _ _ [] = pure ()
    go p st m ticks i ds@(d : rest) = case ticks of
      [] -> pure ()
      (t : ts) ->
        let (stN, reply) = serveLine st (tickLine p (tFeats t) (tEv t))
            act = fromMaybe [] (actField reply)
            mN = case tEv t of
                   Just y -> either error snd (mirrorStep (tFeats t ++ act) y m)
                   Nothing -> m
        in if i == d
             then do
               let BitSample mt _ _ _ _ = mirrorBits mN
                   nb = sum (map qbits (mirrorMetaNormalized mN))
               printf "%-7s %5d %22d %20d  %.2f\n" (pName p) i mt nb
                 (fromIntegral nb / fromIntegral mt :: Double)
               go p stN mN ts (i + 1) rest
             else go p stN mN ts (i + 1) ds
