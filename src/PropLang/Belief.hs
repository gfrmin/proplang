{-# LANGUAGE GHC2021 #-}
-- The sealed exact reasoner (Phase 2 of the exact re-founding;
-- exact-freeze-r0). This surface is the one the frozen oracle's SAT
-- transcripts ran against (pack IX.3); S2 re-binds to it at the close.
module PropLang.Belief
  ( Space, mkSpace, spacePoints
  , Belief                       -- abstract: constructor NOT exported
  , Kernel, kernel, kernelSpace, kernelAt
  , fromWeights                  -- the ONLY prior source (L4' introducer)
  , uniform, point               -- DEFINITIONS over fromWeights (ruling #7)
  , expect, prob
  , push                         -- engine/host machinery (the grammar
                                 -- verb died; prediction stays sayable
                                 -- via Expect/Cond — the agent criterion)
  , condK, condV, predictMass    -- conditioning / marginal mass, exact
  , points, weights, top         -- CL-1 diagnostics: exact read-only views
                                 -- (entropy DISPLAY lives in Report — E1)
  ) where

import Data.List (sortBy)
import Data.List.NonEmpty (NonEmpty, toList)
import Data.Ord (comparing, Down (..))

data Space a = Space [a]

mkSpace :: NonEmpty a -> Space a
mkSpace = Space . toList

spacePoints :: Space a -> [a]
spacePoints (Space pts) = pts

-- normalized: every weight >= 0, sum == 1, EXACTLY
data Belief a = Belief (Space a) [Rational]

data Kernel a b = Kernel (Space b) (a -> Belief b)

kernel :: Space a -> Space b -> (a -> Belief b) -> Kernel a b
kernel _ cod f = Kernel cod f

kernelSpace :: Kernel a b -> Space b
kernelSpace (Kernel cod _) = cod

kernelAt :: Kernel a b -> a -> Belief b
kernelAt (Kernel _ f) = f

-- | The introducer. Refuses (Nothing) iff no positive mass — the
-- impossible-evidence value; otherwise normalizes exactly.
fromWeights :: Space a -> (a -> Rational) -> Maybe (Belief a)
fromWeights sp@(Space pts) f =
  let ws = map f pts
      z = sum ws
  in if any (< 0) ws || z <= 0
       then Nothing
       else Just (Belief sp [ w / z | w <- ws ])

-- | DERIVED (ruling #7): uniform is fromWeights of the constant mass.
-- Total: a Space is nonempty by construction (mkSpace/NonEmpty).
uniform :: Space a -> Belief a
uniform sp = case fromWeights sp (const 1) of
  Just b  -> b
  Nothing -> error "uniform: empty space (unreachable: mkSpace is NonEmpty)"

-- | DERIVED (ruling #7): point is fromWeights of the indicator.
point :: Eq a => Space a -> a -> Maybe (Belief a)
point sp x = fromWeights sp (\y -> if y == x then 1 else 0)

expect :: Belief a -> (a -> Rational) -> Rational
expect (Belief (Space pts) ws) f =
  sum [ w * f x | (x, w) <- zip pts ws ]

-- | DERIVED from prevision: E[indicator] (design §3, unchanged).
prob :: Belief a -> (a -> Bool) -> Rational
prob b p = expect b (\x -> if p x then 1 else 0)

-- | The exact forward marginal (engine machinery; see export note).
push :: Belief a -> Kernel a b -> Belief b
push (Belief (Space pts) ws) k =
  let cod@(Space cps) = kernelSpace k
      colWs x = let Belief _ cws = kernelAt k x in cws
      out = foldr (zipWith (+)) (map (const 0) cps)
                  [ map (w *) (colWs x) | (x, w) <- zip pts ws ]
  in Belief cod out

-- | Conditioning through a kernel on an observed outcome — the sealed
-- Bayes step (the system's one division lives here, in normalization).
-- Nothing = impossible evidence. A Properties row pins this
-- extensionally to fromWeights over the product masses (CL-4 exact).
condK :: Eq b => Belief a -> Kernel a b -> b -> Maybe (Belief a)
condK (Belief sp@(Space pts) ws) k y =
  let ms = [ w * prob (kernelAt k x) (== y) | (x, w) <- zip pts ws ]
      z = sum ms
  in if z <= 0 then Nothing else Just (Belief sp [ m / z | m <- ms ])

-- | Value-matched conditioning: the observed outcome arrives as the
-- RATIONAL the sentence said (the Cond verb's binder convention);
-- the carrier match is realToFrac-exact (Int and Rational both embed
-- exactly).
condV :: Real b => Belief a -> Kernel a b -> Rational -> Maybe (Belief a)
condV (Belief sp@(Space pts) ws) k v =
  let ms = [ w * prob (kernelAt k x) (\o -> realToFrac o == v)
           | (x, w) <- zip pts ws ]
      z = sum ms
  in if z <= 0 then Nothing else Just (Belief sp [ m / z | m <- ms ])

-- | The marginal MASS of an outcome under belief-through-kernel:
-- sum_x w(x) * P_k(x)(y). Exact; the bits view is reporting-edge.
predictMass :: Eq b => Belief a -> Kernel a b -> b -> Rational
predictMass (Belief (Space pts) ws) k y =
  sum [ w * prob (kernelAt k x) (== y) | (x, w) <- zip pts ws ]

-- | The carrier's points (read-only view; with 'weights' the sampling
-- basis of the host's draw — CL-2's boundary reads, never writes).
points :: Belief a -> [a]
points (Belief (Space pts) _) = pts

-- | Exact read-only weight view (the seal guards CONSTRUCTION, not
-- reading — 'top' already reads; displays derive from this at the
-- reporting edge, never here: E1).
weights :: Belief a -> [Rational]
weights (Belief _ ws) = ws

-- | CL-1 diagnostic: the n highest-posterior indices (read-only;
-- index-keyed so Eq is not demanded of the carrier).
top :: Int -> Belief a -> [(Int, Rational)]
top n (Belief _ ws) =
  take n (sortBy (comparing (Down . snd)) (zip [0 ..] ws))
