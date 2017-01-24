module DeckList.Update exposing (..)

import DeckEdit.Models as DeckEdit exposing (Deck)

import DeckList.Models exposing (Model)


type Msg = Edit Deck
         | Delete Deck

update : Msg -> Model -> Model
update msg model = case msg of
    Delete deck ->
        let deleted = remove deck model.list
        in { model | list = deleted }
    _ -> model


{- Utility -}

createEdit : Deck -> DeckEdit.Model
createEdit deck =
    let {name, language, cards} = deck
    in  { previous = []
        , current = Maybe.withDefault (DeckEdit.Card "" "") (List.head cards)
        , rest = Maybe.withDefault [] (List.tail cards)
        , saved = deck
        , deckValidation = ""}


remove : Deck -> List Deck -> List Deck
remove deck =
    List.filter (\{name, language} ->
                    deck.name /= name
                 || deck.language /= language )
