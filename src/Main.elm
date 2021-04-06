module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, class, classList)
import Random exposing (generate)
import Random.List exposing (shuffle)
import Debug exposing (toString)


-- MODEL
type alias Model =
  { cards : List Card
  , selectedCards : (Maybe Card, Maybe Card)
  , matchedCards : List Card
  }
  
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
  }

deck : List Card
deck = 
  [ { value = Ace, suit = Spades }
  , { value = Two, suit = Spades }
  , { value = Three, suit = Spades }
  , { value = Four, suit = Spades }
  , { value = Five, suit = Spades }
  , { value = Six, suit = Spades }
  , { value = Seven, suit = Spades }
  , { value = Eight, suit = Spades }
  , { value = Nine, suit = Spades }
  , { value = Ten, suit = Spades }
  , { value = Jack, suit = Spades }
  , { value = Queen, suit = Spades }
  , { value = King, suit = Spades }
  , { value = Ace, suit = Hearts }
  , { value = Two, suit = Hearts }
  , { value = Three, suit = Hearts }
  , { value = Four, suit = Hearts }
  , { value = Five, suit = Hearts }
  , { value = Six, suit = Hearts }
  , { value = Seven, suit = Hearts }
  , { value = Eight, suit = Hearts }
  , { value = Nine, suit = Hearts }
  , { value = Ten, suit = Hearts }
  , { value = Jack, suit = Hearts }
  , { value = Queen, suit = Hearts }
  , { value = King, suit = Hearts }
  , { value = Ace, suit = Clubs }
  , { value = Two, suit = Clubs }
  , { value = Three, suit = Clubs }
  , { value = Four, suit = Clubs }
  , { value = Five, suit = Clubs }
  , { value = Six, suit = Clubs }
  , { value = Seven, suit = Clubs }
  , { value = Eight, suit = Clubs }
  , { value = Nine, suit = Clubs }
  , { value = Ten, suit = Clubs }
  , { value = Jack, suit = Clubs }
  , { value = Queen, suit = Clubs }
  , { value = King, suit = Clubs }
  , { value = Ace, suit = Diamonds }
  , { value = Two, suit = Diamonds }
  , { value = Three, suit = Diamonds }
  , { value = Four, suit = Diamonds }
  , { value = Five, suit = Diamonds }
  , { value = Six, suit = Diamonds }
  , { value = Seven, suit = Diamonds }
  , { value = Eight, suit = Diamonds }
  , { value = Nine, suit = Diamonds }
  , { value = Ten, suit = Diamonds }
  , { value = Jack, suit = Diamonds }
  , { value = Queen, suit = Diamonds }
  , { value = King, suit = Diamonds }
  ]

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

update : Msg -> Model -> ( Model, Cmd Msg )
update msg currModel =
  case msg of
    Shuffle ->
      ( currModel, generate ShuffledList (shuffle model.cards) )

    ShuffledList shuffledList ->
      ( { currModel | cards = shuffledList }, Cmd.none )

    SelectCard selectedCard ->
      case currModel.selectedCards of
        (Nothing, Nothing) -> ( { currModel | selectedCards = (Just selectedCard, Nothing) }, Cmd.none )
        (Just c1, Just c2) -> (
          { currModel
          | selectedCards = (Just selectedCard, Nothing)
          }
          , Cmd.none)
        (Just c, Nothing) -> (
          { currModel
          | selectedCards = if (isMatched selectedCard currModel.matchedCards) then (Just c, Nothing) else (Just c, Just selectedCard)
          , matchedCards = if (isPair c selectedCard) then c :: selectedCard :: currModel.matchedCards else currModel.matchedCards
          }
          , Cmd.none)
          -- TODO: Possibly handle differently as should never occur
        (Nothing, Just c) -> ( { currModel | selectedCards = (Just selectedCard, Just c) }, Cmd.none ) 

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
    [ div [ class "cards" ] ( List.map (viewCard m) m.cards )
    , div [] [ button [ onClick Shuffle ] [ text "Shuffle" ] ]
    ]

viewCard : Model -> Card -> Html Msg
viewCard m c =
  div [ classList [
          ("card", True),
          ("red", (c.suit == Hearts || c.suit == Diamonds) && ((isSelected m c) || (isMatched c m.matchedCards))),
          ("back", not (isSelected m c))
        ],
        onClick (SelectCard c)
      ] [ text (if (isSelected m c) || (isMatched c m.matchedCards) then card c else "🂠") ]

card : Card -> String
card c =
  case c.suit of
    Spades ->
      case c.value of
        Ace -> "🂡"
        Two -> "🂢"
        Three -> "🂣"
        Four -> "🂤" 
        Five -> "🂥"
        Six -> "🂦"
        Seven -> "🂧" 
        Eight -> "🂨"
        Nine -> "🂩"
        Ten -> "🂪"
        Jack -> "🂫"
        Queen -> "🂭"
        King -> "🂮"
    Hearts ->
      case c.value of
        Ace -> "🂱"
        Two -> "🂲"
        Three -> "🂳"
        Four -> "🂴"
        Five -> "🂵"
        Six -> "🂶"
        Seven -> "🂷"
        Eight -> "🂸"
        Nine -> "🂹"
        Ten -> "🂺"
        Jack -> "🂻"
        Queen -> "🂽"
        King -> "🂾"
    Diamonds ->
      case c.value of
        Ace -> "🃁"
        Two -> "🃂"
        Three -> "🃃"
        Four -> "🃄"
        Five -> "🃅"
        Six -> "🃆"
        Seven -> "🃇"
        Eight -> "🃈"
        Nine -> "🃉"
        Ten -> "🃊"
        Jack -> "🃋"
        Queen -> "🃍"
        King -> "🃎"
    Clubs ->
      case c.value of
        Ace -> "🃑"
        Two -> "🃒"
        Three -> "🃓"
        Four -> "🃔"
        Five -> "🃕"
        Six -> "🃖"
        Seven -> "🃗"
        Eight -> "🃘"
        Nine -> "🃙"
        Ten -> "🃚"
        Jack -> "🃛"
        Queen -> "🃝"
        King -> "🃞"


isSelected : Model -> Card -> Bool
isSelected m c =
  case m.selectedCards of
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
