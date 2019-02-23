module Internal.Icon exposing
    ( Icon(..)
    , icon
    , iconViewBoxAndPaths
    , saFill
    )

import Color as ElmColor
import Color.Convert
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Internal.CommonRoute as CommonRoute
import Internal.Shared as Shared exposing (Model, Msg(..))
import Svg
import Svg.Attributes as SA


elementColorToElmColor : Element.Color -> ElmColor.Color
elementColorToElmColor elementColor =
    ElmColor.fromRgba <| Element.toRgb elementColor



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
    | Logo_Rakuten


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

        Logo_Rakuten ->
            ( "0 0 166 49.4"
            , [ Svg.path
                    [ saFill cl
                    , SA.d "M41.2 49.4l92.3-8H33.2l8 8zm1.3-14.3v1.2h6.2V9.1h-6.2v1.2a10 10 0 0 0-5.8-1.9c-7 0-12.4 6.4-12.4 14.3S29.6 37 36.7 37c2.3 0 4-.7 5.8-1.9zM30.7 22.7c0-4.3 2.5-7.7 6-7.7s5.9 3.4 5.9 7.7c0 4.3-2.5 7.7-5.9 7.7-3.5 0-6-3.4-6-7.7zm56 14.3c3 0 5.3-1.7 5.3-1.7v1h6.2V9.1H92v16c0 3-2.1 5.5-5.1 5.5s-5.1-2.5-5.1-5.5v-16h-6.2v16c0 6.6 4.5 11.9 11.1 11.9zm68.2-28.6c-3 0-5.3 1.7-5.3 1.7v-1h-6.2v27.2h6.2v-16c0-3 2.1-5.5 5.1-5.5s5.1 2.5 5.1 5.5v16h6.2v-16c0-6.6-4.5-11.9-11.1-11.9zM22.4 14c0-6.5-5.3-11.7-11.7-11.7H0v34h6.5V25.8h4.6L19 36.3h8.1l-9.6-12.7c3-2.1 4.9-5.6 4.9-9.6zm-11.7 5.3H6.5V8.7h4.2c2.9 0 5.3 2.4 5.3 5.3s-2.4 5.3-5.3 5.3zm92.9 8c0 6.1 4.6 9.7 9.2 9.7a13 13 0 0 0 6-1.7l-4-5.4c-.6.4-1.3.7-2.1.7-1 0-2.9-.8-2.9-3.3V15.6h5.3V9.1h-5.3V2.3h-6.2v6.8h-3.3v6.5h3.3v11.7zm-45.1-2.2l9.2 11.2h8.6L64 21.8 74.6 9.1H66l-7.5 9.5V0h-6.3v36.3h6.3V25.1zm70.6-16.7c-7.2 0-12.3 6.3-12.3 14.3 0 8.4 6.4 14.3 12.9 14.3 3.3 0 7.4-1.1 10.9-6.1l-5.5-3.2c-4.2 6.2-11.3 3.1-12.1-3.2h17.8c1.7-9.7-4.7-16.1-11.7-16.1zm-5.7 10.8c1.3-6.4 9.9-6.8 11.1 0h-11.1z"
                    ]
                    []
              ]
            )
