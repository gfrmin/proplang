{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE DataKinds #-}
-- bench/BenchLib.hs — the fold-depth instrument's library half (bench
-- r01): the seed-pinned synthetic worlds, the wire-line generators, the
-- exact-state MIRROR (route 2), the window sampler, reply parsing and
-- the build stamp. bench/BenchFoldDepth.hs is the executable over it;
-- bench/BenchTest.hs its tests. See BenchFoldDepth.hs's header for what
-- is measured and how.
module BenchLib
  ( SM, smSeed, smNext, smUnit, smBern, smChoice
  , Profile (..), TickMode (..), Tick (..)
  , profiles, profileP1, profileP2, profileP2nw, profileP3, profileP3wide
  , profileS1, profileS0
  , helloLine, tickLine, genTicks, predictedModels
  , profileP2real, profileP2realDyadic, p2realProvenance
  , Mirror (..), MLive (..), mirrorStart, mirrorStep, mirrorBits, BitSample (..)
  , mirrorMetaNormalized
  , ibits, qbits
  , fieldAfter, scalarField, actField
  , windowLen, windowStarts, median, quantile
  , procStatusKb, stamp, tryRun
  ) where

import Control.Exception (SomeException, try)
import Data.Bits (shiftR, xor)
import Data.List (intercalate, isPrefixOf, sort)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromMaybe, isJust)
import Data.Ratio (denominator, numerator)
import Data.Word (Word64)
import GHC.Num.Integer (integerLog2)
import System.Directory (getFileSize, getModificationTime)
import System.Environment (getExecutablePath)
import System.IO (Handle)
import System.Info (arch, compilerName, fullCompilerVersion, os)
import System.Process (readProcess)
import Text.Printf (hPrintf)

import PropLang.Belief (Belief, condK, predictMass, push, uniform, weights)
import PropLang.Enumerate (Hyp (..), enumerateWith, enumerateWithBreadth,
                           fragFull, mkBreadth)
import PropLang.Eval (Features, Vals (..), evalx, mkEnvIn)
import PropLang.Syntax (Namespace, mkCarrier, mkGrid, mkNamespace)

import P2Real (p2realArity, p2realClock, p2realCredenceRates, p2realFamilies,
                p2realGuards, p2realMenu, p2realNs,
                p2realOperatingRate, p2realProvenance, p2realRho, p2realSaid,
                p2realTheta)

-- ---------------------------------------------------------------------
-- SplitMix64 (Steele/Lea/Flood 2014; the reference constants)
-- ---------------------------------------------------------------------

newtype SM = SM Word64

smNext :: SM -> (Word64, SM)
smNext (SM s) =
  let s' = s + 0x9E3779B97F4A7C15
      z0 = s'
      z1 = (z0 `xor` (z0 `shiftR` 30)) * 0xBF58476D1CE4E5B9
      z2 = (z1 `xor` (z1 `shiftR` 27)) * 0x94D049BB133111EB
      z3 = z2 `xor` (z2 `shiftR` 31)
  in (z3, SM s')

smSeed :: Int -> SM
smSeed n = SM (fromIntegral n * 0x2545F4914F6CDD1D + 0x9E3779B97F4A7C15)

-- a uniform in [0,1) with 53 random bits
smUnit :: SM -> (Double, SM)
smUnit g = let (w, g') = smNext g
           in (fromIntegral (w `shiftR` 11) / 9007199254740992, g')

smBern :: Double -> SM -> (Bool, SM)
smBern p g = let (u, g') = smUnit g in (u < p, g')

smChoice :: [a] -> SM -> (a, SM)
smChoice xs g = let (u, g') = smUnit g
                    i = min (length xs - 1) (floor (u * fromIntegral (length xs)))
                in (xs !! i, g')

-- ---------------------------------------------------------------------
-- profiles: ONE generator for the hello line and the mirror
-- ---------------------------------------------------------------------

-- Every codebook is declared as a [Double] — the number the wire is
-- SENT (rendered by `show`, which round-trips through the wire's
-- `reads`); the exact rational the door embeds is `realToFrac` of it,
-- and the mirror derives its grids by that same embedding (Host.hs
-- `jQ` at 94fd4eb). Dyadic values (n/16) are the same number both
-- ways; non-dyadic decimals embed as 2^-55-denominator rationals —
-- P3's deliberate lever.
data Profile = Profile
  { pName     :: String
  , pNs       :: [String]            -- namespace, act LAST when present
  , pGuards   :: [(String, [Double])]
  , pMenu     :: Maybe (String, [Double])
  , pTheta    :: [Double]
  , pRho      :: Maybe [Double]
  , pArity    :: Maybe Int
  , pUtility  :: Bool                -- the said@1 utility act*(2y-1)
  -- | The world's OPTIONAL clock row, `(name, price, batch)`.  Absent is the
  --   shipped selection (`chooseEU`); present routes selection through
  --   `policyPick` and makes every decide pay a preposterior at batch depth
  --   B.  The reconstruction had no field for this at all, and the consumer
  --   declares one -- which is the single largest per-decide multiplier the
  --   consumer measured (issue #24: 297 ms vs 135 ms, ~2.2x, structural).
  , pClock    :: Maybe (String, Double, Int)
  -- | Raw `said@1` sentence, verbatim.  `Nothing` keeps the generic
  --   `act*(2y-1)` the synthetic profiles use; `Just` carries a real
  --   consumer sentence through unaltered (P2real: nested `if`s over four
  --   linear arms, deeper than the generic one, re-evaluated per candidate
  --   under `substW` on the substituting route).
  , pSaid     :: Maybe String
  , pTickMode :: TickMode
  , pWorld    :: Int -> Features -> SM -> (Int, SM)  -- outcome given tick
                                                     -- index + features
  , pFeats    :: Int -> SM -> (Features, SM)
  }

-- what a tick carries: evidence+menu (the measured profiles), menu
-- only (sanity S1: decisions over a belief that never moves), or
-- features only (sanity S0: the {"ok": true} pure serve)
data TickMode = EvidenceAndMenu | MenuOnly | PureServe deriving (Eq, Show)

sixteenths :: [Int] -> [Double]
sixteenths = map (\k -> fromIntegral k / 16)

-- P1 minimal: one binary feature, one conditioning per tick, one
-- chooseEU between two sentences (act 0 / act 1). theta = 3 dyadic
-- points; a single guard on the feature; no walks; K = 2.
profileP1 :: Profile
profileP1 = Profile
  { pName = "P1", pNs = ["x", "act"]
  , pGuards = [("x", [0.5])]
  , pMenu = Just ("act", [0, 1])
  , pTheta = sixteenths [4, 8, 12]
  , pRho = Nothing, pArity = Nothing, pUtility = True
  , pClock = Nothing, pSaid = Nothing
  , pTickMode = EvidenceAndMenu
  , pWorld = \_ fs g -> let x = fromMaybe 0 (lookup "x" fs)
                            th = if x > 0 then 0.75 else 0.25
                            (b, g') = smBern th g
                        in (if b then 1 else 0, g')
  , pFeats = \_ g -> let (b, g') = smBern 0.5 g
                     in ([("x", if b then 1 else 0)], g')
  }

-- P2 representative (the consumer's utility-fold SHAPE as recorded on
-- the proplang side — HOSTS_PLAN 6.1/6.2: const + walk families over
-- a grid, one-bit verdicts, an interior menu of three; the exact grid
-- widths of the consumer's example model were NOT readable from the
-- permitted table — see the report's DEVIATIONS/QUESTIONS): two
-- features (a binary stream tag s, a four-level covariate c), guards on
-- both and on the act, a 3-option menu, theta = 9 dyadic points, rho =
-- 4 dyadic points (the walk family declared), K = 2.
profileP2 :: Profile
profileP2 = Profile
  { pName = "P2", pNs = ["s", "c", "act"]
  , pGuards = [("s", [0.5]), ("c", sixteenths [4, 8, 12]), ("act", [0.5, 1.5])]
  , pMenu = Just ("act", [0, 1, 2])
  , pTheta = sixteenths [1, 3, 5, 7, 8, 9, 11, 13, 15]
  , pRho = Just (sixteenths [1, 2, 4, 8])
  , pArity = Nothing, pUtility = True
  , pClock = Nothing, pSaid = Nothing
  , pTickMode = EvidenceAndMenu
  , pWorld = \_ fs g -> let s = fromMaybe 0 (lookup "s" fs)
                            c = fromMaybe 0 (lookup "c" fs)
                            th | s > 0 = 0.8
                               | c > 0.5 = 0.3
                               | otherwise = 0.55
                            (b, g') = smBern th g
                        in (if b then 1 else 0, g')
  , pFeats = \_ g -> let (b, g1) = smBern 0.5 g
                         (cv, g2) = smChoice (sixteenths [2, 6, 10, 14]) g1
                     in ([("s", if b then 1 else 0), ("c", realToFrac cv)], g2)
  }

-- P3 adversarial (the choice and why, stated before running):
--   * theta and rho declared as NON-DYADIC decimals (tenths). The wire
--     embeds binary64 exactly, so 0.1 arrives as a 2^-55-denominator
--     rational with a 52-bit odd numerator: every fold multiplies each
--     weight by such a factor, ~107 bits per tick per hypothesis versus
--     ~4-8 for sixteenths — the largest per-fold growth any declared
--     value can buy through the door. This is the dominant lever.
--   * obs_arity K = 6 (the K-ary route; the breadth suite's recorded
--     consumer operating point): the spread atoms carry (1-theta)/(K-1),
--     so 5^t enters every denominator (+log2 5 bits per tick), the
--     positive-atom families run over K-1 = 5 atoms, and every
--     predictive belief is a 6-point vector (6 predictMassS passes per
--     candidate).
--   * the walk family declared (rho): latents mixed through the move
--     kernel and re-normalized every tick — sums of products, the
--     denominators no longer factor; one rate, so the lever is present
--     without multiplying the population.
--   * theta at FIVE points and one guard (x, one threshold): grid WIDTH
--     is not a per-weight denominator lever (each weight's factors are
--     its own theta's), only a population multiplier, and the
--     calibration pilot showed the 9-point/3-rate variant at ~1 s/tick
--     by tick 30 — unmeasurable past a few hundred ticks. Population is
--     kept small so the per-weight growth can be followed to depth.
--   population = 5x5 consts + 5x1 walks + 5x(1x5x4) guards = 130.
profileP3 :: Profile
profileP3 = Profile
  { pName = "P3", pNs = ["x", "act"]
  , pGuards = [("x", [0.5])]
  , pMenu = Just ("act", [0, 1])
  , pTheta = [0.1, 0.3, 0.5, 0.7, 0.9]
  , pRho = Just [0.3]
  , pArity = Just 6, pUtility = True
  , pClock = Nothing, pSaid = Nothing
  , pTickMode = EvidenceAndMenu
  , pWorld = \_ fs g -> let x = fromMaybe 0 (lookup "x" fs)
                            -- a 6-atom world: atom 3 favoured when x=1,
                            -- atom 1 when x=0, the rest share the remainder
                            ws = if x > 0 then [0.1, 0.1, 0.1, 0.5, 0.1, 0.1]
                                          else [0.1, 0.5, 0.1, 0.1, 0.1, 0.1]
                            (u, g') = smUnit g
                            pick acc i (w : rest) = if u < acc + w then i else pick (acc + w) (i + 1) rest
                            pick _ i [] = i - 1
                        in (pick 0 0 ws, g')
  , pFeats = \_ g -> let (b, g') = smBern 0.5 g
                     in ([("x", if b then 1 else 0)], g')
  }

-- P3wide: the FIRST-DRAFT adversarial world (theta 9 tenths, rho 3
-- rates, K = 6, population 420), kept as a calibration variant: the
-- pilot that priced it is in the report; it is not a protocol cell.
profileP3wide :: Profile
profileP3wide = profileP3
  { pName = "P3wide"
  , pTheta = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
  , pRho = Just [0.1, 0.2, 0.3] }

-- P2nw: P2 with the walk family NOT declared — a calibration variant
-- (attribution of P2's fixed and growing cost to the walk latents),
-- never one of the protocol's three profiles.
profileP2nw :: Profile
profileP2nw = profileP2 { pName = "P2nw", pRho = Nothing }

-- S1 sanity: P1's world, ticks carry the menu but NO evidence — the
-- wire decides every tick over a belief that never moves; per-tick
-- cost must be flat.
-- P2real: the consumer's ACTUAL declaration, not a reconstruction.  Every
-- field below is IMPORTED from P2Real.hs, which bench/gen-p2real.py generates
-- straight out of life-agent's own `handshake_decl` -- THE ONE-GENERATOR LAW:
-- this profile does not re-declare a single value it could import, and
-- `python3 bench/gen-p2real.py --check` is the standing identity row.
--
-- The reconstruction `profileP2` STAYS in the corpus beside this, unchanged,
-- so the delta is visible rather than overwritten.  What it got structurally
-- wrong, and this fixes:
--
--   namespace    3 names           ->  19
--   guard mass   G = 6             ->  G = 17 (17 rows, every arity 1)
--   menu         3 options         ->  4 affordances
--   theta        9 DYADIC points   ->  8 NON-dyadic decimals -- the 2^-55
--                                      embedding LEVER APPLIES here, and the
--                                      reconstruction assumed it did not
--   rho          4 points declared ->  ABSENT: no walk family at all, so the
--                                      report's 78%-of-tick walk attribution
--                                      has no counterpart in the real world
--   clock        no field existed  ->  declared (think, 11.0, batch 1)
--   population   445               ->  960
--
-- The report's two highest-ranked levers therefore BOTH flip direction, one
-- each way, which is exactly why only a re-run settles the operating point.
profileP2real :: Profile
profileP2real = Profile
  { pName = "P2real", pNs = p2realNs
  , pGuards = p2realGuards
  , pMenu = Just p2realMenu
  , pTheta = p2realTheta
  , pRho = p2realRho
  , pArity = p2realArity, pUtility = True
  , pClock = p2realClock, pSaid = Just p2realSaid
  , pTickMode = EvidenceAndMenu
  -- the owner's reaction.  The tick's leader-credence indicator IS a
  -- credence bucket, so that bucket's own rate is the faithful emission
  -- rate; the fallback is the consumer's measured operating rate.
  , pWorld = \_ fs g ->
      let rate = case [ r | (nm, r) <- p2realCredenceRates
                          , lookup nm fs == Just 1 ] of
                   (r : _) -> r
                   []      -> p2realOperatingRate
          (b, g') = smBern rate g
      in (if b then 1 else 0, g')
  -- exact coverage: all 18 non-writable names every tick (`t` plus the 17
  -- indicators), never a sparse vector -- the door refuses anything less,
  -- and `act` must never appear (feature/assignment collision).  One member
  -- per multi-member family is hot; the three standalone flags are
  -- independent Bernoulli(1/2).
  , pFeats = \t g0 ->
      let step (acc, g) (_, members) = case members of
            [only] -> let (b, g') = smBern 0.5 g
                      in (acc ++ [(only, if b then 1 else 0)], g')
            _      -> let (win, g') = smChoice members g
                      in (acc ++ [ (m, if m == win then 1 else 0)
                                 | m <- members ], g')
          (fs, gN) = foldl' step ([], g0) p2realFamilies
      in (("t", fromIntegral t) : fs, gN)
  }

-- P2realDy: THE COUNTERFACTUAL.  The consumer's real declaration with ONE
-- change -- theta snapped to the nearest n/2^10 -- and everything else held
-- identical.  It is DERIVED from profileP2real by record update, so it cannot
-- drift from the world it is a counterfactual of.
--
-- WHY THIS CELL EXISTS.  The r01 report names two host-side levers that
-- "change the constant by an order of magnitude and are decision inputs, not
-- language changes": (a) binary-exact grid values instead of decimals, and
-- (b) the walk family.  The consumer has ALREADY taken (b) -- they declare no
-- walk family at all -- so (a) is the only declaration-side lever they have
-- left, and nothing in the corpus measures it on their world.
--
-- The arithmetic, at the door's own embedding: the eight real rungs cost 856
-- bits of exact numerator+denominator; at 2^-10 they cost 142, a 6.0x
-- reduction, for a worst rung shift of 0.00047 -- INSIDE the consumer's own
-- declared _GRID_COLLISION tolerance of 5e-4.  And the two rungs that matter
-- for #19's placement finding (0.857, the measured operating rate, and 0.864,
-- the shadow p95, which sit 0.007 apart) stay DISTINCT at 2^-10.  So the
-- lever is available to them without moving the KL-projection past their own
-- tolerance; this cell measures what taking it is worth.
profileP2realDyadic :: Profile
profileP2realDyadic = profileP2real
  { pName = "P2realDy"
  , pTheta = map (\x -> fromIntegral (round (x * 1024) :: Integer) / 1024)
                 (pTheta profileP2real)
  }

-- P2real with the clock row REMOVED.  #24's situation exactly: a consumer
-- who declines to declare a `clock` (or cannot -- `{"batch": 0}` is refused
-- `bad hello`, so the preposterior is not opt-out-able) is routed to the
-- NON-SUBSTITUTING fold, `Membrane.chooseEU`, instead of the whole-menu
-- tournament `Membrane.policyPick`.  P2real as DECLARED carries a clock and
-- therefore never takes that path, so it cannot measure it; this variant
-- can.  Everything else is the consumer's real declaration byte for byte --
-- same 19 names, 17 guards, 4 affordances, 8 theta rungs, 960 models -- so
-- the only difference between an A cell and a B cell here is which selection
-- verb `Host.hs` calls.
profileP2realNoClock :: Profile
profileP2realNoClock = profileP2real { pName = "P2realNC", pClock = Nothing }

-- Menu-WIDTH variants of the clockless real world.  `policyPick` builds a
-- whole-menu TOURNAMENT where `chooseEU` folds PAIRWISE, so if the two
-- selection verbs differ in cost at all, the difference lives on the MENU
-- WIDTH axis -- and the consumer's real menu is 4 affordances, too narrow to
-- separate them (measured: +0.19%, inside the within-arm spread).  R-RED --
-- a red is CONSTRUCTED, never owed: build the world where the difference
-- would show rather than reading "no difference" off the one width that
-- cannot show it.
--
-- The theta/guard/rho declaration is UNTOUCHED, so the model population stays
-- 960 across the whole sweep (the menu is the action space, not the
-- hypothesis space) and the sweep isolates SELECTION cost from belief cost.
-- The consumer's real `said@1` keeps its four arms, so acts above 4 all take
-- its final else-arm: per-candidate utility cost is flat across widths, which
-- is what makes the width axis attributable to the selection verb alone.
p2realNCWidth :: Int -> Profile
p2realNCWidth k = profileP2realNoClock
  { pName = "P2realNC" ++ show k
  , pMenu = fmap (\(nm, _) -> (nm, map fromIntegral [1 .. k]))
                 (pMenu profileP2realNoClock)
  }

-- The MECHANISM probe for the width cliff.  `policyPick` builds a comparison
-- tree over all n candidates and evaluates it in ONE env; this engine is
-- exact-`Rational` throughout, so evaluation cost is driven by DENOMINATOR
-- SIZE, not by node count.  The consumer's theta grid is decimal (~2^-55
-- denominators, F5/C25), so a wider tree compounds bigger denominators --
-- which would explain a CLIFF rather than a smooth O(n) growth.
--
-- If that is the mechanism, snapping theta to `2^-10` should flatten the
-- cliff at the SAME width; if the cliff survives, the mechanism is the tree
-- shape and not the arithmetic.  Two-sided either way, which is the point.
p2realNCDyWidth :: Int -> Profile
p2realNCDyWidth k = (p2realNCWidth k)
  { pName = "P2realNCDy" ++ show k
  , pTheta = map (\x -> fromIntegral (round (x * 1024) :: Integer) / 1024)
                 (pTheta profileP2realNoClock)
  }

profileS1 :: Profile
profileS1 = profileP1 { pName = "S1", pTickMode = MenuOnly }

-- S0 sanity: P1's world, ticks carry features only — {"ok": true}.
profileS0 :: Profile
profileS0 = profileP1 { pName = "S0", pTickMode = PureServe }

profiles :: [Profile]
profiles = [profileP1, profileP2, profileP2nw, profileP2real,
            profileP2realDyadic, profileP2realNoClock,
            profileP3, profileP3wide, profileS1, profileS0]
           ++ map p2realNCWidth [8, 16, 32, 64]
           ++ map p2realNCDyWidth [8, 16, 32]

-- ---------------------------------------------------------------------
-- rendering the wire lines (from the profile's Doubles, one generator)
-- ---------------------------------------------------------------------

rD :: Double -> String
rD d | d == fromIntegral (round d :: Integer) = show (round d :: Integer)
     | otherwise = show d

-- | The population the engine's enumerator produces for a declaration:
--
--     models = (K-1) * (n_theta + n_rho + G * n_theta * (n_theta - 1))
--
-- where G is the summed guard-grid mass, n_theta\/n_rho the codebook sizes
-- (n_rho = 0 when no walk family is declared) and K the observation arity
-- (2 when `obs_arity` is absent).  This is a DERIVED prediction, never a
-- trusted one: the driver asserts it against the host's own `models` reply
-- for every profile before a single tick is timed, so a profile that drifts
-- from the declaration it means to measure fails loudly at cell start
-- instead of quietly reporting the wrong world's cost.
--
-- Checked by hand against the shipped host at 94fd4eb on five independent
-- points (G=1\/3\/17 at n=5 K=2, and K=3\/4 at G=17) plus the consumer's real
-- declaration (960); the assertion below is what keeps it honest thereafter.
predictedModels :: Profile -> Int
predictedModels p =
  let g = sum (map (length . snd) (pGuards p))
      n = length (pTheta p)
      nr = maybe 0 length (pRho p)
      k = fromMaybe 2 (pArity p)
  in (k - 1) * (n + nr + g * n * (n - 1))

rGrid :: [Double] -> String
rGrid ds = "[" ++ intercalate ", " (map rD ds) ++ "]"

helloLine :: Profile -> String
helloLine p =
  "{\"membrane\": 1, \"world\": {"
  ++ "\"namespace\": [" ++ intercalate ", " (map show (pNs p)) ++ "], "
  ++ "\"guards\": [" ++ intercalate ", "
       [ "{\"name\": " ++ show nm ++ ", \"grid\": " ++ rGrid g ++ "}"
       | (nm, g) <- pGuards p ] ++ "], "
  ++ "\"menu\": [" ++ maybe "" (\(nm, g) -> "{\"name\": " ++ show nm
                                   ++ ", \"grid\": " ++ rGrid g ++ "}") (pMenu p) ++ "], "
  ++ maybe "" (\k -> "\"obs_arity\": " ++ show k ++ ", ") (pArity p)
  ++ "\"codebooks\": {\"theta\": " ++ rGrid (pTheta p)
  ++ maybe "" (\r -> ", \"rho\": " ++ rGrid r) (pRho p) ++ "}"
  ++ maybe "" (\(nm, pr, b) -> ", \"clock\": [{\"name\": " ++ show nm
                 ++ ", \"price\": " ++ rD pr
                 ++ ", \"batch\": " ++ show b ++ "}]") (pClock p)
  ++ (if pUtility p
        then ", \"utility\": {\"form\": \"said@1\", \"said\": "
             ++ (case pSaid p of
                   Just sd -> sd
                   Nothing -> "[\"*\", [\"get\", "
                              ++ show (maybe "act" fst (pMenu p)) ++ "], "
                              ++ "[\"-\", [\"+\", [\"var\", 1], [\"var\", 1]], [\"c\", 1]]]")
             ++ "}"
        else "")
  ++ "}}"

rQ :: Rational -> String
rQ q = rD (fromRational q)

tickLine :: Profile -> Features -> Maybe Int -> String
tickLine p fs mev =
  "{\"tick\": {\"features\": {"
  ++ intercalate ", " [ show nm ++ ": " ++ rQ v | (nm, v) <- fs ] ++ "}"
  ++ (case (pTickMode p, pMenu p) of
        (PureServe, _) -> ""
        (_, Just (nm, _)) -> ", \"menu\": [" ++ show nm ++ "]"
        (_, Nothing) -> "")
  ++ maybe "" (\y -> ", \"evidence\": " ++ show y) mev
  ++ "}}"

-- the tick stream: (features, evidence) per tick index, seed-pinned
-- and PREFIX-STABLE (tick t depends only on the seed and t's draws)
data Tick = Tick { tFeats :: Features, tEv :: Maybe Int }

genTicks :: Profile -> Int -> Int -> [Tick]
genTicks p seed n = go 1 (smSeed seed)
  where
    go t g | t > n = []
           | otherwise =
               let (fs, g1) = pFeats p t g
                   (y, g2) = pWorld p t fs g1
                   ev = case pTickMode p of
                          EvidenceAndMenu -> Just y
                          _ -> Nothing
               in Tick fs ev : go (t + 1) g2

-- ---------------------------------------------------------------------
-- the mirror (route 2): the engine's exact state through exported verbs
-- ---------------------------------------------------------------------

data MLive = MLive Hyp (Belief Rational)
data Mirror = Mirror Namespace [Rational] [MLive]

-- the enumeration call shape, COPY of Host.hs `hello` at 94fd4eb (the
-- `pop` binding: absent arity = enumerateWith; declared arity = the
-- breadth route with the empty declaration)
mirrorStart :: Profile -> Mirror
mirrorStart p =
  let ns = case pNs p of
        (n0 : rest) -> mkNamespace (n0 :| rest)
        [] -> error "profile: empty namespace"
      emb :: Double -> Rational
      emb = realToFrac
      grid nm ds = case map emb ds of
        (q : qs) -> mkGrid nm (q :| qs)
        [] -> error "profile: empty grid"
      thetaG = grid "theta" (pTheta p)
      mRhoG = fmap (grid "rho") (pRho p)
      gs = [ (nm, grid nm ds) | (nm, ds) <- pGuards p ]
      kA = fromMaybe 2 (pArity p)
      obsC = mkCarrier "obs" (0 :| [1 .. kA - 1])
      pop = case pArity p of
        Nothing -> enumerateWith ns obsC thetaG gs mRhoG fragFull
        Just k -> case mkBreadth k [] False of
          Just br -> enumerateWithBreadth br k ns obsC thetaG gs mRhoG fragFull
          Nothing -> error "mirror: mkBreadth refused the empty declaration"
  in Mirror ns (map hypW pop) [ MLive h (uniform (hypLatent h)) | h <- pop ]

-- COPY of Enumerate.hs `observeS`/`tickPred` at 94fd4eb, through the
-- exported Belief verbs: returns the tick's marginal and the new mirror
mirrorStep :: Features -> Int -> Mirror -> Either String (Rational, Mirror)
mirrorStep feats y (Mirror ns ws lives) = do
  env <- mkEnvIn ns feats VNil
  let predOf (MLive h lat) = do
        k <- evalx (hypEmit h) env
        predLat <- case hypMove h of
          Nothing -> Just lat
          Just mv -> do
            mk <- evalx mv env
            Just (push lat mk)
        Just (predLat, k)
      preds = map predOf lives
      pm p = case p of
        Nothing -> 0
        Just (predLat, k) -> predictMass predLat k y
      masses = map pm preds
      z = sum ws
      marginal = sum (zipWith (*) ws masses) / z
      ws' = zipWith (*) ws masses
      absorb hl@(MLive h _) p = case (hypMove h, p) of
        (Just _, Just (predLat, k)) -> case condK predLat k y of
          Just lat' -> MLive h lat'
          Nothing -> hl
        _ -> hl
      lives' = zipWith absorb lives preds
  if marginal <= 0
    then Left "impossible evidence"
    else Right (marginal, Mirror ns ws' lives')

-- bits of an integer: integerLog2 |n| + 1 (0 counts as 1)
ibits :: Integer -> Int
ibits 0 = 1
ibits n = fromIntegral (integerLog2 (abs n)) + 1

qbits :: Rational -> Int
qbits q = ibits (numerator q) + ibits (denominator q)

-- meta total bits, meta max per-hypothesis bits, meta count,
-- latent total bits, latent weight count
data BitSample = BitSample !Int !Int !Int !Int !Int

mirrorBits :: Mirror -> BitSample
mirrorBits (Mirror _ ws lives) =
  let mb = map qbits ws
      lat = [ qbits w | MLive h b <- lives, isJust (hypMove h), w <- weights b ]
  in BitSample (sum mb) (maximum (0 : mb)) (length mb) (sum lat) (length lat)

-- ---------------------------------------------------------------------
-- reply parsing (host side)
-- ---------------------------------------------------------------------

fieldAfter :: String -> String -> Maybe String
fieldAfter key s = go s
  where
    k = "\"" ++ key ++ "\": "
    go r | k `isPrefixOf` r = Just (drop (length k) r)
         | otherwise = case r of
             [] -> Nothing
             (_ : t) -> go t

scalarField :: String -> String -> Maybe String
scalarField key s = takeWhile (`notElem` (",}]" :: String)) <$> fieldAfter key s

-- the act object {"name": v, ...} rendered by Host.hs rAct
actField :: String -> Maybe Features
actField s = do
  r <- fieldAfter "act" s
  case r of
    ('{' : body) -> pairs (takeWhile (/= '}') body)
    _ -> Nothing
  where
    pairs "" = Just []
    pairs b = mapM pair (splitOn ", " b)
    pair kv = case break (== ':') kv of
      (kq, ':' : ' ' : v) -> do
        nm <- case reads kq of
          [(n, "")] -> Just n
          _ -> Nothing
        d <- case reads v :: [(Double, String)] of
          [(x, "")] -> Just x
          _ -> Nothing
        Just (nm, realToFrac d)
      _ -> Nothing
    splitOn sep str = case breakOn sep str of
      (a, Nothing) -> [a]
      (a, Just rest) -> a : splitOn sep rest
    breakOn sep str = go "" str
      where
        go acc r | sep `isPrefixOf` r = (reverse acc, Just (drop (length sep) r))
                 | otherwise = case r of
                     [] -> (reverse acc, Nothing)
                     (c : t) -> go (c : acc) t

-- ---------------------------------------------------------------------
-- windows: log-spaced starts, 100 ticks each
-- ---------------------------------------------------------------------

windowLen :: Int
windowLen = 100

windowStarts :: Int -> [Int]
windowStarts n =
  let cands = [1] ++ [ m * 10 ^ k | k <- [0 .. 6 :: Int], m <- [1, 2, 3, 5, 7] ]
      inRange i = i >= 1 && i + windowLen - 1 <= n
      lastW = n - windowLen + 1
  in uniq (sort (filter inRange (cands ++ [lastW])))
  where
    uniq (a : b : r) | a == b = uniq (b : r)
                     | otherwise = a : uniq (b : r)
    uniq r = r

median :: [Double] -> Double
median [] = 0 / 0
median xs = let s = sort xs; n = length s
            in if odd n then s !! (n `div` 2)
               else (s !! (n `div` 2 - 1) + s !! (n `div` 2)) / 2

quantile :: Double -> [Double] -> Double
quantile _ [] = 0 / 0
quantile q xs = let s = sort xs; n = length s
                    i = min (n - 1) (max 0 (floor (q * fromIntegral (n - 1))))
                in s !! i

-- ---------------------------------------------------------------------
-- /proc reads
-- ---------------------------------------------------------------------

procStatusKb :: String -> IO Int
procStatusKb key = do
  r <- try (readFile "/proc/self/status") :: IO (Either SomeException String)
  case r of
    Left _ -> pure (-1)
    Right s -> pure $ case [ l | l <- lines s, (key ++ ":") `isPrefixOf` l ] of
      (l : _) -> case words l of
        (_ : v : _) -> read v
        _ -> -1
      [] -> -1

-- ---------------------------------------------------------------------
-- build stamp (OB-32)
-- ---------------------------------------------------------------------

stamp :: Handle -> IO ()
stamp h = do
  exe <- getExecutablePath
  sz <- getFileSize exe
  mt <- getModificationTime exe
  sha <- tryRun "sha256sum" [exe]
  hd <- tryRun "git" ["rev-parse", "--short", "HEAD"]
  srcT <- tryRun "git" ["rev-parse", "HEAD:src"]
  dirty <- tryRun "git" ["status", "--porcelain", "src"]
  hPrintf h "# BUILD-STAMP exe=%s size=%d mtime=%s %s-%s %s-%s\n"
    exe sz (show mt) compilerName (show fullCompilerVersion) os arch
  hPrintf h "# BUILD-STAMP sha256=%s HEAD=%s src-tree=%s src-dirty=%d\n"
    (takeWhile (/= ' ') sha) (oneLine hd) (oneLine srcT)
    (length (filter (not . null) (lines dirty)))
  where
    oneLine = takeWhile (/= '\n')

tryRun :: String -> [String] -> IO String
tryRun cmd args = do
  r <- try (readProcess cmd args "") :: IO (Either SomeException String)
  pure (either (const "unavailable") id r)


-- | The mirror's meta weights normalized (the metaPosterior view of the
-- engine's exported surface — the test's exact-equality pin).
mirrorMetaNormalized :: Mirror -> [Rational]
mirrorMetaNormalized (Mirror _ ws _) = let z = sum ws in [ w / z | w <- ws ]
