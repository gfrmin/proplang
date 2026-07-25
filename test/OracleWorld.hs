{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
-- The ORACLE WORLD, declared ONCE and imported by both suites (the
-- repair sitting's R6/R16: world constants live in one declaration;
-- the obs mention codebook DERIVES from the declared carrier via
-- atomGridOf — no suite self-mints an atom grid; egSpace derives from
-- the theta codebook — never hand-written; emitK is built from ONE
-- sentence here, with its provenance).
module OracleWorld
  ( oracleWorld
  , obsAtoms
  , cAtG
  , egSpace
  , emitK
  , doorAt
  ) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio ((%))

import PropLang.Belief (Kernel, Space, mkSpace)
import PropLang.Enumerate (atomGridOf)
import PropLang.Eval
import PropLang.Syntax

oracleWorld :: World
oracleWorld = World
  { wNs = mkNamespace ("t" :| [])
  , wObs = mkCarrier "obs" (0 :| [1])
  , wTheta = mkGrid "theta" (1 % 10 :| [ k % 10 | k <- [2 .. 9] ])
  , wTau = mkGrid "tau"
      (5 :| [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80])
  , wRho = mkGrid "rho"
      (1 % 100 :| [2 % 100, 5 % 100, 1 % 10, 2 % 10, 3 % 10, 4 % 10, 5 % 10])
  }

-- the obs mention codebook, DERIVED from the declared carrier
obsAtoms :: Grid
obsAtoms = atomGridOf (wObs oracleWorld)

cAtG :: Grid -> Int -> Expr env Rational
cAtG g k = case mkC g k of
  Just e -> e
  Nothing -> error "cAtG: off-codebook (unreachable)"

-- the theta carrier, DERIVED from the codebook through the C pattern
-- (read, never re-typed)
egSpace :: Space Rational
egSpace =
  case [ v | k <- [0 .. gridSize g - 1], Just (C _ _ v) <- [mkC g k] ] of
    [] -> error "empty theta codebook (unreachable)"
    (p : ps) -> mkSpace (p :| ps)
  where g = wTheta oracleWorld

-- the Bernoulli emission kernel, built from ONE weight-form sentence
-- (mass = if y > 0 then theta else 1 - theta) — the same body the
-- enumerator's walks utter (Enumerate.hs bernBody), quoted here once
emitK :: Kernel Rational Int
emitK =
  let zero = cAtG obsAtoms 0
      one = cAtG obsAtoms 1
      body = If (Gt (Var Z) zero) (Var (S Z)) (Sub one (Var (S Z)))
      sent = Code egSpace (carrierSpace (wObs oracleWorld)) body
  in case mkEnvIn (wNs oracleWorld) [("t", 0)] VNil of
       Left m -> error ("emitK door (unreachable): " ++ m)
       Right env -> case evalx sent env of
         Just k -> k
         Nothing -> error "emission code refused (unreachable)"

-- door-validated features for the oracle's tick counter
doorAt :: Int -> Features
doorAt t = case mkEnvIn (wNs oracleWorld) fs VNil :: Either String (Env '[]) of
  Right _ -> fs
  Left m -> error ("door refused the oracle tick (unreachable): " ++ m)
  where fs = [("t", fromIntegral t)]
