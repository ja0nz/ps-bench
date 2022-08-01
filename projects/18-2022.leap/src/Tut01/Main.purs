{-
https://github.com/adkelley/javascript-to-purescript/blob/master/tut01/src/Main.purs
Learning:
 - Spin up a newtype, enhance it with categories
 - It should be obvious that, in order to give life to our box, we need
   to extend it it functionality.
-}
module Leap.Tut01.Main where

import Prelude
import Control.Comonad (class Extend, class Comonad, extract)
import Data.Char (fromCharCode)
import Data.Int (fromString)
import Data.Maybe (fromMaybe)
import Data.String (toLower, trim)
import Data.String.CodeUnits (singleton)
import Effect (Effect)
import Effect.Console (log)

-- Start: new type box
newtype Box a = Box a

-- 1. enhance Box with map
instance functorBox :: Functor Box where
  map f (Box x) = Box $ f x

-- 2. enhance Box with show
-- with parametric constraint => Show a
-- <> -> string concat
instance showBox :: Show a => Show (Box a) where
  show (Box x) = "Box(" <> show x <> ")"

-- 3.1. enhance Box with extend (in prep to extract)
instance extendBox :: Extend Box where
  extend f m = Box (f m)

-- 3.2. enhance Box with extract
instance comonadBox :: Comonad Box where
  extract (Box x) = x

-- 4. and just for fun make it comparable
instance setoidBox :: Eq a => Eq (Box a) where
  eq (Box x) (Box y) = x == y

-- point free version (less repetition) using forward composition
-- Composition using oridinary functions.  This is simple, to read, write
-- use and reason about than bundled parenthesis.  See the ReadMe in Tutorial 2
-- for more information on this topic
nextCharForNumberString' :: String -> String
nextCharForNumberString' =
  trim
    >>> fromString
    >>> fromMaybe 0
    >>> (+) 1
    >>> fromCharCode
    >>> fromMaybe ' '
    >>> singleton

-- But when mixing categories (i.e., Box, Maybe), we'll often use
-- composition by putting s into a box and mapping over it
-- (#) Applies an argument to a function: the reverse of ($).
nextCharForNumberString :: String -> String
nextCharForNumberString str =
  Box str
    # map trim
    # map (\s -> fromString s)
    # map (\s -> fromMaybe 0 s)
    # map (\i -> i + 1)
    # map (\i -> fromCharCode i)
    # map (\mi -> fromMaybe ' ' mi)
    # map (\c -> toLower $ singleton c)
    # extract

main :: Effect Unit
main = do
  log "Create Linear Data Flow with Container Style Types (Box)."
  log "Composition using oridinary functions"
  log $ nextCharForNumberString' "     64   "
  log "Let's borrow a trick from our friend array by putting string into a Box."
  log $ nextCharForNumberString "     64   "
  log "Setoid Box shows equality"
  log $ show $ eq (Box 4) (Box 4)
