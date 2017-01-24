module DeckEdit exposing (..)

import Color exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Svg as Svg exposing (..)

import Material.Icons.Content as Icons exposing (add_box, save)
import Material.Icons.Image as Icons exposing (navigate_next, navigate_before)


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
                   , saved : Deck
                   , deckValidation : String }

init : Model
init = Model [] (Card "" "") [] emptyDeck ""


{- Update -}

type Msg = NameInput String
         | LangInput String
         | FrontInput String
         | BackInput String
         | Next
         | Previous
         | Save
         | Invalid String


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
        let oldDeck = model.saved
            cards = makeCards model
        in { model |
               previous = model.current :: model.previous,
               current  = Maybe.withDefault (Card "" "") (List.head model.rest),
               rest     = Maybe.withDefault [] (List.tail model.rest),
               saved    = { oldDeck | cards = cards } }
    Previous ->
        let oldDeck = model.saved
            cards = makeCards model
        in { model |
               previous = Maybe.withDefault [] (List.tail model.previous),
               current  = Maybe.withDefault (Card "" "") (List.head model.previous),
               rest     = model.current :: model.rest,
               saved    = { oldDeck | cards = cards } }
    Save ->
        let oldDeck = model.saved
            cards = makeCards model
        in { model | saved = { oldDeck | cards = cards } }
    Invalid error ->
        { model | deckValidation = error }


makeCards : Model -> List Card
makeCards model = List.reverse model.previous
                ++ (model.current :: model.rest)


validateDeck : Deck -> Msg
validateDeck deck =
    let conditions = Result.map3 (\a b c -> Ok(True))
                     (validateInput deck.name)
                     (validateInput deck.language)
                     (Result.fromMaybe "This deck has no cards"
                                    <| List.head deck.cards)
    in case conditions of
        Ok(_) -> Save
        Err(error) -> Invalid error

validateInput : String -> Result String Bool
validateInput string =
    if string == ""
      then Err("A deck needs both a name and a language")
      else Ok(True)

{- View -}

view : Model -> Html Msg
view model =
    let cardFront = model.current.front
        cardBack  = model.current.back
    in  div [class "deckEdit-view" ]
        [ div [ class "deck-inputs"]
            [ input [ class "deck-input"
                    , placeholder "Name"
                    , value model.saved.name
                    , onInput NameInput ] []
            , input [ class "deck-input"
                    , placeholder "Language"
                    , value model.saved.language
                    , onInput LangInput ] []
            , button [ class "deck-save-button"
                     , onClick (validateDeck model.saved) ]
                     [ Icons.save black 40 ]
            ]



        , cardView model
        , div [] [ Html.text (model.deckValidation)]
        ]


cardView : Model -> Html Msg
cardView model =
    let cardFront = model.current.front
        cardBack  = model.current.back
    in  div [ class "card-view" ]
          [ button [ class "card-nav-button card-previous"
                   , disabled (List.isEmpty model.previous)
                   , onClick Previous ] [ Icons.navigate_before black 40]
          , input [ class "card-input card-front"
                  , placeholder "Front Side"
                  , value cardFront
                  , onInput FrontInput ] []
          , input [ class "card-input card-back"
                  , placeholder "Back Side"
                  , value cardBack
                  , onInput BackInput ] []
          , button [ class "card-nav-button card-next"
                   , disabled (String.isEmpty cardFront ||
                               String.isEmpty cardBack)
                   , onClick Next ] [ nextIcon model.rest ]
         ]


nextIcon : List Card -> Svg msg
nextIcon rest =
    let icon = case rest of
        [] -> Icons.add_box
        _  -> Icons.navigate_next
    in icon black 40
