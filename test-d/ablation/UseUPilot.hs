{-# LANGUAGE DataKinds #-}

-- | Increment D's deletion fixture for DROP_UPILOT (HOSTS_D_PACK
-- section 9): one module binding EACH of the latent-utility surface's
-- names directly, so the flag kills it with errors that name the
-- actual dying identifiers (H-11's lesson: attribution is what the
-- compiler says, not what the row's author expects). The triple-guard
-- claim is exactly this: UPilot, UTickState, membraneTickU,
-- runMembraneU, UFamily, enumerateUModels, verdictKernel,
-- latentMarginal and the TauSpec door die together, and nothing else
-- dies (the runner's layer-absence check).
module UseUPilot where

import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Maybe (fromMaybe)

import PropLang.Belief (Belief)
import PropLang.Enumerate (Agent, TauSpec, UFamily (..), allTerminals,
                           allUFamilies, emit, enumerateModels,
                           enumerateUModels, latentMarginal, mkAgent,
                           mkTauSpec, verdictKernel)
import PropLang.Membrane (PureWorld (..), UPilot (..), UTickState (..),
                          UTickTrace, baseRung, membraneTickU, noEcho,
                          runMembraneU)
import PropLang.Syntax (Expr (..), Grid, Idx (..), mkChan, mkGrid)

ug, rg :: Grid
ug = mkGrid "ubar" (0.5 :| [])
rg = mkGrid "rho_u" (0.1 :| [])

spec :: TauSpec
spec = fromMaybe (error "covering spec must construct")
                 (mkTauSpec (mkGrid "tau" (1 :| [])) (1 :| []))

-- each name bound by name, so the errors attribute
sorts :: [UFamily]
sorts = UConst : allUFamilies

uAgent :: Agent
uAgent = mkAgent (enumerateUModels (verdictKernel ug spec) ug rg sorts)

readout :: Belief Double
readout = latentMarginal uAgent

pilot :: UPilot
pilot = UPilot
  { upSaid    = Var (S Z)
  , upVerdict = mkChan (const (verdictKernel ug spec))
  , upOutcome = emit
  , upDepth   = baseRung
  , upPrice   = "tick-price"
  }

world :: PureWorld ()
world = PureWorld
  { wFeats    = const []
  , wEvidence = const Nothing
  , wMenu     = const []
  , wStep     = \s _ -> s
  }

wAgent :: Agent
wAgent = mkAgent (enumerateModels allTerminals)

tickOnce :: Maybe ((), UTickState, Agent, NonEmpty Agent, UTickTrace)
tickOnce = membraneTickU world noEcho pilot (UTickState 0 0 Nothing) ()
             wAgent (uAgent :| [])

episode :: Maybe (Agent, NonEmpty Agent, [UTickTrace])
episode = runMembraneU world noEcho pilot 1 () wAgent (uAgent :| [])
