module Study.View exposing (..)

import Color exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json

import Material.Icons.Content as Icons
import Material.Icons.Action as Icons

import Study.Models exposing (CardTest(..), Model, RedoStatus(..))
import Study.Update exposing (Msg(..), nextCard, submitRedo)


view : Model -> Html Msg
view model =
    div [class "study"]
      [ deckInfo model
      , if model.redoing
          then redoView model
          else studyView model
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


passedIcon : Html Msg
passedIcon =
    div [ class "passed-icon" ]
        [ Icons.done green 60 ]

failedIcon : Html Msg
failedIcon =
    div [ class "failed-icon" ]
        [ Icons.clear red 60 ]



studyCheckMark : CardTest -> Html Msg
studyCheckMark cardtest = case cardtest of
    Passed -> passedIcon
    Failed -> failedIcon
    _ -> div [] []


studyView : Model -> Html Msg
studyView model =
    div [class "study-view"]
      [ div [class "study-card-front"] [ text model.current.front ]
      , studyCheckMark model.cardTest
      , div [ class "study-input-div " ]
          [ input [ class <| "study-input " ++ toString model.cardTest
                  , onInput Input
                  , onEnter CheckCard
                  , placeholder "answer"
                  , value model.input ]
              [ text model.input ]
          ]
      ]


redoCheckMark : RedoStatus -> Html Msg
redoCheckMark status = case status of
    Submitted -> passedIcon
    _ -> div [] []

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
      , redoCheckMark model.redoStatus
      ]


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code = case code of
            13 -> Json.succeed msg
            _  -> Json.fail "not ENTER"
    in
        on "keydown" (Json.andThen isEnter keyCode)
