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

type alias Model = { deckInput : Deck
                   , deckList : List Deck
                   , currentView : ModelView }

type ModelView = ModelView (Model -> Html Msg)

init : (Model, Cmd Msg)
init = (Model (Deck "" "") [] (ModelView deckListView), Cmd.none)


{- Update -}

type Msg = NameInput String
         | LangInput String
         | Add
         | ChangeView (Model -> Html Msg)


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

    ChangeView newView ->
        ( { model | currentView = ModelView newView }, Cmd.none )

{- View -}

-- The standard view, presenting a list of the current decks
deckListView : Model -> Html Msg
deckListView model =
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


helloView : Model -> Html Msg
helloView _ = text "hello world"

-- Chosen to be able to switch views with a button
view : Model -> Html Msg
view model = case model.currentView of
    ModelView currentView ->
      div []
        [ button [ onClick (ChangeView helloView) ] [ text "Hello View" ]
        , button [ onClick (ChangeView deckListView) ] [ text "Deck View" ]
        , currentView model ]


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
