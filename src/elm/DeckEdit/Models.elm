module DeckEdit.Models exposing (..)

-- Represents a flash card
type alias Card = { front : String, back : String }

type alias Deck = { name : String, language : String, cards: List Card }


-- The first element of previous is the element right before the current card
type alias Model = { previous : List Card
                   , current : Card
                   , rest : List Card
                   , saved : Deck
                   , deckValidation : String }

init : Model
init = Model [] (Card "" "") [] emptyDeck ""

emptyDeck : Deck
emptyDeck = (Deck "" "" [])
