{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

-- | Ablation fixture (step 9): the ElimJ conditioned-belief eliminator
-- is deletable-and-attributable. GENERIC -- src only pattern-matches it
-- (arms CPP-guarded), so layer-absence (0) COMPILES; the fixture proves
-- the type-level deletion. The Nothing arm (Get "y") is an ordinary
-- EXPR, as the type demands.
module UseElimJ where

import PropLang.Syntax (B, Expr (..), Idx (..))

useElimJ :: Expr '[Maybe (B Double)] Double
useElimJ = ElimJ (Var Z) (Get "x") (Get "y")
