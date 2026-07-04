-- | Deletion-audit fixture (grammar-hygiene increment, plan R6): utters
-- the 'FnInd' member and nothing else — fully polymorphic, depends only
-- on the language modules. test-hygiene/ablation.sh compiles this file
-- twice: it must compile against the real grammar (positive control)
-- and must FAIL to compile under -DDROP_FNIND, with the error naming
-- 'FnInd'. Deletion proof (normative, plan Q1): delete FnInd and no
-- sentence can say P(E) — probability-as-prevision loses its syntactic
-- witness.
module UseFnInd (useFnInd) where

import PropLang.Belief (Event)
import PropLang.Syntax

useFnInd :: Event a -> Fn a
useFnInd = FnInd
