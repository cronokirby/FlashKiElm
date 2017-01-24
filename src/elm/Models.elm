module Models exposing (..)

import Html exposing (..)

import DeckEdit.Models as DeckEdit exposing (..)
import DeckEdit.Update as DeckEdit exposing (..)
import DeckList.Models as DeckList exposing (..)
import DeckList.Update as DeckList exposing (..)


type alias Model = { deckList : DeckList.Model
                   , deckEdit : DeckEdit.Model
                   , currentView : ModelView
                   , editing : Bool }

type ModelView = ModelView (Model -> Html Msg)

type Msg = DeckList DeckList.Msg
         | DeckEdit DeckEdit.Msg
         | ChangeView Bool (Model -> Html Msg)
