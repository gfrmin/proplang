-- | Deletion-audit fixture (grammar-hygiene increment, plan R6): utters
-- the 'FnUtil' member and nothing else — fully polymorphic, depends
-- only on the language modules. test-hygiene/ablation.sh compiles this
-- file twice: it must compile against the real grammar (positive
-- control) and must FAIL to compile under -DDROP_FNUTIL, with the
-- error naming 'FnUtil'. Deletion proof (normative, plan Q1): delete
-- FnUtil and expected utility becomes unutterable as a sentence — the
-- policy fragment can no longer quote its own scoring rule.
module UseFnUtil (useFnUtil) where

import PropLang.Syntax

-- RE-DERIVED at the step-8 outcome freeze (R-D22): the utility
-- payload is a priced SENTENCE (USent) and the option a residue code
useFnUtil :: Real a => USent -> Double -> Fn a
useFnUtil = FnUtil
