module Study.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


import Study.Models exposing (Model)
import Study.Update exposing (Msg(..))


view : Model -> Html Msg
view model =
    div []
      [ div [] [ text model.current.front ]
      , input [ placeholder "answer" ] [ text model.input ]
      ]
