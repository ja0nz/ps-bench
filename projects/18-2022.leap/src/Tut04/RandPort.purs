-- https://github.com/adkelley/javascript-to-purescript/blob/master/tut04P1/src/Main.purs
-- Learnings: throw/catch rowtypes
module Leap.Tut04.RandPort where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Effect.Exception (catchException, error, message, throwException)
import Effect.Random (randomInt)

-- record type
type PortRange = { min :: Int, max :: Int }

validPorts :: PortRange
validPorts = { min: 2500, max: 7500 }

-- range predicate
isInvalidPort :: Int -> Boolean
isInvalidPort portNumber = portNumber < validPorts.min || portNumber > validPorts.max

-- when -> Runs an applicative on true, in this cas a Effect String
-- uncaught exception
throwWhenBadPort :: Int -> Effect Unit
throwWhenBadPort portNumber = when (isInvalidPort portNumber) $ throwException errorMessage
  where
  errorMessage =
    error $ "Error: expected a port number between "
      <> show validPorts.min
      <> " and "
      <> show validPorts.max

-- throw/catch block; native side effect
-- throwWhenBadPort produces Effect Unit
-- catException does consume it alongside an Error -> Effect msg
catchWhenBadPort :: Int -> Effect Unit
catchWhenBadPort portNumber = catchException printException $ throwWhenBadPort portNumber
  where
  printException e = log $ message e

main :: Effect Unit
main = do
  log "Use chain for composable error handling with nested Eithers - Part 1"
  portNumber <- randomInt (validPorts.min - 2500) (validPorts.max + 2500)
  log $ "Our random port number is: " <> show portNumber
  catchWhenBadPort portNumber

-- this will natively fail on run
-- throwWhenBadPort portNumber
