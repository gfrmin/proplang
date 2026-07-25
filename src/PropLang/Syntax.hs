{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE PatternSynonyms #-}
-- The 9+1 grammar (exact-freeze-r0): C(MkC), Get, Var, If, Gt, Sub,
-- Mul, Expect, Cond | Code. Every seat holds against an executed
-- composition attempt (pack IX.1/IX.3); Add is the derived name addM
-- (the author's closed form).
module PropLang.Syntax
  ( B, K
  , Name, Ix
  , Grid, mkGrid, gridName, gridSize
  , Carrier, mkCarrier, carrierName, carrierSize, carrierSpace
  , Namespace, mkNamespace, nsNames, nsSize
  , World (..)
  , Idx (..)
  , Expr ( Get, If, Gt, Var, Sub, Mul
#ifndef DROP_EXPECT
         , Expect
#endif
#ifndef DROP_COND
         , Cond
#endif
#ifndef DROP_CODE
         , Code
#endif
         , C
         )
  , mkC
  , addM
  , KnownScope (..)
  , ProdTable (..), prodTable
  , Charge (..), chargeMass
  , weightIn
  ) where

import Data.Kind (Type)
import Data.List.NonEmpty (NonEmpty, toList)
import Data.Proxy (Proxy (..))
import PropLang.Belief (Belief, Kernel, Space, mkSpace)

type B = Belief
type K = Kernel
type Name = String
type Ix = Int

-- | A CODEBOOK (ruling 1): a world-declared mention domain. Exact
-- points; a mention is priced 1/size (the M1 namespace law's shape).
data Grid = Grid Name [Rational]

mkGrid :: Name -> NonEmpty Rational -> Grid
mkGrid nm = Grid nm . toList

gridName :: Grid -> Name
gridName (Grid nm _) = nm

gridSize :: Grid -> Int
gridSize (Grid _ ps) = length ps

gridLookup :: Grid -> Ix -> Maybe Rational
gridLookup (Grid _ ps) k
  | k >= 0 && k < length ps = Just (ps !! k)
  | otherwise = Nothing

data Carrier c = Carrier Name (NonEmpty c)

mkCarrier :: Name -> NonEmpty c -> Carrier c
mkCarrier = Carrier

carrierName :: Carrier c -> Name
carrierName (Carrier nm _) = nm

carrierSize :: Carrier c -> Int
carrierSize (Carrier _ cs) = length (toList cs)

carrierSpace :: Carrier c -> Space c
carrierSpace (Carrier _ cs) = mkSpace cs

data Namespace = Namespace (NonEmpty Name)

mkNamespace :: NonEmpty Name -> Namespace
mkNamespace = Namespace

nsNames :: Namespace -> [Name]
nsNames (Namespace ns) = toList ns

nsSize :: Namespace -> Int
nsSize (Namespace ns) = length (toList ns)

-- | The World: what the world declares (E3 — no concrete point-set
-- lives in the core; every field is data handed in at the boundary).
-- The theta/tau/rho fields are CODEBOOKS (mention domains), never a
-- reasoning-fineness config (ruling 1).
data World = World
  { wNs    :: Namespace
  , wObs   :: Carrier Int
  , wTheta :: Grid
  , wTau   :: Grid
  , wRho   :: Grid
  }

data Idx (env :: [Type]) t where
  Z :: Idx (t ': env) t
  S :: Idx env t -> Idx (u ': env) t

-- The grammar. Rational is the language's numeric sort.
data Expr (env :: [Type]) t where
  MkC :: Grid -> Ix -> Rational -> Expr env Rational
  Get :: Name -> Expr env Rational
  If :: Expr env Bool -> Expr env t -> Expr env t -> Expr env t
  Gt :: Expr env Rational -> Expr env Rational -> Expr env Bool
  Var :: Idx env t -> Expr env t
  Sub, Mul :: Expr env Rational -> Expr env Rational -> Expr env Rational
#ifndef DROP_EXPECT
  -- the prevision atom: the belief's carrier bound AS Rational (the
  -- deleted ToR's conversion moved into the binder — fixed machinery,
  -- never sentence content), integrated against the body.
  Expect :: Real a
         => Expr env (B a) -> Expr (Rational ': env) Rational
         -> Expr env Rational
#endif
#ifndef DROP_COND
  -- THE FUSED CONDITIONING VERB (ruling 4): belief, kernel, observed
  -- outcome, Just-arm (posterior bound), Nothing-arm (impossible
  -- evidence — g6's load-bearing arm). Subsumes SawE/CondE/ElimJ; the
  -- Ev and Maybe(B) corridor sorts are gone. The outcome crosses into
  -- the sentence AS A RATIONAL (the deleted ToR's conversion lives in
  -- the verb, like Expect's and Code's binders — fixed machinery,
  -- never sentence content).
  Cond :: Real b
       => Expr env (B a) -> Expr env (K a b) -> Expr env Rational
       -> Expr (B a ': env) t -> Expr env t -> Expr env t
#endif
#ifndef DROP_CODE
  -- THE likelihood production (KER sort). Weight-form (II): the body
  -- denotes the emission MASS directly; latent and outcome are bound
  -- AS Rational (Real carriers; the binder converts). A code denotes
  -- iff every column is lawful: all masses >= 0, some > 0 — decidable,
  -- no NaN boundary.
  Code :: (Real a, Real b)
       => Space a -> Space b -> Expr (Rational ': Rational ': env) Rational
       -> Expr env (Maybe (K a b))
#endif

pattern C :: () => t ~ Rational => Grid -> Ix -> Rational -> Expr env t
pattern C g k v <- MkC g k v

#if !defined(DROP_EXPECT) && !defined(DROP_COND) && !defined(DROP_CODE)
{-# COMPLETE C, Get, If, Gt, Var, Sub, Mul, Expect, Cond, Code #-}
#endif

-- | The one door to a priced constant: on-codebook mentions only.
mkC :: Grid -> Ix -> Maybe (Expr env Rational)
mkC g k = MkC g k <$> gridLookup g k

-- | DERIVED NAME (the stdlib layer; the Add deletion's macro, in the
-- author's CLOSED FORM — it borrows no codebook zero, so addition is
-- sayable in EVERY declarable world):
--   Sub x x        == 0
--   Sub (Sub b b) b == -b
--   Sub a (Sub (Sub b b) b) == a + b
-- Priced at its expansion (three Sub nodes; b's subtree paid three
-- times — the honest cost of a 9-letter alphabet). Its derivation row
-- IS its deletion proof; there is no terminal to DROP.
addM :: Expr env Rational -> Expr env Rational -> Expr env Rational
addM a b = Sub a (Sub (Sub b b) b)

class KnownScope (env :: [Type]) where
  scopeLen :: Proxy env -> Int

instance KnownScope '[] where
  scopeLen _ = 0

instance KnownScope env => KnownScope (t ': env) where
  scopeLen _ = 1 + scopeLen (Proxy :: Proxy env)

-- | The declared production widths (ruling 2 as SUPERSEDED at the
-- repair sitting, 2026-07-25: the shipped table is 9/1 — Add's seat
-- fell to the executed closed-form composition; the P5 single-site
-- value).
data ProdTable = ProdTable { prodExpr, prodKer :: Int }

prodTable :: ProdTable
prodTable = ProdTable 9 1

-- | The pricing tree. CMass carries the EXACT mass of a content
-- mention (1/width as a Rational) — never a logarithm (the D1 fix:
-- a stored transcendental cannot be inverted). CMul is exact
-- multiplication: associative, so the tree shape is NOT load-bearing
-- (the step-4 float-order apparatus retires).
data Charge s = CW s | CMass Rational | CMul (Charge s) (Charge s)

chargeMass :: (s -> Integer) -> Charge s -> Rational
chargeMass w c0 = case c0 of
  CW s     -> 1 / fromInteger (w s)
  CMass m  -> m
  CMul a b -> chargeMass w a * chargeMass w b

-- | The exact weight of a raw sentence relative to a declared
-- namespace: 1/prodExpr per EXPR node (1/prodKer for Code), 1/|grid|
-- per constant mention, 1/scope per Var, 1/|ns| per Get. EXACT — the
-- prior's Kraft sum and every ratio law hold by (==). "Bits" is the
-- reporting edge's -log2 of this value.
weightIn :: forall env t. KnownScope env
         => Namespace -> Expr env t -> Rational
weightIn ns = go (scopeLen (Proxy :: Proxy env))
  where
    node, kerNode, nameW :: Rational
    node = 1 / fromIntegral (prodExpr prodTable)
    kerNode = 1 / fromIntegral (prodKer prodTable)
    nameW = 1 / fromIntegral (nsSize ns)
    go :: forall env' t'. Int -> Expr env' t' -> Rational
    go sc e = case e of
      C g _ _ -> node / fromIntegral (gridSize g)
      Get _ -> node * nameW
      If c t f -> node * go sc c * go sc t * go sc f
      Gt a b -> node * go sc a * go sc b
      Var _ -> node / fromIntegral sc
      Sub a b -> node * go sc a * go sc b
      Mul a b -> node * go sc a * go sc b
#ifndef DROP_EXPECT
      Expect a b -> node * go sc a * go (sc + 1) b
#endif
#ifndef DROP_COND
      Cond b k y j n -> node * go sc b * go sc k * go sc y
                        * go (sc + 1) j * go sc n
#endif
#ifndef DROP_CODE
      Code _ _ body -> kerNode * go (sc + 2) body
#endif
