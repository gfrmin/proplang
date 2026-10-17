{-# LANGUAGE DataKinds #-}
-- bench/BenchTest.hs — the instrument's own tests (bench r01). Plain
-- assertions, no framework: `ghc -O1 -isrc -ibench bench/BenchTest.hs`
-- then run; exit 0 iff every row holds. Rows:
--
--   t1  the tick stream is deterministic and PREFIX-STABLE per seed
--       (a 10^2 session is the head of the 10^3 session with the same
--       seed) and seeds differ;
--   t2  window starts: 100 ticks each, inside the session, strictly
--       increasing, the last window ends at the last tick;
--   t3  bit-size helpers on known values;
--   t4  reply parsing on a live wire reply (act object, loss_bits);
--   t5  THE MIRROR PIN, per profile (P1, P2, P3, P2nw): over a short
--       session (a) the hello is accepted and the mirror's population
--       equals the hello's `models`; (b) every tick's mirror marginal
--       renders to the wire's loss_bits string; (c) at the end the
--       mirror's normalized meta weights EQUAL (Rational ==) the
--       engine's own metaPosterior of an AgentS folded through
--       observeS on the same (features ++ act, y) stream — the
--       route-2 proxy is the engine's state, not an approximation;
--   t6  the sanity profiles carry no evidence (S1 menu only, S0 pure);
--   t7  every declared codebook value survives the wire's number
--       round-trip (show -> reads) as the same Double, so the mirror's
--       realToFrac embedding is the door's.
module Main (main) where

import Control.Monad (forM_, unless, when)
import Data.IORef
import Data.List (isInfixOf)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromMaybe)
import Data.Ratio ((%), denominator)
import System.Exit (exitFailure)

import BenchLib
import P2Real (p2realModels, p2realNs, p2realGuards, p2realTheta, p2realRho)
import PropLang.Enumerate (AgentS, enumerateWith, enumerateWithBreadth,
                           fragFull, metaPosterior, mkBreadth, observeS,
                           sentenceAgent)
import PropLang.Host (hostStart, serveLine)
import PropLang.Report (bitsView)
import PropLang.Syntax (mkCarrier, mkGrid, mkNamespace)

-- | Bit-size of a Double's exact rational denominator.  Sixteenths give 5;
-- a decimal such as 0.339 gives ~55.
denomBits :: Double -> Int
denomBits = ibits . denominator . toRational

main :: IO ()
main = do
  fails <- newIORef (0 :: Int)
  let check name ok = if ok then putStrLn ("ok   " ++ name)
                      else putStrLn ("FAIL " ++ name) >> modifyIORef' fails (+ 1)
  -- t1
  let s1a = genTicks profileP1 1 100
      s1b = genTicks profileP1 1 1000
      s2 = genTicks profileP1 2 100
      key t = (tFeats t, tEv t)
  check "t1 prefix-stable: 100-tick stream is the head of the 1000-tick stream"
    (map key s1a == map key (take 100 s1b))
  check "t1 deterministic: regenerating gives the same stream"
    (map key s1a == map key (genTicks profileP1 1 100))
  check "t1 seeds differ" (map key s1a /= map key s2)
  -- t2
  forM_ [100, 300, 1000, 10000, 100000] $ \n -> do
    let ws = windowStarts n
    check ("t2 windows for n=" ++ show n ++ ": in range, increasing, last ends at n")
      (all (\i -> i >= 1 && i + windowLen - 1 <= n) ws
       && and (zipWith (<) ws (drop 1 ws))
       && take 1 ws == [1]
       && (case reverse ws of
             (lastW : _) -> lastW + windowLen - 1 == n
             [] -> False))
  -- t8: the P2real declaration -- TWO INDEPENDENT DERIVATIONS MUST AGREE.
  -- gen-p2real.py computes the population from life-agent's declaration in
  -- Python; `predictedModels` recomputes it in Haskell from the profile that
  -- declaration produced.  Neither is trusted: they are checked against each
  -- other here, and both are checked against the ENGINE's own `models` reply
  -- by the driver's population assertion at every cell start.  Three ways of
  -- getting the same number, no hand copy anywhere in the chain.
  check "t8 P2real: python-side and haskell-side population derivations agree"
    (predictedModels profileP2real == p2realModels)
  check "t8 P2real: 960 models"
    (p2realModels == 960)
  check "t8 P2real: 19-name namespace, 17 guard rows, t and act unguarded"
    (length p2realNs == 19 && length p2realGuards == 17
     && notElem "t" (map fst p2realGuards)
     && notElem "act" (map fst p2realGuards))
  -- EVERY Double is dyadic by construction, so "dyadic" here means what the
  -- report means by it: a SMALL power-of-two denominator (the sixteenths the
  -- reconstruction used) versus the ~2^-55 embedding a decimal needs.  The
  -- lever is denominator SIZE, and that is what this row measures.
  check "t8 P2real: theta is 8 points, none small-dyadic (the 2^-55 lever applies)"
    (length p2realTheta == 8
     && all ((> 20) . denomBits) p2realTheta)
  check "t8 control: the reconstruction's theta IS small-dyadic"
    (all ((<= 20) . denomBits) (pTheta profileP2))
  check "t8 P2real: no walk family declared"
    (p2realRho == Nothing)
  -- every profile's declaration predicts the population its hello reports
  forM_ profiles $ \pr -> do
    let (_, r) = serveLine hostStart (helloLine pr)
        got = scalarField "models" r >>= \x -> case reads x of
                [(v, "")] -> Just (v :: Int)
                _ -> Nothing
    check ("t8 population assertion holds for " ++ pName pr
           ++ " (predicted " ++ show (predictedModels pr) ++ ")")
      (got == Just (predictedModels pr))
  -- t3
  check "t3 ibits" (ibits 0 == 1 && ibits 1 == 1 && ibits 255 == 8 && ibits 256 == 9)
  check "t3 qbits 3/8 = 2 + 4" (qbits (3 % 8) == 6)
  -- t4 / t5 / t7 per profile
  forM_ [profileP1, profileP2, profileP3, profileP2nw] $ \p -> do
    let (st1, r1) = serveLine hostStart (helloLine p)
    check (pName p ++ " t5a hello accepted") ("\"ok\": true" `isInfixOf` r1)
    let m0 = mirrorStart p
        BitSample _ _ mn _ _ = mirrorBits m0
        models = fromMaybe "?" (scalarField "models" r1)
    check (pName p ++ " t5a mirror population == models (" ++ models ++ ")")
      (show mn == models)
    -- t7 round trip
    let vals = pTheta p ++ fromMaybe [] (pRho p) ++ concatMap snd (pGuards p)
               ++ maybe [] snd (pMenu p)
        rt d = case reads (showD d) :: [(Double, String)] of
                 [(d', "")] -> d' == d
                 _ -> False
        showD d = if d == fromIntegral (round d :: Integer)
                    then show (round d :: Integer) else show d
    check (pName p ++ " t7 every declared value round-trips through the wire's reads")
      (all rt vals)
    -- t5b/c: run 40 ticks through the wire, the mirror, and an engine
    -- shadow folded through observeS
    let ticks = genTicks p 7 40
        shadow0 = shadowAgent p
        go _ _ _ [] acc = pure acc
        go st m sh (t : rest) (pins, sh') = do
          let line = tickLine p (tFeats t) (tEv t)
              (stN, reply) = serveLine st line
          when ("\"error\"" `isInfixOf` reply) $ do
            putStrLn ("FAIL " ++ pName p ++ " wire error: " ++ reply)
            modifyIORef' fails (+ 1)
          case tEv t of
            Nothing -> go stN m sh rest (pins, sh')
            Just y -> do
              let act = fromMaybe [] (actField reply)
                  full = tFeats t ++ act
              case (mirrorStep full y m, observeS full y sh) of
                (Right (marg, mN), Right (_, shN)) -> do
                  let mine = show (bitsView marg)
                      theirs = fromMaybe "<none>" (scalarField "loss_bits" reply)
                  unless (mine == theirs) $ do
                    putStrLn ("FAIL " ++ pName p ++ " t5b pin: " ++ mine ++ " vs " ++ theirs)
                    modifyIORef' fails (+ 1)
                  -- t4: the act parsed names exactly the menu name
                  unless (map fst act == maybe [] (\(nm, _) -> [nm]) (pMenu p)) $ do
                    putStrLn ("FAIL " ++ pName p ++ " t4 act parse: " ++ reply)
                    modifyIORef' fails (+ 1)
                  go stN mN shN rest (pins + 1, shN)
                (l, r) -> do
                  putStrLn ("FAIL " ++ pName p ++ " fold refused: "
                            ++ either id (const "ok") l ++ " / " ++ either id (const "ok") r)
                  modifyIORef' fails (+ 1)
                  go stN m sh rest (pins, sh')
    (pins, shN) <- go st1 m0 shadow0 ticks (0 :: Int, shadow0)
    check (pName p ++ " t5b every tick pinned (" ++ show pins ++ " of 40)") (pins == 40)
    -- final state: mirror normalized == engine metaPosterior (exact)
    let mFinal = foldMirror p ticks
    check (pName p ++ " t5c mirror normalized meta == engine metaPosterior (Rational ==)")
      (mirrorMetaNormalized mFinal == metaPosterior shN)
  -- t6
  check "t6 S1 ticks carry the menu, no evidence"
    (all (\t -> tEv t == Nothing) (genTicks profileS1 1 50)
     && "\"menu\"" `isInfixOf` tickLine profileS1 [("x", 1)] Nothing
     && not ("evidence" `isInfixOf` tickLine profileS1 [("x", 1)] Nothing))
  check "t6 S0 ticks are features only"
    (not ("\"menu\"" `isInfixOf` tickLine profileS0 [("x", 1)] Nothing))
  check "t4 scalarField reads a field"
    (scalarField "p1" "{\"act\": {\"act\": 1}, \"p1\": 0.5, \"x\": 1}" == Just "0.5")
  check "t4 actField reads the act object"
    (actField "{\"act\": {\"act\": 1, \"b\": 0.5}, \"p1\": 0.5}" == Just [("act", 1), ("b", 1 % 2)])
  n <- readIORef fails
  if n == 0 then putStrLn "ALL BENCH TESTS PASSED"
            else putStrLn (show n ++ " FAILURE(S)") >> exitFailure

-- the engine's own agent for a profile, built through the SAME
-- enumeration call shape the wire uses (Host.hs `hello` at 94fd4eb)
shadowAgent :: Profile -> AgentS
shadowAgent p =
  let ns = case pNs p of
        (n0 : rest) -> mkNamespace (n0 :| rest)
        [] -> error "empty namespace"
      grid nm ds = case map realToFrac ds of
        (q : qs) -> mkGrid nm (q :| qs)
        [] -> error "empty grid"
      thetaG = grid "theta" (pTheta p)
      mRhoG = fmap (grid "rho") (pRho p)
      gs = [ (nm, grid nm ds) | (nm, ds) <- pGuards p ]
      kA = fromMaybe 2 (pArity p)
      obsC = mkCarrier "obs" (0 :| [1 .. kA - 1])
      pop = case pArity p of
        Nothing -> enumerateWith ns obsC thetaG gs mRhoG fragFull
        Just k -> case mkBreadth k [] False of
          Just br -> enumerateWithBreadth br k ns obsC thetaG gs mRhoG fragFull
          Nothing -> error "mkBreadth refused"
  in sentenceAgent ns pop

-- re-fold the mirror over the wire's acts (a second, independent
-- traversal so t5c compares two separately-built states)
foldMirror :: Profile -> [Tick] -> Mirror
foldMirror p ticks = go (fst (serveLine hostStart (helloLine p))) (mirrorStart p) ticks
  where
    go _ m [] = m
    go st m (t : rest) =
      let (stN, reply) = serveLine st (tickLine p (tFeats t) (tEv t))
      in case tEv t of
           Nothing -> go stN m rest
           Just y ->
             let act = fromMaybe [] (actField reply)
             in case mirrorStep (tFeats t ++ act) y m of
                  Right (_, mN) -> go stN mN rest
                  Left e -> error ("foldMirror: " ++ e)

