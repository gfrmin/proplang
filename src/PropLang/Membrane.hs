{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

-- | The membrane (interface.md §1–§3, §5; MEMBRANE_PLAN T3): one typed
-- boundary, three flows, one namespace. Everything here is pure data
-- and pure folds — the IO polling loop against a real world is
-- "PropLang.Host"'s, and nothing in this module's types may mention IO
-- (the increment's own no-IO audit row mirrors gate 3).
--
-- Flow shapes, as compile facts rather than discipline:
--
-- * FEATURES: a world publishes @[(Name, Double)]@ per tick; the
--   membrane appends the agent's own echo ('echoFeatures') — the self
--   arrives as names like any other (§5, CL-6).
-- * EVIDENCE: the explained name's readings route through the frozen
--   'PropLang.Enumerate.observe' — a subset of what the world says.
-- * CHOICE: one 'Choice' per tick, selected by argmax ('argmaxEU' is
--   the doctrinal policy shape), fired at the boundary. 'wStep'
--   returns only the next world state: THE FIRED CHOICE HAS NO RETURN
--   VALUE — no channel exists for one (§1's load-bearing clause), so
--   consequences arrive only inside the next tick's features.
--
-- Deletion coupling (layer absence, the recorded standard): the
-- external action layer dies with its slot grids (@DROP_SLOT_GRID@) or
-- with affordance publication (@DROP_AFFORDANCE@); the self dies with
-- the echo (@DROP_ECHO@) and takes the polling driver with it (the
-- membrane without its echo is not the membrane); the driver also dies
-- with the agent layer (@DROP_EXPFAM@ / @DROP_CARRIER_OBS@) and with
-- 'PropLang.Syntax.Argmax' (@DROP_ARGMAX@ — nothing may select an
-- action but expected value, so no argmax means no choice flow).
module PropLang.Membrane
  ( AffId, mkAffId, affIdCode
  , InternalAct (..)
  , Choice (..)
  , internalMenu
#ifndef DROP_LADDER
  , Rung, baseRung, rungDepth, mkRung, ladderRungs
#endif
#ifndef DROP_SLOT_GRID
  , Slot (..)
#ifndef DROP_AFFORDANCE
  , Affordance (..)
  , menuOptions
#endif
#endif
#ifndef DROP_ECHO
  , EchoSpec, mkEchoSpec, noEcho
  , lastActionCode
  , echoFeatures
#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS) && !defined(DROP_ARGMAX)
  , Pilot (..)
  , argmaxEU
  , PureWorld (..)
  , TickTrace (..)
  , runMembrane
  -- (the latent-utility pilot retired at the step-3 sentence freeze
  --  with the u-fragment; sentence-author-pack.md SS10/SS20)
#endif
#endif
  ) where

import Data.List.NonEmpty (NonEmpty ((:|)))

#ifndef DROP_ECHO
import PropLang.Eval (Features)
#endif
#if !defined(DROP_SLOT_GRID) || !defined(DROP_ECHO)
import PropLang.Syntax (Name)
#endif
#if !defined(DROP_SLOT_GRID) || !defined(DROP_LADDER)
import PropLang.Syntax (Grid)
#endif
#ifndef DROP_LADDER
import PropLang.Syntax (Ix)
#endif
#if !defined(DROP_SLOT_GRID) && !defined(DROP_AFFORDANCE)
import Data.List.NonEmpty (toList)
#endif
#if (!defined(DROP_SLOT_GRID) && !defined(DROP_AFFORDANCE)) || !defined(DROP_LADDER)
import PropLang.Syntax (gridSize, mkC)
#endif
#if (!defined(DROP_SLOT_GRID) && !defined(DROP_AFFORDANCE)) || (!defined(DROP_ECHO) && !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS) && !defined(DROP_ARGMAX)) || !defined(DROP_LADDER)
import PropLang.Eval (Vals (..), evalx, mkEnv)
#endif
#if !defined(DROP_ECHO) && !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS) && !defined(DROP_ARGMAX)
import Data.Maybe (fromMaybe)
import PropLang.Belief (LogProb (LogProb), entropyBits, is, prob)
import PropLang.Enumerate (Agent, Obs, agentMeta, observe, obsSpace,
                           predictive)
import PropLang.Syntax (Args (..), B, Expr (..), Idx (..), StdName (..),
                        Util)
#endif

-- | World-owned stable affordance identity (ruling M2): the echo speaks
-- this id, never a published-menu position, so the integer's meaning
-- cannot shift when the menu grows mid-episode. Worlds choose positive
-- ids by convention; 0 is reserved for "no action fired yet", and the
-- host's one internal entry echoes as -1 (host-owned, equally stable).
newtype AffId = AffId Int
  deriving (Eq, Show)

mkAffId :: Int -> AffId
mkAffId = AffId

affIdCode :: AffId -> Double
affIdCode (AffId k) = fromIntegral k

-- | The internal actions, in the same menu as the world's (§3): one
-- written inhabitant this increment — the myopic think. Ruling M3/M9:
-- the fidelity ladder's depth arrives as an ADDITIVE constructor or
-- slot at its own freeze boundary; no dormant depth field exists here.
data InternalAct = Think
  deriving (Eq, Show)

#ifndef DROP_SLOT_GRID
-- | A typed, grid-priced hole in an affordance schema (§3): slot
-- instantiation is grid-constant utterance, priced by 'PropLang.Syntax.mkC''s
-- rule wherever a sentence names the constant (ruling M4 — menus are
-- world data and carry no description length themselves).
data Slot = Slot Name Grid

#ifndef DROP_AFFORDANCE
-- | A world-published action schema: stable identity, name, slots.
-- Interface.md §8 E at the code level: delete the slot grids and this
-- layer cannot be written (affordances unpriceable, the external menu
-- empties); delete affordance publication and only the internal menu
-- remains.
data Affordance = Affordance AffId Name [Slot]
#endif
#endif

-- | One option, one flow: an instantiated external affordance or an
-- internal act, valued by the same push, chosen by the same argmax.
data Choice
  =
#if !defined(DROP_SLOT_GRID) && !defined(DROP_AFFORDANCE)
    Fire AffId [(Name, Double)]
  |
#endif
    InternalFired InternalAct
  deriving (Eq, Show)

-- | The host's own menu entries — always present, always last: the
-- option list is external instantiations in publication order, then
-- the internal acts, so a world's tie-break precedence (CL-3:
-- first-listed wins) belongs to the world's publication order.
internalMenu :: NonEmpty Choice
internalMenu = InternalFired Think :| []

#ifndef DROP_LADDER
-- | A deliberation rung — the fidelity ladder's own sort (interface.md
-- section 6; LADDER_PLAN L1/L2 as landed). Depth 1 is the base act, the
-- membrane's one internal think, spoken here as 'baseRung'; deeper
-- rungs are grid-priced through the one door. The constructor is NOT
-- exported: an off-grid rung is unconstructible (the mkC discipline as
-- a type-only export), and consumers reach a rung only through
-- 'rungDepth'. The ladder extends the menu by its own sort rather than
-- by a new 'InternalAct' inhabitant because the frozen membrane
-- oracle's exhaustive matches sealed 'InternalAct' and 'Choice' against
-- extension as a compile fact (test-membrane/Membrane.hs choiceName1,
-- under the stanza's -Werror) — discovered and reported at this
-- increment's Task 1.
data Rung = Rung Int
  deriving (Eq, Show)

-- | Depth 1: the myopic think. Always the menu's first rung —
-- shallow-first order is CL-3 at the menu (the recorded tie-break).
baseRung :: Rung
baseRung = Rung 1

rungDepth :: Rung -> Int
rungDepth (Rung k) = k

-- | The one door to a deeper rung: an integral grid point >= 2 (depth
-- 1 already has its one spelling, 'baseRung'), resolved through 'mkC'
-- and the real evaluator like every priced constant — an unpriceable
-- depth is unofferable.
mkRung :: Grid -> Ix -> Maybe Rung
mkRung g k = do
  e <- mkC g k
  let v = evalx e (mkEnv [] VNil)
      r = round v :: Int
  if fromIntegral r == v && r >= 2 then Just (Rung r) else Nothing

-- | The rung menu of a depth grid: the base act, then every deeper
-- grid point in publication order.
ladderRungs :: Grid -> NonEmpty Rung
ladderRungs g =
  baseRung :| [ r | k <- [0 .. gridSize g - 1], Just r <- [mkRung g k] ]
#endif

#if !defined(DROP_SLOT_GRID) && !defined(DROP_AFFORDANCE)
-- | The option space of a published menu (§3): every affordance at
-- every slot-grid point (rightmost slot fastest), then 'internalMenu'.
-- Slot instantiation enumerates the slot's grid through the grammar's
-- only constant door ('mkC' then the real evaluator), so an
-- unpriceable point is unofferable.
menuOptions :: [Affordance] -> NonEmpty Choice
menuOptions affs = case concatMap externals affs of
  []     -> internalMenu
  c : cs -> c :| (cs ++ toList internalMenu)
  where
    externals (Affordance aid _ slots) = map (Fire aid) (fillings slots)
    fillings [] = [[]]
    fillings (Slot nm g : rest) =
      [ (nm, v) : more | v <- points g, more <- fillings rest ]
    points g =
      [ evalx e (mkEnv [] VNil)
      | k <- [0 .. gridSize g - 1], Just e <- [mkC g k] ]
#endif

#ifndef DROP_ECHO
-- | Which of its own names the substrate echoes (§5): the echo set is
-- world data, so a world that echoes nothing (the frozen parity
-- worlds) is just a configuration, not a special case.
data EchoSpec = EchoSpec Bool Bool Bool

-- | last_action, tick, ticks_spent_thinking — in that order.
mkEchoSpec :: Bool -> Bool -> Bool -> EchoSpec
mkEchoSpec = EchoSpec

noEcho :: EchoSpec
noEcho = EchoSpec False False False

-- | The echoed identity of the previously fired choice (ruling M2):
-- 0 before any action; a world affordance's stable id; -1 for the
-- host's internal act.
lastActionCode :: Maybe Choice -> Double
lastActionCode c = case c of
  Nothing                    -> 0
#if !defined(DROP_SLOT_GRID) && !defined(DROP_AFFORDANCE)
  Just (Fire aid _)          -> affIdCode aid
#endif
  Just (InternalFired Think) -> -1

-- | The agent's signature, spoken back as ordinary names (§5, CL-6):
-- appended after the world's features, priced by 'PropLang.Syntax.bitsIn'
-- like sentences about the weather, explained or context like any
-- other name.
echoFeatures :: EchoSpec -> Int -> Int -> Maybe Choice -> Features
echoFeatures (EchoSpec la ti th) t nThink lastC =
     [ ("last_action", lastActionCode lastC) | la ]
  ++ [ ("tick", fromIntegral t) | ti ]
  ++ [ ("ticks_spent_thinking", fromIntegral nThink) | th ]

#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS) && !defined(DROP_ARGMAX)
-- | Defunctionalized pilots — the first-order decision data a membrane
-- world hands the driver. 'PilotEU' is the doctrinal path: 'argmaxEU'
-- over the current predictive with a world-supplied utility over the
-- WHOLE option space (internal acts included — one action space, one
-- valuation). 'PilotThreshold' is the C-world's scripted explorer:
-- fire the first choice when the named feature exceeds the threshold,
-- else the second (the self-signature test's claim is the posterior's,
-- not the policy's).
data Pilot
  = PilotIdle
  | PilotThreshold Name Double Choice Choice
  | PilotEU (Util Choice Obs)

-- | Expected-utility action selection AS A PROGRAM — the same
-- first-order sentence the frozen acceptance suite evaluates: argmax
-- over options of EU(option), predictive belief and world-supplied
-- utility bound in the typed environment.
argmaxEU :: Expr '[NonEmpty o, B y, Util o y] o
argmaxEU =
  Argmax (Var Z)
    (Call EU (Var (S (S Z)) :* Var (S (S (S Z))) :* Var Z :* ANil))

-- | A pure world behind the membrane: what it publishes, what its one
-- explained sensor reads (Nothing = a silent tick), what it offers,
-- and how it moves when a choice fires. 'wStep' returning only @s@ is
-- §1's "actions have no return values" as a type.
data PureWorld s = PureWorld
  { wFeats    :: s -> Features
  , wEvidence :: s -> Maybe Obs
#if !defined(DROP_SLOT_GRID) && !defined(DROP_AFFORDANCE)
  , wMenu     :: s -> [Affordance]
#endif
  , wStep     :: s -> Choice -> s
  }

-- | One tick's public record, in the frozen acceptance loop's own
-- order and arithmetic: features composed (world ++ echo), predictive
-- and meta-entropy taken BEFORE the observation moves the agent, the
-- choice selected and fired, evidence (if the sensor spoke) folded
-- through 'observe' at @negate lp / log 2@ bits.
data TickTrace = TickTrace
  { ttT        :: Int
  , ttP1       :: Double
  , ttEntropy  :: Double
  , ttChoice   :: Choice
  , ttLossBits :: Double
  }
  deriving (Eq, Show)

-- | The polling contract (§1), pure: for each of @n@ ticks — publish,
-- evaluate, fire, step; consequences only ever arrive inside the next
-- tick's features. Cumulative log-loss is the 'foldl'' of the per-tick
-- bits, term for term the frozen suite's accumulation. 'Nothing' =
-- impossible evidence, total like 'PropLang.Belief.cond'.
runMembrane :: PureWorld s -> EchoSpec -> Pilot -> Int -> s -> Agent
            -> Maybe (Agent, [TickTrace])
runMembrane w spec pilot n s0 ag0 = go 0 s0 ag0 Nothing 0
  where
    go t s ag lastC nThink
      | t >= n = Just (ag, [])
      | otherwise = do
          let feats = wFeats w s ++ echoFeatures spec t nThink lastC
              pr = predictive feats ag
              p1 = prob pr (is obsSpace 1)
              h = entropyBits (agentMeta ag)
              opts =
#if !defined(DROP_SLOT_GRID) && !defined(DROP_AFFORDANCE)
                menuOptions (wMenu w s)
#else
                internalMenu
#endif
              c = interpretPilot pilot feats pr opts
          (lossBits, ag') <- case wEvidence w s of
            Nothing -> Just (0, ag)
            Just y  -> case observe feats y ag of
              Nothing              -> Nothing
              Just (LogProb lp, a) -> Just (negate lp / ln2, a)
          let nThink' = case c of
                InternalFired _ -> nThink + 1
#if !defined(DROP_SLOT_GRID) && !defined(DROP_AFFORDANCE)
                Fire _ _        -> nThink
#endif
          (agF, rest) <- go (t + 1) (wStep w s c) ag' (Just c) nThink'
          Just (agF, TickTrace t p1 h c lossBits : rest)

ln2 :: Double
ln2 = log 2

-- One pilot decision: the doctrinal argmax-EU program over the whole
-- option space for 'PilotEU'; the scripted threshold read for the
-- C-world's explorer; the first-listed option for idle worlds.
interpretPilot :: Pilot -> Features -> B Obs -> NonEmpty Choice -> Choice
interpretPilot p feats pr opts = case p of
  PilotIdle -> let c :| _ = opts in c
  PilotThreshold nm th a b ->
    if fromMaybe 0 (lookup nm feats) > th then a else b
  PilotEU u -> evalx argmaxEU (mkEnv feats (opts :. pr :. u :. VNil))

-- ---------------------------------------------------------------------
-- (the latent-utility pilot — UPilot, UTickState, UTickTrace,
--  membraneTickU, runMembraneU, uChoose — RETIRED at the step-3
--  sentence freeze with the u-fragment it consumed; utility returns
--  re-derived from the axioms at steps 6-8, never rebuilt from
--  nostalgia. sentence-author-pack.md SS10/SS16/SS20.)
-- ---------------------------------------------------------------------
#endif
#endif
