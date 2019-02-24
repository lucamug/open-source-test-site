module Internal.Main exposing (main)

import Browser
import Browser.Events
import Internal.Init as Init
import Internal.Model exposing (Model)
import Internal.Msg as Msg
import Internal.Port as Port
import Internal.Type as Type
import Internal.Update as Update
import Internal.View as View
import Keyboard


main : Program Type.Flags Model Msg.Msg
main =
    Browser.application
        { init = Init.init
        , view = View.view
        , update = Update.update
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
