{-
https://github.com/adkelley/javascript-to-purescript/tree/master/tut03
https://github.com/adkelley/javascript-to-purescript/blob/master/tut03/src/Main.purs
Learning:
 - Fn3 FFI -> autocurry
 - Either CodeBranching
 - Pattern matching
 - ErrorChecks
 - NullCheck List


It is the Left constructor that makes the Either functor more flexible than
Box. With Left we can perform pure functional error handling, instead of
creating a side-effect (e.g., throwing an exception). If a function fails
during the computation then return Left a, where a could be assigned an error
message detailing where and what happened. Finally, prevent mapping over
Left for the remainder of the computation. I hope you will agree that this
is much better than crashing the program or returning a null value with no
reason why.
-}
module Leap.Tut03.Main where

import Prelude
import Data.Either (Either(..), either)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.List (List(..), dropWhile, filter, head, null, (:))
import Data.Maybe (fromJust)
import Data.String (toUpper)
import Effect (Effect)
import Effect.Console (log)
import Partial.Unsafe (unsafePartial)

foreign import sliceImpl :: Fn3 Int Int String String

--- uncurry import
slice :: Int -> Int -> String -> String
slice beg end str = runFn3 sliceImpl beg end str

-- simple type aliases
type ColorName = String

type HexValue = String

type Error = Unit

-- product type
data Color = Color ColorName HexValue

instance showColor :: Show Color where
  show (Color name hex') = "Color(" <> show name <> ", " <> show hex' <> ")"

type Colors = List Color

-- const masterColors = { red: '#ff4444', yellow: '#fff68f', blue: '#4444ff' }
-- (:) infix of cons
masterColors :: Colors
masterColors =
  (Color "red" "#ff4444")
    : (Color "blue" "#44ff44")
    : (Color "yellow" "#fff68f")
    : Nil

--const fromNullable = x =>
--  x != null ? Right(x) : Left(null)
fromList :: forall a. List a -> Either Unit a
fromList xs =
  if (null xs) then
    Left unit -- unit -> null
  else
    Right $ unsafePartial fromJust $ head xs -- Remember: *unsafePartial fromJust*

-- Better: using pattern matching instead
fromList' :: forall a. List a -> Either Unit a
fromList' Nil = Left unit
fromList' xs = Right $ unsafePartial fromJust $ head xs

-- const findColor = name => {
--   return fromNullable((masterColors)[name])
-- }
findColor :: ColorName -> Either Error Color
findColor colorName = fromList' $ dropWhile (\(Color n _) -> n /= colorName) masterColors

-- less performant version
findColor' :: ColorName -> Either Error Color
findColor' colorName = fromList $ filter (\(Color n _) -> n == colorName) masterColors

-- HEX
hex :: Color -> HexValue
hex (Color _ h) = h

result :: ColorName -> String
result name =
  findColor name
    # map hex
    # map (slice 1 0)
    # either (\_ -> "No color") toUpper -- non-native side-effect

-- Bonus: This variation will make your head spin. It really shows the power of
-- mapping and composition. All in one expression!  Thanks to @goodacre.liam on
-- on the FP #purescript forum on Slack for this example
-- <<< -> o
result' :: ColorName -> String
--                                            combined map!!!
result' = either (const "No Color") toUpper <<< map (slice 1 0 <<< hex) <<< findColor

main :: Effect Unit
main = do
  log "Enforce a null check with composable code branching using Either"
  log $ result "blue"
  log $ result "green"
  log $ result' "yellow"
