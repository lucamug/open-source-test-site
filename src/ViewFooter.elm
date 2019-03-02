module ViewFooter exposing (view)

import Conf
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font
import Element.Input
import Html exposing (Html)
import Html.Attributes
import Internal.Icon
import Internal.Model exposing (Model)
import Internal.Msg exposing (Msg(..))



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
        , Element.Font.color <| Conf.c model .footerFont
        , Element.Font.size 15
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
                    [ el [ Element.Font.bold ] <| text "GitHub"
                    , column [ spacing 12, Element.Font.color <| Conf.c model .footerFontLight, moveRight 10 ]
                        [ link [] { label = text "Rakuten Technology", url = "https://github.com/rakutentech" }
                        , link [] { label = text "Rakuten Front-end", url = "https://github.com/rakuten-frontend" }
                        , link [] { label = text "Rakuten Web Service", url = "https://github.com/rakuten-ws" }
                        ]
                    , el [ Element.Font.bold ] <| text "Resources"
                    , column [ spacing 12, Element.Font.color <| Conf.c model .footerFontLight, moveRight 10 ]
                        [ link [] { label = text "Rakuten Developers", url = "https://webservice.rakuten.co.jp/" }
                        , link [] { label = text "Rakuten RapidAPI", url = "https://api.rakuten.co.jp/" }
                        ]
                    ]
                , column [ alignRight, spacing 14, alignTop ]
                    [ link [ alignRight ] { label = Internal.Icon.icon Internal.Icon.Logo_Rakuten (Conf.c model .footerFont) 32, url = "https://global.rakuten.com/corp/" }
                    , el [ alignRight, Element.Font.size 15, Element.Font.color <| Conf.c model .footerFontLight ] <| text "© Rakuten, inc."
                    , Element.Input.button [ alignRight, paddingXY 0 20 ]
                        { label =
                            row [ spacing 10 ]
                                [ text "Night Mode"
                                , el
                                    [ width <| px 60
                                    , height <| px 30
                                    , Border.rounded 14
                                    , Background.color <|
                                        rgb255 150 150 150
                                    , inFront <|
                                        el
                                            [ width <| px 26
                                            , height <| px 26
                                            , Border.rounded 13
                                            , htmlAttribute <| Html.Attributes.style "transition" "all 100ms linear"
                                            , Background.color <|
                                                rgb255 10 10 10
                                            , moveRight <|
                                                if model.localStorage.nightMode then
                                                    32

                                                else
                                                    3
                                            , moveDown 2
                                            ]
                                        <|
                                            none
                                    ]
                                  <|
                                    none
                                ]
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
