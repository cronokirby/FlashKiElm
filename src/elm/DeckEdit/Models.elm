module DeckEdit.Models exposing (..)

import Json.Encode exposing (..)

-- Represents a flash card
type alias Card = { front : String, back : String }

type alias Deck = { name : String, language : String, cards: List Card }


-- The first element of previous is the element right before the current card
type alias Model = { previous : List Card
                   , current : Card
                   , rest : List Card
                   , saved : Deck
                   , deckValidation : String }

init : Model
init = Model [] (Card "" "") [] emptyDeck ""

emptyDeck : Deck
emptyDeck = (Deck "" "" [])


{- Serialization -}

serializeCard : Card -> Value
serializeCard {front, back} =
    object
        [ ("front", string front)
        , ("back", string front)
        ]

serializeCards : List Card -> Value
serializeCards = list << List.map serializeCard

serializeDeck : Deck -> Value
serializeDeck {name, language, cards} =
    object
        [ ("name", string name)
        , ("language", string language)
        , ("cards", serializeCards cards)
        ]

serialize : Model -> Value
serialize { previous
          , current
          , rest
          , saved
          , deckValidation} =
    object
        [ ("previous", serializeCards previous)
        , ("current", serializeCard current)
        , ("rest", serializeCards rest)
        , ("saved", serializeDeck saved)
        , ("deckValidation", string deckValidation)
        ]
