{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

-- | The membrane (interface.md §1–§3, §5) — SINCE THE STEP-5 FREEZE:
-- ACTIONS BECOME FEATURES. An action is an assignment of values to
-- the names the agent controls (AGENT_PLAN §3: "choice is the last
-- private wire", dissolved); the writable names and their grids are
-- the world's declared 'Menu'; 'wait' is every action name at the
-- FIRST point of its grid (§5c — structural, never a convention:
-- grids are nonempty by construction, so wait exists in every world
-- with no handshake, and CL-3's first-listed-wins hands ties to it
-- because it is the option space's HEAD by construction).
--
-- DELETED at the step-5 boundary: the five action types ('Choice',
-- 'Affordance', 'AffId', 'Slot', 'InternalAct'), the echo path
-- ('EchoSpec', 'echoFeatures', 'lastActionCode',
-- ticks_spent_thinking — the agent echoing ITSELF; worlds remain
-- free, under CL-1-at-the-echo, to measure the agent's latency from
-- outside the membrane and publish it as an ordinary feature), the
-- 'Rung' machinery, and THE SENTINEL — the fabricated internal think
-- row that existed to make an act table total. Totality needs no
-- fabrication now: the empty Cartesian product has exactly one
-- element, and that element is wait, so a menuless world's option
-- space is a THEOREM of the representation (A5' by algebra).
--
-- SINCE THE STEP-6 FREEZE (stream-freeze-r0): ACTIONS ENTER THE
-- TICK'S FEATURE STREAM, no lag — 'observe' folds evidence at
-- @feats ++ c@, the chosen assignment appended to the world's
-- published features (world-first, ruling D-b2: the stream is the
-- world's document, one authority, no merge semantics; on a
-- conforming world the names are disjoint by handshake, and the wire
-- sentence lands at 7). THE SCORING RULE IS EXOGENOUS-READ (ruling
-- D-b3, 6b's survivor): a candidate's EU reads 'predictive' at the
-- augmented features with hypothesis weights and latents untouched
-- by the contemplation — functionally an intervention semantics at
-- decision time, achieved with NO do-operator in the language (the
-- ruled clauses: test-stream's g2 header; pack Part V §32). Mention
-- prices bound at 6; value prices still bind at 7 (RIDER 2). The M5
-- guardian retired with its subject; M5 itself is repealed only at
-- 7, and the interregnum is guarded by RIDER 2's negative obligation
-- itself.
module PropLang.Membrane
  ( Menu
  , menuAssignments
#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS) && !defined(DROP_ARGMAX)
  -- the agent-facing surface dies with the scoring layer or with
  -- 'PropLang.Syntax.Argmax' (nothing may select an action but
  -- expected value, so no argmax means no choice flow) — the
  -- deletion coupling the retired layer recorded, carried forward
  , Pilot (..)
  , argmaxEU
  , PureWorld (..)
  , TickTrace (..)
  , runMembrane
#endif
  ) where

import Data.List.NonEmpty (NonEmpty ((:|)))

import PropLang.Eval (Features, Vals (..), evalx, mkEnv)
import PropLang.Syntax (Grid, Name, gridSize, mkC)
#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS) && !defined(DROP_ARGMAX)
import Data.Maybe (fromMaybe)
import PropLang.Belief (LogProb (LogProb), entropyBits, is, prob)
import PropLang.Enumerate (Agent, Obs, agentMeta, observe, obsSpace,
                           predictive)
import PropLang.Syntax (Args (..), B, Expr (..), Idx (..),
                        StdName (..), Util)
#endif

-- | The writable names and their grids — a SYNONYM, not a type
-- (AGENT_PLAN §5: the only new name). Identical in shape to
-- 'enumerateSentencesIn''s extras: one shape, two readers, shared by
-- construction. (If 'Menu' ever becomes a @data@ type, ruling D-a3's
-- home question reopens — the sitting's note.)
--
-- Type derivation (step 6, pack §28): DERIVES — the world's declared
-- writable names (AGENT_PLAN §5's one new name; grids are data with
-- prices).
type Menu = [(Name, Grid)]

-- | The option space of a menu: every FULL assignment (one value per
-- writable name — ruling D-a1: a partial assignment would
-- re-introduce exactly the unset-vs-set ambiguity §5c killed), grid
-- points entering through the grammar's only constant door ('mkC'
-- then the real evaluator) in declaration order, first names varying
-- slowest — so the HEAD is the all-first-points assignment: 'wait'.
-- The empty menu's sole option is the empty assignment (the empty
-- product's one element IS wait; nothing fabricated remains).
-- The option space is exponential in menu names: EXHAUSTIVE argmax
-- over it is the GENERAL ROUTE, and any future factored or greedy
-- evaluation is a fast path under the §1b law and arrives with its
-- pin (the pricing freeze's caution, third statement).
menuAssignments :: Menu -> NonEmpty Features
menuAssignments menu = case go menu of
  a : as -> a :| as
  []     -> [] :| []
  where
    go [] = [[]]
    go ((nm, g) : rest) =
      [ (nm, v) : more | v <- points g, more <- go rest ]
    points g =
      [ evalx e (mkEnv [] VNil)
      | k <- [0 .. gridSize g - 1], Just e <- [mkC g k] ]

#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS) && !defined(DROP_ARGMAX)
-- | Defunctionalized pilots, 'Choice' deleted: the same three shapes
-- over assignments. No internal act exists to value — the sentinel is
-- dead, and 'argmax' stays total because wait is always options'
-- head.
--
-- Type derivation (the §8c audit, first pass at step 6 — pack §28,
-- adopted at the sitting): 'PilotEU' DERIVES — "nothing may select an
-- action but expected value", the doctrinal arm and the only one on
-- the agent path. 'PilotIdle' and 'PilotThreshold' are FENCED:
-- scripted competitor policies, simulator scaffolding OUTSIDE the
-- language (the raw Double is a script parameter, never a priced
-- quantity). Their move to a test-side harness module is a SCHEDULED
-- step-7 opening-checklist row (the sitting's split ruling: the
-- forgetter asymmetry dies at the first boundary that can fix it
-- for free).
data Pilot
  = PilotIdle
  | PilotThreshold Name Double Features Features
  | PilotEU (Util Features Obs)

-- | Expected-utility action selection AS A PROGRAM — unchanged from
-- the shipped membrane; the option type simply instantiates at
-- 'Features' (assignments) where 'Choice' stood.
argmaxEU :: Expr '[NonEmpty o, B y, Util o y] o
argmaxEU =
  Argmax (Var Z)
    (Call EU (Var (S (S Z)) :* Var (S (S (S Z))) :* Var Z :* ANil))

-- | A pure world behind the membrane: what it publishes, what its one
-- explained sensor reads (Nothing = a silent tick), which names it
-- lets the agent write (per tick — menu growth is a world's own
-- declaration), and how it moves when an assignment lands. 'wStep'
-- returning only @s@ is §1's "actions have no return values" as a
-- type.
--
-- Type derivation (step 6, pack §28): FENCE — simulator scaffolding,
-- outside the language. The real boundary is the wire (host
-- conformance binds to membrane-wire.md, never GHC artifacts); the
-- engine needs SOME in-process world to fold against, and this is
-- that harness.
data PureWorld s = PureWorld
  { wFeats    :: s -> Features
  , wEvidence :: s -> Maybe Obs
  , wMenu     :: s -> Menu
  , wStep     :: s -> Features -> s
  }

-- | One tick's public record, the frozen loop's own order and
-- arithmetic: features published, predictive and meta-entropy BEFORE
-- the observation moves the agent, the assignment selected and
-- fired, evidence folded through 'observe' at @negate lp / log 2@
-- bits.
--
-- Type derivation (step 6, pack §28): DERIVES — the tick's public
-- record mirrors the wire's readouts (interface §1 observables: p1,
-- entropy, act, loss); the wire-mirror argument is a real derivation
-- (the sitting's ruling on the borderline).
data TickTrace = TickTrace
  { ttT        :: Int
  , ttP1       :: Double
  , ttEntropy  :: Double
  , ttAct      :: Features
  , ttLossBits :: Double
  }
  deriving (Eq, Show)

-- | The polling contract (§1), pure — the shipped fold minus the echo
-- append and the internal-act arm; consequences only ever arrive
-- inside a LATER tick's features ("actions have no return values"),
-- while the CHOSEN assignment joins THIS tick's observation features
-- (step 6: 'observe' at @feats ++ c@; the trace records the
-- pre-choice predictive — ruling D-b1's geometry, E-b1-verified).
-- The E-a1-verified prototype is the executable design: features ->
-- predictive/entropy -> menuAssignments -> interpretPilot -> observe
-- at negate lp / ln2 -> wStep.
runMembrane :: PureWorld s -> Pilot -> Int -> s -> Agent
            -> Maybe (Agent, [TickTrace])
runMembrane w pilot n s0 ag0 = go 0 s0 ag0
  where
    go t s ag
      | t >= n = Just (ag, [])
      | otherwise = do
          let feats = wFeats w s
              pr = predictive feats ag
              p1 = prob pr (is obsSpace 1)
              h = entropyBits (agentMeta ag)
              opts = menuAssignments (wMenu w s)
              c = interpretPilot ag pilot feats pr opts
          (lossBits, ag') <- case wEvidence w s of
            Nothing -> Just (0, ag)
            Just y  -> case observe (feats ++ c) y ag of
              Nothing              -> Nothing
              Just (LogProb lp, a) -> Just (negate lp / ln2, a)
          (agF, rest) <- go (t + 1) (wStep w s c) ag'
          Just (agF, TickTrace t p1 h c lossBits : rest)

ln2 :: Double
ln2 = log 2

-- One pilot decision: the doctrinal argmax-EU program over the whole
-- option space; the scripted threshold read; the first-listed option
-- (= wait, by construction) for idle worlds.
interpretPilot :: Agent -> Pilot -> Features -> B Obs -> NonEmpty Features
               -> Features
interpretPilot ag p feats _pr opts = case p of
  PilotIdle -> let c :| _ = opts in c
  PilotThreshold nm th a b ->
    if fromMaybe 0 (lookup nm feats) > th then a else b
  PilotEU u ->
    -- per-assignment exogenous-read scoring (6b's survivor): each
    -- candidate's EU is taken against predictive (feats ++ candidate)
    -- at current weights, through the public EU verb.
    -- THE SELECTION IS A HOST-SIDE FOLD, not an evaluation of the
    -- doctrinal 'argmaxEU' Expr: the per-candidate predictive read
    -- has no verb inside the language, so the doctrinal program
    -- cannot express the re-read. Under the §1b law the fold is a
    -- FAST PATH of the doctrinal program, lawful because test-stream
    -- g2's bridge row is its extensional pin (runMembrane's choice ==
    -- the public per-assignment EU arithmetic, every tick; strict >
    -- displaces = the Argmax evaluator's own tie discipline, so
    -- first-listed wait keeps ties). Entered on the §1b fast-path
    -- register at the step-6 r1 (the author's classification order).
    let euAt a = evalx (Call EU (Var Z :* Var (S Z) :* Var (S (S Z)) :* ANil))
                       (mkEnv [] (predictive (feats ++ a) ag :. u :. a :. VNil))
        c0 :| cs = opts
        go best _bv [] = best
        go best bv (c : rest) =
          let cv = euAt c
          in if cv > bv then go c cv rest else go best bv rest
    in go c0 (euAt c0) cs
#endif
