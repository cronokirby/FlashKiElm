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
    div []
      [ table [ class "Deck" ]
        [ thead []
          [ tr []
            [ th [] [ text "Name" ]
            , td [] [ text "Language" ]
            , td [ class "deck-delete" ]
                 [ deckButton "deck-delete-button"
                              (Delete deck)
                              (Icons.delete gray 24)
                 ]
            ]
          ]
        , tbody []
          (  List.map (\n -> td [] [span [] [text n]]) [deck.name, deck.language]
          ++ [ td [] [ deckButton "deck-edit-button"
                                  (Edit deck)
                                  (Icons.edit gray 24)
                     ]
             ]
          )
        ]
      ]


deckButton : String -> Msg -> Svg Msg -> Html Msg
deckButton classes msg icon =
    button [ class classes
           , onClick msg ] [ icon ]
