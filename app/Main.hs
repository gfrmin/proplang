-- proplang-host: the returning driver (the host-less window's exit,
-- step 7). The entire program is PropLang.Host.hostMain — the
-- stdin/stdout line loop over the pure wire-session core (gate 3:
-- IO lives in Host.hs; this file is the executable's front door and
-- adds nothing).
module Main (main) where

import PropLang.Host (hostMain)

main :: IO ()
main = hostMain
