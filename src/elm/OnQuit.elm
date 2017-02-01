port module OnQuit exposing (..)

import Json.Encode exposing (Value)

port sendModel : Value -> Cmd msg

port onQuit : (List String -> msg) -> Sub msg
