module DeckList.View exposing (..)

import Color exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material.Icons.Image as Icons exposing (edit)

import DeckEdit.Models exposing (Deck)

import DeckList.Models exposing (Model)
import DeckList.Update exposing (Msg(..))


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
          ++ [ td [] [ button [ class "deck-edit-button"
                              , onClick <| Edit deck ] [ Icons.edit gray 24 ] ] ]
          )
        ]
      ]
