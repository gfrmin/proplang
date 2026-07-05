{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE PatternSynonyms #-}

-- | The grammar as a GADT (typed-port-spec §3): ill-typed sentences are
-- unrepresentable. Indexed by result type and a typed environment (de
-- Bruijn); the grammar is defunctionalized — 'Fn' and 'Stats' are
-- first-order syntax, never Haskell lambdas.
--
-- The 'Push' and 'Argmax' constructors sit behind CPP flags @DROP_PUSH@ /
-- @DROP_ARGMAX@: the deletion audit (gate 7, audit/ablation.sh) compiles
-- fixture modules with these flags set and requires the compile to FAIL —
-- deletion of a verb is a code-level ablation, not a runtime mock. The
-- corresponding 'bits' cases sit behind the same flags, so the ablated
-- grammar keeps a total pricer.
module PropLang.Syntax
  ( B, K, Ev
  , Name, Ix
  , Grid, mkGrid, gridName, gridSize
  , Idx(..)
  , Expr( Get, If, Gt, Var
#ifndef DROP_PUSH
        , Push
#endif
        , CondE, Expect
#ifndef DROP_ARGMAX
        , Argmax
#endif
        , Call, C )
  , mkC
  , Fn(..)
  , Args(..)
  , StdName(..)
  , Util, mkUtil, applyUtil
  , KnownScope(..)
  , bits
  , featureNames
  ) where

import Data.Kind (Type)
import Data.List.NonEmpty (NonEmpty, toList)
import Data.Proxy (Proxy (..))
import PropLang.Belief (Belief, Bits (..), Event, Evidence, Kernel)

type B = Belief
type K = Kernel
type Ev = Evidence

type Name = String

-- | Index into a priced grid. Out-of-range mentions are UNCONSTRUCTIBLE
-- (amended spec §3): the only door to a priced constant is 'mkC', which
-- returns 'Nothing' off the grid. The 'Get' 0.0 convention is dormancy
-- for names that may appear later; a grid index never can, so it gets
-- no denotation at all.
type Ix = Int

-- | A priced grid of sayable constants: a named, finite point set whose
-- mention costs @log2 n@ bits. Data with prices (design §5); the concrete
-- theta\/tau\/rho grids live in "PropLang.Enumerate".
data Grid = Grid Name [Double]

-- | Grids are nonempty by construction, so 'gridSize' is at least 1 and
-- every grid has a finite price.
mkGrid :: Name -> NonEmpty Double -> Grid
mkGrid nm = Grid nm . toList

gridName :: Grid -> Name
gridName (Grid nm _) = nm

gridSize :: Grid -> Int
gridSize (Grid _ pts) = length pts

-- Total point lookup: 'Nothing' off the grid. Private since the
-- grammar-hygiene increment (R7): its only public consumer was the
-- evaluator's dormant read, retired at Task 3 — it survives as the
-- validator inside 'mkC'.
gridLookup :: Grid -> Ix -> Maybe Double
gridLookup (Grid _ pts) k
  | k >= 0 = case drop k pts of
      p : _ -> Just p
      []    -> Nothing
  | otherwise = Nothing

-- | Typed de Bruijn index into the environment.
data Idx env t where
  Z :: Idx (t ': env) t
  S :: Idx env t -> Idx (u ': env) t

-- | The program grammar. The verbs are sayable (reflexive closure);
-- 'Argmax' binds its option variable in an extended typed environment.
-- 'Argmax' ranges over 'NonEmpty' options: a totality-forced deviation
-- from the spec §3 sketch's @[o]@, approved at Phase 1 review.
data Expr env t where
  MkC    :: Grid -> Ix -> Double -> Expr env Double  -- NOT exported: 'mkC' is the only door (R1)
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

-- | Match-only view of a priced constant: grid, index, and the point
-- VALUE, resolved once at construction time by 'mkC' — the only door
-- (amended spec §3, plan R1). Unidirectional, so a @C@ nobody validated
-- cannot exist: off-grid constants are unconstructible, and the
-- evaluator reads the carried value with no lookup, no dormant 0.0, no
-- error site.
pattern C :: () => t ~ Double => Grid -> Ix -> Double -> Expr env t
pattern C g k v <- MkC g k v

-- The shipped grammar for the exhaustiveness checker, with 'C' standing
-- in for the unexported 'MkC'. The set tracks the CPP ablation flags so
-- every audited configuration keeps totality as a compile fact.
{-# COMPLETE C, Get, If, Gt, Var,
#ifndef DROP_PUSH
             Push,
#endif
             CondE, Expect,
#ifndef DROP_ARGMAX
             Argmax,
#endif
             Call #-}

-- | Defunctionalized function syntax (first-order, priced): the
-- grammar-hygiene alphabet, exactly the two published expansions of the
-- reference (a REPORTED alphabet change, GRAMMAR_HYGIENE_PLAN Q1).
-- 'FnInd' is the indicator of a declared event — probability derived
-- from prevision (design §3) gets its syntactic witness; 'FnUtil' is a
-- utility section — the EU contract's expansion. Each costs one FN
-- choice bit; the opaque value-layer payloads are priced 0, the
-- recorded parity-scoped convention (Phase 1 report §4.3) — when
-- events/utilities become latent (CIRL), the payloads become priced
-- syntax. The CPP flags are the deletion audit's raises-by-type
-- ablation points, same standard as DROP_PUSH/DROP_ARGMAX.
data Fn a where
#ifndef DROP_FNIND
  FnInd  :: Event a -> Fn a
#endif
#ifndef DROP_FNUTIL
  FnUtil :: Util o a -> o -> Fn a
#endif

-- | The ONLY constructor of a priced-constant sentence: 'Nothing' off
-- the grid, so a malformed constant is unconstructible rather than
-- denoting (amended spec §3; the Get 0.0 convention is dormancy for
-- names that may appear — a grid index never can). The grid point is
-- resolved here, once, and carried by the sentence.
mkC :: Grid -> Ix -> Maybe (Expr env Double)
mkC g k = MkC g k <$> gridLookup g k

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
data Util a y = Util (a -> y -> Double)

mkUtil :: (a -> y -> Double) -> Util a y
mkUtil = Util

applyUtil :: Util a y -> a -> y -> Double
applyUtil (Util f) = f

-- | Type-level scope size, so 'Var' can be priced as a name mention
-- (amended spec §3): the pricer reads |scope| from the environment
-- index, and Argmax bodies get the extended instance for free.
class KnownScope (env :: [Type]) where
  scopeLen :: Proxy env -> Int

instance KnownScope '[] where
  scopeLen _ = 0

instance KnownScope env => KnownScope (t ': env) where
  scopeLen _ = 1 + scopeLen (Proxy :: Proxy env)

-- | Total pricing: every constructible sentence has a price (structural
-- recursion; '-Wincomplete-patterns' as error makes totality a compile
-- fact). Contract (amended spec §3, prefix-decodable): every node pays
-- its constructor-choice cost log2 nExpr — 'Var' included — plus
-- content; description length is relative to the generating fragment's
-- production grammar (model-fragment dl is the enumerator's,
-- derivation-relative — plan R4).
--
-- GRAMMAR-HYGIENE STUB (Task 1, oracle phase): the body below is still
-- the parity-phase placeholder; the R5 table lands in Task 4 and the
-- hygiene suite's group 3 stays red until it does.
bits :: KnownScope env => Expr env t -> Bits
bits e0 = Bits (go e0)
  where
    go :: Expr env' t' -> Double
    go (MkC g _ _)   = 1 + logBase 2 (fromIntegral (gridSize g))
    go (Get _)       = 1 + nameBits
    go (If c t e)    = 1 + go c + go t + go e
    go (Gt a b)      = go a + go b
    go (Var _)       = 0
#ifndef DROP_PUSH
    go (Push a b)    = 1 + go a + go b
#endif
    go (CondE a b)   = 1 + go a + go b
    go (Expect a _)  = 1 + go a
#ifndef DROP_ARGMAX
    go (Argmax o v)  = 1 + go o + go v
#endif
    go (Call _ as)   = 1 + goArgs as

    goArgs :: Args env' ts -> Double
    goArgs ANil      = 0
    goArgs (a :* as) = go a + goArgs as

    nameBits :: Double
    nameBits = case featureNames of
      _ : _ : _ -> logBase 2 (fromIntegral (length featureNames))
      _         -> 0

-- | The priced feature namespace: @Get name@ costs
-- @log2 |featureNames|@ at the mention site (0 bits while the namespace
-- has one name). Runtime lookup is deliberately decoupled from pricing
-- (a sentence about a sensor that does not exist yet is sayable,
-- dormant, and priced).
featureNames :: [Name]
featureNames = ["t"]
