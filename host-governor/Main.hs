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

import Data.List (intercalate)
import Data.List.NonEmpty (NonEmpty)
import System.IO (BufferMode (LineBuffering), hSetBuffering, stdout)

import PropLang.Enumerate (Agent)
import PropLang.Membrane (UTickState (..))
import Wire (Msg (..), Reply (..), World, buildWorld, parseLine,
             renderReply, step)
import WireU (MsgU (..), ReplyU (..), WorldU, buildWorldU, countsU,
              helloFormU, helloReplyU, parseLineU, renderReplyU, stepU)

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  input <- getContents
  start (lines input)

-- awaiting a valid handshake; the DECLARED utility form is the
-- dispatch seam (fail-closed, the Task-3 report review's ruling,
-- 2026-07-10): latent@1
-- binds the line to the v2 parser, table@1 or no declared form is
-- v1's — the explicit default, byte-identical to H's driver — and
-- any other declared form is an error, never the other version's
-- semantics.
start :: [String] -> IO ()
start [] = pure ()
start (l : ls) = case helloFormU l of
  Nothing -> v1Line
  Just f
    | f == "latent@1" -> v2Line
    | f == "table@1"  -> v1Line
    | otherwise ->
        putStrLn (renderReply (RError ("unknown-utility-form: " ++ f)))
          >> start ls
  where
    v1Line = case parseLine l of
      Right (MHandshake wd) -> case buildWorld wd of
        Right (w, ag, r) -> putStrLn (renderReply r) >> loop w ag ls
        Left e           -> putStrLn (renderReply (RError e)) >> start ls
      Right (MTick _) ->
        putStrLn (renderReply (RError "expected-handshake")) >> start ls
      Left e -> putStrLn (renderReply (RError e)) >> start ls
    v2Line = case parseLineU l of
      Right (MUHello wd ld) -> case buildWorldU wd ld of
        Right (w, wAg, uAgs) ->
          putStrLn (helloReplyU w)
            >> loopU w (UTickState 0 0 Nothing) wAg uAgs ls
        Left e -> putStrLn (renderReply (RError e)) >> start ls
      Right _ ->
        putStrLn (renderReply (RError "expected-handshake")) >> start ls
      Left e -> putStrLn (renderReply (RError e)) >> start ls

-- the v2 polling loop: threaded tick state (no counter resets,
-- R-D11); observe_batch folds the one-tick step and answers one
-- line (a JSON array, one entry per collapsed tick)
loopU :: WorldU -> UTickState -> Agent -> NonEmpty Agent -> [String]
      -> IO ()
loopU _ _ _ _ [] = pure ()
loopU w st wAg uAgs (l : ls) = case parseLineU l of
  Right (MUTick tag tm) ->
    let (st', wAg', uAgs', out) = stepU w st wAg uAgs (tag, tm)
    in putStrLn out >> loopU w st' wAg' uAgs' ls
  Right (MUBatch items) ->
    let goB (stB, wB, uB, acc) it =
          let (st', w', u', out) = stepU w stB wB uB it
          in (st', w', u', out : acc)
        (stF, wF, uF, outs) = foldl goB (st, wAg, uAgs, []) items
    in putStrLn ("[" ++ intercalate "," (reverse outs) ++ "]")
         >> loopU w stF wF uF ls
  Right (MUCounts tag feats n1 n0) ->
    let (wAg', uAgs', out) = countsU w wAg uAgs (tag, feats, n1, n0)
    in putStrLn out >> loopU w st wAg' uAgs' ls
  Right (MUHello _ _) ->
    putStrLn (renderReplyU (RUError "already-initialized"))
      >> loopU w st wAg uAgs ls
  Left e ->
    putStrLn (renderReplyU (RUError e)) >> loopU w st wAg uAgs ls

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
