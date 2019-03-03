module Internal.Update exposing (update)

import Browser
import Browser.Navigation
import Internal.CommonRoute as CommonRoute
import Internal.Model exposing (Model)
import Internal.Msg exposing (Msg(..))
import Internal.Port
import Internal.Route as Route
import Internal.Search as Search
import Internal.Type as Type
import Internal.Utils as Utils
import Json.Decode
import Json.Decode.Pipeline
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


decoder : Json.Decode.Decoder Type.LocalStorage
decoder =
    Json.Decode.succeed Type.LocalStorage
        |> Json.Decode.Pipeline.required "nightMode" Json.Decode.bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnStoreChange ls ->
            let
                localStorageResult =
                    Json.Decode.decodeString decoder ls
            in
            case localStorageResult of
                Ok localStorage ->
                    ( { model | localStorage = localStorage }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        GotData response ->
            let
                ( repos, error ) =
                    case response of
                        Ok repos_ ->
                            ( model.repos ++ repos_, Nothing )

                        Err err ->
                            ( model.repos, Just err )
            in
            ( { model
                | repos = repos
                , indexForRepo = Search.indexBuilderforRepo repos
                , error = error
              }
            , Cmd.none
            )

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
            let
                localStorage =
                    model.localStorage

                newLocalStorage =
                    { localStorage | nightMode = not localStorage.nightMode }
            in
            ( { model | localStorage = newLocalStorage }
            , Internal.Port.toLocalStorage newLocalStorage
            )

        ToggleLayoutMode ->
            ( { model
                | layoutMode =
                    case model.layoutMode of
                        Type.Grid ->
                            Type.List

                        _ ->
                            Type.Grid
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
