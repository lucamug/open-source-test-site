port module Internal.Port exposing
    ( elmToLocalStorage
    , onStoreChange
    , pageInTopArea
    , toLocalStorage
    )

import Internal.Type
import Json.Encode


port pageInTopArea : (Bool -> msg) -> Sub msg


port onStoreChange : (String -> msg) -> Sub msg


port elmToLocalStorage : Maybe String -> Cmd msg


toLocalStorage : { a | nightMode : Bool } -> Cmd msg
toLocalStorage data =
    let
        json =
            Json.Encode.object
                [ ( "nightMode", Json.Encode.bool data.nightMode )
                ]

        string =
            Json.Encode.encode 0 json
    in
    elmToLocalStorage <| Just string



-- decoder_ : Json.Decode.Decoder Username
-- decoder_ =
--     Json.Decode.map Username Json.Decode.string
--
--
-- credDecoder : Json.Decode.Decoder Cred
-- credDecoder =
--     Json.Decode.succeed Cred
--         |> Json.Decode.Pipeline.required "username" decoder_
--         |> Json.Decode.Pipeline.required "token" Json.Decode.string
--
--
-- decoderFromCred : Json.Decode.Decoder (Cred -> a) -> Json.Decode.Decoder a
-- decoderFromCred decoder =
--     Json.Decode.map2 (\fromCred cred -> fromCred cred)
--         decoder
--         credDecoder
--
--
-- storageDecoder : Json.Decode.Decoder (Cred -> viewer) -> Json.Decode.Decoder viewer
-- storageDecoder viewerDecoder =
--     Json.Decode.field "user" (decoderFromCred viewerDecoder)
--
--
-- decodeFromChange : Json.Decode.Decoder (Cred -> viewer) -> Json.Decode.Value -> Maybe viewer
-- decodeFromChange viewerDecoder val =
--     -- It's stored in localStorage as a JSON String;
--     -- first decode the Value as a String, then
--     -- decode that String as JSON.
--     Json.Decode.decodeValue (storageDecoder viewerDecoder) val
--         |> Result.toMaybe
--
--
-- viewerChanges : (Maybe viewer -> msg) -> Json.Decode.Decoder (Cred -> viewer) -> Sub msg
-- viewerChanges toMsg decoder =
--     onStoreChange (\value -> toMsg (decodeFromChange decoder value))
--
--
-- type Cred
--     = Cred Username String
--
--
-- type Username
--     = Username String
