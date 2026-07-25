{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- Ablation fixture (the exact boundary, structural atom): fails to
-- compile under -DDROP_GET — the seat's clause-(b) half (its clause-(a)
-- transcript is the R15 bank, pack IX.3).
module UseGet (useGet) where

import PropLang.Syntax

useGet :: Expr '[] Rational
useGet = Get "x"
