{-
https://thomashoneyman.com/articles/replace-react-components-with-purescript/#1-write-the-react-component-in-idiomatic-purescript
-}
module PS.Components.Counter where

import Prelude

import Data.Interpolate (i)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import React.Basic.DOM (button, div_, p_, text)
import React.Basic.DOM.Events (capture_)
import React.Basic.Hooks (Component, component, useState', (/\))
import React.Basic.Hooks as React

type Props =
  { label :: String
  , onClick :: Int -> Effect Unit
  , counterType :: CounterType
  }

data CounterType = Incrementer | Decrementer

counterTypeToString :: CounterType -> String
counterTypeToString = case _ of
  Incrementer -> "incrementer"
  Decrementer -> "decrementer"

counterTypeFromString :: String -> Maybe CounterType
counterTypeFromString = case _ of
  "incrementer" -> Just Incrementer
  "decrementer" -> Just Decrementer
  _ -> Nothing

mkCounter :: Component Props
mkCounter = component "Counter" \props -> React.do
  counter /\ setCount <- useState' 0

  let
    step n = case props.counterType of
      Incrementer -> n + 1
      Decrementer -> n - 1

  pure $ div_
    [ p_ [ text $ i "You clicked " counter " times" ]
    , button
        { onClick: capture_ do
             let next = step counter
             setCount next
             props.onClick next
        , children: [ text props.label ]
        }
    ]
