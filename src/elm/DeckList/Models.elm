module DeckList.Models exposing (..)

import DeckEdit.Models exposing (Card, Deck)

type alias Model = { list : List Deck }

init : Model
init = Model []
