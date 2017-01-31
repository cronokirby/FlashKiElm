module Study.Serialize exposing (..)

import Json.Encode exposing (..)

import DeckEdit.Serialize exposing (serializeCard, serializeCards, serializeDeck)
import Study.Models exposing (..)


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
