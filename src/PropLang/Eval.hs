{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

-- | The evaluator (typed-port-spec §3): @evalx :: Expr env t -> Env env
-- -> t@ — the type IS the purity claim. No IO anywhere in this module
-- (audit gate 3); the environment carries features and typed bindings;
-- stdlib semantics for 'PropLang.Syntax.StdName' live here in Phase 2.
--
-- PHASE 1 STUB: 'Vals' is real (the frozen tests construct
-- environments); bodies are 'undefined'.
module PropLang.Eval
  ( Features
  , Vals(..)
  , Env
  , mkEnv
  , evalx
  ) where

import PropLang.Syntax (Expr, Name)

-- | The world's published names, one tick's worth. Absent names read 0.0
-- (interface.md §1: prices, clocks, and echoes are names like any other).
type Features = [(Name, Double)]

-- | Typed value stack matching the expression's environment index.
data Vals env where
  VNil :: Vals '[]
  (:.) :: t -> Vals env -> Vals (t ': env)

infixr 5 :.

-- | The evaluation environment: features + typed bindings. Abstract.
data Env env

mkEnv :: Features -> Vals env -> Env env
mkEnv = undefined

-- | Big-step evaluation. Pure and total.
evalx :: Expr env t -> Env env -> t
evalx = undefined
