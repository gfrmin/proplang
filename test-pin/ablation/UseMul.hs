{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- Ablation fixture (the exact boundary, structural atom): fails to
-- compile under -DDROP_MUL — the seat's clause-(b) half (its clause-(a)
-- transcript is the R15 bank, pack IX.3).
module UseMul (useMul) where

import PropLang.Syntax

useMul :: Expr '[Rational] Rational
useMul = Mul (Var Z) (Var Z)
