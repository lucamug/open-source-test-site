module Internal.View exposing (view)

import Browser
import Color as ElmColor
import Conf
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Footer
import Header
import Html exposing (Html)
import Html.Attributes
import Internal.CommonRoute as CommonRoute
import Internal.Route as Route
import Internal.Shared as Shared exposing (Model, Msg(..))
import Svg.Attributes as SA



{-
   ██   ██ ███████ ██      ██████  ███████ ██████  ███████
   ██   ██ ██      ██      ██   ██ ██      ██   ██ ██
   ███████ █████   ██      ██████  █████   ██████  ███████
   ██   ██ ██      ██      ██      ██      ██   ██      ██
   ██   ██ ███████ ███████ ██      ███████ ██   ██ ███████
-}
-- HELPERS


elementColorToElmColor : Element.Color -> ElmColor.Color
elementColorToElmColor elementColor =
    ElmColor.fromRgba <| Element.toRgb elementColor



{-
   ██    ██ ██ ███████ ██     ██
   ██    ██ ██ ██      ██     ██
   ██    ██ ██ █████   ██  █  ██
    ██  ██  ██ ██      ██ ███ ██
     ████   ██ ███████  ███ ███
-}


css =
    """
.animatedItem {
    transition: all 100ms linear;
}
.animatedItem:hover {
    transform: scale(1.7, 1.7);
    z-index: 1;
}
"""


view : Model -> Browser.Document Msg
view model =
    let
        route =
            CommonRoute.fromUrl Route.conf model.url
    in
    { title = "Rakuten Open Source"
    , body =
        [ layoutWith
            { options =
                [ focusStyle
                    { borderColor = Nothing
                    , backgroundColor = Nothing
                    , shadow =
                        Nothing
                    }
                ]
            }
            [ width fill
            , Font.family
                [ Font.typeface "Noto Sans JP"
                , Font.sansSerif
                ]
            , Font.color <| Conf.c model .font
            , Font.size 18
            , Background.color <| Conf.c model .background
            , htmlAttribute <| Html.Attributes.style "transition" "background 1000ms linear"
            , inFront <| Header.view model
            ]
          <|
            column
                [ paddingEach { top = Conf.headerHeight + 20, right = 0, bottom = 0, left = 0 }
                , spacing 10
                , width fill

                --, Border.shadow { offset = ( 0, 0 ), size = 5, blur = 10, color = rgba 0 0 0 0.2 }
                ]
            <|
                [ html <| Html.node "style" [] [ Html.text <| css ]
                , paragraph
                    [ width (fill |> maximum Conf.maxWidth)
                    , centerX
                    , padding 40
                    , spacing 8
                    ]
                    [ el
                        [ alignLeft
                        , paddingXY 10 0
                        , Font.size 60
                        ]
                        (text "L")
                    , text "orem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suscipit nunc risus, aliquet viverra urna tincidunt a. Nulla non augue ipsum. Vestibulum eget rutrum purus, id dictum quam. Morbi lacinia purus nec pellentesque molestie. In id metus imperdiet, pulvinar libero ac, accumsan mauris. Nullam laoreet purus sed odio auctor venenatis. Aliquam commodo, mauris a maximus cursus, dui nisi iaculis diam, a varius velit enim sit amet nisi. Suspendisse ac porttitor augue, et egestas sapien. Sed ac scelerisque ex, vel malesuada ex. Maecenas id mi pretium, blandit mi in, efficitur massa. Proin at sapien dui. Sed lectus diam, dapibus eu semper facilisis, semper nec odio. Sed sollicitudin orci a pulvinar consequat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae."
                    ]
                , Footer.view model
                ]
        ]
    }
