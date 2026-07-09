-- | WireU — the membrane wire's v2 surface (@latent\@1@), HOSTS_D_PACK
-- section 8. A PARALLEL module by necessity, not taste: Wire's v1
-- record types are sealed against additive fields by the frozen
-- govhost suite's record constructions (GovHost.hs:243 constructs
-- 'Wire.WorldDecl' exhaustively under -Werror), so v2 enters through
-- new types and new entry points and the v1 paths stay byte-identical.
--
-- ORACLE PHASE (HOSTS_D_PACK Task 1): this is type surface with
-- runtime stubs — the test-d wire goldens compile against it and run
-- red; the arithmetic lands only after the author's freeze. Like
-- host-governor/Wire.hs, this module is implementation surface
-- (ruling H-7): tracked, never manifest-frozen; gate 5 keeps it
-- honest by failing the frozen oracle if it drifts.
module WireU
  ( ResidualGrid (..)
  , TauDecl (..)
  , GaugeDecl (..)
  , LatentDecl (..)
  , ComparisonDecl (..)
  , MsgU (..)
  , ReplyU (..)
  , parseLatentDecl
  , parseLineU
  , renderReplyU
  ) where

import Wire (Json, TickMsg, WorldDecl)

import PropLang.Membrane (Choice)

-- | One declared residual component's grid (rider 1/R-D8: priced
-- world data over value-space; the invariance constant's site).
data ResidualGrid = ResidualGrid
  { rgName   :: String
  , rgPoints :: [Double]
  }
  deriving (Eq, Show)

-- | The declared owner-response spec (R-D9; grade-III residue): tau
-- points and DECLARED prior weights — marginalised, never updated.
data TauDecl = TauDecl
  { tdPoints  :: [Double]
  , tdWeights :: [Double]
  }
  deriving (Eq, Show)

-- | The declared affine gauge (R-D7 AS AMENDED at the second review,
-- 2026-07-09): affine freedom is two degrees and both are spent
-- before any second anchor could enter — the accounting layer's
-- measured-dollar payload term spends the SCALE ('gdScale' names the
-- measured unit whose slope is declared 1), and status-quo = 0
-- spends the ZERO. The erstwhile second anchor (u(reference-bad) =
-- -1) was either a tautology or a hand-set exchange rate for the
-- very component this boundary makes latent; it is DELETED, and may
-- return only as a redundancy CHECK, never as a fixing declaration.
data GaugeDecl = GaugeDecl
  { gdZero  :: String
  , gdScale :: String
  }
  deriving (Eq, Show)

-- | The @latent\@1@ utility block of a v2 world declaration: the USay
-- payload as an S-expression (parsed against the priced grammar at
-- implementation), the residual grids, the tau spec, the tick-price
-- FEATURE NAME (measured world data — never a declared constant,
-- rider 1's stratification), and the gauge.
data LatentDecl = LatentDecl
  { ldSaid      :: Json
  , ldResiduals :: [ResidualGrid]
  , ldTau       :: TauDecl
  , ldPriceName :: String
  , ldGauge     :: GaugeDecl
  }
  deriving (Eq, Show)

-- | A comparison (lottery) affordance's payload (HOSTS_D_PACK
-- section 4): two acts over measured outcomes, one at a declared
-- probability; its COST is measured units through the accounting
-- layer — never theta_ask (the stratification rule, checked by the
-- gRouting pins).
newtype ComparisonDecl = ComparisonDecl
  { cdLottery :: Json
  }
  deriving (Eq, Show)

-- | A v2 line: the handshake (v1 world declaration + the latent
-- block), a stream-tagged tick (report | verdict | outcome |
-- comparison — Nothing = untagged, the v1 reading), a batched
-- evidence array (@observe_batch@ — H's 39k-tick cost finding; a
-- wire addition, not an alphabet change), or a count-collapsed warm
-- row (@observe_counts@ — the second review's budget ruling:
-- stream tag, context features, and the (n1, n0) outcome counts.
-- Semantics are per-hypothesis likelihood exponentiation — EXACT for
-- exchangeable (iid-emission) families, and for state-carrying ones
-- (hmm / UWalk) it IS the declared warm-flattening approximation,
-- printed rather than smuggled. O(contexts x grid), not O(ticks):
-- batching removes round-trips, counts remove the ticks).
data MsgU
  = MUHello WorldDecl LatentDecl
  | MUTick (Maybe String) TickMsg
  | MUBatch [(Maybe String, TickMsg)]
  | MUCounts (Maybe String) [(String, Double)] Int Int
  deriving (Eq, Show)

-- | A v2 decision reply: choice, p1, entropy — plus the latent
-- readouts: the pointer marginal's mean ('latentMarginal' through the
-- wire) and the decision's sensitivity across the residual's support.
-- OBSERVABILITY-ONLY (consumer discipline, HOSTS_D_PACK section 8): no
-- adapter may branch on the last two fields; routing to elicitation
-- happens engine-side, by argmax over the declared menu.
data ReplyU
  = RUChoice Choice Double Double Double Bool
  | RUObserved Int Double
  | RUError String
  deriving (Eq, Show)

-- | Parse a @latent\@1@ utility block. Oracle-phase stub.
parseLatentDecl :: Json -> Either String LatentDecl
parseLatentDecl _ = Left "unimplemented (oracle phase, HOSTS_D_PACK Task 1)"

-- | Parse one v2 request line. Oracle-phase stub.
parseLineU :: String -> Either String MsgU
parseLineU _ = Left "unimplemented (oracle phase, HOSTS_D_PACK Task 1)"

-- | Render one v2 reply line. Oracle-phase stub.
renderReplyU :: ReplyU -> String
renderReplyU _ = error "renderReplyU: unimplemented (oracle phase, HOSTS_D_PACK Task 1)"
