{-# LANGUAGE GHC2021 #-}
-- test-readout — the #20 K-ary readout micro-increment's oracle
-- (wire-author-pack.md Part IX; opened 2026-07-30, oracle-first).
--
-- THE CLAIM UNDER TEST (IX.3, the design of record): the decision
-- reply gains one member, "p_codes" — the FULL per-code predictive
-- vector at the tick's readout geometry (full = feats ++ act,
-- post-choice pre-observation; R5), rendered element-wise exactly as
-- p1 is rendered, appended LAST (the W4 utility_bits precedent);
-- present exactly where decPart renders (decision + combined
-- replies), never on evidence-only / silent / internal replies.
-- Observability only: the engine's choice is untouched (VIII.1's
-- GRANT; consumer discipline HOSTS_PLAN 8.12(b), quoted into
-- membrane-wire.md section 3 at this increment's freeze). Plus N1
-- (IX.2's live-defect find): entropy_bits is FINITE on every reply —
-- the reporting edge guards the rendered Double, not only the exact
-- weight (Report.hs:14-17's underflow hole).
--
-- Provenance (R-D20 — copied, never re-derived):
--   * the K=6 world and stream are the IX.2 opening probe's,
--     verbatim (dyadic theta codebook 1/8..7/8; 300 nulls / 100
--     threes interleaved: y = 3 iff t mod 4 == 3);
--   * the combined-tick fold idiom COPIES trampoline g6.3
--     (test-trampoline/Trampoline.hs:524-525) — the fold channel a
--     menu-bearing world actually has;
--   * the no-utility choice is menuAssignments' head (Host.hs:387
--     "wait: the option space's head") — a = 0 every tick;
--   * the element rendering COPIES the p1 convention (Host.hs:428):
--     show (fromRational m :: Double); the joiner is the reply's
--     own ", " (commaSep);
--   * expected strings derive from the SHIPPED exported verbs in
--     this file (the transport expectedReplies law — "never a
--     hand-copied literal"; Transport.hs:93-95).
--
-- Runtime-RED against shipped src (the type surface is complete —
-- no stub is owed; the red IS the missing reply member, and g6's
-- red is the live NaN): every row below fails today, each for its
-- own stated reason. Designed kills (measured at the close matrix,
-- per-row against the pool; the dyadic R7 pre-ruling for sibling
-- shadowing):
--   g1 <- M-r1 (p_codes dropped from decPart);
--   g2 <- M-r2 (vector computed at feats, not feats ++ act — the R5
--          geometry mutant); M-r3 (metaPosterior weights rendered
--          instead of the predictive vector);
--   g3 <- M-r4 (vector order reversed / indexing off by one);
--   g4 <- M-r5 (vector emitted only on the declared-arity route);
--   g5 <- M-r6 (p_codes appended to evidence replies too);
--   g6 <- M-r7 (the Double-side entropy guard reverted).
module Main (main) where

import Data.List (intercalate, isInfixOf, stripPrefix, tails)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (listToMaybe, mapMaybe)
import Data.Ratio ((%))

import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Enumerate (AgentS, agentObsPoints, enumerateWithArity,
                           fragFull, observeS, predictMassS, sentenceAgent)
import PropLang.Host (hostStart, serveLine)
import PropLang.Report (entropyAgent)
import PropLang.Syntax (mkCarrier, mkGrid, mkNamespace)

-- --------------------------------------------------------------- --
-- the IX.2 world (K=6) and stream, verbatim
-- --------------------------------------------------------------- --

helloK6 :: String
helloK6 = "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\", \"a\"], \"guards\": [], "
  ++ "\"codebooks\": {\"theta\": [0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875]}, "
  ++ "\"menu\": [{\"name\": \"a\", \"grid\": [0, 1]}], "
  ++ "\"obs_arity\": 6}}"

ysK6 :: [Int]
ysK6 = [ if t `mod` 4 == 3 then 3 else 0 | t <- [0 .. 399 :: Int] ]

combinedTick :: Int -> Int -> String
combinedTick t y = "{\"tick\": {\"features\": {\"t\": " ++ show t
  ++ "}, \"menu\": [\"a\"], \"evidence\": " ++ show y ++ "}}"

decisionTick :: Int -> String
decisionTick t = "{\"tick\": {\"features\": {\"t\": " ++ show t
  ++ "}, \"menu\": [\"a\"]}}"

-- a session's replies, oldest first (serveLine is the pure wire)
repliesOf :: [String] -> [String]
repliesOf ls = reverse (fst (foldl' step ([], hostStart) ls))
  where step (acc, st) l = let (st', r) = serveLine st l in (r : acc, st')

sessK6 :: [String]
sessK6 = repliesOf (helloK6 : [ combinedTick t y | (t, y) <- zip [0 ..] ysK6 ]
                    ++ [decisionTick 400])

decReplyK6 :: String
decReplyK6 = last sessK6

-- --------------------------------------------------------------- --
-- the derivation over EXPORTED verbs (the same fold, exact)
-- --------------------------------------------------------------- --

orDie :: Either String a -> a
orDie = either error id

agK6 :: AgentS
agK6 = foldl' step ag0 (zip [0 :: Int ..] ysK6)
  where
    nsN = mkNamespace ("t" :| ["a"])
    obsC = mkCarrier "obs" (0 :| [1 .. 5 :: Int])
    thetaG = mkGrid "theta"
               (1 % 8 :| [2 % 8, 3 % 8, 4 % 8, 5 % 8, 6 % 8, 7 % 8])
    pop = enumerateWithArity 6 nsN obsC thetaG [] Nothing fragFull
    ag0 = sentenceAgent nsN pop
    step ag (t, y) =
      snd (orDie (observeS [("t", fromIntegral t), ("a", 0)] y ag))

fullK6 :: [(String, Rational)]
fullK6 = [("t", 400), ("a", 0)]

-- the p1 rendering convention (COPY Host.hs:428)
rD :: Rational -> String
rD m = show (fromRational m :: Double)

vecK6 :: [Rational]
vecK6 = [ orDie (predictMassS fullK6 y agK6) | y <- agentObsPoints agK6 ]

expectedMemberK6 :: String
expectedMemberK6 = "\"p_codes\": [" ++ intercalate ", " (map rD vecK6) ++ "]"

-- --------------------------------------------------------------- --
-- the plain-route world (no obs_arity; g4) and the menu-less world
-- (evidence-only replies exist only where no act is owed; g5)
-- --------------------------------------------------------------- --

helloBin :: String
helloBin = "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\", \"a\"], \"guards\": [], "
  ++ "\"codebooks\": {\"theta\": [0.25, 0.5, 0.75]}, "
  ++ "\"menu\": [{\"name\": \"a\", \"grid\": [0, 1]}]}}"

decReplyBin :: String
decReplyBin = last (repliesOf
  [helloBin, combinedTick 0 1, combinedTick 1 0, decisionTick 2])

helloEv :: String
helloEv = "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\"], \"guards\": [], "
  ++ "\"codebooks\": {\"theta\": [0.25, 0.5, 0.75]}}}"

sessEv :: [String]
sessEv = repliesOf
  [ helloEv
  , "{\"tick\": {\"features\": {\"t\": 0}, \"evidence\": 1}}"
  , "{\"tick\": {\"features\": {\"t\": 1}}}" ]

-- --------------------------------------------------------------- --
-- reply scanners (byte-level, on the engine's own single-line form)
-- --------------------------------------------------------------- --

memberAfter :: String -> String -> Maybe String
memberAfter key s =
  listToMaybe (mapMaybe (stripPrefix ("\"" ++ key ++ "\": ")) (tails s))

arrayElems :: String -> Maybe [String]
arrayElems rest = do
  body <- stripPrefix "[" rest
  pure (splitComma (takeWhile (/= ']') body))

splitComma :: String -> [String]
splitComma = words . map (\c -> if c == ',' then ' ' else c)

scalar :: String -> String
scalar = takeWhile (\c -> c /= ',' && c /= '}')

-- --------------------------------------------------------------- --
-- the rows
-- --------------------------------------------------------------- --

main :: IO ()
main = defaultMain (testGroup "the #20 K-ary readout (the 14.9 wire docket; pack Part IX)"
  [ testCase "g1 shape: the K=6 decide reply carries p_codes with K elements" $
      case memberAfter "p_codes" decReplyK6 >>= arrayElems of
        Nothing -> assertFailure ("no p_codes member: " ++ decReplyK6)
        Just es -> assertEqual "K elements" 6 (length es)
  , testCase "g2 derivation pin: p_codes byte-equals the exported-verb vector at feats ++ act" $
      assertBool ("reply: " ++ decReplyK6 ++ "   want member: " ++ expectedMemberK6)
        (expectedMemberK6 `isInfixOf` decReplyK6)
  , testCase "g3 coherence: p_codes index 1 equals the reply's own p1 rendering" $
      case ( memberAfter "p_codes" decReplyK6 >>= arrayElems
           , scalar <$> memberAfter "p1" decReplyK6 ) of
        (Just es, Just p1s) | length es > 1 ->
          assertEqual "vec[1] == p1" p1s (es !! 1)
        _ -> assertFailure ("member missing: " ++ decReplyK6)
  , testCase "g4 plain route: the binary decide reply carries p_codes, 2 elements, index 1 == p1" $
      case ( memberAfter "p_codes" decReplyBin >>= arrayElems
           , scalar <$> memberAfter "p1" decReplyBin ) of
        (Just es, Just p1s) -> do
          assertEqual "2 elements" 2 (length es)
          assertEqual "vec[1] == p1" p1s (es !! 1)
        _ -> assertFailure ("member missing: " ++ decReplyBin)
  , testCase "g5 presence scope: p_codes rides decPart exactly (combined yes; evidence-only no; silent no)" $ do
      let combinedReply = sessK6 !! 1
      assertBool ("the combined reply carries it: " ++ combinedReply)
        ("\"p_codes\"" `isInfixOf` combinedReply)
      case sessEv of
        [_, evReply, silReply] -> do
          assertBool ("evidence-only reply carries NO p_codes: " ++ evReply)
            (not ("p_codes" `isInfixOf` evReply))
          assertBool ("silent reply carries NO p_codes: " ++ silReply)
            (not ("p_codes" `isInfixOf` silReply))
        _ -> assertFailure "menu-less session shape"
  , testCase "g6 N1: entropy_bits FINITE after the long fold (the edge guards the rendered Double)" $ do
      assertBool "entropyAgent finite on the reconstructed agent"
        (not (isNaN (entropyAgent agK6)))
      assertBool ("no NaN on the wire: " ++ decReplyK6)
        (not ("NaN" `isInfixOf` decReplyK6))
  ])
