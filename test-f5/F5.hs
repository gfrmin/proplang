{-# LANGUAGE DataKinds #-}
-- THE F5-DELETION INCREMENT ORACLE (the completeness boundary's
-- first increment, ruled CR2 = DELETE in-session 2026-07-27, pack
-- Part VI; ratifies at this increment's freeze tag).
--
-- THE RULING'S TWO STATEMENTS, carried here (the author's words):
--   (1) deletion re-prices the purchase sentence downward, which
--       SHIFTS PRIOR MASS toward it — deleting dead weight is still
--       PRIOR MOTION, which is exactly why it is the author's
--       signature and not cleanup;
--   (2) the re-derivation discipline — every price-mentioning row
--       below re-derives from the pricing artifact POST-deletion;
--       no row inherits a pre-deletion number; M34's identity pins
--       that the EXTENSIONAL surface does not move while the price
--       does. EXTENSION FIXED, PRICE MOVED is the deletion's
--       complete signature.
--
-- The extensional half is policed by the STANDING corpus (the d6
-- cells and trampoline g5 stay green through the deletion — M34's
-- identity, now working as the deletion's pin); this oracle carries
-- the PRICE half, which the standing corpus provably cannot see
-- (M34 UNREACHED is that proof).
--
-- R-D20 copy table:
--   w61 (the d6.1 economics)   <- test-dyadic/Dyadic.hs:214-217
--   pNs (the door namespace)   <- src/PropLang/Purchase.hs doorNs
--                                 (runPurchase's where block)
--   preDeletionRows            <- src/PropLang/Purchase.hs
--                                 purchaseRows AT COMMIT 3835952
--                                 (the pre-deletion referent, byte
--                                 copy of the refine-arm
--                                 construction with forgoneS; the
--                                 comparison's FIXED side, pinned
--                                 to the commit because the live
--                                 file moves at implementation)
--   f1's literal               <- the frozen pricing artifact
--                                 executed over the post-deletion
--                                 construction (EV-CR2, transcript
--                                 test-completeness/opening/
--                                 f5-price-delta-transcript.txt)
--   f2's literal               <- 3^16 = 43046721, same transcript
--                                 (seven nodes at 1/9, two scope-3
--                                 Vars: 9^7 * 3^2)

module Main (main) where

import Control.Exception (evaluate)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ratio ((%))
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Purchase (PurchaseWorld (..), purchaseRows)
import PropLang.Syntax

pin :: (Eq a, Show a) => String -> a -> a -> Assertion
pin name expected actual = do
  _ <- evaluate (length (show expected))
  assertEqual name expected actual

pNs :: Namespace
pNs = mkNamespace ("door" :| [])

w61 :: PurchaseWorld
w61 = PurchaseWorld { pwStakes = (1, -1)
                    , pwRefine = Just (1 % 20)
                    , pwLadderCap = 16 }

-- the pre-deletion referent (COPY, commit 3835952): the refine-arm
-- construction WITH the forgone term, held fixed so f2 measures the
-- live sentence against it
preDeletionRows :: NonEmpty ( Expr '[Rational, Rational, Rational] Rational
                            , Expr '[Rational, Rational, Rational] Rational )
preDeletionRows = rows
  where
    mintQ v = case mkC (mkGrid "k" (v :| [])) 0 of
      Just e  -> e
      Nothing -> error "preDeletionRows: singleton mint (unreachable)"
    codeM i = case mkC (mkGrid "pacts" (0 :| [1, 2])) i of
      Just e  -> e
      Nothing -> error "preDeletionRows: on-codebook index (unreachable)"
    zeroM = mintQ 0
    capM = mintQ (pwLadderCap w61)
    pessV = Var Z
    optV = Var (S Z)
    gainV = Var (S (S Z))
    forgoneS = If (Gt pessV zeroM) pessV zeroM
    refineRow s =
      If (Gt pessV zeroM) zeroM
        (If (Gt optV zeroM)
            (Sub (Sub (Mul capM gainV) (mintQ s)) forgoneS)
            zeroM)
    rows = case pwRefine w61 of
      Nothing -> (codeM 0, zeroM) :| [(codeM 1, pessV)]
      Just s  -> (codeM 0, zeroM)
             :| [(codeM 1, pessV), (codeM 2, refineRow s)]

main :: IO ()
main = defaultMain $ testGroup "f5 the forgone term's deletion (price half; extension = the standing corpus)"
  [ testCase "f1 the standing sentence's price, re-derived POST-deletion (no inherited number)" $
      pin "weightIn of chooseKS (purchaseRows w61)"
          (1 % 834385168331080533771857328695283)
          (weightIn pNs (chooseKS (purchaseRows w61)))
  , testCase "f2 extension fixed, price moved: live sentence vs the pinned pre-deletion referent = 3^16 exactly" $
      pin "weight ratio live/pre-deletion"
          (43046721 % 1)
          (weightIn pNs (chooseKS (purchaseRows w61))
           / weightIn pNs (chooseKS preDeletionRows))
  ]
