module Study.Update exposing (..)

import Time exposing (..)
import Task

import DeckEdit.Models exposing (Card)

import Study.Models exposing (CardTest(..), Model, RedoStatus(..))
import Utility.Time exposing(delay)


type Msg = Input String
         | Delay Model Msg -- Used to delay messages but carry a partially updated model
         | Wait Msg     -- Used to delay messages
         | CheckCard    -- Updates the failures, and chooses a delayed message
         | Redo
         | UpdateRedo
         | Advance Card
         | StudyFailed
         | Leave        -- This gets caught in the main update, exiting this view


delayMsg : Model -> Msg -> (Model, Cmd Msg)
delayMsg model msg =
    model ! [ delay (Time.second * 0.5)  <| msg ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    Wait msg ->
        delayMsg model msg
    Delay newModel msg ->
        delayMsg newModel msg
    Input string ->
        let cmd = if model.redoing
            then
                Task.perform (\_ -> UpdateRedo) <| Task.succeed 0
            else
                Cmd.none
        in ({ model | input = string }, cmd)

    UpdateRedo ->
        let redoStatus = isMatching model
        in ({model | redoStatus = redoStatus }, Cmd.none)
    {- CheckCard will get triggered by the input, and has the responsibility of
       updating the model in regards to failed answers -}
    CheckCard ->
        let updated = updateFailed model
        in ( updated
           , Task.perform (Wait << nextCard) <| Task.succeed updated )

    Redo ->
        ({ model | input = ""
                 , cardTest = None
                 , redoing = True
                 , redoStatus = PartMatch }, Cmd.none)

    Advance next ->
        let rest = Maybe.withDefault [] <| List.tail model.rest
        in ({ model |
                current = next,
                input = "",
                cardTest = None,
                redoing = False,
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
            cardTest = None,
            redoing = False }


nextCard : Model -> Msg
nextCard model = case model.cardTest of
    Failed ->
        Redo
    _ ->
    case List.head model.rest of
        Nothing ->
            if model.failed == []
                then Leave
                else StudyFailed
        Just next ->
            Advance next


isMatching : Model -> RedoStatus
isMatching model =
    let answer = model.input
        cardBack = model.current.back
        answerLength = String.length answer
        mustMatch = cardBack |> String.left answerLength
        conditions = ( answer == mustMatch
                     , answerLength == String.length cardBack)
    in case conditions of
        (False, _)    -> Failing
        (True, False) -> PartMatch
        (True, True)  -> FullMatch


submitRedo : Model -> Msg
submitRedo model = case model.redoStatus of
    FullMatch ->
        let updated = { model | redoStatus = Submitted }
        in Delay updated <| nextCard model
    _ -> UpdateRedo
