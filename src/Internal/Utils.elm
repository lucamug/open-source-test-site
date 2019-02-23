module Internal.Utils exposing
    ( decode
    , encode
    )

import Color as ElmColor
import Element
import Url


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
