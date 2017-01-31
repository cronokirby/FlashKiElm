module DeckList.Models exposing (..)

import Json.Decode exposing (..)
import Json.Encode as Json


import DeckEdit.Models exposing (Card, Deck, serializeDeck)


type alias Model = { list : List Deck }

init : Model
init = Model [ Deck "101" "German" [Card "1" "1", Card "2" "2"]
             , Deck "102" "German" []]


serialize : Model -> Json.Value
serialize {list} =
    Json.object [("list", Json.list <| List.map serializeDeck list)]
