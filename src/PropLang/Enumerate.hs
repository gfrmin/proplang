-- | The model fragment and the agent (typed-port-spec §6): enumeration to
-- the Cromwell frontier (depth-1 in @if@; a parameter of the
-- implementation, not the language), and the belief-over-programs agent
-- moved only by the verbs. No adaptation code exists here — that is the
-- point, and audit gate 4 checks it.
--
-- The clock is externalized: callers pass the tick as an ordinary feature
-- @[("t", t)]@ (interface.md §5, the host's tick echo) — a deliberate,
-- reviewed deviation from the Python reference's internal @self.t@.
-- There is no @disabled@ knob: deletion audits ablate the grammar itself
-- (gate 7) or restrict enumeration; they never mock.
--
-- PHASE 1 STUB: 'Terminal' is real; bodies are 'undefined'.
module PropLang.Enumerate
  ( Terminal(..)
  , allTerminals
  , Model
  , renderModel
  , enumerateModels
  , Obs
  , obsSpace, thetaSpace, emit
  , Agent
  , mkAgent
  , predictive
  , observe
  , agentMeta
  , agentModels
  ) where

import PropLang.Belief (Belief, Kernel, LogProb, Space)
import PropLang.Eval (Features)

-- | The model-fragment terminals, for restricted enumeration in the
-- deletion audit (deleting a terminal = enumerating without it).
data Terminal = TBern | THmm | TIf | TGt | TGet | TC
  deriving (Eq, Show)

allTerminals :: [Terminal]
allTerminals = [TBern, THmm, TIf, TGt, TGet, TC]

-- | A model-fragment sentence (a hypothesis). Abstract to consumers.
data Model

-- | Canonical rendering, byte-identical to the Python reference's repr,
-- e.g. @"('hmm', ('c', 'rho', 3))"@. The frozen tests assert MAP
-- programs against these exact strings.
renderModel :: Model -> String
renderModel = undefined

-- | Enumerate the model fragment to depth 1 (the Cromwell frontier) from
-- the allowed terminal set. Order and count must match the Python
-- reference (full set: 1169 sentences under the current grids).
enumerateModels :: [Terminal] -> [Model]
enumerateModels = undefined

-- | Observations of the demonstration domain ({0,1}).
type Obs = Int

obsSpace :: Space Obs
obsSpace = undefined

thetaSpace :: Space Double
thetaSpace = undefined

-- | The Bernoulli emission kernel theta -> Belief over {0,1}.
emit :: Kernel Double Obs
emit = undefined

-- | A belief over programs plus per-hypothesis filtered latent state.
data Agent

mkAgent :: [Model] -> Agent
mkAgent = undefined

-- | The one-tick-ahead predictive: push of the meta-belief along the
-- per-hypothesis step kernel at the given features.
predictive :: Features -> Agent -> Belief Obs
predictive = undefined

-- | One polling re-entry: returns the natural-log marginal likelihood of
-- the observation ('LogProb') and the conditioned agent. 'Nothing' =
-- impossible evidence (total, like 'PropLang.Belief.cond').
observe :: Features -> Obs -> Agent -> Maybe (LogProb, Agent)
observe = undefined

-- | The meta-belief over hypothesis indices (positions in 'agentModels').
agentMeta :: Agent -> Belief Int
agentMeta = undefined

agentModels :: Agent -> [Model]
agentModels = undefined
