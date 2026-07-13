{-# LANGUAGE DerivingStrategies #-}

-- | The sealed reasoner (typed-port-spec §2).
--
-- One module owns all probability arithmetic. The 'Belief' constructor is
-- NOT exported: no code outside this module can read, write, or name a
-- log-weight (invariant I1 as a compile fact). The export list below is
-- frozen verbatim from typed-port-spec §2 (as amended) and checked by
-- audit gate 2.
--
-- The arithmetic mirrors the Python reference (proplang.py) operation for
-- operation: the same log-sum-exp, the same left-to-right summation order,
-- the same skip rules on zero-mass points, the same normalization at
-- construction. Cross-language float agreement is therefore at the
-- unit-in-last-place level, orders of magnitude inside the frozen anchor
-- tolerances.
module PropLang.Belief
  ( Space, mkSpace, spacePoints
  , Belief                      -- abstract: constructor NOT exported
  , Event, is, event            -- host-layer smart constructors
  , Kernel, kernel
  , Evidence(..)                -- closed variant: I2
  , Bits(..), LogProb(..)       -- newtypes; derived numeric instances
  , uniform, point, fromBits    -- the ONLY prior sources in the system
  , expect, prob, push, cond, logPredict
  , entropyBits, top            -- CL-1 diagnostics, read-only by type
  ) where

import Data.List (sortOn)
import Data.List.NonEmpty (NonEmpty, toList)

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

-- | A set of possibilities. Finite in the reference implementation, and
-- nonempty by construction ('mkSpace').
data Space a = Space [a]

-- | A coherent prevision on a finite Space. Opaque handle (I1): the
-- log-weights are normalized at construction and never leave this module.
data Belief a = Belief (Space a) [Double]

-- | A declared proposition over a Space. Peer primitive (design §3).
data Event a = Event (a -> Bool)

-- | A Prevision-valued arrow between Spaces. Peer primitive (design §3).
-- The codomain rides along because 'push' accumulates over its points;
-- a kernel's output beliefs are over the codomain, in its point order.
data Kernel a b = Kernel (Space b) (a -> Belief b)

-- | Evidence carries its algebra in its type (invariant I2): an Event, or
-- a (Kernel, observation) pair. No third constructor — in particular no
-- function case; the engine can never receive an opaque closure.
data Evidence a where
  Is  :: Event a -> Evidence a
  Saw :: Eq o => Kernel a o -> o -> Evidence a

-- ---------------------------------------------------------------------
-- private arithmetic (the reference's _lse and summation conventions)
-- ---------------------------------------------------------------------

negInf :: Double
negInf = -1 / 0

ln2 :: Double
ln2 = log 2

-- left-to-right summation from zero, as Python's sum()
sumL :: [Double] -> Double
sumL = foldl' (+) 0

-- log-sum-exp over a nonempty list (every call site supplies one)
lse :: [Double] -> Double
lse xs =
  let m = maximum xs
  in if m == negInf
       then negInf
       else m + log (sumL [exp (x - m) | x <- xs])

-- Normalize log-weights into a Belief; 'Nothing' when the total mass is
-- zero (the reference constructor raises "conditioned on an impossible
-- evidence" here; the public surface exposes this only through 'cond',
-- whose Maybe is the frozen totality story).
mkBelief :: Space a -> [Double] -> Maybe (Belief a)
mkBelief sp ws =
  let z = lse ws
  in if z == negInf
       then Nothing
       else Just (Belief sp [w - z | w <- ws])

-- The three prior constructors and 'push' return bare 'Belief' by frozen
-- signature; on zero total mass they can only mirror the reference's
-- raise. Every such site is unreachable from the frozen suites.
orImpossible :: String -> Maybe (Belief a) -> Belief a
orImpossible site Nothing  = error (site ++ ": belief has no mass")
orImpossible _ (Just b) = b

-- ---------------------------------------------------------------------
-- constructors
-- ---------------------------------------------------------------------

mkSpace :: NonEmpty a -> Space a
mkSpace = Space . toList

-- | The point list a Space was declared with ('mkSpace''s own argument,
-- declaration order). Amended into the frozen export list at
-- code-freeze-r0 (step 1; pack §6.10 item 6, the author's ruling):
-- 'Code'/'Pos' evaluation enumerates a Space's points, and nothing
-- sealed leaks — a Space IS its declared points; the WEIGHTS stay
-- inside this module.
spacePoints :: Space a -> [a]
spacePoints (Space pts) = pts

-- | The event "equals x".
is :: Eq a => Space a -> a -> Event a
is _ x = Event (== x)

-- | An event from a predicate (host-layer smart constructor).
event :: Space a -> (a -> Bool) -> Event a
event _ = Event

kernel :: Space a -> Space b -> (a -> Belief b) -> Kernel a b
kernel _ = Kernel

uniform :: Space a -> Belief a
uniform sp@(Space pts) =
  orImpossible "uniform" (mkBelief sp (map (const 0) pts))

point :: Eq a => Space a -> a -> Belief a
point sp@(Space pts) x =
  orImpossible "point" (mkBelief sp [if p == x then 0 else negInf | p <- pts])

-- | The prior @2^(-|program|)@: description lengths in, prevision out.
-- This is the ONLY place a prior comes from (design §5).
fromBits :: Space h -> (h -> Bits) -> Belief h
fromBits sp@(Space pts) f =
  orImpossible "fromBits"
    (mkBelief sp [negate b * ln2 | p <- pts, let Bits b = f p])

-- ---------------------------------------------------------------------
-- verbs
-- ---------------------------------------------------------------------

-- | push to R: the prevision of a test function. Prediction, expected
-- utility, and marginal likelihood are all this.
expect :: Belief a -> (a -> Double) -> Double
expect (Belief (Space pts) ws) f =
  sumL [exp w * f x | (x, w) <- zip pts ws, w > negInf]

-- | Probability derived from prevision: E[indicator] (design §3).
prob :: Belief a -> Event a -> Double
prob b (Event p) = expect b (\x -> if p x then 1.0 else 0.0)

-- | Pushforward along a Kernel: belief over the codomain. Positional over
-- the codomain's points, in source-point order per accumulator, exactly
-- as the reference's per-point append lists.
push :: Belief a -> Kernel a b -> Belief b
push (Belief (Space xs) ws) (Kernel cod@(Space cs) f) =
  orImpossible "push" (mkBelief cod logw)
  where
    rows = [ (w, bws) | (x, w) <- zip xs ws, w > negInf
                      , let Belief _ bws = f x ]
    col j = [ w + wy | (w, bws) <- rows, let wy = bws !! j, wy > negInf ]
    logw = [ if null cj then negInf else lse cj
           | j <- [0 .. length cs - 1], let cj = col j ]

-- Log-likelihood of the evidence at each point of the belief's space
-- (the reference's _loglik; private).
loglik :: Belief a -> Evidence a -> [Double]
loglik (Belief (Space pts) _) ev = case ev of
  Is (Event p) -> [if p x then 0 else negInf | x <- pts]
  Saw (Kernel cod f) o ->
    [ let p = prob (f x) (is cod o)
      in if p > 0 then log p else negInf
    | x <- pts ]

-- | The Bayesian update: the unique diachronically coherent rule.
-- 'Nothing' = impossible evidence (conditioning-on-the-impossible is a
-- value, not an exception: totality).
cond :: Belief a -> Evidence a -> Maybe (Belief a)
cond b@(Belief sp ws) ev = mkBelief sp (zipWith (+) ws (loglik b ev))

-- | log marginal likelihood of the evidence: log E[likelihood], natural
-- log. This is push-to-R; it exists so no consumer needs the weights.
logPredict :: Belief a -> Evidence a -> LogProb
logPredict b@(Belief _ ws) ev =
  LogProb (lse (zipWith (+) ws (loglik b ev)))

-- ---------------------------------------------------------------------
-- diagnostics
-- ---------------------------------------------------------------------

-- | Posterior entropy in bits. CL-1: read-only diagnostic for display;
-- must never feed action selection.
entropyBits :: Belief a -> Double
entropyBits (Belief _ ws) =
  negate (sumL [exp w * w | w <- ws, w > negInf]) / ln2

-- | CL-1 diagnostic: the n highest-posterior points with probabilities.
-- Stable descending sort, as the reference's sorted(key = -weight).
top :: Belief a -> Int -> [(a, Double)]
top (Belief (Space pts) ws) n =
  [ (x, exp w) | (x, w) <- take n (sortOn (negate . snd) (zip pts ws)) ]
