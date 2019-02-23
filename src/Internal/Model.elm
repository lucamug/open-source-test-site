module Internal.Model exposing (Model)

import Browser.Navigation
import Http
import Internal.APIRequest as APIRequest
import Internal.CommonRoute as CommonRoute
import Internal.Msg as Msg exposing (Msg(..))
import Internal.Route as Route
import Internal.StopWordFilter as StopWordFilter
import Internal.Utils as Utils
import Url


type alias Model =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , filter : String
    , width : Int
    , pageInTopArea : Bool
    , colorMode : Msg.ColorMode
    , layoutMode : Msg.LayoutMode
    , response : Maybe (Result Http.Error (List Msg.Repo))
    }
