module DeckList.View exposing (..)

import Color exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Svg exposing (Svg)

import Material.Icons.Image as Icons
import Material.Icons.Action as Icons


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
    div [ class "Deck" ]
      [ div [ class "deck-upper" ]
          [ div []
              [ deckButton "deck-edit-button"
                           (Edit deck)
                           (Icons.edit gray 24)
              ]
           , div [ class "deck-name deck-info" ] [ text deck.name ]
           , div [ class "deck-language deck-info" ] [ text deck.language ]
          ]

      , div [ class "deck-lower" ]
          [ deckButton "deck-delete-button"
                (Delete deck)
                (Icons.delete gray 24)
          ]

      ]

deckButton : String -> Msg -> Svg Msg -> Html Msg
deckButton classes msg icon =
    button [ class classes
           , onClick msg ] [ icon ]
