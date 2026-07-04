{-# LANGUAGE DataKinds #-}

-- | Deletion-audit fixture (FROZEN, gate 7): utters the 'Push' verb and
-- nothing else — fully polymorphic, depends only on PropLang.Syntax.
-- audit/ablation.sh compiles this file twice: it must compile against
-- the real grammar (positive control) and must FAIL to compile under
-- -DDROP_PUSH, with the error naming 'Push'. Deletion of a verb is a
-- code-level ablation of the grammar, never a runtime mock.
module UsePush (usePush) where

import PropLang.Syntax

usePush :: Expr '[B a, K a b] (B b)
usePush = Push (Var Z) (Var (S Z))
