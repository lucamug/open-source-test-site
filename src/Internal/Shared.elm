module Internal.Shared exposing
    ( Flags
    , init
    , resultSearch
    , update
    )

import Browser
import Browser.Navigation
import ElmTextSearch
import Index.Defaults
import Internal.APIRequest as APIRequest
import Internal.CommonRoute as CommonRoute
import Internal.Model as Model exposing (Model)
import Internal.Msg as Msg exposing (Msg(..))
import Internal.Route as Route
import Internal.StopWordFilter as StopWordFilter
import Internal.Utils as Utils
import Keyboard
import StopWordFilter
import Url



-- INIT


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        filter =
            case CommonRoute.fromUrl Route.conf url of
                Route.Filter filter_ ->
                    filter_

                _ ->
                    ""
    in
    ( { url = url
      , key = key
      , filter = filter
      , width = flags.width
      , pageInTopArea = True
      , colorMode = Msg.Day
      , layoutMode = Msg.Grid
      , response = Nothing
      }
    , APIRequest.request
    )



-- FLAGS


type alias Flags =
    { width : Int
    }



-- UPDATE


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



-- HELPERS
-- SEARCH ENGINE
--createMyStopWordFilter : Index.Model.Index doc -> ( Index.Model.Index doc, String -> Bool )


indexForLinks :
    List { b | lookup : { a | description : String, name : String } }
    -> ( ElmTextSearch.Index { b | lookup : { a | description : String, name : String } }, List ( Int, String ) )
indexForLinks list =
    let
        index =
            ElmTextSearch.newWith
                { ref = \item -> item.lookup.name
                , fields =
                    [ ( \item -> item.lookup.name, 5.0 )
                    , ( \item -> item.lookup.description, 1.0 )
                    ]
                , listFields = []
                , indexType = "Rakuten Open Source - Customized Stop Words v1"
                , initialTransformFactories = Index.Defaults.defaultInitialTransformFactories
                , transformFactories = Index.Defaults.defaultTransformFactories
                , filterFactories = [ StopWordFilter.createMyStopWordFilter ]
                }
    in
    ElmTextSearch.addDocs list index


indexBuilderforPeople :
    List { b | lookup : { a | name : String, twitter : String, github : String } }
    -> ( ElmTextSearch.Index { b | lookup : { a | name : String, twitter : String, github : String } }, List ( Int, String ) )
indexBuilderforPeople list =
    let
        index =
            ElmTextSearch.newWith
                { ref = \item -> item.lookup.name
                , fields =
                    [ ( \item -> item.lookup.name, 5.0 )
                    , ( \item -> item.lookup.twitter, 1.0 )
                    , ( \item -> item.lookup.github, 1.0 )
                    ]
                , listFields = []
                , indexType = "Rakuten Open Source - Customized Stop Words v1"
                , initialTransformFactories = Index.Defaults.defaultInitialTransformFactories
                , transformFactories = Index.Defaults.defaultTransformFactories
                , filterFactories = [ StopWordFilter.createMyStopWordFilter ]
                }
    in
    ElmTextSearch.addDocs list index


indexBuilder :
    List { b | lookup : { a | name : String } }
    -> ( ElmTextSearch.Index { b | lookup : { a | name : String } }, List ( Int, String ) )
indexBuilder list =
    let
        index =
            ElmTextSearch.newWith
                { ref = \item -> item.lookup.name
                , fields =
                    [ ( \item -> item.lookup.name, 5.0 )
                    ]
                , listFields = []
                , indexType = "Rakuten Open Source - Customized Stop Words v1"
                , initialTransformFactories = Index.Defaults.defaultInitialTransformFactories
                , transformFactories = Index.Defaults.defaultTransformFactories
                , filterFactories = [ StopWordFilter.createMyStopWordFilter ]
                }
    in
    ElmTextSearch.addDocs list index


resultSearch :
    ( ElmTextSearch.Index doc, b )
    -> String
    -> Result String ( ElmTextSearch.Index doc, List ( String, Float ) )
resultSearch index searchString =
    ElmTextSearch.search searchString (Tuple.first index)
