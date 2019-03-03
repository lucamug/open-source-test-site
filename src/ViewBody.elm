module ViewBody exposing
    ( view
    , viewTagline
    )

import Element exposing (..)
import Element.Font as Font
import Html exposing (Html)
import Internal.Model exposing (Model)
import Internal.Msg exposing (Msg(..))
import Internal.Utils as Utils



{-
   ██████   ██████  ██████  ██    ██
   ██   ██ ██    ██ ██   ██  ██  ██
   ██████  ██    ██ ██   ██   ████
   ██   ██ ██    ██ ██   ██    ██
   ██████   ██████  ██████     ██
-}


viewTagline : { a | width : number } -> Element msg
viewTagline model =
    if Utils.isMobile model then
        paragraph
            [ Font.size 30
            , paddingXY 40 40
            , moveDown 40
            , width (fill |> maximum 600)
            , centerX
            , spacing 10
            , Font.center
            ]
            [ el [] <| text "“"
            , text "Contribute to society by creating value through innovation"
            , el [] <| text "”"
            ]

    else
        column
            [ Font.size 30
            , paddingXY 40 40
            , moveDown 40
            , width (fill |> maximum 600)
            , centerX
            , spacing 10
            , Font.center
            ]
            [ row [ centerX ]
                [ el [ Font.size 70 ] <| text "“"
                , text "Contribute to society by"
                ]
            , row [ centerX, moveUp 30 ]
                [ text "creating value through innovation"
                , el [ Font.size 70, moveDown 30 ] <| text "”"
                ]
            ]


view : List (Element msg)
view =
    [ el
        [ alignLeft
        , paddingEach { top = 0, right = 10, bottom = 0, left = 0 }
        , Font.size 60
        ]
        (text "L")
    , text "orem ipsum dolor sit amet, consectetur adipiscing elit. Aenean suscipit nunc risus, aliquet viverra urna tincidunt a. Nulla non augue ipsum. Vestibulum eget rutrum purus, id dictum quam. Morbi lacinia purus nec pellentesque molestie. In id metus imperdiet, pulvinar libero ac, accumsan mauris. Nullam laoreet purus sed odio auctor venenatis. Aliquam commodo, mauris a maximus cursus, dui nisi iaculis diam, a varius velit enim sit amet nisi."

    --, text "Suspendisse ac porttitor augue, et egestas sapien. Sed ac scelerisque ex, vel malesuada ex. Maecenas id mi pretium, blandit mi in, efficitur massa. Proin at sapien dui. Sed lectus diam, dapibus eu semper facilisis, semper nec odio. Sed sollicitudin orci a pulvinar consequat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae."
    ]
