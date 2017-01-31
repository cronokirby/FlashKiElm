module DeckList.Serialize exposing (..)

import Json.Encode as Json
import Json.Decode exposing (..)

import DeckEdit.Serialize exposing (serializeDeck, decoderDeck)
import DeckList.Models exposing (..)


serialize : Model -> Json.Value
serialize {list} =
    Json.object [("list", Json.list <| List.map serializeDeck list)]


decoder : Decoder Model
decoder = map Model (field "list" <| list decoderDeck)
