module Internal.Main exposing (main)

import Browser
import Browser.Events
import Internal.Port as Port
import Internal.Shared as Shared
import Internal.View as View
import Keyboard


main : Program Shared.Flags Shared.Model Shared.Msg
main =
    Browser.application
        { init = Shared.init
        , view = View.view
        , update = Shared.update
        , subscriptions =
            \model ->
                Sub.batch
                    [ Browser.Events.onResize Shared.OnResize
                    , Port.pageInTopArea Shared.PageInTopArea
                    , Keyboard.ups Shared.KeyUp
                    ]
        , onUrlRequest = Shared.LinkClicked
        , onUrlChange = Shared.UrlChanged
        }
