module DeckList.Models exposing (..)

import DeckEdit.Models exposing (Deck)


type alias Model = { list : List Deck }

init : Model
init = Model [Deck "101" "German" [], Deck "102" "German" []]
