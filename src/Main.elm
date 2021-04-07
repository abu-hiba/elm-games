module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, classList)
import Random
import Random.List exposing (shuffle)

type CardValue
  = Ace
  | Two
  | Three
  | Four
  | Five
  | Six
  | Seven
  | Eight
  | Nine
  | Ten
  | Jack
  | Queen
  | King

type Suit
  = Spades
  | Hearts
  | Diamonds
  | Clubs

type alias Card =
  { value : CardValue
  , suit : Suit
  , face : String
  }

type alias SelectedCards = (Maybe Card, Maybe Card)

deck : List Card
deck = 
  [ { value = Ace, suit = Spades, face = "🂡" }
  , { value = Two, suit = Spades, face = "🂢" }
  , { value = Three, suit = Spades, face = "🂣" }
  , { value = Four, suit = Spades, face = "🂣" }
  , { value = Five, suit = Spades, face = "🂥" }
  , { value = Six, suit = Spades, face = "🂦" }
  , { value = Seven, suit = Spades, face = "🂧" }
  , { value = Eight, suit = Spades, face = "🂨" }
  , { value = Nine, suit = Spades, face = "🂩" }
  , { value = Ten, suit = Spades, face = "🂪" }
  , { value = Jack, suit = Spades, face = "🂫" }
  , { value = Queen, suit = Spades, face = "🂭" }
  , { value = King, suit = Spades, face = "🂮" }
  , { value = Ace, suit = Hearts, face = "🂱" }
  , { value = Two, suit = Hearts, face = "🂲" }
  , { value = Three, suit = Hearts, face = "🂳" }
  , { value = Four, suit = Hearts, face = "🂴" }
  , { value = Five, suit = Hearts, face = "🂵" }
  , { value = Six, suit = Hearts, face = "🂶" }
  , { value = Seven, suit = Hearts, face = "🂷" }
  , { value = Eight, suit = Hearts, face = "🂸" }
  , { value = Nine, suit = Hearts, face = "🂹" }
  , { value = Ten, suit = Hearts, face = "🂺" }
  , { value = Jack, suit = Hearts, face = "🂻" }
  , { value = Queen, suit = Hearts, face = "🂽" }
  , { value = King, suit = Hearts, face = "🂾" }
  , { value = Ace, suit = Clubs, face = "🃁" }
  , { value = Two, suit = Clubs, face = "🃂" }
  , { value = Three, suit = Clubs, face = "🃃" }
  , { value = Four, suit = Clubs, face = "🃄" }
  , { value = Five, suit = Clubs, face = "🃅" }
  , { value = Six, suit = Clubs, face = "🃆" }
  , { value = Seven, suit = Clubs, face = "🃇" }
  , { value = Eight, suit = Clubs, face = "🃈" }
  , { value = Nine, suit = Clubs, face = "🃉" }
  , { value = Ten, suit = Clubs, face = "🃊" }
  , { value = Jack, suit = Clubs, face = "🃋" }
  , { value = Queen, suit = Clubs, face = "🃍" }
  , { value = King, suit = Clubs, face = "🃎" }
  , { value = Ace, suit = Diamonds, face = "🃑" }
  , { value = Two, suit = Diamonds, face = "🃒" }
  , { value = Three, suit = Diamonds, face = "🃓" }
  , { value = Four, suit = Diamonds, face = "🃔" }
  , { value = Five, suit = Diamonds, face = "🃕" }
  , { value = Six, suit = Diamonds, face = "🃖" }
  , { value = Seven, suit = Diamonds, face = "🃗" }
  , { value = Eight, suit = Diamonds, face = "🃘" }
  , { value = Nine, suit = Diamonds, face = "🃙" }
  , { value = Ten, suit = Diamonds, face = "🃚" }
  , { value = Jack, suit = Diamonds, face = "🃛" }
  , { value = Queen, suit = Diamonds, face = "🃝" }
  , { value = King, suit = Diamonds, face = "🃞" }
  ]

-- MODEL
type alias Model =
  { cards : List Card
  , selectedCards : SelectedCards
  , matchedCards : List Card
  }
  
model : Model
model =
  { cards = deck
  , selectedCards = (Nothing, Nothing)
  , matchedCards = []
  }


-- UPDATE
type Msg
  = Shuffle
  | ShuffledList (List Card)
  | SelectCard Card

update : Msg -> Model -> (Model, Cmd Msg)
update msg currModel =
  case msg of
    Shuffle ->
      (currModel, Random.generate ShuffledList (shuffle model.cards))

    ShuffledList shuffledList ->
      ({ currModel | cards = shuffledList }, Cmd.none)

    SelectCard selectedCard ->
      case currModel.selectedCards of
        (Nothing, Nothing) -> ({ currModel | selectedCards = (Just selectedCard, Nothing) }, Cmd.none)
        (Just _, Just _) -> ({ currModel | selectedCards = (Just selectedCard, Nothing)}, Cmd.none)
        (Just c, Nothing) -> (
          { currModel
          | selectedCards = if (isMatched selectedCard currModel.matchedCards) then (Just c, Nothing) else (Just c, Just selectedCard)
          , matchedCards = if (isPair c selectedCard) then c :: selectedCard :: currModel.matchedCards else currModel.matchedCards
          }
          , Cmd.none)
          -- TODO: Possibly handle differently as should never occur
        (Nothing, Just c) -> ({ currModel | selectedCards = (Just selectedCard, Just c) }, Cmd.none) 

isPair : Card -> Card -> Bool
isPair c1 c2 =
  if c1.value == c2.value then
    case c1.suit of
      Spades -> (c2.suit == Spades || c2.suit == Clubs)
      Clubs -> (c2.suit == Spades || c2.suit == Clubs)
      Hearts -> (c2.suit == Hearts || c2.suit == Diamonds)
      Diamonds -> (c2.suit == Hearts || c2.suit == Diamonds)
  else
    False


-- VIEW
view : Model -> Html Msg
view m =
  div []
    [ div [ class "cards" ] (List.map (viewCard m) m.cards)
    , div [] [ button [ onClick Shuffle ] [ text "Shuffle" ] ]
    ]

viewCard : Model -> Card -> Html Msg
viewCard m c =
  div [ classList [
          ("card", True),
          ("red", (c.suit == Hearts || c.suit == Diamonds) && ((isSelected c m.selectedCards) || (isMatched c m.matchedCards))),
          ("back", not (isSelected c m.selectedCards))
        ],
        onClick (SelectCard c)
      ] [ text (if (isSelected c m.selectedCards) || (isMatched c m.matchedCards) then c.face else "🂠") ]

isSelected : Card -> SelectedCards -> Bool
isSelected c currentSelected =
  case currentSelected of
    (Nothing, Just sc) -> if sc == c then True else False
    (Just sc, Nothing) -> if sc == c then True else False
    (Just sc1, Just sc2) -> if (sc1 == c) || (sc2 == c) then True else False
    (Nothing, Nothing) -> False

isMatched : Card -> List Card -> Bool
isMatched c matches =
  List.member c matches


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> (model, Cmd.none)
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
