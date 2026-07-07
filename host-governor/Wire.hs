-- | The membrane wire, pure half (HOSTS_PLAN section 1-2; oracle-phase
-- TYPE SURFACE, bodies unimplemented — the red the red-run proves).
--
-- One process, one agent, one world. JSON-lines over stdio; the wire
-- is the membrane's three flows plus a world declaration, all data.
-- Everything in this module is pure: the IO loop lives in Main.hs and
-- nowhere else (the Host.hs discipline). @step@ is fully testable from
-- the oracle without a process.
--
-- Codec contract (strict JSON subset, canonical rendering):
--
-- * rendering emits no whitespace outside strings; object keys keep
--   insertion order; a numerically integral value renders without a
--   decimal point (@1@, not @1.0@), any other value renders as
--   Haskell 'show' (shortest round-trip); strings escape only
--   @\"@, @\\@ and @\\n@.
-- * parsing accepts whitespace between tokens and exactly the subset
--   the renderer emits; unknown object keys are IGNORED (the
--   governor's own new-key negotiation doctrine) — they parse and
--   drop, never error.
--
-- Wire messages (HOSTS_PLAN section 1):
--
-- * handshake (first line): the world declaration — namespace, guard
--   grids, menu (affordances + slots), utility STEP TABLE, echo spec.
--   Epoch-1 restriction, VALIDATED here: echo must be all-false (the
--   n=1 driver resets internal counters per call; echo would be
--   silently wrong — register item 8.9).
-- * decision tick: features + menu (affordance ids) -> one choice,
--   with the read-only scalars p1 and entropy_bits. The agent does
--   not move.
-- * evidence tick: the judged event's original features + the 0/1
--   verdict -> observed + loss_bits.
-- * a tick MAY carry both; semantics are the frozen loop's order
--   (choice from the predictive BEFORE the observation moves the
--   agent — Membrane.hs runMembrane, verbatim, via n=1).
-- * impossible evidence: an error reply, agent unchanged (total).
module Wire
  ( -- * JSON subset
    Json (..)
  , parseJson
  , renderJson
    -- * wire messages
  , WorldDecl (..)
  , GuardDecl (..)
  , MenuItem (..)
  , UtilRow (..)
  , TickMsg (..)
  , Msg (..)
  , Reply (..)
  , parseLine
  , renderReply
    -- * the driver's pure half
  , World (..)
  , buildWorld
  , step
  ) where

import PropLang.Enumerate (Agent, Obs)
import PropLang.Membrane (Affordance, Choice)
import PropLang.Syntax (Name, Util)

-- ---------------------------------------------------------------------
-- JSON subset
-- ---------------------------------------------------------------------

-- | The wire's value grammar. No null-vs-absent distinction is ever
-- meaningful on this wire; absent keys are the only optionality.
data Json
  = JBool Bool
  | JNum Double
  | JStr String
  | JArr [Json]
  | JObj [(String, Json)]
  deriving (Eq, Show)

parseJson :: String -> Either String Json
parseJson _ = Left "unimplemented (oracle phase)"

renderJson :: Json -> String
renderJson _ = error "renderJson: unimplemented (oracle phase)"

-- ---------------------------------------------------------------------
-- wire messages
-- ---------------------------------------------------------------------

-- | A guard-family declaration: a Get-mentionable name plus its
-- threshold grid (HOSTS_PLAN 2.4: for the governor's one-hot
-- indicators, the singleton grid [0.5]).
data GuardDecl = GuardDecl Name [Double]
  deriving (Eq, Show)

-- | A published affordance: world-owned id, display name, typed slots
-- (name, grid points). The governor's three effectors carry no slots.
data MenuItem = MenuItem Int Name [(Name, [Double])]
  deriving (Eq, Show)

-- | One row of the utility step table: an affordance id (Right) or
-- the internal think row (Left ()), with (u(y=0), u(y=1)).
data UtilRow = UtilRow (Either () Int) (Double, Double)
  deriving (Eq, Show)

-- | The handshake's world declaration.
data WorldDecl = WorldDecl
  { wdNamespace :: [Name]
  , wdGuards    :: [GuardDecl]
  , wdMenu      :: [MenuItem]
  , wdUtility   :: [UtilRow]
  , wdEcho      :: (Bool, Bool, Bool)
  }
  deriving (Eq, Show)

-- | One tick. @tmMenu@ lists offered affordance ids in NORMATIVE
-- order (argmaxEU ties resolve first-listed, CL-3 — the R1 polarity
-- ruling names the order for the governor). @tmUtility@ is the
-- per-tick profile override (a full replacement table).
data TickMsg = TickMsg
  { tmFeatures :: [(Name, Double)]
  , tmEvidence :: Maybe Obs
  , tmMenu     :: Maybe [Int]
  , tmUtility  :: Maybe [UtilRow]
  }
  deriving (Eq, Show)

-- | A parsed request line.
data Msg = MHandshake WorldDecl | MTick TickMsg
  deriving (Eq, Show)

-- | A reply line. 'RTick' carries the decision part iff a menu was
-- offered and the evidence part iff evidence arrived; both absent is
-- the silent tick (agent unmoved, @{"ok":true}@).
data Reply
  = RHandshake Int Double                -- ^ models, namespace_bits
  | RTick (Maybe (Choice, Double, Double)) (Maybe (Obs, Double))
      -- ^ (choice, p1, entropy_bits); (observed, loss_bits)
  | RError String
  deriving (Eq, Show)

parseLine :: String -> Either String Msg
parseLine _ = Left "unimplemented (oracle phase)"

renderReply :: Reply -> String
renderReply _ = error "renderReply: unimplemented (oracle phase)"

-- ---------------------------------------------------------------------
-- the driver's pure half
-- ---------------------------------------------------------------------

-- | A built world: the enumerated agent's seed data plus everything a
-- tick needs. The agent itself is threaded separately (the one moving
-- part).
data World = World
  { wNamespaceBits :: Double            -- ^ log2 |namespace|
  , wModelCount    :: Int               -- ^ size of the enumeration
  , wAffordances   :: [(Int, Affordance)]  -- ^ declared menu, by id
  , wUtility       :: Util Choice Obs   -- ^ the step table, folded
  , wRows          :: [UtilRow]         -- ^ the declared rows (for validation)
  }

-- | Validate and build: namespace nonempty and covering every guard
-- name; every grid nonempty; every menu id declared once and covered
-- by a utility row, the internal think row present; echo all-false
-- (epoch 1). Returns the world, the seeded agent
-- (@mkAgent (enumerateModelsIn ns extras allTerminals)@ — the host
-- gets THE agent, not a configured one: the terminal set is not on
-- the wire), and the handshake reply.
buildWorld :: WorldDecl -> Either String (World, Agent, Reply)
buildWorld _ = Left "unimplemented (oracle phase)"

-- | One wire tick over the frozen loop: @runMembrane@ with @n = 1@
-- over a constant 'PropLang.Membrane.PureWorld' (wStep = const) —
-- the frozen tick arithmetic verbatim (HOSTS_PLAN 2.3). Total:
-- impossible evidence returns @RError "impossible-evidence"@ with the
-- agent UNCHANGED; an undeclared menu id or an override table missing
-- an offered row is an error reply, agent unchanged.
step :: World -> Agent -> TickMsg -> (Agent, Reply)
step _ ag _ = (ag, RError "unimplemented (oracle phase)")
