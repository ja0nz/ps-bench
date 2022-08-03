{-
https://thomashoneyman.com/articles/replace-react-components-with-purescript/#2-write-an-interop-module-for-the-component

These modules:
- Provide a mapping between PureScript types used in the component and a simple JavaScript representation
- Add a layer of safety by marking all inputs that could reasonably be null or undefined with the Nullable type, which helps our code handle missing values gracefully
- Translate functions in their curried form into usual JavaScript functions, and translates effectful functions (represented as thunks in generated code) into functions that run immediately when called
- Serve as a canary for changes in PureScript code that will affect dependent JavaScript code so that you can be extra careful
-}
module PS.Components.Counter.Interop (jsCounter) where

import Prelude

import Data.Maybe (fromMaybe)
import Data.Nullable (Nullable, toMaybe)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Effect.Unsafe (unsafePerformEffect)
import PS.Components.Counter (CounterType(..), Props, counterTypeFromString, mkCounter)
import React.Basic.Hooks (JSX)

-- define Interface to the component
-- Nullable with fallback
type JSProps =
  { label :: Nullable String
  , onClick :: Nullable (EffectFn1 Int Unit)
  , counterType :: Nullable String
  }

-- Interop layer
jsPropsToProps :: JSProps -> Props
jsPropsToProps props =
  { label: fromMaybe "Click away!" $ toMaybe props.label
  , onClick: fromMaybe mempty $ map runEffectFn1 $ toMaybe props.onClick
  , counterType: fromMaybe Incrementer $ counterTypeFromString =<< toMaybe props.counterType}

{-
For the time being we’ll use unsafePerformEffect to run the effect that
creates our component. We won’t ever use this function in our
PureScript code, but it makes it possible to import this module directly
into JavaScript
-}
jsCounter :: JSProps -> JSX
jsCounter = unsafePerformEffect mkCounter <<< jsPropsToProps
