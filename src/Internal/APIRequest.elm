module Internal.APIRequest exposing
    ( decoderBody
    , request
    )

import HttpBuilder
import Internal.Msg as Msg
import Internal.Type as Type
import Json.Decode
import Json.Decode.Pipeline


request : Cmd Msg.Msg
request =
    "test-api/repos.json"
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decoderBody
        |> HttpBuilder.send Msg.GotData


decoderBody : Json.Decode.Decoder (List Type.Repo)
decoderBody =
    Json.Decode.list decoderRepo


decoderRepo : Json.Decode.Decoder Type.Repo
decoderRepo =
    Json.Decode.succeed Type.Repo
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.optional "description" Json.Decode.string ""
        |> Json.Decode.Pipeline.required "fork" Json.Decode.bool
        |> Json.Decode.Pipeline.required "updated_at" Json.Decode.string
        |> Json.Decode.Pipeline.optional "homepage" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "language" Json.Decode.string ""
