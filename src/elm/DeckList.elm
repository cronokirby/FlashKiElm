module DeckList exposing (Model, Msg, init, update, view)

import Html exposing (..)

import DeckEdit exposing (Deck)

{- Model -}

type alias Model = { list : List Deck }

init : Model
init = Model []

{- Update -}

type Msg = Noth

update : Msg -> Model -> Model
update msg model = model

{- View -}

-- The standard view, presenting a list of the current decks
view : Model -> Html Msg
view model =
    div []
      [ div [] (List.map viewDeck model.list) ]

viewDeck : Deck -> Html Msg
viewDeck {name, language} =
    div []
      [ table []
        [ thead []
          [ tr []
            [ th [] [ text "Name" ]
            , th [] [ text "Language" ]
            ]
          ]
        , tbody [] (List.map (\n -> td [] [span [] [text n]]) [name, language])
        ]
      ]
