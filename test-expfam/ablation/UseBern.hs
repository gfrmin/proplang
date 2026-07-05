-- Ablation fixture (EXPFAM_PLAN E9, row 'bern'): utters the derived
-- name and nothing else operational. The signature pins the ruled name
-- shape (E6): carrier payload, one Double argument, Belief-valued.
-- Capability survives this deletion (raw expfam remains sayable);
-- brevity dies — the call-boundary honesty flag (design §2) applied to
-- a derived name.
module UseBern where

import PropLang.Syntax (Args (..), B, Carrier, Expr (Call), StdName (Bern))

use :: Carrier Int -> Expr env Double -> Expr env (B Int)
use car p = Call (Bern car) (p :* ANil)
