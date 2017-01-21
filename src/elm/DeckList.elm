module DeckList exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


{- Model -}

type alias Deck = { name : String, language : String }

type alias Model = { deckInput : Deck
                   , deckList : List Deck }

init : Model
init = Model (Deck "" "") []


{- Update -}

type Msg = NameInput String
         | LangInput String
         | Add

update : Msg -> Model -> Model
update msg model = case msg of
    NameInput string ->
        let oldDeck = model.deckInput
        in { model | deckInput = { oldDeck | name = string } }
    LangInput string ->
        let oldDeck = model.deckInput
        in { model | deckInput = { oldDeck | language = string } }
    Add ->
        ( { model |
            deckList = model.deckInput :: model.deckList,
            deckInput = Deck "" "" } )


{- View -}

-- The standard view, presenting a list of the current decks
view : Model -> Html Msg
view model =
    div []
      [ input [ placeholder "Deck name"
              , value model.deckInput.name
              , onInput NameInput ] []
      , input [ placeholder "Deck language"
              , value model.deckInput.language
              , onInput LangInput ] []
      , button [ onClick Add ] [ text "add Deck" ]
      , div [] (List.map viewDeck model.deckList)
      ]

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
