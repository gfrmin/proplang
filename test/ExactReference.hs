{-# LANGUAGE GHC2021 #-}
-- THE GENERATOR of the frozen exact anchors (R14: a generator of frozen data is NOT a prototype — it lands in-tree, the successor of audit/capture_oracle.py): the FULL exact-rational reference
-- pipeline — grid-agnostic engine over a declared World, weight-form
-- (II) emissions, exact meta/latent updates — run against the FROZEN
-- observation streams (imported from test/Streams.hs, the artifact
-- itself: R-D20-i copy-not-reconstruct at its strongest) and compared
-- against the frozen Double anchors (imported from test/Anchors.hs).
--
-- Anchor movement in continuous quantities is THE CORRECTION (the
-- author: "we're choosing between right and wrong"); discrete-story
-- anchors (actions, consult ticks, MAP program, tick counts,
-- enumeration counts) are expected to REPRODUCE, and any discrete
-- movement is surfaced.
--
-- E3 note: every point-set below sits in the WORLD block; the engine
-- functions below it are grid-agnostic.
module Main (main) where
--
-- LINEAGE: adapted from the A1 evidence program (ExactPipeline.hs,
-- session record) at the R1-R16 repair sitting. Emit mode ("anchors")
-- regenerates test/Anchors.hs' content from the frozen streams; the
-- probe-tick rule is DECLARED below (tests_acceptance.py's own rule:
-- t mod 20 == 0 or even t in [58, 76]), never read from an anchor file.

import Data.List (maximumBy)
import Data.Ord (comparing)
import Data.Ratio ((%))
import System.Environment (getArgs)


import Streams (buffer36, drift400, flat400, shifted160)

type Q = Rational

-- ---------------------------------------------------------------------
-- THE WORLD DECLARATION (the only home of concrete point-sets)
-- ---------------------------------------------------------------------

thetaG :: [Q]
thetaG = [1 % 10, 2 % 10, 3 % 10, 4 % 10, 5 % 10, 6 % 10, 7 % 10, 8 % 10, 9 % 10]

tauG :: [Q]
tauG = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80]

rhoG :: [Q]
rhoG = [1 % 100, 2 % 100, 5 % 100, 1 % 10, 2 % 10, 3 % 10, 4 % 10, 5 % 10]

-- ---------------------------------------------------------------------
-- Models and the exact prior (widths verified by A2: 36 / 16 / 82944)
-- ---------------------------------------------------------------------

data Model = MBern Int | MWalk Int | MGuard Int Int Int
  deriving (Eq, Show)

enumModels :: [String] -> [Model]
enumModels allowed =
     [ MBern k | has "bern", has "c", k <- idx thetaG ]
  ++ [ MWalk j | has "hmm", has "c", j <- idx rhoG ]
  ++ [ MGuard kt a b
     | all has ["bern", "if", "c", "get", ">"]
     , kt <- idx tauG, a <- idx thetaG, b <- idx thetaG, a /= b ]
  where
    has x = x `elem` allowed
    idx g = [0 .. length g - 1]

fullAllowed :: [String]
fullAllowed = ["bern", "hmm", "if", "c", "get", ">"]

wModel :: Model -> Q
wModel m = case m of
  MBern {}  -> 1 % 36
  MWalk {}  -> 1 % 16
  MGuard {} -> 1 % 82944

-- ---------------------------------------------------------------------
-- The grid-agnostic exact engine
-- ---------------------------------------------------------------------

-- reflected random walk, one exact step of the latent
stepWalk :: Q -> [Q] -> [Q]
stepWalk rho lat = [ sum [ li * t i j | (li, i) <- zip lat [0 ..] ]
                   | j <- [0 .. n - 1] ]
  where
    n = length lat
    t i j
      | j == i = 1 - rho
      | j == lo && j == hi = rho
      | j == lo || j == hi = rho / 2
      | otherwise = 0
      where
        lo = if i > 0 then i - 1 else i + 1
        hi = if i < n - 1 then i + 1 else i - 1

data HypSt = StBern Q | StGuard Q Q Q | StWalk Q [Q]

initSt :: Model -> HypSt
initSt m = case m of
  MBern k       -> StBern (thetaG !! k)
  MWalk j       -> StWalk (rhoG !! j) (map (const (1 % 9)) thetaG)
  MGuard kt a b -> StGuard (tauG !! kt) (thetaG !! a) (thetaG !! b)

-- per-tick predictive P(y=1) plus the post-observation state
p1And :: Int -> HypSt -> (Q, Int -> HypSt)
p1And t st = case st of
  StBern th -> (th, const st)
  StGuard tau a b -> (if fromIntegral t > tau then a else b, const st)
  StWalk rho lat ->
    let predLat = stepWalk rho lat
        p1 = sum (zipWith (*) predLat thetaG)
        absorb y =
          let ms = [ pl * (if y == 1 then th else 1 - th)
                   | (pl, th) <- zip predLat thetaG ]
              z = sum ms
          in StWalk rho (map (/ z) ms)
    in (p1, absorb)

data AgentX = AgentX Int [Q] [HypSt]   -- tick, meta weights (unnormalized, exact), states

axT :: AgentX -> Int
axT (AgentX t _ _) = t

mkAgent :: [Model] -> AgentX
mkAgent ms = AgentX 0 (map wModel ms) (map initSt ms)

-- one observation: returns the tick's predictive marginal (exact) and
-- the updated agent; learn=False is the deletion audit's frozen agent
-- (cond deleted: weights and latents never move; t still advances)
observeX :: Bool -> AgentX -> Int -> (Q, AgentX)
observeX learn (AgentX t ws sts) y =
  let pairs = [ (p1, ab) | st <- sts, let (p1, ab) = p1And t st ]
      py (p1, _) = if y == 1 then p1 else 1 - p1
      z = sum ws
      marginal = sum (zipWith (\w pr -> w * py pr) ws pairs) / z
      ws' = if learn then zipWith (\w pr -> w * py pr) ws pairs else ws
      sts' = if learn then [ ab y | (_, ab) <- pairs ] else sts
  in (marginal, AgentX (t + 1) ws' sts')

predictive1 :: AgentX -> Q
predictive1 (AgentX t ws sts) =
  sum (zipWith (\w st -> w * fst (p1And t st)) ws sts) / sum ws

entropyBits :: AgentX -> Double
entropyBits (AgentX _ ws _) =
  let z = sum ws
      ps = [ fromRational (w / z) :: Double | w <- ws, w > 0 ]
  in sum [ negate (p * logBase 2 p) | p <- ps ]

mapModel :: [Model] -> AgentX -> (Model, Q)
mapModel ms (AgentX _ ws _) =
  let (m, w) = maximumBy (comparing snd) (zip ms ws)
  in (m, w / sum ws)

-- CL-3 argmax: first-listed incumbent, strict > displaces
argmaxCL3 :: [(a, Q)] -> (a, Q)
argmaxCL3 []             = error "argmaxCL3: empty"
argmaxCL3 ((a0, v0) : r) = foldl' step (a0, v0) r
  where step (b, bv) (c, cv) = if cv > bv then (c, cv) else (b, bv)

-- ---------------------------------------------------------------------
-- TEST 1 — changing world
-- ---------------------------------------------------------------------

t1Util :: Q -> [(String, Q)]
t1Util p1 =
  [ ("predict1", 2 * p1 - 1)
  , ("predict0", 1 - 2 * p1)
  , ("consult", 35 % 100)
  ]

runT1 :: ([(Int, Q, String, Double)], (Model, Q), Q)
runT1 = go (mkAgent ms) shifted160 [] 1
  where
    ms = enumModels fullAllowed
    go ag [] acc marg = (reverse acc, mapModel ms ag, marg)
    go ag (y : ys) acc marg =
      let p1 = predictive1 ag
          (act, _) = argmaxCL3 (t1Util p1)
          h = entropyBits ag
          row = (axT ag, p1, act, h)
          (m, ag') = observeX True ag y
      in go ag' ys (row : acc) (marg * m)

-- ---------------------------------------------------------------------
-- TEST 2 — lazy genius (exact deliberation)
-- ---------------------------------------------------------------------

condTheta :: [Q] -> Int -> ([Q], Q)          -- (posterior, predictive mass)
condTheta b y =
  let ms = [ w * (if y == 1 then th else 1 - th) | (w, th) <- zip b thetaG ]
      z = sum ms
  in (map (/ z) ms, z)

vAct :: [Q] -> Q
vAct b = snd (argmaxCL3 [ ("L", eL), ("R", eR) ])
  where
    eR = sum [ w * (2 * th - 1) | (w, th) <- zip b thetaG ]
    eL = negate eR

vThink :: [Q] -> Int -> Q -> Q
vThink b bufLen price = total - price
  where
    batchN = min 3 bufLen
    seqs = foldl' (\ss _ -> [ s ++ [y] | s <- ss, y <- [0, 1] ]) [[]]
                  [1 .. batchN]
    total = sum
      [ mass * vAct bb
      | s <- seqs
      , let (bb, mass) = foldl'
              (\(bAcc, mAcc) y -> let (b', m) = condTheta bAcc y
                                  in (b', mAcc * m))
              (b, 1) s ]

runDelib :: Q -> [Int] -> (Int, String)
runDelib price buf0 = go (map (const (1 % 9)) thetaG) buf0 0
  where
    go b buf ticks =
      let acts = ("act", vAct b)
               : [ ("think", vThink b (length buf) price) | not (null buf) ]
          (choice, _) = argmaxCL3 acts
      in if choice == "act"
           then (ticks, finalAct b)
           else
             let (b', _) = foldl' (\(bb, m) y ->
                             let (b2, mm) = condTheta bb y in (b2, m * mm))
                           (b, 1 :: Q) (take 3 buf)
             in go b' (drop 3 buf) (ticks + 1)
    finalAct b = fst (argmaxCL3 [ ("L", eL b), ("R", eR b) ])
    eR b = sum [ w * (2 * th - 1) | (w, th) <- zip b thetaG ]
    eL b = negate (eR b)

-- ---------------------------------------------------------------------
-- TEST 3 — forgetting trap
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- TEST 4 — deletion audit
-- ---------------------------------------------------------------------

llOver :: [Model] -> Bool -> [Int] -> (Q, Double)
llOver ms learn ys =
  let marg = snd (foldl' (\(ag, m) y ->
               let (mm, ag') = observeX learn ag y in (ag', m * mm))
               (mkAgent ms, 1) ys)
  in (marg, negate (logBase 2 (fromRational marg)))

-- ---------------------------------------------------------------------

showModel :: Model -> String
showModel (MBern k) = "bern theta[" ++ show k ++ "]"
showModel (MWalk j) = "hmm rho[" ++ show j ++ "]"
showModel (MGuard kt a b) =
  "bern(if t>tau[" ++ show kt ++ "] theta[" ++ show a ++ "] theta["
  ++ show b ++ "])"

-- ---------------------------------------------------------------------
-- D1: the exact-anchor emitter ("anchors" mode). Emits the successor
-- anchor module's content — every exact quantity as a Rational literal
-- derived from THIS executed reference (provenance = this file), every
-- display quantity as the Double the reporting edge computes from it.
-- ---------------------------------------------------------------------

forgetterMarg :: Q -> [Int] -> Q
forgetterMarg gamma ys = prod
  where
    (_, _, prod) = foldl' step (1, 1, 1 :: Q) ys
    step (a, b, acc) y =
      let p = a / (a + b)
          term = if y == 1 then p else 1 - p
      in (gamma * a + fromIntegral y, gamma * b + fromIntegral (1 - y),
          acc * term)

emitAnchors :: IO ()
emitAnchors = do
  let ms = enumModels fullAllowed
      (timeline, (mapHyp, mapP), m160) = runT1
      probeTs = [ t | t <- [0 .. 159], t `mod` 20 == 0 || (t >= 58 && t <= 76 && even t) ]
  putStrLn "-- GENERATED by the exact reference pipeline (ExactPipeline.hs,"
  putStrLn "-- the A1 R-D21 evidence program) — DO NOT EDIT. Every Rational"
  putStrLn "-- is the exact value; every Double is the reporting-edge display"
  putStrLn "-- computed from it. Node price 1/10 does not enter these rows:"
  putStrLn "-- the corpus prior is family-width priced (36/16/82944, A2)."
  putStrLn "module Anchors where"
  putStrLn ""
  putStrLn "import Data.Ratio ((%))"
  putStrLn ""
  putStrLn "-- TEST 1: (t, P(y=1) exact, action, H bits display)"
  putStrLn "t1ProbeRowsX :: [(Int, Rational, String, Double)]"
  putStrLn "t1ProbeRowsX ="
  let rows = [ r | r@(t, _, _, _) <- timeline, t `elem` probeTs ]
      showRow (t, p, a, h) = "(" ++ show t ++ ", " ++ show p ++ ", "
                             ++ show a ++ ", " ++ show h ++ ")"
  mapM_ (\(i, r) -> putStrLn ((if i == (0 :: Int) then "  [ " else "  , ")
                              ++ showRow r)) (zip [0 ..] rows)
  putStrLn "  ]"
  putStrLn ""
  putStrLn "t1ConsultTicksX :: [Int]"
  putStrLn ("t1ConsultTicksX = "
            ++ show [ t | (t, _, a, _) <- timeline, a == "consult" ])
  putStrLn ""
  putStrLn "-- MAP: guard family, (tau, thetaA, thetaB) indices; exact posterior"
  putStrLn "t1MapIndicesX :: (Int, Int, Int)"
  case mapHyp of
    MGuard kt a b -> putStrLn ("t1MapIndicesX = " ++ show (kt, a, b))
    _ -> putStrLn ("t1MapIndicesX = error \"MAP not a guard: "
                   ++ showModel mapHyp ++ "\"")
  putStrLn "t1MapPosteriorX :: Rational"
  putStrLn ("t1MapPosteriorX = " ++ show mapP)
  putStrLn "t1MarginalX :: Rational   -- 160-tick cumulative, exact"
  putStrLn ("t1MarginalX = " ++ show m160)
  let hs59 = [ h | (t, _, _, h) <- timeline, t == 59 ]
      hpm = maximum [ h | (t, _, _, h) <- timeline, t >= 60, t < 90 ]
  putStrLn "t1HPreX, t1HPostMaxX :: Double"
  putStrLn ("t1HPreX = " ++ show (case hs59 of { (h : _) -> h; [] -> 0 }))
  putStrLn ("t1HPostMaxX = " ++ show hpm)
  putStrLn ""
  putStrLn "-- TEST 2: (price exact, thinking ticks, final act)"
  putStrLn "t2RowsX :: [(Rational, Int, String)]"
  let t2 = [ (p, runDelib p buffer36)
           | p <- [3 % 10, 5 % 100, 5 % 1000, 0] ]
  putStrLn ("t2RowsX = " ++ show [ (p, n, a) | (p, (n, a)) <- t2 ])
  putStrLn ""
  putStrLn "-- TEST 3: exact cumulative marginals (log-loss = -log2, display)"
  let (mDrift, llD) = llOver ms True drift400
      (mFlat, llF) = llOver ms True flat400
  putStrLn "t3AgentDriftMargX, t3AgentFlatMargX :: Rational"
  putStrLn ("t3AgentDriftMargX = " ++ show mDrift)
  putStrLn ("t3AgentFlatMargX = " ++ show mFlat)
  putStrLn "t3AgentDriftLLX, t3AgentFlatLLX :: Double"
  putStrLn ("t3AgentDriftLLX = " ++ show llD)
  putStrLn ("t3AgentFlatLLX = " ++ show llF)
  putStrLn "-- the quarantined forgetter (exact gamma, exact product)"
  putStrLn "t3ForgetterRowsX :: [(Rational, Double, Double)]"
  let gs = [4 % 5, 9 % 10, 19 % 20, 49 % 50, 1]
      fRow g = (g, dsp' (forgetterMarg g drift400),
                   dsp' (forgetterMarg g flat400))
      dsp' q = negate (logBase 2 (fromRational q)) :: Double
  putStrLn ("t3ForgetterRowsX = " ++ show (map fRow gs))
  putStrLn ""
  putStrLn "-- TEST 4: the deletion table, exact"
  let (mFroz, _) = llOver ms False shifted160
      (mFull, llFull') = llOver ms True shifted160
      (mNoif, llNoif') = llOver (enumModels ["bern", "hmm", "c", "get", ">"]) True shifted160
      (mNoget, llNoget') = llOver (enumModels ["bern", "hmm", "c", "if", ">"]) True shifted160
      d250 = take 250 drift400
      (mFullD, llFullD') = llOver ms True d250
      (mNohmm, llNohmm') = llOver (enumModels ["bern", "if", "c", "get", ">"]) True d250
  putStrLn "t4FrozenIsExactlyHalfPerTickX :: Bool"
  putStrLn ("t4FrozenIsExactlyHalfPerTickX = "
            ++ show (mFroz == 1 % (2 ^ (160 :: Int)))
            ++ "   -- marginal == 2^-160, the symmetry theorem")
  putStrLn "t4MargFullX, t4MargNoifX, t4MargNogetX, t4MargFullDX, t4MargNohmmX :: Rational"
  putStrLn ("t4MargFullX = " ++ show mFull)
  putStrLn ("t4MargNoifX = " ++ show mNoif)
  putStrLn ("t4MargNogetX = " ++ show mNoget)
  putStrLn ("t4MargFullDX = " ++ show mFullD)
  putStrLn ("t4MargNohmmX = " ++ show mNohmm)
  putStrLn "t4LlDisplayX :: [Double]  -- full, noif, noget, fullD, nohmm"
  putStrLn ("t4LlDisplayX = " ++ show [llFull', llNoif', llNoget', llFullD', llNohmm'])
  putStrLn "t4CountsX :: (Int, Int, Int)  -- full, noc, nobern"
  putStrLn ("t4CountsX = " ++ show
            ( length ms
            , length (enumModels ["bern", "hmm", "if", "get", ">"])
            , length (enumModels ["if", "c", "get", ">"]) ))

main :: IO ()
main = do
  args <- getArgs
  if args == ["anchors"] then emitAnchors
    else putStrLn "usage: exact-reference anchors   (emits the anchor module content)"
