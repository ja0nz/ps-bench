module PS.Components.Counter (jsCounter) where

import Prelude

import Data.Interpolate (i)
import Effect.Unsafe (unsafePerformEffect)
import React.Basic.DOM (button, div_, p_, text)
import React.Basic.DOM.Events (capture_)
import React.Basic.Hooks (Component, JSX, component, useState, (/\))
import React.Basic.Hooks as React

type Props = { label :: String }

{-
For the time being we’ll use unsafePerformEffect to run the effect that
creates our component. We won’t ever use this function in our
PureScript code, but it makes it possible to import this module directly
into JavaScript
-}
jsCounter :: Props -> JSX
jsCounter = unsafePerformEffect mkCounter

mkCounter :: Component Props
mkCounter = component "Counter" \props -> React.do
  counter /\ setCount <- useState 0

  pure $ div_
    [ p_ [ text $ i "You clicked " counter " times" ]
    , button
        { onClick: capture_ $ setCount (_ + 1)
        , children: [ text props.label ]
        }
    ]
