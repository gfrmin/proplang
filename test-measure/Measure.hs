-- test-measure: the wire boundary's W1 opening-measurement oracle
-- (WIRE_PLAN.md section 1; issues #5 and #6 of the 2026-07-19 batch).
--
-- PIN-FREEZE FORM (the step-10 "or capability" reading): the pinned
-- capability — context discrimination at the shipped wire path — is
-- already shipped; no implementation is owed. Red is demonstrated by
-- seeded defect, attribution partitioned:
--   g1a red reachable: drop FGuardHead from the fragment (g1c is that
--       very configuration, live in-suite) — no guard family, no
--       context read, S collapses to 0.
--   g1b red reachable: probe the zeros context at t=61 instead of the
--       true all-zeros — the t-guard families separate the posteriors
--       (executed in the W1 SAT transcript: differs at ~6e-17).
--   g2 red reachable: any grid edit moves the population off its pin
--       (the 1529 -> 1601 step is the frozen demonstration,
--       test-unify/Unify.hs:125-126).
-- The timing rows are INSTRUMENT rows (report, no gate) — their
-- two-sided half is the population pin in the same test; a freeze run
-- that cannot reproduce the pinned population fails before it reports
-- a time.
--
-- GATE DERIVATIONS (the mandate-3 sweep at the opening sitting):
--   0.4 (C1)  = half the shipped grid's maximum achievable separation
--               (theta in [0.1, 0.9] bounds S at 0.8): "discriminates"
--               means recovering at least HALF the achievable
--               separation on a perfectly-informative stream.
--               Pre-stated before the evidence program ran; measured
--               S = 0.794 clears it at 2x.
--   0.05 (C2) = the flat band. Measured margin (recorded per the
--               CL-4 discipline): the guard-free defect regime
--               measures S = 0.0 EXACTLY (no Get survives the
--               fragment restriction, so the predictive is
--               context-free) — the band has total margin over the
--               defect it names.
--
-- TIMING SEMANTICS (the mandate-6b repair, at the opening sitting):
-- laziness defers agent realization out of the hello reply (the
-- reply forces the population COUNT, not the agent), so a naive
-- hello window undercounts and the first tick overpays. The
-- instrument therefore reports SETUP (hello + first observed tick,
-- agent realization forced) and STEADY-STATE ms/tick (the next 100
-- ticks) as separable numbers. Figures are stanza-build (-O per
-- cabal) and machine-relative: report rows, never gates.
--
-- Evidence-program provenance (R-D21): criteria pre-stated and the
-- exact stream executed against the shipped 'serveLine' BEFORE this
-- file froze — w1-prestatement.md and the prototype transcript ride
-- the boundary pack. Measured at the opening: S = 0.794119,
-- p1_attack = 0.897, 9.4-14.6 ms/tick at the four pinned populations
-- (prototype, -O2, pre-6b instrument; the suite's own first green run
-- is the figure of record).
module Main (main) where

import Data.List (intercalate, isPrefixOf, tails)
import Data.List.NonEmpty (NonEmpty ((:|)))
import System.CPUTime (getCPUTime)
import Text.Printf (printf)

import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief (is, prob)
import PropLang.Enumerate (FragProd (..), enumerateSentencesIn, fragFull,
                           obsSpace, predictive, sentenceAgent)
import PropLang.Host (HostState, hostStart, serveLine)
import PropLang.Syntax (mkGrid, mkNamespace)

main :: IO ()
main = defaultMain $ testGroup "measure (wire boundary W1)"
  [ g1Contrast
  , g2Timing
  ]

-- ---------------------------------------------------------------------
-- wire-line builders (the W1 evidence program's, verbatim)
-- ---------------------------------------------------------------------

helloLine :: [String] -> [(String, [Double])] -> [(String, [Double])] -> String
helloLine ns gs menu =
  "{\"world\": {\"namespace\": [" ++ intercalate ", " (map show ns)
  ++ "], \"guards\": [" ++ intercalate ", " (map pair gs) ++ "]"
  ++ (if null menu
      then ""
      else ", \"menu\": [" ++ intercalate ", " (map pair menu) ++ "]")
  ++ "}}"
  where
    pair (nm, vs) = "{\"name\": " ++ show nm ++ ", \"grid\": ["
                    ++ intercalate ", " (map show vs) ++ "]}"

tickLine :: [(String, Double)] -> Maybe Int -> Maybe [String] -> String
tickLine feats ev menu =
  "{\"tick\": {\"features\": {"
  ++ intercalate ", " [ show k ++ ": " ++ show v | (k, v) <- feats ] ++ "}"
  ++ maybe "" (\y -> ", \"evidence\": " ++ show y) ev
  ++ maybe "" (\ms -> ", \"menu\": [" ++ intercalate ", " (map show ms) ++ "]") menu
  ++ "}}"

runAll :: HostState -> [String] -> (HostState, [String])
runAll st0 = go st0 []
  where
    go st acc []       = (st, reverse acc)
    go st acc (l : ls) =
      let (st', r) = serveLine st l
      in length r `seq` go st' (r : acc) ls

-- number after '"k": ' in a reply line
field :: String -> String -> Maybe Double
field k s =
  case [ drop (length pat) t | t <- tails s, pat `isPrefixOf` t ] of
    rest : _ -> Just (read (takeWhile (`notElem` ",}") rest))
    []       -> Nothing
  where pat = "\"" ++ k ++ "\": "

-- ---------------------------------------------------------------------
-- g1: contrast-context discrimination on the shipped wire (issue #5)
-- ---------------------------------------------------------------------

-- the W1 stream: namespace [t, risk, m], guard risk@[0.5], menu m@[0.0];
-- 60 ticks, evidence perfectly correlated with the alternating risk
-- feature. The most favourable stream possible: failure here is failure
-- everywhere (the govhost flat-p1 shape, HOSTS_H_REPORT.md:167).
--
-- SCOPE (the mandate-5 guard, the timing ring-fence's sibling): the
-- "attack"/"benign"/"empty" names here are SYNTHETIC risk-bit
-- contexts, NOT the govhost corpora those words named in the H era.
-- What this group pins is the STRUCTURAL half of the flat-p1
-- question — the engine is a genuine function of context when the
-- signal is present — which is the half that could be measured
-- host-free. Whether the engine discriminates on REAL governance
-- features stays unmeasured until a host-corpus differential re-run;
-- no such re-run is claimed. ("S" below is the discrimination
-- statistic p1_attack - p1_benign — unrelated to the step-10 route
-- label (S) or the Idx constructor S.)
w1Hello :: String
w1Hello = helloLine ["t", "risk", "m"] [("risk", [0.5])] [("m", [0.0])]

w1Train :: [String]
w1Train = [ tickLine [("t", fromIntegral i), ("risk", r)]
                     (Just (round r)) Nothing
          | i <- [1 .. 60 :: Int], let r = if odd i then 1.0 else 0.0 ]

w1Trained :: HostState
w1Trained = fst (runAll hostStart (w1Hello : w1Train))

probeP1 :: HostState -> [(String, Double)] -> Maybe Double
probeP1 st fs = field "p1" (snd (serveLine st (tickLine fs Nothing (Just ["m"]))))

g1Contrast :: TestTree
g1Contrast = testGroup "g1 contrast-context p1 through the shipped wire"
  [ testCase "discrimination: S >= 0.4 and the 0.9 ceiling holds (W1 C1+C3)" $ do
      let pAtt = probeP1 w1Trained [("t", 61), ("risk", 1.0)]
          pBen = probeP1 w1Trained [("t", 61), ("risk", 0.0)]
      case (pAtt, pBen) of
        (Just a, Just b) -> do
          let s = a - b
          assertBool ("S = " ++ show s ++ " < 0.4: context discrimination lost "
                      ++ "(the flat-p1 defect, HOSTS_H_REPORT.md:167)")
                     (s >= 0.4)
          assertBool ("p1_attack = " ++ show a ++ " > 0.9: the emission-grid "
                      ++ "ceiling moved without re-pinning this row (issue #4/W3)")
                     (a <= 0.9 + 1e-9)
        _ -> assertFailure "p1 absent from probe reply"
  , testCase "empty context IS the all-zeros context (Get-absent = 0.0, Eval.hs:80)" $ do
      let pEmp = probeP1 w1Trained []
          pZer = probeP1 w1Trained [("t", 0), ("risk", 0)]
      assertBool "probe failed" (pEmp /= Nothing)
      pEmp @?= pZer
  , testCaseInfo "attribution: without the guard head the engine is context-flat (seeded defect, live)" $ do
      -- library route (the wire cannot utter a restricted fragment):
      -- same namespace and guards, FGuardHead dropped. This is g1a's
      -- red, kept green as its mirror: discrimination COMES FROM the
      -- guard families (the "nowhere else" is scoped by the
      -- fragment: consts and walks carry no Get). Measured at the
      -- opening: EXACTLY 0.0 — the 0.05 band's recorded margin.
      let ns = mkNamespace ("t" :| ["risk", "m"])
          gs = [("risk", mkGrid "riskc" (0.5 :| []))]
          agFlat = sentenceAgent
                     (enumerateSentencesIn ns gs
                        [ p | p <- fragFull, p /= FGuardHead ])
          p1At fs = prob (predictive fs agFlat) (is obsSpace 1)
          s = p1At [("t", 61), ("risk", 1.0)] - p1At [("t", 61), ("risk", 0.0)]
      assertBool ("guard-free S = " ++ show s ++ " not flat: a context read "
                  ++ "exists outside the guard family (attribution broken)")
                 (abs s < 0.05)
      pure ("guard-free S = " ++ show s)
  ]

-- ---------------------------------------------------------------------
-- g2: the timing instrument at the pinned populations (issue #6)
-- ---------------------------------------------------------------------

-- populations are COPIES with provenance (R-D20-i), never re-derived:
--   1169  src/PropLang/Enumerate.hs:329 (enumerateSentences haddock;
--         the test re-asserts it against the live engine)
--   1241  test-sentence/Sentence.hs:287 (membrane port)
--   1529  test-unify/Unify.hs:125
--   1601  test-unify/Unify.hs:126
-- The timing figures are REPORT, not gate ("one number per population,
-- run at each freeze so regressions are visible" — issue #6's
-- disposition, adopted at the W1 opening). The population pin is the
-- same row's gate half. Window semantics per the mandate-6b repair
-- (header): SETUP = hello + first observed tick (the reply forces
-- only the population count; the first tick forces the agent), then
-- STEADY-STATE over the next 100 ticks — separable numbers.
g2Timing :: TestTree
g2Timing = testGroup "g2 ms/tick at the pinned populations (report rows; pop pin is the gate)"
  [ timingRow 1169 (helloLine ["t"] [] []) [("t", 0)]
  , timingRow 1241 (helloLine ["t", "s2"] [("s2", [0.5])] [])
               [("t", 0), ("s2", 0.3)]
  , timingRow 1529 (helloLine ["t", "z", "a"]
                      [("z", [0.25, 0.5, 0.75]), ("a", [0.5, 1.5])] [])
               [("t", 0), ("z", 0.4), ("a", 1.0)]
  , timingRow 1601 (helloLine ["t", "z", "a"]
                      [("z", [0.25, 0.5, 0.75]), ("a", [0.5, 1.5, 2.5])] [])
               [("t", 0), ("z", 0.4), ("a", 1.0)]
  ]

timingRow :: Int -> String -> [(String, Double)] -> TestTree
timingRow pin hello featShape =
  testCaseInfo ("population " ++ show pin ++ ": pin holds; setup + ms/tick reported") $ do
    let tickAt i = tickLine
                     [ (k, if k == "t"
                           then fromIntegral i
                           else v + 0.01 * fromIntegral (i `mod` 7))
                     | (k, v) <- featShape ]
                     (Just (i `mod` 2)) Nothing
    t0 <- getCPUTime
    let (st1, hr) = serveLine hostStart hello
    length hr `seq` pure ()
    let (st2, r1) = serveLine st1 (tickAt 1)
    length r1 `seq` pure ()
    t1 <- getCPUTime
    field "models" hr @?= Just (fromIntegral pin)
    let ticks = [ tickAt i | i <- [2 .. 101 :: Int] ]
        (_, rs) = runAll st2 ticks
    length (concat rs) `seq` pure ()
    t2 <- getCPUTime
    let ms a b = fromIntegral (b - a) / (1e9 :: Double)
    pure (printf "setup %.1f ms (hello + first tick), %.2f ms/tick steady-state (100 ticks, wire-inclusive; stanza -O, machine-relative)"
                 (ms t0 t1) (ms t1 t2 / 100))
