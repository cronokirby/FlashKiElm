module DeckList.Models exposing (..)

import DeckEdit.Models exposing (Card, Deck)


type alias Model = { list : List Deck }

init : Model
init = Model [ Deck "101" "German" [Card "1" "1", Card "2" "2"]
             , Deck "102" "German" []]
