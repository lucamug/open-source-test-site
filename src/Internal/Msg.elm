module Internal.Msg exposing
    ( ClickData
    , ColorMode(..)
    , Flags
    , LayoutMode(..)
    , Msg(..)
    , Repo
    )

import Browser
import Http
import Internal.CommonRoute as CommonRoute
import Internal.Route as Route
import Internal.StopWordFilter as StopWordFilter
import Internal.Utils as Utils
import Keyboard
import Url



-- OTHER TYPES


type alias Flags =
    { width : Int
    }


type ColorMode
    = Day
    | Night


type LayoutMode
    = List
    | Grid


type alias ClickData =
    { id1 : String
    , id2 : String
    , id3 : String
    , id4 : String
    , id5 : String
    }


type alias Repo =
    { name : String
    , description : String
    , fork : Bool
    , updated_at : String
    , homepage : String
    , language : String
    }



-- MSG


type Msg
    = Click ClickData
    | OnResize Int Int
    | ToggleColorMode
    | ToggleLayoutMode
    | ChangeFilter String
    | PageInTopArea Bool
    | KeyUp Keyboard.RawKey
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotData (Result Http.Error (List Repo))
