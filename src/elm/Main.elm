module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)

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
                   , currentView : ModelView }

type ModelView = ModelView (Model -> Html Msg)

init : (Model, Cmd Msg)
init =
    let deckList = DeckList.init
        deckEdit = DeckEdit.init
    in (Model deckList deckEdit (ModelView deckListView), Cmd.none)


{- Update -}

type Msg = DeckList DeckList.Msg
         | DeckEdit DeckEdit.Msg
         | ChangeView (Model -> Html Msg)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    DeckList msg ->
        let deckList = DeckList.update msg model.deckList
        in ( { model | deckList = deckList }, Cmd.none )
    DeckEdit msg ->
        let deckEdit = DeckEdit.update msg model.deckEdit
        in ( { model | deckEdit = deckEdit }, Cmd.none )
    ChangeView newView ->
        ( { model | currentView = ModelView newView }, Cmd.none )


{- View -}

helloView : Model -> Html Msg
helloView _ = text "hello world"

deckListView : Model -> Html Msg
deckListView model = Html.map DeckList (DeckList.view model.deckList)

deckEditView : Model -> Html Msg
deckEditView model = Html.map DeckEdit (DeckEdit.view model.deckEdit)

-- Chosen to be able to switch views with a button
view : Model -> Html Msg
view model = case model.currentView of
    ModelView currentView ->
      div []
        [ button [ onClick (ChangeView helloView) ]
                 [ text "Hello View" ]
        , button [ onClick (ChangeView deckListView) ]
                 [ text "Deck View" ]
        , button [ onClick (ChangeView deckEditView) ]
                 [ text "Edit View" ]
        , (currentView model) ]


{- Subscriptions -}
subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
