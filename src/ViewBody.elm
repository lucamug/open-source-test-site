module ViewBody exposing (view)

import Color as ElmColor
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Internal.CommonRoute as CommonRoute
import Internal.Model as Model exposing (Model)
import Internal.Msg as Msg exposing (Msg(..))
import Internal.Route as Route
import Internal.Shared as Shared
import Svg.Attributes as SA



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
        , Font.size 60
        ]
        (text "L")
    , text "orem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suscipit nunc risus, aliquet viverra urna tincidunt a. Nulla non augue ipsum. Vestibulum eget rutrum purus, id dictum quam. Morbi lacinia purus nec pellentesque molestie. In id metus imperdiet, pulvinar libero ac, accumsan mauris. Nullam laoreet purus sed odio auctor venenatis. Aliquam commodo, mauris a maximus cursus, dui nisi iaculis diam, a varius velit enim sit amet nisi."
    , text "Suspendisse ac porttitor augue, et egestas sapien. Sed ac scelerisque ex, vel malesuada ex. Maecenas id mi pretium, blandit mi in, efficitur massa. Proin at sapien dui. Sed lectus diam, dapibus eu semper facilisis, semper nec odio. Sed sollicitudin orci a pulvinar consequat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae."
    ]
