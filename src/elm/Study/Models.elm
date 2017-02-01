module Study.Models exposing (..)

import DeckEdit.Models exposing  ( Card, Deck, emptyDeck)

type RedoStatus = PartMatch
                | FullMatch
                | Failing
                | Submitted

type CardTest = None
              | Failed
              | Passed

type alias Model = { current : Card
                   , rest : List Card
                   , failed : List Card
                   , deck : Deck
                   , input : String
                   , cardTest : CardTest
                   , redoing : Bool
                   , redoStatus : RedoStatus}

-- Fills out all the fields that don't depend on a deck
default : Card -> List Card -> Deck -> Model
default current rest deck =
    Model current rest [] deck "" None False PartMatch


emptyModel : Model
emptyModel = default (Card "" "") [] emptyDeck


fromDeck : Deck -> Model
fromDeck deck =
    let cards = deck.cards
        current = Maybe.withDefault (Card "" "") <| List.head cards
        rest = Maybe.withDefault [] <| List.tail cards
    in  default current rest deck
