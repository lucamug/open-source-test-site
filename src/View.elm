module View exposing (view)

import Array
import Browser
import Color as ElmColor
import Color.Convert
import CommonRoute
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode
import Route
import Shared exposing (Model, Msg(..))
import Svg
import Svg.Attributes as SA
import Utils



-- CONSTANTS


borderSize : Int
borderSize =
    2


headerHeight : Int
headerHeight =
    80



{-
    ██████  ██████  ██       ██████  ██████  ███████
   ██      ██    ██ ██      ██    ██ ██   ██ ██
   ██      ██    ██ ██      ██    ██ ██████  ███████
   ██      ██    ██ ██      ██    ██ ██   ██      ██
    ██████  ██████  ███████  ██████  ██   ██ ███████
-}


type alias ColorPalette =
    { background : Color
    , font : Color
    , fontLight : Color
    , border : Color
    , series : List Color
    }


green : Color
green =
    rgb 0.3 0.7 0.3


colorPalette : Shared.ColorMode -> ColorPalette
colorPalette colorMode =
    case colorMode of
        Shared.Night ->
            { background = rgb 0.2 0.2 0.2
            , font = rgb 0.8 0.8 0.8
            , fontLight = rgb 0.5 0.5 0.5
            , border = rgb 0.2 0.2 0.2

            -- https://coolors.co/ffc09f-ffee93-fcf5c7-a0ced9-adf7b6
            -- $color1: rgba(255, 192, 159, 1);
            -- $color2: rgba(255, 238, 147, 1);
            -- $color3: rgba(252, 245, 199, 1);
            -- $color4: rgba(160, 206, 217, 1);
            -- $color5: rgba(173, 247, 182, 1);
            -- https://coolors.co/a37b66-a3985e-a19c7f-66848b-6f9e74
            -- $color1: rgba(163, 123, 102, 1);
            -- $color2: rgba(163, 152, 94, 1);
            -- $color3: rgba(161, 156, 127, 1);
            -- $color4: rgba(102, 132, 139, 1);
            -- $color5: rgba(111, 158, 116, 1);
            , series =
                [ rgb255 163 123 102
                , rgb255 163 152 94
                , rgb255 161 156 127
                , rgb255 102 132 139
                , rgb255 111 158 116
                ]
            }

        Shared.Day ->
            { background = rgb 0.95 0.95 0.95
            , font = rgb 0.3 0.3 0.3
            , fontLight = rgb 0.4 0.4 0.4
            , border = rgb 0.8 0.8 0.8
            , series =
                [ rgb255 255 192 159
                , rgb255 255 238 147
                , rgb255 252 245 199
                , rgb255 160 206 217
                , rgb255 173 247 182
                ]
            }

        Shared.Green ->
            { background = green
            , font = green
            , fontLight = green
            , border = green
            , series =
                [ green
                , green
                , green
                , green
                , green
                ]
            }


pseudoRandomColor : Model -> String -> Color
pseudoRandomColor model title =
    let
        index =
            modBy 5 (String.length title)

        series =
            c model .series

        seriesArray =
            Array.fromList series
    in
    Maybe.withDefault green <| Array.get index seriesArray


c : Model -> (ColorPalette -> b) -> b
c model key =
    key <| colorPalette model.colorMode



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
        , backgroundColor = c model .background
        , fontColor = c model .font
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
        ([ Border.widthEach { bottom = borderSize, left = borderSize, right = borderSize, top = borderSize }
         , Border.width 0
         , Border.dashed
         , Border.color <| c model .border
         , Background.color <| pseudoRandomColor model item.lookup.name
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



{-
   ███████ ██    ██  ██████      ██  ██████  ██████  ███    ██ ███████
   ██      ██    ██ ██           ██ ██      ██    ██ ████   ██ ██
   ███████ ██    ██ ██   ███     ██ ██      ██    ██ ██ ██  ██ ███████
        ██  ██  ██  ██    ██     ██ ██      ██    ██ ██  ██ ██      ██
   ███████   ████    ██████      ██  ██████  ██████  ██   ████ ███████
   SVG ICONS
-}


type Icon
    = Icon_Plus
    | Icon_Minus
    | Icon_Close
    | Icon_PlusL
    | Icon_Github
    | Icon_Twitter
    | Icon_ExternalLink
    | Icon_Grid
    | Icon_Row


saFill : Color -> Svg.Attribute Msg
saFill cl =
    SA.fill <| Color.Convert.colorToHex <| elementColorToElmColor cl


icon : Icon -> Color -> Int -> Element Msg
icon icon_ cl size =
    let
        ( viewBox, paths ) =
            iconViewBoxAndPaths icon_ cl
    in
    html <|
        Svg.svg
            [ SA.xmlSpace "http://www.w3.org/2000/svg"
            , SA.viewBox viewBox
            , SA.height <| String.fromInt size
            ]
            paths


iconViewBoxAndPaths : Icon -> Color -> ( String, List (Svg.Svg Msg) )
iconViewBoxAndPaths icon_ cl =
    case icon_ of
        Icon_Plus ->
            ( "0 0 53 53"
            , [ Svg.path
                    [ saFill cl
                    , SA.d "M29 20h-6v-6a1 1 0 0 0-2 0v6h-6a1 1 0 0 0 0 2h6v6a1 1 0 0 0 2 0v-6h6a1 1 0 0 0 0-2z"
                    ]
                    []
              , Svg.path
                    [ saFill cl
                    , SA.d "M51.7 51.3L36.8 35.8A21 21 0 0 0 22 0a21 21 0 1 0 13.4 37.2l14.9 15.5a1 1 0 0 0 1.4 0c.4-.4.4-1 0-1.4zM3 21a19 19 0 1 1 38 0 19 19 0 0 1-38 0z"
                    ]
                    []
              ]
            )

        Icon_Minus ->
            ( "0 0 53 53"
            , [ Svg.path
                    [ saFill cl
                    , SA.d "M29 20H15a1 1 0 0 0 0 2h14a1 1 0 0 0 0-2z"
                    ]
                    []
              , Svg.path
                    [ saFill cl
                    , SA.d "M51.7 51.3L36.8 35.8A21 21 0 0 0 22 0a21 21 0 1 0 13.4 37.2l14.9 15.5a1 1 0 0 0 1.4 0c.4-.4.4-1 0-1.4zM3 21a19 19 0 1 1 38 0 19 19 0 0 1-38 0z"
                    ]
                    []
              ]
            )

        Icon_Close ->
            ( "0 0 53 53"
            , [ Svg.path
                    [ saFill cl
                    , SA.d "M26 0a26 26 0 1 0 0 52 26 26 0 0 0 0-52zm0 50a24 24 0 1 1 0-48 24 24 0 0 1 0 48z"
                    ]
                    []
              , Svg.path
                    [ saFill cl
                    , SA.d "M35.7 16.3a1 1 0 0 0-1.4 0L26 24.6l-8.3-8.3a1 1 0 1 0-1.4 1.4l8.3 8.3-8.3 8.3a1 1 0 1 0 1.4 1.4l8.3-8.3 8.3 8.3a1 1 0 0 0 1.4 0c.4-.4.4-1 0-1.4L27.4 26l8.3-8.3c.4-.4.4-1 0-1.4z"
                    ]
                    []
              ]
            )

        Icon_PlusL ->
            ( "0 0 640 640"
            , [ Svg.path
                    [ saFill cl
                    , SA.d "M143 147a10 10 0 0 0 14-14L97 73a10 10 0 0 0-14 14zm0 0M100 300c0-6-4-10-10-10H10a10 10 0 1 0 0 20h80c6 0 10-4 10-10zm0 0M143 453l-60 60a10 10 0 1 0 14 14l60-60a10 10 0 0 0-14-14zm0 0M554 354c-18 11-39 17-61 17-65-1-118-55-117-121 0-50 31-96 78-114a10 10 0 0 0 0-19c-19-5-38-8-58-7-30 0-60 8-86 22V10a10 10 0 1 0-20 0v101a190 190 0 0 0 0 378v101a10 10 0 0 0 20 0V468a182 182 0 0 0 259-103 10 10 0 0 0-15-11zm-414-54c0-86 65-159 150-169v338c-85-10-150-83-150-169zm256 170c-30 0-60-9-86-25V155c26-16 56-25 86-25l24 1c-40 27-64 71-64 119a139 139 0 0 0 184 133c-28 54-83 87-144 87zm0 0"
                    ]
                    []
              , Svg.path
                    [ saFill cl
                    , SA.d "M599 213c-1-4-4-6-8-7l-36-6-16-34c-2-4-5-6-9-6s-7 2-9 6l-16 34-37 6a10 10 0 0 0-5 17l26 27-6 38a10 10 0 0 0 15 11l32-18 32 18a10 10 0 0 0 13-3c2-2 2-5 2-8l-6-38 26-27c3-3 4-7 2-10zm-46 27c-2 2-3 5-3 8l4 23-19-10c-3-2-7-2-10 0l-19 10 4-23c0-3-1-6-3-8l-16-17 22-4c3 0 6-2 8-5l9-20 9 20c2 3 5 5 8 5l22 4zm0 0"
                    ]
                    []
              ]
            )

        Icon_Github ->
            ( "0 0 1024 1024"
            , [ Svg.path
                    [ saFill cl
                    , SA.fillRule "evenodd"
                    , SA.clipRule "evenodd"
                    , SA.d "M512 0a512 512 0 0 0-162 998c26 4 35-11 35-25v-95c-129 24-162-31-173-60-5-15-30-60-52-72-18-10-44-34-1-34 41-1 69 37 79 52 46 78 120 56 149 42 5-33 18-55 33-68-114-13-233-57-233-253 0-56 20-102 52-137-5-13-23-66 5-136 0 0 43-14 141 52a475 475 0 0 1 256 0c98-66 141-52 141-52 28 70 10 123 5 136 33 35 53 81 53 137 0 197-120 240-234 253 19 16 35 47 35 95l-1 140c0 14 10 30 35 25A513 513 0 0 0 512 0z"
                    ]
                    []
              ]
            )

        Icon_Twitter ->
            ( "0 0 300 244"
            , [ Svg.path [ saFill cl, SA.d "M94.7 243.2c112.5 0 174-93.2 174-174 0-2.6 0-5.2-.2-7.9 12-8.6 22.3-19.4 30.5-31.6a122 122 0 0 1-35.1 9.6 61.4 61.4 0 0 0 26.9-33.8c-11.8 7-25 12-38.8 14.8a61 61 0 0 0-104.2 55.8 173.6 173.6 0 0 1-126-64 61 61 0 0 0 18.9 81.7c-10-.3-19.5-3-27.7-7.6v.8c0 29.6 21 54.3 49 59.9a61.2 61.2 0 0 1-27.6 1 61.2 61.2 0 0 0 57.1 42.5A122.7 122.7 0 0 1 1 215.7a173 173 0 0 0 93.7 27.5" ] []
              ]
            )

        Icon_ExternalLink ->
            ( "0 0 512 512"
            , [ Svg.path [ saFill cl, SA.d "M393 292h-18a9 9 0 0 0-10 9v92c0 12-4 23-13 32s-20 14-32 14H82c-12 0-23-5-32-14s-13-20-13-32V155c0-12 4-23 13-32s20-13 32-13h201c3 0 5-1 7-3l2-7V82l-2-6c-2-2-4-3-7-3H82c-22 0-42 8-58 24a79 79 0 0 0-24 58v238c0 23 8 42 24 58s36 24 58 24h238c22 0 42-8 58-24s24-35 24-58v-92l-3-6c-1-2-3-3-6-3z" ] []
              , Svg.path [ saFill cl, SA.d "M506 42c-3-4-8-5-13-5H347c-5 0-9 1-13 5-3 4-5 8-5 13s2 9 5 13l51 50-187 186a9 9 0 0 0 0 13l33 33a9 9 0 0 0 13 0l186-186 51 50a17 17 0 0 0 26 0c3-4 5-8 5-13V55c0-5-2-9-6-13z" ] []
              ]
            )

        Icon_Grid ->
            ( "0 0 490 490"
            , [ Svg.rect [ saFill cl, SA.x "349.918", SA.y "53.9", SA.width "140.082", SA.height "107.8" ] []
              , Svg.rect [ saFill cl, SA.x "349.918", SA.y "191.1", SA.width "140.082", SA.height "107.8" ] []
              , Svg.rect [ saFill cl, SA.x "349.918", SA.y "328.3", SA.width "140.082", SA.height "107.8" ] []
              , Svg.rect [ saFill cl, SA.x "170.059", SA.y "53.9", SA.width "149.882", SA.height "107.8" ] []
              , Svg.rect [ saFill cl, SA.x "170.059", SA.y "191.1", SA.width "149.882", SA.height "107.8" ] []
              , Svg.rect [ saFill cl, SA.x "170.059", SA.y "328.3", SA.width "149.882", SA.height "107.8" ] []
              , Svg.rect [ saFill cl, SA.y "53.9", SA.width "140.082", SA.height "107.8" ] []
              , Svg.rect [ saFill cl, SA.y "191.1", SA.width "140.082", SA.height "107.8" ] []
              , Svg.rect [ saFill cl, SA.y "328.3", SA.width "140.082", SA.height "107.8" ] []
              ]
            )

        Icon_Row ->
            ( "0 0 490 490"
            , [ Svg.rect [ saFill cl, SA.y "372.4", SA.width "490", SA.height "9.8" ] []
              , Svg.rect [ saFill cl, SA.y "401.8", SA.width "490", SA.height "9.8" ] []
              , Svg.rect [ saFill cl, SA.y "431.2", SA.width "490", SA.height "9.8" ] []
              , Svg.rect [ saFill cl, SA.y "343", SA.width "490", SA.height "9.8" ] []
              , Svg.rect [ saFill cl, SA.y "49", SA.width "490", SA.height "107.8" ] []
              , Svg.rect [ saFill cl, SA.y "186.2", SA.width "490", SA.height "107.8" ] []
              ]
            )



{-
   ██   ██ ███████  █████  ██████  ███████ ██████
   ██   ██ ██      ██   ██ ██   ██ ██      ██   ██
   ███████ █████   ███████ ██   ██ █████   ██████
   ██   ██ ██      ██   ██ ██   ██ ██      ██   ██
   ██   ██ ███████ ██   ██ ██████  ███████ ██   ██
-}


viewHeader : Model -> Element Msg
viewHeader model =
    let
        iconSize =
            32
    in
    el
        [ height <|
            px
                (if model.pageInTopArea then
                    headerHeight

                 else
                    headerHeight - 20
                )
        , clip
        , width fill
        , Background.color <| c model .background
        , Border.shadow { offset = ( 0, 0 ), size = 5, blur = 10, color = rgba 0 0 0 0.2 }
        , htmlAttribute <| Html.Attributes.style "transition" "height 200ms linear"
        , htmlAttribute <| Html.Attributes.style "transition" "background 1000ms linear"
        ]
    <|
        row
            [ width fill
            , spacing 40
            , htmlAttribute <| Html.Attributes.style "transition" "padding 200ms linear"
            , padding <|
                if model.pageInTopArea then
                    20

                else
                    10
            ]
            [ if model.width > 700 then
                el
                    [ Font.size
                        (if model.pageInTopArea then
                            40

                         else
                            30
                        )
                    , width shrink
                    , htmlAttribute <| Html.Attributes.style "transition" "font 200ms linear"
                    ]
                <|
                    text "Elm Resources"

              else
                none
            , row [ width fill, spacing 10 ]
                [ Input.text
                    [ Border.widthEach { bottom = 2, left = 0, right = 0, top = 0 }
                    , paddingXY 8 8
                    , Font.size 24
                    , width fill
                    , Background.color <| c model .background
                    , Border.color <| c model .background
                    ]
                    { onChange = Shared.ChangeFilter
                    , text = Utils.decode model.filter
                    , placeholder = Just <| Input.placeholder [ Font.color <| c model .fontLight ] <| text "Filter"
                    , label = Input.labelAbove [] none
                    }
                , if String.length model.filter > 0 then
                    Input.button []
                        { label = icon Icon_Close (c model .font) iconSize
                        , onPress = Just <| ChangeFilter ""
                        }

                  else
                    none
                , Input.button []
                    { label = icon Icon_PlusL (c model .font) iconSize
                    , onPress = Just ToggleColorMode
                    }
                , Input.button []
                    { label =
                        icon
                            (case model.layoutMode of
                                Shared.Grid ->
                                    Icon_Row

                                Shared.List ->
                                    Icon_Grid
                            )
                            (c model .font)
                            iconSize
                    , onPress = Just ToggleLayoutMode
                    }
                , Input.button []
                    { label = icon Icon_Plus (c model .font) iconSize
                    , onPress = Just DecreaseSquareQuantity
                    }
                , Input.button []
                    { label = icon Icon_Minus (c model .font) iconSize
                    , onPress = Just IncreaseSquareQuantity
                    }
                , newTabLink []
                    { label = icon Icon_Github (c model .font) iconSize
                    , url = "https://github.com/lucamug/elm-resources"
                    }
                ]
            ]


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
    { title = "Elm Resources"
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
             , Font.color <| c model .font
             , inFront <| viewHeader model
             , Background.color <| c model .background
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
                        [ paddingEach { top = headerHeight, right = 0, bottom = 0, left = 0 }
                        ]

                Shared.List ->
                    column
                        [ paddingEach { top = headerHeight + 20, right = 20, bottom = 20, left = 20 }
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
                        , backgroundColor = c model .background
                        , fontColor = c model .font
                        }
                    ++ textInBoxes model
                        { string = "Keywords"
                        , quantity = 4
                        , paddingLeft = 60
                        , fontRatio = 2
                        , backgroundColor = c model .background
                        , fontColor = c model .font
                        }
                    ++ textInBoxes model
                        { string = "Links"
                        , quantity = 2
                        , paddingLeft = 25
                        , fontRatio = 2
                        , backgroundColor = c model .background
                        , fontColor = c model .font
                        }
                )
        ]
    }
