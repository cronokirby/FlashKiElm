module Study.View exposing (..)

import Color exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json

import Material.Icons.Content as Icons
import Material.Icons.Action as Icons

import Study.Models exposing (CardTest(..), Model)
import Study.Update exposing (Msg(..), nextCard, submitRedo)


view : Model -> Html Msg
view model =
    div []
      [ deckInfo model
      , case model.cardTest of
          Redoing -> redoView model
          _ -> studyView model
      --, text <| toString model
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
        Failed ->
            div [ class "failed-icon" ]
              [ Icons.clear red 40 ]
        Passed ->
            div [ class "passed-icon" ]
              [ Icons.done green 40 ]
        _ -> div [] []


studyView : Model -> Html Msg
studyView model =
    div []
      [ div [] [ text model.current.front ]
      , div []
          [ input [ onInput Input
              , onEnter CheckCard
              , placeholder "answer"
              , value model.input
              , class <| toString model.redoStatus ]
              [ text model.input ]
          ]
      , cardCheckMark model.cardTest
      ]


redoView : Model -> Html Msg
redoView model =
    div []
      [ div [] [ text model.current.front ]
      , div [] [ text model.current.back  ]
      , div [ class <| toString model.redoStatus ]
          [ input [ onInput Input
                  , onEnter <| submitRedo model
                  , value model.input ]
                  [ text model.input ]
          ]
      ]


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code = case code of
            13 -> Json.succeed msg
            _  -> Json.fail "not ENTER"
    in
        on "keydown" (Json.andThen isEnter keyCode)
