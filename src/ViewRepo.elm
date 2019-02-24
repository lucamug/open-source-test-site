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
    column [ spacing 6 ]
        [ el [ Font.size 30 ] <| text <| String.fromInt (index + 1) ++ ". " ++ repo.name
        , text <| repo.description
        , text <|
            if repo.fork then
                "True"

            else
                "False"
        , text <| repo.updated_at
        , text <| repo.homepage
        , text <| repo.language
        ]
