module DeckEdit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

{- Model -}

-- Represents a flash card
type alias Card = { front : String, back : String }

-- The first element of previous is the element right before the current card
type alias Model = { previous : List Card
                   , current : Card
                   , rest : List Card }

init : Model
init = Model [] (Card "" "") []


{- Update -}

type Msg = FrontInput String
         | BackInput String
         | Next
         | Previous

update : Msg -> Model -> Model
update msg model = case msg of
    FrontInput string ->
        let oldCard = model.current
        in { model | current = { oldCard | front = string } }
    BackInput string ->
        let oldCard = model.current
        in { model | current = { oldCard | back = string } }
    Next ->
        { model |
            previous = model.current :: model.previous,
            current  = Maybe.withDefault (Card "" "") (List.head model.rest),
            rest     = Maybe.withDefault [] (List.tail model.rest) }
    Previous ->
        { model |
            previous = Maybe.withDefault [] (List.tail model.previous),
            current  = Maybe.withDefault (Card "" "") (List.head model.previous),
            rest     = model.current :: model.rest }

{- View -}

view : Model -> Html Msg
view model =
    div []
    [ button [ disabled (List.isEmpty model.previous)
             , onClick Previous ] [ text "Previous" ]
    , input [ placeholder "Front Side"
            , value model.current.front
            , onInput FrontInput ] []
    , input [ placeholder "Back Side"
            , value model.current.back
            , onInput BackInput ] []
    , button [ onClick Next ] [ text "Next" ]
    ]
