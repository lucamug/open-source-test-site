module Conf exposing
    ( ColorPalette
    , borderSize
    , c
    , colorPalette
    , green
    , headerHeight
    , pseudoRandomColor
    )

import Array
import Browser
import Color as ElmColor
import Color.Convert
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
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
