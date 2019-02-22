module View exposing (view)

import Array
import Browser
import Color as ElmColor
import Color.Convert
import Conf
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Footer
import Header
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Internal.CommonRoute as CommonRoute
import Internal.Shared as Shared exposing (Model, Msg(..))
import Json.Decode
import Route
import Svg
import Svg.Attributes as SA
import Utils



{-
   ██   ██ ███████ ██      ██████  ███████ ██████  ███████
   ██   ██ ██      ██      ██   ██ ██      ██   ██ ██
   ███████ █████   ██      ██████  █████   ██████  ███████
   ██   ██ ██      ██      ██      ██      ██   ██      ██
   ██   ██ ███████ ███████ ██      ███████ ██   ██ ███████
-}
-- HELPERS


elementColorToElmColor : Element.Color -> ElmColor.Color
elementColorToElmColor elementColor =
    ElmColor.fromRgba <| Element.toRgb elementColor


sizeOfBoxesInt : Model -> Int
sizeOfBoxesInt model =
    floor <| sizeOfBoxesFloat model


sizeOfBoxesFloat : Model -> Float
sizeOfBoxesFloat model =
    let
        size =
            toFloat model.width / toFloat model.squareQuantity
    in
    size


textInBoxes :
    Model
    ->
        { b
            | backgroundColor : Color
            , fontColor : Color
            , fontRatio : Int
            , paddingLeft : Int
            , quantity : Int
            , string : String
        }
    -> List (Element msg)
textInBoxes model { string, quantity, paddingLeft, fontRatio, backgroundColor, fontColor } =
    let
        size =
            sizeOfBoxesInt model

        paddingLeft_ =
            floor ((toFloat size / 120) * toFloat paddingLeft)

        fontSize =
            (size // 3) * fontRatio
    in
    case model.layoutMode of
        Shared.Grid ->
            List.indexedMap
                (\index _ ->
                    el
                        [ height <| px size
                        , width <| px size
                        , clip
                        , Font.color <| fontColor
                        , Background.color <| backgroundColor
                        ]
                    <|
                        el
                            [ centerY
                            , paddingXY paddingLeft_ 0
                            , Font.size fontSize
                            , moveLeft <| toFloat (size * index)
                            ]
                        <|
                            text string
                )
                (List.repeat quantity ())

        Shared.List ->
            [ el [ padding 20, Font.size 24 ] <| text string ]


dunno : String
dunno =
    "¯\\_(ツ)_/¯"


notFound : Model -> List (Element msg)
notFound model =
    textInBoxes
        model
        { paddingLeft = 40
        , quantity = 2
        , string = dunno
        , fontRatio = 1
        , backgroundColor = Conf.c model .background
        , fontColor = Conf.c model .font
        }


itemNotFound : Element msg
itemNotFound =
    column [ padding 50, spacing 30, width fill ]
        [ el [ Font.size 30, centerX ] <| text "Item not found"
        , el [ Font.size 30, centerX ] <| text dunno
        ]


nameAndQuantity : String -> Int -> String
nameAndQuantity title quantity =
    title ++ " (" ++ String.fromInt quantity ++ ")"


type ItemType
    = Keyword
    | Person
    | Link
    | LinkVideo



{-
   ██    ██ ██ ███████ ██     ██     ██      ██ ███████ ████████ ███████
   ██    ██ ██ ██      ██     ██     ██      ██ ██         ██    ██
   ██    ██ ██ █████   ██  █  ██     ██      ██ ███████    ██    ███████
    ██  ██  ██ ██      ██ ███ ██     ██      ██      ██    ██         ██
     ████   ██ ███████  ███ ███      ███████ ██ ███████    ██    ███████
-}


viewSquare :
    Model
    ->
        { c
            | item :
                { b
                    | lookup : { a | name : String, picture : String }
                    , quantity : Int
                }
            , itemType : ItemType
        }
    -> Element msg
viewSquare model { item, itemType } =
    let
        size =
            sizeOfBoxesInt model

        imageAttrs =
            if String.contains ".svg" item.lookup.picture then
                [ width <| px <| size * 2 // 3
                , height <| px <| size * 2 // 3
                , centerX
                , centerY
                ]

            else
                [ width <| px <| size
                , height <| px <| size
                ]

        modalOpen =
            case CommonRoute.fromUrl Route.conf model.url of
                Route.Empty ->
                    False

                Route.Filter _ ->
                    False

                _ ->
                    True
    in
    el
        ([ Border.widthEach { bottom = Conf.borderSize, left = Conf.borderSize, right = Conf.borderSize, top = Conf.borderSize }
         , Border.width 0
         , Border.dashed
         , Border.color <| Conf.c model .border
         , Background.color <| Conf.pseudoRandomColor model item.lookup.name
         , width <| px size
         , height <| px size
         , alignTop
         , htmlAttribute <| Html.Attributes.title <| item.lookup.name ++ " (" ++ String.fromInt item.quantity ++ ")"

         --, htmlAttribute <| Html.Attributes.style "transition" "background 1000ms linear"
         ]
            ++ (if modalOpen then
                    []

                else
                    [ htmlAttribute <| Html.Attributes.class "animatedItem" ]
               )
        )
    <|
        if item.lookup.picture == "" then
            el
                [ centerX
                , centerY
                , Font.size <| size * 2 // 3
                ]
            <|
                text <|
                    String.left 1 item.lookup.name

        else
            case itemType of
                Link ->
                    image
                        imageAttrs
                        { src = item.lookup.picture
                        , description = item.lookup.name
                        }

                LinkVideo ->
                    image
                        imageAttrs
                        { src = item.lookup.picture
                        , description = item.lookup.name
                        }

                Person ->
                    image
                        imageAttrs
                        { src = item.lookup.picture
                        , description = nameAndQuantity item.lookup.name item.quantity
                        }

                Keyword ->
                    image
                        imageAttrs
                        { src = item.lookup.picture
                        , description = nameAndQuantity item.lookup.name item.quantity
                        }


viewList :
    Model
    ->
        { c
            | itemType : ItemType
            , itemsToShow :
                List
                    { b
                        | lookup : { a | name : String, picture : String }
                        , quantity : Int
                    }
            , select :
                { b
                    | lookup : { a | name : String, picture : String }
                    , quantity : Int
                }
                -> Route.Route
        }
    -> List (Element Msg)
viewList model { itemsToShow, itemType, select } =
    if List.length itemsToShow == 0 then
        notFound model

    else
        List.map
            (\item ->
                let
                    square =
                        viewSquare model
                            { item = item
                            , itemType = itemType
                            }
                in
                link
                    []
                    { url = CommonRoute.toStringAndHash Route.conf <| select item
                    , label =
                        row [ spacing 10 ]
                            ([ square
                             ]
                                ++ (case model.layoutMode of
                                        Shared.Grid ->
                                            []

                                        Shared.List ->
                                            [ paragraph []
                                                [ text <|
                                                    item.lookup.name
                                                        ++ (if item.quantity > 1 then
                                                                " (" ++ String.fromInt item.quantity ++ ")"

                                                            else
                                                                ""
                                                           )
                                                ]
                                            ]
                                   )
                            )
                    }
            )
            itemsToShow


viewSelectionTitle :
    Model
    ->
        { d
            | extraData : List (Element msg)
            , item :
                { b
                    | lookup : { a | name : String, picture : String }
                    , quantity : Int
                }
            , itemType : ItemType
        }
    -> List (Element msg)
    -> Element msg
viewSelectionTitle model { item, itemType, extraData } extra =
    row [ spacing 20 ]
        [ viewSquare model { item = item, itemType = itemType }
        , column [ width fill, spacing 10 ]
            ([ el [ Font.size 16 ] <|
                text <|
                    case itemType of
                        Keyword ->
                            "Keyword"

                        Person ->
                            "Author"

                        Link ->
                            "Link"

                        LinkVideo ->
                            "Video"
             , paragraph [ alignTop, Font.size 30 ]
                ([ text <| item.lookup.name ++ " "
                 , if item.quantity > 1 then
                    el [ Font.size 16 ] <| text <| "(" ++ String.fromInt item.quantity ++ ") "

                   else
                    none
                 ]
                    ++ extra
                )
             ]
                ++ extraData
            )
        ]


linkUrl : { b | lookup : { a | name : String } } -> ItemType -> String
linkUrl item type_ =
    CommonRoute.toStringAndHash Route.conf <|
        case type_ of
            Link ->
                Route.SelectedLink <|
                    Utils.encode item.lookup.name

            LinkVideo ->
                Route.SelectedLink <|
                    Utils.encode item.lookup.name

            Person ->
                Route.SelectedPerson <|
                    Utils.encode item.lookup.name

            Keyword ->
                Route.SelectedKeyword <|
                    Utils.encode item.lookup.name



{-
   ██    ██ ██ ███████ ██     ██     ███████ ███████ ██      ███████  ██████ ████████ ██  ██████  ███    ██
   ██    ██ ██ ██      ██     ██     ██      ██      ██      ██      ██         ██    ██ ██    ██ ████   ██
   ██    ██ ██ █████   ██  █  ██     ███████ █████   ██      █████   ██         ██    ██ ██    ██ ██ ██  ██
    ██  ██  ██ ██      ██ ███ ██          ██ ██      ██      ██      ██         ██    ██ ██    ██ ██  ██ ██
     ████   ██ ███████  ███ ███      ███████ ███████ ███████ ███████  ██████    ██    ██  ██████  ██   ████
-}


isVideo : String -> Bool
isVideo url =
    String.contains "https://www.youtube.com" url



{-
   ██    ██ ██ ███████ ██     ██
   ██    ██ ██ ██      ██     ██
   ██    ██ ██ █████   ██  █  ██
    ██  ██  ██ ██      ██ ███ ██
     ████   ██ ███████  ███ ███
-}


clickDecoder : Json.Decode.Decoder Shared.ClickData
clickDecoder =
    Json.Decode.map5 Shared.ClickData
        (Json.Decode.at [ "target", "id" ] Json.Decode.string)
        (Json.Decode.at [ "target", "parentElement", "id" ] Json.Decode.string)
        (Json.Decode.at [ "target", "parentElement", "parentElement", "id" ] Json.Decode.string)
        (Json.Decode.at [ "target", "parentElement", "parentElement", "parentElement", "id" ] Json.Decode.string)
        (Json.Decode.at [ "target", "parentElement", "parentElement", "parentElement", "parentElement", "id" ] Json.Decode.string)


view : Model -> Browser.Document Msg
view model =
    let
        route =
            CommonRoute.fromUrl Route.conf model.url
    in
    { title = "Rakuten Open Source"
    , body =
        [ layoutWith
            { options =
                [ focusStyle
                    { borderColor = Nothing
                    , backgroundColor = Nothing
                    , shadow =
                        Nothing
                    }
                ]
            }
            ([ width fill
             , Font.family
                [ Font.typeface "Noto Sans Japanese"
                , Font.sansSerif
                ]
             , Font.color <| Conf.c model .font
             , inFront <| Header.view model
             , Background.color <| Conf.c model .background
             , htmlAttribute <| Html.Attributes.style "transition" "background 1000ms linear"
             ]
                ++ (case route of
                        Route.Empty ->
                            []

                        Route.Filter _ ->
                            []

                        _ ->
                            []
                   )
            )
          <|
            (case model.layoutMode of
                Shared.Grid ->
                    wrappedRow
                        [ paddingEach { top = Conf.headerHeight, right = 0, bottom = 0, left = 0 }
                        ]

                Shared.List ->
                    column
                        [ paddingEach { top = Conf.headerHeight + 20, right = 20, bottom = 20, left = 20 }
                        , spacing 10
                        , width (fill |> maximum 800)
                        , centerX
                        , Border.shadow { offset = ( 0, 0 ), size = 5, blur = 10, color = rgba 0 0 0 0.2 }
                        ]
            )
            <|
                ([ html <|
                    Html.node "style"
                        []
                        [ Html.text <| """
                        .width-px-""" ++ String.fromInt (sizeOfBoxesInt model) ++ """ {
                            width: """ ++ String.fromFloat (sizeOfBoxesFloat model) ++ """px
                        }

                        .animatedItem {
                            transition: all 100ms linear;
                        }
                        .animatedItem:hover {
                            transform: scale(1.7, 1.7);
                            z-index: 1;
                        }
                        """
                        ]
                 ]
                    ++ textInBoxes model
                        { string = "People"
                        , quantity = 3
                        , paddingLeft = 50
                        , fontRatio = 2
                        , backgroundColor = Conf.c model .background
                        , fontColor = Conf.c model .font
                        }
                    ++ textInBoxes model
                        { string = "Keywords"
                        , quantity = 4
                        , paddingLeft = 60
                        , fontRatio = 2
                        , backgroundColor = Conf.c model .background
                        , fontColor = Conf.c model .font
                        }
                    ++ textInBoxes model
                        { string = "Links"
                        , quantity = 2
                        , paddingLeft = 25
                        , fontRatio = 2
                        , backgroundColor = Conf.c model .background
                        , fontColor = Conf.c model .font
                        }
                    ++ [ Footer.view ]
                )
        ]
    }
