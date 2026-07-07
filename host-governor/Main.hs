-- | proplang-govhost — the membrane wire driver (HOSTS_PLAN section 2;
-- membrane-wire.md is the normative statement).
--
-- IO lives HERE and nowhere else (the Host.hs discipline): read one
-- line, run the pure 'Wire.step', write one reply line, flush. The
-- first line is the handshake ('Wire.buildWorld'); on a failed
-- handshake the process answers the error and stays on the handshake
-- state (membrane-wire.md section 2); every later line is a tick.
-- Nothing else — no clocks, no randomness, no state beyond the
-- threaded 'PropLang.Enumerate.Agent'.
module Main (main) where

import System.IO (BufferMode (LineBuffering), hSetBuffering, stdout)

import PropLang.Enumerate (Agent)
import Wire (Msg (..), Reply (..), World, buildWorld, parseLine,
             renderReply, step)

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  input <- getContents
  start (lines input)

-- awaiting a valid handshake
start :: [String] -> IO ()
start [] = pure ()
start (l : ls) = case parseLine l of
  Right (MHandshake wd) -> case buildWorld wd of
    Right (w, ag, r) -> putStrLn (renderReply r) >> loop w ag ls
    Left e           -> putStrLn (renderReply (RError e)) >> start ls
  Right (MTick _) ->
    putStrLn (renderReply (RError "expected-handshake")) >> start ls
  Left e ->
    putStrLn (renderReply (RError e)) >> start ls

-- the polling loop: one line, one tick, one reply
loop :: World -> Agent -> [String] -> IO ()
loop _ _ [] = pure ()
loop w ag (l : ls) = case parseLine l of
  Right (MTick t) ->
    let (ag', r) = step w ag t
    in putStrLn (renderReply r) >> loop w ag' ls
  Right (MHandshake _) ->
    putStrLn (renderReply (RError "already-initialized")) >> loop w ag ls
  Left e ->
    putStrLn (renderReply (RError e)) >> loop w ag ls
