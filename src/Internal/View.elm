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

        attrsContainer =
            [ width (fill |> maximum Conf.maxWidth)
            , centerX
            , paddingXY 10 40
            ]
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
                , el [ width fill, height <| px 190, clip ] <| image [ width fill ] { src = "img/background2.png", description = "Coding..." }
                , column
                    [ Font.size 30
                    , paddingXY 40 40
                    , moveDown 40
                    , width (fill |> maximum 600)
                    , centerX
                    , spacing 10
                    , Font.center
                    ]
                    [ row [ centerX ]
                        [ el [ Font.size 70 ] <| text "“"
                        , text "Contribute to society by"
                        ]
                    , row [ centerX, moveUp 30 ]
                        [ text "creating value through innovation"
                        , el [ Font.size 70, moveDown 30 ] <| text "”"
                        ]
                    ]
                , paragraph
                    [ spacing 8
                    , width (fill |> maximum 800)
                    , padding 20
                    , centerX
                    ]
                    ViewBody.view
                , el attrsContainer <|
                    case model.response of
                        Just result ->
                            case result of
                                Ok repos ->
                                    column [ spacing 5 ] <| List.indexedMap (\index repo -> ViewRepo.view model index repo) repos

                                Err err ->
                                    paragraph [] [ text <| "Error" ]

                        Nothing ->
                            text "Loading Repos"
                , el [ height <| px 60 ] none
                , ViewFooter.view model
                ]
        ]
    }
