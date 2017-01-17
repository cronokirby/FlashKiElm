module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import List exposing (..)


main : Program Never Model Msg
main = Html.program { init = init
                    , view = view
                    , update = update
                    , subscriptions = subscriptions}


{- Model -}


type alias Deck = { name : String, language : String }

type alias Model = { deckInput : Deck, deckList : List Deck }

init : (Model, Cmd Msg)
init = (Model (Deck "" "") [], Cmd.none)


{- Update -}

type Msg = NameInput String
         | LangInput String
         | Add

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    NameInput string ->
        let oldDeck = model.deckInput
        in ( { model | deckInput = { oldDeck | name = string } }
           , Cmd.none)
    LangInput string ->
        let oldDeck = model.deckInput
        in ( { model | deckInput = { oldDeck | language = string } }
           , Cmd.none)

    Add ->
        ( { model |
            deckList = model.deckInput :: model.deckList,
            deckInput = Deck "" "" }
        , Cmd.none )

{- View -}

view : Model -> Html Msg
view model =
    div []
      [ input [ placeholder "Deck name"
              , onInput NameInput ] []
      , input [ placeholder "Deck language"
              , onInput LangInput ] []
      , button [ onClick Add ] [ text "add Deck" ]
      , div [] (List.map viewDeck model.deckList)
      ]

viewDeck : Deck -> Html Msg
viewDeck {name, language} =
    text (name ++ language)

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
