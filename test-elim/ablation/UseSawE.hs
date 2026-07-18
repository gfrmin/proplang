{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

-- | Ablation fixture (step 9): the SawE evidence producer is
-- deletable-and-attributable. GENERIC -- src only pattern-matches it
-- (the total evaluator/renderer arms are CPP-guarded), so layer-absence
-- (0) COMPILES; the fixture proves the type-level deletion.
module UseSawE where

import PropLang.Syntax (Ev, Expr (..), Idx (..), K)

useSawE :: Expr '[Double, K Double Double] (Ev Double)
useSawE = SawE (Var (S Z)) (Var Z)
