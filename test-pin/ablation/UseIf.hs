{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- Ablation fixture (the exact boundary, structural atom): fails to
-- compile under -DDROP_IF — the seat's clause-(b) half (its clause-(a)
-- transcript is the R15 bank, pack IX.3).
module UseIf (useIf) where

import PropLang.Syntax

useIf :: Expr '[Rational] Rational
useIf = If (Gt (Var Z) (Var Z)) (Var Z) (Var Z)
