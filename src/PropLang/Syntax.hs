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
  , Carrier, mkCarrier, carrierName, carrierSize, carrierSpace
  , Idx(..)
  , Expr( Get, If, Gt, Var
#ifndef DROP_PUSH
        , Push
#endif
        , CondE, Expect
#ifndef DROP_ARGMAX
        , Argmax
#endif
        , Call, C
#ifndef DROP_EXPFAM
        , ExpFam
#endif
        )
  , mkC
  , Fn(..)
  , Stats(..)
  , Args(..)
  , StdName(..)
  , Util, mkUtil, applyUtil
  , KnownScope(..)
  , bits
  , featureNames
  , carrierNames
  ) where

import Data.Kind (Type)
import Data.List.NonEmpty (NonEmpty, toList)
import Data.Proxy (Proxy (..))
import PropLang.Belief (Belief, Bits (..), Event, Evidence, Kernel, Space)

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

-- | A declared finite output space for the expfam basis (EXPFAM_PLAN
-- Q1/E4): 'Grid' generalized — a named finite point set, typed by its
-- carrier. Abstract; 'mkCarrier' is the constructor. Declarations are
-- domain data and live in "PropLang.Enumerate", like the grids. A
-- carrier mention is priced against the 'carrierNames' registry (same
-- written rule as 'featureNames': 0 bits while the registry is a
-- singleton).
data Carrier c = Carrier Name (NonEmpty c)

mkCarrier :: Name -> NonEmpty c -> Carrier c
mkCarrier = Carrier

carrierName :: Carrier c -> Name
carrierName (Carrier nm _) = nm

carrierSize :: Carrier c -> Int
carrierSize (Carrier _ pts) = length pts

-- | The carrier's points as a Space, through the public constructor —
-- expfam beliefs over a carrier normalize over exactly these points.
carrierSpace :: Carrier c -> Space c
carrierSpace = undefined -- Task-1 type-surface stub (oracle group 1 red)

-- | Defunctionalized sufficient-statistic syntax (first-order, priced;
-- the reported STATS alphabet, EXPFAM_PLAN Q4/E5): sole written member
-- 'SId', the identity statistic T(y) = y — bern's sufficient statistic
-- (interface.md §4). Sort-local coding (author pack §1): a STATS
-- choice costs log2 1 = 0 bits while the alphabet has one member; the
-- gauss pair (y, y²) is the named continuous-carrier debt and grows
-- this alphabet by reported change when it lands. The CPP flag is the
-- deletion audit's ablation point (test-expfam row 'sid').
data Stats c where
#ifndef DROP_SID
  SId :: Real c => Stats c
#endif

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
#ifndef DROP_EXPFAM
  -- the expfam basis (interface.md §4; EXPFAM_PLAN E3 as ruled): the
  -- family node IS a kernel from its (single) natural parameter to the
  -- declared carrier — the parameter arrives where the kernel is
  -- applied, as the K type says. The Space payload declares the
  -- kernel's domain (a kernel HAS a domain; declaring it is declared
  -- structure), priced 0 by the recorded opaque-payload convention.
  -- KER-sort: 0 constructor bits (sole production, author pack §1).
  ExpFam :: Space Double -> Carrier c -> Stats c -> Expr env (K Double c)
#endif

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
#ifndef DROP_EXPFAM
             ExpFam,
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
#if !defined(DROP_BERN) && !defined(DROP_EXPFAM)
  -- the derived name (EXPFAM_PLAN E6): bern re-derived over the expfam
  -- basis — a REPORTED alphabet change (STDNAME grows 4 -> 5, author
  -- pack §1). Belief-valued: the emission distribution at the
  -- evaluated parameter. The carrier rides as an opaque payload (the
  -- Fn-payload precedent); its mention is priced by the carrier
  -- registry at the 'bits' site. Executed semantics is the recorded
  -- fast form; the expfam expansion is the property-enforced contract
  -- (E7 — CL-4's doctrine at the name layer). Dies with the basis
  -- (E9): the flag conjunction is the coupling that keeps "delete
  -- expfam and nothing can assign likelihood" true at the code level.
  Bern   :: Carrier Int -> StdName '[Double] (B Int)
#endif

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
-- its constructor-choice cost @log2 nExpr@ — 'Var' included — plus
-- content ('Var' adds @log2 |scope|@, read from the type by
-- 'KnownScope' at the root and tracked through 'Argmax' binders).
-- Description length is relative to the generating fragment's
-- production grammar: this is the POLICY pricer; model-fragment dl is
-- the enumerator's, charged at derivation (plan R4).
bits :: forall env t. KnownScope env => Expr env t -> Bits
bits e0 = Bits (go (scopeLen (Proxy :: Proxy env)) e0)
  where
    -- the shipped grammar's written alternative counts (plan R2/R5):
    -- ten EXPR productions, four stdlib names, two Fn members.
    -- Alphabet data with prices, like grid points; counting is by
    -- written alternatives, not type-pruned availability.
    nodeB, stdB :: Double
    nodeB = logBase 2 10
    stdB  = logBase 2 4

    go :: Int -> Expr env' t' -> Double
    go sc e = case e of
      MkC g _ _  -> nodeB + logBase 2 (fromIntegral (gridSize g))
      Get _      -> nodeB + nameBits
      If c t f   -> nodeB + go sc c + go sc t + go sc f
      Gt a b     -> nodeB + go sc a + go sc b
      Var _      -> nodeB + logBase 2 (fromIntegral sc)
#ifndef DROP_PUSH
      Push a b   -> nodeB + go sc a + go sc b
#endif
      CondE a b  -> nodeB + go sc a + go sc b
      Expect a f -> nodeB + go sc a + fnB f
#ifndef DROP_ARGMAX
      Argmax o v -> nodeB + go sc o + go (sc + 1) v
#endif
#ifndef DROP_EXPFAM
      ExpFam {}  -> undefined -- Task-1 stub (KER-sort price lands at Task 3)
#endif
      Call _ as  -> nodeB + stdB + goArgs sc as

    goArgs :: Int -> Args env' ts -> Double
    goArgs _  ANil      = 0
    goArgs sc (a :* as) = go sc a + goArgs sc as

    -- one FN choice bit (log2 2, the two written members — plan Q1);
    -- the opaque value-layer payloads are priced 0, the recorded
    -- parity-scoped convention.
    fnB :: Fn a -> Double
    fnB _ = 1

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

-- | The priced carrier registry (EXPFAM_PLAN E4): a carrier mention
-- costs @log2 |carrierNames|@ at the mention site — 0 bits while the
-- registry has one declared carrier, the same written rule as
-- 'featureNames'. The declarations themselves are domain data in
-- "PropLang.Enumerate".
carrierNames :: [Name]
carrierNames = ["obs"]
