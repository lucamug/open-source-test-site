module ViewHeader exposing (view)

import Conf
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes
import Internal.Icon as Icon
import Internal.Model exposing (Model)
import Internal.Msg exposing (Msg(..))
import Internal.Type
import Internal.Utils as Utils



{-
   ██   ██ ███████  █████  ██████  ███████ ██████
   ██   ██ ██      ██   ██ ██   ██ ██      ██   ██
   ███████ █████   ███████ ██   ██ █████   ██████
   ██   ██ ██      ██   ██ ██   ██ ██      ██   ██
   ██   ██ ███████ ██   ██ ██████  ███████ ██   ██
-}


logo : Model -> Element msg
logo model =
    row [ spacing 7 ]
        [ if Utils.isMobile model then
            el [ moveDown 0 ] <| Icon.icon Icon.Logo_R (Conf.c model .logo) 50

          else
            el [] <| Icon.icon Icon.Logo_Rakuten (Conf.c model .logo) 30
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


filterText : { a | width : number } -> String
filterText model =
    if Utils.isMobile model then
        "Filter"

    else
        "Filter by name, description or language"


logoSmall : Model -> Element msg
logoSmall model =
    el [] <| Icon.icon Icon.Logo_R (Conf.c model .logo) 40


filterInputText : Model -> Element Msg
filterInputText model =
    row [ width fill, spacing 20 ]
        [ Input.text
            [ Border.width 1
            , Border.rounded 5
            , Border.color <| Conf.c model .border
            , paddingXY 8 8
            , Font.size 20
            , width fill
            , Background.color <| Conf.c model .background
            ]
            { onChange = Internal.Msg.ChangeFilter
            , text = Utils.decode model.filter
            , placeholder = Just <| Input.placeholder [ moveDown 4, clip, Font.color <| Conf.c model .fontLight ] <| text (filterText model)
            , label = Input.labelHidden (filterText model)
            }
        , if String.length model.filter > 0 then
            Input.button []
                { label = Icon.icon Icon.Icon_Close (Conf.c model .font) Conf.iconSize
                , onPress = Just <| ChangeFilter ""
                }

          else
            none
        ]


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
            , spacing (Utils.paddingResponsive model)
            , htmlAttribute <| Html.Attributes.style "transition" "padding 200ms linear"
            , paddingXY (Utils.paddingResponsive model) 0
            ]
            [ logo model
            , filterInputText model
            ]
