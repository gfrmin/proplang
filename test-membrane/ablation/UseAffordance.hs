-- Fixture for the affordance-publication deletion row (interface.md §3;
-- MEMBRANE_PLAN group 7): utters a world-published affordance at its
-- home module and nothing else operational. Under -DDROP_AFFORDANCE
-- this module must NOT compile, and the error must name Affordance:
-- the external half of the menu ceases to exist and only the internal
-- acts remain offerable.
module UseAffordance where

import PropLang.Membrane (Affordance (..), mkAffId)

anAff :: Affordance
anAff = Affordance (mkAffId 1) "hold" []
