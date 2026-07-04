{-# LANGUAGE DerivingStrategies #-}

-- | The sealed reasoner (typed-port-spec §2).
--
-- One module owns all probability arithmetic. The 'Belief' constructor is
-- NOT exported: no code outside this module can read, write, or name a
-- log-weight (invariant I1 as a compile fact). The export list below is
-- frozen verbatim from typed-port-spec §2 (as amended) and checked by
-- audit gate 2.
--
-- PHASE 1 STUB: signatures only; every body is 'undefined'. Phase 2 fills
-- the bodies in without touching the export list.
module PropLang.Belief
  ( Space, mkSpace
  , Belief                      -- abstract: constructor NOT exported
  , Event, is, event            -- host-layer smart constructors
  , Kernel, kernel
  , Evidence(..)                -- closed variant: I2
  , Bits(..), LogProb(..)       -- newtypes; derived numeric instances
  , uniform, point, fromBits    -- the ONLY prior sources in the system
  , expect, prob, push, cond, logPredict
  , entropyBits, top            -- CL-1 diagnostics, read-only by type
  ) where

import Data.List.NonEmpty (NonEmpty)

-- | Description length in bits. Newtype (not a synonym): confusing bits
-- with nats at the module boundary is a bug class this port makes
-- unwritable (typed-port-spec §2, amended).
newtype Bits = Bits Double
  deriving stock (Show)
  deriving newtype (Eq, Ord, Num, Fractional, Floating, Real, RealFrac)

-- | Natural-log probability (the marginal likelihood returned by
-- 'logPredict' is a natural log; consumers convert to bits explicitly).
newtype LogProb = LogProb Double
  deriving stock (Show)
  deriving newtype (Eq, Ord, Num, Fractional, Floating, Real, RealFrac)

-- | A set of possibilities. Finite in the reference implementation.
data Space a

-- | A coherent prevision on a finite Space. Opaque handle (I1).
data Belief a

-- | A declared proposition over a Space. Peer primitive (design §3).
data Event a

-- | A Prevision-valued arrow between Spaces. Peer primitive (design §3).
data Kernel a b

-- | Evidence carries its algebra in its type (invariant I2): an Event, or
-- a (Kernel, observation) pair. No third constructor — in particular no
-- function case; the engine can never receive an opaque closure.
data Evidence a where
  Is  :: Event a -> Evidence a
  Saw :: Eq o => Kernel a o -> o -> Evidence a

mkSpace :: NonEmpty a -> Space a
mkSpace = undefined

-- | The event "equals x".
is :: Eq a => Space a -> a -> Event a
is = undefined

-- | An event from a predicate (host-layer smart constructor).
event :: Space a -> (a -> Bool) -> Event a
event = undefined

kernel :: Space a -> Space b -> (a -> Belief b) -> Kernel a b
kernel = undefined

uniform :: Space a -> Belief a
uniform = undefined

point :: Eq a => Space a -> a -> Belief a
point = undefined

-- | The prior @2^(-|program|)@: description lengths in, prevision out.
-- This is the ONLY place a prior comes from (design §5).
fromBits :: Space h -> (h -> Bits) -> Belief h
fromBits = undefined

-- | push to R: the prevision of a test function. Prediction, expected
-- utility, and marginal likelihood are all this.
expect :: Belief a -> (a -> Double) -> Double
expect = undefined

-- | Probability derived from prevision: E[indicator] (design §3).
prob :: Belief a -> Event a -> Double
prob = undefined

-- | Pushforward along a Kernel: belief over the codomain.
push :: Belief a -> Kernel a b -> Belief b
push = undefined

-- | The Bayesian update: the unique diachronically coherent rule.
-- 'Nothing' = impossible evidence (conditioning-on-the-impossible is a
-- value, not an exception: totality).
cond :: Belief a -> Evidence a -> Maybe (Belief a)
cond = undefined

-- | log marginal likelihood of the evidence: log E[likelihood], natural
-- log. This is push-to-R; it exists so no consumer needs the weights.
logPredict :: Belief a -> Evidence a -> LogProb
logPredict = undefined

-- | Posterior entropy in bits. CL-1: read-only diagnostic for display;
-- must never feed action selection.
entropyBits :: Belief a -> Double
entropyBits = undefined

-- | CL-1 diagnostic: the n highest-posterior points with probabilities.
top :: Belief a -> Int -> [(a, Double)]
top = undefined
