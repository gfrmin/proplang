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
import PropLang.Syntax (Chan, applyChan, mkChan, mkUtil)

chan :: Chan () Double Obs
chan = mkChan (const emit)

shown :: Kernel Double Obs
shown = applyChan chan ()

valuation :: Double
valuation = vPre 1 (uniform thetaSpace) chan ([0, 1] :: [Obs])
                 (mkUtil (\_ _ -> 0)) (() :| [])
                 (mkUtil (\() th -> th)) (() :| []) 3 0.05
