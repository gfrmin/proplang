{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
-- Big-step evaluation, pure and total on door-built envs
-- (exact-freeze-r0). Env construction is DOOR-ONLY (ruling R5): the
-- three refusals are named; no 0.0 default exists.
module PropLang.Eval
  ( Features
  , Vals (..)
  , Env
  , mkEnvIn
  , evalx
  ) where

import Data.List (nub)
import Data.Maybe (fromMaybe)

import PropLang.Belief (condV, expect, fromWeights, kernel, spacePoints)
import PropLang.Syntax

type Features = [(Name, Rational)]

data Vals env where
  VNil :: Vals '[]
  (:.) :: t -> Vals env -> Vals (t ': env)

infixr 5 :.

data Env env = Env Features (Vals env)

-- | THE DOOR (ruling #8 as repaired at the R5 sitting, fail-closed):
-- Env construction is DOOR-ONLY — this is the sole exported
-- constructor, so the door is an Env invariant, never call-site
-- discipline. A tick must cover the declared namespace exactly; the
-- three refusals are named (the A5 evidence's Either form). The
-- 0.0-dormancy default is dead; an under-specified tick is
-- UNSERVABLE, not silently defaulted.
mkEnvIn :: Namespace -> Features -> Vals env -> Either String (Env env)
mkEnvIn ns feats vals
  | not (null missing) = Left ("tick refused: missing declared "
                               ++ show missing)
  | not (null extra) = Left ("tick refused: undeclared " ++ show extra)
  | not (null dup) = Left ("tick refused: duplicate " ++ show dup)
  | otherwise = Right (Env feats vals)
  where
    names = nsNames ns
    given = map fst feats
    missing = [ n | n <- names, n `notElem` given ]
    extra = [ g | g <- given, g `notElem` names ]
    dup = [ g | g <- nub given, length (filter (== g) given) > 1 ]

lookupVal :: Idx env t -> Vals env -> t
lookupVal Z (v :. _) = v
lookupVal (S i) (_ :. vs) = lookupVal i vs

-- | Total on door-built envs (the ONLY kind that exists: mkEnvIn is
-- the sole constructor): every Get names a declared feature
-- (enumeration utters only declared names; the wire's parser checks
-- against the hello's namespace), and the door guarantees the
-- declared names are present. The error is door-unreachable — the
-- cAt-precedented form for an invariant the types do not yet carry.
evalx :: Expr env t -> Env env -> t
evalx expr env@(Env feats vals) = case expr of
  C _ _ v -> v
  Get nm -> fromMaybe (error ("evalx: Get \"" ++ nm
                              ++ "\" undeclared (door-unreachable)"))
                      (lookup nm feats)
  If c t e -> if evalx c env then evalx t env else evalx e env
  Gt a b -> evalx a env > evalx b env
  Var ix -> lookupVal ix vals
  Sub a b -> evalx a env - evalx b env
  Mul a b -> evalx a env * evalx b env
#ifndef DROP_EXPECT
  Expect b body ->
    expect (evalx b env)
           (\x -> evalx body (Env feats (realToFrac x :. vals)))
#endif
#ifndef DROP_COND
  -- the fused conditioning verb: condition the belief through the
  -- kernel on the observed outcome; Just-arm binds the posterior,
  -- Nothing-arm is the impossible-evidence sentence (load-bearing).
  Cond b k y j n -> case condV (evalx b env) (evalx k env) (evalx y env) of
    Just b' -> evalx j (Env feats (b' :. vals))
    Nothing -> evalx n env
#endif
#ifndef DROP_CODE
  -- weight-form denotation: a code denotes iff every column is lawful
  -- (all masses >= 0, some > 0) — decidable; fromWeights IS the check.
  Code dom cod body ->
    let cell x y = evalx body
          (Env feats (realToFrac y :. realToFrac x :. vals))
        col x = fromWeights cod (cell x)
        cols = map col (spacePoints dom)
    in if all ok cols
         then Just (kernel dom cod (\x ->
                case col x of
                  Just b -> b
                  Nothing -> error "Code: unlawful column (guarded above)"))
         else Nothing
    where
      ok c = case c of { Just _ -> True; Nothing -> False }
#endif
