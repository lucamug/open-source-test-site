module ViewHeader exposing (view)

import Conf
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
   ██   ██ ███████  █████  ██████  ███████ ██████
   ██   ██ ██      ██   ██ ██   ██ ██      ██   ██
   ███████ █████   ███████ ██   ██ █████   ██████
   ██   ██ ██      ██   ██ ██   ██ ██      ██   ██
   ██   ██ ███████ ██   ██ ██████  ███████ ██   ██
-}


logo : Model.Model -> Element msg
logo model =
    row [ spacing 7 ]
        [ if Utils.isMobile model then
            el [ moveDown 0 ] <| Icon.icon Icon.Logo_R (Utils.c model .logo) 50

          else
            el [] <| Icon.icon Icon.Logo_Rakuten (Utils.c model .logo) 30
        , if Utils.isMobile model && model.filter /= "" then
            none

          else
            el
                [ Font.color <| Utils.c model .logo
                , Font.size 26
                , Font.letterSpacing -1
                , Font.bold
                , moveUp 4
                ]
            <|
                text "Open Source"
        ]


filterText : { a | width : number } -> String
filterText model =
    if Utils.isMobile model then
        "Filter"

    else
        "Filter by name, description or language"


logoSmall : Model.Model -> Element msg
logoSmall model =
    el [] <| Icon.icon Icon.Logo_R (Utils.c model .logo) 40


filterInputText : Model.Model -> Element Msg.Msg
filterInputText model =
    row [ width fill, spacing 20 ]
        [ Input.text
            [ Border.width 1
            , Border.rounded 5
            , Border.color <| Utils.c model .border
            , Font.size 18
            , width fill
            , Background.color <| Utils.c model .repoBackground
            ]
            { onChange = Msg.ChangeFilter
            , text = Utils.decode model.filter
            , placeholder =
                Just <|
                    Input.placeholder
                        [ Font.color <| Utils.c model .fontLight
                        , moveDown 4
                        ]
                    <|
                        text (filterText model)
            , label = Input.labelHidden (filterText model)
            }
        , if String.length model.filter > 0 then
            Input.button []
                { label = Icon.icon Icon.Icon_Close (Utils.c model .border) Conf.iconSize
                , onPress = Just <| Msg.ChangeFilter ""
                }

          else
            none
        ]


view : Model.Model -> Element Msg.Msg
view model =
    el
        ([ clip
         , width fill
         , Background.color <| Utils.c model .background
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
            , spacing (Utils.paddingResponsive model)
            , htmlAttribute <| Html.Attributes.style "transition" "padding 200ms linear"
            , paddingXY (Utils.paddingResponsive model) 0
            ]
            [ logo model
            , filterInputText model
            ]
