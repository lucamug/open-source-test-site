module Internal.Init exposing (init)

import Browser.Navigation
import Internal.APIRequest as APIRequest
import Internal.CommonRoute as CommonRoute
import Internal.Model as Model exposing (Model)
import Internal.Msg as Msg exposing (Msg(..))
import Internal.Route as Route
import Internal.StopWordFilter as StopWordFilter
import Internal.Type as Type
import Internal.Utils as Utils
import Url



-- INIT


init : Type.Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        filter =
            case CommonRoute.fromUrl Route.conf url of
                Route.Filter filter_ ->
                    filter_

                _ ->
                    ""
    in
    ( { url = url
      , key = key
      , filter = filter
      , width = flags.width
      , pageInTopArea = True
      , colorMode = Type.Day
      , layoutMode = Type.Grid
      , response = Nothing
      }
    , APIRequest.request
    )
