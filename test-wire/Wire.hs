-- | test-wire — the wire's fail-closed conformance oracle.
--
-- THE INCREMENT.  membrane-wire.md section 2 declares the door's law:
-- "Unparseable or unpriceable declarations are validation failures —
-- FAIL-CLOSED."  The shipped host honours that for guards, menu names,
-- codebooks, grids, obs_arity, the clock row, evidence range and tick
-- menus.  It does NOT honour it for the reads inside a wire-supplied
-- UTILITY: an undeclared name there passes the hello gate and reaches
-- the partial Get case in Eval.evalx, whose own comment claims the case
-- is "door-unreachable".  The wire reaches it.
--
-- This is a CONFORMANCE REPAIR, not a language increment: the frozen
-- membrane already declares the behaviour these rows assert, so nothing
-- here changes the alphabet, adds a production, or moves a type.  No
-- primitivity gate is owed and no ablation fixture is owed, because no
-- terminal enters or leaves.
--
-- PROVENANCE.  Found live at the paper boundary while executing the
-- witness the author's freeze review asked for (PAPER.md section 7,
-- promoting claim 6 from ARGUED to EXECUTED): the transcript's leg 3 is
-- the reproduction.  The author's ruling on the fork was "never freeze a
-- known bug or hole", so the terminus waits behind this suite.
--
-- THE LATENCY IS THE INTERESTING PART (w2).  Haskell's laziness means an
-- undeclared read in a branch the guard does not take is never forced.
-- So one and the same malformed declaration is a crash or a success
-- depending on runtime data — a hello accepted today crashes on the tick
-- the guard flips.  That is why the repair belongs AT THE DOOR, where a
-- declaration is well-formed or not independently of which branch runs,
-- and not in evalx, where it would only ever be a better-worded crash.
--
-- RED PARTITION (the two-run triptych).  Against the shipped
-- pre-increment surface: w1, w2 and w5 are RED (the hello is accepted,
-- and the decision tick either crashes the host or silently succeeds);
-- w3 and w4 are GREEN (they are the controls — the declared reads that
-- must keep working, and they pin that the repair does not over-refuse).
-- A repair that refused everything would turn w1/w2/w5 green and w3/w4
-- red; a repair that refused nothing leaves w1/w2/w5 red.  Only the
-- correct one is all-green, which is what makes the control rows part of
-- the assertion rather than decoration.
module Main (main) where

import Test.Tasty
import Test.Tasty.HUnit

import Data.List (isInfixOf)

import PropLang.Host (hostStart, serveLine)

main :: IO ()
main = defaultMain (testGroup "wire fail-closed conformance" [w1, w2, w3, w4, w5])

-- ---------------------------------------------------------------------
-- the worlds (one generator: every row's hello comes from helloU, so a
-- row differs from its control ONLY in the utility sentence)
-- ---------------------------------------------------------------------

-- a two-option menu is load-bearing: with ONE option the utility is
-- never evaluated, which is exactly how this defect stayed latent
helloU :: String -> String
helloU said =
  "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\", \"m\"], "
    ++ "\"guards\": [], "
    ++ "\"menu\": [{\"name\": \"m\", \"grid\": [-1, 1]}], "
    ++ "\"codebooks\": {\"theta\": [0.3, 0.7]}, "
    ++ "\"utility\": {\"form\": \"said@1\", \"said\": " ++ said ++ "}}}"

decisionTick :: String
decisionTick = "{\"tick\": {\"features\": {\"t\": 0}, \"menu\": [\"m\"]}}"

-- a plain second line, to prove the session SURVIVES a refusal (w5)
laterTick :: String
laterTick = "{\"tick\": {\"features\": {\"t\": 1}, \"menu\": [\"m\"]}}"

helloReply :: String -> String
helloReply said = snd (serveLine hostStart (helloU said))

-- hello, then the given tick lines; every reply in order
replies :: String -> [String] -> [String]
replies said ticks = go (fst (serveLine hostStart (helloU said))) ticks
  where
    go _ [] = []
    go st (l : ls) = let (st', r) = serveLine st l in r : go st' ls

refused :: String -> Bool
refused r = "\"error\"" `isInfixOf` r

accepted :: String -> Bool
accepted r = "\"ok\": true" `isInfixOf` r

-- ---------------------------------------------------------------------
-- w1 — an undeclared read in the utility is REFUSED AT THE HELLO
-- ---------------------------------------------------------------------

w1 :: TestTree
w1 = testGroup "w1 an undeclared read is refused at the door"
  [ testCase "w1a a bare undeclared read" $
      assertBool "hello with [get zzz] must be refused"
        (refused (helloReply "[\"get\", \"zzz\"]"))
  , testCase "w1b an undeclared read nested inside arithmetic" $
      assertBool "hello with a nested [get zzz] must be refused"
        (refused (helloReply
          "[\"*\", [\"c\", 1], [\"-\", [\"var\", 1], [\"get\", \"zzz\"]]]"))
  , testCase "w1c an undeclared read under a guard" $
      assertBool "hello with [get zzz] in the guard must be refused"
        (refused (helloReply
          "[\"if\", [\">\", [\"get\", \"zzz\"], [\"c\", 0]], [\"var\", 1], [\"c\", 0]]"))
  ]

-- ---------------------------------------------------------------------
-- w2 — THE LATENT CASE: an undeclared read the guard does not take
-- ---------------------------------------------------------------------
-- On the shipped surface this hello is accepted AND the decision tick
-- SUCCEEDS, because laziness never forces the untaken branch.  It is the
-- same malformed declaration as w1c; only the guard's constant differs.
-- A door check refuses it; an evalx-side check never sees it.

w2 :: TestTree
w2 = testGroup "w2 an undeclared read is refused even where laziness hides it"
  [ testCase "w2a undeclared read in the UNTAKEN branch" $
      assertBool "hello must be refused though the branch is never forced"
        (refused (helloReply
          "[\"if\", [\">\", [\"c\", 1], [\"c\", 0]], [\"var\", 1], [\"get\", \"zzz\"]]"))
  , testCase "w2b the same sentence with the guard flipped is refused identically" $
      assertBool "refusal must not depend on which branch the guard takes"
        (refused (helloReply
          "[\"if\", [\">\", [\"c\", 0], [\"c\", 1]], [\"var\", 1], [\"get\", \"zzz\"]]"))
  ]

-- ---------------------------------------------------------------------
-- w3, w4 — THE CONTROLS: declared reads must still be accepted
-- ---------------------------------------------------------------------
-- These pin that the repair does not over-refuse.  Without them a
-- "refuse every utility" patch would turn this suite green, which is the
-- green-that-cannot-fail's mirror: a red that fires for the wrong
-- reason.  w4 matters specifically because a MENU name is writable and
-- is legitimately read by the t2-lineage utility.

w3 :: TestTree
w3 = testGroup "w3 control: a declared namespace read is accepted"
  [ testCase "w3a [get t] is accepted" $
      assertBool "a declared read must be accepted"
        (accepted (helloReply "[\"get\", \"t\"]"))
  , testCase "w3b a declared read serves a decision tick" $
      case replies "[\"get\", \"t\"]" [decisionTick] of
        [r] -> assertBool ("decision tick must serve, got: " ++ r)
                 ("\"act\"" `isInfixOf` r)
        rs  -> assertFailure ("expected one reply, got " ++ show (length rs))
  ]

w4 :: TestTree
w4 = testGroup "w4 control: a declared MENU-name read is accepted"
  [ testCase "w4a [get m] is accepted" $
      assertBool "a menu name is a declared read"
        (accepted (helloReply "[\"get\", \"m\"]"))
  , testCase "w4b the all-nine-form utility of PAPER.md section 7 is accepted" $
      assertBool "the paper's live-host hello must keep working"
        (accepted (helloReply
          ("[\"if\", [\"=\", [\"get\", \"m\"], [\"get\", \"m\"]], "
            ++ "[\"if\", [\">\", [\"get\", \"m\"], [\"c\", 0]], "
            ++ "[\"*\", [\"get\", \"m\"], [\"-\", [\"+\", [\"var\", 1], "
            ++ "[\"var\", 1]], [\"c\", 1]]], "
            ++ "[\"*\", [\"get\", \"m\"], [\"-\", [\"+\", [\"var\", 1], "
            ++ "[\"var\", 1]], [\"c\", 1]]]], [\"c\", 0]]")))
  ]

-- ---------------------------------------------------------------------
-- w5 — a refusal is a WIRE ERROR: the session survives it
-- ---------------------------------------------------------------------
-- The defect's signature is not merely "wrong answer" but "the host
-- process dies", which on a real wire takes the session and every other
-- client decision with it.  This row asserts the refusal is served like
-- any other bad hello: the state stays awaiting, and a subsequent line
-- is answered rather than lost.

w5 :: TestTree
w5 = testGroup "w5 a refused hello leaves a live session, not a dead host"
  [ testCase "w5a the refused hello's ticks are answered, not fatal" $
      case replies "[\"get\", \"zzz\"]" [decisionTick, laterTick] of
        [r1, r2] -> do
          assertBool ("first tick must be answered, got: " ++ r1) (refused r1)
          assertBool ("second tick must be answered, got: " ++ r2) (refused r2)
        rs -> assertFailure ("expected two replies, got " ++ show (length rs))
  ]
