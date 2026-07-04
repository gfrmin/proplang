-- | The host boundary (typed-port-spec §2/§6): the ONLY module in src/
-- whose types may mention IO. 'draw' is CL-2 made compiler-checked — the
-- language cannot utter it, because uttering it would change the
-- evaluator's type. The membrane, polling loop, and affordances land
-- here post-parity (CLAUDE.md porting order, step 6).
--
-- PHASE 1 STUB.
module PropLang.Host
  ( draw
  ) where

import PropLang.Belief (Belief)

-- | The sole source of randomness, host-side, called AFTER the language
-- has finished constructing the belief. Used only to simulate worlds.
draw :: Belief a -> IO a
draw = undefined
