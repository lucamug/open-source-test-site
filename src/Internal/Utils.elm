module Internal.Utils exposing
    ( decode
    , encode
    )

import Url


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
