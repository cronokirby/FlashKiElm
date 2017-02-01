module Main exposing (..)

import Html exposing (..)
import Json.Encode exposing (Value)

import Models exposing (..)
import Update exposing (update)
import View exposing (view, deckListView, studyView)
import Storage exposing (load)
import OnQuit exposing (..)

main : Program Value Model Msg
main = Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions}


init : Value -> (Model, Cmd Msg)
init json =
    (load json (ModelView deckListView), Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions _ =
    onQuit (\_ -> SaveModel)
