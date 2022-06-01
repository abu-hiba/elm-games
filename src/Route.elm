module Route exposing (Route(..), parseUrl)

import Url
import Url.Parser as Parser


type Route
    = NotFound
    | Home
    | Pairs


parseUrl : Url.Url -> Route
parseUrl url =
    case Parser.parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser.Parser (Route -> a) a
matchRoute =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Pairs (Parser.s "pairs")
        ]
