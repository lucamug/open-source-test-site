module Internal.Init exposing (init)

import Browser
import Browser.Navigation
import ElmTextSearch
import Index.Defaults
import Internal.APIRequest as APIRequest
import Internal.CommonRoute as CommonRoute
import Internal.Model as Model exposing (Model)
import Internal.Msg as Msg exposing (Msg(..))
import Internal.Route as Route
import Internal.StopWordFilter as StopWordFilter
import Internal.Utils as Utils
import Keyboard
import StopWordFilter
import Url



-- INIT


init : Msg.Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
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
      , colorMode = Msg.Day
      , layoutMode = Msg.Grid
      , response = Nothing
      }
    , APIRequest.request
    )
