{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
-- test-selection/Selection.hs — THE SELECTION INCREMENT'S ORACLE
-- (the #24 sitting's (3) increment, opened at chooseeu-sitting-r0,
-- 2026-09-02; the ruling: R-SHAPE rev 2, chooseeu-sitting/drafts/
-- shape-ruling.md at commit 99f6b2a).
--
-- WHAT THIS SUITE PINS.  The pairwise-substituting fold (policyPick's
-- body at the increment's implementation) against (a) the CONSUMER
-- BEHAVIOUR on issue #24's world — head loses, the declared argmax
-- wins, through the SHIPPED WIRE (rows s1, s8, s9, s10); and (b) the
-- one-sentence chooseKS reference, policyPickKS, extensionally, over
-- the MINIMAL SEPARATING FAMILY (rows s2-s7; chooseeu-sitting-r0
-- clause 4b: the family separates the six seeded defects and includes
-- one width past the old cliff, nothing more — breadth is OB-33's
-- matrix's job).
--
-- PROVENANCE (R-D20-i: copied, never re-derived).
--   * #24's world: the issue body's verbatim declaration (values
--     10/100/50, argmax act=2); its wire reply substring is copied
--     from chooseeu-sitting/f1-issue24-transcript.txt (the arm-2
--     reply at 94fd4eb).
--   * The utility composition (eqE / arm / nested if): rule-for-rule
--     from src/PropLang/Host.hs at 94fd4eb, the binding
--     `parseSaidWith` ("+" -> addM; "=" -> the If/Gt composition
--     with singleton-minted true/false; "c" -> the singleton mint =
--     mintQ) — the same copy the r2 prototype carried (transcript
--     r2-f12).
--   * The atom grid: Host.hs at 94fd4eb, the binding `atomGridOfC`
--     (mkCarrier "obs" (0 :| [1 .. kA-1])).
--   * The scoring: Host.hs at 94fd4eb, the binding `scored`
--     (predictiveBelief at feats ++ candidate).
--   * The guarded profile (row s6): bench/BenchLib.hs at 99f6b2a,
--     the binding `profileP2` — namespace/guards/rho/menu copied as
--     data (bench is unfrozen and not importable from a test suite;
--     the copy is asserted against nothing — it is a WORLD, and the
--     row it feeds is an equality row).  The THETA GRID deliberately
--     departs from profileP2's: that grid is SYMMETRIC around 1/2,
--     which makes every candidate's EU exactly 0 under the generic
--     utility — a tie cell in disguise (found by the d5 sweep at the
--     oracle phase: the inversion defect could not fire here).  The
--     asymmetric grid below makes the cell genuinely
--     belief-differentiating, which is its seat in the family.
--   * ONE GENERATOR: each family cell's value list generates BOTH
--     its library utility (uFromValues) and its wire hello
--     (helloFor) — the two routes' agreement is what the rows
--     themselves assert.
--
-- RED-RUN FORM (the two-run triptych): rows s2-s6 are red at the
-- oracle phase through the policyPickKS stub, with the live side
-- FORCED to normal form first (one forceShow per comparison row —
-- the red is attributable to the stub, never shadowed by it).  Row
-- s1 is red NATURALLY (the shipped clockless arm routes chooseEU —
-- the #24 defect itself; its seeded defect is the identifier
-- reversion, and the standing corpus's green at HEAD is the proof
-- no standing row kills it).  Rows s8/s9 are capability pins, green
-- at HEAD (the clock path already substitutes); their reds ride the
-- defect-overlay transcripts (the step-2 pin-freeze form, "or
-- capability" per the step-10 amendment).  Rows s7/s10 are
-- INFEASIBLE at HEAD by measurement (probe A1: ~14.5*2^w walked
-- nodes at w=32 under the pre-increment expansion) — the red run
-- passes --skip-heavy and PRINTS the skip; their reds ride the
-- defect-overlay transcripts (no-silent-caps).
module Main (main) where

import Control.Exception (evaluate)
import Control.Monad (foldM, unless)
import Data.List (intercalate, isInfixOf)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio ((%))
import System.Environment (getArgs)
import System.Exit (exitFailure)

import PropLang.Belief (Belief)
import PropLang.Enumerate (AgentS, enumerateWith, fragFull, sentenceAgent)
import PropLang.Eval (Features)
import PropLang.Host (hostStart, serveLine)
import PropLang.Membrane (menuAssignments, mintQ, policyPick, policyPickKS,
                          predictiveBelief)
import PropLang.Syntax (Expr (..), Grid, Idx (..), Namespace, addM, mkCarrier,
                        mkGrid, mkNamespace)

-- ---------------------------------------------------------------------
-- harness: named rows, PASS/FAIL printed, heavy rows skippable LOUDLY
-- ---------------------------------------------------------------------

data Row = Row { rName :: String, rHeavy :: Bool, rRun :: IO (Either String ()) }

-- the forcing discipline: the LIVE side of every comparison row is
-- brought to normal form (show traverses fully) BEFORE the stub side
-- is consulted, so an oracle-phase red is attributable to the stub
forceShow :: Show a => a -> IO ()
forceShow x = evaluate (length (show x)) >> pure ()

-- candidate identity, the compared value (the r2 prototype's pickName)
pickOf :: Either String (Maybe (Features, b)) -> Either String (Maybe Features)
pickOf = fmap (fmap fst)

expectEq :: (Eq a, Show a) => String -> a -> a -> Either String ()
expectEq what a b
  | a == b = Right ()
  | otherwise = Left (what ++ ": " ++ show a ++ " /= " ++ show b)

-- ---------------------------------------------------------------------
-- the family's ONE GENERATOR: a value list per cell
-- ---------------------------------------------------------------------

-- #24's declared values, verbatim from the issue body (10/100/50,
-- argmax at act=2); width cells place 1000 at a mid slot, 10+k
-- elsewhere (all distinct, argmax neither head nor last)
vals24 :: [Rational]
vals24 = [10, 100, 50]

valsW :: Int -> Int -> [Rational]
valsW w m = [ if k == m then 1000 else 10 + fromIntegral k | k <- [1 .. w] ]

argmaxSlot :: [Rational] -> Rational
argmaxSlot vs = fromIntegral (snd (maximum (zip vs [(1 :: Int) ..])))

-- the library utility from a value list: nested if over act codes,
-- every arm belief-blind (the +0*var(1) form) — parseSaidWith's rules
uFromValues :: [Rational] -> Expr '[Rational, Rational] Rational
uFromValues vs0 = go (1 :: Int) vs0
  where
    go _ [] = error "uFromValues: empty value list (unreachable)"
    go _ [v] = arm v
    go k (v : rest) = If (eqE (Get "act") (mintQ (fromIntegral k)))
                         (arm v) (go (k + 1) rest)
    arm v = addM (mintQ v) (Mul (Var (S Z)) (mintQ 0))
    eqE x y =
      let trueE  = Gt (mintQ 1) (mintQ 0)
          falseE = Gt (mintQ 0) (mintQ 1)
      in If (Gt x y) falseE (If (Gt y x) falseE trueE)

-- the wire hello from the same value list (menu 1..w, the #24
-- namespace/guard/theta shape, said = the same nested if in wire
-- forms), optionally with a clock row
helloFor :: [Rational] -> Maybe Rational -> String
helloFor vs mPrice =
  "{\"membrane\":1,\"world\":{"
    ++ "\"namespace\":[\"ctx\",\"act\"],"
    ++ "\"guards\":[{\"name\":\"ctx\",\"grid\":[0.5]}],"
    ++ "\"menu\":[{\"name\":\"act\",\"grid\":[" ++ menuPts ++ "]}],"
    ++ "\"codebooks\":{\"theta\":[0.1,0.3,0.5,0.7,0.9]},"
    ++ clockPart
    ++ "\"utility\":{\"form\":\"said@1\",\"said\":" ++ said (1 :: Int) vs ++ "}}}"
  where
    menuPts = intercalate "," (map showD (map fromIntegral [1 .. length vs]))
    clockPart = case mPrice of
      Nothing -> ""
      Just p  -> "\"clock\":[{\"name\":\"think\",\"price\":" ++ showD p
                   ++ ",\"batch\":1}],"
    said _ [] = error "helloFor: empty value list (unreachable)"
    said _ [v] = armJ v
    said k (v : rest) =
      "[\"if\",[\"=\",[\"get\",\"act\"],[\"c\"," ++ showD (fromIntegral k)
        ++ "]]," ++ armJ v ++ "," ++ said (k + 1) rest ++ "]"
    armJ v = "[\"+\",[\"c\"," ++ showD v
               ++ "],[\"*\",[\"var\",1],[\"c\",0.0]]]"
    showD q = show (fromRational q :: Double)

tickLine :: String
tickLine = "{\"tick\":{\"features\":{\"ctx\":1.0},\"menu\":[\"act\"]}}"

-- ---------------------------------------------------------------------
-- library worlds
-- ---------------------------------------------------------------------

ns24 :: Namespace
ns24 = mkNamespace ("ctx" :| ["act"])

atomBin :: Grid
atomBin = mkGrid "obs-atoms" (0 :| [1])

grid1 :: String -> [Rational] -> Grid
grid1 nm ds = case ds of
  (q : qs) -> mkGrid nm (q :| qs)
  []       -> error "grid1: empty grid (unreachable)"

agent24 :: AgentS
agent24 =
  let thetaG = grid1 "theta" [1 % 10, 3 % 10, 5 % 10, 7 % 10, 9 % 10]
      gs = [("ctx", grid1 "ctx" [1 % 2])]
      obsC = mkCarrier "obs" (0 :| [1])
  in sentenceAgent ns24 (enumerateWith ns24 obsC thetaG gs Nothing fragFull)

feats24 :: Features
feats24 = [("ctx", 1)]

cands24For :: Int -> [Features]
cands24For w = menuAssignments [("act", grid1 "act" (map fromIntegral [1 .. w]))]

scoreCands :: Features -> AgentS -> [Features]
           -> Either String [(Features, Belief Int)]
scoreCands feats ag = mapM (\c -> do
  b <- predictiveBelief (feats ++ c) ag
  Right (c, b))

-- the guarded belief-differentiating world (profileP2's data, copied)
nsG :: Namespace
nsG = mkNamespace ("s" :| ["c", "act"])

sx :: [Integer] -> [Rational]
sx = map (% 16)

agentG :: AgentS
agentG =
  let thetaG = grid1 "theta" (sx [1, 3, 5, 7, 9, 11, 14])
      gs = [ ("s", grid1 "s" [1 % 2])
           , ("c", grid1 "c" (sx [4, 8, 12]))
           , ("act", grid1 "act" [1 % 2, 3 % 2]) ]
      rhoG = Just (grid1 "rho" (sx [1, 2, 4, 8]))
      obsC = mkCarrier "obs" (0 :| [1])
  in sentenceAgent nsG (enumerateWith nsG obsC thetaG gs rhoG fragFull)

featsG :: Features
featsG = [("s", 0), ("c", 1 % 4)]

candsG :: [Features]
candsG = menuAssignments [("act", grid1 "act" [0, 1, 2])]

uG :: Expr '[Rational, Rational] Rational
uG = Mul (Get "act") (Sub (Mul (mintQ 2) (Var (S Z))) (mintQ 1))

-- ---------------------------------------------------------------------
-- rows
-- ---------------------------------------------------------------------

-- a comparison row over the family: policyPick vs the constructed
-- answer (when one exists) vs policyPickKS — live side forced first
cmpRow :: String -> Bool -> Namespace -> Features -> Grid
       -> Expr '[Rational, Rational] Rational -> [(Features, Belief Int)]
       -> Maybe Features -> Row
cmpRow name heavy ns feats atomG u scored mExpect = Row name heavy $ do
  let live = pickOf (policyPick ns feats atomG u scored)
  forceShow live
  let absCheck = case mExpect of
        Nothing -> Right ()
        Just e  -> expectEq "policyPick vs constructed" live (Right (Just e))
      refCheck = expectEq "policyPick vs policyPickKS" live
                   (pickOf (policyPickKS ns feats atomG u scored))
  pure (absCheck >> refCheck)

-- a wire row: hello + tick, the reply must carry the expected act
wireRow :: String -> Bool -> String -> String -> Row
wireRow name heavy hello expectSub = Row name heavy $ do
  let (st1, r1) = serveLine hostStart hello
      (_, r2) = serveLine st1 tickLine
  forceShow r2
  pure $ do
    unless ("\"ok\": true" `isInfixOf` r1)
      (Left ("hello refused: " ++ r1))
    unless (expectSub `isInfixOf` r2)
      (Left ("reply " ++ r2 ++ " lacks " ++ expectSub))

rows :: [Row]
rows =
  [ -- s1 — THE 4a ROW: #24's world, clockless, through the shipped
    -- wire; head loses, the declared argmax wins.  The expected
    -- substring is the f1 transcript's arm-2 reply fragment (the
    -- clock arm's answer, now demanded of the clockless arm).
    wireRow "s1.wire24-clockless-argmax" False
      (helloFor vals24 Nothing) "\"act\": {\"act\": 2}"
  , cmpRow "s2.lib24-fold-eq-ks" False ns24 feats24 atomBin
      (uFromValues vals24) (scored24 3) (Just [("act", 2)])
  , -- s3 — the tie world: all arms equal, strict Gt keeps the HEAD
    -- (first-listed incumbent; separates the Ge and Le defects)
    cmpRow "s3.lib24-tie-head" False ns24 feats24 atomBin
      (uFromValues [10, 10, 10]) (scored24 3) (Just [("act", 1)])
  , cmpRow "s4.lib-w8" False ns24 feats24 atomBin
      (uFromValues (valsW 8 5)) (scored24 8)
      (Just [("act", argmaxSlot (valsW 8 5))])
  , cmpRow "s5.lib-w16" False ns24 feats24 atomBin
      (uFromValues (valsW 16 9)) (scored24 16)
      (Just [("act", argmaxSlot (valsW 16 9))])
  , cmpRow "s6.lib-guarded-eq" False nsG featsG atomBin uG scoredG Nothing
  , -- s7 — one width past the old cliff, FOLD-ONLY (the reference is
    -- unevaluable here by its own cost — probe A1; the residual is
    -- printed below, never absorbed)
    Row "s7.lib-w32-fold-argmax" True $ do
      let live = pickOf (policyPick ns24 feats24 atomBin
                           (uFromValues (valsW 32 17)) (scored24 32))
      forceShow live
      pure (expectEq "policyPick w32 vs constructed" live
              (Right (Just [("act", argmaxSlot (valsW 32 17))])))
  , -- s8/s9 — the clock path over the same family (clause 5:
    -- pickWire routed through the family).  s8: a prohibitive think
    -- price, the external argmax must win.  s9: price 0 makes the
    -- think row TIE the best external row exactly on a belief-blind
    -- world (tv = the best arm's value); strict displacement keeps
    -- the EXTERNAL act (separates Ge/Le at the think comparison).
    wireRow "s8.wire24-clock-highprice-argmax" False
      (helloFor vals24 (Just 1000)) "\"act\": {\"act\": 2}"
  , wireRow "s9.wire24-clock-price0-tie-ext" False
      (helloFor vals24 (Just 0)) "\"act\": {\"act\": 2}"
  , wireRow "s10.wire-w32-clock-argmax" True
      (helloFor (valsW 32 17) (Just 1000)) "\"act\": {\"act\": 17}"
  ]
  where
    scored24 w = either (error . ("scoring refused: " ++)) id
                   (scoreCands feats24 agent24 (cands24For w))
    scoredG = either (error . ("scoring refused: " ++)) id
                (scoreCands featsG agentG candsG)

main :: IO ()
main = do
  args <- getArgs
  let skipHeavy = "--skip-heavy" `elem` args
  putStrLn "test-selection — the selection increment's oracle (chooseeu-sitting-r0)"
  putStrLn "RESIDUAL: equality cells stop at w=16 — the reference's own cost"
  putStrLn "  (probe A1: walked term ~14.5*2^w); w=32 cells are fold-only."
  putStrLn "RESIDUAL: the family is the MINIMAL SEPARATING family (clause 4b);"
  putStrLn "  breadth is OB-33's matrix's job, pools are grown."
  bad <- foldM (step skipHeavy) (0 :: Int) rows
  if bad == 0 then putStrLn "ALL ROWS PASS" else exitFailure
  where
    step skipHeavy bad r
      | skipHeavy && rHeavy r = do
          putStrLn ("SKIP " ++ rName r ++ " (--skip-heavy: infeasible at the"
                    ++ " pre-increment expansion BY MEASUREMENT, A1/F9; its"
                    ++ " red rides the defect-overlay transcript)")
          pure bad
      | otherwise = do
          res <- rRun r
          case res of
            Right () -> putStrLn ("PASS " ++ rName r) >> pure bad
            Left e   -> putStrLn ("FAIL " ++ rName r ++ " — " ++ e)
                          >> pure (bad + 1)
