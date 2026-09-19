{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
-- #26 witness, in-process leg (throwaway probe; R-D21 -- the transcript rides the record).
--
-- Reads a leg file written by probe-wire.py --dump (the ONE stream; nothing here re-declares
-- the world), rebuilds the population with the call Host.hs makes at 571b589 -- the binding
--   pop = enumerateWith nsN obsC thetaG gs mRhoG fragFull
-- with obsC = mkCarrier "obs" (0 :| [1]) (arity absent) -- folds the evidence with observeS,
-- and ASSERTS every probe's predictMassS equals the wire's p1 bit-for-bit (as a Double,
-- the wire's own `show (fromRational p1 :: Double)`).  Then it reads metaPosterior by cut.
--
-- Leg C (the depth question), two pricings of the two-cut sentences
--   If (Gt (Get g1) c) ta (If (Gt (Get g2) c) tb tc)      g1 = ge90, g2 = p-none=ge50
-- every body checked inCorpus:
--   C-g  ONE pricer, weightIn -- the grammar's own weight (R17's normative prior) -- over
--        consts + single cuts on g1, g2 (depth 1) and the same plus the two-cuts (depth 2).
--   C-x  the SHIPPED selector population (Host.hs's pop, its own charges) plus the two-cuts
--        over {g1, g2}, each charged the shipped guard charge times ONE MORE factor of the
--        shipped guard-to-const ratio.  THAT PRICE IS THE BUILDER'S EXTENSION: the selector
--        has no two-cut production and nothing shipped or ruled prices one.  The single-cut kernel below is a COPY of Enumerate.hs's
-- `bernBody`/`guardFamily` shape at 571b589, and the probe asserts the copy against the
-- shipped family extensionally (same weightIn, same prediction at every probe) before use.
--
-- Build: ghc -isrc -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns
--          -XGHC2021 -hide-all-packages -package base -package containers
--          issues-2026-09-19/probe-mass.hs
-- Run:   probe-mass <dump-dir> [--no-c]   (expects leg-B.world and leg-Bp.world)
module Main (main) where

import Control.Monad (foldM, forM_, unless)
import Data.List (sortBy)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ord (comparing, Down (..))
import System.Environment (getArgs)
import System.Exit (die)

import PropLang.Belief (mkSpace)
import PropLang.Enumerate
import PropLang.Eval (Features)
import PropLang.Syntax hiding (World (..))

data World = World
  { wNs :: [Name]
  , wGuards :: [(Name, [Rational])]
  , wTheta :: [Rational]
  , wAct :: (Name, Rational)
  , wEv :: [(Int, Features)]
  , wProbes :: [(String, String, Int, Int, Double, Features)]
  }

q :: String -> Rational
q s = toRational (read s :: Double)   -- the wire's jQ: realToFrac of the parsed Double

feat :: String -> (Name, Rational)
feat kv = case break (== '=') (reverse kv) of
  (rv, '=' : rk) -> (reverse rk, q (reverse rv))
  _ -> error ("bad feature " ++ kv)

parseWorld :: String -> World
parseWorld = foldl step (World [] [] [] ("", 0) [] []) . map words . lines
  where
    step w ("ns" : ns) = w { wNs = ns }
    step w ("guard" : nm : vs) = w { wGuards = wGuards w ++ [(nm, map q vs)] }
    step w ("theta" : vs) = w { wTheta = map q vs }
    step w ["act", nm, v] = w { wAct = (nm, q v) }
    step w ("ev" : y : fs) = w { wEv = wEv w ++ [(read y, map feat fs)] }
    step w ("probe" : lc : pn : n : k : p1 : fs) =
      w { wProbes = wProbes w ++ [(lc, pn, read n, read k, read p1, map feat fs)] }
    step _ l = error ("bad line " ++ unwords l)

ne :: [a] -> NonEmpty a
ne (x : xs) = x :| xs
ne [] = error "empty"

orDie :: Either String a -> IO a
orDie = either die pure

bits :: Rational -> Double
bits r = negate (logBase 2 (fromRational r))

main :: IO ()
main = do
  args <- getArgs
  (dir, withC) <- case args of
    [d] -> pure (d, True)
    [d, "--no-c"] -> pure (d, False)
    _ -> die "usage: probe-mass <dump-dir> [--no-c]"
  wB <- parseWorld <$> readFile (dir ++ "/leg-B.world")
  wBp <- parseWorld <$> readFile (dir ++ "/leg-Bp.world")
  forM_ [("B", wB), ("Bp", wBp)] massLeg
  if withC then legC wBp else putStrLn "\n(leg C not run on this dump: it reads src only, run once)"

-- the population exactly as Host.hs builds it
hostPop :: World -> (Namespace, Carrier Int, Grid, [(Name, Grid)], [Hyp])
hostPop w =
  let nsN = mkNamespace (ne (wNs w))
      obsC = mkCarrier "obs" (0 :| [1])
      thetaG = mkGrid "theta" (ne (wTheta w))
      gs = [ (nm, mkGrid nm (ne g)) | (nm, g) <- wGuards w ]
  in (nsN, obsC, thetaG, gs, enumerateWith nsN obsC thetaG gs Nothing fragFull)

foldAll :: World -> AgentS -> IO AgentS
foldAll w ag0 = foldM (\ag (y, fs) -> snd <$> orDie (observeS (fs ++ [wAct w]) y ag)) ag0 (wEv w)

massLeg :: (String, World) -> IO ()
massLeg (leg, w) = do
  let (nsN, _, thetaG, gs, pop) = hostPop w
      nT = gridSize thetaG
      fam = nT * (nT - 1)          -- one guard family: |tg| = 1 cut point, a /= b arms
  unless (length pop == nT + length gs * fam) (die "population shape moved")
  unless (all ((== "const") . fst . hypTag) (take nT pop)
          && all ((== "guard") . fst . hypTag) (drop nT pop)) (die "tag order moved")
  ag <- foldAll w (sentenceAgent nsN pop)
  putStrLn ("\n=== in-process leg " ++ leg ++ ": |pop| = " ++ show (length pop)
            ++ ", Kraft = " ++ show (fromRational (kraftSum pop) :: Double))
  putStrLn "  probe p1 in-process == wire p1 (bit-for-bit as Double):"
  forM_ (wProbes w) $ \(lc, pn, _, _, wireP1, fs) -> do
    p1 <- orDie (predictMassS (fs ++ [wAct w]) 1 ag)
    let d = fromRational p1 :: Double
    unless (d == wireP1) (die ("MISMATCH " ++ lc ++ " " ++ pn ++ " " ++ show d ++ " vs " ++ show wireP1))
    putStrLn ("    " ++ lc ++ "/" ++ pn ++ "  " ++ show d ++ "  ok")
  let post = metaPosterior ag
      chunks = ("const (all rungs)", sum (take nT post))
             : [ (nm, sum (take fam (drop (nT + i * fam) post))) | (i, (nm, _)) <- zip [0 ..] gs ]
  putStrLn "  posterior mass by cut (the guard name each single-cut family reads):"
  forM_ (take 6 (sortBy (comparing (Down . snd)) chunks)) $ \(nm, m) ->
    putStrLn ("    " ++ pad 26 nm ++ show (fromRational m :: Double))
  let (iB, hB, mB) = last (sortBy (comparing (\(_, _, m) -> m)) (zip3 [0 :: Int ..] pop post))
      thetaAt k = fromRational (wTheta w !! k) :: Double
      armsOf h = case hypTag h of
        ("guard", [_, a, b]) -> "arms (on, off) = " ++ show (thetaAt a, thetaAt b)
        ("const", [k]) -> "rung " ++ show (thetaAt k)
        t -> show t
      nmOf i = if i < nT then "const" else fst (gs !! ((i - nT) `div` fam))
  putStrLn ("  MAP model: " ++ nmOf iB ++ "  " ++ armsOf hB ++ "  mass " ++ show (fromRational mB :: Double))
  where pad n s = s ++ replicate (n - length s) ' '

legC :: World -> IO ()
legC w = do
  let (nsN, obsC, thetaG, gs, pop) = hostPop w
      nT = gridSize thetaG
      obsSp = carrierSpace obsC
      atomG = atomGridOf obsC
      cAt g k = case mkC g k of
        Just e -> e
        Nothing -> error "off-codebook"
      zero = cAt atomG 0
      one = cAt atomG 1
      -- COPY of Enumerate.hs `bernBody` and the unit latent at 571b589 (asserted below)
      bernBody th = If (Gt (Var Z) zero) th (Sub one th)
      unitLatent = mkSpace ((\(t0 :| _) -> t0) (ne (wTheta w)) :| [])
      code body = Code unitLatent obsSp (bernBody body)
      gridOf nm = maybe (error nm) id (lookup nm gs)
      cut nm = Gt (Get nm) (cAt (gridOf nm) 0)
      g1 = "leader-credence=ge90"
      g2 = "p-none=ge50"
      price e = weightIn nsN e
      mk tag e = Hyp tag (price e) unitLatent e Nothing
      consts = [ mk ("const", [k]) (code (cAt thetaG k)) | k <- [0 .. nT - 1] ]
      single nm i = [ mk ("cut:" ++ nm, [i, a, b]) (code (If (cut nm) (cAt thetaG a) (cAt thetaG b)))
                    | a <- [0 .. nT - 1], b <- [0 .. nT - 1], a /= b ]
      two o i = [ mk ("cut2:" ++ o ++ ">" ++ i, [a, b, c])
                    (code (If (cut o) (cAt thetaG a) (If (cut i) (cAt thetaG b) (cAt thetaG c))))
                | a <- [0 .. nT - 1], b <- [0 .. nT - 1], c <- [0 .. nT - 1], b /= c ]
      c0 = consts ++ single g1 0 ++ single g2 0
      c1 = c0 ++ two g1 g2 ++ two g2 g1
      grids = thetaG : atomG : map snd gs
  -- (1) the copy is the shipped kernel: same grammar weight and same prediction as the
  --     enumerated ge90 family, member by member
  let i1 = length (takeWhile ((/= g1) . fst) gs)
      shipped = take (nT * (nT - 1)) (drop (nT + i1 * nT * (nT - 1)) pop)
  forM_ (zip shipped (single g1 0)) $ \(hs, hc) -> do
    unless (weightIn nsN (hypEmit hs) == weightIn nsN (hypEmit hc)) (die "copy: weightIn differs")
    forM_ (wProbes w) $ \(_, _, _, _, _, fs) -> do
      a <- orDie (predictMassS (fs ++ [wAct w]) 1 (sentenceAgent nsN [hs]))
      b <- orDie (predictMassS (fs ++ [wAct w]) 1 (sentenceAgent nsN [hc]))
      unless (a == b) (die "copy: prediction differs")
  putStrLn ("\n=== leg C (in-process; |ns| = " ++ show (nsSize nsN) ++ ")")
  putStrLn ("  copy of the single-cut kernel == shipped ge90 family: " ++ show (length shipped)
            ++ " members, weightIn and every probe prediction identical")
  -- (2) every sentence is a sentence of the corpus
  unless (all (inCorpus nsN grids . hypEmit) c1) (die "a leg-C body is not inCorpus")
  putStrLn ("  inCorpus: all " ++ show (length c1) ++ " bodies True")
  let wOf t = case [ hypW h | h <- c1, fst (hypTag h) == t ] of
        (x : _) -> bits x
        [] -> 0 / 0
      t2a = "cut2:" ++ g1 ++ ">" ++ g2
      t2b = "cut2:" ++ g2 ++ ">" ++ g1
  putStrLn ("  C-g grammar weight (weightIn), bits: const " ++ show (wOf "const")
            ++ " | single cut " ++ show (wOf ("cut:" ++ g1)) ++ " | two-cut " ++ show (wOf t2a))
  -- C-x: the shipped charges, and the builder's extension for the two-cut
  let wConst = chargeMass fragWidth (constCharge thetaG)
      wGuard = chargeMass fragWidth (guardCharge nsN (gridOf g1) thetaG)
      wTwo = wGuard * (wGuard / wConst)
      reprice h = h { hypW = wTwo }
      cx = pop ++ map reprice (two g1 g2 ++ two g2 g1)
  unless (all (\h -> hypW h == (if fst (hypTag h) == "const" then wConst else wGuard)) pop)
    (die "C-x: the shipped population's charges are not the two read here")
  putStrLn ("  C-x selector charges, bits: const " ++ show (bits wConst) ++ " | single cut "
            ++ show (bits wGuard) ++ " | two-cut (BUILDER'S EXTENSION) " ++ show (bits wTwo))
  let report lbl hs tags = do
        ag <- foldAll w (sentenceAgent nsN hs)
        let post = metaPosterior ag
            by t = sum [ m | (h, m) <- zip hs post, fst (hypTag h) == t ]
        putStrLn ("  -- " ++ lbl ++ ", " ++ show (length hs) ++ " models")
        putStrLn ("     mass: " ++ unwords [ t ++ "=" ++ show (fromRational (by t) :: Double) | t <- tags ])
        forM_ (wProbes w) $ \(lc, pn, n, k, _, fs) -> do
          p1 <- orDie (predictMassS (fs ++ [wAct w]) 1 ag)
          putStrLn ("     " ++ lc ++ "/" ++ pn ++ "  real " ++ show k ++ "/" ++ show n
                    ++ "  p1 " ++ show (fromRational p1 :: Double))
      gTags = [ "const", "cut:" ++ g1, "cut:" ++ g2, t2a, t2b ]
  report "C-g depth 1 (consts + single cuts on g1, g2; weightIn)" c0 gTags
  report "C-g depth 2 (C-g depth 1 + two-cuts; weightIn)" c1 gTags
  report "C-x (shipped population + two-cuts at the extension price)" cx [ "const", "guard", t2a, t2b ]
