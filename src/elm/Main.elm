module Main exposing (..)

import Html exposing (..)

import DeckList.Models as DeckList
import DeckEdit.Models as DeckEdit
import Study.Models as Study

import Models exposing (..)
import Update exposing (update)
import View exposing (view, deckListView)

main : Program Never Model Msg
main = Html.program { init = init
                    , view = view
                    , update = update
                    , subscriptions = subscriptions}


init : (Model, Cmd Msg)
init =
    let deckList = DeckList.init
        deckEdit = DeckEdit.init
        study = Study.emptyModel
    in (Model deckList deckEdit study (ModelView deckListView) False, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
