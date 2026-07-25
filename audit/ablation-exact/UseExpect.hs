{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- Ablation fixture: the prevision atom (seat re-earned at this
-- boundary, A3 transcript). Fails to compile under -DDROP_EXPECT.
module UseExpect (useExpect) where

import PropLang.Syntax

useExpect :: Expr '[B Rational] Rational
useExpect = Expect (Var Z) (Var Z)
