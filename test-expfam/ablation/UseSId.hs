-- Ablation fixture (EXPFAM_PLAN E9, row 'sid'): utters the identity
-- statistic and nothing else. Deleting the last STATS member makes the
-- family node uncompletable — likelihood assignment dies at the stats
-- door (plan Q4's deletion proof, checked by type).
module UseSId where

import PropLang.Syntax (Stats (SId))

use :: Stats Int
use = SId
