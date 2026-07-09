-- | Increment D's restricted-enumeration fixture for DROP_UWALK
-- (HOSTS_D_PACK section 9): the drift sort is CONTENT — delete it and
-- drift is unsayable (the VoI floor collapses to the frozen decay,
-- gHeadline's paired claim). This fixture names the constructor at
-- two sites (a value and a match arm) so the flag's error attributes
-- to UWalk itself.
module UseUWalk where

import PropLang.Enumerate (UFamily (..))

walkIsContent :: UFamily
walkIsContent = UWalk

describe :: UFamily -> String
describe u = case u of
  UConst -> "the pointer is a grid constant"
  UWalk  -> "the pointer drifts at a sayable rate"
