-- | proplang-govhost — the membrane wire driver (HOSTS_PLAN section 2).
--
-- IO lives HERE and nowhere else (the Host.hs discipline): read one
-- line, run the pure 'Wire.step', write one reply line, flush. The
-- first line is the handshake ('Wire.buildWorld'); every later line is
-- a tick. Nothing else — no clocks, no randomness, no state beyond the
-- threaded 'PropLang.Enumerate.Agent'.
--
-- Oracle-phase STUB: the loop body is unimplemented; the g5 process
-- smoke runs red against this binary until the implementation phase.
module Main (main) where

main :: IO ()
main = error "proplang-govhost: unimplemented (oracle phase, HOSTS_PLAN H)"
