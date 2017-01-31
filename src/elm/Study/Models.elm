module Study.Models exposing (..)

import Json.Encode exposing (..)

import DeckEdit.Models exposing  ( Card, Deck, emptyDeck
                                 , serializeCard, serializeCards, serializeDeck)

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


debug : Model
debug =
    { current = Card "Katze" "Bushido"
    , rest = [Card "Hund" "Dog"]
    , deck = Deck "Vocabulaire allemand" "German" [Card "Katze" "Bushido", Card "Hund" "Dog"]
    , input = ""
    , cardTest = None
    , redoing = True
    , failed = []
    , redoStatus = PartMatch }

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


serialize : Model -> Value
serialize { current
          , rest
          , failed
          , deck
          , input
          , cardTest
          , redoing
          , redoStatus} =
        object
            [ ("current", serializeCard current)
            , ("rest", serializeCards rest)
            , ("failed", serializeCards failed)
            , ("deck", serializeDeck deck)
            , ("input", string input)
            , ("cardTest", string <| toString cardTest)
            , ("redoing", bool redoing)
            , ("redoStatus", string <| toString redoStatus)
            ]
