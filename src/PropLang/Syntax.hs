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
#ifndef DROP_CONDE
        , CondE
#endif
#ifndef DROP_EXPECT
        , Expect
#endif
#ifndef DROP_ARGMAX
        , Argmax
#endif
        , C
#ifndef DROP_SAWE
        , SawE
#endif
#ifndef DROP_ELIMJ
        , ElimJ
#endif
#ifndef DROP_CODE
        , Code
#endif
#ifndef DROP_POS
        , Pos
#endif
#ifndef DROP_TOR
        , ToR
#endif
        , Add, Sub, Mul, Div, Log, Exp, Neg
        )
  , mkC
  , KnownScope(..)
  , ProdTable(..), prodTable
  -- THE STEP-4 TYPE SURFACE (one pricing mechanism, two declared
  -- tables). Oracle-phase stubs until the author's freeze.
  , Charge (..)
  , chargeBits
  , bits
  , featureNames
  , carrierNames
  , Namespace, mkNamespace, nsNames, nsSize
  , bitsIn
  ) where

import Data.Kind (Type)
import Data.List.NonEmpty (NonEmpty, toList)
import Data.Proxy (Proxy (..))
import PropLang.Belief (Belief, Bits (..), Evidence, Kernel, Space,
                        mkSpace)

-- Type derivation (§8c audit, step 6, pack §28): synonyms of the sealed
-- reasoner's objects (with Name and Ix below).
type B = Belief
type K = Kernel
type Ev = Evidence

-- Type derivation (§8c audit, step 6, pack §28): a published feature name
-- (interface §1).
type Name = String

-- | Index into a priced grid. Out-of-range mentions are UNCONSTRUCTIBLE
-- (amended spec §3): the only door to a priced constant is 'mkC', which
-- returns 'Nothing' off the grid. The 'Get' 0.0 convention is dormancy
-- for names that may appear later; a grid index never can, so it gets
-- no denotation at all.
-- Type derivation (§8c audit, step 6, pack §28): index into declared
-- grids — synonym, part of the priced surface.
type Ix = Int

-- | A priced grid of sayable constants: a named, finite point set whose
-- mention costs @log2 n@ bits. Data with prices (design §5); the concrete
-- theta\/tau\/rho grids live in "PropLang.Enumerate".
-- Type derivation (§8c audit, step 6, pack §28): grid definitions are
-- data with prices (CLAUDE.md forbidden-moves list).
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
-- Type derivation (§8c audit, step 6, pack §28): the declared observation
-- carrier (ExpFam basis, plan E9).
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
carrierSpace (Carrier _ pts) = mkSpace pts

-- | Typed de Bruijn index into the environment.
-- Type derivation (§8c audit, step 6, pack §28): the priced language
-- itself: programs as data (brief §2; with Expr/Args).
data Idx env t where
  Z :: Idx (t ': env) t
  S :: Idx env t -> Idx (u ': env) t

-- | The program grammar. The verbs are sayable (reflexive closure);
-- 'Argmax' binds its option variable in an extended typed environment.
-- 'Argmax' ranges over 'NonEmpty' options: a totality-forced deviation
-- from the spec §3 sketch's @[o]@, approved at Phase 1 review.
-- Type derivation (§8c audit, step 6, pack §28): the priced language
-- itself: programs as data (brief §2).
data Expr env t where
  MkC    :: Grid -> Ix -> Double -> Expr env Double  -- NOT exported: 'mkC' is the only door (R1)
  Get    :: Name -> Expr env Double                  -- absent name ~> 0.0
  If     :: Expr env Bool -> Expr env t -> Expr env t -> Expr env t
  Gt     :: Expr env Double -> Expr env Double -> Expr env Bool
  Var    :: Idx env t -> Expr env t
#ifndef DROP_PUSH
  Push   :: Expr env (B a) -> Expr env (K a b) -> Expr env (B b)
#endif
#ifndef DROP_CONDE
  CondE  :: Expr env (B a) -> Expr env (Ev a) -> Expr env (Maybe (B a))
#endif
#ifndef DROP_EXPECT
  -- the PREVISION atom (step 9; brief §3: "take the prevision — a
  -- coherent expectation functional — as the atom, and derive
  -- probability from it"). A binder: the belief's carrier is bound as a
  -- real (the residue convention step 8 established, 'realToFrac' of the
  -- outcome at 'Var Z'), the body an ordinary EXPR in extended scope.
  -- It SUBSUMES the FN sort — 'prob b e' is 'Expect b (indicator)' and
  -- utility-prevision is 'Expect b (priced body)' (E-e1b, 42 rows
  -- bit-exact; the 'Fn'/'FnInd'/'FnUtil' surface and the 'Event'
  -- peer-noun all dissolve into it). The body's RESIDUE (the bound
  -- outcome variable) survives here and dies at outcome-as-feature.
  Expect :: Real a => Expr env (B a) -> Expr (Double ': env) Double
                   -> Expr env Double
#endif
#ifndef DROP_ARGMAX
  Argmax :: Expr env (NonEmpty o) -> Expr (o ': env) Double -> Expr env o
#endif
#ifndef DROP_SAWE
  -- the evidence producer (step 9): evidence is a kernel applied to an
  -- outcome ('PropLang.Belief.Saw' made sayable) — the ONLY producer of
  -- 'Expr env (Ev a)', so it is what makes 'CondE' reachable from a
  -- sentence (AGENT_PLAN:501, "the hole VThink papered over"). Its
  -- kernel argument is a BARE 'K a b' (an env-validated kernel), never a
  -- raw 'Code' — which is why 'ElimJ' owes one Maybe, not two.
  SawE :: Eq b => Expr env (K a b) -> Expr env b -> Expr env (Ev a)
#endif
#ifndef DROP_ELIMJ
  -- the conditioned-belief eliminator (step 9): a conditioned belief is
  -- 'Maybe'-valued for totality ('cond' returns 'Maybe', the
  -- impossible-evidence case a value not an exception); 'ElimJ' is the
  -- ONLY consumer that lets a sentence USE it. ONE Maybe, not two:
  -- 'Code''s 'Maybe (K a b)' is eliminated at the engine layer (step-3
  -- ruling 4), so no sentence eliminates it. The Nothing arm is an
  -- ordinary EXPR — a SENTENCE-LEVEL default, never a baked constant,
  -- because it is LOAD-BEARING when the impossible is reached with real
  -- weight (E-e1a's non-weight-zero case, default 0.42 shown through).
  ElimJ :: Expr env (Maybe (B a)) -> Expr (B a ': env) t -> Expr env t
                                  -> Expr env t
#endif
#ifndef DROP_CODE
  -- THE likelihood production (AGENT_PLAN §2a, boundary agent-boundary-r1).
  -- A kernel whose rows are 2^(-L), where L is an ordinary PRICED
  -- EXPRESSION: the CODE LENGTH of the outcome y (Var Z) in the context x
  -- (Var (S Z)). The same principle as the prior — 'fromBits'
  -- (Belief.hs:133) is already "the ONLY place a prior comes from", and by
  -- KRAFT nothing is more foundational: every distribution IS a code,
  -- bijectively, so this is a reparameterization and no generality is lost.
  --
  -- It is not new behaviour. `walkOn` (Enumerate.hs:342) ALREADY computes
  -- 2^(-L) through 'fromBits', hard zeros and all — it was written, called a
  -- special case, and shelved. Executed at the oracle phase: the code form
  -- reproduces walkOn BIT-FOR-BIT, 567/567 cells (AGENT_PLAN §5d).
  --
  -- KER-sort. The Space payloads declare domain and codomain (a kernel HAS
  -- them; declaring them is declared structure), priced 0 by the recorded
  -- opaque-payload convention — the ExpFam precedent, verbatim.
  --
  -- The Maybe codomain is R-C1 ruling (iii) (pack §6.10, author 2026-07-13):
  -- a code whose column carries NaN or −∞, or no mass at all, DOES NOT
  -- DENOTE — the partiality lives in the type, at the one door where
  -- arbitrary arithmetic enters, and 'fromBits' stays total on what reaches
  -- it. Elimination is deferred exactly as CondE's is (ElimJ, build-order
  -- step 9): an unvalidated code cannot feed a verb.
  Code :: Space a -> Space b -> Expr (b ': a ': env) Double -> Expr env (Maybe (K a b))
#endif
#ifndef DROP_POS
  -- the POSITION reader (AGENT_PLAN §5d): the position of a point in its
  -- DECLARED space. `walkOn`'s adjacency is UNSAYABLE without it: the
  -- shipped grids are FP-nonuniform (0.2 + 0.1 = 0.30000000000000004), so
  -- adjacency is NOT a function of the values, and the boundary reflection
  -- doubles a neighbour's mass. Deletion costs the reflected walk.
  --
  -- DISTINCT FROM 'ToR', and the distinction is load-bearing: this returns a
  -- POSITION, that returns a VALUE. They coincide on every carrier shipped
  -- today only because obsCarrier = mkCarrier "obs" (0 :| [1]) — a
  -- coincidence of the declarations, not a theorem (§5d).
  Pos :: Eq a => Space a -> Expr env a -> Expr env Double
#endif
#ifndef DROP_TOR
  -- the VALUE reader (AGENT_PLAN §5d): a carrier point as a Double. THIS —
  -- not 'Pos' — is what subsumes Stats/SId, since statVal SId = realToFrac
  -- (Eval.hs:168). expfam's eta * T(y) needs T(y) :: Double, and a POSITION
  -- cannot supply it. Deletion costs every statistic.
  ToR :: Real c => Expr env c -> Expr env Double
#endif
  -- THE ARITHMETIC (AGENT_PLAN §5). Forced by the LIKELIHOOD, not by
  -- utility: a code length IS an arithmetic expression, and a Double-valued
  -- sentence could previously only be nested If/Gt over grid constants —
  -- piecewise constant. It could not express -log2 theta, nor eta*T(y)/ln2,
  -- nor walkOn's mass.
  --
  -- The engine has been computing every one of these in Haskell, behind the
  -- alphabet's back, since Phase 2. They are not being ADDED. They are being
  -- CONFESSED, and their price now enters the prior where it belongs.
  --
  -- No 'logBase': logBase 2 y == Log y / Log 2 EXACTLY (GHC.Float's own
  -- definition), measured bit-exact 9/9 at the oracle phase (§5d).
  Add, Sub, Mul, Div :: Expr env Double -> Expr env Double -> Expr env Double
  -- 'Neg' is separate from 'Sub': 0 - x differs from negate x at -0.0, a
  -- real IEEE-754 distinction, recorded in AGENT_PLAN OPEN 5.
  Log, Exp, Neg :: Expr env Double -> Expr env Double

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
#ifndef DROP_CONDE
             CondE,
#endif
#ifndef DROP_EXPECT
             Expect,
#endif
#ifndef DROP_ARGMAX
             Argmax,
#endif
#ifndef DROP_SAWE
             SawE,
#endif
#ifndef DROP_ELIMJ
             ElimJ,
#endif
#ifndef DROP_CODE
             Code,
#endif
#ifndef DROP_POS
             Pos,
#endif
#ifndef DROP_TOR
             ToR,
#endif
             Add, Sub, Mul, Div, Log, Exp, Neg #-}

-- | The ONLY constructor of a priced-constant sentence: 'Nothing' off
-- the grid, so a malformed constant is unconstructible rather than
-- denoting (amended spec §3; the Get 0.0 convention is dormancy for
-- names that may appear — a grid index never can). The grid point is
-- resolved here, once, and carried by the sentence.
mkC :: Grid -> Ix -> Maybe (Expr env Double)
mkC g k = MkC g k <$> gridLookup g k

-- | Type-level scope size, so 'Var' can be priced as a name mention
-- (amended spec §3): the pricer reads |scope| from the environment
-- index, and Argmax bodies get the extended instance for free.
class KnownScope (env :: [Type]) where
  scopeLen :: Proxy env -> Int

instance KnownScope '[] where
  scopeLen _ = 0

instance KnownScope env => KnownScope (t ': env) where
  scopeLen _ = 1 + scopeLen (Proxy :: Proxy env)

-- | The normative production table's written alternative counts
-- (spec §3; HOSTS_PLAN §0.3 — P5's single-site alphabet constant,
-- landed at the govhost freeze): ONE value, total by construction. A
-- count change edits exactly this value plus the enumerated frozen
-- pins of the changed sort (the P5 forward ruling's mandatory boundary
-- item); the govhost oracle's gP5 group pins the identity — 'bits'
-- moves nowhere at the re-base.
--
-- SINCE THE STEP-9 ELIMINATION (elim-freeze-r0, WIDE): SIX FIELDS ->
-- TWO. Four whole sorts vanished — STDNAME (the five VoI verbs + IsEq,
-- deleted), FN (FnInd/FnUtil, subsumed by the Expect binder), UTIL
-- (USay, utility is an ordinary Expr), STATS (SId, subsumed by ToR) —
-- and KER lost 'ExpFam' (subsumed by 'Code', bit-for-bit; only 'Code'
-- remains). Two sorts stand where six stood; every survivor carries an
-- executed proof (AGENT_PLAN §5b's "22 productions, 2 sorts").
-- Type derivation (§8c audit, step 6, pack §28): the DECLARED production
-- table — prices are data, never hand counts.
data ProdTable = ProdTable
  { prodExpr, prodKer :: Int }

prodTable :: ProdTable
prodTable = ProdTable 20 1

-- | THE CHARGE TREE (step 4: one pricing mechanism, two declared
-- tables): a derivation's price as DECLARED DATA. The tree's shape IS
-- the float order (the E-s1/test-code doctrine) — float addition is
-- not associative, and at today's leaf values the fragments' shapes
-- coincide with refolds only because every sort width is exactly one
-- bit (measured, E-p1/assoc probe); the association ships as data so
-- correctness never depends on that coincidence. Transparent: charge
-- trees are declarable data, like the width tables they mention.
-- Type derivation (§8c audit, step 6, pack §28): step 4's mechanism: the
-- float order as declared data (with PolSort).
data Charge s
  = CW s                          -- a sort-choice: lg (width s)
  | CBits Double                  -- content (a grid or namespace mention)
  | CSum (Charge s) (Charge s)    -- float addition, THIS association

-- | THE MECHANISM: the one definition in src that turns declared
-- widths into bits (step 4's charter — after its freeze, both the
-- policy pricer and the sentence fragment's derivation charges route
-- through this evaluator, each over its own declared table and its
-- own declared tree shapes).
chargeBits :: (s -> Int) -> Charge s -> Double
chargeBits w c0 = case c0 of
  CW s     -> logBase 2 (fromIntegral (w s))
  CBits d  -> d
  CSum a b -> chargeBits w a + chargeBits w b

-- | Total pricing: every constructible sentence has a price (structural
-- recursion; '-Wincomplete-patterns' as error makes totality a compile
-- fact). Contract (amended spec §3, prefix-decodable): every node pays
-- its constructor-choice cost @log2 nExpr@ — 'Var' included — plus
-- content ('Var' adds @log2 |scope|@, read from the type by
-- 'KnownScope' at the root and tracked through 'Argmax' binders).
-- Description length is relative to the generating fragment's
-- production grammar: this is the POLICY pricer; model-fragment dl is
-- the enumerator's, charged at derivation (plan R4).
bits :: KnownScope env => Expr env t -> Bits
bits = bitsAt frozenNameBits
  where
    frozenNameBits :: Double
    frozenNameBits = case featureNames of
      _ : _ : _ -> logBase 2 (fromIntegral (length featureNames))
      _         -> 0

-- The policy fragment's sorts, for the mechanism's table read (the
-- 'FragSort' analogue on this side; internal — the public single site
-- stays 'prodTable', whose fields these constructors name one-for-one).
-- Type derivation (§8c audit, step 6, pack §28): step 4's mechanism (with
-- Charge): the policy sorts it prices.
data PolSort
  = PolExpr | PolKer

polWidth :: PolSort -> Int
polWidth s = case s of
  PolExpr    -> prodExpr prodTable
  PolKer     -> prodKer prodTable

-- The shared pricing worker (MEMBRANE_PLAN T1): the whole production
-- system with the name-mention charge as a parameter — 'bits' and
-- 'bitsIn' are one arithmetic, one tree, no drift (the E7 doctrine at
-- the pricer; the membrane oracle pins the identity with ==).
--
-- SINCE THE STEP-4 PRICING FREEZE (ruling D-p1(B)): the worker BUILDS
-- a declared charge tree ('Charge PolSort') mirroring its frozen fold
-- shapes node for node, and prices it through THE MECHANISM
-- ('chargeBits' — the one definition in src that turns declared
-- widths into bits; E-p1 measured the mirror bit-identical over
-- 11,851 policy charges before the ruling froze). The alternative
-- counts are read from 'prodTable' — the P5 single site — through
-- 'polWidth'; the counts are stated THERE and in the spec's table
-- only. Counting is by written alternatives, not type-pruned
-- availability. THE TREE'S SHAPE IS THE FLOAT ORDER: any future
-- shortcut that skips tree-building is a fast path under the §1b law
-- and arrives with its pin (the pricing freeze's recorded caution).
bitsAt :: forall env t. KnownScope env => Double -> Expr env t -> Bits
bitsAt nameBits e0 =
  Bits (chargeBits polWidth (go (scopeLen (Proxy :: Proxy env)) e0))
  where
    node :: Charge PolSort
    node = CW PolExpr

    go :: Int -> Expr env' t' -> Charge PolSort
    go sc e = case e of
      MkC g _ _  -> CSum node (CBits (logBase 2 (fromIntegral (gridSize g))))
      Get _      -> CSum node (CBits nameBits)
      If c t f   -> CSum (CSum (CSum node (go sc c)) (go sc t)) (go sc f)
      Gt a b     -> CSum (CSum node (go sc a)) (go sc b)
      Var _      -> CSum node (CBits (logBase 2 (fromIntegral sc)))
#ifndef DROP_PUSH
      Push a b   -> CSum (CSum node (go sc a)) (go sc b)
#endif
#ifndef DROP_CONDE
      CondE a b  -> CSum (CSum node (go sc a)) (go sc b)
#endif
#ifndef DROP_EXPECT
      -- the prevision atom (step 9): constructor choice + the belief,
      -- plus the utility body priced as an ordinary EXPR in the
      -- outcome-bound extended scope (the FN choice bit is GONE — the
      -- Fn sort dissolved into this binder). The body was priced 0 as
      -- an opaque Fn payload before step 9; utility is a priced
      -- sentence now.
      Expect a b -> CSum (CSum node (go sc a)) (go (sc + 1) b)
#endif
#ifndef DROP_ARGMAX
      Argmax o v -> CSum (CSum node (go sc o)) (go (sc + 1) v)
#endif
#ifndef DROP_SAWE
      -- the evidence producer (step 9): constructor choice + the kernel
      -- expression + the outcome expression
      SawE k y   -> CSum (CSum node (go sc k)) (go sc y)
#endif
#ifndef DROP_ELIMJ
      -- the conditioned-belief eliminator (step 9): constructor choice +
      -- the Maybe-belief, the Just arm priced in the belief-bound extended
      -- scope, and the Nothing arm an ordinary EXPR
      ElimJ m j n -> CSum (CSum (CSum node (go sc m)) (go (sc + 1) j))
                          (go sc n)
#endif
#ifndef DROP_CODE
      -- KER-sort (AGENT_PLAN §2a): the constructor choice, plus the code
      -- length's own PRICE as an ordinary EXPR in the body's extended
      -- scope. Code binds TWO variables (y at Var Z, x at Var (S Z)), so
      -- the body prices at sc + 2 -- the Argmax binder discipline, twice.
      -- The Space payloads are priced 0 (the opaque-payload convention).
      --
      -- This is where "the alphabet IS the prior" finally reaches the
      -- likelihood: a structured code is short, an arbitrary code TABLE is
      -- O(|x|*|y|) bits, and bern beats the table BECAUSE IT IS SHORTER --
      -- not because we forbade the table (brief §8's method, applied to
      -- likelihoods for the first time).
      Code _ _ b -> CSum (CW PolKer) (go (sc + 2) b)
#endif
#ifndef DROP_POS
      Pos _ e'   -> CSum node (go sc e')
#endif
#ifndef DROP_TOR
      ToR e'     -> CSum node (go sc e')
#endif
      Add a b    -> CSum (CSum node (go sc a)) (go sc b)
      Sub a b    -> CSum (CSum node (go sc a)) (go sc b)
      Mul a b    -> CSum (CSum node (go sc a)) (go sc b)
      Div a b    -> CSum (CSum node (go sc a)) (go sc b)
      Log a      -> CSum node (go sc a)
      Exp a      -> CSum node (go sc a)
      Neg a      -> CSum node (go sc a)

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

-- | A world's visible feature namespace (MEMBRANE_PLAN T1, ruling M1 —
-- the normative pricing law): description length is namespace-relative;
-- a name mention costs @log2 |ns|@ against the WORLD's visible
-- namespace, so publishing a name raises every mention's cost and
-- re-weights the prior. The namespace is declared per world and covers
-- the Get-mentionable names only (ruling M5: the action vocabulary
-- prices through slots and argmax, never through this registry);
-- 'featureNames' remains the frozen worlds' singleton declaration and
-- 'bits' remains its pricer. Abstract, like 'Carrier'.
-- Type derivation (§8c audit, step 6, pack §28): mention pricing over the
-- completed namespace (M1; RIDER 2).
data Namespace = Namespace (NonEmpty Name)

mkNamespace :: NonEmpty Name -> Namespace
mkNamespace = Namespace

nsNames :: Namespace -> NonEmpty Name
nsNames (Namespace ns) = ns

nsSize :: Namespace -> Int
nsSize (Namespace ns) = length ns

-- | Namespace-relative pricing (MEMBRANE_PLAN T1; the namespace law,
-- spec §3): 'bits' with the name-mention term charged against the
-- given namespace instead of the frozen registry — @log2 |ns|@ per
-- mention, 0 bits while the namespace has one name (the frozen worlds'
-- case, whose prices this leaves untouched: the oracle pins
-- @bitsIn (mkNamespace ("t" :| [])) == bits@ with ==).
bitsIn :: KnownScope env => Namespace -> Expr env t -> Bits
bitsIn ns = bitsAt (case nsSize ns of
  1 -> 0
  k -> logBase 2 (fromIntegral k))
