module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, h3, text)
import Page
import Page.Home as Home
import Page.Pairs as Pairs
import Route
import Url



-- MODEL


type Page
    = NotFoundPage
    | HomePage
    | PairsPage Pairs.Model


type alias Model =
    { route : Route.Route
    , page : Page
    , navKey : Nav.Key
    }


type Msg
    = PairsPageMsg Pairs.Msg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Route.Pairs ->
                    let
                        ( pageModel, pageCmds ) =
                            Pairs.init
                    in
                    ( PairsPage pageModel, Cmd.map PairsPageMsg pageCmds )

                Route.Home ->
                    ( HomePage, Cmd.none )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( PairsPageMsg subMsg, PairsPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    Pairs.update subMsg pageModel
            in
            ( { model | page = PairsPage updatedPageModel }
            , Cmd.map PairsPageMsg updatedCmd
            )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

        ( _, _ ) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Card games"
    , body = [ currentView model ]
    }


currentView : Model -> Html Msg
currentView model =
    case model.page of
        NotFoundPage ->
            Page.view [ notFoundView ]

        PairsPage pageModel ->
            Page.view [ Pairs.view pageModel ]
                |> Html.map PairsPageMsg

        HomePage ->
            Home.view


notFoundView : Html msg
notFoundView =
    h3 [] [ text "The page you requested was not found" ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        NotFoundPage ->
            Sub.none

        PairsPage pairs ->
            Sub.map PairsPageMsg (Pairs.subscriptions pairs)

        HomePage ->
            Sub.none


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
