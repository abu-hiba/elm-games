module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Random exposing (generate)
import Random.List exposing (shuffle)
import Debug exposing (toString)


-- MODEL
type alias Model =
  { cards : List Int
  , points : Int
  }

model : Model
model =
  { cards = List.range 1 5
  , points = 0
  }


-- UPDATE

type Msg
  = Shuffle
  | ShuffledList (List Int)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg currModel =
  case msg of
    Shuffle ->
      ( currModel, generate ShuffledList (shuffle model.cards) )

    ShuffledList shuffledList ->
      ({ currModel | cards = shuffledList }, Cmd.none)


-- VIEW

view : Model -> Html Msg
view m =
  div []
    [ div [] [ text <| toString <| m.cards ]
    , div [ ] [ button [ onClick Shuffle ] [ text "Shuffle" ] ]
    ]

main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> (model, Cmd.none)
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
