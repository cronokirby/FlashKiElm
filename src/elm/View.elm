module View exposing (..)

import Color exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material.Icons.Av as Icons
import Material.Icons.Action as Icons

import DeckList.View as DeckList
import DeckEdit.View as DeckEdit
import Study.View as Study

import Models exposing (..)
import Storage exposing (..)


-- Chosen to be able to switch views with a button
view : Model -> Html Msg
view model =
    case model.currentView of
    ModelView currentView ->
      div []
        [ div [ class "nav-buttons" ]
            [ button [ hidden <| model.editing
                              || not model.studying
                     , class "nav-button"
                     , onClick (ChangeView False studyView) ]
                     [ Icons.book black 40 ]
            , button [ hidden model.editing
                     , class "nav-button"
                     , onClick (ChangeView False deckListView) ]
                     [ Icons.list black 40 ]
            , button [ hidden model.editing
                     , class "nav-button"
                     , onClick (ChangeView True deckEditView) ]
                     [ Icons.library_add black 40 ]
            ]
        , (currentView model)
        , text <| toString <| fromJson model.deb
        ]


deckListView : Model -> Html Msg
deckListView model = Html.map DeckList (DeckList.view model.deckList)

deckEditView : Model -> Html Msg
deckEditView model = Html.map DeckEdit (DeckEdit.view model.deckEdit)

studyView : Model -> Html Msg
studyView model = Html.map Study (Study.view model.study)
