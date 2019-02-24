module Internal.Msg exposing (Msg(..))

import Browser
import Http
import Internal.CommonRoute as CommonRoute
import Internal.Route as Route
import Internal.StopWordFilter as StopWordFilter
import Internal.Type as Type
import Internal.Utils as Utils
import Keyboard
import Url


type Msg
    = Click Type.ClickData
    | OnResize Int Int
    | ToggleColorMode
    | ToggleLayoutMode
    | ChangeFilter String
    | PageInTopArea Bool
    | KeyUp Keyboard.RawKey
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotData (Result Http.Error (List Type.Repo))
