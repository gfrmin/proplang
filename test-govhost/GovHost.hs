{-# LANGUAGE DataKinds #-}

-- | The governor-host oracle (HOSTS_PLAN boundary H; the roadmap's
-- re-opening, c65a386) — written in the oracle phase, runtime-red
-- against the host-governor/ type-surface stubs, to be FROZEN at H's
-- author signing.
--
-- Groups, in order (HOSTS_PLAN 2.9):
--
-- * g0 — THE TWO MANDATORY OPENING FIXTURES (WRITEUP.md post-close
--   review: "Any future increment under P5's route opens its oracle
--   with these as its first fixtures"): the interior-menu max above
--   the singleton, and vPreAt recursion above depth 1. Hand-derived
--   pins (provenance: the frozen Eval.hs definitions, arithmetic
--   shown below — never a parallel simulation). GREEN from day zero.
-- * gP5 — identity pins for the freeze's single-site production-table
--   constant (HOSTS_PLAN 0.3): one pin per sort constant, green now,
--   MUST stay green through the re-base — the empty-census witness.
-- * g1 — wire codec goldens (byte fixtures). RED: unimplemented.
-- * g2 — pure step semantics over the frozen loop. RED: unimplemented.
-- * g3 — namespace-price pins at the governor world (nsB = lg 40,
--   count == 3977) + the restricted-enumeration ablation row. GREEN.
-- * g4 — analytic cross-checks: conjugate closed forms demoted to
--   TEST ORACLES (grid Bayes identity at 1e-12; a SOUND oscillation
--   quadrature bound as a property; one documented margin). GREEN.
-- * g5 — process smoke against the proplang-govhost binary
--   (GOVHOST_EXE, or PATH via the future build-tool-depends). RED.
--
-- Red/green enumerated for the pack: RED (3 groups, all by RUNTIME
-- failure under the stanza's exact flags — the red is the missing
-- implementation, proven by compiling): g1, g2, g5. GREEN from day
-- zero (4 groups): g0, gP5, g3, g4 — they exercise frozen surfaces
-- only and hold the worlds against drift through the increment.
--
-- Numeric literals below are world data of the oracle's fixtures
-- (test code; the no-steering-literals rule binds src/).
-- Test names are ASCII-only (canonized).
module Main (main) where

import Data.List (isInfixOf)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv)
import System.Exit (ExitCode (..))
import System.Process (readProcessWithExitCode)
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck

import PropLang.Belief
import PropLang.Enumerate (Agent, Model, Obs, Terminal (..), agentMeta,
                           allTerminals, enumerateModelsIn, mkAgent,
                           modelBits, observe, obsCarrier, obsSpace,
                           predictive, thetaSpace)
import PropLang.Eval (Vals (..), evalx, mkEnv, vPre)
import PropLang.Membrane (Affordance (..), Choice (..), InternalAct (..),
                          argmaxEU, menuOptions, mkAffId, affIdCode)
import PropLang.Syntax

import Wire

main :: IO ()
main = defaultMain $ testGroup "proplang govhost (boundary H oracle)"
  [ g0Mandatory
  , gP5Table
  , g1Codec
  , g2Step
  , g3Namespace
  , g4Analytic
  , g5Process
  ]

-- ---------------------------------------------------------------------
-- shared helpers (the cirl idiom)
-- ---------------------------------------------------------------------

assertApprox :: String -> Double -> Double -> Double -> Assertion
assertApprox msg tol expected actual =
  assertBool (msg ++ ": expected " ++ show expected ++ " +- " ++ show tol
                  ++ ", got " ++ show actual)
             (abs (actual - expected) <= tol)

lg :: Double -> Double
lg = logBase 2

-- ---------------------------------------------------------------------
-- g0 — the two mandatory opening fixtures
--
-- THE WORLD (fixture data): latent h over {0, 1} (uniform); outcomes
-- y in {0, 1}, n = 1; terminal menu {0.0, 1.0} with the match utility
-- u(a, h) = 1 iff (a > 1/2) == (h > 1/2) else 0; interior menu
-- {GProbe, GWait} with per-decision channels — GProbe's channel is
-- the identity (y = h, a point-mass kernel), GWait's is the constant
-- (y = 0 regardless); interior utility uD(GProbe, h) = +0.2 if
-- h > 1/2 else -0.3 (probing is itself risky), uD(GWait, .) = 0;
-- tick price 0.05.
--
-- HAND DERIVATION (from Eval.hs vPreAt, verbatim semantics: est 0 =
-- vAct; est j = max over interior dd of [ E[uD(dd)] + sum over
-- length-n outcome sequences of P(seq | belief through dd's OWN
-- channel) * est (j-1) (belief | seq) ] - price, the price OUTSIDE
-- the max; walk folds logPredict before cond, impossible branch
-- weight 0):
--
--   est0(uniform) = max(E u(0), E u(1)) = max(1/2, 1/2)     = 1/2
--   est0(point_h) = 1
--
--   depth 1 at uniform:
--     GProbe: E[uD] = (1/2)(-0.3) + (1/2)(0.2) = -0.05;
--       y=0 w.p. 1/2 -> point_0, est0 = 1; y=1 w.p. 1/2 -> point_1,
--       est0 = 1; continuation = 1.  branch = -0.05 + 1 = 0.95
--     GWait:  E[uD] = 0; y=0 w.p. 1 -> belief unchanged, est0 = 1/2;
--       y=1 impossible (weight 0).   branch = 0 + 0.5  = 0.50
--     est1(uniform) = max(0.95, 0.50) - 0.05 = 0.90            [PIN]
--     singleton faces: probe-only 0.95 - 0.05 = 0.90;
--                      wait-only  0.50 - 0.05 = 0.45           [PINS]
--
--   depth 2 at uniform (the recursion above depth 1):
--     est1(point_1): GProbe 0.2 + 1 = 1.2; GWait 0 + 1 = 1.0;
--       max 1.2 - 0.05 = 1.15
--     est1(point_0): GProbe -0.3 + 1 = 0.7; GWait 0 + 1 = 1.0;
--       max 1.0 - 0.05 = 0.95
--       (the interior CHOICE differs by belief: probe wins at
--        point_1, wait wins at point_0 — action-dependence doing
--        real work inside the recursion)
--     est2(uniform):
--       GProbe: -0.05 + (1/2)(0.95) + (1/2)(1.15) = -0.05 + 1.05
--             = 1.00
--       GWait:  0 + est1(uniform) = 0.90
--       est2 = max(1.00, 0.90) - 0.05 = 0.95                   [PIN]
--
-- Pins at 1e-12 (C10's standard for value pins over frozen-verb
-- compositions; the fixture's decimals are not binary-exact).
-- ---------------------------------------------------------------------

data GD = GProbe | GWait
  deriving (Eq, Show)

g0H :: Space Double
g0H = mkSpace (0.0 :| [1.0])

g0Y :: Space Obs
g0Y = mkSpace (0 :| [1])

g0B :: Belief Double
g0B = uniform g0H

g0IdK, g0ConstK :: Kernel Double Obs
g0IdK    = kernel g0H g0Y (\h -> point g0Y (if h > 0.5 then 1 else 0))
g0ConstK = kernel g0H g0Y (\_ -> point g0Y 0)

g0Chan :: Chan GD Double Obs
g0Chan = mkChan (\d -> case d of GProbe -> g0IdK; GWait -> g0ConstK)

g0UD :: Util GD Double
g0UD = mkUtil $ \d h -> case d of
  GProbe -> if h > 0.5 then 0.2 else -0.3
  GWait  -> 0

g0U :: Util Double Double
g0U = mkUtil $ \a h -> if (a > 0.5) == (h > 0.5) then 1 else 0

g0Acts :: NonEmpty Double
g0Acts = 0.0 :| [1.0]

g0Val :: Int -> NonEmpty GD -> Double
g0Val d menu = vPre d g0B g0Chan ([0, 1] :: [Obs]) g0UD menu g0U g0Acts 1 0.05

g0Mandatory :: TestTree
g0Mandatory = testGroup "g0 mandatory opening fixtures (post-close review)"
  [ testCase "interior-menu max above the singleton: pair menu = 0.90" $
      assertApprox "vPre depth 1, menu {probe, wait}" 1e-12 0.90
        (g0Val 1 (GProbe :| [GWait]))
  , testCase "singleton faces: probe-only 0.90, wait-only 0.45" $ do
      assertApprox "probe-only" 1e-12 0.90 (g0Val 1 (GProbe :| []))
      assertApprox "wait-only"  1e-12 0.45 (g0Val 1 (GWait :| []))
  , testCase "the pair equals the max of its singleton faces (exact)" $
      assertEqual "max exercised, not defaulted"
        (max (g0Val 1 (GProbe :| [])) (g0Val 1 (GWait :| [])))
        (g0Val 1 (GProbe :| [GWait]))
  , testCase "order flip: the fold scans past the first-listed loser" $
      assertEqual "menu {wait, probe} = menu {probe, wait}"
        (g0Val 1 (GProbe :| [GWait]))
        (g0Val 1 (GWait :| [GProbe]))
  , testCase "recursion above depth 1: hand-derived W2 = 0.95" $
      assertApprox "vPre depth 2, menu {probe, wait}" 1e-12 0.95
        (g0Val 2 (GProbe :| [GWait]))
  , testCase "depth 2 is not depth 1 (the recursion does work)" $
      assertBool "W2 - W1 = 0.05 by hand"
        (abs (g0Val 2 (GProbe :| [GWait]) - g0Val 1 (GProbe :| [GWait]) - 0.05)
          <= 1e-12)
  ]

-- ---------------------------------------------------------------------
-- gP5 — identity pins for the single-site constant re-base
--
-- H's only src edit exports the production table as one value and
-- re-bases bitsAt's five literals onto it (HOSTS_PLAN 0.3). These
-- pins are green NOW against the as-frozen constants and must stay
-- green through the freeze: bits moves nowhere — the empty-census
-- witness, one pin per sort constant.
-- ---------------------------------------------------------------------

gP5Grid4 :: Grid
gP5Grid4 = mkGrid "g4" (1 :| [2, 3, 4])

gP5Table :: TestTree
gP5Table = testGroup "gP5 single-site constant identity pins"
  [ testCase "EXPR node cost: Get prices at lg 19 (singleton namespace)" $
      let Bits v = bits (Get "t" :: Expr '[] Double)
      in assertApprox "nodeB" 1e-12 (lg 19) v
  , testCase "EXPR + grid mention: mkC sentence prices at lg 19 + lg 4" $
      case mkC gP5Grid4 0 of
        Nothing -> assertFailure "mkC: index 0 off a 4-point grid"
        Just e  -> let Bits v = bits (e :: Expr '[] Double)
                   in assertApprox "nodeB + grid" 1e-12 (lg 19 + lg 4) v
  , testCase "STDNAME choice: Call IsEq prices at lg 19 + lg 7 + args" $
      let Bits v = bits (Call IsEq (Get "t" :* Get "t" :* ANil)
                           :: Expr '[] Bool)
      in assertApprox "nodeB + stdB + 2 Gets" 1e-12
           (lg 19 + lg 7 + 2 * lg 19) v
  , testCase "FN choice: Expect/FnInd prices at 2 lg 19 + 1" $
      let ev = event obsSpace (> 0)
          Bits v = bits (Expect (Var Z) (FnInd ev)
                           :: Expr '[B Obs] Double)
      in assertApprox "nodeB + Var(scope 1) + fnB" 1e-12
           (2 * lg 19 + 1) v
  , testCase "KER + STATS + carrier registry: ExpFam node prices at lg 2 (Code joined KER at the step-1 freeze)" $
      let Bits v = bits (ExpFam thetaSpace obsCarrier SId
                           :: Expr '[] (Kernel Double Obs))
      in assertApprox "kerB + carrierB + statsB" 1e-12 (lg 2) v
  , testCase "UTIL sort: USay (Var Z) prices at 0 + payload (lg 19 + 1)" $
      let Bits v = bits (USay (Var Z) :: Expr '[] (Util Double Double))
      in assertApprox "utilB + scope-2 Var" 1e-12 (lg 19 + 1) v
  ]

-- ---------------------------------------------------------------------
-- g1 — wire codec goldens (RED: Wire is a type-surface stub)
-- ---------------------------------------------------------------------

-- the small world used across g1/g2/g5 (world data of this oracle)
smallDecl :: WorldDecl
smallDecl = WorldDecl
  { wdNamespace = ["t", "x"]
  , wdGuards    = [GuardDecl "x" [0.5]]
  , wdMenu      = [ MenuItem 3 "ask" []
                  , MenuItem 2 "block" []
                  , MenuItem 1 "proceed" [] ]
  , wdUtility   = [ UtilRow (Right 3) (-0.02, -0.02)
                  , UtilRow (Right 2) (0, -0.5)
                  , UtilRow (Right 1) (-0.5, 0)
                  , UtilRow (Left ()) (-3, -3) ]
  , wdEcho      = (False, False, False)
  }

handshakeLine :: String
handshakeLine =
  "{\"membrane\":1,\"world\":{\"namespace\":[\"t\",\"x\"],\
  \\"guards\":[{\"name\":\"x\",\"grid\":[0.5]}],\
  \\"menu\":[{\"id\":3,\"name\":\"ask\",\"slots\":[]},\
  \{\"id\":2,\"name\":\"block\",\"slots\":[]},\
  \{\"id\":1,\"name\":\"proceed\",\"slots\":[]}],\
  \\"utility\":{\"form\":\"table@1\",\"rows\":[\
  \{\"fire\":3,\"u\":[-0.02,-0.02]},\
  \{\"fire\":2,\"u\":[0,-0.5]},\
  \{\"fire\":1,\"u\":[-0.5,0]},\
  \{\"internal\":\"think\",\"u\":[-3,-3]}]},\
  \\"echo\":{\"last_action\":false,\"tick\":false,\
  \\"ticks_spent_thinking\":false}}}"

decisionLine :: String
decisionLine = "{\"tick\":{\"features\":{\"t\":1,\"x\":1},\"menu\":[3,2,1]}}"

evidenceLine :: String
evidenceLine = "{\"tick\":{\"features\":{\"t\":1,\"x\":1},\"evidence\":1}}"

smallFeats :: [(Name, Double)]
smallFeats = [("t", 1), ("x", 1)]

genJson :: Int -> Gen Json
genJson 0 = oneof
  [ JBool <$> arbitrary
  , JNum <$> elements [0, 1, -2, 0.5, 5.5, 3977]
  , JStr <$> elements ["", "a", "tool-name=bash", "line\nbreak",
                       "q\"q", "b\\b"]
  ]
genJson d = oneof
  [ genJson 0
  , JArr <$> resize 3 (listOf (genJson (d - 1)))
  , do ks <- sublistOf ["a", "b", "c"]
       vs <- mapM (const (genJson (d - 1))) ks
       pure (JObj (zip ks vs))
  ]

g1Codec :: TestTree
g1Codec = testGroup "g1 wire codec goldens"
  [ testCase "render: canonical object, integral numbers undotted" $
      assertEqual "golden" "{\"ok\":true,\"proto\":1,\"models\":3977,\"namespace_bits\":5.5}"
        (renderJson (JObj [ ("ok", JBool True), ("proto", JNum 1)
                          , ("models", JNum 3977)
                          , ("namespace_bits", JNum 5.5) ]))
  , testCase "render: string escapes (quote, backslash, newline)" $
      assertEqual "golden" "\"q\\\"q\\\\n\\n\""
        (renderJson (JStr "q\"q\\n\n"))
  , testCase "parse: whitespace tolerated between tokens" $
      assertEqual "golden"
        (Right (JObj [("a", JArr [JNum 1, JBool True])]))
        (parseJson "{ \"a\" : [ 1 , true ] }")
  , testCase "parse handshake golden -> the small world declaration" $
      assertEqual "golden" (Right (MHandshake smallDecl))
        (parseLine handshakeLine)
  , testCase "parse decision tick golden" $
      assertEqual "golden"
        (Right (MTick (TickMsg smallFeats Nothing (Just [3, 2, 1]) Nothing)))
        (parseLine decisionLine)
  , testCase "parse evidence tick golden" $
      assertEqual "golden"
        (Right (MTick (TickMsg smallFeats (Just 1) Nothing Nothing)))
        (parseLine evidenceLine)
  , testCase "unknown keys are ignored, never an error" $
      assertEqual "golden"
        (Right (MTick (TickMsg [("t", 1)] (Just 0) Nothing Nothing)))
        (parseLine "{\"tick\":{\"features\":{\"t\":1},\"evidence\":0,\"frobnicate\":9}}")
  , testCase "render replies: handshake, decision, evidence, combined, silent, error" $ do
      assertEqual "handshake"
        "{\"ok\":true,\"proto\":1,\"models\":3977,\"namespace_bits\":5.5}"
        (renderReply (RHandshake 3977 5.5))
      assertEqual "decision"
        "{\"choice\":{\"fire\":1,\"slots\":{}},\"p1\":0.75,\"entropy_bits\":3.25}"
        (renderReply (RTick (Just (Fire (mkAffId 1) [], 0.75, 3.25)) Nothing))
      assertEqual "evidence"
        "{\"observed\":1,\"loss_bits\":0.5}"
        (renderReply (RTick Nothing (Just (1, 0.5))))
      assertEqual "combined (internal choice)"
        "{\"choice\":{\"internal\":\"think\"},\"p1\":0.75,\"entropy_bits\":3.25,\"observed\":0,\"loss_bits\":2}"
        (renderReply (RTick (Just (InternalFired Think, 0.75, 3.25))
                            (Just (0, 2))))
      assertEqual "silent tick" "{\"ok\":true}"
        (renderReply (RTick Nothing Nothing))
      assertEqual "error" "{\"error\":\"impossible-evidence\"}"
        (renderReply (RError "impossible-evidence"))
  , testProperty "parse . render = Right (the subset round-trips)" $
      forAll (genJson 2) $ \j -> parseJson (renderJson j) === Right j
  ]

-- ---------------------------------------------------------------------
-- g2 — pure step semantics (RED: buildWorld/step are stubs)
-- ---------------------------------------------------------------------

withWorld :: WorldDecl -> ((World, Agent, Reply) -> Assertion) -> Assertion
withWorld d k = either (assertFailure . ("buildWorld: " ++)) k (buildWorld d)

-- the test-side fold of the small world's utility table (the frozen
-- composition g2's choice pins go through)
smallUtil :: Util Choice Obs
smallUtil = mkUtil $ \c y -> case c of
  Fire aid _
    | affIdCode aid == 3 -> -0.02
    | affIdCode aid == 2 -> if y == 1 then -0.5 else 0
    | affIdCode aid == 1 -> if y == 1 then 0 else -0.5
    | otherwise          -> -1 / 0
  InternalFired Think -> -3

smallAffs :: [Affordance]
smallAffs = [ Affordance (mkAffId 3) "ask" []
            , Affordance (mkAffId 2) "block" []
            , Affordance (mkAffId 1) "proceed" [] ]

-- the frozen-verb composition a decision tick must equal (the same
-- selection the membrane's PilotEU line performs)
expectedChoice :: Agent -> [(Name, Double)] -> [Affordance]
               -> Util Choice Obs -> Choice
expectedChoice ag feats affs u =
  evalx argmaxEU
    (mkEnv feats (menuOptions affs :. predictive feats ag :. u :. VNil))

decTick :: TickMsg
decTick = TickMsg smallFeats Nothing (Just [3, 2, 1]) Nothing

evTick :: TickMsg
evTick = TickMsg smallFeats (Just 1) Nothing Nothing

g2Step :: TestTree
g2Step = testGroup "g2 pure step semantics (the frozen loop at n = 1)"
  [ testCase "handshake reply: 1241 models, namespace_bits = lg 2 = 1" $
      withWorld smallDecl $ \(_, _, r) ->
        case r of
          RHandshake n nsb -> do
            assertEqual "models (9 + 8 + 16*72 + 1*72)" 1241 n
            assertApprox "namespace bits" 1e-12 1 nsb
          _ -> assertFailure ("expected RHandshake, got " ++ show r)
  , testCase "decision tick: choice, p1, entropy from the frozen verbs" $
      withWorld smallDecl $ \(w, ag0, _) ->
        case step w ag0 decTick of
          (_, RTick (Just (c, p, h)) Nothing) -> do
            assertEqual "choice = the argmaxEU program's"
              (expectedChoice ag0 smallFeats smallAffs smallUtil) c
            assertEqual "p1 = prob(predictive)(y=1)"
              (prob (predictive smallFeats ag0) (is obsSpace 1)) p
            assertEqual "entropy = entropyBits(meta)"
              (entropyBits (agentMeta ag0)) h
          (_, r) -> assertFailure ("expected decision reply, got " ++ show r)
  , testCase "decision tick moves nothing: later evidence identical" $
      withWorld smallDecl $ \(w, ag0, _) ->
        case (step w ag0 evTick, step w (fst (step w ag0 decTick)) evTick) of
          ((_, RTick Nothing (Just (_, l1))), (_, RTick Nothing (Just (_, l2)))) ->
            assertEqual "loss bits bit-identical" l1 l2
          (r1, r2) -> assertFailure ("expected evidence replies, got "
                                      ++ show (snd r1) ++ " / " ++ show (snd r2))
  , testCase "evidence tick: loss_bits = the frozen observe arithmetic" $
      withWorld smallDecl $ \(w, ag0, _) ->
        case (step w ag0 evTick, observe smallFeats 1 ag0) of
          ((_, RTick Nothing (Just (y, l))), Just (LogProb lp, _)) -> do
            assertEqual "observed echoes the verdict" 1 y
            assertEqual "loss = negate lp / ln 2" (negate lp / log 2) l
          ((_, r), _) -> assertFailure ("expected evidence reply, got " ++ show r)
  , testCase "combined tick: choice from the predictive BEFORE observe" $
      withWorld smallDecl $ \(w, ag0, _) ->
        case step w ag0 (TickMsg smallFeats (Just 1) (Just [3, 2, 1]) Nothing) of
          (_, RTick (Just (c, _, _)) (Just (1, _))) ->
            assertEqual "pre-observation choice"
              (expectedChoice ag0 smallFeats smallAffs smallUtil) c
          (_, r) -> assertFailure ("expected combined reply, got " ++ show r)
  , testCase "impossible evidence: error reply, agent unchanged" $
      withWorld smallDecl $ \(w, ag0, _) ->
        case step w ag0 (TickMsg smallFeats (Just 7) Nothing Nothing) of
          (agE, RError e) -> do
            assertEqual "the declared error" "impossible-evidence" e
            case (step w ag0 evTick, step w agE evTick) of
              ((_, RTick Nothing (Just (_, l1))), (_, RTick Nothing (Just (_, l2)))) ->
                assertEqual "agent bit-identical after the error" l1 l2
              _ -> assertFailure "expected evidence replies after the error"
          (_, r) -> assertFailure ("expected RError, got " ++ show r)
  , testCase "per-tick utility override flips the choice (profiles)" $
      withWorld smallDecl $ \(w, ag0, _) ->
        let override = [ UtilRow (Right 3) (0, 0)
                       , UtilRow (Right 2) (0, 0)
                       , UtilRow (Right 1) (5, 5)
                       , UtilRow (Left ()) (-9, -9) ]
        in case step w ag0 (TickMsg smallFeats Nothing (Just [3, 2, 1])
                                    (Just override)) of
             (_, RTick (Just (c, _, _)) Nothing) ->
               assertEqual "proceed dominates under the override"
                 (Fire (mkAffId 1) []) c
             (_, r) -> assertFailure ("expected decision reply, got " ++ show r)
  , testCase "menu order is normative: ties resolve first-listed (CL-3)" $
      let tieDecl = smallDecl
            { wdMenu    = [MenuItem 4 "alt-a" [], MenuItem 5 "alt-b" []]
            , wdUtility = [ UtilRow (Right 4) (0, 0)
                          , UtilRow (Right 5) (0, 0)
                          , UtilRow (Left ()) (-9, -9) ] }
      in withWorld tieDecl $ \(w, ag0, _) -> do
        case step w ag0 (TickMsg smallFeats Nothing (Just [4, 5]) Nothing) of
          (_, RTick (Just (c, _, _)) Nothing) ->
            assertEqual "first-listed wins the tie" (Fire (mkAffId 4) []) c
          (_, r) -> assertFailure ("expected decision reply, got " ++ show r)
        case step w ag0 (TickMsg smallFeats Nothing (Just [5, 4]) Nothing) of
          (_, RTick (Just (c, _, _)) Nothing) ->
            assertEqual "reordering flips the tie" (Fire (mkAffId 5) []) c
          (_, r) -> assertFailure ("expected decision reply, got " ++ show r)
  ]

-- ---------------------------------------------------------------------
-- g3 — namespace-price pins at the governor world (frozen enumerate)
--
-- The 39 indicator names are the governor's six categorical features
-- one-hot encoded (credence-governor config.py, values verbatim);
-- with "t" the declared namespace has 40 names, nsB = lg 40. From the
-- frozen derivation (Enumerate.hs dlGuard, singleton threshold grid):
--   dlGuard(indicator) = 6 + lg 40 + 2 lg 9
--   dlGuard(t, 16-pt tau) = 6 + lg 40 + lg 16 + 2 lg 9
--   dlConst = 2 + lg 9 (namespace-free); dlWalk = 1 + lg 8 = 4
-- Enumeration order: 9 consts, 8 walks, 16*72 = 1152 t-guards, then
-- 39 * 72 indicator guards -> 3977 total.
-- ---------------------------------------------------------------------

govFeatureValues :: [(String, [String])]
govFeatureValues =
  [ ("tool-name",
     [ "read", "write", "edit", "bash", "exec", "process", "apply_patch"
     , "grep", "find", "ls", "other" ])
  , ("working-directory-relative",
     ["project-root", "subdirectory", "outside-project", "no-path"])
  , ("parent-tool-call-name",
     [ "read", "write", "edit", "bash", "exec", "process", "apply_patch"
     , "grep", "find", "ls", "other", "none" ])
  , ("recent-repetition-count", ["rep-0", "rep-1", "rep-2", "rep-3plus"])
  , ("recent-identical-call-count",
     ["ident-0", "ident-1", "ident-2", "ident-3plus"])
  , ("time-since-last-user-message", ["lt-30s", "lt-2m", "lt-10m", "gt-10m"])
  ]

govIndicators :: [String]
govIndicators = [f ++ "=" ++ v | (f, vs) <- govFeatureValues, v <- vs]

govNs :: Namespace
govNs = mkNamespace ("t" :| govIndicators)

govExtras :: [(Name, Grid)]
govExtras = [(nm, mkGrid nm (0.5 :| [])) | nm <- govIndicators]

govModels :: [Model]
govModels = enumerateModelsIn govNs govExtras allTerminals

modelBitsAt :: Int -> Double
modelBitsAt i = let Bits v = modelBits (govModels !! i) in v

g3Namespace :: TestTree
g3Namespace = testGroup "g3 namespace-price pins (the governor world)"
  [ testCase "the one-hot encoding yields 39 indicators" $
      assertEqual "39 values over 6 features" 39 (length govIndicators)
  , testCase "enumeration count: 1169 + 39 * 72 = 3977" $
      assertEqual "count" 3977 (length govModels)
  , testCase "constants stay namespace-free: dl(model 0) = 2 + lg 9" $
      assertApprox "dlConst" 1e-12 (2 + lg 9) (modelBitsAt 0)
  , testCase "walks stay namespace-free: dl(model 9) = 4" $
      assertApprox "dlWalk" 1e-12 4 (modelBitsAt 9)
  , testCase "t-guard under 40 names: dl(model 17) = 6 + lg 40 + lg 16 + 2 lg 9" $
      assertApprox "dlGuard(tau)" 1e-12 (6 + lg 40 + lg 16 + 2 * lg 9)
        (modelBitsAt 17)
  , testCase "indicator guard: dl(model 1169) = 6 + lg 40 + 2 lg 9" $
      assertApprox "dlGuard(indicator)" 1e-12 (6 + lg 40 + 2 * lg 9)
        (modelBitsAt 1169)
  , testCase "ablation row (restricted enumeration): no guards without TGet" $
      assertEqual "9 consts + 8 walks only" 17
        (length (enumerateModelsIn govNs govExtras
                   (filter (/= TGet) allTerminals)))
  ]

-- ---------------------------------------------------------------------
-- g4 — analytic cross-checks (conjugacy demoted to TEST ORACLE)
--
-- (i)  Machinery identity: over the restricted enumeration
--      [TBern, TC] (the nine grid Bernoullis; equal description
--      lengths, hence a uniform meta-prior), the agent's posterior
--      after k ones and m zeros must equal the closed-form grid Bayes
--      theta_i^k (1-theta_i)^m / sum_j ... at 1e-12.
-- (ii) A SOUND quadrature bound (stated at its true strength: the
--      bound is sound, not tight): both f(t) = t^k (1-t)^m and
--      g(t) = t f(t) are Beta kernels, unimodal with interior modes
--      k/n and (k+1)/(n+1), which for the generated ranges
--      (5 <= n <= 25, 2 <= k <= n-2) lie inside (0.05, 0.95). The
--      9-point grid sum is a midpoint rule over [0.05, 0.95] whose
--      per-cell error is bounded by the cell oscillation (exact for a
--      unimodal function: endpoint values, plus the mode if interior
--      to the cell), and the two tails are monotone, bounded by
--      0.05 * the inner endpoint value. With A = sum g, B = sum f
--      (times the cell width), m = (k+1)/(n+2) <= 1:
--        |A/B - m| <= (errA + errB) / B.
-- (margin) One documented spot margin, authored from the hand
--      calculation shown at the test: (k, n) = (3, 10) gives grid
--      predictive ~ 0.3330 vs 4/12 ~ 0.3333 — difference ~ 3.5e-4,
--      pinned <= 0.02 (a measured margin, not a derived bound).
-- ---------------------------------------------------------------------

thetas :: [Double]
thetas = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]

-- fold k ones and m zeros through the frozen observe (order
-- irrelevant for the exchangeable Bernoulli family)
bernAgent :: Int -> Int -> Agent
bernAgent k m =
  foldl (\ag y -> case observe [("t", 0)] y ag of
                    Just (_, ag') -> ag'
                    Nothing       -> error "g4: impossible evidence")
        (mkAgent (enumerateModelsIn (mkNamespace ("t" :| [])) []
                    [TBern, TC]))
        (replicate k 1 ++ replicate m 0)

gridPosterior :: Int -> Int -> [Double]
gridPosterior k m =
  let f t = t ^ k * (1 - t) ^ m
      z = sum (map f thetas)
  in [f t / z | t <- thetas]

-- exact oscillation of a unimodal function on [a, b] with mode mu
osc :: (Double -> Double) -> Double -> Double -> Double -> Double
osc f mu a b
  | mu <= a || mu >= b = abs (f a - f b)
  | otherwise          = f mu - min (f a) (f b)

g4Analytic :: TestTree
g4Analytic = testGroup "g4 analytic cross-checks (test oracles only)"
  [ testCase "grid Bayes identity: posterior after (3, 7) at 1e-12" $ do
      let ag = bernAgent 3 7
          expectedP = gridPosterior 3 7
          idxSp = mkSpace (0 :| [1 .. 8]) :: Space Int
          actualP = [prob (agentMeta ag) (is idxSp i) | i <- [0 .. 8]]
      sequence_
        [ assertApprox ("theta index " ++ show i) 1e-12 e a
        | (i, e, a) <- zip3 [0 :: Int ..] expectedP actualP ]
  , testProperty "grid predictive within the sound oscillation bound" $
      forAll (do n <- choose (5, 25 :: Int)
                 k <- choose (2, n - 2)
                 pure (k, n)) $ \(k, n) ->
        let m = n - k
            f t = t ^ k * (1 - t) ^ m
            g t = t * f t
            muF = fromIntegral k / fromIntegral n
            muG = fromIntegral (k + 1) / fromIntegral (n + 1)
            cells = [(t - 0.05, t + 0.05) | t <- thetas]
            errOf h mu =
              sum [osc h mu a b | (a, b) <- cells] * 0.1
                + 0.05 * h 0.05 + 0.05 * h 0.95
            bigA = sum (map g thetas) * 0.1
            bigB = sum (map f thetas) * 0.1
            pHat = prob (predictive [("t", 0)] (bernAgent k m))
                        (is obsSpace 1)
            mExact = fromIntegral (k + 1) / fromIntegral (n + 2)
            bound = (errOf g muG + errOf f muF) / bigB
        in counterexample
             ("k=" ++ show k ++ " n=" ++ show n ++ " pHat=" ++ show pHat
                ++ " m=" ++ show mExact ++ " bound=" ++ show bound)
             (abs (pHat - mExact) <= bound
                && abs (pHat - (bigA / bigB)) <= 1e-12)
  , testCase "spot margin: (k, n) = (3, 10) within 0.02 of (k+1)/(n+2)" $
      assertApprox "measured margin (authoring calc: |diff| ~ 3.5e-4)"
        0.02 (4 / 12)
        (prob (predictive [("t", 0)] (bernAgent 3 7)) (is obsSpace 1))
  ]

-- ---------------------------------------------------------------------
-- g5 — process smoke (RED: the binary is a stub)
-- ---------------------------------------------------------------------

g5Process :: TestTree
g5Process = testGroup "g5 process smoke (proplang-govhost)"
  [ testCase "handshake + decision + evidence over stdio" $ do
      exe <- fromMaybe "proplang-govhost" <$> lookupEnv "GOVHOST_EXE"
      (code, out, err) <- readProcessWithExitCode exe []
        (unlines [handshakeLine, decisionLine, evidenceLine])
      assertEqual ("exit (stderr: " ++ err ++ ")") ExitSuccess code
      case lines out of
        [l1, l2, l3] -> do
          assertEqual "handshake reply golden"
            "{\"ok\":true,\"proto\":1,\"models\":1241,\"namespace_bits\":1}"
            l1
          assertBool "decision reply fires the ask affordance"
            ("\"fire\":3" `isInfixOf` l2)
          assertBool "evidence reply observes the verdict"
            ("\"observed\":1" `isInfixOf` l3)
        ls -> assertFailure ("expected three reply lines, got "
                              ++ show (length ls) ++ ": " ++ show ls)
  ]
