module Internal.Type exposing
    ( ClickData
    , ColorMode(..)
    , Flags
    , LayoutMode(..)
    , Repo
    )

import Internal.CommonRoute
import Internal.StopWordFilter as StopWordFilter
import Internal.Utils


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
