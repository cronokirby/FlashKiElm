module DeckEdit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

{- Model -}

-- Represents a flash card
type alias Card = { front : String, back : String }

type alias Model = { current : Card, rest : List Card }

init : Model
init = Model (Card "" "") []


{- Update -}

type Msg = FrontInput String
         | BackInput String

update : Msg -> Model -> Model
update msg model = case msg of
    FrontInput string ->
        let oldCard = model.current
        in { model | current = { oldCard | front = string } }
    BackInput string ->
        let oldCard = model.current
        in { model | current = { oldCard | front = string } }


{- View -}

view : Model -> Html Msg
view model =
    div []
    [ input [ placeholder "Front Side"
            , value model.current.front
            , onInput FrontInput ] []
    , input [ placeholder "Back Side"
            , value model.current.back
            , onInput BackInput ] []
    ]
