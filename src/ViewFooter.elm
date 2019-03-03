module ViewFooter exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import Internal.Icon as Icon
import Internal.Model as Model
import Internal.Msg as Msg
import Internal.Utils as Utils



{-
   ███████  ██████   ██████  ████████ ███████ ██████
   ██      ██    ██ ██    ██    ██    ██      ██   ██
   █████   ██    ██ ██    ██    ██    █████   ██████
   ██      ██    ██ ██    ██    ██    ██      ██   ██
   ██       ██████   ██████     ██    ███████ ██   ██
-}


view : Model.Model -> Element Msg.Msg
view model =
    let
        alignL =
            if Utils.isMobile model then
                centerX

            else
                alignLeft

        alignR =
            if Utils.isMobile model then
                centerX

            else
                alignRight
    in
    el
        [ centerX
        , paddingXY 20 60
        , Background.color <| Utils.c model .footerBackground
        , width fill
        , Font.color <| Utils.c model .footerFont
        , Font.size 15
        ]
    <|
        column
            [ width (fill |> maximum 500)
            , centerX
            , spacing 60
            ]
            [ column
                [ width fill
                , explain Debug.todo
                ]
                [ column
                    [ spacing 30
                    , alignL
                    ]
                    [ el [ Font.bold ] <| text "GitHub"
                    , column [ spacing 12, Font.color <| Utils.c model .footerFontLight, moveRight 10 ]
                        [ link [] { label = text "Rakuten Technology", url = "https://github.com/rakutentech" }
                        , link [] { label = text "Rakuten Front-end", url = "https://github.com/rakuten-frontend" }
                        , link [] { label = text "Rakuten Web Service", url = "https://github.com/rakuten-ws" }
                        ]
                    , el [ Font.bold ] <| text "Resources"
                    , column [ spacing 12, Font.color <| Utils.c model .footerFontLight, moveRight 10 ]
                        [ link [] { label = text "Rakuten Developers", url = "https://webservice.rakuten.co.jp/" }
                        , link [] { label = text "Rakuten RapidAPI", url = "https://api.rakuten.co.jp/" }
                        ]
                    ]
                , column [ alignR, spacing 14, alignTop ]
                    [ link [ alignR ] { label = Icon.icon Icon.Logo_Rakuten (Utils.c model .footerFont) 32, url = "https://global.rakuten.com/corp/" }
                    , el [ alignR, Font.size 15, Font.color <| Utils.c model .footerFontLight ] <| text "© Rakuten, inc."
                    , Input.button [ alignR, paddingXY 0 20 ]
                        { label =
                            row [ spacing 10 ]
                                [ text "Night mode"
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
                        , onPress = Just Msg.ToggleColorMode
                        }
                    ]
                ]
            , row [ spacing 30, centerX ]
                [ link [] { label = text "About", url = "https://global.rakuten.com/corp/" }
                , link [] { label = text "Careers", url = "https://rakuten.careers/" }
                , link [] { label = text "Contact", url = "mailto:dev-opensource@mail.rakuten.com" }
                ]
            ]
