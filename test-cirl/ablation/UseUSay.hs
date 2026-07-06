{-# LANGUAGE DataKinds #-}

-- test-cirl/ablation/UseUSay.hs — the pointer-door ablation fixture:
-- uses the UTIL sort's sole codeword and nothing else the flag does
-- not delete. Deletion proof (CIRL_PLAN C8 as ruled): delete USay and
-- no sentence can hold a utility — the agent's own utility stops
-- being sayable while the worlds, the verbs, and the opaque
-- world-data face (mkUtil) all survive. Under -DDROP_USAY this file
-- must fail to compile, and the error must name the deleted surface.
module UseUSay (useUSay) where

import PropLang.Syntax (Expr (USay), Util)

useUSay :: Expr '[Double, Double] Double -> Expr env (Util Double Double)
useUSay = USay
