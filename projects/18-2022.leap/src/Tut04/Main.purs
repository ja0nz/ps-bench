{-
https://github.com/adkelley/javascript-to-purescript/blob/master/tut04P2/src/Main.purs
Learnings:
 - chain readFile NodeFS
-}
module Leap.Tut04.Main where

import Prelude
import Effect (Effect)
import Effect.Console (log, logShow)
import Effect.Exception (Error, error, try)
import Control.Monad.Except (runExcept)
import Data.Either (Either(..), either)
import Foreign (unsafeFromForeign)
import Simple.JSON (parseJSON)
import Data.List.NonEmpty (head)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)

pathToFile :: String
pathToFile = "./sampledata/readfile.json"

main :: Effect Unit
main = do
  log "Use chain for composable error handling with nested Eithers"
  -- logShow is log equivalent - it just brings in the show with it
  -- try returns Effect (Either Error String)
  -- logShow first collapse the Effect wrap and show Right or Left
  (try $ readTextFile UTF8 pathToFile) >>= logShow
  logShow =<< (try $ readTextFile UTF8 pathToFile)

-- Code Example 2
--getPort >>= logShow
