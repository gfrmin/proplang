{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

-- | Ablation fixture (step 9): the Expect prevision binder is
-- deletable-and-attributable. SELF-LICENSED -- src itself constructs
-- Expect (Membrane.argmaxEU), so the layer-absence check (0) FAILS by
-- design; that failure IS the license. The (a)/(b)/(c) checks below
-- isolate the constructor: this fixture imports only Syntax.
--
-- THE HONEST SHAPE (the audit's job on the most central primitive):
-- Expect's GENERIC evidence is the entire corpus -- every suite that
-- prices or evaluates a prob/utility is an unwitting deletion proof --
-- so its survival rests on twelve suites of generic usage; the
-- SELF-LICENSED flag marks only this one bespoke ablation world. A
-- primitive everything depends on is proven by everything, not by a
-- single fixture.
module UseExpect where

import PropLang.Syntax (B, Expr (..), Idx (..))

useExpect :: Expr '[B Double] Double
useExpect = Expect (Var Z) (Var Z)
