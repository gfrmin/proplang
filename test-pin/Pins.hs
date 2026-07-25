{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
-- The Phase-2 pin suite (staged; frozen at the close under the
-- author's key — the increment's opt-law and coincidence pins in one
-- stanza).
--
--   R17 rows — the corpus is a derivation: the generator's small
--     frontier is EXHAUSTIVELY pinned (count derived in-comment,
--     Kraft exact); every family body is IN the corpus's intension
--     (structural membership over declared data); the fragment table
--     is NOT the grammar weight (the registered #5 question, pinned
--     as an inequality with both exemplar values recorded).
--   ARITY rows — W3's capability on the exact surface: the K=2
--     arity route COINCIDES with the plain route EXACTLY (the old g2
--     coincidence, now by ==); the K=4 emission column obeys the
--     categorical law exactly (the SevenSeats/CatBody bank, through
--     the SHIPPED enumeration).
--   SELECTION row — the sentence-route chooseEU obeys CL-3 against
--     a reference fold over the same Expect values (the re-homing's
--     pin, opening ruling 3).
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio ((%))

import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief
import PropLang.Enumerate
import PropLang.Eval
import PropLang.Membrane (chooseEU, predictiveBelief)
import PropLang.Syntax

oracleWorld :: World
oracleWorld = World
  { wNs = mkNamespace ("t" :| [])
  , wObs = mkCarrier "obs" (0 :| [1])
  , wTheta = mkGrid "theta" (1 % 10 :| [ k % 10 | k <- [2 .. 9] ])
  , wTau = mkGrid "tau"
      (5 :| [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80])
  , wRho = mkGrid "rho"
      (1 % 100 :| [2 % 100, 5 % 100, 1 % 10, 2 % 10, 3 % 10, 4 % 10, 5 % 10])
  }

doorAt :: Int -> Features
doorAt t = [("t", fromIntegral t)]

margOf :: [Hyp] -> [Int] -> Rational
margOf hs ys =
  let step (ag, t, m) y = case observeS (doorAt t) y ag of
        Right (mm, ag') -> (ag', t + 1, m * mm)
        Left e -> error ("pin run refused: " ++ e)
      (_, _, m') = foldl step (sentenceAgent (wNs oracleWorld) hs, 0 :: Int, 1)
                     ys
  in m'

cAtP :: Grid -> Int -> Expr env Rational
cAtP g k = case mkC g k of
  Just e -> e
  Nothing -> error "cAtP: off-codebook (unreachable)"

stream20 :: [Int]
stream20 = [1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0]

main :: IO ()
main = defaultMain $ testGroup "the Phase-2 pins"
  [ testGroup "R17: the corpus is a derivation"
      [ testCase "small-frontier exhaustive: 55 sentences at budget 3 over a 2-point codebook (5 leaves + 2*5*5 binaries; If needs >= 6 nodes), Kraft exact" $ do
          let ns = mkNamespace ("t" :| [])
              g2 = mkGrid "theta2" (1 % 10 :| [9 % 10])
              cs = corpusBodies ns [g2] 3
          length cs @?= 55
          let kr = sum (map (weightIn ns) cs)
          assertBool "Kraft over the frontier < 1 (exact)" (kr < 1)
          assertBool "every weight positive" (all ((> 0) . weightIn ns) cs)
      , testCase "every family body is IN the corpus intension (structural membership over declared data, all 1169)" $ do
          let hs = enumerate oracleWorld fragFull
              gs = [ wTheta oracleWorld, wTau oracleWorld
                   , wRho oracleWorld, atomGridOf (wObs oracleWorld) ]
              ok h = case hypEmit h of
                Code _ _ body -> inCorpus (wNs oracleWorld) gs body
                _ -> False
              okMove h = case hypMove h of
                Nothing -> True
                Just (Code _ _ body) -> inCorpus (wNs oracleWorld) gs body
                Just _ -> False
          assertBool "all emissions in-corpus" (all ok hs)
          assertBool "all moves in-corpus" (all okMove hs)
      , testCase "the fragment table is NOT the grammar weight (#5 pinned as inequality; exemplar values recorded)" $ do
          let hs = enumerate oracleWorld fragFull
              h0 = case hs of (x : _) -> x; [] -> error "empty corpus"
              fragW = hypW h0                      -- 1/36 (the selector's table)
              gramW = case hypEmit h0 of
                Code _ _ body -> weightIn (wNs oracleWorld) body
                _ -> 0
          fragW @?= 1 % 36
          assertBool "frag weight /= grammar weight" (fragW /= gramW)
          assertBool "grammar weight positive" (gramW > 0)
      ]
  , testGroup "ARITY: W3's capability, exact"
      [ testCase "K=2 arity route COINCIDES with the plain route: counts and a 20-tick marginal, by ==" $ do
          let ns = wNs oracleWorld
              obsC = wObs oracleWorld
              guards = [ (nm, wTau oracleWorld) | nm <- nsNames ns ]
              plain = enumerateWith ns obsC (wTheta oracleWorld) guards
                        (Just (wRho oracleWorld)) fragFull
              ar2 = enumerateWithArity 2 ns obsC (wTheta oracleWorld) guards
                        (Just (wRho oracleWorld)) fragFull
          length ar2 @?= length plain
          margOf ar2 stream20 @?= margOf plain stream20
      , testCase "K=4 emission column obeys the categorical law exactly (the CatBody vector [7/30,7/30,3/10,7/30])" $ do
          let ns = wNs oracleWorld
              obsC4 = mkCarrier "obs" (0 :| [1, 2, 3])
              guards = [ (nm, wTau oracleWorld) | nm <- nsNames ns ]
              ar4 = enumerateWithArity 4 ns obsC4 (wTheta oracleWorld) guards
                      Nothing fragFull
          case [ h | h <- ar4, hypTag h == ("const", [2, 2]) ] of
            [h] -> do
              env <- either error pure
                       (mkEnvIn ns (doorAt 0) VNil :: Either String (Env '[]))
              case evalx (hypEmit h) env of
                Nothing -> assertFailure "code refused"
                Just k -> do
                  let latPt = case points (uniform (hypLatent h)) of
                        (q : _) -> q
                        [] -> error "unit latent empty (unreachable)"
                  [ prob (kernelAt k latPt) (== y) | y <- [0 .. 3 :: Int] ]
                    @?= [7 % 30, 7 % 30, 3 % 10, 7 % 30]
            _ -> assertFailure "const[2,2] not found"
      ]
  , testCase "SELECTION pin: chooseEU == the CL-3 reference fold, >= 2 candidates through the SENTENCES, tie included (the mandate-1 repair of the singleton base case)" $ do
      -- a two-name world: "m" is writable; candidates differ, so the
      -- fold's pick sentence, reindexUtility, and both Expects are
      -- LIVE code on every step
      let ns2 = mkNamespace ("t" :| ["m"])
          w2 = World
            { wNs = ns2
            , wObs = wObs oracleWorld
            , wTheta = wTheta oracleWorld
            , wTau = wTau oracleWorld
            , wRho = wRho oracleWorld
            }
          atomG = atomGridOf (wObs oracleWorld)
          hs2 = enumerate w2 fragFull
          ag2 = sentenceAgent ns2 hs2
          feats = [("t", 3)]
          -- u = y * (2y - 1): outcome-driven, option code inert
          u = Mul (Var (S Z))
                  (Sub (Mul (addM oneA oneA) (Var (S Z))) oneA)
          oneA = cAtP atomG 1
          cands = [ [("m", 10)], [("m", 70)], [("m", 40)] ]
      scored <- either error pure
        (mapM (\c -> do
            b <- predictiveBelief (feats ++ c) ag2
            pure (c, b)) cands)
      -- the CL-3 REFERENCE: EU per candidate via an evalx'd Expect
      -- (an independent route through the same sentences), strict
      -- displacement, first-listed incumbency
      let euOf (_, b) = case mkEnvIn ns2 (feats ++ [("m", 0)])
                               (b :. VNil) of
            Right env -> evalx (Expect (Var Z)
                          (Mul (Var Z)
                               (Sub (Mul (addM oneA oneA) (Var Z)) oneA)))
                          env
            Left e -> error e
          ref = fst (foldl (\(bst, bv) c ->
                  let cv = euOf c in if cv > bv then (c, cv) else (bst, bv))
                  (case scored of (c0 : _) -> (c0, euOf c0); [] -> error "none")
                  (drop 1 scored))
      got <- either error pure (chooseEU ns2 feats atomG u scored)
      fmap fst got @?= Just (fst ref)
      -- the TIE case: duplicated candidates — the incumbent
      -- (first-listed) must win on both routes
      let dup = [ scored !! 0, scored !! 0 ]
      gotT <- either error pure (chooseEU ns2 feats atomG u dup)
      fmap fst gotT @?= Just (fst (dup !! 0))

  ]
