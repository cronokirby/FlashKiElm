module Study.Update exposing (..)

import Time exposing (..)
import Process
import Task

import DeckEdit.Models exposing (Card)

import Study.Models exposing (Model)

delay : Time -> msg -> Cmd msg
delay time msg =
  Process.sleep time
  |> Task.andThen (always <| Task.succeed msg)
  |> Task.perform identity

type Msg = Input String
         | Wait Msg
         | Advance Card Model  -- These 2 get passed a deck with failures updated
         | StudyFailed Model
         | Leave



update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    Input string ->
        ({ model | input = string }, Cmd.none)
    Wait msg ->
        model
        ! [ delay Time.second <| msg ]
    Advance next updated ->
        let current = model.current
            rest = Maybe.withDefault [] <| List.tail model.rest
        in ({ updated |
                current = next,
                input = "",
                rest = rest }, Cmd.none)

    StudyFailed updated ->
        (studyFailed updated, Cmd.none)
    Leave ->
        (model, Cmd.none)


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
    in {model |
            current = current,
            rest = rest,
            failed = [],
            input = ""}


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
