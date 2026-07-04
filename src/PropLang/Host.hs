-- | The host boundary (typed-port-spec §2/§6): the ONLY module in src/
-- whose types may mention IO. 'draw' is CL-2 made compiler-checked — the
-- language cannot utter it, because uttering it would change the
-- evaluator's type. The membrane, polling loop, and affordances land
-- here post-parity (CLAUDE.md porting order, step 6).
module PropLang.Host
  ( draw
  ) where

import Data.Word (Word64)
import Foreign.Marshal.Alloc (allocaBytes)
import Foreign.Ptr (Ptr, castPtr)
import Foreign.Storable (peek)
import System.IO (IOMode (ReadMode), hGetBuf, withBinaryFile)

import PropLang.Belief (Belief, top)

-- | The sole source of randomness, host-side, called AFTER the language
-- has finished constructing the belief. Used only to simulate worlds.
--
-- Sampling goes through the sealed reasoner's public diagnostics ('top'
-- ranks every point with its probability): a cumulative walk over the
-- ranked points is the same categorical draw as the reference's walk in
-- space order — the host cannot see log-weights any more than a program
-- can. Entropy comes from the operating system; src/ depends on base
-- only, so there is no in-process generator (and hence no seed) anywhere
-- in the language or its host boundary.
draw :: Belief a -> IO a
draw b = do
  u <- unitSample
  let walk _ [] = error "draw: belief over an empty space (unreachable)"
      walk _ [(x, _)] = x
      walk acc ((x, p) : rest) =
        let acc' = acc + p
        in if u <= acc' then x else walk acc' rest
  pure (walk 0 (top b maxBound))

-- A uniform draw in [0, 1) from /dev/urandom.
unitSample :: IO Double
unitSample =
  withBinaryFile "/dev/urandom" ReadMode $ \h ->
    allocaBytes 8 $ \buf -> do
      n <- hGetBuf h buf 8
      if n /= 8
        then ioError (userError "draw: short read from /dev/urandom")
        else do
          w <- peek (castPtr buf :: Ptr Word64)
          pure (fromIntegral w / 2 ^^ (64 :: Int))
