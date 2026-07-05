-- Fixture for the slot-grid deletion row (interface.md §8 E; MEMBRANE_PLAN
-- group 7): utters a grid-priced slot — the external action layer's
-- pricing surface, at its home module — and nothing else operational.
-- Under -DDROP_SLOT_GRID this module must NOT compile, and the error
-- must name Slot: affordances become unpriceable and the external menu
-- cannot be written at all.
module UseSlotGrid where

import Data.List.NonEmpty (NonEmpty ((:|)))

import PropLang.Membrane (Slot (..))
import PropLang.Syntax (mkGrid)

aSlot :: Slot
aSlot = Slot "speed" (mkGrid "speed" (0.2 :| [0.4, 0.6, 0.8]))
