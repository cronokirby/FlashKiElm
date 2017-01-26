module Study.Update exposing (..)

import DeckEdit.Models exposing (Card)

import Study.Models exposing (Model)


type Msg = Input String
         | Advance Card
         | StudyFailed
         | Leave



update : Msg -> Model -> Model
update msg model = case msg of
    Input string ->
        { model | input = string }

    Advance next ->
        let updated = updateFailed model
            current = model.current
            rest = Maybe.withDefault [] <| List.tail model.rest
        in { updated |
                current = next,
                input = "",
                rest = rest }

    StudyFailed ->
        studyFailed <| updateFailed model
    Leave ->
        model

updateFailed : Model -> Model
updateFailed model =
    let current = model.current
        answer = model.input
        incorrect = answer /= current.back
        failed = if incorrect
                    then current :: model.failed
                    else model.failed
    in { model | failed = failed }


studyFailed : Model -> Model
studyFailed model =
    let failedOrder = List.reverse model.failed
        current = Maybe.withDefault (Card "" "")
               <| List.head failedOrder
        rest = Maybe.withDefault []
            <| List.tail failedOrder
    in Model current "" rest [] False


nextCard : Model -> Msg
nextCard model =
    case List.head model.rest of
        Nothing ->
            if model.failed == []
                then Leave
                else StudyFailed
        Just next ->
            Advance next
