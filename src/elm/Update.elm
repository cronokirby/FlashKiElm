module Update exposing (..)

import DeckList.Models as DeckList
import DeckList.Update as DeckList
import DeckEdit.Models as DeckEdit
import DeckEdit.Update as DeckEdit
import Study.Models as Study
import Study.Update as Study

import Models exposing (..)
import View exposing (..)
import Storage exposing (serialize)
import OnQuit exposing (..)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of

    DeckList msg -> case msg of

        DeckList.Edit deck ->
            let deckEdit = DeckList.createEdit deck
                deckList = DeckList.Model
                        <| DeckList.remove deck model.deckList.list
            in ( { model |
                    deckList = deckList,
                    deckEdit = deckEdit,
                    currentView = ModelView deckEditView,
                    editing = True }, Cmd.none )

        DeckList.Study deck ->
            let study = Study.fromDeck deck
            in ( { model |
                    study = study,
                    currentView = ModelView studyView,
                    studying = True }, Cmd.none )
        _ ->
            let deckList = DeckList.update msg model.deckList
            in ( { model | deckList = deckList }, Cmd.none )


    DeckEdit msg -> case msg of
        DeckEdit.Save ->
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

    Study msg -> case msg of
        Study.Leave ->
            let study = Study.emptyModel
            in ( { model |
                    study = study,
                    currentView = ModelView deckListView,
                    studying = False }, Cmd.none )
        _ ->
            let (study, cmd) = Study.update msg model.study
            in ( { model | study = study }, Cmd.map Study cmd )

    ChangeView editing newView ->
        ( { model | currentView = ModelView newView
                  , editing = editing }, Cmd.none )

    SaveModel ->
        (model, sendModel <| serialize model)
