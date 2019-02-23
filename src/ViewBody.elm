module ViewBody exposing (view)

import Element exposing (..)
import Element.Font
import Html exposing (Html)
import Internal.Model exposing (Model)
import Internal.Msg exposing (Msg(..))



{-
   ██████   ██████  ██████  ██    ██
   ██   ██ ██    ██ ██   ██  ██  ██
   ██████  ██    ██ ██   ██   ████
   ██   ██ ██    ██ ██   ██    ██
   ██████   ██████  ██████     ██
-}


view : List (Element msg)
view =
    [ el
        [ alignLeft
        , paddingEach { top = 0, right = 10, bottom = 0, left = 0 }
        , Element.Font.size 60
        ]
        (text "L")
    , text "orem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suscipit nunc risus, aliquet viverra urna tincidunt a. Nulla non augue ipsum. Vestibulum eget rutrum purus, id dictum quam. Morbi lacinia purus nec pellentesque molestie. In id metus imperdiet, pulvinar libero ac, accumsan mauris. Nullam laoreet purus sed odio auctor venenatis. Aliquam commodo, mauris a maximus cursus, dui nisi iaculis diam, a varius velit enim sit amet nisi."

    --, text "Suspendisse ac porttitor augue, et egestas sapien. Sed ac scelerisque ex, vel malesuada ex. Maecenas id mi pretium, blandit mi in, efficitur massa. Proin at sapien dui. Sed lectus diam, dapibus eu semper facilisis, semper nec odio. Sed sollicitudin orci a pulvinar consequat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae."
    ]
