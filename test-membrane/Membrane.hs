{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

-- | The membrane increment's oracle (MEMBRANE_PLAN Task 1; interface.md
-- §1–§3, §5 with §8's tests A, B, C and E's slot-grid row). Authored
-- runtime-red against the type-surface stubs, before any
-- implementation, per the canonized increment protocol; on the author's
-- Task 2 signature this file is as frozen as test/.
--
-- Anchor policy: group 1 (parity) reuses the FROZEN anchors — the
-- membrane re-expresses the frozen worlds and must reproduce
-- test/Anchors.hs values under test/Anchors.hs tolerances, plus one
-- bit-for-bit identity (Double ==) between the membrane fold and a
-- verbatim replica of the frozen accumulation. New-world tolerances
-- are the E12 conventions: cross-path comparisons 1e-9 relative in the
-- CL-4 shape, closed-form pins 1e-12, price pins 1e-12 absolute.
--
-- Recorded scope limits (visible for the freeze review):
--
-- * EVIDENCE routes through the frozen 'observe' with the explained
--   name's readings supplied by the world ('wEvidence'); declaring and
--   PRICING the explained name inside the namespace is future scope —
--   ruling M5 scopes the priced namespace to Get-mentionable names,
--   and no approved group prices an evidence-name declaration.
-- * A world's namespace is DECLARED for the episode; a dormant sensor
--   (test A) is a declared name whose readings have not yet appeared,
--   so its appearance changes no price mid-episode. Mid-episode
--   namespace growth (M1's re-weighting exercised within one run) is
--   future scope; M1 is pinned here ACROSS worlds (group 6).
-- * Menu order convention: external instantiations in publication
--   order, then the internal acts — a world's tie-break precedence
--   (CL-3 first-listed-wins) is its publication order.
--
-- Fixture provenance: every stream literal below is the output of
-- test-membrane/gen_fixtures.py (seeds inline there), which also runs
-- the pre-freeze sanity simulation proving each discriminator
-- discriminates BOTH ways (the ExpFam group-6 lesson): the
-- self-signature world's MAP is the last_action sentence at posterior
-- 0.947 while the exogenous control's MAP is the t-changepoint at
-- 0.627 mentioning no echo name; the dormant sentence rides at its
-- prior ratio to 1.4e-15 until its sensor speaks, then lands MAP at
-- 0.432 from a 1.3e-4 prior; the grown affordance's EU clears the
-- incumbent by 0.34 the tick it appears.
module Main (main) where

import Data.List (isInfixOf)
import Data.List.NonEmpty (NonEmpty ((:|)))
import System.Exit (ExitCode (..))
import System.Process (readProcessWithExitCode)
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck (Property, choose, counterexample, forAll,
                              testProperty)

import PropLang.Belief (Bits (Bits), LogProb (LogProb), top)
import PropLang.Enumerate (Model, Obs, allTerminals, enumerateModels,
                           enumerateModelsIn, mkAgent, modelBits, observe,
                           renderModel, agentMeta, agentModels)
import PropLang.Membrane (Affordance (..), Choice (..), EchoSpec,
                          InternalAct (..), Pilot (..), PureWorld (..),
                          Slot (..), TickTrace (..), lastActionCode,
                          echoFeatures, mkAffId, mkEchoSpec, noEcho,
                          runMembrane)
import PropLang.Syntax (Expr (..), Grid, Idx (..), KnownScope, Namespace,
                        Util, bits, bitsIn, mkC, mkGrid, mkNamespace,
                        mkUtil)

import Anchors (t1MapProgram, t1MapPosterior, t1ProbeRows, t3AgentDrift,
                t3MapProgram, tolBits, tolProb)
import Streams (drift400, shifted160)

main :: IO ()
main = defaultMain $ testGroup "membrane oracle (Task 1, runtime-red)"
  [ g1Parity, g2Dormant, g3Menu, g4Self, g5Names, g6Fragment
  , g7SlotPrice, g8Rows ]

-- ---------------------------------------------------------------------
-- helpers (tolerance shapes are the frozen E12 conventions)
-- ---------------------------------------------------------------------

ln2 :: Double
ln2 = log 2

lg :: Double -> Double
lg = logBase 2

unBits :: Bits -> Double
unBits (Bits d) = d

assertApprox :: String -> Double -> Double -> Double -> Assertion
assertApprox msg tol expected actual =
  assertBool (msg ++ ": expected " ++ show expected ++ " +- " ++ show tol
                  ++ ", got " ++ show actual)
             (abs (actual - expected) <= tol)

-- the CL-4 relative shape: |lhs - rhs| <= tol * (1 + |rhs|)
assertRel :: String -> Double -> Double -> Double -> Assertion
assertRel msg tol expected actual =
  assertBool (msg ++ ": expected " ++ show expected ++ " (rel " ++ show tol
                  ++ "), got " ++ show actual)
             (abs (actual - expected) <= tol * (1 + abs expected))

traceAt :: [TickTrace] -> Int -> IO TickTrace
traceAt trs t = case [tr | tr <- trs, ttT tr == t] of
  tr : _ -> pure tr
  []     -> assertFailure ("no trace at t=" ++ show t)

runOrFail :: Maybe a -> IO a
runOrFail (Just x) = pure x
runOrFail Nothing  = assertFailure "runMembrane: impossible evidence"

-- MAP program via the frozen route: meta.top -> index -> render
mapOfAgent :: (Model -> String) -> [(Int, Double)] -> [Model] -> IO (String, Double)
mapOfAgent rend ranked ms = case ranked of
  (ix, p) : _ -> pure (rend (ms !! ix), p)
  []          -> assertFailure "agentMeta top returned no entries"

-- posterior mass of one model index, through the public diagnostics
massOf :: [(Int, Double)] -> Int -> IO Double
massOf ranked i = case [p | (ix, p) <- ranked, ix == i] of
  p : _ -> pure p
  []    -> assertFailure ("no mass entry for model index " ++ show i)

sub :: String -> String -> Bool
sub needle hay = needle `isInfixOf` hay

-- ---------------------------------------------------------------------
-- worlds: a pure evidence stream behind the membrane
-- ---------------------------------------------------------------------

-- prediction-only world: publishes the tick, reads the stream its
-- state carries, offers nothing (the frozen worlds' shape; M10)
predWorld :: PureWorld (Int, [Obs])
predWorld = PureWorld
  { wFeats    = \(t, _) -> [("t", fromIntegral t)]
  , wEvidence = \(_, ys) -> case ys of { y : _ -> Just y; [] -> Nothing }
  , wMenu     = const []
  , wStep     = \(t, ys) _ -> (t + 1, drop 1 ys)
  }

-- ---------------------------------------------------------------------
-- group 1: membrane parity (T2/M10 — the load-bearing group)
-- ---------------------------------------------------------------------

-- verbatim replica of the frozen accumulation (test/Acceptance.hs
-- stepAgent/runWorld): observe at [("t", t)], negate lp / ln2, foldl'
handLoss :: [Obs] -> Double
handLoss ys = fst (foldl' step (0, mkAgent (enumerateModels allTerminals))
                          (zip [0 :: Int ..] ys))
  where
    step (acc, ag) (t, y) =
      case observe [("t", fromIntegral t)] y ag of
        Nothing              -> error ("impossible evidence at t=" ++ show t)
        Just (LogProb lp, a) -> (acc + negate lp / ln2, a)

t1Menu :: [Affordance]
t1Menu = [ Affordance (mkAffId 1) "predict1" []
         , Affordance (mkAffId 2) "predict0" []
         , Affordance (mkAffId 3) "consult" [] ]

-- the frozen util1 spoken over the membrane's option space (the whole
-- space, internal acts included — one action space, one valuation)
util1M :: Util Choice Obs
util1M = mkUtil $ \c y -> case c of
  Fire aid _
    | aid == mkAffId 1 -> if y == 1 then 1.0 else -1.0
    | aid == mkAffId 2 -> if y == 0 then 1.0 else -1.0
    | otherwise        -> 0.35
  InternalFired _      -> -2.0

choiceName1 :: Choice -> String
choiceName1 c = case c of
  Fire aid _
    | aid == mkAffId 1 -> "predict1"
    | aid == mkAffId 2 -> "predict0"
    | aid == mkAffId 3 -> "consult"
    | otherwise        -> "?"
  InternalFired Think  -> "think"

g1Parity :: TestTree
g1Parity = testGroup "membrane parity: frozen worlds, frozen anchors"
  [ testCase "t3 drift: membrane fold == frozen fold, bit for bit" $ do
      (_, trs) <- runOrFail (runMembrane predWorld noEcho
                               PilotIdle 400 (0, drift400)
                               (mkAgent (enumerateModels allTerminals)))
      let membLoss = foldl' (+) 0 (map ttLossBits trs)
      assertEqual "cumulative log-loss (bits), exact Double equality"
                  (handLoss drift400) membLoss
  , testCase "t3 drift: membrane loss lands on the frozen anchor" $ do
      (_, trs) <- runOrFail (runMembrane predWorld noEcho
                               PilotIdle 400 (0, drift400)
                               (mkAgent (enumerateModels allTerminals)))
      assertApprox "t3 agent log-loss" tolBits t3AgentDrift
                   (foldl' (+) 0 (map ttLossBits trs))
  , testCase "t3 drift: MAP program == frozen anchor" $ do
      (agF, _) <- runOrFail (runMembrane predWorld noEcho
                               PilotIdle 400 (0, drift400)
                               (mkAgent (enumerateModels allTerminals)))
      (m, _) <- mapOfAgent renderModel
                  (top (agentMeta agF) (length (agentModels agF)))
                  (agentModels agF)
      m @?= t3MapProgram
  , testCase "t1 probes: P(y=1), action, meta-entropy at the frozen rows" $ do
      (_, trs) <- runOrFail (runMembrane predWorld { wMenu = const t1Menu } noEcho
                               (PilotEU util1M) 160 (0, shifted160)
                               (mkAgent (enumerateModels allTerminals)))
      mapM_ (\(t, p1a, act, ha) -> do
               tr <- traceAt trs t
               assertApprox ("P(y=1) at t=" ++ show t) tolProb p1a (ttP1 tr)
               assertApprox ("meta-entropy at t=" ++ show t) tolProb ha
                            (ttEntropy tr)
               choiceName1 (ttChoice tr) @?= act)
            t1ProbeRows
  , testCase "t1 end MAP: program and posterior == frozen anchors" $ do
      (agF, _) <- runOrFail (runMembrane predWorld { wMenu = const t1Menu } noEcho
                               (PilotEU util1M) 160 (0, shifted160)
                               (mkAgent (enumerateModels allTerminals)))
      (m, p) <- mapOfAgent renderModel
                  (top (agentMeta agF) (length (agentModels agF)))
                  (agentModels agF)
      m @?= t1MapProgram
      assertApprox "t1 MAP posterior" tolProb t1MapPosterior p
  ]

-- ---------------------------------------------------------------------
-- group 2: the dormant sensor (interface.md §8 A)
-- ---------------------------------------------------------------------

nsA :: Namespace
nsA = mkNamespace ("t" :| ["s2"])

s2Grid :: Grid
s2Grid = mkGrid "s2c" (0.5 :| [])

modelsA :: [Model]
modelsA = enumerateModelsIn nsA [("s2", s2Grid)] allTerminals

-- s2 exists from tick 40; before that the name is declared but silent
aWorld :: PureWorld Int
aWorld = PureWorld
  { wFeats    = \t -> ("t", fromIntegral t)
                      : [("s2", fromIntegral (s2A !! t)) | t >= 40]
  , wEvidence = \t -> Just (yA !! t)
  , wMenu     = const []
  , wStep     = \t _ -> t + 1
  }

-- index arithmetic of the fragment's enumeration order: 9 constants,
-- 8 walks, 16*72 t-guards, then the s2-guard block; within a guard
-- family, threshold outermost, then (k1, k2) with k2 skipping k1
s2GuardIx :: Int -> Int -> Int
s2GuardIx k1 k2 = 9 + 8 + 16 * 72 + k1 * 8 + (if k2 > k1 then k2 - 1 else k2)

g2Dormant :: TestTree
g2Dormant = testGroup "dormant sensor (A): declared, silent, then heard"
  [ testCase "pre-appearance: the dormant sentence rides at its prior ratio" $ do
      (ag, _) <- runOrFail (runMembrane aWorld noEcho PilotIdle 39 0
                              (mkAgent modelsA))
      let ranked = top (agentMeta ag) (length modelsA)
      mapM_ (\(k1, k2) -> do
               let gIx = s2GuardIx k1 k2
               if length modelsA <= gIx
                 then assertFailure "enumeration lacks the s2-guard block"
                 else do
                   mg <- massOf ranked gIx
                   mt <- massOf ranked k2
                   let dlG = unBits (modelBits (modelsA !! gIx))
                       dlT = unBits (modelBits (modelsA !! k2))
                   assertRel ("posterior ratio, pair " ++ show (k1, k2))
                             1e-9 (2 ** (dlT - dlG)) (mg / mt))
            [(7, 2), (0, 5), (4, 8)]
  , testCase "post-appearance: evidence flows, MAP mentions the sensor" $ do
      (agF, _) <- runOrFail (runMembrane aWorld noEcho PilotIdle 120 0
                               (mkAgent modelsA))
      (m, p) <- mapOfAgent renderModel
                  (top (agentMeta agF) (length modelsA)) modelsA
      assertBool ("MAP mentions ('get', 's2'): " ++ m)
                 (sub "('get', 's2')" m)
      assertBool ("MAP posterior >= 0.2, got " ++ show p) (p >= 0.2)
  , testCase "the winning sentence started below a thousandth of the mass" $ do
      (agF, _) <- runOrFail (runMembrane aWorld noEcho PilotIdle 120 0
                               (mkAgent modelsA))
      let rankedEnd = top (agentMeta agF) (length modelsA)
          ranked0 = top (agentMeta (mkAgent modelsA)) (length modelsA)
      case rankedEnd of
        (ix, _) : _ -> do
          p0 <- massOf ranked0 ix
          assertBool ("prior mass of the eventual MAP <= 1e-3, got "
                      ++ show p0) (p0 <= 1e-3)
        [] -> assertFailure "empty posterior ranking"
  ]

-- ---------------------------------------------------------------------
-- group 3: the growing menu (interface.md §8 B)
-- ---------------------------------------------------------------------

speedGrid :: Grid
speedGrid = mkGrid "speed" (0.2 :| [0.4, 0.6, 0.8])

holdAff, moveAff :: Affordance
holdAff = Affordance (mkAffId 1) "hold" []
moveAff = Affordance (mkAffId 2) "move" [Slot "speed" speedGrid]

-- the affordance "move" is published from tick 10; evidence is twenty
-- ones over the FROZEN fragment (menu growth is not namespace growth —
-- ruling M5)
bWorld :: PureWorld Int
bWorld = PureWorld
  { wFeats    = \t -> [("t", fromIntegral t)]
  , wEvidence = const (Just 1)
  , wMenu     = \t -> if t >= 10 then [holdAff, moveAff] else [holdAff]
  , wStep     = \t _ -> t + 1
  }

utilB :: Double -> Util Choice Obs
utilB holdPay = mkUtil $ \c y -> case c of
  Fire aid slots
    | aid == mkAffId 1 -> holdPay
    | otherwise ->
        let v = case [x | (nm, x) <- slots, nm == "speed"] of
                  x : _ -> x
                  []    -> 0
        in if y == 1 then v else negate v
  InternalFired _ -> -2.0

g3Menu :: TestTree
g3Menu = testGroup "growing menu (B): adopted iff expected utility says so"
  [ testCase "B1: the new affordance is adopted the tick it appears" $ do
      (_, trs) <- runOrFail (runMembrane bWorld noEcho
                               (PilotEU (utilB 0.2)) 20 0
                               (mkAgent (enumerateModels allTerminals)))
      map ttChoice trs @?=
        (replicate 10 (Fire (mkAffId 1) [])
         ++ replicate 10 (Fire (mkAffId 2) [("speed", 0.8)]))
  , testCase "B2: a dominated affordance is never adopted (same call)" $ do
      (_, trs) <- runOrFail (runMembrane bWorld noEcho
                               (PilotEU (utilB 0.9)) 20 0
                               (mkAgent (enumerateModels allTerminals)))
      map ttChoice trs @?= replicate 20 (Fire (mkAffId 1) [])
  , testCase "menu growth is not namespace growth (M5, ruled at the freeze)" $
      -- the freeze-review consistency requirement: this increment
      -- defers mid-episode NAMESPACE growth, so B's mid-episode MENU
      -- growth is legitimate only because it adds action vocabulary
      -- (slot-priced) and never a Get-mentionable name — asserted in
      -- construction: the published feature-name set is the declared
      -- singleton at every tick, growth tick included
      assertBool "published feature names == [\"t\"] at every tick"
        (all (\t -> map fst (wFeats bWorld t) == ["t"]) [0 .. 19])
  ]

-- ---------------------------------------------------------------------
-- group 4: the self-signature (interface.md §8 C), WITH the required
-- competitor (Task 0 ruling): the same hypothesis space must hand the
-- exogenous control world to the changepoint story
-- ---------------------------------------------------------------------

nsC :: Namespace
nsC = mkNamespace ("t" :| ["z", "last_action"])

zGrid, laGrid :: Grid
zGrid = mkGrid "zc" (0.25 :| [0.5, 0.75])
laGrid = mkGrid "lac" (0.5 :| [1.5])

modelsC :: [Model]
modelsC = enumerateModelsIn nsC [("z", zGrid), ("last_action", laGrid)]
                            allTerminals

cMenu :: [Affordance]
cMenu = [Affordance (mkAffId 1) "a1" [], Affordance (mkAffId 2) "a2" []]

-- the scripted explorer: fire a2 when z > 0.5 else a1 (the test's
-- claim is the posterior's, not the policy's)
cPilot :: Pilot
cPilot = PilotThreshold "z" 0.5 (Fire (mkAffId 2) []) (Fire (mkAffId 1) [])

cWorld :: [Obs] -> PureWorld Int
cWorld ys = PureWorld
  { wFeats    = \t -> [("t", fromIntegral t), ("z", zC !! t)]
  , wEvidence = \t -> Just (ys !! t)
  , wMenu     = const cMenu
  , wStep     = \t _ -> t + 1
  }

cEcho :: EchoSpec
cEcho = mkEchoSpec True False False

g4Self :: TestTree
g4Self = testGroup "self-signature (C): the echo wins only when it should"
  [ testCase "C: MAP mentions ('get', 'last_action'), decisively" $ do
      (agF, _) <- runOrFail (runMembrane (cWorld yC) cEcho cPilot 160 0
                               (mkAgent modelsC))
      (m, p) <- mapOfAgent renderModel
                  (top (agentMeta agF) (length modelsC)) modelsC
      assertBool ("MAP mentions ('get', 'last_action'): " ++ m)
                 (sub "('get', 'last_action')" m)
      assertBool ("MAP posterior > 0.5, got " ++ show p) (p > 0.5)
  , testCase "C0 control: the exogenous story wins, BY STRUCTURE" $ do
      (agF, _) <- runOrFail (runMembrane (cWorld shifted160) cEcho cPilot
                               160 0 (mkAgent modelsC))
      (m, _) <- mapOfAgent renderModel
                  (top (agentMeta agF) (length modelsC)) modelsC
      -- freeze-review ruling (the ExpFam group-6 standard): the
      -- competitor's win is pinned by structure, not by negation — the
      -- control MAP must BE the changepoint program, and the sanity
      -- simulation says it is byte-identical to the frozen t1 anchor
      -- (tau index 11 = 60.0; thetas 0 and 8)
      m @?= t1MapProgram
      assertBool ("control MAP must not mention last_action: " ++ m)
                 (not (sub "('get', 'last_action')" m))
  ]

-- ---------------------------------------------------------------------
-- group 5: CL-6 and the namespace pricer (T1/M1 at the policy sort)
-- ---------------------------------------------------------------------

ns0 :: Namespace
ns0 = mkNamespace ("t" :| [])

eqPriced :: KnownScope env => Expr env t -> Bool
eqPriced e = unBits (bits e) == unBits (bitsIn ns0 e)

propNsPrice :: Property
propNsPrice =
  forAll (choose (2, 12 :: Int)) $ \k ->
    let ns = mkNamespace ("t" :| ["n" ++ show i | i <- [2 .. k]])
        got = unBits (bitsIn ns (Get "t" :: Expr '[] Double))
        want = lg 19 + lg (fromIntegral k)
    in counterexample ("k=" ++ show k ++ " got " ++ show got)
         (abs (got - want) <= 1e-12)

g5Names :: TestTree
g5Names = testGroup "one namespace: echo names ordinary, prices per world"
  [ testCase "a 3-name world prices Get at lg 19 + lg 3" $
      assertApprox "bitsIn nsC (Get last_action)" 1e-12 (lg 19 + lg 3)
        (unBits (bitsIn nsC (Get "last_action" :: Expr '[] Double)))
  , testCase "a 2-name world prices Get at lg 19 + 1" $
      assertApprox "bitsIn nsA (Get s2)" 1e-12 (lg 19 + 1)
        (unBits (bitsIn nsA (Get "s2" :: Expr '[] Double)))
  , testProperty "k published names charge lg k at every mention" propNsPrice
  , testCase "the frozen registry is the singleton special case (==)" $ do
      assertBool "Get" (eqPriced (Get "t" :: Expr '[] Double))
      assertBool "Gt" (eqPriced (Gt (Get "t") (Get "t") :: Expr '[] Bool))
      assertBool "If"
        (eqPriced (If (Gt (Get "t") (Get "t")) (Get "t") (Get "t")
                     :: Expr '[] Double))
      assertBool "Argmax"
        (eqPriced (Argmax (Var Z) (Get "t")
                     :: Expr '[NonEmpty Double] Double))
  , testCase "echoFeatures speaks the trio, in order, or nothing" $ do
      echoFeatures (mkEchoSpec True True True) 7 2
                   (Just (InternalFired Think))
        @?= [ ("last_action", -1.0), ("tick", 7.0)
            , ("ticks_spent_thinking", 2.0) ]
      echoFeatures noEcho 7 2 (Just (InternalFired Think)) @?= []
  , testCase "lastActionCode: 0 before any action; stable ids after" $ do
      lastActionCode Nothing @?= 0.0
      lastActionCode (Just (Fire (mkAffId 3) [])) @?= 3.0
      lastActionCode (Just (InternalFired Think)) @?= -1.0
  ]

-- ---------------------------------------------------------------------
-- group 6: the model fragment under a namespace (T1/M1 at the model
-- sort — derivation-charged, so pinned through modelBits)
-- ---------------------------------------------------------------------

g6Fragment :: TestTree
g6Fragment = testGroup "model fragment: namespace-relative derivation charges"
  [ testCase "the frozen fragment is enumerateModelsIn ns0 [] (renders, dls, order)" $ do
      let new = enumerateModelsIn ns0 [] allTerminals
          old = enumerateModels allTerminals
      length new @?= length old
      mapM_ (\(n, o) -> do
               renderModel n @?= renderModel o
               assertEqual ("dl of " ++ renderModel o)
                           (unBits (modelBits o)) (unBits (modelBits n)))
            (zip new old)
  , testCase "declared guards extend the enumeration: 1241 and 1529" $ do
      length modelsA @?= 1241
      length modelsC @?= 1529
  , testCase "guard sentences pay their namespace and their threshold grid" $ do
      -- pin provenance (the membrane pre-tag re-open): these literals
      -- are the frozen tree of dlChange, src/PropLang/Enumerate.hs —
      -- model bit + (if bit + ((Get bit + lg |ns|) + mention grid)) +
      -- two theta mentions — verified against the artifact at fd70162
      -- (modelBits of the first frozen t-guard = 16.339850002884624);
      -- a pin is derived from the frozen artifact, never from a
      -- parallel derivation
      if length modelsA <= s2GuardIx 0 1
        then assertFailure "enumeration lacks the s2-guard block"
        else assertApprox "s2-guard dl under a 2-name world" 1e-12
               (1 + (1 + ((1 + 1) + (1 + 0))) + (1 + lg 9) + (1 + lg 9))
               (unBits (modelBits (modelsA !! s2GuardIx 0 1)))
      let laBase = 9 + 8 + 16 * 72 + 3 * 72
      if length modelsC <= laBase
        then assertFailure "enumeration lacks the last_action-guard block"
        else assertApprox "la-guard dl under a 3-name world" 1e-12
               (1 + (1 + ((1 + lg 3) + (1 + 1))) + (1 + lg 9) + (1 + lg 9))
               (unBits (modelBits (modelsC !! laBase)))
  , testCase "M1: publishing a name re-prices every mention (across worlds)" $ do
      let tGuardA = unBits (modelBits (modelsA !! 17))
          tGuardC = unBits (modelBits (modelsC !! 17))
          tGuard0 = unBits (modelBits
                              (enumerateModels allTerminals !! 17))
      assertApprox "3-name vs 2-name t-guard" 1e-12 (lg 3 - lg 2)
                   (tGuardC - tGuardA)
      assertApprox "2-name vs frozen t-guard" 1e-12 1
                   (tGuardA - tGuard0)
  ]

-- ---------------------------------------------------------------------
-- group 7: slot instantiation is grid-constant utterance (ruling M4)
-- ---------------------------------------------------------------------

g7SlotPrice :: TestTree
g7SlotPrice = testGroup "slot pricing: the charge sits at the C node"
  [ testCase "naming a slot point costs the node plus the slot's grid" $
      case mkC speedGrid 3 of
        Nothing -> assertFailure "mkC refused an on-grid index"
        Just c  -> assertApprox "bits of a speed constant" 1e-12
                     (lg 19 + lg 4) (unBits (bits (c :: Expr '[] Double)))
  , testCase "a finer slot grid charges exactly its extra bit" $ do
      let fine = mkGrid "speed8" (0.1 :| [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8])
      case (mkC speedGrid 0, mkC fine 0) of
        (Just c4, Just c8) ->
          assertApprox "lg 8 - lg 4" 1e-12 1
            (unBits (bits (c8 :: Expr '[] Double))
             - unBits (bits (c4 :: Expr '[] Double)))
        _ -> assertFailure "mkC refused an on-grid index"
  ]

-- ---------------------------------------------------------------------
-- group 8: deletion rows and the grep clauses (Q4/M6/M7)
-- ---------------------------------------------------------------------

shellRow :: String -> [String] -> Assertion
shellRow cmd args = do
  (code, out, err) <- readProcessWithExitCode cmd args ""
  case code of
    ExitSuccess   -> pure ()
    ExitFailure _ -> assertFailure (cmd ++ " " ++ unwords args
                                    ++ ":\n" ++ out ++ err)

srcFiles :: [String]
srcFiles = map ("src/PropLang/" ++)
  ["Belief.hs", "Syntax.hs", "Eval.hs", "Enumerate.hs", "Host.hs",
   "Membrane.hs"]

g8Rows :: TestTree
g8Rows = testGroup "deletion rows and grep clauses"
  [ testCase "slot grids delete: affordances unutterable" $
      shellRow "sh" ["test-membrane/ablation.sh", "slot-grid"]
  , testCase "affordance publication deletes: external menu unutterable" $
      shellRow "sh" ["test-membrane/ablation.sh", "affordance"]
  , testCase "echo deletes: the self unutterable" $
      shellRow "sh" ["test-membrane/ablation.sh", "echo"]
  , testCase "no subscription machinery anywhere in src (S8 A grep)" $
      shellRow "python3" (["audit/strip_comments.py", "--forbidden",
                           "test-membrane/no-subscription.txt"] ++ srcFiles)
  , testCase "the membrane is pure: no IO token (gate-3 mirror)" $
      shellRow "python3" ["audit/strip_comments.py", "--word", "IO",
                          "src/PropLang/Membrane.hs"]
  , testCase "no forbidden tokens in the new module (gate-4 mirror)" $
      -- gate 4's frozen scan names five files, so a new src module
      -- would escape the frozen semantic list entirely; this row
      -- closes that hole with the SAME frozen list, read-only
      shellRow "python3" ["audit/strip_comments.py", "--forbidden",
                          "audit/forbidden.txt",
                          "src/PropLang/Membrane.hs"]
  ]

-- ---------------------------------------------------------------------
-- fixtures (generated + sanity-simulated by test-membrane/gen_fixtures.py)
-- ---------------------------------------------------------------------

-- world A sensor readings, valid from tick 40 (rng seed 101)
s2A :: [Int]
s2A =
  [ 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0
  , 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0
  , 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1
  , 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0
  , 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1
  , 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1
  ]

-- world A explained readings: fair coin to tick 39, then 0.85/0.15 on
-- s2 (rng seed 101, same stream as s2A)
yA :: [Obs]
yA =
  [ 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1
  , 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0
  , 1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1
  , 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1
  , 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0
  , 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1
  ]

-- world C context stream (rng seed 202): aperiodic, so no
-- current-tick sentence can proxy the lag the echo carries
zC :: [Double]
zC =
  [ 0.7638815744633954, 0.6447807510863064, 0.40943808013995275, 0.19808744040113768, 0.6767003342360466
  , 0.9692858163726752, 0.42774708898859193, 0.8508748594767727, 0.036078303300847936, 0.5277860412448065
  , 0.20155321238517532, 0.4942660229634893, 0.6112527232963626, 0.8559082496370558, 0.5229658349769678
  , 0.8688389390876086, 0.32677934673499076, 0.12840989549245074, 0.464946990798343, 0.7152468996358645
  , 0.7079444055031988, 0.03674529136974525, 0.24857148343947266, 0.25434474234978877, 0.47157968486789925
  , 0.8617020435058247, 0.27090929424730037, 0.04588509298910648, 0.898044162818999, 0.8692000927533886
  , 0.7706996582437882, 0.03868779823161672, 0.26071076848820574, 0.17679425487660894, 0.9149845853572381
  , 0.1247762691814659, 0.12749534009772823, 0.22064485914448861, 0.7909890387518833, 0.19802256998212397
  , 0.9833758044078205, 0.30815505903287455, 0.6500811602972846, 0.1918766967857739, 0.29205572110731104
  , 0.8654062707721905, 0.9975602236830079, 0.24234912525910135, 0.3494958562329116, 0.05738465199820186
  , 0.19459585690947445, 0.38396148675330977, 0.5211296287363507, 0.5728266339465008, 0.3494505167705202
  , 0.1580478194401167, 0.5557031473401765, 0.34891657446743507, 0.34511962615759206, 0.9732087418298719
  , 0.5872592428652408, 0.015131720013235594, 0.9570810173892395, 0.9697011150746265, 0.3899178249402995
  , 0.9796379455859785, 0.10503597027001488, 0.9186653549784145, 0.16886817106488827, 0.8640299707248008
  , 0.677393015469918, 0.958336820535021, 0.30228094004558437, 0.6539282549257739, 0.9405720076563844
  , 0.1288487580388612, 0.18510410684438972, 0.5570599695054576, 0.1336947339751663, 0.05453928468702074
  , 0.015523122041815163, 0.34696045313653123, 0.6499602306210984, 0.4658578540938607, 0.6041332716945342
  , 0.026368748395587893, 0.10124766221453585, 0.5654261544724538, 0.15680423108532615, 0.012824944273280403
  , 0.06161851290700826, 0.6518827219485058, 0.9599300852975065, 0.4963045372344488, 0.006289238982428391
  , 0.1947794521035049, 0.6812923526386081, 0.7926520562656519, 0.20604181596784943, 0.46748791606580087
  , 0.03630839980614653, 0.5402450431444167, 0.756077508833009, 0.49959407928270205, 0.7852773044289958
  , 0.23424898721227194, 0.6660319564191836, 0.47071635679190515, 0.6035913241862448, 0.07281748372873065
  , 0.4538937693071986, 0.6200193225537551, 0.23417215110972356, 0.5539355889533747, 0.01966969700413501
  , 0.4179602560886627, 0.9412028197949556, 0.6470504724458113, 0.5061461450725504, 0.8710807411457973
  , 0.6935892521969669, 0.5089022416018498, 0.37519097252023725, 0.8737532376735282, 0.5643281702155495
  , 0.48755638256953904, 0.37140463524028267, 0.1527719143761158, 0.19047370627583904, 0.6025314595643306
  , 0.5373125801595716, 0.7745694336404262, 0.44911066812217937, 0.38450791343289026, 0.5553143405841365
  , 0.25128770486599317, 0.9615743551078895, 0.6352708035606135, 0.30073836938485243, 0.49164698681513486
  , 0.8407722422486795, 0.9508945317116384, 0.699882909462003, 0.8773974424492639, 0.8066516311507484
  , 0.36733907167219004, 0.41782103194430553, 0.46509605756754535, 0.052063353108449784, 0.5914715882861393
  , 0.5522742956937672, 0.7870882486811381, 0.33989034102585525, 0.9772133248871614, 0.7387381242549643
  , 0.5788591594627351, 0.22760920288056674, 0.9339733226024151, 0.6834608410061699, 0.633945255772792
  ]

-- world C explained readings (rng seed 202): 0.9 when the previous
-- tick's action was affordance 2, else 0.1
yC :: [Obs]
yC =
  [ 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1
  , 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1
  , 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0
  , 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0
  , 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0
  , 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1
  , 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0
  , 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0
  ]
