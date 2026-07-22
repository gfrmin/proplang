-- test-transport/Transport.hs — the #18 transport oracle: the FIRST
-- process-level oracle class (declared at the 2026-07-22 disposition
-- sitting; flag-faithful discipline extended to processes). The suite
-- spawns the REAL proplang-host executable over PLAIN PIPES (no PTY)
-- and asserts per-line reply delivery in strict request-reply
-- lockstep. It is deliberately SEMANTICS-BLIND: every expected reply
-- byte is computed at runtime by folding the same request lines
-- through the frozen pure core (PropLang.Host.serveLine from
-- hostStart) — R-D20's copy-not-reconstruct taken to its limit; the
-- frozen artifact itself is the expectation, no literal can drift.
-- Transport is therefore the ONLY thing this suite can convict.
--
-- Design of record: dispositions-pack.md Part II (#18 brief; probe
-- transcript of the HEAD deadlock) and Part VI (the sitting's ruling:
-- "fix-it, oracle-first ... the first process-level suite").
--
-- Binary resolution: `findExecutable "proplang-host"` — under the
-- cabal stanza, build-tool-depends places the freshly built exe on
-- PATH; for a standalone `ghc -isrc` run, prepend the dist build dir
-- (or a prototype dir) to PATH. The suite never hardcodes a path.
--
-- Red/green partition (oracle phase, against the HEAD binary — no
-- stubs: the red IS the shipped executable block-buffering stdout
-- under pipes, GHC's default off-terminal):
--   RED   t1 (hello reply not delivered within the window),
--         t2 (lockstep exchange stalls at the first reply),
--         t3 (the error line for an unparseable request stalls too —
--             fail-closed refusals must ALSO be delivered per-line)
--   GREEN t4 (EOF-flush parity: send everything, close stdin, read to
--         EOF — the block-buffered replies all arrive at process exit
--         and match the serveLine composition byte-for-byte). t4 is
--         the ATTRIBUTION PARTITION: it proves the pure core's replies
--         are already correct at HEAD and only per-line delivery is
--         missing, so t1-t3's red is attributable to buffering alone.
--
-- The reply window is 5 seconds per line (pre-stated; the HEAD
-- deadlock manifests as this timeout — the pack's probe waited
-- indefinitely). A passing exchange completes in milliseconds; the
-- window is two orders of magnitude of slack, not a tuned number.
--
-- R-D20 copy table (byte-wise copies, reviewable by grep):
--   world fixture (worldHead)      <- test-said/Said.hs:81-84 (itself
--                                     test-outcome/Outcome.hs:216-222)
--   utility block ("neg" var 1)    <- test-said/Said.hs:171
--   decision tick (tickDec)        <- test-said/Said.hs:117
--
-- Test names ASCII-only (the membrane locale incident).
module Main (main) where

import Data.List (mapAccumL)
import System.Directory (findExecutable)
import System.IO (BufferMode (LineBuffering), Handle, hClose, hFlush,
                  hGetContents', hGetLine, hPutStrLn, hSetBuffering)
import System.Process (CreateProcess (..), ProcessHandle,
                       StdStream (CreatePipe, Inherit), createProcess,
                       proc, terminateProcess, waitForProcess)
import System.Timeout (timeout)
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.HUnit (assertFailure, testCase, (@?=))

import PropLang.Host (hostStart, serveLine)

main :: IO ()
main = defaultMain (testGroup "transport (#18): per-line delivery over pipes"
  [ t1, t2, t3, t4 ])

-- world fixture copied from test-said/Said.hs:81-84 (R-D20); utility
-- block copied from test-said/Said.hs:171
helloLine :: String
helloLine = "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\", \"z\", \"a\"], "
    ++ "\"guards\": [{\"name\": \"z\", \"grid\": [0.25, 0.5, 0.75]}, "
    ++ "{\"name\": \"a\", \"grid\": [0.5, 1.5]}], "
    ++ "\"menu\": [{\"name\": \"a\", \"grid\": [0.5, 1.5]}], "
    ++ "\"utility\": {\"form\": \"said@1\", \"said\": [\"neg\", [\"var\", 1]]}}}"

-- decision tick copied from test-said/Said.hs:117 (R-D20)
tickDec :: String
tickDec = "{\"tick\": {\"features\": {\"t\": 0, \"z\": 0.7}, \"menu\": [\"a\"]}}"

tickEvid :: String
tickEvid = "{\"tick\": {\"features\": {\"t\": 1, \"z\": 0.7}, \"evidence\": 1}}"

tickSilent :: String
tickSilent = "{\"tick\": {\"features\": {\"t\": 2, \"z\": 0.7}}}"

badLine :: String
badLine = "not json"

requests :: [String]
requests = [helloLine, tickDec, tickEvid, tickSilent]

-- THE EXPECTATION: the frozen pure core itself, folded over the same
-- lines (R-D20 — never a hand-copied literal)
expectedReplies :: [String]
expectedReplies = snd (mapAccumL serveLine hostStart requests)

replyTimeoutUs :: Int
replyTimeoutUs = 5 * 1000 * 1000

spawnHost :: IO (Handle, Handle, ProcessHandle)
spawnHost = do
  mexe <- findExecutable "proplang-host"
  exe <- case mexe of
    Just e  -> pure e
    Nothing -> assertFailure
      "proplang-host not on PATH (cabal supplies it via build-tool-depends; \
      \prepend the built binary's dir for a standalone run)"
  (mi, mo, _, ph) <- createProcess (proc exe [])
      { std_in = CreatePipe, std_out = CreatePipe, std_err = Inherit }
  case (mi, mo) of
    (Just hin, Just hout) -> do
      hSetBuffering hin LineBuffering
      pure (hin, hout, ph)
    _ -> assertFailure "createProcess returned no pipe handles"

stopHost :: (Handle, Handle, ProcessHandle) -> IO ()
stopHost (_, _, ph) = do
  terminateProcess ph
  _ <- waitForProcess ph
  pure ()

-- one lockstep exchange: write the line, then the reply must arrive
-- within the window — Nothing IS the #18 deadlock
exch :: Handle -> Handle -> String -> IO (Maybe String)
exch hin hout l = do
  hPutStrLn hin l
  hFlush hin
  timeout replyTimeoutUs (hGetLine hout)

expectReply :: String -> Maybe String -> String -> IO ()
expectReply label r want = case r of
  Nothing  -> assertFailure
    (label ++ ": no reply line within 5s (the #18 deadlock)")
  Just got -> got @?= want

t1 :: TestTree
t1 = testCase "t1-hello-over-pipes-replies-per-line" $ do
  h@(hin, hout, _) <- spawnHost
  r <- exch hin hout helloLine
  stopHost h
  case expectedReplies of
    (e : _) -> expectReply "hello" r e
    []      -> assertFailure "no expected replies computed"

t2 :: TestTree
t2 = testCase "t2-lockstep-decision-evidence-silent" $ do
  h@(hin, hout, _) <- spawnHost
  mapM_ (\(req, want) -> do
           r <- exch hin hout req
           expectReply req r want)
        (zip requests expectedReplies)
  stopHost h

t3 :: TestTree
t3 = testCase "t3-error-reply-also-delivered-per-line" $ do
  h@(hin, hout, _) <- spawnHost
  r <- exch hin hout badLine
  stopHost h
  expectReply "bad line" r (snd (serveLine hostStart badLine))

t4 :: TestTree
t4 = testCase "t4-eof-flush-parity-attribution-partition" $ do
  h@(hin, hout, _) <- spawnHost
  mapM_ (hPutStrLn hin) requests
  hClose hin
  out <- timeout (2 * replyTimeoutUs) (hGetContents' hout)
  stopHost h
  case out of
    Nothing -> assertFailure "process did not reach EOF within 10s"
    Just o  -> lines o @?= expectedReplies
