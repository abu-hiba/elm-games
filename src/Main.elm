module Main exposing (..)

import Browser
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (class, classList, selected, src)
import Html.Events exposing (onClick)
import Random
import Random.List exposing (shuffle)
import Time


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
    , image : String
    }


type alias SelectedCards =
    ( Maybe Card, Maybe Card )


deck : List Card
deck =
    [ { value = Ace, suit = Spades, image = "as" }
    , { value = Two, suit = Spades, image = "2s" }
    , { value = Three, suit = Spades, image = "3s" }
    , { value = Four, suit = Spades, image = "4s" }
    , { value = Five, suit = Spades, image = "5s" }
    , { value = Six, suit = Spades, image = "6s" }
    , { value = Seven, suit = Spades, image = "7s" }
    , { value = Eight, suit = Spades, image = "8s" }
    , { value = Nine, suit = Spades, image = "9s" }
    , { value = Ten, suit = Spades, image = "10s" }
    , { value = Jack, suit = Spades, image = "js" }
    , { value = Queen, suit = Spades, image = "qs" }
    , { value = King, suit = Spades, image = "ks" }
    , { value = Ace, suit = Hearts, image = "ah" }
    , { value = Two, suit = Hearts, image = "2h" }
    , { value = Three, suit = Hearts, image = "3h" }
    , { value = Four, suit = Hearts, image = "4h" }
    , { value = Five, suit = Hearts, image = "5h" }
    , { value = Six, suit = Hearts, image = "6h" }
    , { value = Seven, suit = Hearts, image = "7h" }
    , { value = Eight, suit = Hearts, image = "8h" }
    , { value = Nine, suit = Hearts, image = "9h" }
    , { value = Ten, suit = Hearts, image = "10h" }
    , { value = Jack, suit = Hearts, image = "jh" }
    , { value = Queen, suit = Hearts, image = "qh" }
    , { value = King, suit = Hearts, image = "kh" }
    , { value = Ace, suit = Clubs, image = "ac" }
    , { value = Two, suit = Clubs, image = "2c" }
    , { value = Three, suit = Clubs, image = "3c" }
    , { value = Four, suit = Clubs, image = "4c" }
    , { value = Five, suit = Clubs, image = "5c" }
    , { value = Six, suit = Clubs, image = "6c" }
    , { value = Seven, suit = Clubs, image = "7c" }
    , { value = Eight, suit = Clubs, image = "8c" }
    , { value = Nine, suit = Clubs, image = "9c" }
    , { value = Ten, suit = Clubs, image = "10c" }
    , { value = Jack, suit = Clubs, image = "jc" }
    , { value = Queen, suit = Clubs, image = "qc" }
    , { value = King, suit = Clubs, image = "kc" }
    , { value = Ace, suit = Diamonds, image = "ad" }
    , { value = Two, suit = Diamonds, image = "2d" }
    , { value = Three, suit = Diamonds, image = "3d" }
    , { value = Four, suit = Diamonds, image = "4d" }
    , { value = Five, suit = Diamonds, image = "5d" }
    , { value = Six, suit = Diamonds, image = "6d" }
    , { value = Seven, suit = Diamonds, image = "7d" }
    , { value = Eight, suit = Diamonds, image = "8d" }
    , { value = Nine, suit = Diamonds, image = "9d" }
    , { value = Ten, suit = Diamonds, image = "10d" }
    , { value = Jack, suit = Diamonds, image = "jd" }
    , { value = Queen, suit = Diamonds, image = "qd" }
    , { value = King, suit = Diamonds, image = "kd" }
    ]



-- MODEL


type alias Model =
    { cards : List Card
    , selectedCards : SelectedCards
    , matchedCards : List Card
    , timer : Int
    , gameStarted : Bool
    }


model : Model
model =
    { cards = deck
    , selectedCards = ( Nothing, Nothing )
    , matchedCards = []
    , timer = 0
    , gameStarted = False
    }



-- UPDATE


type Msg
    = Shuffle
    | ShuffledList (List Card)
    | SelectCard Card
    | IncrementTimer Time.Posix
    | ResetGame
    | StartGame
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg currModel =
    case msg of
        Shuffle ->
            ( currModel, Random.generate ShuffledList (shuffle model.cards) )

        ShuffledList shuffledList ->
            ( { currModel | cards = shuffledList }, Cmd.none )

        SelectCard selectedCard ->
            case currModel.selectedCards of
                ( Nothing, Nothing ) ->
                    ( { currModel | selectedCards = ( Just selectedCard, Nothing ) }, Cmd.none )

                ( Just _, Just _ ) ->
                    ( { currModel | selectedCards = ( Just selectedCard, Nothing ) }, Cmd.none )

                ( Just c, Nothing ) ->
                    ( { currModel
                        | selectedCards =
                            if List.member selectedCard currModel.matchedCards || (c == selectedCard) then
                                ( Just c, Nothing )

                            else
                                ( Just c, Just selectedCard )
                        , matchedCards =
                            if isPair c selectedCard && not (c == selectedCard) then
                                c :: selectedCard :: currModel.matchedCards

                            else
                                currModel.matchedCards
                      }
                    , Cmd.none
                    )

                -- should never occur
                ( Nothing, Just _ ) ->
                    ( currModel, Cmd.none )

        IncrementTimer _ ->
            ( { currModel | timer = currModel.timer + 1 }, Cmd.none )

        ResetGame ->
            ( model, Cmd.none )

        StartGame ->
            ( { currModel | gameStarted = True }, Random.generate ShuffledList (shuffle currModel.cards) )

        NoOp ->
            ( currModel, Cmd.none )


isPair : Card -> Card -> Bool
isPair c1 c2 =
    if c1.value == c2.value then
        case c1.suit of
            Spades ->
                c2.suit == Spades || c2.suit == Clubs

            Clubs ->
                c2.suit == Spades || c2.suit == Clubs

            Hearts ->
                c2.suit == Hearts || c2.suit == Diamonds

            Diamonds ->
                c2.suit == Hearts || c2.suit == Diamonds

    else
        False



-- VIEW


view : Model -> Html Msg
view m =
    div []
        [ div [ class "controls" ]
            [ if m.gameStarted then
                button [ onClick ResetGame ] [ text "Reset" ]

              else
                button [ onClick StartGame ] [ text "Start" ]
            , text <| String.fromInt m.timer
            ]
        , div [ class "cards" ] (List.map (viewCard m) m.cards)
        ]


viewCard : Model -> Card -> Html Msg
viewCard m c =
    div
        [ classList
            [ ( "card", True )
            , ( "red", (c.suit == Hearts || c.suit == Diamonds) && (isSelected c m.selectedCards || List.member c m.matchedCards) )
            , ( "back", not (isSelected c m.selectedCards) )
            ]
        , onClick
            (if m.gameStarted then
                SelectCard c

             else
                NoOp
            )
        ]
        [ img [ src (getCardFace c m.selectedCards m.matchedCards) ] []
        ]


getCardFace : Card -> SelectedCards -> List Card -> String
getCardFace c selected matched =
    if isSelected c selected || List.member c matched then
        "./cards/" ++ c.image ++ ".svg"

    else
        "./cards/card_back.svg"


isSelected : Card -> SelectedCards -> Bool
isSelected c currentSelected =
    case currentSelected of
        ( Nothing, Just sc ) ->
            sc == c

        ( Just sc, Nothing ) ->
            sc == c

        ( Just sc1, Just sc2 ) ->
            (sc1 == c) || (sc2 == c)

        ( Nothing, Nothing ) ->
            False



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions m =
    if m.gameStarted && (List.length m.matchedCards < 52) then
        Time.every 1000 IncrementTimer

    else
        Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( model, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
