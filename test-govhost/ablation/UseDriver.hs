{-# LANGUAGE DataKinds #-}

-- | The driver's consumer-coupling fixture (HOSTS_PLAN 2.9): one
-- module that exercises exactly the frozen membrane surface the
-- govhost driver stands on, so that each EXISTING layer flag kills it
-- with an attributable error — the argmax verb (argmaxEU, named
-- directly so the DROP_ARGMAX error names the argmax surface), the
-- affordance layer (menuOptions / Affordance / wMenu / Fire), and
-- the echo layer (runMembrane / noEcho). Uses nothing any of those
-- flags does not delete, plus the always-present agent seed.
module UseDriver where

import Data.List.NonEmpty (NonEmpty)

import PropLang.Enumerate (Agent, Obs, allTerminals, enumerateModels,
                           mkAgent)
import PropLang.Membrane (Affordance (..), Choice (..), Pilot (..),
                          PureWorld (..), TickTrace, argmaxEU, menuOptions,
                          mkAffId, noEcho, runMembrane)
import PropLang.Syntax (B, Expr, Util, mkUtil)

menu :: [Affordance]
menu = [Affordance (mkAffId 1) "go" []]

world :: PureWorld ()
world = PureWorld
  { wFeats    = const [("t", 0)]
  , wEvidence = const Nothing
  , wMenu     = const menu
  , wStep     = \s _ -> s
  }

flatU :: Util Choice Obs
flatU = mkUtil (\_ _ -> 0)

opts :: NonEmpty Choice
opts = menuOptions menu

-- the doctrinal selection program, named so DROP_ARGMAX attributes
policy :: Expr '[NonEmpty Choice, B Obs, Util Choice Obs] Choice
policy = argmaxEU

drive :: Maybe (Agent, [TickTrace])
drive = runMembrane world noEcho (PilotEU flatU) 1 ()
          (mkAgent (enumerateModels allTerminals))
