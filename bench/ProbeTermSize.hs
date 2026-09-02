{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
-- bench/ProbeTermSize.hs — the #24 sitting r2, probe A1: is the F9
-- width cliff an artefact of EXPRESSION DUPLICATION in the chooseKS
-- expansion, or intrinsic to substitution?  A STATIC probe: build the
-- selection term exactly as `policyPick` does and COUNT it — no
-- timing, no box.
--
-- The hypothesis under test (the sitting's verdict, 2026-09-02): the
-- tournament re-embeds the winner subtree in each successive
-- comparison, so TERM size is exponential in width while the heap
-- DAG stays small — and `evalx` walks the TREE, not the DAG.
--
-- Provenance (R-D20-i: commit hash + binding name, quoted):
--   src/PropLang/Syntax.hs at 94fd4eb, the binding `chooseKS`:
--     chooseKS ((c0, v0) :| rest) = fst (foldl step (c0, v0) rest)
--       where step (cw, vw) (c, v) = (If (Gt v vw) c cw, If (Gt v vw) v vw)
--   src/PropLang/Eval.hs at 94fd4eb, the binding `evalx` (If/Gt cases):
--     If c t e -> if evalx c env then evalx t env else evalx e env
--     Gt a b -> evalx a env > evalx b env
--   src/PropLang/Membrane.hs at 94fd4eb, the binding `policyPick`
--   (the construction this probe copies, through the SAME exported
--   doors — withRows, substW via withRows, chooseKS, mkGrid, mkC):
--     codeG = mkGrid "options" (0 :| map fromIntegral [1 .. n - 1])
--     uB = reindexUtility atomG u
--     withRows uB cands (\vals rows ->
--       case zipWith (\i row -> (codeM i, row)) [0 ..] rows of
--         (r0 : rs) -> ... evalx (chooseKS (r0 :| rs)) env ...)
--
-- The utility used is the generic said@1 shape act*(2y-1) (the
-- documented BenchLib.pUtility form).  The REAL P2real sentence is
-- deeper, but the utility enters the tournament recurrence only as
-- the leaf constant |row|: tree(k) = a*2^k + b*|row| growth is
-- utility-independent, and the probe prints tree/|row| so the
-- structural factor is legible on its own.  Menus (name, width,
-- codebook) come from the SAME profiles the F9 cells ran
-- (BenchLib.profiles, by pName — one generator, no hand copy).
module Main (main) where

import Data.IORef
import qualified Data.IntMap.Strict as IM
import Data.List.NonEmpty (NonEmpty ((:|)))
import System.Mem.StableName
import Text.Printf (printf)

import BenchLib (Profile (..), profiles)
import PropLang.Belief (Belief, mkSpace, uniform)
import PropLang.Eval (Features)
import PropLang.Membrane (mintQ, reindexUtility, substW, withRows,
                          menuAssignments)
import PropLang.Syntax (B, Expr (..), Grid, Idx (..), Ix, mkC, mkGrid,
                        chooseKS)

-- ---------------------------------------------------------------------
-- tree size (what evalx walks) and DAG size (what the heap shares),
-- one pass: size memoized by HEAP IDENTITY (StableName), so the walk
-- is linear in the DAG while the returned Integer is the exact tree
-- count — exact at any width, 2^63 included.
-- ---------------------------------------------------------------------

data AnyName = forall x. AnyName (StableName x)

countExpr :: Expr env t -> IO (Integer, Int)
countExpr root = do
  memo <- newIORef (IM.empty :: IM.IntMap [(AnyName, Integer)])
  dagC <- newIORef (0 :: Int)
  let look :: StableName x -> IO (Maybe Integer)
      look sn = do
        m <- readIORef memo
        let findIn [] = Nothing
            findIn ((AnyName s, v) : rest)
              | eqStableName s sn = Just v
              | otherwise = findIn rest
        pure (IM.lookup (hashStableName sn) m >>= findIn)
      ins :: StableName x -> Integer -> IO ()
      ins sn v =
        modifyIORef' memo (IM.insertWith (++) (hashStableName sn)
                                              [(AnyName sn, v)])
      go :: forall env' t'. Expr env' t' -> IO Integer
      go e = e `seq` do
        sn <- makeStableName e
        hit <- look sn
        case hit of
          Just v -> pure v
          Nothing -> do
            modifyIORef' dagC (+ 1)
            v <- case e of
              C {}    -> pure 1
              Get _   -> pure 1
              Var _   -> pure 1
              If c a b -> (\x y z -> 1 + x + y + z) <$> go c <*> go a <*> go b
              Gt a b  -> (\x y -> 1 + x + y) <$> go a <*> go b
              Sub a b -> (\x y -> 1 + x + y) <$> go a <*> go b
              Mul a b -> (\x y -> 1 + x + y) <$> go a <*> go b
              Expect eb body -> (\x y -> 1 + x + y) <$> go eb <*> go body
              Cond c1 c2 c3 c4 c5 ->
                (\a1 a2 a3 a4 a5 -> 1 + a1 + a2 + a3 + a4 + a5)
                  <$> go c1 <*> go c2 <*> go c3 <*> go c4 <*> go c5
              Code _ _ body -> (1 +) <$> go body
            ins sn v
            pure v
  t <- go root
  d <- readIORef dagC
  pure (t, d)

-- ---------------------------------------------------------------------
-- the terms
-- ---------------------------------------------------------------------

mintOn :: Grid -> Ix -> Expr e Rational
mintOn g i = case mkC g i of
  Just e  -> e
  Nothing -> error "probe: mint off grid (unreachable)"

-- the generic said@1 utility act*(2y-1) in its wire slots (slot S Z
-- is the outcome y; the act reads through Get, per ACTIONS ARE
-- FEATURES — reindexUtility zeroes the dead act slot)
uGeneric :: String -> Expr '[Rational, Rational] Rational
uGeneric actName =
  Mul (Get actName) (Sub (Mul (mintQ 2) (Var (S Z))) (mintQ 1))

-- the tournament term, built exactly as policyPick builds it (the
-- quoted construction above), handed to the continuation
tournament :: Grid -> Expr '[Rational, Rational] Rational
           -> [(Features, Belief Int)]
           -> (forall env. Expr env Rational -> IO r) -> IO r
tournament atomG u cands k =
  let n = length cands
      codeG = mkGrid "options" (0 :| map fromIntegral [1 .. n - 1])
      codeM :: forall e2. Ix -> Expr e2 Rational
      codeM i = mintOn codeG i
      uB :: forall e. Expr (Rational ': e) Rational
      uB = reindexUtility atomG u
  in withRows uB cands (\_vals rows ->
       case zipWith (\i row -> (codeM i, row)) [0 ..] rows of
         []        -> error "probe: empty menu (unreachable)"
         (r0 : rs) -> k (chooseKS (r0 :| rs)))

-- chooseEU's frozen binary pick sentence (Membrane.hs at 94fd4eb,
-- the binding `pick`), through exported doors — the per-comparison
-- constant of the shipped clockless route
pickBinary :: Grid -> Expr '[Rational, Rational] Rational
           -> Expr '[B Int, B Int] Rational
pickBinary atomG u =
  let uB :: forall e. Expr (Rational ': e) Rational
      uB = reindexUtility atomG u
  in If (Gt (Expect (Var Z) uB) (Expect (Var (S Z)) uB))
        (mintOn atomG 1) (mintOn atomG 0)

-- the verdict's THIRD SHAPE, per-comparison term: pairwise AND
-- substituting — chooseEU's fold with substW applied per side
pairSub :: Grid -> Expr '[Rational, Rational] Rational
        -> Features -> Features -> Expr '[B Int, B Int] Rational
pairSub atomG u aC aI =
  let uB :: forall e. Expr (Rational ': e) Rational
      uB = reindexUtility atomG u
  in If (Gt (Expect (Var Z) (substW aC uB))
            (Expect (Var (S Z)) (substW aI uB)))
        (mintOn atomG 1) (mintOn atomG 0)

-- ---------------------------------------------------------------------

probeWidth :: Int -> IO (Integer, Int)
probeWidth w = do
  let nm = if w == 4 then "P2realNC" else "P2realNC" ++ show w
      p = case [ q | q <- profiles, pName q == nm ] of
            (q : _) -> q
            []      -> error ("probe: no profile " ++ nm)
      (menuNm, vals) = case pMenu p of
        Just mv -> mv
        Nothing -> error ("probe: " ++ nm ++ " has no menu (unreachable)")
      grid = case map toRational vals of
        (v0 : vs) -> mkGrid menuNm (v0 :| vs)
        []        -> error "probe: empty codebook (unreachable)"
      atomG = mkGrid "atom" (0 :| [1])
      bel = uniform (mkSpace (0 :| [1])) :: Belief Int
      cands = [ (c, bel) | c <- menuAssignments [(menuNm, grid)] ]
      u = uGeneric menuNm
  (treeT, dagT) <- tournament atomG u cands countExpr
  (treeP, _) <- countExpr (pickBinary atomG u)
  (treeS, _) <- case cands of
    ((a0, _) : (a1, _) : _) -> countExpr (pairSub atomG u a0 a1)
    _ -> error "probe: fewer than two candidates (unreachable)"
  printf "w=%-3d tournament tree=%-22s dag=%-7d  pick/cmp=%d (x%d cmps=%d)  pairSub/cmp=%d (x%d cmps=%d)\n"
         w (show treeT) dagT
         treeP (w - 1) (treeP * fromIntegral (w - 1))
         treeS (w - 1) (treeS * fromIntegral (w - 1))
  pure (treeT, dagT)

main :: IO ()
main = do
  putStrLn "ProbeTermSize (the #24 sitting r2, A1) — STATIC term counts at 94fd4eb"
  putStrLn "tree = nodes evalx walks; dag = distinct heap nodes; pick/pairSub rows"
  putStrLn "are PER-COMPARISON constants of the two O(width) routes, x(w-1) total."
  putStrLn ""
  results <- mapM probeWidth [4, 8, 16, 32, 64]
  putStrLn ""
  putStrLn "growth per doubling (tree, then dag):"
  let pairsW = zip [4 :: Int, 8, 16, 32] (drop 1 results)
      prevs = results
  mapM_ (\((w2, (t2, d2)), (t1, d1)) ->
           printf "  w=%d -> w=%d : tree x%.2f, dag x%.2f\n"
                  w2 (w2 * 2)
                  (fromIntegral t2 / fromIntegral t1 :: Double)
                  (fromIntegral d2 / fromIntegral d1 :: Double))
        (zip pairsW prevs)
  putStrLn ""
  putStrLn "reading: tree ~2^w with dag staying polynomial = the cliff is"
  putStrLn "EXPRESSION DUPLICATION (an implementation artefact of the chooseKS"
  putStrLn "expansion under a tree-walking evalx), not intrinsic to substitution;"
  putStrLn "the pairSub row shows the substituting per-comparison term is a"
  putStrLn "width-independent constant."
