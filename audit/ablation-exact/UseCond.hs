{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
-- Ablation fixture (the exact boundary): Cond is THE ENTRANT (the
-- fused conditioning verb, ruling 4) — the two-sided entry gate's
-- clause (b). Under -DDROP_COND this module MUST fail to compile,
-- naming the missing constructor.
module UseCond (useCond) where

import PropLang.Syntax

useCond :: Expr '[Rational, K Rational Int, B Rational] Rational
useCond = Cond (Var (S (S Z))) (Var (S Z)) (Var Z) (Get "x") (Get "y")
