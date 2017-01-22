module DeckList exposing (Model
                         , Msg(Edit)
                         , createEdit
                         , init
                         , update
                         , view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import DeckEdit exposing (Deck)

{- Model -}

type alias Model = { list : List Deck }

init : Model
init = Model [Deck "101" "German" [], Deck "101" "German" []]


{- Update -}

type Msg = Edit Deck

update : Msg -> Model -> Model
update msg model = model

createEdit : Deck -> DeckEdit.Model
createEdit deck =
    let {name, language, cards} = deck

    in  { previous = []
        , current = Maybe.withDefault (DeckEdit.Card "" "") (List.head cards)
        , rest = Maybe.withDefault [] (List.tail cards)
        , saved = deck
        , deckValidation = ""}

{- View -}

-- The standard view, presenting a list of the current decks
view : Model -> Html Msg
view model =
    div [class "deck-list"]
      [ div [] (List.map viewDeck model.list) ]

viewDeck : Deck -> Html Msg
viewDeck deck =
    div []
      [ table [ class "Deck" ]
        [ thead []
          [ tr []
            [ th [] [ text "Name" ]
            , th [] [ text "Language" ]
            ]
          ]
        , tbody []
          (  List.map (\n -> td [] [span [] [text n]]) [deck.name, deck.language]
          ++ [ td [] [ button [ onClick <| Edit deck ] [ text "Edit" ] ] ]
          )
        ]
      ]
