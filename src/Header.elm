module Header exposing (view)

import Color as ElmColor
import Conf
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes
import Internal.CommonRoute as CommonRoute
import Internal.Icon as Icon
import Internal.Shared as Shared exposing (Model, Msg(..))
import Internal.Utils as Utils
import Svg.Attributes as SA



{-
   ██   ██ ███████  █████  ██████  ███████ ██████
   ██   ██ ██      ██   ██ ██   ██ ██      ██   ██
   ███████ █████   ███████ ██   ██ █████   ██████
   ██   ██ ██      ██   ██ ██   ██ ██      ██   ██
   ██   ██ ███████ ██   ██ ██████  ███████ ██   ██
-}


view : Model -> Element Msg
view model =
    el
        ([ clip
         , width fill
         , Background.color <| Conf.c model .background
         , htmlAttribute <| Html.Attributes.style "transition" "all 200ms linear"
         ]
            ++ (if model.pageInTopArea then
                    [ height <| px Conf.headerHeight ]

                else
                    [ height <| px Conf.headerHeightSmall
                    , Border.shadow { offset = ( 0, 0 ), size = 5, blur = 10, color = rgba 0 0 0 0.2 }
                    ]
               )
        )
    <|
        row
            [ width (fill |> maximum Conf.maxWidth)
            , centerX
            , centerY
            , spacing 40
            , htmlAttribute <| Html.Attributes.style "transition" "padding 200ms linear"
            , paddingXY 40 0
            ]
            [ if model.width > 700 then
                el
                    [ Font.size
                        (if model.pageInTopArea then
                            40

                         else
                            30
                        )
                    , width shrink
                    , htmlAttribute <| Html.Attributes.style "transition" "font 200ms linear"
                    ]
                <|
                    row [ spacing 7 ]
                        [ el [] <| Icon.icon Icon.Logo_Rakuten (Conf.c model .logo) 30
                        , el
                            [ Font.color <| Conf.c model .logo
                            , Font.size 26
                            , Font.letterSpacing -1
                            , Font.bold
                            , moveUp 4
                            ]
                          <|
                            text "Open Source"
                        ]

              else
                none
            , row [ width fill, spacing 40 ]
                [ Input.text
                    [ Border.width 1
                    , Border.rounded 5
                    , Border.color <| Conf.c model .border
                    , paddingXY 8 8
                    , Font.size 24
                    , width fill
                    , Background.color <| Conf.c model .background
                    ]
                    { onChange = Shared.ChangeFilter
                    , text = Utils.decode model.filter
                    , placeholder = Just <| Input.placeholder [ Font.color <| Conf.c model .fontLight ] <| text "Filter"
                    , label = Input.labelAbove [] none
                    }
                , if String.length model.filter > 0 then
                    Input.button []
                        { label = Icon.icon Icon.Icon_Close (Conf.c model .font) Conf.iconSize
                        , onPress = Just <| ChangeFilter ""
                        }

                  else
                    none
                , Input.button []
                    { label =
                        Icon.icon
                            (case model.layoutMode of
                                Shared.Grid ->
                                    Icon.Icon_Row

                                Shared.List ->
                                    Icon.Icon_Grid
                            )
                            (Conf.c model .font)
                            Conf.iconSize
                    , onPress = Just ToggleLayoutMode
                    }
                ]
            ]
