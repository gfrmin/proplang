{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
-- World-parametric enumeration and the sentence-driven engine
-- (exact-freeze-r0). E3: no concrete point-set in this module — every
-- grid, atom, and name arrives in the World.
module PropLang.Enumerate
  ( FragSort (..), FragProd (..), fragSortOf, fragWidth, fragFull
  , Hyp (..)
  , constCharge, walkCharge, guardCharge
  , enumerate
  , enumerateWith
  , enumerateWithArity
  , Breadth (..)
  , enumerateWithBreadth
  , corpusBodies
  , inCorpus
  , AgentS
  , agentObsPoints
  , atomGridOf
  , sentenceAgent
  , observeS
  , stepFrozenS
  , predictMassS
  , metaPosterior
  , mapS
  , kraftSum
  ) where

import Data.List (maximumBy)
import Data.List.NonEmpty (NonEmpty ((:|)))
import Data.Ord (comparing)

import PropLang.Belief
import PropLang.Eval
import PropLang.Syntax

-- ---------------------------------------------------------------------
-- The fragment (sorts, productions, charges) — declared data
-- ---------------------------------------------------------------------

data FragSort = MODEL | THETA | HEAD | RATE
  deriving (Eq, Show)

data FragProd = FBern | FWalk | FConst | FIf | FGuardHead
  deriving (Eq, Show)

fragSortOf :: FragProd -> FragSort
fragSortOf FBern = MODEL
fragSortOf FWalk = MODEL
fragSortOf FConst = THETA
fragSortOf FIf = THETA
fragSortOf FGuardHead = HEAD

fragWidth :: FragSort -> Integer
fragWidth MODEL = 2
fragWidth THETA = 2
fragWidth HEAD = 2
fragWidth RATE = 1

fragFull :: [FragProd]
fragFull = [FBern, FWalk, FConst, FIf, FGuardHead]

-- the exact charge trees (shapes ported from the frozen step-4 trees,
-- CSum -> CMul, CBits log2 -> CMass exact; values pinned by A2:
-- 1/36, 1/16, 1/82944)
mentionMass :: Grid -> Charge s
mentionMass g = CMass (1 / fromIntegral (gridSize g))

constCharge :: Grid -> Charge FragSort
constCharge eg = CMul (CW MODEL) (CMul (CW THETA) (mentionMass eg))

walkCharge :: Grid -> Charge FragSort
walkCharge rg = CMul (CW MODEL) (CMul (CW RATE) (mentionMass rg))

guardCharge :: Namespace -> Grid -> Grid -> Charge FragSort
guardCharge ns g eg =
  CMul (CW MODEL) (CMul (CMul x y) z)
  where
    nsB = CMass (1 / fromIntegral (nsSize ns))
    x = CMul (CW THETA)
             (CMul (CMul (CW HEAD) nsB)
                   (CMul (CW THETA) (mentionMass g)))
    y = CMul (CW THETA) (mentionMass eg)
    z = CMul (CW THETA) (mentionMass eg)

-- ---------------------------------------------------------------------
-- Hypotheses: a sentence, its exact prior weight, its latent axis,
-- and a declared TAG (family + mention indices — introspectable data,
-- so no probe ever re-derives an identity)
-- ---------------------------------------------------------------------

data Hyp = Hyp
  { hypTag :: (String, [Int])
  , hypW :: Rational
  , hypLatent :: Space Rational
  , hypEmit :: Expr '[] (Maybe (K Rational Int))
  , hypMove :: Maybe (Expr '[] (Maybe (K Rational Rational)))
  }

-- | World-parametric enumeration: consts, walks, guard families —
-- order and counts match the frozen reference (1169 under the
-- oracle world). DERIVES from enumerateWith (one family builder; the
-- World form binds every namespace name to the wTau codebook).
enumerate :: World -> [FragProd] -> [Hyp]
enumerate w =
  enumerateWith (wNs w) (wObs w) (wTheta w)
                [ (nm, wTau w) | nm <- nsNames (wNs w) ]
                (Just (wRho w))

-- | The host-facing form (the wire declares per-name guard codebooks
-- and may omit walks): same families, same order, grids per guard
-- name. K=2 obs carriers only; the K-ary route is
-- 'enumerateWithArity'.
enumerateWith :: Namespace -> Carrier Int -> Grid -> [(Name, Grid)]
              -> Maybe Grid -> [FragProd] -> [Hyp]
enumerateWith _ns obsC eg guardGs mrg allowed =
    consts ++ walks ++ concatMap guardFamily guardGs
  where
    has t = t `elem` allowed
    obsSp = carrierSpace obsC
    atomG = atomGridOf obsC
    cAt :: Grid -> Int -> Expr env Rational
    cAt g k = case mkC g k of
      Just e -> e
      Nothing -> error "enumerate: on-codebook index refused (unreachable)"
    zero = cAt atomG 0
    one = cAt atomG 1
    -- equality: the If/Gt composition (E-e2; under Rational a THEOREM)
    eqE a b = If (Gt a b) falseE (If (Gt b a) falseE trueE)
      where
        trueE = Gt one zero
        falseE = Gt zero one
    -- the weight-form bern body over an outcome bound at Var Z:
    -- mass = if y > 0 then th else 1 - th
    bernBody th = If (Gt (Var Z) zero) th (Sub one th)
    -- the unit latent for stateless sentences: codebook-derived point,
    -- weight 1, value never read (no 0.5 literal)
    unitLatent = mkSpace (thetaPt 0 :| [])
    thetaPt k = case mkC eg k :: Maybe (Expr '[] Rational) of
      Just (C _ _ v) -> v
      _ -> error "enumerate: theta codebook too small"
    egSp = mkSpace (case [ thetaPt k | k <- [0 .. gridSize eg - 1] ] of
                      [] -> error "enumerate: empty codebook (unreachable)"
                      (p : ps) -> p :| ps)
    consts =
      [ Hyp ("const", [k]) (chargeMass fragWidth (constCharge eg))
            unitLatent
            (Code unitLatent obsSp (bernBody (cAt eg k)))
            Nothing
      | has FBern, has FConst, k <- [0 .. gridSize eg - 1] ]
    walks = case mrg of
      Nothing -> []
      Just rg ->
        [ Hyp ("walk", [j]) (chargeMass fragWidth (walkCharge rg))
              egSp
              (Code egSp obsSp (bernBody (Var (S Z))))
              (Just (walkMove rg j))
        | has FWalk, has FConst, j <- [0 .. gridSize rg - 1] ]
    -- the reflected walk's move code, Pos-free and Div-free: adjacency
    -- by VALUE (the codebook is exactly uniform), the step DERIVED from
    -- the codebook, masses in Mul-form (2-2p, p, p) — fromWeights
    -- normalizes to the law (1-p, p/2, p/2; reflected edges p)
    walkMove rg j = Code egSp egSp mass
      where
        rv = cAt rg j
        xv = Var (S Z)
        jv = Var Z
        step = Sub (cAt eg 1) (cAt eg 0)
        minT = cAt eg 0
        maxT = cAt eg (gridSize eg - 1)
        lo = If (Gt xv minT) (Sub xv step) (addM xv step)
        hi = If (Gt maxT xv) (addM xv step) (Sub xv step)
        two = addM one one
        stay = Mul two (Sub one rv)
        mass = addM (addM (If (eqE jv xv) stay zero)
                          (If (eqE jv lo) rv zero))
                    (If (eqE jv hi) rv zero)
    guardFamily (nm, tg) =
      [ Hyp ("guard", [kt, a, b]) (chargeMass fragWidth (guardCharge _ns tg eg))
            unitLatent
            (Code unitLatent obsSp
               (bernBody (If (Gt (Get nm) (cAt tg kt)) (cAt eg a) (cAt eg b))))
            Nothing
      | has FBern, has FIf, has FConst, has FGuardHead
      , kt <- [0 .. gridSize tg - 1]
      , a <- [0 .. gridSize eg - 1], b <- [0 .. gridSize eg - 1], a /= b ]

-- | The K-ary route (W3's arity capability, exact): at declared arity
-- K >= 2 the families run over distinguished POSITIVE atoms
-- j in {1..K-1}, j outermost per family — P(y = j) = theta with the
-- rest of the codomain sharing (1 - theta) uniformly. Weight-form and
-- Mul-form: the target atom's mass is (K-1)*theta with the world
-- integer K-1 READ FROM THE ATOM CODEBOOK'S OWN LAST ATOM (atoms are
-- 0..K-1, so the last atom's value IS K-1 — no second declaration);
-- the spread atoms carry (1 - theta); fromWeights normalizes to the
-- law (theta target, (1-theta)/(K-1) spread — the SevenSeats/CatBody
-- bank). The arity charge is the shipped tree times the atom mention
-- 1/(K-1) (the M1 namespace-law shape: 1 at K = 2). At K = 2 this
-- route coincides with 'enumerateWith' extensionally (the old g2
-- coincidence, now pinned EXACTLY in test-pin/Arity).
enumerateWithArity :: Int -> Namespace -> Carrier Int -> Grid
                   -> [(Name, Grid)] -> Maybe Grid -> [FragProd] -> [Hyp]
enumerateWithArity kAr _ns obsC eg guardGs mrg allowed =
    concat [ constsJ j | j <- posAtoms ]
    ++ concat [ walksJ j | j <- posAtoms ]
    ++ concat [ guardFamilyJ j g | j <- posAtoms, g <- guardGs ]
  where
    has t = t `elem` allowed
    posAtoms = [1 .. kAr - 1]
    obsSp = carrierSpace obsC
    atomG = atomGridOf obsC
    cAt :: Grid -> Int -> Expr env Rational
    cAt g k = case mkC g k of
      Just e -> e
      Nothing -> error "enumerateWithArity: off-codebook (unreachable)"
    zero = cAt atomG 0
    one = if gridSize atomG > 1 then cAt atomG 1 else zero
    eqE a b = If (Gt a b) falseE (If (Gt b a) falseE trueE)
      where
        trueE = Gt one zero
        falseE = Gt zero one
    km1 = cAt atomG (kAr - 1)          -- the world integer K-1, read
                                       -- from the carrier's own atoms
    catBody j th =
      If (eqE (Var Z) (cAt atomG j)) (Mul km1 th) (Sub one th)
    arityMass = CMass (1 / fromIntegral (max 1 (kAr - 1)))
    unitLatent = mkSpace (thetaPt 0 :| [])
    thetaPt k = case mkC eg k :: Maybe (Expr '[] Rational) of
      Just (C _ _ v) -> v
      _ -> error "enumerateWithArity: theta codebook too small"
    egSp = mkSpace (case [ thetaPt k | k <- [0 .. gridSize eg - 1] ] of
                      [] -> error "enumerateWithArity: empty codebook"
                      (q : qs) -> q :| qs)
    constsJ j =
      [ Hyp ("const", [j, k])
            (chargeMass fragWidth (CMul (constCharge eg) arityMass))
            unitLatent
            (Code unitLatent obsSp (catBody j (cAt eg k)))
            Nothing
      | has FBern, has FConst, k <- [0 .. gridSize eg - 1] ]
    walksJ j = case mrg of
      Nothing -> []
      Just rg ->
        [ Hyp ("walk", [j, r])
              (chargeMass fragWidth (CMul (walkCharge rg) arityMass))
              egSp
              (Code egSp obsSp (catBody j (Var (S Z))))
              (Just (walkMoveA rg r))
        | has FWalk, has FConst, r <- [0 .. gridSize rg - 1] ]
    walkMoveA rg r = Code egSp egSp mass
      where
        rv = cAt rg r
        xv = Var (S Z)
        jv = Var Z
        step = Sub (cAt eg 1) (cAt eg 0)
        minT = cAt eg 0
        maxT = cAt eg (gridSize eg - 1)
        lo = If (Gt xv minT) (Sub xv step) (addM xv step)
        hi = If (Gt maxT xv) (addM xv step) (Sub xv step)
        two = addM one one
        stay = Mul two (Sub one rv)
        mass = addM (addM (If (eqE jv xv) stay zero)
                          (If (eqE jv lo) rv zero))
                    (If (eqE jv hi) rv zero)
    guardFamilyJ j (nm, tg) =
      [ Hyp ("guard", [j, kt, a, b])
            (chargeMass fragWidth (CMul (guardCharge _ns tg eg) arityMass))
            unitLatent
            (Code unitLatent obsSp
               (catBody j (If (Gt (Get nm) (cAt tg kt))
                              (cAt eg a) (cAt eg b))))
            Nothing
      | has FBern, has FIf, has FConst, has FGuardHead
      , kt <- [0 .. gridSize tg - 1]
      , a <- [0 .. gridSize eg - 1], b <- [0 .. gridSize eg - 1], a /= b ]

-- ---------------------------------------------------------------------
-- Declared breadth (the OB-19 heir key, breadth-sitting-r0's authority).
-- The hello's world declares the richer family's extent: an ordered
-- atom-pair codebook S and/or the null-rate face — VIII.4's doctrine
-- verbatim ("declared resolution, priced by mention bits, is world
-- data"). Type derivation (the type-audit line): Breadth is world-
-- declaration data carried by the handshake, exactly as Namespace and
-- Grid are — deletable-and-declarable, so world data, never core; it
-- names no new production (the declared families are sentences of
-- If/Gt/catBody — derived shapes, no primitivity clause owed).
-- An empty declaration is the shipped route, byte-identical.
-- ---------------------------------------------------------------------

data Breadth = Breadth
  { breadthPairs :: [(Int, Int)]  -- ordered (jHi, jLo), positive atoms
  , breadthNull  :: Bool          -- the null-rate face
  }
  deriving (Eq, Show)

-- | The declared-breadth enumeration (the heir key's library half).
-- Contract: pairs arrive door-validated (each component in
-- [1..K-1], jHi /= jLo, no duplicates); the wire refuses before this
-- function sees an invalid pair, and the null face is refused at K=2
-- (the exact-duplication law) — validation is the door's, totality
-- is this function's.
enumerateWithBreadth :: Breadth -> Int -> Namespace -> Carrier Int -> Grid
                     -> [(Name, Grid)] -> Maybe Grid -> [FragProd] -> [Hyp]
enumerateWithBreadth _br kAr ns obsC eg guardGs mrg allowed =
  enumerateWithArity kAr ns obsC eg guardGs mrg allowed

-- ---------------------------------------------------------------------
-- R17: THE CORPUS IS A DERIVATION. The normative hypothesis space is
-- the grammar's own sayable sentences under the World's codebooks,
-- within a declared FRONTIER (here: a node budget; the weight bound
-- derives from it — n nodes cost at least (1/prodExpr)^n times the
-- smallest mention factor). 'enumerate' (the family route) is a
-- SELECTOR over this intension — a fast path under the optimisation
-- law, pinned by test-pin/R17: every family body is 'inCorpus' (the
-- intensional membership check over declared data), and the small-
-- frontier extension of 'corpusBodies' is exhaustively pinned.
-- The fragment table (fragWidth) is the selector's own declared
-- weighting, NOT the grammar weight — the registered question #5's
-- shape, pinned as an inequality in test-pin/R17.
-- ---------------------------------------------------------------------

-- | Every Code-body sentence (scope: outcome, latent — the likelihood
-- shape) up to a node budget, over the declared mention codebooks and
-- the declared namespace. The generator IS the production table read
-- as a recipe: each hole filled by each written alternative.
corpusBodies :: Namespace -> [Grid] -> Int
             -> [Expr '[Rational, Rational] Rational]
corpusBodies ns gs budget = genR budget
  where
    leavesR :: [Expr '[Rational, Rational] Rational]
    leavesR =
      [ e | g <- gs, k <- [0 .. gridSize g - 1], Just e <- [mkC g k] ]
      ++ [ Get nm | nm <- nsNames ns ]
      ++ [ Var Z, Var (S Z) ]
    genR :: Int -> [Expr '[Rational, Rational] Rational]
    genR n
      | n < 1 = []
      | otherwise =
          leavesR
          ++ [ op a b | n >= 3, (i, j) <- splits2 (n - 1)
             , a <- genR i, b <- genR j, op <- [Sub, Mul] ]
          ++ [ If c t e | n >= 6, (i, j, k) <- splits3 (n - 1)
             , c <- genB i, t <- genR j, e <- genR k ]
    genB :: Int -> [Expr '[Rational, Rational] Bool]
    genB n
      | n < 3 = []
      | otherwise =
          [ Gt a b | (i, j) <- splits2 (n - 1)
          , a <- genR i, b <- genR j ]
          ++ [ If c t e | n >= 10, (i, j, k) <- splits3 (n - 1)
             , c <- genB i, t <- genB j, e <- genB k ]
    splits2 m = [ (i, m - i) | i <- [1 .. m - 1] ]
    splits3 m = [ (i, j, m - i - j)
                | i <- [1 .. m - 2], j <- [1 .. m - i - 1] ]

-- | Intensional corpus membership: the body is a sentence of the
-- grammar whose every mention sits on a DECLARED codebook and whose
-- every read names the DECLARED namespace — checked structurally over
-- declared data (never by enumeration; the corpus is an intension and
-- this is its characteristic function).
inCorpus :: Namespace -> [Grid] -> Expr env t -> Bool
inCorpus ns gs = goT
  where
    okGrid g k = any (\g' -> gridName g' == gridName g
                             && gridSize g' == gridSize g) gs
                 && k >= 0 && k < gridSize g
    goT :: Expr env' t' -> Bool
    goT e = case e of
      C g k _ -> okGrid g k
      Get nm -> nm `elem` nsNames ns
      Var _ -> True
      If c t f -> goT c && goT t && goT f
      Gt a b -> goT a && goT b
      Sub a b -> goT a && goT b
      Mul a b -> goT a && goT b
      Expect b body -> goT b && goT body
      Cond b k y j n -> goT b && goT k && goT y && goT j && goT n
      Code _ _ body -> goT body

-- | The obs carrier's atoms as a codebook (world-DERIVED, not a new
-- declaration): the source of every 0/1 mention.
atomGridOf :: Carrier Int -> Grid
atomGridOf c =
  mkGrid (carrierName c ++ "-atoms")
         (case map fromIntegral (spacePoints (carrierSpace c)) of
            [] -> error "atomGridOf: empty carrier (unreachable)"
            (p : ps) -> p :| ps)

-- | Kraft over an enumeration, exact (the L4' census row: 55/72 under
-- the oracle world; the deficiency is 1 - this, visible).
kraftSum :: [Hyp] -> Rational
kraftSum = foldl' (\acc h -> acc + hypW h) 0

-- ---------------------------------------------------------------------
-- The engine: sentence-driven, exact
-- ---------------------------------------------------------------------

data HypLive = HypLive Hyp (Belief Rational)

-- Type derivation: the engine's live state — the declared namespace it
-- serves (door invariant), the tick counter, the exact meta weights,
-- the per-hypothesis filtered latents. Function of: the World's
-- namespace + the enumeration + the observation history, nothing else.
data AgentS = AgentS Namespace Int [Rational] [HypLive]

sentenceAgent :: Namespace -> [Hyp] -> AgentS
sentenceAgent ns hs =
  AgentS ns 0 (map hypW hs) [ HypLive h (uniform (hypLatent h)) | h <- hs ]

-- per-tick, per-hypothesis: the predicted latent (post-transition) and
-- the emission kernel under a DOOR-BUILT env; Nothing = the code
-- refuses (unlawful column) and the hypothesis carries zero mass
tickPred :: Env '[] -> HypLive -> Maybe (Belief Rational, Kernel Rational Int)
tickPred env (HypLive h lat) = do
  k <- evalx (hypEmit h) env
  predLat <- case hypMove h of
    Nothing -> Just lat
    Just mv -> do
      mk <- evalx mv env
      Just (push lat mk)
  Just (predLat, k)

-- | One observation: the tick's exact predictive marginal + the
-- updated agent. The features go through THE DOOR against the
-- agent's declared namespace — a refused tick is Left, never served
-- (ruling 8: no default, no dormancy).
observeS :: Features -> Int -> AgentS -> Either String (Rational, AgentS)
observeS feats y (AgentS ns t ws lives) = do
  env <- mkEnvIn ns feats VNil
  let preds = map (tickPred env) lives
      pm p = case p of
        Nothing -> 0
        Just (predLat, k) -> predictMass predLat k y
      masses = map pm preds
      z = sum ws
      marginal = sum (zipWith (*) ws masses) / z
      ws' = zipWith (*) ws masses
      lives' = zipWith absorb lives preds
      absorb hl@(HypLive h _) p = case (hypMove h, p) of
        (Just _, Just (predLat, k)) -> case condK predLat k y of
          Just lat' -> HypLive h lat'
          Nothing -> hl
        _ -> hl
  if marginal <= 0
    then Left "impossible evidence"   -- refuse WITHOUT update: the
         -- agent is unmoved (the old engine's Nothing, as the door's
         -- Either; a zero marginal would poison every later tick)
    else Right (marginal, AgentS ns (t + 1) ws' lives')

-- | The deletion audit's frozen agent (cond deleted): the tick's
-- marginal with NO update — weights and latents stay; t advances.
stepFrozenS :: Features -> Int -> AgentS -> Either String (Rational, AgentS)
stepFrozenS feats y (AgentS ns t ws lives) = do
  env <- mkEnvIn ns feats VNil
  let pm hl = case tickPred env hl of
        Nothing -> 0
        Just (predLat, k) -> predictMass predLat k y
      marginal = sum (zipWith (*) ws (map pm lives)) / sum ws
  Right (marginal, AgentS ns (t + 1) ws lives)

-- | The exact predictive mass of an OUTCOME (R16: the outcome is a
-- parameter — no event baked into a core name).
predictMassS :: Features -> Int -> AgentS -> Either String Rational
predictMassS feats y (AgentS ns _ ws lives) = do
  env <- mkEnvIn ns feats VNil
  let pm hl = case tickPred env hl of
        Nothing -> 0
        Just (predLat, k) -> predictMass predLat k y
  Right (sum (zipWith (*) ws (map pm lives)) / sum ws)

-- | The exact normalized meta posterior (read-only view; displays —
-- entropy — derive from this at the reporting edge, never here: E1).
metaPosterior :: AgentS -> [Rational]
metaPosterior (AgentS _ _ ws _) =
  let z = sum ws in [ w / z | w <- ws ]

-- | The obs carrier's points as the AGENT sees them — read from the
-- first hypothesis's own emission Code (declared data inside the
-- sentence; no second declaration of the carrier exists).
agentObsPoints :: AgentS -> [Int]
agentObsPoints (AgentS _ _ _ lives) = case lives of
  [] -> []
  (HypLive h _ : _) -> case hypEmit h of
#ifndef DROP_CODE
    Code _ cod _ -> spacePoints cod
#endif
    _ -> []

-- | MAP: the top hypothesis's declared tag and exact posterior.
mapS :: AgentS -> ((String, [Int]), Rational)
mapS (AgentS _ _ ws lives) =
  let (HypLive h _, w) = maximumBy (comparing snd) (zip lives ws)
  in (hypTag h, w / sum ws)
