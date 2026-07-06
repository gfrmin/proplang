-- Fixture for the ladder deletion row (interface.md section 6;
-- LADDER_PLAN L8): utters every surface the DROP_LADDER flag removes —
-- the rung sort and its door, the rung menu, and the worker valuation.
-- Under -DDROP_LADDER this module must NOT compile, and the error must
-- name the deleted items: with the ladder gone no deeper estimate can
-- be spoken or valued, and what SURVIVES is exactly the myopic base —
-- the induction base cannot be deleted, which is section 6's honest
-- minimum stated as a compile fact.
module UseLadder where

import Data.List.NonEmpty (NonEmpty ((:|)))

import PropLang.Belief (uniform)
import PropLang.Enumerate (Obs, emit, thetaSpace)
import PropLang.Eval (vThinkK)
import PropLang.Membrane (Rung, baseRung, ladderRungs, mkRung, rungDepth)
import PropLang.Syntax (Grid, mkUtil)

menu :: Grid -> NonEmpty Rung
menu = ladderRungs

deepest :: Grid -> Int
deepest g = maximum (rungDepth baseRung
                     : [ rungDepth r | Just r <- [mkRung g 0] ])

valuation :: Double
valuation = vThinkK 2 (uniform thetaSpace) emit ([0, 1] :: [Obs])
                    (mkUtil (\() th -> th)) (() :| []) 3 0.05
