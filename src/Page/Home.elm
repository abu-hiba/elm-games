module Page.Home exposing (init, view)

import Html exposing (Html, a, div, text)
import Html.Attributes exposing (class, href)
import Html.Keyed as Keyed



-- Model


type alias PageLink =
    { text : String
    , route : String
    }


type alias Model =
    { pages : List PageLink }


model : Model
model =
    Model
        [ { text = "Pairs", route = "/pairs" }
        , { text = "Solitaire", route = "/solitaire" }
        ]


init : ( Model, Cmd msg )
init =
    ( model, Cmd.none )



-- View


view : Html msg
view =
    div [ class "menu-list" ]
        [ Keyed.node "div" [] (List.map viewPageLinks model.pages)
        ]


viewPageLinks : PageLink -> ( String, Html msg )
viewPageLinks link =
    ( link.route
    , div [ class "menu-list--item" ]
        [ a [ href link.route, class "menu-list--link" ]
            [ text link.text ]
        ]
    )
