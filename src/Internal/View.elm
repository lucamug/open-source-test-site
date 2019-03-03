module Internal.View exposing (view)

import Browser
import Conf
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes
import Internal.CommonRoute as CommonRoute
import Internal.Model exposing (Model)
import Internal.Msg exposing (Msg(..))
import Internal.Route as Route
import Internal.Type as Type
import Repos
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


attrsRepoContainer : Model -> List (Attribute msg)
attrsRepoContainer model =
    [ width fill
    , height fill
    , alignTop
    , Border.rounded 10
    , padding 20
    , Background.color <| Conf.c model .repoBackground
    , Border.shadow { offset = ( 2, 2 ), size = 2, blur = 10, color = Conf.c model .repoShadow }
    ]


attrsRow : Model -> List (Attribute msg)
attrsRow model =
    [ width fill
    , spacing 20
    ]


repoCell : Model -> Type.Repo -> Element msg
repoCell model repo =
    link (attrsRepoContainer model)
        { url = repo.html_url
        , label = ViewRepo.view model 0 repo
        }


viewFirstOne : Model -> List Type.Repo -> List (Element msg)
viewFirstOne model repos =
    List.map (\repo -> repoCell model repo) repos


viewFirstTwo : Model -> List Type.Repo -> List (Element msg)
viewFirstTwo model repos =
    case repos of
        [] ->
            []

        x :: [] ->
            [ repoCell model x ]

        x :: y :: xs ->
            [ row
                (attrsRow model)
                [ repoCell model x
                , repoCell model y
                ]
            ]
                ++ viewFirstTwo model xs


viewFirstThree : Model -> List Type.Repo -> List (Element msg)
viewFirstThree model repos =
    case repos of
        [] ->
            []

        x :: [] ->
            [ repoCell model x ]

        x :: y :: [] ->
            [ row
                (attrsRow model)
                [ repoCell model x
                , repoCell model y
                ]
            ]

        x :: y :: z :: xs ->
            [ row
                (attrsRow model)
                [ repoCell model x
                , repoCell model y
                , repoCell model z
                ]
            ]
                ++ viewFirstThree model xs


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
                , el
                    [ width fill
                    , height <| px 190
                    , Background.image <|
                        if model.localStorage.nightMode then
                            "img/backgroundDark.png"

                        else
                            "img/backgroundBright.png"
                    ]
                  <|
                    none
                , ViewBody.viewTagline model
                , paragraph
                    [ spacing 8
                    , width (fill |> maximum 800)
                    , padding 20
                    , centerX
                    ]
                    ViewBody.view
                , case model.response of
                    Just result ->
                        case result of
                            Ok repos ->
                                column
                                    [ centerX
                                    , width (fill |> maximum Conf.maxWidth)
                                    , spacing 30
                                    , padding 20
                                    ]
                                <|
                                    (if model.width < 600 then
                                        viewFirstOne

                                     else if model.width < 900 then
                                        viewFirstTwo

                                     else
                                        viewFirstThree
                                    )
                                        model
                                        (Repos.repos ++ repos)

                            Err _ ->
                                none

                    Nothing ->
                        el [ centerX ] <| text "Loading repositories..."
                , el [ height <| px 60 ] none
                , ViewFooter.view model
                ]
        ]
    }
