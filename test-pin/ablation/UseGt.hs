{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- Ablation fixture (the exact boundary, structural atom): fails to
-- compile under -DDROP_GT — the seat's clause-(b) half (its clause-(a)
-- transcript is the R15 bank, pack IX.3).
module UseGt (useGt) where

import PropLang.Syntax

useGt :: Expr '[Rational] Bool
useGt = Gt (Var Z) (Var Z)
