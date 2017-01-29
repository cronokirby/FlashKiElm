module Study.View exposing (..)

import Color exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json

import Material.Icons.Content as Icons
import Material.Icons.Action as Icons

import Study.Models exposing (CardTest(..), Model)
import Study.Update exposing (Msg(..), nextCard)


view : Model -> Html Msg
view model =
    div []
      [ deckInfo model
      , studyView model
      ]


deckInfo : Model -> Html Msg
deckInfo model =
    div []
      [ div [] [ text model.deck.name ]
      , div [] [ text model.deck.language ]
      , div [] [ text <| (toString <| List.length model.deck.cards)
                      ++ " cards"
               ]
      ]


cardCheckMark : CardTest -> Html Msg
cardCheckMark cardTest =
    case cardTest of
        None ->
            div [] []
        Failed ->
            div [ class "failed-icon" ]
              [ Icons.clear red 40 ]
        Passed ->
            div [ class "passed-icon" ]
              [ Icons.done green 40 ]


studyView : Model -> Html Msg
studyView model =
    div []
      [ div [] [ text model.current.front ]
      , div []
          [ input [ onInput Input
              , onEnter CheckCard
              , placeholder "answer"
              , value model.input ]
              [ text model.input ]
          ]
      , cardCheckMark model.cardTest
      ]


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code = case code of
            13 -> Json.succeed msg
            _  -> Json.fail "not ENTER"
    in
        on "keydown" (Json.andThen isEnter keyCode)
