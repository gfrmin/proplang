-- test-breadth/Breadth.hs — THE OB-19 HEIR ORACLE (the breadth key).
--
-- Authority: the breadth-sitting-r0 tag (author key over 197269b),
-- which minted THE BAR AT 2 (gate b6), accepted the drift in pack
-- XIV.6's operative clause, ruled b8 in, and routed the freeze kit's
-- installs. Row map: pack breadth-author-pack.md Parts VI/XI-XVII.
--
-- ORACLE-PHASE STATUS. Written red-first against the type-surface
-- stub (`enumerateWithBreadth` delegates to `enumerateWithArity` and
-- ignores its Breadth; the wire ignores an undeclared world key), per
-- the increment protocol. Attribution is PARTITIONED (the pin-freeze
-- clause): rows b1b/b2a-d/b3a/b3b/b4a/b4c/b5a(models)/b5c/b6d are
-- RED BY STUB (the missing implementation); rows b1a/b1c/b4d/b5a
-- (identity half)/b6a/b6b/b7a/b8a and the drift row are IDENTITY or
-- INSTRUMENT rows, green at stub, their reds demonstrated by seeded
-- defects in the red-run transcript (test-breadth/opening/red-run.txt).
--
-- THE ANCHOR-SIDE LAW (pack IV P1, honesty item 2): every world here
-- is declared on ONE side of the wire's Double parse, deliberately.
-- Wire-facing worlds use binary-exact SIXTEENTHS (n/16 is exact in
-- Double, so the declared decimal and the exact rational are the SAME
-- number — the readout suite's eighths lesson); the probe21 world
-- (exact tenths) is LIBRARY-ONLY and never crosses the wire.
--
-- THE MINT LAW (pack XIII.5's gating clause, executed at XVIII.3).
-- Three senses of "mint" live in this increment and are DECLARED here
-- (the mandate-5 finding): (A) a SITTING mint — an author key act
-- (the bar, the bands); (B) an INSTRUMENT mint — one build-stamped
-- run of THIS suite with BREADTH_MINT=1 whose transcript rides
-- test-breadth/opening/mint-run.txt, from which the frozen literals
-- below derive and from nothing else; (C) minting a TAG (the kit's
-- 4-close). A LICENSED RE-MINT is sense A executed THROUGH sense B:
-- an author act at a boundary, carried out by a fresh instrument
-- run — never a builder's standing license. Bands: windowed means
-- +/-15% (the sitting's hardware-tolerant band; beyond it lies a
-- licensed re-mint, never a breadth failure), and +/-0.03 absolute
-- on the deep/shallow mean ratio (the sitting's number, carried to
-- the RE-STATED statistic: the author's 2026-08-06 rulings re-stated
-- the LS half-slope — whose realized quiet spread broke it — to the
-- windowed-mean ratio, with an interim 0.06 band for a measured
-- cross-build shift; the freeze review of 2026-08-07 restored 0.03
-- after that shift collapsed post-climb, and a licensed re-mint is
-- PRE-DECLARED at the implementation's close should a divergence
-- return — pack XVIII U7's third ruling). A composition
-- change is a LICENSED RE-MINT of the gate, never a breadth failure
-- (XIII.5's clause, quoted).
--
-- OB-3's run-each-freeze half is RE-HOMED here: this suite rides
-- `cabal test all` (frozen gate 5), so the instrument runs at every
-- freeze. The suite prints its own build identity (the build-stamp
-- obligation, minted at the sitting).
--
-- Residuals (the no-silent-caps law): K=6 only for the cost rows (the
-- consumer's live operating point; K=10/16010 declared UNMEASURED in
-- the acceptance and not walked here); one stream shape per cost cell
-- (the 8:1 interleave); CPU ms, ONE process, ONE tasty thread
-- (NumThreads 1 is PINNED in main — getCPUTime is process-wide, so
-- parallel tests would pollute every timed cell; the pin also makes
-- the drift cell's first-in-suite position meaningful); -O1; default
-- RTS; the timed cells are ALSO a function of the BUILD DRIVER (the
-- pre-climb cross-build shift measured +0.037; post-climb every
-- class, INCLUDING the kit's own cabal build measured at the freeze
-- review (|delta| 0.0009, opening/cabal-drift-probe.txt), sits
-- within 0.006 of the mint — the standing gate-5 runs are
-- cabal-built, and the freeze commit's gate5-run.txt records that
-- build's values permanently) and of the
-- box being QUIET (pack XVIII.3/U6); wall-clock ~5-7 minutes,
-- dominated by the 300-tick drift row (the accepted price's own
-- instrument).
module Main (main) where

import Control.Exception (SomeException, try)
import Control.Monad (forM_, unless, when)
import Data.List (intercalate, isInfixOf)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (isJust)
import Data.Ratio ((%))
import System.CPUTime (getCPUTime)
import System.Directory (findExecutable, getFileSize, getModificationTime)
import System.Environment (getExecutablePath, lookupEnv)
import System.IO (BufferMode (LineBuffering), hClose, hGetLine, hPutStrLn,
                  hSetBuffering)
import System.Info (arch, compilerName, fullCompilerVersion, os)
import System.Process (CreateProcess (..), StdStream (..), createProcess,
                       proc, readProcess, terminateProcess)
import System.Timeout (timeout)
import Text.Printf (printf)

import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.Runners (NumThreads (..))

import PropLang.Enumerate (AgentS, Breadth, Hyp (..), agentObsPoints,
                           breadthEmpty, breadthNull, breadthPairs,
                           enumerateWithArity, enumerateWithBreadth, fragFull,
                           kraftSum, mapS, metaPosterior, mkBreadth, observeS,
                           predictMassS, sentenceAgent)
import PropLang.Host (hostStart, serveLine)
import PropLang.Report (bitsView, entropyAgent)
import PropLang.Syntax (Carrier, Grid, Namespace, mkCarrier, mkGrid,
                        mkNamespace)

-- ---------------------------------------------------------------------
-- THE FROZEN MINT VALUES (derivation: test-breadth/opening/mint-run.txt,
-- the official quiet build-stamped run at 4b6c9f7; this box, steel; see
-- the MINT LAW in the header). Every literal below is checked against
-- that transcript mechanically by the kit's 1-verify.
-- ---------------------------------------------------------------------

-- gate b6's bar: minted 2 at breadth-sitting-r0 (pack XIV.6; the
-- measured envelope beneath it: |S|=2 = 1.26, |S|=6 pairs-only =
-- 1.78-1.89 through depth 300, per-pair 0.132-0.148 linear, naive
-- 3.64 excluded). HEADROOM IS FACE-DEPENDENT (the freeze review's
-- ordered cell, opening/envelope-null-run.txt): SIX ordered pairs
-- with the null face OFF — but |S|=6 WITH the null face CROSSES the
-- bar at depth (2.018 at [250..280], 2.033 at [271..300], measured
-- on the prophecy overlay; the null increment 0.21 shallow declining
-- to 0.15 deep), so headroom with null declared is FIVE (implied
-- 1.87-1.89 deep — XIV.2's linearity form; the |S|=5+null cell not
-- run, marked). The operating point |S|=2+null measures 1.387.
b6Bar :: Double
b6Bar = 2.0

-- the drift row's frozen windowed means (CPU ms) and the DEEP/SHALLOW
-- MEAN RATIO — mean[151..300] / mean[6..150]. The statistic was
-- RE-STATED from the LS half-slope ratio by the author's ruling of
-- 2026-08-06 (pack XVIII register U7): the half-slope's realized
-- quiet run-to-run spread (0.044 over seven runs) exceeded the
-- minted +/-0.03 band and the gate false-fired on a quiet run; the
-- windowed-mean statistic reproduces ~10x tighter. The band value
-- itself is unchanged. The drift cell runs FIRST in the suite so it
-- owns a fresh heap: the process-shape experiment (pack XVIII.3)
-- measured depth-DEPENDENT window inflation (+7.4% shallow vs +1.5%
-- deep) when the cell ran after the heir populations, which would
-- move this ratio across the stub/implementation boundary.
driftWindows :: [(Int, Int)]
driftWindows = [(6, 30), (50, 80), (100, 130), (150, 180), (250, 280)]

driftFrozenMeans :: [Double]
driftFrozenMeans = [431.1, 598.0, 787.2, 1007.0, 1504.3]  -- mint-run.txt

driftFrozenMeanRatio :: Double
driftFrozenMeanRatio = 1.9078  -- RATIO-form re-mint, selection-freeze-r1 (box-robust: measure on the gate's own box); was 2.0092 (steel abs-ms mint)

driftMeanBand :: Double
driftMeanBand = 0.15   -- +/-15%, the sitting's hardware-tolerant band

driftRatioBand :: Double
driftRatioBand = 0.03  -- +/-0.03 absolute — the SITTING'S OWN NUMBER,
                       -- restored at the freeze review (the author,
                       -- 2026-08-07; pack XVIII U7's third ruling).
                       -- History, in full: the interim ruling of
                       -- 2026-08-06 (U7's second half) set 0.06 to
                       -- cover a measured +0.037 cross-build codegen
                       -- shift; the mkBreadth climb then CONVERGED
                       -- the builds and the shift collapsed
                       -- (post-climb: stub-vs-overlay 0.0017, the
                       -- kit's own cabal class 0.0009, within-build
                       -- up to 0.0057 — every measured class within
                       -- 0.006 of the mint; opening/
                       -- cabal-drift-probe.txt is the review's added
                       -- class). 0.03 sits ~5x above that noise
                       -- ceiling; the RATIO gate's own executed kill
                       -- is the depth-differential defect d10,
                       -- CONSTRUCTED at the review (R-RED;
                       -- opening/defect-d10.txt, numbers at pack
                       -- XIX.3) after the review's arithmetic was
                       -- caught mixing eras — d6 is ratio-INVISIBLE
                       -- by design (proportional cost cancels in the
                       -- ratio: r10c deviation 0.0194; its means
                       -- fire everything), so the named class was
                       -- owed its construction. Should a future
                       -- module addition reintroduce a cross-build
                       -- divergence, the remedy is the PRE-DECLARED
                       -- LICENSED RE-MINT at the implementation's
                       -- close (XIII.5's pattern, stated in the
                       -- freeze tag) — never a silent widening

-- the composition record beside the gate (XIII.5: recorded at the
-- mint; REPORT rows — a composition change is a licensed re-mint)
compFrozenEv, compFrozenWalkShare, compFrozenRo, compFrozenWire :: Double
compFrozenEv        = 66.2   -- base ev mean [6..30], mint-run.txt
compFrozenWalkShare = 23.8   -- ev(base) - ev(walk-free), mint-run.txt
compFrozenRo        = 434.5  -- base ev+ro mean [6..30], mint-run.txt
compFrozenWire      = 832.7  -- wire combined tick mean [6..30], mint-run.txt

-- b7's gate is EXACT EQUALITY (the repo's own standard: every law an
-- exact ==, no tolerance constant). The zero floor is a THEOREM, not
-- a measurement (the mandate-1 finding): the independent form is
-- entropyOf's expression with negation factored out, and both sides
-- consume metaPosterior in the same order, so under IEEE negation
-- symmetry they coincide bit-for-bit; the wire side adds only the
-- show/read round-trip, which is exact for Double. The row's
-- DISCRIMINATING content is therefore the POSTERIOR ROUTE — the wire
-- agent's posterior against the reference route's — plus the render
-- contract; the arithmetic-form independence is nominal, and the
-- kill is the sign-drop class (M8/defect-d4), which fires through
-- the wire side alone. What the row is a FUNCTION OF, stated: the
-- summation order of metaPosterior, the Double show/read round-trip,
-- and the two posterior routes. (The first draft gated at 1e-12
-- citing "the repo's smallest standing gate class" — a class the
-- exact re-founding ABOLISHED; the mandate round convicted the
-- citation and the gate went to == .)

-- ---------------------------------------------------------------------
-- the consumer-class world (SIXTEENTHS — wire-safe by construction;
-- the #21 live curves' size class: per-atom population 1601)
-- ---------------------------------------------------------------------

thetaQs, rhoQs, tauQs :: [Integer]
thetaQs = [1 .. 9]
rhoQs   = [1 .. 8]
tauQs   = [3 .. 13]

g16 :: [Integer] -> NonEmpty Rational
g16 ns = case [ n % 16 | n <- ns ] of
  (q : qs) -> q :| qs
  []       -> error "breadth oracle: empty grid (unreachable)"

nsC :: Namespace
nsC = mkNamespace ("t" :| ["c1", "c2", "skill"])

obsAt :: Int -> Carrier Int
obsAt k = mkCarrier "obs" (0 :| [1 .. k - 1])

thetaC, rhoC :: Grid
thetaC = mkGrid "theta" (g16 thetaQs)
rhoC   = mkGrid "rho" (g16 rhoQs)

guardsC :: [(String, Grid)]
guardsC = [ ("c1", mkGrid "c1" (g16 tauQs))
          , ("c2", mkGrid "c2" (g16 tauQs)) ]

basePop :: Int -> [Hyp]
basePop k = enumerateWithArity k nsC (obsAt k) thetaC guardsC (Just rhoC) fragFull

heirPop :: Int -> Breadth -> [Hyp]
heirPop k br =
  enumerateWithBreadth br k nsC (obsAt k) thetaC guardsC (Just rhoC) fragFull

-- the declared operating point (issue #21's demand): the minority
-- atom-pair both ways, plus the null face
s21 :: [(Int, Int)]
s21 = [(3, 2), (2, 3)]

-- every declaration goes through the ONE validator (the ladder as
-- climbed: the type is abstract; the oracle's worlds declare validly,
-- so the unwrap is total here — an invalid literal is a suite bug)
mkBr :: Int -> [(Int, Int)] -> Bool -> Breadth
mkBr k ps nl = case mkBreadth k ps nl of
  Just b  -> b
  Nothing -> error "breadth oracle: invalid declaration (unreachable)"

brFull, brEmpty, brAsym, brPairs6, brNull6 :: Breadth
brFull   = mkBr 6 s21 True
brEmpty  = breadthEmpty
brAsym   = mkBr 6 [(3, 2)] True
brPairs6 = mkBr 6 s21 False
brNull6  = mkBr 6 [] True

-- the probe21-side (K=5) declarations, validated at their own arity
br21Pairs, br21PairsNull, br21OnePair, br21Null :: Breadth
br21Pairs    = mkBr k21 s21 False
br21PairsNull = mkBr k21 s21 True
br21OnePair  = mkBr k21 [(3, 2)] False
br21Null     = mkBr k21 [] True

-- closed forms, derived from the DECLARED data above (the sweep-
-- universe law: never hand-enumerated counts). FUNCTION OF, complete
-- (the mandate-6 finding): the declared list lengths BELOW, plus the
-- full fragment set (every enumeration here passes fragFull) and the
-- walk grid's PRESENCE (the rPts term holds only for worlds passing
-- Just rho - the consumer world; the probe21 world passes Nothing
-- and these forms are never applied to it)
ePts, rPts, tPts, nGuards :: Int
ePts    = length thetaQs
rPts    = length rhoQs
tPts    = length tauQs
nGuards = length guardsC

perAtomBase :: Int
perAtomBase = ePts + rPts + nGuards * tPts * ePts * (ePts - 1)

baseClosed :: Int -> Int
baseClosed k = (k - 1) * perAtomBase

pairClosed :: [(Int, Int)] -> Int
pairClosed s = length s * nGuards * tPts * ePts * (ePts - 1)

nullClosed :: Int
nullClosed = ePts + nGuards * tPts * ePts * (ePts - 1)

heirClosed :: Int -> Breadth -> Int
heirClosed k br =
  baseClosed k + pairClosed (breadthPairs br)
    + (if breadthNull br then nullClosed else 0)

-- the 8:1-shaped interleaved stream (the #21 corpus shape; COPY of the
-- opening probes' streamC — pack IV, P0/P7)
-- Tick: a feature assignment with its evidence label — the fold's
-- own input shape (observeS's first two arguments, paired); a test
-- alias, no new frozen-surface content
type Tick = ([(String, Rational)], Int)

streamC :: Int -> Int -> [Tick]
streamC k n =
  [ ( [ ("t", fromIntegral (i `mod` 7))
      , ("c1", if minority then 3 % 4 else 1 % 4)
      , ("c2", 1 % 2), ("skill", 1) ]
    , if minority then min 3 (k - 1) else min 2 (k - 1) )
  | i <- [0 .. n - 1]
  , let minority = i `mod` 9 == 8 ]

-- ---------------------------------------------------------------------
-- the probe21 world (EXACT TENTHS — library side ONLY, never wired;
-- dispositions-pack.md VII.1's shape: ns [t, ctx, skill], one guard
-- ctx@[1/2], K=5)
-- ---------------------------------------------------------------------

k21 :: Int
k21 = 5

ns21 :: Namespace
ns21 = mkNamespace ("t" :| ["ctx", "skill"])

theta21Qs :: [Rational]
theta21Qs = [ n % 10 | n <- [1 .. 9] ]

theta21 :: Grid
theta21 = case theta21Qs of
  (q : qs) -> mkGrid "theta" (q :| qs)
  []       -> error "breadth oracle: empty theta21 (unreachable)"

tau21 :: Grid
tau21 = mkGrid "ctx" (1 % 2 :| [])

obs21 :: Carrier Int
obs21 = mkCarrier "obs" (0 :| [1 .. k21 - 1])

base21 :: [Hyp]
base21 = enumerateWithArity k21 ns21 obs21 theta21 [("ctx", tau21)] Nothing fragFull

heir21 :: Breadth -> [Hyp]
heir21 br =
  enumerateWithBreadth br k21 ns21 obs21 theta21 [("ctx", tau21)] Nothing fragFull

-- the #21 stream: 60 dominant-context ticks then 8 minority ticks
stream21 :: [Tick]
stream21 =
  [ (fs (0 :: Int), 2) | _ <- [1 .. 60 :: Int] ]
    ++ [ (fs (1 :: Int), 3) | _ <- [1 .. 8 :: Int] ]
  where
    fs c = [ ("t", 0), ("ctx", fromIntegral c), ("skill", 0) ]

minorityFs, dominantFs :: [(String, Rational)]
minorityFs = [ ("t", 0), ("ctx", 1), ("skill", 0) ]
dominantFs = [ ("t", 0), ("ctx", 0), ("skill", 0) ]

-- the null-dominant stream (P2's shape: 75% y=0), 200 ticks
streamNull :: [Tick]
streamNull =
  [ ( [ ("t", fromIntegral (i `mod` 7)), ("ctx", 1 % 4), ("skill", 0) ]
    , if i `mod` 4 == 3 then 2 else 0 )
  | i <- [0 .. 199 :: Int] ]

nullProbeFs :: [(String, Rational)]
nullProbeFs = [ ("t", 0), ("ctx", 1 % 4), ("skill", 0) ]

-- the structural cap on the shipped null mass, DERIVED from the
-- declared list (the tauPoints law: the first draft hand-wrote the
-- 1/10 and the mandate round convicted it - the convicted 0.9-class
-- literal, back one boundary after its deletion). TWO forms, kept
-- distinct: the FROZEN premise (OB-19 / W3 ruling 1 / R-D23) is
-- p0 <= 1/(K-1); the TIGHTER (1 - min theta)/(K - 1) is the
-- builder's addition, with its executed witness recorded at the
-- mandate round (max p0 over the whole probe21 corpus == this cap
-- exactly, walk-free and walk-live - pack XVIII.10)
nullCapFrozen, nullCap :: Rational
nullCapFrozen = 1 / fromIntegral (k21 - 1)
nullCap = (1 - minimum theta21Qs) / fromIntegral (k21 - 1)

-- ---------------------------------------------------------------------
-- library helpers (fold, readout reference, argmax — COPY shapes:
-- test-readout/Readout.hs at 0766ebe, bindings foldEv/refVecAt/
-- refArgmax; the opening probes' foldEv/vecAt)
-- ---------------------------------------------------------------------

orDie :: Either String a -> a
orDie = either (error . ("breadth oracle: " ++)) id

foldEv :: AgentS -> [Tick] -> AgentS
foldEv = foldl one
  where one ag (fs, y) = snd (orDie (observeS fs y ag))

vecAt :: [(String, Rational)] -> AgentS -> [Rational]
vecAt fs ag = [ orDie (predictMassS fs j ag) | j <- agentObsPoints ag ]

argmaxLow :: [Rational] -> Int
argmaxLow vs0 = case vs0 of
  []       -> error "breadth oracle: empty vector (unreachable)"
  (v : vs) -> go 0 0 v vs
  where
    go best _ _ [] = best
    go best i cur (x : xs)
      | x > cur   = go (i + 1) (i + 1) x xs
      | otherwise = go best (i + 1) cur xs

tagCount :: String -> [Hyp] -> Int
tagCount nm hs = length [ h | h@(Hyp (n, _) _ _ _ _) <- hs, n == nm ]

firstFs :: [Tick] -> [(String, Rational)]
firstFs ts = case ts of
  ((f, _) : _) -> f
  []           -> error "breadth oracle: empty stream (unreachable)"

weightsOf :: (String, [Int]) -> [Hyp] -> [Rational]
weightsOf tg hs = [ hypW h | h <- hs, hypTag h == tg ]

-- ---------------------------------------------------------------------
-- timing (COPY: the opening probes' timedFold/evStep/roStep/winMean/
-- lsSlope — pack IV P0/P7, src-tree ecfd3102)
-- ---------------------------------------------------------------------

msSince :: Integer -> IO Double
msSince t0 = do
  t1 <- getCPUTime
  pure (fromIntegral (t1 - t0) / 1e9)

timedFold :: (AgentS -> Tick -> AgentS) -> AgentS -> [Tick] -> IO [Double]
timedFold step = go
  where
    go _ [] = pure []
    go ag (t : ts) = do
      t0 <- getCPUTime
      let ag' = step ag t
      ms <- ag' `seq` msSince t0
      (ms :) <$> go ag' ts

evStep :: AgentS -> Tick -> AgentS
evStep ag (fs, y) = case observeS fs y ag of
  Left e         -> error ("observeS: " ++ e)
  Right (m, ag') -> bitsView m `seq` ag'

-- the ev+ro CLASS copies P0's executed shape byte-for-byte, entropyAgent
-- included (pack IV P0); b7's COMPARISON is what never touches
-- entropyAgent — the class definition and the pin are different rows
roStep :: AgentS -> Tick -> AgentS
roStep ag t@(fs, _) =
  let ag' = evStep ag t
      vec = vecAt fs ag'
      h   = entropyAgent ag'
  in sum vec `seq` h `seq` ag'

winMean :: Int -> Int -> [Double] -> Double
winMean lo hi xs =
  let w = take (hi - lo + 1) (drop (lo - 1) xs)
  in sum w / fromIntegral (length w)

-- the INDEPENDENT entropy (OB-31's law: from the posterior masses
-- directly, NEVER entropyAgent — the renderer's own function must sit
-- on only ONE side of b7's comparison)
indepEntropy :: AgentS -> Double
indepEntropy ag =
  negate (sum [ p * logBase 2 p
              | w <- metaPosterior ag, w > 0
              , let p = fromRational w :: Double ])

-- ---------------------------------------------------------------------
-- the wire (COPY shapes: the opening P0 probe's helloP0/tickW; the
-- readout suite's replay/single-point-menu design and pipes form)
-- ---------------------------------------------------------------------

renderQ :: Rational -> String
renderQ q = show (fromRational q :: Double)

renderGrid16 :: [Integer] -> String
renderGrid16 ns = "[" ++ intercalate ", " [ renderQ (n % 16) | n <- ns ] ++ "]"

-- the breadth key's drafted wire syntax (under-determination register
-- row U1; the sitting absorbs or amends at the freeze):
--   "breadth": {"pairs": [[jHi, jLo], ...], "null": true|false}
-- both keys optional; {} == absent key == the shipped route.
breadthJson :: Breadth -> String
breadthJson br =
  "\"breadth\": {\"pairs\": ["
    ++ intercalate ", " [ "[" ++ show a ++ ", " ++ show b ++ "]"
                        | (a, b) <- breadthPairs br ]
    ++ "], \"null\": " ++ (if breadthNull br then "true" else "false") ++ "}, "

-- the consumer-world hello; single-point menu (the readout suite's
-- design: the chosen act is FORCED to skill=1, so the reference folds
-- at a known assignment without parsing the act back out)
helloB :: Maybe String -> Int -> String
helloB mBreadth k =
  "{\"membrane\": 1, \"world\": {\"namespace\": [\"t\", \"c1\", \"c2\", \"skill\"], "
    ++ "\"guards\": [{\"name\": \"c1\", \"grid\": " ++ renderGrid16 tauQs ++ "}, "
    ++ "{\"name\": \"c2\", \"grid\": " ++ renderGrid16 tauQs ++ "}], "
    ++ "\"menu\": [{\"name\": \"skill\", \"grid\": [1]}], "
    ++ "\"obs_arity\": " ++ show k ++ ", "
    ++ maybe "" id mBreadth
    ++ "\"utility\": {\"form\": \"said@1\", \"said\": [\"*\", [\"get\", \"skill\"], "
    ++ "[\"-\", [\"+\", [\"var\", 1], [\"var\", 1]], [\"c\", 1]]]}, "
    ++ "\"codebooks\": {\"theta\": " ++ renderGrid16 thetaQs
    ++ ", \"rho\": " ++ renderGrid16 rhoQs ++ "}}}"

-- a minimal K=2-capable hello (still sixteenths; guards kept so the
-- pair face would have somewhere to land if it were legal)
helloMin :: Maybe String -> Int -> String
helloMin mBreadth k =
  "{\"membrane\": 1, \"world\": {\"namespace\": [\"m\"], "
    ++ "\"guards\": [], "
    ++ "\"menu\": [{\"name\": \"m\", \"grid\": [1]}], "
    ++ "\"obs_arity\": " ++ show k ++ ", "
    ++ maybe "" id mBreadth
    ++ "\"codebooks\": {\"theta\": " ++ renderGrid16 thetaQs ++ "}}}"

-- wire ticks DERIVED from the one stream generator (the probe-
-- discipline law: a probe reads declared data, and two parallel lists
-- of the same ticks are the TWO-LISTS DISEASE made sayable — so they
-- are made unsayable): a Tick's wire form renders the Tick's OWN
-- assignment minus the act name (the single-point menu carries the
-- act), with the Tick's own label as evidence. Sixteenths make the
-- Double render exact, so wire and reference build the same world.
featsJson :: [(String, Rational)] -> String
featsJson fs =
  "\"features\": {"
    ++ intercalate ", " [ "\"" ++ n ++ "\": " ++ renderQ v
                        | (n, v) <- fs, n /= "skill" ]
    ++ "}"

tickEvOf :: Tick -> String
tickEvOf (fs, y) =
  "{\"tick\": {" ++ featsJson fs ++ ", \"menu\": [\"skill\"], \"evidence\": "
    ++ show y ++ "}}"

tickDecOf :: [(String, Rational)] -> String
tickDecOf fs = "{\"tick\": {" ++ featsJson fs ++ ", \"menu\": [\"skill\"]}}"

-- the rendering convention (COPY: the wire's Double render - the
-- p_codes renderer is the where-binding rQ inside readoutFields,
-- src/PropLang/Host.hs at 4b6c9f7; byte-identical to test-readout's
-- rD, whose frozen rows pin the render on the wire)
rD :: Rational -> String
rD q = show (fromRational q :: Double)

fieldCodes :: [Rational] -> String
fieldCodes vec = "\"p_codes\": [" ++ intercalate ", " (map rD vec) ++ "]"

-- extract a numeric field's rendering from a reply line
fieldOf :: String -> String -> Maybe String
fieldOf name reply = go reply
  where
    key = "\"" ++ name ++ "\": "
    go s | key `isPrefixOfS` s =
             Just (takeWhile (`notElem` (",}]" :: String)) (drop (length key) s))
         | otherwise = case s of
             []       -> Nothing
             (_ : r)  -> go r
    isPrefixOfS p s = take (length p) s == p

isErrorReply :: String -> Bool
isErrorReply r = "\"error\"" `isInfixOf` r && not ("\"ok\": true" `isInfixOf` r)

-- ---------------------------------------------------------------------
-- the build stamp (the sitting's minted obligation: the instrument
-- prints its own identity; a stale run is self-convicting)
-- ---------------------------------------------------------------------

stamp :: IO ()
stamp = do
  exe <- getExecutablePath
  sz  <- getFileSize exe
  mt  <- getModificationTime exe
  sha <- tryRun "sha256sum" [exe]
  hd  <- tryRun "git" ["rev-parse", "--short", "HEAD"]
  srcT <- tryRun "git" ["rev-parse", "HEAD:src"]
  dirty <- tryRun "git" ["status", "--porcelain", "src"]
  printf "BUILD-STAMP exe=%s size=%d mtime=%s %s-%s %s-%s\n"
         exe sz (show mt) compilerName (show fullCompilerVersion) os arch
  printf "BUILD-STAMP sha256=%s HEAD=%s src-tree=%s src-dirty=%d\n"
         (takeWhile (/= ' ') sha) (oneLine hd) (oneLine srcT)
         (length (filter (not . null) (lines dirty)))
  where
    oneLine = takeWhile (/= '\n')

tryRun :: String -> [String] -> IO String
tryRun cmd args = do
  r <- try (readProcess cmd args "") :: IO (Either SomeException String)
  pure (either (const "unavailable") id r)

-- ---------------------------------------------------------------------
-- gate-or-mint: in mint mode a frozen-value row PRINTS its measured
-- value (the mint transcript's line) and never gates; in the standing
-- form it gates against the frozen literal
-- ---------------------------------------------------------------------

gateOrMint :: Bool -> String -> Bool -> Assertion
gateOrMint mintMode msg cond =
  if mintMode
    then putStrLn ("MINT " ++ msg)
    else assertBool msg cond

-- ---------------------------------------------------------------------
-- main
-- ---------------------------------------------------------------------

main :: IO ()
main = do
  mintMode <- isJust <$> lookupEnv "BREADTH_MINT"
  stamp
  when mintMode (putStrLn "MINT MODE: frozen-value rows print, never gate")
  -- ONE tasty thread, PINNED (the mandate-6 finding): getCPUTime is
  -- process-wide, so any parallelism pollutes every timed cell, and
  -- the drift cell's first-in-suite position is only meaningful
  -- sequentially. Pinned in code so no stanza flag or ambient
  -- TASTY_NUM_THREADS can silently unpin it.
  defaultMain (localOption (NumThreads 1) (tests mintMode))

tagName :: Hyp -> String
tagName h = fst (hypTag h)

foldReplies :: String -> [String] -> String
foldReplies hello ticks = go (fst (serveLine hostStart hello)) ticks
  where
    go _ []       = error "breadth oracle: no ticks (unreachable)"
    go st [l]     = snd (serveLine st l)
    go st (l : ls) = go (fst (serveLine st l)) ls

-- the b5/b7 wire scenario: 12 evidence ticks then a decide, every
-- tick DERIVED from streamC (the one generator); the reference twin
-- folds the same 12 ticks at the forced act
wireTicks :: [String]
wireTicks =
  map tickEvOf (streamC 6 12) ++ [tickDecOf probeFs12]

refAgFolded :: AgentS
refAgFolded = foldEv (sentenceAgent nsC (heirPop 6 brFull)) (streamC 6 12)

-- the decide tick's assignment: streamC's OWN 13th tick (index 12),
-- act included — derived, never hand-written (the tauPoints law)
probeFs12 :: [(String, Rational)]
probeFs12 = firstFs (drop 12 (streamC 6 13))

-- the drift cell runs FIRST (a fresh-heap cell: see the constants
-- block's note — its statistic must not read the suite's heap shape)
tests :: Bool -> TestTree
tests mintMode = testGroup "breadth oracle (b1-b8 + drift; breadth-sitting-r0)"
  [ gDrift mintMode, gB1, gB2, gB3, gB4, gB5, gB7, gB8, gB6 mintMode ]

-- ---------------------------------------------------------------------
-- b1 — the untouched route and the closed form
-- ---------------------------------------------------------------------

gB1 :: TestTree
gB1 = testGroup "b1 untouched route + models closed form"
  [ testCase "b1a empty breadth IS the shipped route: count and folded minority vec exact == (probe21 world)" $ do
      let popE = heir21 brEmpty
          agS  = foldEv (sentenceAgent ns21 base21) stream21
          agE  = foldEv (sentenceAgent ns21 popE) stream21
      length popE @?= length base21
      vecAt minorityFs agE @?= vecAt minorityFs agS
  , testCase "b1b heir models == the closed form over declared data (consumer world, S=2 pairs + null)" $ do
      let popH = heirPop 6 brFull
      length popH @?= heirClosed 6 brFull
      -- the faces separately declarable: each face's count alone
      length (heirPop 6 brPairs6)
        @?= baseClosed 6 + pairClosed s21
      length (heirPop 6 brNull6)
        @?= baseClosed 6 + nullClosed
  , testCase "b1c K=2 with empty breadth: count and an 8-tick folded vec exact == the shipped route" $ do
      let popB = basePop 2
          popH = heirPop 2 brEmpty
          ticks = streamC 2 8
          agB = foldEv (sentenceAgent nsC popB) ticks
          agH = foldEv (sentenceAgent nsC popH) ticks
          pf  = firstFs ticks
      length popH @?= length popB
      vecAt pf agH @?= vecAt pf agB
  ]

-- ---------------------------------------------------------------------
-- b2 — Kraft and the mention pricing
-- ---------------------------------------------------------------------

gB2 :: TestTree
gB2 = testGroup "b2 Kraft and pricing"
  [ testCase "b2a kraft: heir < 1 AND strictly above base (the declaration ADDS prior mass)" $ do
      let kB = kraftSum (basePop 6)
          kH = kraftSum (heirPop 6 brFull)
      assertBool ("kraft heir < 1: " ++ show (fromRational kH :: Double)) (kH < 1)
      assertBool "kraft heir > kraft base (strict)" (kH > kB)
  , testCase "b2b the declared-pair mention mass is 1/|S|: same coordinates at |S|=2 weigh HALF of |S|=1 (Rational ==)" $ do
      -- the law is the FROZEN charge algebra applied to the declared
      -- codebook (mentionMass g = CMass (1/gridSize g),
      -- src/PropLang/Enumerate.hs at 4b6c9f7, binding mentionMass);
      -- the prototype transcript (pack IV P3) is its executed
      -- instance, not its definition
      let tg  = ("dpair", [3, 2, 0, 7, 8])
          w1s = weightsOf tg (heir21 br21OnePair)
          w2s = weightsOf tg (heir21 br21Pairs)
      case (w1s, w2s) of
        ([w1], [w2]) -> w2 @?= w1 / 2
        _ -> assertFailure
               ("expected exactly one row each side, got "
                  ++ show (length w1s) ++ "/" ++ show (length w2s))
  , testCase "b2c independent pricing: the null face's weight is invariant in the pair declaration (Rational ==)" $ do
      let tg  = ("nullconst", [0, 6])
          wN  = weightsOf tg (heir21 br21Null)
          wNP = weightsOf tg (heir21 br21PairsNull)
      case (wN, wNP) of
        ([w1], [w2]) -> w2 @?= w1
        _ -> assertFailure
               ("expected exactly one nullconst row each side, got "
                  ++ show (length wN) ++ "/" ++ show (length wNP))
  , testCase "b2d prices are finite and positive (REPORT: bits printed)" $ do
      let popH = heir21 br21PairsNull
          pick tg = case weightsOf tg popH of
            (w : _) -> w
            []      -> 0
          -- tag layouts: dpair [jHi,jLo,kt,a,b] (pack IV P3, binding
          -- declaredFamily), nullconst [0,k] and nullguard [0,kt,a,b]
          -- (pack IV P2, bindings nullConsts/nullGuarded); the
          -- nullguard coordinates pick an ARBITRARY family member
          -- (kt=0, a=6, b=3; any a/=b member serves - the row pins
          -- positivity and pricing, not the member). All tag vectors
          -- are functions of the declared grid ORDER (a grid edit
          -- moves them; pick fails closed as "got 0/0").
          wD = pick ("dpair", [3, 2, 0, 7, 8])
          wC = pick ("nullconst", [0, 6])
          wG = pick ("nullguard", [0, 0, 6, 3])
      printf "  REPORT prices: dpair %.2f bits, nullconst %.2f bits, nullguard %.2f bits\n"
             (bitsView wD) (bitsView wC) (bitsView wG)
      assertBool "dpair weight > 0" (wD > 0)
      assertBool "nullconst weight > 0" (wC > 0)
      assertBool "nullguard weight > 0" (wG > 0)
  ]

-- ---------------------------------------------------------------------
-- b3 — the #21 semantics (library side, exact tenths)
-- ---------------------------------------------------------------------

gB3 :: TestTree
gB3 = testGroup "b3 the #21 semantics: the minority tie BREAKS"
  [ testCase "b3a declared [(3,2),(2,3)]: minority argmax 3 with P(3) > 1/2; dominant argmax stays 2" $ do
      let agD = foldEv (sentenceAgent ns21 (heir21 br21Pairs)) stream21
          vM  = vecAt minorityFs agD
          vDm = vecAt dominantFs agD
      printf "  REPORT minority vec: %s\n"
             (show (map (\q -> fromRational q :: Double) vM))
      argmaxLow vM @?= 3
      assertBool ("P(3) > 1/2: " ++ show (fromRational (vM !! 3) :: Double))
                 (vM !! 3 > 1 % 2)
      argmaxLow vDm @?= 2
  , testCase "b3b the MAP is the declared pair sentence (pack IV P3 D2: dpair [3,2,0,7,8], mass > 1/2)" $ do
      let agD = foldEv (sentenceAgent ns21 (heir21 br21Pairs)) stream21
          (tg, w) = mapS agD
      printf "  REPORT MAP %s @ %.4f\n" (show tg) (fromRational w :: Double)
      tg @?= ("dpair", [3, 2, 0, 7, 8])
      assertBool "MAP mass > 1/2" (w > 1 % 2)
  ]

-- ---------------------------------------------------------------------
-- b4 — the null face and the K=2 door
-- ---------------------------------------------------------------------

gB4 :: TestTree
gB4 = testGroup "b4 the null face and the K=2 door"
  [ testCase "b4a null-dominant stream: extended p0 breaks the structural cap (pack IV P2 criteria S1/S2)" $ do
      let agS = foldEv (sentenceAgent ns21 base21) streamNull
          agE = foldEv (sentenceAgent ns21 (heir21 br21Null)) streamNull
          p0S = orDie (predictMassS nullProbeFs 0 agS)
          p0E = orDie (predictMassS nullProbeFs 0 agE)
          (mTg, mW) = mapS agE
      printf "  REPORT p0 shipped %.6f (caps %.6f frozen / %.6f tight)  extended %.6f  MAP %s @ %.4f\n"
             (fromRational p0S :: Double) (fromRational nullCapFrozen :: Double)
             (fromRational nullCap :: Double)
             (fromRational p0E :: Double) (show mTg) (fromRational mW :: Double)
      -- RECORD rows, not this row's discriminating content (the
      -- readout r5a precedent: mandate 1 convicted p0<=cap as a
      -- THEOREM of normalized weights and it is recorded as one;
      -- re-convicted at this increment's mandate round). The
      -- discriminating asserts are the extended-face three below.
      assertBool "RECORD: shipped p0 <= 1/(K-1) (the FROZEN premise, OB-19/R-D23)"
                 (p0S <= nullCapFrozen)
      assertBool "RECORD: shipped p0 <= (1-min theta)/(K-1) (builder's tighter form, witness at XVIII.10)"
                 (p0S <= nullCap)
      assertBool "extended p0 > 2x shipped" (p0E > 2 * p0S)
      assertBool "extended p0 in (0.60, 0.85)" (p0E > 3 % 5 && p0E < 17 % 20)
      mTg @?= ("nullconst", [0, 6])
  , testCase "b4c the door refuses: null at K=2, invalid pairs, a==b, out of range, the null atom, duplicates" $ do
      let refuse lbl hello =
            assertBool (lbl ++ ": " ++ take 90 (snd (serveLine hostStart hello)))
                       (isErrorReply (snd (serveLine hostStart hello)))
      refuse "null at K=2 (the exact-duplication law)"
             (helloMin (Just "\"breadth\": {\"pairs\": [], \"null\": true}, ") 2)
      refuse "pair at K=2 (no distinct positive pair exists)"
             (helloMin (Just "\"breadth\": {\"pairs\": [[1, 2]], \"null\": false}, ") 2)
      refuse "a==b pair" (helloB (Just "\"breadth\": {\"pairs\": [[3, 3]], \"null\": false}, ") 6)
      refuse "atom out of range" (helloB (Just "\"breadth\": {\"pairs\": [[7, 2]], \"null\": false}, ") 6)
      refuse "the null atom is not a positive atom"
             (helloB (Just "\"breadth\": {\"pairs\": [[0, 2]], \"null\": false}, ") 6)
      refuse "duplicate pair (a codebook is a set)"
             (helloB (Just "\"breadth\": {\"pairs\": [[3, 2], [3, 2]], \"null\": false}, ") 6)
  , testCase "b4d an empty declaration IS the absent key: hello replies byte-identical" $ do
      let rNone  = snd (serveLine hostStart (helloB Nothing 6))
          rEmpty = snd (serveLine hostStart (helloB (Just "\"breadth\": {}, ") 6))
          rExpl  = snd (serveLine hostStart (helloB (Just (breadthJson brEmpty)) 6))
      rEmpty @?= rNone
      rExpl @?= rNone
  ]

-- ---------------------------------------------------------------------
-- b5 — the wire is the reference route
-- ---------------------------------------------------------------------

gB5 :: TestTree
gB5 = testGroup "b5 wire == reference route"
  [ testCase "b5a breadth hello: models the closed form; decide p_codes == the reference vector" $ do
      let hello = helloB (Just (breadthJson brFull)) 6
          helloReply = snd (serveLine hostStart hello)
      assertBool ("hello accepted: " ++ take 90 helloReply)
                 ("\"ok\": true" `isInfixOf` helloReply)
      assertBool ("models == closed form: " ++ take 120 helloReply)
                 (("\"models\": " ++ show (heirClosed 6 brFull))
                    `isInfixOf` helloReply)
      let decReply = foldReplies hello wireTicks
          vec = vecAt probeFs12 refAgFolded
      assertBool ("p_codes crosses as the reference vector: " ++ decReply)
                 (fieldCodes vec `isInfixOf` decReply)
      -- the faces SEPARATELY DECLARABLE on the wire, at an ASYMMETRIC
      -- declared set. Falsifiability is the reason for the asymmetry:
      -- the #21 set [(3,2),(2,3)] is CLOSED under per-pair swap, so a
      -- door-side swap defect is invisible to it by construction —
      -- this cell is where that defect class fires (defect-d7).
      let helloA = helloB (Just (breadthJson brAsym)) 6
          helloAReply = snd (serveLine hostStart helloA)
      assertBool ("asym hello models == closed form: " ++ take 120 helloAReply)
                 (("\"models\": " ++ show (heirClosed 6 brAsym))
                    `isInfixOf` helloAReply)
      let decA = foldReplies helloA wireTicks
          refA = foldEv (sentenceAgent nsC (heirPop 6 brAsym)) (streamC 6 12)
          vecA = vecAt probeFs12 refA
      assertBool ("asym p_codes == the reference vector: " ++ decA)
                 (fieldCodes vecA `isInfixOf` decA)
  , testCase "b5c the breadth hello survives the pipes (spawned host, the g6 form)" $ do
      mexe <- findExecutable "proplang-host"
      exe <- case mexe of
        Just e  -> pure e
        Nothing -> assertFailure
          "proplang-host not on PATH (cabal supplies it via build-tool-depends)"
      (mi, mo, _, ph) <- createProcess (proc exe [])
          { std_in = CreatePipe, std_out = CreatePipe, std_err = Inherit }
      (hin, hout) <- case (mi, mo) of
        (Just i, Just o) -> pure (i, o)
        _ -> assertFailure "pipes not created"
      hSetBuffering hin LineBuffering
      hPutStrLn hin (helloB (Just (breadthJson brFull)) 6)
      mreply <- timeout (30 * 1000 * 1000) (hGetLine hout)
      hClose hin
      terminateProcess ph
      case mreply of
        Nothing -> assertFailure "no hello reply within the window"
        Just reply -> assertBool ("models over the pipes: " ++ reply)
          (("\"models\": " ++ show (heirClosed 6 brFull)) `isInfixOf` reply)
  ]

-- ---------------------------------------------------------------------
-- b7 — entropy_bits against an INDEPENDENT computation (OB-31)
-- ---------------------------------------------------------------------

gB7 :: TestTree
gB7 = testGroup "b7 entropy_bits (OB-31)"
  [ testCase "b7a the wire's entropy_bits == the independent computation from posterior masses (never entropyAgent)" $ do
      let decReply = foldReplies (helloB (Just (breadthJson brFull)) 6) wireTicks
      wireH <- case fieldOf "entropy_bits" decReply of
        Just s  -> pure (read s :: Double)
        Nothing -> assertFailure ("no entropy_bits field: " ++ decReply)
      let indepH = indepEntropy refAgFolded
      printf "  REPORT entropy wire %.12f independent %.12f delta %.3e\n"
             wireH indepH (abs (wireH - indepH))
      wireH @?= indepH
  ]

-- ---------------------------------------------------------------------
-- b8 — the walk-free exchangeability identity (P10 cell b, ruled in)
-- ---------------------------------------------------------------------

gB8 :: TestTree
gB8 = testGroup "b8 walk-free exchangeability"
  [ testCase "b8a the walk-free heir corpus: forward fold == reversed fold, exact (Rational ==)" $ do
      let full   = heirPop 6 brFull
          noWalk = [ h | h <- full, tagName h /= "walk" ]
          ticks  = streamC 6 16
          pf     = firstFs ticks
          fwd    = foldEv (sentenceAgent nsC noWalk) ticks
          rev    = foldEv (sentenceAgent nsC noWalk) (reverse ticks)
      length full - length noWalk @?= (6 - 1) * rPts
      vecAt pf fwd @?= vecAt pf rev
  ]

-- ---------------------------------------------------------------------
-- b6 — the ms/tick instrument (the deleted test-measure's law:
-- population pins GATE, absolute ms REPORT, setup/steady separated by
-- windowing; OB-3's run-each-freeze half re-homed here)
-- ---------------------------------------------------------------------

gB6 :: Bool -> TestTree
gB6 mintMode = testGroup "b6 the ms/tick instrument"
  [ testCase "b6a population pin: the base route is 8005 sentences (the #21 live curves' operating point)" $ do
      -- the exact-integer pin (R-D20-i anchor: breadth-author-pack.md
      -- IV P0 at 7b765fa, the K=6 models cell; the closed form below
      -- derives the same integer from the declared grids)
      length (basePop 6) @?= 8005
      baseClosed 6 @?= 8005
  , testCase "b6d the census: every declared-family row is a const/guard shape; NO walk variants (XII.6's gate row)" $ do
      let popH = heirPop 6 brFull
          counts = [ (nm, tagCount nm popH)
                   | nm <- ["const", "walk", "guard", "dpair", "nullconst", "nullguard"] ]
      counts @?= [ ("const", (6 - 1) * ePts)
                 , ("walk", (6 - 1) * rPts)
                 , ("guard", (6 - 1) * nGuards * tPts * ePts * (ePts - 1))
                 , ("dpair", pairClosed s21)
                 , ("nullconst", ePts)
                 , ("nullguard", nGuards * tPts * ePts * (ePts - 1)) ]
      -- no tag outside the census (the partition is exhaustive)
      sum (map snd counts) @?= length popH
  , testCase "b6b the ratio gate at matched depth and window, with the composition record (XIII.5)" $ do
      -- THIS ROW IS THE SITTING'S "GATE b6" (the group name b6 covers
      -- three rows; the minted ratio gate is exactly this one). What
      -- the ratio is a FUNCTION OF, stated: the two routes, the
      -- window, the process position (this group runs LAST - its
      -- mint measured the same position, so the cell is
      -- self-consistent, and driftFrozenMeans!!0 vs compFrozenRo are
      -- the SAME quantity at the two positions, ~0.8% apart), and
      -- fold order. The WARM-UP folds below exist because the first
      -- timed fold otherwise pays the one-time CAF costs: the
      -- mandate round measured a systematic -1.3% ANTI-CONSERVATIVE
      -- bias (the heir ran warm) across three stub runs.
      let agB = sentenceAgent nsC (basePop 6)
          agH = sentenceAgent nsC (heirPop 6 brFull)
          noWalkPop = [ h | h <- basePop 6, tagName h /= "walk" ]
      _ <- timedFold roStep agB (streamC 6 3)   -- warm-up, untimed use
      _ <- timedFold roStep agH (streamC 6 3)   -- warm-up, untimed use
      msB <- timedFold roStep agB (streamC 6 30)
      msH <- timedFold roStep agH (streamC 6 30)
      evB <- timedFold evStep (sentenceAgent nsC (basePop 6)) (streamC 6 30)
      evNW <- timedFold evStep (sentenceAgent nsC noWalkPop) (streamC 6 30)
      wireMs <- wireTiming 30
      let roB = winMean 6 30 msB
          roH = winMean 6 30 msH
          ratio = roH / roB
          evM = winMean 6 30 evB
          walkShare = evM - winMean 6 30 evNW
          wireM = winMean 6 30 wireMs
      printf "  REPORT base ev+ro %.1f ms/tick, heir ev+ro %.1f ms/tick, ratio %.3f (bar %.1f)\n"
             roB roH ratio b6Bar
      printf "  REPORT composition at [6..30]: ev %.1f (frozen %.1f) of which walks %.1f (frozen %.1f); ev+ro %.1f (frozen %.1f); wire %.1f (frozen %.1f)\n"
             evM compFrozenEv walkShare compFrozenWalkShare roB compFrozenRo
             wireM compFrozenWire
      putStrLn "  REPORT a composition change is a LICENSED RE-MINT, never a breadth failure (XIII.5)"
      putStrLn "  REPORT (the wire column is the BASE route BY DESIGN - XIII.5 pins the base's composition; it cannot move when the heir's wire route changes)"
      assertBool "the instrument executed (all means positive)"
                 (all (> 0) [roB, roH, evM, wireM])
      gateOrMint mintMode
        (printf "b6 ratio %.3f <= bar %.1f (heir/base ev+ro, matched depth+window)"
                ratio b6Bar :: String)
        (ratio <= b6Bar)
  ]
  where
    wireTiming :: Int -> IO [Double]
    wireTiming n = do
      let (st1, r1) = serveLine hostStart (helloB Nothing 6)
      unless ("\"ok\": true" `isInfixOf` r1)
             (assertFailure ("wire hello refused: " ++ take 90 r1))
      go st1 (map tickEvOf (streamC 6 n))
      where
        go _ [] = pure []
        go st (l : ls) = do
          t0 <- getCPUTime
          let (st', r) = serveLine st l
          ms <- length r `seq` msSince t0
          (ms :) <$> go st' ls

-- ---------------------------------------------------------------------
-- the drift row — GATED diff-vs-frozen (XIII.5; the acceptance's own
-- instrument: the accepted curve must stay the accepted curve)
-- ---------------------------------------------------------------------

gDrift :: Bool -> TestTree
gDrift mintMode = testGroup "drift (gated diff-vs-frozen)"
  [ testCase "drift-a the base route's deep/shallow mean ratio sits inside the minted band (absolute means printed as a residual, gated in bench/)" $ do
      msB <- timedFold roStep (sentenceAgent nsC (basePop 6)) (streamC 6 300)
      let means = [ winMean lo hi msB | (lo, hi) <- driftWindows ]
          ratio = winMean 151 300 msB / winMean 6 150 msB
      -- (ii), selection-freeze-r1 / register R8: re-mint to RATIO form.  The
      -- absolute-ms band false-reds under box load; the deep/shallow ratio is
      -- FAR more load-robust -- witnessed in a loaded-box rehearsal, the window
      -- means inflated ~97% while this ratio moved ~3.6% -- so IT is the sole
      -- GATE, re-measured on the SAME box gate 5 runs, within driftRatioBand.
      -- What (ii) surrenders: a ratio cannot see a UNIFORM slowdown, and load
      -- still nudges it, so measure and gate on ONE quiet/stable box (do-close.sh
      -- does both in one run).  Absolute-cost regression detection lives in
      -- bench/ (which records its load), BY DESIGN.  The per-window means PRINT
      -- as a residual (no silent cap, EXACT_PLAN 14.1), never asserted.
      forM_ (zip3 driftWindows driftFrozenMeans means) $ \((lo, hi), fz, cur) ->
        printf "  REPORT window [%d..%d] mean %.1f ms (frozen %.1f, %+.1f%% delta; former gate +/-%.0f%%) -- residual, gated in bench/\n"
               lo hi cur fz ((cur - fz) / fz * 100) (driftMeanBand * 100)
      printf "  REPORT deep/shallow mean ratio %.4f (frozen %.4f)\n"
             ratio driftFrozenMeanRatio
      gateOrMint mintMode
        (printf "drift deep/shallow mean ratio %.4f within +/-%.2f of frozen %.4f"
                ratio driftRatioBand driftFrozenMeanRatio :: String)
        (abs (ratio - driftFrozenMeanRatio) <= driftRatioBand)
  ]
