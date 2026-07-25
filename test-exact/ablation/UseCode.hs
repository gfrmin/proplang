{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- Ablation fixture: the likelihood production (KER's sole member).
-- Fails to compile under -DDROP_CODE.
module UseCode (useCode) where

import PropLang.Belief (Space)
import PropLang.Syntax

useCode :: (Real a, Real b) => Space a -> Space b -> Expr '[] (Maybe (K a b))
useCode sp cod = Code sp cod (Var Z)
