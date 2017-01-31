module Storage exposing (..)

import Json.Encode exposing (..)

import DeckList.Models as DeckList
import DeckList.Serialize as DeckList
import DeckEdit.Models as DeckEdit
import DeckEdit.Serialize as DeckEdit
import Study.Models as Study
import Study.Serialize as Study

import Models exposing (Model)


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
