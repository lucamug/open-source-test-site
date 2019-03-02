module Internal.Type exposing
    ( ClickData
    , ColorMode(..)
    , Flags
    , LayoutMode(..)
    , Repo
    )


type alias Flags =
    { width : Int
    , nightMode : Bool
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
