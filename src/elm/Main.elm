module Main exposing (..)

import Html exposing (..)
import Json.Encode exposing (Value)
import DeckList.Models as DeckList
import DeckEdit.Models as DeckEdit
import Study.Models as Study

import Models exposing (..)
import Update exposing (update)
import View exposing (view, deckListView, studyView)

main : Program Value Model Msg
main = Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions}




init : Value -> (Model, Cmd Msg)
init _ =
    let deckList = DeckList.init
        deckEdit = DeckEdit.init
        study = Study.debug
    in (Model deckList deckEdit study (ModelView studyView) False False, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
