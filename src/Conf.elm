module Conf exposing
    ( ColorPalette
    , borderSize
    , c
    , colorPalette
    , css
    , headerHeight
    , headerHeightSmall
    , iconSize
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
import Internal.Model as Model exposing (Model)
import Internal.Msg as Msg exposing (Msg(..))
import Internal.Shared as Shared
import Svg.Attributes as SA



{-
    ██████  ██████  ███    ██ ███████
   ██      ██    ██ ████   ██ ██
   ██      ██    ██ ██ ██  ██ █████
   ██      ██    ██ ██  ██ ██ ██
    ██████  ██████  ██   ████ ██
-}


borderSize : Int
borderSize =
    2


headerHeight : Int
headerHeight =
    120


headerHeightSmall : Int
headerHeightSmall =
    80


maxWidth : Int
maxWidth =
    1200


iconSize : Int
iconSize =
    32



{-
    ██████ ███████ ███████
   ██      ██      ██
   ██      ███████ ███████
   ██           ██      ██
    ██████ ███████ ███████
-}


css : String
css =
    """
.animatedItem {
    transition: all 100ms linear;
}
.animatedItem:hover {
    transform: scale(1.7, 1.7);
    z-index: 1;
}
"""



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
    }


colorPalette : Msg.ColorMode -> ColorPalette
colorPalette colorMode =
    case colorMode of
        Msg.Night ->
            { background = rgb 0.2 0.2 0.2
            , font = rgb 0.8 0.8 0.8
            , fontLight = rgb 0.5 0.5 0.5
            , footerBackground = rgb255 51 51 51
            , footerFont = rgb255 200 200 200
            , footerFontLight = rgb255 153 153 153
            , border = rgb 0.2 0.2 0.2
            , logo = rgb255 200 200 200
            }

        Msg.Day ->
            { background = rgb 1 1 1
            , font = rgb 0.3 0.3 0.3
            , fontLight = rgb 0.4 0.4 0.4
            , footerBackground = rgb255 51 51 51
            , footerFont = rgb255 200 200 200
            , footerFontLight = rgb255 153 153 153
            , border = rgb 0.8 0.8 0.8
            , logo = rgb255 191 0 0
            }


c : Model -> (ColorPalette -> b) -> b
c model key =
    key <| colorPalette model.colorMode
