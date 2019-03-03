module ViewRepo exposing (view)

import Element exposing (..)
import Element.Font as Font
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
    column [ spacing 20, height fill ]
        [ paragraph
            [ Font.bold
            , Font.size 24
            ]
            [ text <| repo.name ]
        , paragraph [] [ text <| repo.description ]
        , if repo.homepage == "" then
            none

          else
            link [] { label = paragraph [] [ text <| repo.homepage ], url = repo.homepage }
        , if repo.language == "" then
            none

          else
            paragraph [ alignBottom ] [ text <| "Language: " ++ repo.language ]
        ]
