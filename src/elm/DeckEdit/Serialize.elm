module DeckEdit.Serialize exposing (..)

import Json.Encode exposing (..)

import DeckEdit.Models exposing (..)


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
