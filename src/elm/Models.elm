module Models exposing (..)

import Html exposing (..)

import DeckEdit.Models as DeckEdit exposing (..)
import DeckEdit.Update as DeckEdit exposing (..)
import DeckList.Models as DeckList exposing (..)
import DeckList.Update as DeckList exposing (..)
import Study.Models as Study exposing (..)
import Study.Update as Study exposing (..)


type alias Model = { deckList : DeckList.Model
                   , deckEdit : DeckEdit.Model
                   , study : Study.Model
                   , currentView : ModelView
                   , editing : Bool
                   , studying : Bool }

type ModelView = ModelView (Model -> Html Msg)

type Msg = DeckList DeckList.Msg
         | DeckEdit DeckEdit.Msg
         | Study Study.Msg
         | ChangeView Bool (Model -> Html Msg)
