{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

-- | Ablation fixture (step 9): the Expect prevision binder is
-- deletable-and-attributable. SELF-LICENSED -- src itself constructs
-- Expect (Membrane.argmaxEU), so the layer-absence check (0) FAILS by
-- design; that failure IS the license. The (a)/(b)/(c) checks below
-- isolate the constructor: this fixture imports only Syntax.
module UseExpect where

import PropLang.Syntax (B, Expr (..), Idx (..))

useExpect :: Expr '[B Double] Double
useExpect = Expect (Var Z) (Var Z)
