module Internal.Main exposing (main)

import Browser
import Browser.Events
import Internal.Model as Model exposing (Model)
import Internal.Msg as Msg
import Internal.Port as Port
import Internal.Shared as Shared
import Internal.View as View
import Keyboard


main : Program Shared.Flags Model Msg.Msg
main =
    Browser.application
        { init = Shared.init
        , view = View.view
        , update = Shared.update
        , subscriptions =
            \model ->
                Sub.batch
                    [ Browser.Events.onResize Msg.OnResize
                    , Port.pageInTopArea Msg.PageInTopArea
                    , Keyboard.ups Msg.KeyUp
                    ]
        , onUrlRequest = Msg.LinkClicked
        , onUrlChange = Msg.UrlChanged
        }
