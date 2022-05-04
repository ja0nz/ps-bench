-- https://github.com/adkelley/javascript-to-purescript/tree/master/tut02
-- https://github.com/adkelley/javascript-to-purescript/blob/master/tut02/src/Main.purs
-- Learning: FFI Composition Refactoring
module Leap.Tut02.Main where

import Prelude
import Control.Comonad (extract)
import Data.Box (Box(..))
import Data.String (Pattern(..), Replacement(..), replace)
import Effect (Effect)
import Effect.Console (log, logShow)

-- We use an unsafe prefix for parseFloat, because JS parseFloat
-- may return NaN.  We deal with this case by returning 0.0 (see Main.js)
foreign import unsafeParseFloat :: String -> Number

moneyToFloat :: String -> Box Number
moneyToFloat s =
  Box s
    # map (replace (Pattern "$") (Replacement ""))
    # map (unsafeParseFloat)

percentToFloat :: String -> Box Number
percentToFloat s =
  Box s
    # map (replace (Pattern "%") (Replacement ""))
    # map (unsafeParseFloat)
    # map ((*) 0.01)

-- Antipattern: The super ugly nested closure applyDiscount
applyDiscount :: String -> String -> Number
applyDiscount price discount =
  -- 1. unpack box
  (extract $ moneyToFloat price)
    -- 2. pass float
    #
      ( \cost ->
          -- 3. unpack box
          (extract $ percentToFloat discount)
            --- mangle
            # (\savings -> cost - cost * savings)
      )

-- the nicer monadic bind version
-- these bind operations (>>=) are perhaps the more canonical approach
-- for solving applyDiscount. We'll cover them in a later tutorial
applyDiscount' :: String -> String -> Number
applyDiscount' price discount =
  extract
    $ (moneyToFloat price) -- 1. Box

        >>=
          ( \cost -> -- bind "cost"

              (percentToFloat discount) -- 2. Box

                >>= (\savings -> pure $ cost - cost * savings) -- closure cost bound savings
          )

main :: Effect Unit
main = do
  log "Refactor imperative code to a single composed expression using Box"
  log "Using extract to remove x from the Box before applying the final expression"
  logShow $ applyDiscount "$5.00" "20%"
  log "Oh god - Monad bind operations already!  Only if you want them"
  logShow $ applyDiscount' "$5.00" "20%"
