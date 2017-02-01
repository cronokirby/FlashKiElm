module DeckEdit.Serialize exposing (..)

import Json.Encode exposing (..)
import Json.Decode as D

import DeckEdit.Models exposing (..)


serializeCard : Card -> Value
serializeCard {front, back} =
    object
        [ ("front", string front)
        , ("back", string back)
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

{- Decoding -}

decoderCard : D.Decoder Card
decoderCard = D.map2 Card (D.field "front" D.string) (D.field "back" D.string)

decoderDeck : D.Decoder Deck
decoderDeck =
    D.map3 Deck
        (D.field "name" D.string)
        (D.field "language" D.string)
        (D.field "cards" <| D.list decoderCard)

decoder : D.Decoder Model
decoder =
    D.map5 Model
        (D.field "previous" <| D.list decoderCard)
        (D.field "current" decoderCard)
        (D.field "rest" <| D.list decoderCard)
        (D.field "saved" decoderDeck)
        (D.field "deckValidation" D.string)
