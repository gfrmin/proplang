{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

-- | The grammar as a GADT (typed-port-spec §3): ill-typed sentences are
-- unrepresentable. Indexed by result type and a typed environment (de
-- Bruijn); the grammar is defunctionalized — 'Fn' and 'Stats' are
-- first-order syntax, never Haskell lambdas.
--
-- The 'Push' and 'Argmax' constructors sit behind CPP flags @DROP_PUSH@ /
-- @DROP_ARGMAX@: the deletion audit (gate 7, audit/ablation.sh) compiles
-- fixture modules with these flags set and requires the compile to FAIL —
-- deletion of a verb is a code-level ablation, not a runtime mock.
--
-- PHASE 1 STUB: the data types are real (the frozen tests construct
-- them); function bodies are 'undefined'.
module PropLang.Syntax
  ( B, K, Ev
  , Name, Ix
  , Grid
  , Idx(..)
  , Expr(..)
  , Fn
  , Args(..)
  , StdName(..)
  , Util, mkUtil, applyUtil
  , bits
  , featureNames
  ) where

import Data.List.NonEmpty (NonEmpty)
import PropLang.Belief (Belief, Bits, Evidence, Kernel)

type B = Belief
type K = Kernel
type Ev = Evidence

type Name = String

-- | Index into a priced grid. (Validated smart construction is a Phase 2
-- concern, recorded in the Phase 1 report.)
type Ix = Int

-- | A priced grid of sayable constants: a named, finite point set whose
-- mention costs @log2 n@ bits. Data with prices (design §5); the concrete
-- theta\/tau\/rho grids live in "PropLang.Enumerate".
data Grid

-- | Typed de Bruijn index into the environment.
data Idx env t where
  Z :: Idx (t ': env) t
  S :: Idx env t -> Idx (u ': env) t

-- | The program grammar. The verbs are sayable (reflexive closure);
-- 'Argmax' binds its option variable in an extended typed environment.
-- 'Argmax' ranges over 'NonEmpty' options: a totality-forced deviation
-- from the spec §3 sketch's @[o]@, approved at Phase 1 review.
data Expr env t where
  C      :: Grid -> Ix -> Expr env Double            -- priced constant
  Get    :: Name -> Expr env Double                  -- absent name ~> 0.0
  If     :: Expr env Bool -> Expr env t -> Expr env t -> Expr env t
  Gt     :: Expr env Double -> Expr env Double -> Expr env Bool
  Var    :: Idx env t -> Expr env t
#ifndef DROP_PUSH
  Push   :: Expr env (B a) -> Expr env (K a b) -> Expr env (B b)
#endif
  CondE  :: Expr env (B a) -> Expr env (Ev a) -> Expr env (Maybe (B a))
  Expect :: Expr env (B a) -> Fn a -> Expr env Double
#ifndef DROP_ARGMAX
  Argmax :: Expr env (NonEmpty o) -> Expr (o ': env) Double -> Expr env o
#endif
  Call   :: StdName args t -> Args env args -> Expr env t
  -- ExpFam/Carrier/Stats deliberately absent in the parity phase
  -- (CLAUDE.md porting order, step 6).

-- | Defunctionalized function syntax (first-order, priced). Deliberately
-- abstract in Phase 1: no frozen test constructs one.
data Fn a

-- | Typed argument list for 'Call'.
data Args env ts where
  ANil :: Args env '[]
  (:*) :: Expr env t -> Args env ts -> Args env (t ': ts)

infixr 5 :*

-- | The stdlib alphabet: named compositions ('call' is the stdlib
-- boundary, design §2). Closed; adding a member is a reported alphabet
-- change (CLAUDE.md forbidden moves). Semantics live in "PropLang.Eval"
-- and are pure verb composition; the recorded contracts:
--
-- * @EU b u a      = expect b (applyUtil u a)@
-- * @IsEq x y      = x == y@
-- * @VAct b u acts = max over acts of expect b (applyUtil u a)@
-- * @VThink b k ys u acts n price@: Russell–Wefald preposterior value —
--   over all length-@n@ sequences of @ys@ outcomes in binary-counting
--   order (alphabet order as given), fold @logPredict@ BEFORE @cond@ per
--   outcome, weight @exp (sum logPredict)@ times the post-conditioning
--   @VAct@, sum, minus @price@; a 'Nothing' from 'cond' contributes
--   weight 0.
data StdName args t where
  EU     :: StdName '[B y, Util a y, a] Double
  IsEq   :: Eq a => StdName '[a, a] Bool
  VAct   :: StdName '[B h, Util a h, NonEmpty a] Double
  VThink :: Eq y => StdName '[B h, K h y, [y], Util a h, NonEmpty a, Int, Double] Double

-- | A utility as an opaque value-layer object (precedent: 'expect',
-- 'kernel', 'event' all accept host functions at the value layer;
-- likelihoods, by contrast, may only enter as 'Evidence'). Parity-scoped:
-- when utility becomes latent (CIRL, post-parity), Util must become
-- priced syntax.
data Util a y

mkUtil :: (a -> y -> Double) -> Util a y
mkUtil = undefined

applyUtil :: Util a y -> a -> y -> Double
applyUtil = undefined

-- | Total pricing: every constructible sentence has a price (structural
-- recursion; '-Wincomplete-patterns' as error makes totality a compile
-- fact in Phase 2).
bits :: Expr env t -> Bits
bits = undefined

-- | The priced feature namespace: @Get name@ costs
-- @log2 |featureNames|@ at the mention site (0 bits while the namespace
-- has one name). Runtime lookup is deliberately decoupled from pricing
-- (a sentence about a sensor that does not exist yet is sayable,
-- dormant, and priced).
featureNames :: [Name]
featureNames = undefined
