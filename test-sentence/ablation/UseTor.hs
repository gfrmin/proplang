-- Ablation fixture (step 3, decision 9; row 'tor'): utters THE VALUE
-- READER and nothing else operational. Delete 'ToR' and every
-- statistic dies: eta * T(y) needs T(y) :: Double and a position
-- cannot supply it (AGENT_PLAN §5d; test-code group 3 is why).
module UseTor where

import PropLang.Syntax (Expr (..))

use :: Expr env Int -> Expr env Double
use = ToR
