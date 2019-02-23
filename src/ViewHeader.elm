module ViewHeader exposing (view)

import Conf
import Element exposing (..)
import Element.Background
import Element.Border
import Element.Font
import Element.Input
import Html exposing (Html)
import Html.Attributes
import Internal.Icon
import Internal.Model exposing (Model)
import Internal.Msg exposing (Msg(..))
import Internal.Utils



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
         , Element.Background.color <| Conf.c model .background
         , htmlAttribute <| Html.Attributes.style "transition" "all 200ms linear"
         ]
            ++ (if model.pageInTopArea then
                    [ height <| px Conf.headerHeight ]

                else
                    [ height <| px Conf.headerHeightSmall
                    , Element.Border.shadow { offset = ( 0, 0 ), size = 5, blur = 10, color = rgba 0 0 0 0.2 }
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
                    [ Element.Font.size
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
                        [ el [] <| Internal.Icon.icon Internal.Icon.Logo_Rakuten (Conf.c model .logo) 30
                        , el
                            [ Element.Font.color <| Conf.c model .logo
                            , Element.Font.size 26
                            , Element.Font.letterSpacing -1
                            , Element.Font.bold
                            , moveUp 4
                            ]
                          <|
                            text "Open Source"
                        ]

              else
                none
            , row [ width fill, spacing 40 ]
                [ Element.Input.text
                    [ Element.Border.width 1
                    , Element.Border.rounded 5
                    , Element.Border.color <| Conf.c model .border
                    , paddingXY 8 8
                    , Element.Font.size 20
                    , width fill
                    , Element.Background.color <| Conf.c model .background
                    ]
                    { onChange = Internal.Msg.ChangeFilter
                    , text = Internal.Utils.decode model.filter
                    , placeholder = Just <| Element.Input.placeholder [ Element.Font.color <| Conf.c model .fontLight ] <| text "Filter by repository name, description or language"
                    , label = Element.Input.labelAbove [] none
                    }
                , if String.length model.filter > 0 then
                    Element.Input.button []
                        { label = Internal.Icon.icon Internal.Icon.Icon_Close (Conf.c model .font) Conf.iconSize
                        , onPress = Just <| ChangeFilter ""
                        }

                  else
                    none
                , Element.Input.button []
                    { label =
                        Internal.Icon.icon
                            (case model.layoutMode of
                                Internal.Msg.Grid ->
                                    Internal.Icon.Icon_Row

                                Internal.Msg.List ->
                                    Internal.Icon.Icon_Grid
                            )
                            (Conf.c model .font)
                            Conf.iconSize
                    , onPress = Just ToggleLayoutMode
                    }
                ]
            ]
