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
    , paddingDesktop
    , paddingMobile
    )

import Element exposing (..)
import Internal.Model as Model



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


paddingDesktop : Int
paddingDesktop =
    20


paddingMobile : Int
paddingMobile =
    8



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
    , repoBackground : Color
    , repoShadow : Color
    , font : Color
    , fontLight : Color
    , footerBackground : Color
    , footerFont : Color
    , footerFontLight : Color
    , border : Color
    , logo : Color
    }


colorPalette : Bool -> ColorPalette
colorPalette nightMode =
    if nightMode then
        { background = rgb 0.1 0.1 0.1
        , repoBackground = rgb 0.18 0.18 0.18
        , repoShadow = rgb 0 0 0
        , font = rgb 0.8 0.8 0.8
        , fontLight = rgb 0.5 0.5 0.5
        , footerBackground = rgb255 40 40 40
        , footerFont = rgb255 200 200 200
        , footerFontLight = rgb255 153 153 153
        , border = rgb 0.2 0.2 0.2
        , logo = rgb255 200 200 200
        }

    else
        { background = rgb 1 1 1
        , repoBackground = rgb 0.97 0.97 0.97
        , repoShadow = rgb 0.8 0.8 0.8
        , font = rgb 0.3 0.3 0.3
        , fontLight = rgb 0.4 0.4 0.4
        , footerBackground = rgb255 51 51 51
        , footerFont = rgb255 200 200 200
        , footerFontLight = rgb255 153 153 153
        , border = rgb 0.8 0.8 0.8
        , logo = rgb255 191 0 0
        }


c : Model.Model -> (ColorPalette -> b) -> b
c model key =
    key <| colorPalette model.localStorage.nightMode
