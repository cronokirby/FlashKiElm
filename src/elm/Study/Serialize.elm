module Study.Serialize exposing (..)

import Json.Encode exposing (..)
import Json.Decode as D exposing (field)

import DeckEdit.Serialize exposing (serializeCard, serializeCards, serializeDeck
                                   , decoderCard, decoderDeck)
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


decoderCardTest : String -> D.Decoder CardTest
decoderCardTest json =
    case json of
        "Failed" -> D.succeed Failed
        "Passed" -> D.succeed Passed
        _ -> D.succeed None

decoderRedoStatus : String -> D.Decoder RedoStatus
decoderRedoStatus json =
    case json of
        "FullMatch" -> D.succeed FullMatch
        "Failing" -> D.succeed Failing
        "Submitted" -> D.succeed Submitted
        _ -> D.succeed PartMatch

decoder : D.Decoder Model
decoder =
    D.map8 Model
        (field "current" decoderCard)
        (field "rest" <| D.list decoderCard)
        (field "failed" <| D.list decoderCard)
        (field "deck" decoderDeck)
        (field "input" D.string)
        (field "cardTest" <| D.andThen decoderCardTest D.string )
        (field "redoing" D.bool)
        (field "redoStatus" <| D.andThen decoderRedoStatus D.string )
