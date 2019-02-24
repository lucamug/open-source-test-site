module Internal.Model exposing (Model)

import Browser.Navigation
import Http
import Internal.APIRequest
import Internal.CommonRoute
import Internal.Route
import Internal.StopWordFilter
import Internal.Type as Type
import Internal.Utils
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
