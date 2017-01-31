module DeckList.Serialize exposing (..)

import Json.Encode as Json

import DeckEdit.Serialize exposing (serializeDeck)
import DeckList.Models exposing (..)


serialize : Model -> Json.Value
serialize {list} =
    Json.object [("list", Json.list <| List.map serializeDeck list)]
