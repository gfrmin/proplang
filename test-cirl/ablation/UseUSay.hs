{-# LANGUAGE DataKinds #-}

-- test-cirl/ablation/UseUSay.hs — the pointer-door ablation fixture:
-- uses the UTIL sort's sole codeword and nothing else the flag does
-- not delete. Deletion proof (CIRL_PLAN C8 as ruled): delete USay and
-- no sentence can hold a utility — the agent's own utility stops
-- being sayable while the worlds and the verbs survive. Under
-- -DDROP_USAY this file must fail to compile, and the error must name
-- the deleted surface.
--
-- RE-DERIVED at the step-8 outcome freeze (R-D22): the door now
-- yields USent — the priced program itself. The deletion proof is
-- STRICTLY STRONGER than it was: the old text said "the opaque
-- world-data face (mkUtil) survives", and that face is GONE — with
-- USay deleted there is no way to make a utility AT ALL, from inside
-- the language or from a host. The pointer's door is now the only
-- door.
module UseUSay (useUSay) where

import PropLang.Syntax (Expr (USay), USent)

useUSay :: Expr '[Double, Double] Double -> Expr env USent
useUSay = USay
