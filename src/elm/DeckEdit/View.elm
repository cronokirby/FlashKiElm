module DeckEdit.View exposing (..)

import Color exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Svg as Svg exposing (..)

import Material.Icons.Content as Icons
import Material.Icons.Image as Icons

import DeckEdit.Models exposing (Card, Model)
import DeckEdit.Update exposing (Msg(..), validateDeck)


view : Model -> Html Msg
view model =
    let cardFront = model.current.front
        cardBack  = model.current.back
    in  div [class "deckEdit-view" ]
        [ div [ class "deck-inputs"]
            [ input [ class "deck-input"
                    , placeholder "Name"
                    , value model.saved.name
                    , onInput NameInput ] []
            , input [ class "deck-input"
                    , placeholder "Language"
                    , value model.saved.language
                    , onInput LangInput ] []
            , button [ class "deck-save-button"
                     , onClick (validateDeck model.saved) ]
                     [ Icons.save black 40 ]
            ]



        , cardView model
        , div [] [ Html.text (model.deckValidation)]
        ]


cardView : Model -> Html Msg
cardView model =
    let cardFront = model.current.front
        cardBack  = model.current.back
    in  div [ class "card-view" ]
          [ button [ class "card-nav-button card-previous"
                   , disabled (List.isEmpty model.previous)
                   , onClick Previous ] [ Icons.navigate_before black 40]
          , input [ class "card-input card-front"
                  , placeholder "Front Side"
                  , value cardFront
                  , onInput FrontInput ] []
          , input [ class "card-input card-back"
                  , placeholder "Back Side"
                  , value cardBack
                  , onInput BackInput ] []
          , button [ class "card-nav-button card-next"
                   , disabled (String.isEmpty cardFront ||
                               String.isEmpty cardBack)
                   , onClick Next ] [ nextIcon model.rest ]
         ]


nextIcon : List Card -> Svg msg
nextIcon rest =
    let icon = case rest of
        [] -> Icons.add_box
        _  -> Icons.navigate_next
    in icon black 40
