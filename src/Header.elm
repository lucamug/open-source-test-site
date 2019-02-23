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
import Icon
import Internal.CommonRoute as CommonRoute
import Internal.Shared as Shared exposing (Model, Msg(..))
import Svg.Attributes as SA
import Utils



{-
   ██   ██ ███████  █████  ██████  ███████ ██████
   ██   ██ ██      ██   ██ ██   ██ ██      ██   ██
   ███████ █████   ███████ ██   ██ █████   ██████
   ██   ██ ██      ██   ██ ██   ██ ██      ██   ██
   ██   ██ ███████ ██   ██ ██████  ███████ ██   ██
-}


view : Model -> Element Msg
view model =
    let
        iconSize =
            32
    in
    el
        [ height <|
            px
                (if model.pageInTopArea then
                    Conf.headerHeight

                 else
                    Conf.headerHeight - 20
                )
        , clip
        , width fill
        , Background.color <| Conf.c model .background
        , Border.shadow { offset = ( 0, 0 ), size = 5, blur = 10, color = rgba 0 0 0 0.2 }
        , htmlAttribute <| Html.Attributes.style "transition" "height 200ms linear"
        , htmlAttribute <| Html.Attributes.style "transition" "background 1000ms linear"
        ]
    <|
        row
            [ width (fill |> maximum Conf.maxWidth)
            , centerX
            , spacing 40
            , htmlAttribute <| Html.Attributes.style "transition" "padding 200ms linear"
            , padding <|
                if model.pageInTopArea then
                    20

                else
                    10
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
            , row [ width fill, spacing 10 ]
                [ Input.text
                    [ Border.widthEach { bottom = 2, left = 0, right = 0, top = 0 }
                    , paddingXY 8 8
                    , Font.size 24
                    , width fill
                    , Background.color <| Conf.c model .background
                    , Border.color <| Conf.c model .background
                    ]
                    { onChange = Shared.ChangeFilter
                    , text = Utils.decode model.filter
                    , placeholder = Just <| Input.placeholder [ Font.color <| Conf.c model .fontLight ] <| text "Filter"
                    , label = Input.labelAbove [] none
                    }
                , if String.length model.filter > 0 then
                    Input.button []
                        { label = Icon.icon Icon.Icon_Close (Conf.c model .font) iconSize
                        , onPress = Just <| ChangeFilter ""
                        }

                  else
                    none
                , Input.button []
                    { label = Icon.icon Icon.Icon_PlusL (Conf.c model .font) iconSize
                    , onPress = Just ToggleColorMode
                    }
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
                            iconSize
                    , onPress = Just ToggleLayoutMode
                    }
                , Input.button []
                    { label = Icon.icon Icon.Icon_Plus (Conf.c model .font) iconSize
                    , onPress = Just DecreaseSquareQuantity
                    }
                , Input.button []
                    { label = Icon.icon Icon.Icon_Minus (Conf.c model .font) iconSize
                    , onPress = Just IncreaseSquareQuantity
                    }
                , newTabLink []
                    { label = Icon.icon Icon.Icon_Github (Conf.c model .font) iconSize
                    , url = "https://github.com/lucamug/elm-resources"
                    }
                ]
            ]
