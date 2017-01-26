module Study.Models exposing (..)

import DeckEdit.Models exposing (Card, Deck)


type alias Model = { current : Card
                   , input : String
                   , rest : List Card
                   , failed : List Card }

emptyModel : Model
emptyModel = Model (Card "" "") "" [] []


fromDeck : Deck -> Model
fromDeck deck =
    let cards = deck.cards
        current = Maybe.withDefault (Card "" "") <| List.head cards
        rest = Maybe.withDefault [] <| List.tail cards
        failed = []
        input = ""
    in Model current input rest failed
