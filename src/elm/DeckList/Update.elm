module DeckList.Update exposing (..)

import DeckEdit.Models as DeckEdit exposing (Deck)

import DeckList.Models exposing (Model)


type Msg = Edit Deck

update : Msg -> Model -> Model
update msg model = model


{- Utility -}

createEdit : Deck -> DeckEdit.Model
createEdit deck =
    let {name, language, cards} = deck
    in  { previous = []
        , current = Maybe.withDefault (DeckEdit.Card "" "") (List.head cards)
        , rest = Maybe.withDefault [] (List.tail cards)
        , saved = deck
        , deckValidation = ""}
