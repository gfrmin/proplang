{-# LANGUAGE DataKinds #-}
-- Ablation fixture (step 3, decision 9; row 'code'): utters THE
-- LIKELIHOOD DOOR and nothing else operational. Delete 'Code' and no
-- hypothesis is utterable — the whole sentence fragment dies with the
-- one door where arbitrary arithmetic enters (R-C1 iii).
module UseCode where

import PropLang.Belief (Space)
import PropLang.Syntax (Expr (..), K)

use :: Space Double -> Space Int -> Expr '[Int, Double] Double
    -> Expr '[] (Maybe (K Double Int))
use = Code
