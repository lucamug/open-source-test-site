module Internal.Shared exposing
    ( ClickData
    , ColorMode(..)
    , Flags
    , LayoutMode(..)
    , Model
    , Msg(..)
    , init
    , resultSearch
    , update
    )

import Browser
import Browser.Navigation
import ElmTextSearch
import Index.Defaults
import Internal.CommonRoute as CommonRoute
import Keyboard
import Route
import StopWordFilter
import Url
import Utils



-- CONSTANTS


initialSquareWidth : Int
initialSquareWidth =
    56


initialSquareWidthForMobile : Int
initialSquareWidthForMobile =
    50



-- TYPES


type ColorMode
    = Day
    | Night
    | Green


type LayoutMode
    = List
    | Grid



-- MODEL


type alias Model =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , filter : String
    , squareQuantity : Int
    , squareWidth : Float
    , width : Int
    , pageInTopArea : Bool
    , colorMode : ColorMode
    , layoutMode : LayoutMode
    }



-- INIT


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        squareQuantity =
            if flags.width < 475 then
                flags.width // initialSquareWidthForMobile

            else
                flags.width // initialSquareWidth

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
      , squareQuantity = squareQuantity
      , squareWidth = toFloat flags.width / toFloat squareQuantity
      , width = flags.width
      , pageInTopArea = True
      , colorMode = Day
      , layoutMode = Grid
      }
    , Cmd.none
    )



-- FLAGS


type alias Flags =
    { width : Int
    }



-- UPDATE


type alias ClickData =
    { id1 : String
    , id2 : String
    , id3 : String
    , id4 : String
    , id5 : String
    }


type Msg
    = Click ClickData
    | OnResize Int Int
    | ToggleColorMode
    | ToggleLayoutMode
    | IncreaseSquareQuantity
    | DecreaseSquareQuantity
    | ChangeFilter String
    | PageInTopArea Bool
    | KeyUp Keyboard.RawKey
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


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
            let
                newQuantity =
                    x // floor model.squareWidth

                newQuantity_ =
                    if newQuantity > 1 then
                        newQuantity

                    else
                        1
            in
            ( { model | width = x, squareQuantity = newQuantity_ }, Cmd.none )

        IncreaseSquareQuantity ->
            let
                newQuantity =
                    model.squareQuantity + 1
            in
            ( { model
                | squareQuantity = newQuantity
                , squareWidth = toFloat model.width / toFloat newQuantity
              }
            , Cmd.none
            )

        DecreaseSquareQuantity ->
            let
                newQuantity =
                    if model.squareQuantity > 1 then
                        model.squareQuantity - 1

                    else
                        model.squareQuantity
            in
            ( { model
                | squareQuantity = newQuantity
                , squareWidth = toFloat model.width / toFloat newQuantity
              }
            , Cmd.none
            )

        ToggleColorMode ->
            ( { model
                | colorMode =
                    case model.colorMode of
                        Day ->
                            Night

                        _ ->
                            Day
              }
            , Cmd.none
            )

        ToggleLayoutMode ->
            ( { model
                | layoutMode =
                    case model.layoutMode of
                        Grid ->
                            List

                        _ ->
                            Grid
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


createMyStopWordFilter =
    {- The type signature for this function would be:

       createMyStopWordFilter : Index.Model.Index doc -> ( Index.Model.Index doc, String -> Bool )

       but these types are not exposed.
    -}
    StopWordFilter.createFilterFunc
        []


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
                , indexType = "Elm Resources - Customized Stop Words v1"
                , initialTransformFactories = Index.Defaults.defaultInitialTransformFactories
                , transformFactories = Index.Defaults.defaultTransformFactories
                , filterFactories = [ createMyStopWordFilter ]
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
                , indexType = "Elm Resources - Customized Stop Words v1"
                , initialTransformFactories = Index.Defaults.defaultInitialTransformFactories
                , transformFactories = Index.Defaults.defaultTransformFactories
                , filterFactories = [ createMyStopWordFilter ]
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
                , indexType = "Elm Resources - Customized Stop Words v1"
                , initialTransformFactories = Index.Defaults.defaultInitialTransformFactories
                , transformFactories = Index.Defaults.defaultTransformFactories
                , filterFactories = [ createMyStopWordFilter ]
                }
    in
    ElmTextSearch.addDocs list index


resultSearch :
    ( ElmTextSearch.Index doc, b )
    -> String
    -> Result String ( ElmTextSearch.Index doc, List ( String, Float ) )
resultSearch index searchString =
    ElmTextSearch.search searchString (Tuple.first index)
