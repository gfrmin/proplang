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
-- deletion of a verb is a code-level ablation, not a runtime mock. The
-- corresponding 'bits' cases sit behind the same flags, so the ablated
-- grammar keeps a total pricer.
module PropLang.Syntax
  ( B, K, Ev
  , Name, Ix
  , Grid, mkGrid, gridName, gridSize, gridLookup
  , Idx(..)
  , Expr(..)
  , Fn
  , Args(..)
  , StdName(..)
  , Util, mkUtil, applyUtil
  , bits
  , featureNames
  ) where

import Data.List.NonEmpty (NonEmpty, toList)
import PropLang.Belief (Belief, Bits (..), Evidence, Kernel)

type B = Belief
type K = Kernel
type Ev = Evidence

type Name = String

-- | Index into a priced grid. Out-of-range mentions are sayable and
-- dormant: the evaluator reads them as 0.0, the same convention as an
-- absent 'Get' name (the Phase 1 report's recorded partiality of @C@ is
-- resolved by total dormancy, not by a runtime error).
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

-- | Total point lookup: 'Nothing' off the grid (the evaluator maps it to
-- the dormant 0.0).
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

-- | Defunctionalized function syntax (first-order, priced). Uninhabited
-- in the parity phase: no frozen test constructs one, and the evaluator
-- discharges the 'Expect' case by empty match. Constructors (with
-- prices) arrive with the ExpFam basis (porting order, step 6).
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
data Util a y = Util (a -> y -> Double)

mkUtil :: (a -> y -> Double) -> Util a y
mkUtil = Util

applyUtil :: Util a y -> a -> y -> Double
applyUtil (Util f) = f

-- | Total pricing: every constructible sentence has a price (structural
-- recursion; '-Wincomplete-patterns' as error makes totality a compile
-- fact). The model fragment carries the reference prices exactly: one
-- choice bit per two-alternative nonterminal, @log2 n@ per grid mention,
-- the sole-alternative TEST free. The policy fragment is priced one
-- choice bit per verb node and zero per variable mention — unfrozen in
-- the parity phase (no frozen test utters a priced policy sentence), and
-- an alphabet-change report accompanies any future re-pricing.
bits :: Expr env t -> Bits
bits e0 = Bits (go e0)
  where
    go :: Expr env' t' -> Double
    go (C g _)       = 1 + logBase 2 (fromIntegral (gridSize g))
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
