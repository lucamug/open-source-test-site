module Internal.View exposing (view)

import Browser
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
import Internal.Model as Model exposing (Model)
import Internal.Msg as Msg exposing (Msg(..))
import Internal.Route as Route
import Internal.Shared as Shared
import Svg.Attributes as SA
import ViewBody
import ViewFooter
import ViewHeader
import ViewRepo



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
                [ Font.typeface "Noto Sans JP"
                , Font.sansSerif
                ]
            , Font.color <| Conf.c model .font
            , Font.size 18
            , Background.color <| Conf.c model .background
            , htmlAttribute <| Html.Attributes.style "transition" "background 1000ms linear"
            , inFront <| ViewHeader.view model
            ]
          <|
            column
                [ paddingEach { top = Conf.headerHeight, right = 0, bottom = 0, left = 0 }
                , spacing 10
                , width fill
                ]
            <|
                [ html <| Html.node "style" [] [ Html.text <| Conf.css ]

                --, paragraph [] [ text <| Debug.toString model.response ]
                , el [ padding 40 ] <|
                    case model.response of
                        Just result ->
                            case result of
                                Ok repos ->
                                    column [ spacing 5 ] <| List.indexedMap (\index repo -> ViewRepo.view model index repo) repos

                                Err err ->
                                    paragraph [] [ text <| Debug.toString model.response ]

                        Nothing ->
                            text "Loading Repos"
                , paragraph
                    [ width (fill |> maximum Conf.maxWidth)
                    , centerX
                    , paddingEach { top = 10, right = 40, bottom = 40, left = 40 }
                    , spacing 8
                    ]
                    ViewBody.view
                , ViewFooter.view model
                ]
        ]
    }
