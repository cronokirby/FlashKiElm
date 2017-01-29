module Study.Models exposing (..)

import DeckEdit.Models exposing (Card, Deck, emptyDeck)


type alias Model = { current : Card
                   , rest : List Card
                   , failed : List Card
                   , deck : Deck
                   , input : String }

emptyModel : Model
emptyModel = Model (Card "" "") [] [] emptyDeck ""


fromDeck : Deck -> Model
fromDeck deck =
    let cards = deck.cards
    in  { current = Maybe.withDefault (Card "" "") <| List.head cards
        , rest = Maybe.withDefault [] <| List.tail cards
        , failed = []
        , deck = deck
        , input = ""
        }
