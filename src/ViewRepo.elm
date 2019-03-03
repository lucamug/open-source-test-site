module ViewRepo exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html.Attributes
import Internal.Model exposing (Model)
import Internal.Type as Type



{-
   ██████  ███████ ██████   ██████
   ██   ██ ██      ██   ██ ██    ██
   ██████  █████   ██████  ██    ██
   ██   ██ ██      ██      ██    ██
   ██   ██ ███████ ██       ██████
-}


view : Model -> Int -> Type.Repo -> Element msg
view model index repo =
    column
        [ spacing 20
        , height fill
        ]
        [ paragraph
            [ Font.bold
            , Font.size 24
            ]
            [ if repo.logo == "" then
                none

              else
                el
                    [ alignLeft
                    , padding 4
                    , Background.color <| rgb255 200 0 0
                    ]
                <|
                    image
                        [ height <| px 24 ]
                        { src = repo.logo, description = "Logo" }
            , text <| repo.name
            ]
        , paragraph [] [ text <| repo.description ]
        , if repo.homepage == "" then
            none

          else
            link
                [ alignBottom
                , htmlAttribute <| Html.Attributes.style "word-break" "break-all"
                ]
                { label = paragraph [] [ text <| repo.homepage ], url = repo.homepage }
        , if repo.language == "" then
            none

          else
            paragraph [ alignBottom ] [ text <| "Language: " ++ repo.language ]
        ]
