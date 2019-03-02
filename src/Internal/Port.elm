port module Internal.Port exposing
    ( onStoreChange
    , pageInTopArea
    , storeCache
    , storeFlags
    )

import Internal.Type as Type
import Json.Encode


port pageInTopArea : (Bool -> msg) -> Sub msg


port onStoreChange : (Json.Encode.Value -> msg) -> Sub msg


port storeCache : Maybe Json.Encode.Value -> Cmd msg


storeFlags : Bool -> Cmd msg
storeFlags nightMode =
    let
        json =
            Json.Encode.object
                [ ( "nightMode", Json.Encode.bool nightMode )
                ]
    in
    storeCache (Just json)
