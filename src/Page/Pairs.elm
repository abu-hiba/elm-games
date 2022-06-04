module Page.Pairs exposing (..)

import Html exposing (Html, button, div, img, span, text)
import Html.Attributes exposing (class, classList, selected, src)
import Html.Events exposing (onClick)
import Html.Keyed as Keyed
import Html.Lazy exposing (lazy, lazy2)
import PlayingCards
import Random
import Random.List
import Time



-- MODEL


type alias SelectedCards =
    ( Maybe PlayingCards.Card, Maybe PlayingCards.Card )


type alias Model =
    { cards : List PlayingCards.Card
    , selectedCards : SelectedCards
    , matchedCards : List PlayingCards.Card
    , timer : Int
    , gameStarted : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


model : Model
model =
    { cards = PlayingCards.deck
    , selectedCards = ( Nothing, Nothing )
    , matchedCards = []
    , timer = 0
    , gameStarted = False
    }



-- UPDATE


type Msg
    = Shuffle
    | ShuffledList (List PlayingCards.Card)
    | SelectCard PlayingCards.Card
    | IncrementTimer Time.Posix
    | ResetGame
    | StartGame
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg currModel =
    case msg of
        Shuffle ->
            ( currModel, Random.generate ShuffledList (Random.List.shuffle model.cards) )

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
            ( { currModel | gameStarted = True }, Random.generate ShuffledList (Random.List.shuffle currModel.cards) )

        NoOp ->
            ( currModel, Cmd.none )


isPair : PlayingCards.Card -> PlayingCards.Card -> Bool
isPair c1 c2 =
    if c1.value == c2.value then
        case c1.suit of
            PlayingCards.Spades ->
                c2.suit == PlayingCards.Spades || c2.suit == PlayingCards.Clubs

            PlayingCards.Clubs ->
                c2.suit == PlayingCards.Spades || c2.suit == PlayingCards.Clubs

            PlayingCards.Hearts ->
                c2.suit == PlayingCards.Hearts || c2.suit == PlayingCards.Diamonds

            PlayingCards.Diamonds ->
                c2.suit == PlayingCards.Hearts || c2.suit == PlayingCards.Diamonds

    else
        False



-- VIEW


view : Model -> Html Msg
view m =
    div []
        [ div [ class "controls" ]
            [ if m.gameStarted then
                btn [ onClick ResetGame ] [ text "Reset" ]

              else
                btn [ onClick StartGame ] [ text "Start" ]
            , span [ class "timer" ] [ text <| String.fromInt m.timer ]
            ]
        , lazy viewCards m
        ]


btn : List (Html.Attribute msg) -> List (Html msg) -> Html msg
btn attr html =
    button (List.concat [ attr, [ class "btn" ] ]) html


viewCards : Model -> Html Msg
viewCards m =
    Keyed.node "div" [ class "cards" ] (List.map (viewKeyedCard m) m.cards)


viewKeyedCard : Model -> PlayingCards.Card -> ( String, Html Msg )
viewKeyedCard m c =
    ( c.image, lazy2 viewCard m c )


viewCard : Model -> PlayingCards.Card -> Html Msg
viewCard m c =
    div
        [ classList
            [ ( "card", True )
            , ( "card--back", not (isSelected c m.selectedCards) )
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


getCardFace : PlayingCards.Card -> SelectedCards -> List PlayingCards.Card -> String
getCardFace c selected matched =
    if isSelected c selected || List.member c matched then
        "../cards/" ++ c.image ++ ".svg"

    else
        "../cards/card_back.svg"


isSelected : PlayingCards.Card -> SelectedCards -> Bool
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
