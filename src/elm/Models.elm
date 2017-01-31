module Models exposing (..)

import Html exposing (..)
import Json.Encode exposing (..)

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


type alias Storage = { deckList : DeckList.Model
                     , deckEdit : DeckEdit.Model
                     , study : Study.Model }


store : Model -> Storage
store {deckList, deckEdit, study} =
    Storage deckList deckEdit study


{-To note that the serialization here is only used for storing the session-}
serialize : Model -> Value
serialize model =
    let {deckList, deckEdit, study} = store model
    in Json.Encode.object
        [ ("deckList", DeckList.serialize deckList)
        , ("deckEdit", DeckEdit.serialize deckEdit)
        , ("study", Study.serialize study)
        ]
