-- bench/GmpOps.hs — the arithmetic-cost model, measured on this box
-- (bench r01): microseconds per operation for Integer gcd, a big
-- Rational times a 55-bit Rational (the fold's multiply: reduce =
-- one gcd of the products), and a big Rational plus a big Rational
-- (the marginal's sum: one multiply of the denominators, one gcd of
-- the doubled size), at operand sizes spanning the belief-state sizes
-- the profiles reach. Route 1 (time) and route 2 (bits) reconcile
-- through this curve: cost/op ~ bits^gamma with gamma the local slope
-- printed below. Operands are deterministic (3^a * 7^b + s), so the
-- table is reproducible; run: ghc -O1 bench/GmpOps.hs -o gmpops && ./gmpops
module Main (main) where

import Control.Exception (evaluate)
import Data.Ratio (numerator, (%))
import GHC.Clock (getMonotonicTimeNSec)
import GHC.Num.Integer (integerLog2)
import System.IO (BufferMode (LineBuffering), hSetBuffering, stdout)
import Text.Printf (printf)

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  putStrLn "bits(operand)  gcd_us  mulQ55_us  addQQ_us   (us per op; n ops averaged)"
  mapM_ row [1000, 3000, 10000, 30000, 100000, 300000 :: Int]
  where
    mk :: Int -> Integer -> Integer
    mk k s = 3 ^ (k `div` 2) * 7 ^ (k `div` 3) + s
    row bits = do
      let a = mk bits 1
          b = mk bits 12345 + 2 ^ (bits `div` 2)
          n = if bits > 50000 then 50 else 500 :: Int
          actual = fromIntegral (integerLog2 a) + 1 :: Int
      t0 <- getMonotonicTimeNSec
      _ <- evaluate (foldl (\acc i -> acc + gcd (a + fromIntegral i) b) 0 [1 .. n])
      t1 <- getMonotonicTimeNSec
      let q = a % b
          r = 3602879701896397 % (2 ^ (55 :: Int) :: Integer)
      t2 <- getMonotonicTimeNSec
      _ <- evaluate (foldl (\acc i -> acc + numerator (q * (r + fromIntegral i))) 0 [1 .. n])
      t3 <- getMonotonicTimeNSec
      let q2 = (a + 1) % (b + 2)
      t4 <- getMonotonicTimeNSec
      _ <- evaluate (foldl (\acc i -> acc + numerator (q + (q2 + fromIntegral i))) 0 [1 .. n])
      t5 <- getMonotonicTimeNSec
      let us x y = fromIntegral (y - x) / 1000 / fromIntegral n :: Double
      printf "%13d %7.1f %10.1f %9.1f   (n=%d)\n" actual (us t0 t1) (us t2 t3) (us t4 t5) n
