-- Ablation fixture (EXPFAM_PLAN E9, row 'carrier-obs'): utters the
-- demonstration domain's carrier declaration and nothing else. Delete
-- the declaration and no expfam sentence can declare its output space
-- over observations — observations become context-only (interface.md
-- test E, restricted to the code level). This row's subject lives in
-- PropLang.Enumerate (declarations are domain data, plan E4), so the
-- fixture utters that module — the "Syntax only" convention scopes to
-- what the row deletes.
module UseObsCarrier where

import PropLang.Enumerate (Obs, obsCarrier)
import PropLang.Syntax (Carrier)

use :: Carrier Obs
use = obsCarrier
