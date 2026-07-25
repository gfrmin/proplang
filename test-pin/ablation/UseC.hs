{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- Ablation fixture (the exact boundary, structural atom): fails to
-- compile under -DDROP_C — the seat's clause-(b) half (its clause-(a)
-- transcript is the R15 bank, pack IX.3).
module UseC (useC) where

import PropLang.Syntax

useC :: Maybe (Expr '[] Rational)
useC = mkC g 0
  where g = mkGrid "k" (pure 1)
