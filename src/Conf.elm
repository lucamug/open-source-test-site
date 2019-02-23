module Conf exposing
    ( ColorPalette
    , borderSize
    , c
    , colorPalette
    , green
    , headerHeight
    , maxWidth
    )

import Color as ElmColor
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Internal.CommonRoute as CommonRoute
import Internal.Shared as Shared exposing (Model, Msg(..))
import Svg.Attributes as SA



-- CONSTANTS


borderSize : Int
borderSize =
    2


headerHeight : Int
headerHeight =
    80


maxWidth : Int
maxWidth =
    1200



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
    , footerBackground : Color
    , footerFont : Color
    , footerFontLight : Color
    , border : Color
    , logo : Color
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
            , footerBackground = rgb255 51 51 51
            , footerFont = rgb255 200 200 200
            , footerFontLight = rgb255 153 153 153
            , border = rgb 0.2 0.2 0.2
            , logo = rgb255 200 200 200

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
            { background = rgb 1 1 1
            , font = rgb 0.3 0.3 0.3
            , fontLight = rgb 0.4 0.4 0.4
            , footerBackground = rgb255 51 51 51
            , footerFont = rgb255 200 200 200
            , footerFontLight = rgb255 153 153 153
            , border = rgb 0.8 0.8 0.8
            , logo = rgb255 191 0 0
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
            , footerBackground = green
            , footerFont = green
            , footerFontLight = green
            , border = green
            , logo = green
            , series =
                [ green
                , green
                , green
                , green
                , green
                ]
            }


c : Model -> (ColorPalette -> b) -> b
c model key =
    key <| colorPalette model.colorMode
