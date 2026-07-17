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
#ifndef DROP_USAY
        , USay
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
  , Fn(..)
  , Stats(..)
  , Args(..)
  , StdName(..)
  , USent (..)
#ifndef DROP_VPRE
  , Chan, mkChan, applyChan
#endif
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
import PropLang.Belief (Belief, Bits (..), Event, Evidence, Kernel, Space,
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

-- | Defunctionalized sufficient-statistic syntax (first-order, priced;
-- the reported STATS alphabet, EXPFAM_PLAN Q4/E5): sole written member
-- 'SId', the identity statistic T(y) = y — bern's sufficient statistic
-- (interface.md §4). Sort-local coding (author pack §1): a STATS
-- choice costs log2 1 = 0 bits while the alphabet has one member; the
-- gauss pair (y, y²) is the named continuous-carrier debt and grows
-- this alphabet by reported change when it lands. The CPP flag is the
-- deletion audit's ablation point (test-expfam row 'sid').
-- Type derivation (§8c audit, step 6, pack §28): defunctionalized
-- sufficient statistics — no host lambdas in Expr.
data Stats c where
#ifndef DROP_SID
  SId :: Real c => Stats c
#endif

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
#ifndef DROP_USAY
  -- the pointer's door (increment 6, CIRL_PLAN C3 as ruled): the
  -- priced utility. A NEW SORT (UTIL, spec section 3 table row at this
  -- increment's freeze): USay is the sole codeword at declared
  -- utility-valued holes (the ExpFam maneuver — outside EXPR's ten
  -- written alternatives, 0 constructor bits), its payload priced as
  -- EXPR in its own two-variable scope. Env convention as ruled:
  -- Var Z is the option code, Var (S Z) the latent parameter. The
  -- subprogram is CLOSED — evaluation discards the outer environment —
  -- SINCE THE STEP-8 FREEZE (outcome-freeze-r0/r0a): THE PAYLOAD IS
  -- EVALUATED AT THE TICK'S FEATURES through the one bridge
  -- ('PropLang.Eval.uAt') — 'Get' inside a utility READS THE WORLD,
  -- because features ARE the consequences (A1). This comment read,
  -- until step 8: "The subprogram is CLOSED — evaluation discards the
  -- outer environment — so utilities are featureless and clockless as
  -- a definition-level fact ('Get' inside a utility is dormant,
  -- per-node-priced syntax)." E-d1 measured that "definition-level
  -- fact" to be ONE EMPTY ENVIRONMENT ARGUMENT; the closed face
  -- survives as the empty-environment case, @uAt [] u a y@, which
  -- test-cirl's doctrine row asserts beside the repeal's face.
  -- The env convention is the RESIDUE scope (named at the step-8
  -- sitting): Var Z the option code, Var (S Z) the outcome — the
  -- not-yet-featurized residue of Savage's (act, outcome) pair, kept
  -- for continuity through the demolition and dying knowingly at a
  -- named boundary (the A1-terminal form: Get-only over the completed
  -- feature row, reachable when worlds publish outcomes as features).
  -- Dies with DROP_USAY: delete the door and NO UTILITY EXISTS AT ALL
  -- — the worlds and the verbs survive, but the old escape (the
  -- opaque world-data face, 'mkUtil') is GONE with the wrapper, so
  -- this door is now the only one. The deletion proof is strictly
  -- stronger than it was at the CIRL increment.
  USay :: Expr '[Double, Double] Double -> Expr env USent
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
             CondE, Expect,
#ifndef DROP_ARGMAX
             Argmax,
#endif
#ifndef DROP_EXPFAM
             ExpFam,
#endif
#ifndef DROP_USAY
             USay,
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
             Add, Sub, Mul, Div, Log, Exp, Neg,
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
-- Type derivation (§8c audit, step 6, pack §28): defunctionalized
-- function forms (the Fn/Stats mandate, CLAUDE.md).
data Fn a where
#ifndef DROP_FNIND
  FnInd  :: Event a -> Fn a
#endif
#ifndef DROP_FNUTIL
  FnUtil :: Real a => USent -> Double -> Fn a
#endif

-- | The ONLY constructor of a priced-constant sentence: 'Nothing' off
-- the grid, so a malformed constant is unconstructible rather than
-- denoting (amended spec §3; the Get 0.0 convention is dormancy for
-- names that may appear — a grid index never can). The grid point is
-- resolved here, once, and carried by the sentence.
mkC :: Grid -> Ix -> Maybe (Expr env Double)
mkC g k = MkC g k <$> gridLookup g k

-- | Typed argument list for 'Call'.
-- Type derivation (§8c audit, step 6, pack §28): the priced language
-- itself: programs as data (brief §2; with Idx/Expr).
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
-- Type derivation (§8c audit, step 6, pack §28): the stdlib alphabet:
-- derived names with prices (brief §9).
data StdName args t where
  EU     :: Real y => StdName '[B y, USent, [(Name, Double)], Double] Double
  IsEq   :: Eq a => StdName '[a, a] Bool
  VAct   :: StdName '[B Double, USent, NonEmpty Double] Double
  VThink :: Eq y => StdName '[B Double, K Double y, [y], USent, NonEmpty Double, Int, Double] Double
#ifndef DROP_LADDER
  -- the fidelity ladder's rung valuation (increment 4, LADDER_PLAN L1
  -- reading c / L3 as ruled): a REPORTED alphabet change, STDNAME
  -- grows 5 -> 6 (stdB moves lg 5 -> lg 6; the author's one-literal
  -- amendment of the frozen expfam price pin accompanies this member
  -- in the same freeze commit). Contract: @VThinkK d b k ys u acts n
  -- price@ is Est_d - Est_0 the value of acting now (the induction
  -- base), Est_k the next-batch preposterior of Est_{k-1} minus the
  -- tick's price - so depth 1 is exactly @VThink@ and depth k
  -- telescopes to the k-batch preposterior of acting minus k*price.
  -- Dies with the ladder (DROP_LADDER), never with the myopic base.
  VThinkK :: Eq y => StdName '[Int, B Double, K Double y, [y], USent, NonEmpty Double, Int, Double] Double
#endif
#ifndef DROP_VPRE
  -- the action-dependent preposterior (increment 5, PREPOSTERIOR_PLAN
  -- P1/P4 as ruled): a REPORTED alphabet change, STDNAME grows 6 -> 7
  -- (stdB moves lg 6 -> lg 7; the author's two frozen price-pin
  -- amendments accompany this member in the same freeze commit).
  -- Contract: @VPre d b ch ys uD ds u acts n price@ is W_d - W_0 the
  -- frozen leaf (vAct over the terminal menu, the induction base),
  -- W_j the best interior decision's immediate prevision plus the
  -- continuation through ITS OWN channel, price outside the max. The
  -- frozen VThink chain is the mute-singleton degenerate case (the
  -- oracle pins == at the verb layer). Dies with DROP_VPRE; the
  -- myopic base and the fidelity ladder survive.
  VPre :: Eq y => StdName '[Int, B Double, Chan Double Double y, [y], USent, NonEmpty Double, USent, NonEmpty Double, Int, Double] Double
#endif
  -- ('Bern' LEFT the stdlib at the step-3 sentence freeze: Bernoulli
  -- emission is said as a CODE of the declared production table, and
  -- the evaluator's 'bernFast' remains the E7-pinned fast form.
  -- STDNAME 7 -> 6, the P5 refund; the deletion the UseBern fixture
  -- proved possible became the deletion that happened —
  -- discharged-permanent.)

-- | A utility as a PRICED SENTENCE (step 8: `Util a y` — the
-- host-function wrapper that carried the calculator — dies; the
-- program that was always inside USay is the surface now).
--
-- Type derivation (§8c audit, step 8): DERIVES — utility is a priced
-- sentence (brief §9, CIRL; the one grammar, the one price source),
-- evaluated at the tick's features (A1: features ARE the world state
-- as rendered). RESIDUE NOTE (the step-8 sitting): the two-variable
-- scope is the not-yet-featurized residue of Savage's (act, outcome)
-- pair — retained for continuity through the demolition; the
-- A1-terminal form is Get-only over the completed feature row
-- (reachable when worlds publish outcomes as features); the residue
-- dies knowingly at a named boundary, never as a lingering default.
newtype USent = USent (Expr '[Double, Double] Double)

#ifndef DROP_VPRE
-- | An action-indexed evidence channel (PREPOSTERIOR_PLAN P3 as
-- ruled): the value-layer opaque wrapper, the 'Util' pattern verbatim
-- — which kernel the world shows depends on which decision fires.
-- Composition, not widening: 'Evidence' stays the closed variant,
-- 'Kernel' is untouched, and conditioning still enters only as
-- evidence. Parity-scoped, recorded: when channels become latent (the
-- CIRL neighborhood), Chan must become priced syntax — the same debt
-- 'Util' carries.
-- Type derivation (§8c audit, step 6, pack §28): the CIRL channel
-- (increment 6, utility-as-latent under the discrete reading); step-8
-- subject beside Util.
data Chan d h y = Chan (d -> Kernel h y)

mkChan :: (d -> Kernel h y) -> Chan d h y
mkChan = Chan

applyChan :: Chan d h y -> d -> Kernel h y
applyChan (Chan f) = f
#endif

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
-- landed at the govhost freeze): ONE value, six fields, total by
-- construction. A count change edits exactly this value plus the
-- enumerated frozen pins of the changed sort (the P5 forward
-- ruling's mandatory boundary item); the govhost oracle's gP5 group
-- pins the identity — 'bits' moves nowhere at the re-base.
-- Type derivation (§8c audit, step 6, pack §28): the DECLARED production
-- table — prices are data, never hand counts.
data ProdTable = ProdTable
  { prodExpr, prodFn, prodStats, prodKer, prodStdName, prodUtil :: Int }

prodTable :: ProdTable
prodTable = ProdTable 19 2 1 2 6 1

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
  = PolExpr | PolFn | PolStats | PolKer | PolStdName | PolUtil

polWidth :: PolSort -> Int
polWidth s = case s of
  PolExpr    -> prodExpr prodTable
  PolFn      -> prodFn prodTable
  PolStats   -> prodStats prodTable
  PolKer     -> prodKer prodTable
  PolStdName -> prodStdName prodTable
  PolUtil    -> prodUtil prodTable

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
      CondE a b  -> CSum (CSum node (go sc a)) (go sc b)
      -- one FN choice (the two written members, plan Q1); the opaque
      -- value-layer payload is priced 0, the recorded parity-scoped
      -- convention
      Expect a _ -> CSum (CSum node (go sc a)) (CW PolFn)
#ifndef DROP_ARGMAX
      Argmax o v -> CSum (CSum node (go sc o)) (go (sc + 1) v)
#endif
#ifndef DROP_EXPFAM
      -- KER-sort (spec §3 production table): constructor choice +
      -- carrier mention + sole-member stats choice; the Space payload
      -- is priced 0 (recorded opaque-payload convention)
      ExpFam {}  -> CSum (CSum (CW PolKer) (CBits carrierB)) (CW PolStats)
#endif
#ifndef DROP_USAY
      -- UTIL-sort (spec section 3 as amended at the cirl freeze):
      -- sole-codeword constructor choice (0 bits); the payload prices
      -- as EXPR in its own closed two-variable scope
      USay p     -> CSum (CW PolUtil) (go 2 p)
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
      Call _ as  -> CSum (CSum node (CW PolStdName)) (goArgs sc as)

    goArgs :: Int -> Args env' ts -> Charge PolSort
    goArgs _  ANil      = CBits 0
    goArgs sc (a :* as) = CSum (go sc a) (goArgs sc as)

    -- a carrier mention is a name mention against the carrier registry
    -- (same written rule as 'nameBits': free while the registry is a
    -- singleton)
    carrierB :: Double
    carrierB = case carrierNames of
      _ : _ : _ -> logBase 2 (fromIntegral (length carrierNames))
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
