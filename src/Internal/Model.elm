module Internal.Model exposing (Model)

import Browser.Navigation
import Http
import Internal.Type as Type
import Url


type alias Model =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , filter : String
    , width : Int
    , pageInTopArea : Bool
    , colorMode : Type.ColorMode
    , layoutMode : Type.LayoutMode
    , response : Maybe (Result Http.Error (List Type.Repo))
    }
