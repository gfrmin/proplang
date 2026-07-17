{-# LANGUAGE DataKinds #-}

-- test-outcome/Outcome.hs — the step-8 increment oracle (AGENT_PLAN
-- §7 step 8: UTILITY ON WORLD STATES, LATENT; outcome-author-pack.md
-- Parts I-VII). `Util a y` — the host-function wrapper that carried
-- the calculator — dies; utility is a PRICED SENTENCE (USent, the
-- residue-scope program) evaluated at the tick's features through the
-- ONE bridge (uAt). The doctrine: no OUTCOME sort exists because none
-- is owed — features are the world state as rendered, and the act is
-- among them since step 6.
--
--   g1  THE BRIDGE: the measured one-site delta pinned — Get inside a
--       utility reads the world; the repeal's arithmetic face
--       ("featureless and clockless" was one empty-environment
--       argument, E-d1a).
--   g2  THE SEAMS: EU and FnUtil pinned two-route to the public
--       arithmetic over USent; the membrane fold re-pinned (the
--       step-6 g2 bridge, carried to the new surface).
--   g3  THE SCOPE LINE (ruling D-e7, order 2): the visible-fuse world
--       as a GREEN DECLARED-LIMITATION pin, R-D23 form — the myopic
--       refusal ASSERTED as the known behaviour. BOTH gaps, printed:
--       (i) choice-side — the depth composition is blocked by the
--       body's ELIMINATORS (no Features projection; IsEq var-to-var
--       is the grammar's only Features predicate — the 8b compile
--       transcript, pack §9); (ii) model-side — no transition-
--       hypothesis family exists to LEARN a rollforward even if one
--       were sayable (the granted-transition prototype, pack §12).
--       This row is flipped DELIBERATELY by whichever boundary lands
--       the horizon (step 10's reflexive-cost terrain: depth earned,
--       not toggled), never silently.
--   g4  THE WIRE (ruling D-e5): said@1 — the principal's declaration
--       as a POINT-MASS PRIOR over the program shape; unparseable
--       declarations FAIL CLOSED.
--   g5  THE LATENT HALF: the grid-priced parameter behind the
--       point-mass shape, moved by evidence through the one door
--       (the CIRL miniature, re-derived over USent).

module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import GHC.Float (castDoubleToWord64)
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.HUnit (assertBool, testCase, (@?=))

import PropLang.Belief (expect)
import PropLang.Enumerate (Agent, Obs, enumerateSentencesIn,
                           fragFull, observe, predictive, sentenceAgent)
import PropLang.Eval (Features, Vals (..), evalx, mkEnv, uAt)
import PropLang.Host (hostStart, serveLine)
import PropLang.Membrane (Pilot (..), PureWorld (..), TickTrace (..),
                          runMembrane)
import PropLang.Syntax (Args (..), Expr (..), Fn (..), Grid, Idx (..),
                        StdName (..), USent (..), mkC, mkGrid,
                        mkNamespace)

main :: IO ()
main = defaultMain $ testGroup "outcome -- utility on world states, latent (step 8)"
  [ g1Bridge
  , g2Seams
  , g3ScopeLine
  , g4Wire
  , g5Latent
  ]

-- ---------------------------------------------------------------------
-- shared fixture surface
-- ---------------------------------------------------------------------

gk :: Double -> Expr env Double
gk v = case mkC (mkGrid "k" (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "outcome fixture: singleton grid index 0 must construct"

w64 :: Double -> Integer
w64 = toInteger . castDoubleToWord64

-- u(feats, code, y) = y - 0.2 * Get "a": the fuse world's utility AS
-- A SENTENCE — the act read from the world (the doctrine's face)
uFuse :: USent
uFuse = USent (Sub (Var (S Z)) (Mul (gk 0.2) (Get "a")))

-- a code-dispatching utility (the residue var serving code-shaped
-- options): u = if code > 0.5 then (2y - 1.5) else 0.1
uCode :: USent
uCode = USent (If (Gt (Var Z) (gk 0.5))
                  (Sub (Mul (gk 2) (Var (S Z))) (gk 1.5))
                  (gk 0.1))

zG, aG :: Grid
zG = mkGrid "zc" (0.25 :| [0.5, 0.75])
aG = mkGrid "ac" (0.5 :| [1.5])

-- ---------------------------------------------------------------------
-- g1: the bridge (the one-site delta, pinned)
-- ---------------------------------------------------------------------

g1Bridge :: TestTree
g1Bridge = testGroup "g1 the bridge: Get inside a utility reads the world"
  [ testCase "the E-d1 payload at feats=[] vs feats=[x=10]: only Get moves, by exactly the feature" $ do
      let pay = USent (Add (Mul (Var Z) (Var (S Z))) (Get "x"))
      uAt [] pay 2 3 @?= 6.0
      uAt [("x", 10)] pay 2 3 @?= 16.0
  , testCase "USay evaluates to SYNTAX (the wrapper is dead): both routes bit-equal at arbitrary points" $ do
      let pay = Sub (Var (S Z)) (Mul (gk 0.2) (Get "a"))
          viaDoor = evalx (USay pay) (mkEnv [] VNil)
          direct  = USent pay
          probe u = [ uAt fs u a y | fs <- [[], [("a", 1)], [("a", 1), ("b", 7)]]
                                   , a <- [0, 1.5], y <- [0, 1] ]
      map w64 (probe viaDoor) @?= map w64 (probe direct)
  , testCase "the mute face: a Get on an absent name reads 0 (dormancy, unchanged by the step)" $ do
      let u = USent (Get "ghost")
      w64 (uAt [("t", 3)] u 1 1) @?= w64 0
  ]

-- ---------------------------------------------------------------------
-- g2: the seams (EU / FnUtil / the fold), two-route
-- ---------------------------------------------------------------------

trainedTZA :: Agent
trainedTZA =
  let pop = enumerateSentencesIn (mkNamespace ("t" :| ["z", "a"]))
                                 [("z", zG), ("a", aG)] fragFull
      step ag (t, aval, y) =
        case observe [("t", t), ("z", 0.5), ("a", aval)] y ag of
          Just (_, a') -> a'
          Nothing      -> error "outcome g2: impossible evidence"
      ticks = [ (fromIntegral i, if even (i `div` 5) then 1.5 else 0.5,
                 if even (i `div` 5) then 1 else 0 :: Obs)
              | i <- [0 .. 39 :: Int] ]
  in foldl step (sentenceAgent pop) ticks

g2Seams :: TestTree
g2Seams = testGroup "g2 the seams: the public arithmetic over USent, two-route"
  [ testCase "EU == expect . uAt (the verb against the hand route, bit-exact)" $ do
      let feats = [("t", 40), ("z", 0.5), ("a", 1.5)] :: Features
          b = predictive feats trainedTZA
          viaVerb = evalx (Call EU (Var Z :* Var (S Z) :* Var (S (S Z))
                                    :* Var (S (S (S Z))) :* ANil))
                          (mkEnv [] (b :. uFuse :. feats :. (0 :: Double) :. VNil))
          byHand = expect b (\y -> uAt feats uFuse 0 (fromIntegral y))
      w64 viaVerb @?= w64 byHand
  , testCase "FnUtil reads the ENV's features (the seam carries the world)" $ do
      let feats = [("t", 40), ("z", 0.5), ("a", 1.5)] :: Features
          b = predictive feats trainedTZA
          viaExpand = evalx (Expect (Var Z) (FnUtil uFuse 0))
                            (mkEnv feats (b :. VNil))
          byHand = expect b (\y -> uAt feats uFuse 0 (fromIntegral y))
      w64 viaExpand @?= w64 byHand
  , testCase "the fold == the public per-assignment arithmetic (the step-6 bridge, re-pinned over USent)" $ do
      let feats = [("t", 40), ("z", 0.5)] :: Features
          euPub a = expect (predictive (feats ++ a) trainedTZA)
                           (\y -> uAt (feats ++ a) uFuse 0 (fromIntegral y))
          opts = [[("a", 0.5)], [("a", 1.5)]] :: [Features]
          pubPick = case pairs of
            p0 : ps -> fst (foldl (\(b0, bv) (x, v) ->
                              if v > bv then (x, v) else (b0, bv)) p0 ps)
            []      -> error "outcome g2: empty option space"
          pairs = [ (a, euPub a) | a <- opts ]
          w = PureWorld { wFeats = const feats
                        , wEvidence = const Nothing
                        , wMenu = const [("a", aG)]
                        , wStep = \s _ -> s }
      case runMembrane w (PilotEU uFuse) 1 (0 :: Int) trainedTZA of
        Just (_, [tr]) -> ttAct tr @?= pubPick
        _              -> error "outcome g2: one tick expected"
  , testCase "the residue var serves code-shaped options: uCode dispatches on Var Z" $ do
      uAt [] uCode 1.0 1 @?= 0.5
      uAt [] uCode 0.0 1 @?= 0.1
  ]

-- ---------------------------------------------------------------------
-- g3: THE SCOPE LINE (D-e7 order 2; R-D23 green declared-limitation)
-- ---------------------------------------------------------------------

g3ScopeLine :: TestTree
g3ScopeLine = testGroup "g3 THE SCOPE LINE: recurring-stakes myopia, asserted (R-D23; flipped deliberately, never silently)"
  [ testCase "the visible-fuse world: the trained myopic loop REFUSES the dominant act (the known limitation, its heir step 10)" $ do
      -- phase 1: ten scripted episodes on the fuse world (lag 5)
      let ns = mkNamespace ("t" :| ["pending", "a"])
          g01 nm = mkGrid nm (0.5 :| [])
          pop = enumerateSentencesIn ns [("pending", g01 "pending"), ("a", g01 "a")] fragFull
          epT = 12 :: Int; lagK = 5 :: Int
          yStream e = [ if (e * 7 + t) `mod` 10 < 9 then 1 else 0 | t <- [0 .. epT - 1] ]
          aScript e = [ (e * 13 + t) `mod` 2 == 0 | t <- [0 .. epT - 1] ]
          runEp (ag0, _) e = (foldl stepT ag0 [0 .. epT - 1], ())
            where
              fusesAt = scanl (\fs t -> [ f + 1 | f <- fs, f < lagK ]
                                        ++ [ 0 | aScript e !! t ]) [] [0 .. epT - 1]
              stepT ag t =
                let pend = if any (== lagK) (fusesAt !! t) then 1.0 else 0.0
                    aval = if aScript e !! t then 1.0 else 0.0
                    py = if pend > 0.5 then 0.9 else 0.1 :: Double
                    y = if py > 0.5 then yStream e !! t else 1 - (yStream e !! t)
                in case observe [("t", fromIntegral t), ("pending", pend), ("a", aval)] y ag of
                     Just (_, a') -> a'
                     Nothing      -> error "g3: impossible evidence"
          (agT, _) = foldl runEp (sentenceAgent pop, ()) [1 .. 10 :: Int]
          -- the decision at a fresh episode's t=0 (pending 0; the fuse
          -- would pay at t=5): myopic EU refuses — THE KNOWN BEHAVIOUR
          feats = [("t", 0), ("pending", 0)] :: Features
          euA a = expect (predictive (feats ++ a) agT)
                         (\y -> uAt (feats ++ a) uFuse 0 (fromIntegral y))
          euAct = euA [("a", 1)]
          euWait = euA [("a", 0)]
      assertBool ("the myopic rule refuses (euAct < euWait): "
                  ++ show (euAct, euWait))
                 (euAct < euWait)
  ]

-- ---------------------------------------------------------------------
-- g4: the wire, said@1 (D-e5: point-mass, fail-closed)
-- ---------------------------------------------------------------------

helloSaid :: String
helloSaid = "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\", \"z\", \"a\"], "
    ++ "\"guards\": [{\"name\": \"z\", \"grid\": [0.25, 0.5, 0.75]}, "
    ++ "{\"name\": \"a\", \"grid\": [0.5, 1.5]}], "
    ++ "\"menu\": [{\"name\": \"a\", \"grid\": [0.5, 1.5]}], "
    ++ "\"utility\": {\"form\": \"said@1\", \"said\": "
    ++ "[\"-\", [\"var\", 1], [\"*\", [\"c\", 0.2], [\"get\", \"a\"]]]}}}"

helloBadSaid :: String
helloBadSaid = "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\"], "
    ++ "\"guards\": [], \"menu\": [], "
    ++ "\"utility\": {\"form\": \"said@1\", \"said\": [\"frobnicate\", 1]}}}"

tickDec :: String
tickDec = "{\"tick\": {\"features\": {\"t\": 0, \"z\": 0.7}, \"menu\": [\"a\"]}}"

g4Wire :: TestTree
g4Wire = testGroup "g4 the wire: said@1 -- the principal's declaration, fail-closed"
  [ testCase "a said@1 hello parses, prices, and answers with the engine's own census" $ do
      let (_, r) = serveLine hostStart helloSaid
          pop = enumerateSentencesIn (mkNamespace ("t" :| ["z", "a"]))
                                     [("z", zG), ("a", aG)] fragFull
      r @?= "{\"ok\": true, \"proto\": 1, \"models\": "
            ++ show (length pop) ++ ", \"namespace_bits\": "
            ++ show (logBase 2 3 :: Double) ++ "}"
  , testCase "the decision routes through the declared program (two-route against the public arithmetic)" $ do
      let (s1, _) = serveLine hostStart helloSaid
          (_, r) = serveLine s1 tickDec
          pop = enumerateSentencesIn (mkNamespace ("t" :| ["z", "a"]))
                                     [("z", zG), ("a", aG)] fragFull
          ag = sentenceAgent pop
          feats = [("t", 0), ("z", 0.7)] :: Features
          euA a = expect (predictive (feats ++ a) ag)
                         (\y -> uAt (feats ++ a) uFuse 0 (fromIntegral y))
          expected = if euA [("a", 1.5)] > euA [("a", 0.5)]
                       then "1.5" else "0.5"
      assertBool ("act matches the public arithmetic, got: " ++ r)
                 (("\"act\": {\"a\": " ++ expected ++ "}") `isPrefixOfAnywhere` r)
  , testCase "an unparseable declaration FAILS CLOSED (the ruled doctrine)" $ do
      let (_, r) = serveLine hostStart helloBadSaid
      r @?= "{\"error\": \"bad hello\"}"
  ]

isPrefixOfAnywhere :: String -> String -> Bool
isPrefixOfAnywhere n hay = any (\s -> take (length n) s == n) (tails hay)
  where tails s = case s of [] -> [[]]; (_ : t) -> s : tails t

-- ---------------------------------------------------------------------
-- g5: the latent half (point-mass shape, grid-priced parameter)
-- ---------------------------------------------------------------------

g5Latent :: TestTree
g5Latent = testGroup "g5 the latent half: the parameter behind the point-mass shape moves through the one door"
  [ testCase "evidence moves the belief over the utility parameter; the chosen act follows it" $ do
      -- the family: u_p = if code > 0.5 then (2p - 1) * (2y - 1) else 0
      -- (act pays when p is high, costs when p is low); p in {0.2, 0.8}
      let uP p = USent (If (Gt (Var Z) (gk 0.5))
                           (Mul (gk (2 * p - 1))
                                (Sub (Mul (gk 2) (Var (S Z))) (gk 1)))
                           (gk 0))
          -- point-mass over the shape; the parameter latent with a
          -- declared prior; human evidence: y=1 iff the world favors
          -- high p (likelihood 0.9/0.1) — three approvals arrive
          like p y = if y == (1 :: Obs) then (if p > 0.5 then 0.9 else 0.1)
                                        else (if p > 0.5 then 0.1 else 0.9)
          post ys = let raw = [ (p, product [ like p y | y <- ys ])
                              | p <- [0.2, 0.8] ]
                        z = sum (map snd raw)
                    in [ (p, m / z) | (p, m) <- raw ]
          -- the act under the posterior-mixed utility, via the bridge
          euAct ys = sum [ m * uAt [] (uP p) 1 1 | (p, m) <- post ys ]
      assertBool "prior (no evidence): acting is worth ~0 (the mixture cancels)"
                 (abs (euAct []) < 1e-12)
      assertBool "after three approvals: acting is worth > 0.5 (the parameter moved)"
                 (euAct [1, 1, 1] > 0.5)
      assertBool "after three disapprovals: acting is worth < -0.5 (deference the other way)"
                 (euAct [0, 0, 0] < -0.5)
  ]
