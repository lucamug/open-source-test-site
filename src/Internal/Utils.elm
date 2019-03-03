module Internal.Utils exposing
    ( decode
    , elementColorToElmColor
    , encode
    , isMobile
    , paddingResponsive
    )

import Color as ElmColor
import Conf
import Element
import Url


isMobile : { a | width : number } -> Bool
isMobile model =
    model.width < 700


paddingResponsive : { a | width : number } -> Int
paddingResponsive model =
    if isMobile model then
        Conf.paddingMobile

    else
        Conf.paddingDesktop


elementColorToElmColor : Element.Color -> ElmColor.Color
elementColorToElmColor elementColor =
    ElmColor.fromRgba <| Element.toRgb elementColor


encode : String -> String
encode string =
    string
        |> String.replace " " "_"
        |> Url.percentEncode


decode : String -> String
decode string =
    string
        |> Url.percentDecode
        |> Maybe.withDefault ""
        |> String.replace "_" " "
