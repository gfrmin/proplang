{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- Ablation fixture (the exact boundary, structural atom): fails to
-- compile under -DDROP_SUB — the seat's clause-(b) half (its clause-(a)
-- transcript is the R15 bank, pack IX.3).
module UseSub (useSub) where

import PropLang.Syntax

useSub :: Expr '[Rational] Rational
useSub = Sub (Var Z) (Var Z)
