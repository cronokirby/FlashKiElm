module Study.Update exposing (..)

import Time exposing (..)
import Process
import Task

import DeckEdit.Models exposing (Card)

import Study.Models exposing (CardTest(..), Model)

delay : Time -> msg -> Cmd msg
delay time msg =
  Process.sleep time
  |> Task.andThen (always <| Task.succeed msg)
  |> Task.perform identity

type Msg = Input String
         | Wait Msg     -- Used to delay messages
         | CheckCard    -- Updates the failures, and chooses a delayed message
         | Redo
         | Advance Card
         | StudyFailed
         | Leave        -- This gets caught in the main update, exiting this view


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    Wait msg ->
        model
        ! [ delay (Time.second * 0.5) <| msg ]

    Input string ->
        ({ model | input = string }, Cmd.none)

    {- CheckCard will get triggered by the input, and has the responsibility of
       updating the model in regards to failed answers -}
    CheckCard ->
        let updated = updateFailed model
        in ( updated
           , Task.perform (Wait << nextCard) <| Task.succeed updated )

    Redo ->
        ({ model | cardTest = Redoing }, Cmd.none)

    Advance next ->
        let rest = Maybe.withDefault [] <| List.tail model.rest
        in ({ model |
                current = next,
                input = "",
                cardTest = None,
                rest = rest }, Cmd.none)

    StudyFailed ->
        (studyFailed model, Cmd.none)

    Leave ->
        (model, Cmd.none)


{- Compares the answer with the back of the card, appends the card to the failed
   stack if necessary, and changes CardTest, which is used to check this status -}
updateFailed : Model -> Model
updateFailed model =
    let current = model.current
        answer = model.input
        incorrect = answer /= current.back
        (failed, cardTest) =
            if incorrect
                then (current :: model.failed, Failed)
                else (model.failed, Passed)
    in { model |
            cardTest = cardTest,
            failed = failed }


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
            input = "",
            cardTest = None}


nextCard : Model -> Msg
nextCard model =
    case List.head model.rest of
        Nothing ->
            if model.failed == []
                then Leave
                else StudyFailed
        Just next ->
            if model.cardTest == Passed
                then Advance next
                else Redo
