module Internal.Update exposing (update)

import Browser
import Browser.Navigation
import Internal.APIRequest as APIRequest
import Internal.CommonRoute as CommonRoute
import Internal.Model as Model exposing (Model)
import Internal.Msg as Msg exposing (Msg(..))
import Internal.Route as Route
import Internal.StopWordFilter as StopWordFilter
import Internal.Utils as Utils
import Keyboard
import Url


commandToCloseModal :
    { a
        | filter : String
        , key : Browser.Navigation.Key
    }
    -> Cmd msg
commandToCloseModal { filter, key } =
    Browser.Navigation.pushUrl key <|
        CommonRoute.toStringAndHash Route.conf <|
            Route.routeToRestoreFilter filter


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotData response ->
            ( { model | response = Just response }, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Browser.Navigation.load href
                    )

        UrlChanged url ->
            let
                route =
                    CommonRoute.fromUrl Route.conf url

                filter =
                    case route of
                        Route.Filter filter_ ->
                            filter_

                        Route.Empty ->
                            ""

                        _ ->
                            model.filter
            in
            ( { model | url = url, filter = filter }, Cmd.none )

        Click data ->
            if data.id1 == "cover" then
                ( model
                , commandToCloseModal model
                )

            else
                ( model, Cmd.none )

        KeyUp key ->
            if Keyboard.rawValue key == "Escape" then
                ( model
                , commandToCloseModal model
                )

            else
                ( model, Cmd.none )

        PageInTopArea state ->
            ( { model | pageInTopArea = state }, Cmd.none )

        OnResize x _ ->
            ( { model | width = x }, Cmd.none )

        ToggleColorMode ->
            ( { model
                | colorMode =
                    case model.colorMode of
                        Msg.Day ->
                            Msg.Night

                        _ ->
                            Msg.Day
              }
            , Cmd.none
            )

        ToggleLayoutMode ->
            ( { model
                | layoutMode =
                    case model.layoutMode of
                        Msg.Grid ->
                            Msg.List

                        _ ->
                            Msg.Grid
              }
            , Cmd.none
            )

        ChangeFilter filter ->
            ( { model | filter = filter }
            , Browser.Navigation.pushUrl model.key <|
                CommonRoute.toStringAndHash
                    Route.conf
                <|
                    if filter == "" then
                        Route.Empty

                    else
                        Route.Filter <| Utils.encode filter
            )
