module Study.Update exposing (..)

import DeckEdit.Models exposing (Card)

import Study.Models exposing (Model)


type Msg = Input String
         | Advance Card Model  -- These 2 get passed a deck with failures updated
         | StudyFailed Model
         | Leave



update : Msg -> Model -> Model
update msg model = case msg of
    Input string ->
        { model | input = string }

    Advance next updated ->
        let current = model.current
            rest = Maybe.withDefault [] <| List.tail model.rest
        in { updated |
                current = next,
                input = "",
                rest = rest }

    StudyFailed updated ->
        studyFailed updated
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
    in Model current "" rest []


{- Failed cards need to be updated before checking if no failed cards are left;
   this prevents the last card from "Leaving" if it's the only failed one -}
nextCard : Model -> Msg
nextCard model =
    let updated = updateFailed model
    in case List.head model.rest of
          Nothing ->
              if updated.failed == []
                  then Leave
                  else StudyFailed updated
          Just next ->
              Advance next updated
