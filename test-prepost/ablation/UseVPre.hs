-- Fixture for the preposterior deletion row (PREPOSTERIOR_PLAN P8):
-- utters every surface the DROP_VPRE flag removes — the action-indexed
-- channel and its door, and the action-dependent worker. Under
-- -DDROP_VPRE this module must NOT compile, and the error must name
-- the deleted items: with the mechanism gone no decision's own channel
-- can be spoken and exploration is unpriceable — behavior collapses to
-- the immediate argmax. What SURVIVES is the myopic base AND the
-- fidelity ladder: anticipation deletes, deliberation does not.
module UseVPre where

import Data.List.NonEmpty (NonEmpty ((:|)))

import PropLang.Belief (Kernel, uniform)
import PropLang.Enumerate (Obs, emit, thetaSpace)
import PropLang.Eval (vPre)
import PropLang.Syntax (Chan, Expr (..), Idx (..), USent (..), applyChan,
                        mkC, mkChan, mkGrid)

-- RE-DERIVED at the step-8 outcome freeze (R-D22): the utilities are
-- priced SENTENCES and the menus are residue codes; the fixture still
-- utters exactly what DROP_VPRE deletes and nothing else.
chan :: Chan Double Double Obs
chan = mkChan (const emit)

shown :: Kernel Double Obs
shown = applyChan chan 0

gk0 :: Double -> Expr env Double
gk0 v = case mkC (mkGrid "k" (v :| [])) 0 of
  Just e  -> e
  Nothing -> error "UseVPre fixture: singleton grid index 0 must construct"

valuation :: Double
valuation = vPre 1 (uniform thetaSpace) chan ([0, 1] :: [Obs])
                 (USent (gk0 0)) (0 :| [])
                 (USent (Var (S Z))) (0 :| []) 3 0.05
