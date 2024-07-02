module Page exposing (view)

import Html exposing (Html, a, button, div, text)
import Html.Attributes exposing (class, href)


view : List (Html msg) -> Html msg
view children =
    div [] (backButton :: children)


backButton : Html msg
backButton =
    a [ class "btn home-btn", href "/" ] [ text "❮ Home" ]
