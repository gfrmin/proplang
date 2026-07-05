-- Fixture for the echo deletion row (interface.md §5, CL-6;
-- MEMBRANE_PLAN group 7): utters the features echo at its home module
-- and nothing else operational. Under -DDROP_ECHO this module must NOT
-- compile, and the error must name echoFeatures: the agent's own
-- signature can no longer be spoken back, so no sentence can explain a
-- self-name and the self-signature world is unbuildable.
module UseEcho where

import PropLang.Eval (Features)
import PropLang.Membrane (echoFeatures, noEcho)

silent :: Features
silent = echoFeatures noEcho 0 0 Nothing
