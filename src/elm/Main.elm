module Main exposing (..)

import Color exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Material.Icons.Content exposing (add_box)

import DeckList as DeckList exposing (..)
import DeckEdit as DeckEdit exposing (..)


main : Program Never Model Msg
main = Html.program { init = init
                    , view = view
                    , update = update
                    , subscriptions = subscriptions}


{- Model -}

type alias Model = { deckList : DeckList.Model
                   , deckEdit : DeckEdit.Model
                   , currentView : ModelView
                   , editing : Bool }

type ModelView = ModelView (Model -> Html Msg)

init : (Model, Cmd Msg)
init =
    let deckList = DeckList.init
        deckEdit = DeckEdit.init
    in (Model deckList deckEdit (ModelView deckListView) False, Cmd.none)


{- Update -}

type Msg = DeckList DeckList.Msg
         | DeckEdit DeckEdit.Msg
         | ChangeView Bool (Model -> Html Msg)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of

    DeckList msg -> case msg of
        Edit deck ->
            let deckEdit = DeckList.createEdit deck
                deckList = DeckList.Model
                        <| List.filter (\d -> d /= deck)
                           model.deckList.list
            in ( { model |
                    deckList = deckList,
                    deckEdit = deckEdit,
                    currentView = ModelView deckEditView,
                    editing = True }, Cmd.none )

    DeckEdit msg -> case msg of
        Save ->
            let deckEdit = DeckEdit.init
                deckList = DeckList.Model
                           (model.deckEdit.saved :: model.deckList.list)
            in ( { model |
                    deckEdit = deckEdit,
                    deckList = deckList,
                    currentView = ModelView deckListView,
                    editing = False }, Cmd.none )
        _ ->
            let deckEdit = DeckEdit.update msg model.deckEdit
            in ( { model | deckEdit = deckEdit }, Cmd.none )

    ChangeView editing newView ->
        ( { model | currentView = ModelView newView
                  , editing = editing }, Cmd.none )


{- View -}

deckListView : Model -> Html Msg
deckListView model = Html.map DeckList (DeckList.view model.deckList)

deckEditView : Model -> Html Msg
deckEditView model = Html.map DeckEdit (DeckEdit.view model.deckEdit)

-- Chosen to be able to switch views with a button
view : Model -> Html Msg
view model =
    case model.currentView of
    ModelView currentView ->
      div []
        [ div [ hidden model.editing
              , class "nav-buttons"]
            [ button [ class "nav-button"
                     , onClick (ChangeView False deckListView) ]
                     [ text "Deck View" ]
             , button [ class "nav-button"
                      , onClick (ChangeView True deckEditView) ]
                     [ add_box black 50 ]
            ]
        , (currentView model) ]


{- Subscriptions -}
subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
