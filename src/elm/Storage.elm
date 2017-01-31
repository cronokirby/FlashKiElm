module Storage exposing (..)

import Json.Encode exposing (..)
import Json.Decode as D

import DeckList.Models as DeckList
import DeckList.Serialize as DeckList
import DeckEdit.Models as DeckEdit
import DeckEdit.Serialize as DeckEdit
import Study.Models as Study
import Study.Serialize as Study

import Models exposing (Model, ModelView)


type alias Storage = { deckEdit : DeckEdit.Model
                     , deckList : DeckList.Model
                     , study : Study.Model }


{- This is used to have some kind of thing to load in the rare event of a
   loading error-}
defaultStorage : Storage
defaultStorage = Storage DeckEdit.init DeckList.init  Study.emptyModel


store : Model -> Storage
store {deckEdit, deckList, study} =
    Storage deckEdit deckList study

{-To note that the serialization here is only used for storing the session-}
serialize : Model -> Value
serialize model =
    let {deckEdit, deckList, study} = store model
    in Json.Encode.object
        [ ("deckEdit", DeckEdit.serialize deckEdit)
        , ("deckList", DeckList.serialize deckList)
        , ("study", Study.serialize study)
        ]


decoder : D.Decoder Storage
decoder =
    D.map3 Storage
        (D.field "deckEdit" DeckEdit.decoder)
        (D.field "deckList" DeckList.decoder)
        (D.field "study" Study.decoder)


fromJson : Value -> Result String Storage
fromJson = D.decodeValue decoder

{- This function would need knowledge from Views to provide the last parameter -}
toModel : Value -> Storage -> (ModelView -> Model)
toModel debug {deckEdit, deckList, study} =
    Model deckList deckEdit study False False debug

load : Value -> (ModelView -> Model)
load val = fromJson val
         |> Result.withDefault defaultStorage
         |> toModel val
