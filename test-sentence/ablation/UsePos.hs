-- Ablation fixture (step 3, decision 9; row 'pos'): utters THE
-- POSITION READER and nothing else operational. Delete 'Pos' and the
-- reflected walk is unsayable: the shipped grids are FP-nonuniform,
-- so adjacency is not a function of the values (AGENT_PLAN §5d).
module UsePos where

import PropLang.Belief (Space)
import PropLang.Syntax (Expr (..))

use :: Space Double -> Expr env Double -> Expr env Double
use = Pos
