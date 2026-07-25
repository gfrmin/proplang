{-# LANGUAGE GHC2021 #-}
-- THE REPORTING EDGE (EXACT_PLAN section 4; exact-freeze-r0): the only
-- module where a Double appears. Displays are pure functions of exact
-- views, asserted (==) under the pinned toolchain (R7).
module PropLang.Report
  ( entropyBits
  , entropyAgent
  , bitsView
  ) where

import PropLang.Belief (Belief, weights)
import PropLang.Enumerate (AgentS, metaPosterior)

entropyOf :: [Rational] -> Double
entropyOf ps =
  sum [ negate (p * logBase 2 p)
      | w <- ps, w > 0, let p = fromRational w :: Double ]

-- | Belief entropy in bits (display).
entropyBits :: Belief a -> Double
entropyBits = entropyOf . weights

-- | Meta-posterior entropy in bits (display).
entropyAgent :: AgentS -> Double
entropyAgent = entropyOf . metaPosterior

-- | The bits view of an exact weight/mass: -log2 w (display; the
-- exact rational is the fact, this is its rendering).
bitsView :: Rational -> Double
bitsView w = negate (logBase 2 (fromRational w))
