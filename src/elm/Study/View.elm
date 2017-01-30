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
    div [class "study"]
      [ deckInfo model
      , case model.cardTest of
          Redoing -> redoView model
          _ -> studyView model
      --, text <| toString model
      ]


deckInfo : Model -> Html Msg
deckInfo model =
    div [class "study-deckinfo"]
      [ div [class "study-cardcount"]
          [ text <| (toString <| List.length model.deck.cards)
                 ++ " cards"
          ]
      , div [class "study-deckname"] [ text model.deck.name ]
      , div [class "study-decklang"] [ text model.deck.language ]

      ]


cardCheckMark : CardTest -> Html Msg
cardCheckMark cardTest =
    case cardTest of
        Failed ->
            div [ class "failed-icon" ]
              [ Icons.clear red 60 ]
        Passed ->
            div [ class "passed-icon" ]
              [ Icons.done green 60 ]
        _ -> div [] []


studyView : Model -> Html Msg
studyView model =
    div [class "study-view"]
      [ div [class "study-card-front"] [ text model.current.front ]
      , cardCheckMark model.cardTest
      , div [ class "study-input-div " ]
          [ input [ class <| "study-input " ++ toString model.cardTest
                  , onInput Input
                  , onEnter CheckCard
                  , placeholder "answer"
                  , value model.input ]
              [ text model.input ]
          ]
      ]


redoView : Model -> Html Msg
redoView model =
    div [class "redo-view"]
      [ div [class "redo-cardfront"] [ text model.current.front ]
      , div [class "redo-cardback"] [ text model.current.back  ]
      , div [ class "redo-input-div"]
        [ input [ class <| "redo-input " ++ toString model.redoStatus
                  , onInput Input
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
