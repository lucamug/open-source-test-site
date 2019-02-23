module Footer exposing (view)

import Color as ElmColor
import Conf
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Internal.CommonRoute as CommonRoute
import Internal.Icon as Icon
import Internal.Shared as Shared exposing (Model, Msg(..))
import Svg.Attributes as SA



{-
   ███████  ██████   ██████  ████████ ███████ ██████
   ██      ██    ██ ██    ██    ██    ██      ██   ██
   █████   ██    ██ ██    ██    ██    █████   ██████
   ██      ██    ██ ██    ██    ██    ██      ██   ██
   ██       ██████   ██████     ██    ███████ ██   ██
-}


view : Model -> Element Msg
view model =
    el
        [ centerX
        , paddingXY 20 60
        , Background.color <| Conf.c model .footerBackground
        , width fill
        , Font.color <| Conf.c model .footerFont
        , Font.size 15
        ]
    <|
        column
            [ width (fill |> maximum 500)
            , centerX
            , spacing 60
            ]
            [ row
                [ width fill ]
                [ column [ spacing 30 ]
                    [ el [ Font.bold ] <| text "GitHub"
                    , column [ spacing 12, Font.color <| Conf.c model .footerFontLight, moveRight 10 ]
                        [ link [] { label = text "Rakuten Technology", url = "https://github.com/rakutentech" }
                        , link [] { label = text "Rakuten Front-end", url = "https://github.com/rakuten-frontend" }
                        , link [] { label = text "Rakuten Web Service", url = "https://github.com/rakuten-ws" }
                        ]
                    , el [ Font.bold ] <| text "Resources"
                    , column [ spacing 12, Font.color <| Conf.c model .footerFontLight, moveRight 10 ]
                        [ link [] { label = text "Rakuten Developers", url = "https://webservice.rakuten.co.jp/" }
                        , link [] { label = text "Rakuten RapidAPI", url = "https://api.rakuten.co.jp/" }
                        ]
                    ]
                , column [ alignRight, spacing 14, alignTop ]
                    [ link [ alignRight ] { label = Icon.icon Icon.Logo_Rakuten (Conf.c model .footerFont) 32, url = "https://global.rakuten.com/corp/" }
                    , el [ Font.size 15, Font.color <| Conf.c model .footerFontLight ] <| text "© Rakuten, inc."
                    , Input.button [ alignRight, paddingXY 0 20 ]
                        { label = Icon.icon Icon.Icon_PlusL (Conf.c model .footerFontLight) Conf.iconSize
                        , onPress = Just ToggleColorMode
                        }
                    ]
                ]
            , row [ spacing 30, centerX ]
                [ link [] { label = text "About", url = "https://global.rakuten.com/corp/" }
                , link [] { label = text "Careers", url = "https://rakuten.careers/" }
                , link [] { label = text "Contact", url = "mailto:dev-opensource@mail.rakuten.com" }
                ]
            ]
