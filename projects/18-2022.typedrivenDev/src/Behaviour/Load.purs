-- https://blog.oyanglul.us/purescript/type-driven-development-with-purescript/

module Typedriven.Behaviour.Load where

import Prelude
import Effect.Aff
import Typedriven.Data.Todo

import Control.Plus (empty)
import Data.Bifunctor (lmap)
import Data.Either (Either)
import Effect.Aff.Compat (EffectFnAff(..), fromEffectFnAff)
import Foreign (MultipleErrors)
import Simple.JSON (class ReadForeign, parseJSON, readJSON)

type Path
  = String

-- we want Todos after all ... getting there
foreign import _get :: Path -> EffectFnAff String
-- lift to Aff: fromEffectFnAff

-- PSC-IDE: C-c C-a
-- PSC-IDE: C-c C-i
load :: Path -> Aff (Array Todo)
load _ = empty

-- PSC-IDE: C-c x
-- Return ReadForeign a on success

{-
How to proceed - metal model:
- _get path -> EffectFnAff String
- a bit convoluted: let's see what else we have in the Compat package
- fromEffectFnAff should list to Aff
- toJson $ fromEffectFnAff -> is type: Aff String -> Aff (Either Error a0)
- can be lifted
- toJson <$> fromEffectFnAff -> is type: String -> Either Error a0
-}


ajaxGet :: forall a. ReadForeign a => Path -> Aff (Either Error a)
ajaxGet path = (lmap adaptError <<< parseJSON) <$> fromEffectFnAff (_get path)
  where
    parseJSON :: String -> Either MultipleErrors a
    parseJSON = readJSON
    adaptError :: MultipleErrors -> Error
    adaptError = error <<< show

-- lift ReadForeign to a: readJSON
