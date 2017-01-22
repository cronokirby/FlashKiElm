module DeckEdit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

{- Model -}

-- Represents a flash card
type alias Card = { front : String, back : String }

type alias Deck = { name : String, language : String, cards: List Card }

emptyDeck : Deck
emptyDeck = (Deck "" "" [])

-- The first element of previous is the element right before the current card
type alias Model = { previous : List Card
                   , current : Card
                   , rest : List Card
                   , saved : Deck}

init : Model
init = Model [] (Card "" "") [] emptyDeck 


{- Update -}

type Msg = NameInput String
         | LangInput String
         | FrontInput String
         | BackInput String
         | Next
         | Previous
         | Save


update : Msg -> Model -> Model
update msg model = case msg of
    NameInput string ->
        let oldDeck = model.saved
        in { model | saved = { oldDeck | name = string } }
    LangInput string ->
        let oldDeck = model.saved
        in { model | saved = { oldDeck | language = string } }
    FrontInput string ->
        let oldCard = model.current
        in { model | current = { oldCard | front = string } }
    BackInput string ->
        let oldCard = model.current
        in { model | current = { oldCard | back = string } }
    Next ->
        { model |
            previous = model.current :: model.previous,
            current  = Maybe.withDefault (Card "" "") (List.head model.rest),
            rest     = Maybe.withDefault [] (List.tail model.rest) }
    Previous ->
        { model |
            previous = Maybe.withDefault [] (List.tail model.previous),
            current  = Maybe.withDefault (Card "" "") (List.head model.previous),
            rest     = model.current :: model.rest }
    Save ->
        let oldDeck = model.saved
            cards = List.reverse model.previous
                 ++ (model.current :: model.rest)
        in { model | saved = { oldDeck | cards = cards } }


{- View -}

view : Model -> Html Msg
view model =
    div []
    [ input [ placeholder "Name"
            , value model.saved.name
            , onInput NameInput ] []
    , input [ placeholder "Language"
            , value model.saved.language
            , onInput LangInput ] []
    , button [ disabled (List.isEmpty model.previous)
             , onClick Previous ] [ text "Previous" ]
    , input [ placeholder "Front Side"
            , value model.current.front
            , onInput FrontInput ] []
    , input [ placeholder "Back Side"
            , value model.current.back
            , onInput BackInput ] []
    , button [ onClick Next ] [ text "Next" ]
    , button [ onClick Save ] [ text "Save" ]
    ]
