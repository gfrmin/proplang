{-# LANGUAGE DataKinds #-}

-- | Deletion-audit fixture (FROZEN, gate 7): utters the 'Argmax' verb
-- and nothing else — fully polymorphic, depends only on PropLang.Syntax.
-- audit/ablation.sh compiles this file twice: it must compile against
-- the real grammar (positive control) and must FAIL to compile under
-- -DDROP_ARGMAX, with the error naming 'Argmax'.
module UseArgmax (useArgmax) where

import Data.List.NonEmpty (NonEmpty)
import PropLang.Syntax

useArgmax :: Expr '[NonEmpty o] o
useArgmax = Argmax (Var Z) (Get "t")
