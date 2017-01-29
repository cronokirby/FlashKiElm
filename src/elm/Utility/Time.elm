module Utility.Time exposing (..)

import Time exposing (..)
import Task
import Process


delay : Time -> msg -> Cmd msg
delay time msg =
  Process.sleep time
  |> Task.andThen (always <| Task.succeed msg)
  |> Task.perform identity
