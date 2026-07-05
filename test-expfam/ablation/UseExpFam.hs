-- Ablation fixture (EXPFAM_PLAN E9, row 'expfam'): utters the family
-- constructor and nothing else operational. Type-only imports of
-- sealed nouns are permitted (recorded ruling, grammar-hygiene
-- freeze); the signature pins the ruled node shape (E3): parameter
-- space payload, carrier, stats — the family IS a kernel from its
-- parameter to the declared carrier.
module UseExpFam where

import PropLang.Belief (Space)
import PropLang.Syntax (Carrier, Expr (ExpFam), K, Stats)

use :: Space Double -> Carrier c -> Stats c -> Expr env (K Double c)
use = ExpFam
