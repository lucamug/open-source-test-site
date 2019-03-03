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
import Internal.Model as Model
import Internal.Msg exposing (Msg(..))
import Internal.Route as Route
import Internal.Search as Search
import Internal.Type as Type
import Internal.Utils as Utils
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


attrsRepoContainer : Model.Model -> List (Attribute msg)
attrsRepoContainer model =
    [ width fill
    , height fill
    , alignTop
    , Border.rounded 10
    , padding 20
    , Background.color <| Utils.c model .repoBackground
    , Border.shadow { offset = ( 2, 2 ), size = 2, blur = 10, color = Utils.c model .repoShadow }
    ]


attrsRow : Model.Model -> List (Attribute msg)
attrsRow model =
    [ width fill
    , spacing 20
    ]


repoCell : Model.Model -> Type.Repo -> Element msg
repoCell model repo =
    link (attrsRepoContainer model)
        { url = repo.html_url
        , label = ViewRepo.view model 0 repo
        }


viewFirstOne : Model.Model -> List Type.Repo -> List (Element msg)
viewFirstOne model repos =
    List.map (\repo -> repoCell model repo) repos


viewFirstTwo : Model.Model -> List Type.Repo -> List (Element msg)
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


viewFirstThree : Model.Model -> List Type.Repo -> List (Element msg)
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


viewIntroduction : Model.Model -> Element msg
viewIntroduction model =
    column [ width fill ]
        [ el
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
        ]


viewRepos : Model.Model -> Element msg
viewRepos model =
    let
        repos =
            Search.filteredRepos model

        length =
            List.length repos
    in
    column
        [ centerX
        , width (fill |> maximum Conf.maxWidth)
        , spacing 30
        , padding 20
        ]
    <|
        if length == 0 then
            [ el [ centerX, paddingXY 0 100 ] <| text <| "No Repositories found for the filter \"" ++ model.filter ++ "\"" ]

        else
            [ el [] <| text <| String.fromInt length ++ " repositories" ]
                ++ (if model.width < 600 then
                        viewFirstOne

                    else if model.width < 900 then
                        viewFirstTwo

                    else
                        viewFirstThree
                   )
                    model
                    repos


view : Model.Model -> Browser.Document Msg
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
            , Font.color <| Utils.c model .font
            , Font.size 18
            , Background.color <| Utils.c model .background
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
                , if model.filter == "" then
                    viewIntroduction model

                  else
                    none
                , viewRepos model
                , case model.error of
                    Just errorHttp ->
                        el [ centerX ] <| text "Error while loading repositories..."

                    Nothing ->
                        none
                , el [ height <| px 60 ] none
                , ViewFooter.view model
                ]
        ]
    }
