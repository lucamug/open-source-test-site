module View exposing (view)

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
import Internal.Shared as Shared exposing (Model, Msg(..))
import Route
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
                [ Font.typeface "Noto Sans Japanese"
                , Font.sansSerif
                ]
            , Font.color <| Conf.c model .font
            , inFront <| Header.view model
            , Background.color <| Conf.c model .background
            , htmlAttribute <| Html.Attributes.style "transition" "background 1000ms linear"
            ]
          <|
            column
                [ paddingEach { top = Conf.headerHeight + 20, right = 20, bottom = 20, left = 20 }
                , spacing 10
                , width (fill |> maximum 800)
                , centerX
                , Border.shadow { offset = ( 0, 0 ), size = 5, blur = 10, color = rgba 0 0 0 0.2 }
                ]
            <|
                [ html <|
                    Html.node "style"
                        []
                        [ Html.text <| """
                        .animatedItem {
                            transition: all 100ms linear;
                        }
                        .animatedItem:hover {
                            transform: scale(1.7, 1.7);
                            z-index: 1;
                        }
                        """
                        ]
                , Footer.view
                ]
        ]
    }
