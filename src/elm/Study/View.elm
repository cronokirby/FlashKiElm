module Study.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json

import Study.Models exposing (Model)
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


studyView : Model -> Html Msg
studyView model =
    div []
      [ div [] [ text model.current.front ]
      , div []
          [ input [ onInput Input
              , onEnter <| Wait <| nextCard model
              , placeholder "answer"
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
