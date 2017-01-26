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
      [ div [] [ text model.current.front ]
      , input [ onInput Input
              , onEnter <| nextCard model
              , placeholder "answer"
              , value model.input ]
              [ text model.input ]
      , div [ value <| toString model ] [ text <| toString model ]
      ]


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code = case code of
            13 -> Json.succeed msg
            _  -> Json.fail "not ENTER"
    in
        on "keydown" (Json.andThen isEnter keyCode)
