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
#if !defined(DROP_UPILOT) && !defined(DROP_LADDER) && !defined(DROP_VPRE) && !defined(DROP_SLOT_GRID) && !defined(DROP_AFFORDANCE)
  -- the latent-utility pilot (HOSTS_D_PACK; implemented at Task 3
  -- against the r2 oracle). Dies with the affordance layer too: no
  -- menus, no driver.
  , UPilot (..)
  , UTickState (..)
  , UTickTrace (..)
  , membraneTickU
  , runMembraneU
#endif
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
#if !defined(DROP_UPILOT) && !defined(DROP_LADDER) && !defined(DROP_VPRE) && !defined(DROP_SLOT_GRID) && !defined(DROP_AFFORDANCE)
import qualified Data.List.NonEmpty as NE
import PropLang.Belief (Belief, Kernel, expect, kernel, mkSpace, point,
                        push)
import PropLang.Enumerate (latentChannel, latentMarginal, latentName,
                           latentPoints, observeVia)
import PropLang.Eval (vPre)
import PropLang.Syntax (Chan, applyChan, mkChan, mkUtil)
#endif
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

#if !defined(DROP_UPILOT) && !defined(DROP_LADDER) && !defined(DROP_VPRE) && !defined(DROP_SLOT_GRID) && !defined(DROP_AFFORDANCE)
-- ---------------------------------------------------------------------
-- the latent-utility pilot (HOSTS_D_PACK §6/§8/§9; increment D;
-- implemented at Task 3 against the r2 oracle, the audited rule of
-- stop report #2 §2). 'Pilot', 'runMembrane', 'TickTrace' are
-- untouched — these are SIBLINGS, recorded honestly, not degenerate
-- faces (HOSTS_PLAN 6.2).
-- ---------------------------------------------------------------------

-- | The latent-utility pilot: the utility IS priced syntax ('upSaid'
-- is exactly 'PropLang.Syntax.USay''s payload shape — Var Z the
-- option code, Var (S Z) the latent parameter); verdicts arrive
-- through a decision-indexed channel (asking routes to the verdict
-- kernel, acting to noise); OUTCOME ticks condition the pointer
-- through their own declared emission ('upOutcome' — O3's
-- responder-free channel, world data like every kernel here); depth
-- is bought through the ladder's sort; and the tick price is read as
-- a FEATURE by name — measured world data, never a declared constant
-- (rider 1's stratification).
data UPilot = UPilot
  { upSaid    :: Expr '[Double, Double] Double
  , upVerdict :: Chan Double Double Obs
  , upOutcome :: Kernel Double Obs
  , upDepth   :: Rung
  , upPrice   :: Name
  }

-- | The explicitly threaded per-tick counters (register 8.9 / R-D11,
-- built in from birth): the wire drives one tick at a time with NO
-- counter resets; full episodes compose by folding 'membraneTickU'
-- from @UTickState 0 0 Nothing@ — one function, both drivers.
data UTickState = UTickState
  { usT     :: Int
  , usThink :: Int
  , usLast  :: Maybe Choice
  }
  deriving (Eq, Show)

-- | One tick's public record for the two-agent driver: the world
-- trace's fields plus the tick's stream tag (report | verdict |
-- outcome | comparison — §8's one-flow roles), the residual readout,
-- and the decision's sensitivity across the residual's support.
-- Observability-only on the wire: no consumer may branch on
-- 'utResidual' or 'utSensitivity' (consumer discipline, §8).
data UTickTrace = UTickTrace
  { utT           :: Int
  , utStream      :: Name
  , utP1          :: Double
  , utEntropy     :: Double
  , utChoice      :: Choice
  , utLossBits    :: Double
  , utResidual    :: Double
  , utSensitivity :: Bool
  }
  deriving (Eq, Show)

-- | The one-tick core, threaded state in and out — the R-D11 answer
-- to the counter-reset hazard 'runMembrane' n=1 re-entry carries
-- (membrane-wire.md's "inert under noEcho, silently wrong under
-- echo"). The utility side is a NonEmpty of PER-LATENT agents — the
-- pointer first, then the declared residual components in order:
-- rider 2's product-form independence as the ARCHITECTURE (each
-- component its own Agent), not an estimated correlation.
membraneTickU :: PureWorld s -> EchoSpec -> UPilot -> UTickState -> s
              -> Agent -> NonEmpty Agent
              -> Maybe (s, UTickState, Agent, NonEmpty Agent, UTickTrace)
membraneTickU w spec up (UTickState t nThink lastC) s wAg uAgs = do
  let feats = wFeats w s ++ echoFeatures spec t nThink lastC
      sCode = fromMaybe 0 (lookup "stream" feats)
      price = fromMaybe 0 (lookup (upPrice up) feats)
      pr = predictive feats wAg
      p1 = prob pr (is obsSpace 1)
      hEnt = entropyBits (agentMeta wAg)
      pointer = NE.head uAgs
      residuals = NE.tail uAgs
      menu = wMenu w s
      opts = menuOptions menu
      ptrPts = latentPoints pointer
      ptrM = latentMarginal pointer
      -- the first residual's declarations; a pilot with no residual
      -- components gets the degenerate zero residual (uncharged,
      -- uninformative) — the pair machinery is total either way
      (rNm, rPts, rChan, rM) = case residuals of
        r : _ -> ( latentName r, latentPoints r, latentChannel r
                 , latentMarginal r )
        []    -> ( "", 0 :| []
                 , kernel (mkSpace (0 :| [])) obsSpace
                          (const (point obsSpace 0))
                 , point (mkSpace (0 :| [])) 0 )
      choiceAt = uChoose up price menu opts ptrPts ptrM rNm rPts rChan
      choice = choiceAt rM
      -- the per-decision sensitivity scalar (§4's live counterpart of
      -- routing pin 2): does the fired choice flip across the
      -- residual's support? Observability-only on the wire.
      rSp = mkSpace rPts
      live = [ p | p <- NE.toList rPts, prob rM (is rSp p) > 0 ]
      sens = case live of
        [] -> False
        ps -> choiceAt (point rSp (minimum ps))
                /= choiceAt (point rSp (maximum ps))
      utRes = case residuals of
        [] -> expect ptrM id
        _  -> expect rM id
  (lossBits, wAg', uAgs') <- case wEvidence w s of
    Nothing -> Just (0, wAg, uAgs)
    -- one evidence flow, streams as roles (HOSTS_PLAN 6.2): report
    -- ticks are the world hypotheses' to explain; verdict ticks the
    -- pointer's, through its carried channel; outcome ticks the
    -- pointer's, through the DECLARED outcome emission (O3's
    -- responder-free channel); comparison ticks the residuals', each
    -- through its own carried channel
    Just y -> case round sCode :: Int of
      1 -> do (LogProb lp, p') <- observe feats y pointer
              Just (negate lp / ln2, wAg, p' :| residuals)
      2 -> do (LogProb lp, p') <- observeVia (upOutcome up) feats y pointer
              Just (negate lp / ln2, wAg, p' :| residuals)
      3 -> do prs <- traverse (observe feats y) residuals
              let bits = sum [ negate lp / ln2 | (LogProb lp, _) <- prs ]
              Just (bits, wAg, pointer :| map snd prs)
      _ -> do (LogProb lp, w') <- observe feats y wAg
              Just (negate lp / ln2, w', uAgs)
  let nThink' = case choice of
        InternalFired _ -> nThink + 1
        Fire _ _        -> nThink
  Just ( wStep w s choice
       , UTickState (t + 1) nThink' (Just choice)
       , wAg', uAgs'
       , UTickTrace t (uStreamName sCode) p1 hEnt choice lossBits
                    utRes sens )

uStreamName :: Double -> Name
uStreamName c = case round c :: Int of
  1 -> "verdict"
  2 -> "outcome"
  3 -> "comparison"
  _ -> "report"

-- one option described for the pair valuation: its code (the echo's
-- own convention — world affordance ids; -1 for the internal act)
-- and its world-declared name
uDescribe :: [Affordance] -> Choice -> (Double, Name)
uDescribe menu ch = case ch of
  Fire aid _ ->
    ( affIdCode aid
    , case [ nm | Affordance a nm _ <- menu, a == aid ] of
        nm : _ -> nm
        []     -> "" )
  InternalFired Think -> (-1, "think")

-- The audited decision rule (stop report #2 §2; prototype-verified,
-- the r2 satisfiability transcript): pair belief = pointer x first
-- residual, composed by PUBLIC verbs; every option valued as a vPre
-- face at the declared depth, n = 1, the world's measured tick price
-- outside the max; fired choice = menu-order argmax (CL-3, strict
-- improvement). Bindings are NAME-KEYED — rider 1's own upPrice
-- mechanism, the wire's binding surface throughout: an option opens
-- 'upVerdict' at its code (the documented routing: asking to the
-- verdict kernel, acting to noise), EXCEPT the one named "compare",
-- which opens the residual's declared channel (the wire-v2
-- comparison payload's driver realization — recorded as a name-keyed
-- simplification); an option is charged the residual as object-level
-- decision cost iff the residual's grid name is "theta_" ++ its name
-- (the extended ledger's permitted row: theta_ask prices ask
-- decisions as ordinary utility).
uChoose :: UPilot -> Double -> [Affordance] -> NonEmpty Choice
        -> NonEmpty Double -> Belief Double
        -> Name -> NonEmpty Double -> Kernel Double Obs -> Belief Double
        -> Choice
uChoose up price menu opts ptrPts ptrM rNm rPts rChan rM =
  case described of
    (c0, d0) :| ds -> fst (foldl' scan (c0, face d0) ds)
  where
    described = fmap (\c -> (c, uDescribe menu c)) opts
    scan (bc, bv) (c, d) =
      let v = face d in if v > bv then (c, v) else (bc, bv)
    uSp = mkSpace ptrPts
    rSp = mkSpace rPts
    pSp = case [ (u, r) | u <- NE.toList ptrPts, r <- NE.toList rPts ] of
      p : ps -> mkSpace (p :| ps)
      []     -> error "uChoose: grids are nonempty by construction"
    pairB = push ptrM (kernel uSp pSp (\u ->
              push rM (kernel rSp pSp (\r -> point pSp (u, r)))))
    charged nm = rNm == "theta_" ++ nm
    uT = mkUtil (\(code, nm) (u, r) ->
           evalx (upSaid up) (mkEnv [] (code :. u :. VNil))
             - (if charged nm then r else 0))
    uDD = mkUtil (\(_, nm) (_, r) -> if charged nm then negate r else 0)
    chanU = mkChan (\(code, nm) ->
              if nm == ("compare" :: Name)
                then kernel pSp obsSpace (\(_, r) -> push (point rSp r) rChan)
                else kernel pSp obsSpace (\(u, _) ->
                       push (point uSp u) (applyChan (upVerdict up) code)))
    actsAll = fmap snd described
    face d = vPre (rungDepth (upDepth up)) pairB chanU ([0, 1] :: [Obs])
                  uDD (d :| []) uT actsAll 1 price

-- | The episode fold over 'membraneTickU': world agent and per-latent
-- utility agents threaded together, one evidence flow, streams as
-- roles (report | verdict | outcome | comparison).
runMembraneU :: PureWorld s -> EchoSpec -> UPilot -> Int -> s
             -> Agent -> NonEmpty Agent
             -> Maybe (Agent, NonEmpty Agent, [UTickTrace])
runMembraneU w spec up n s0 wAg0 uAgs0 =
    go n s0 (UTickState 0 0 Nothing) wAg0 uAgs0
  where
    go k s st wa ua
      | k <= 0 = Just (wa, ua, [])
      | otherwise = do
          (s', st', wa', ua', tt) <- membraneTickU w spec up st s wa ua
          (waF, uaF, rest) <- go (k - 1) s' st' wa' ua'
          Just (waF, uaF, tt : rest)
#endif
#endif
#endif
