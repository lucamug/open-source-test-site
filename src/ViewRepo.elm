module ViewRepo exposing (view)

import Element exposing (..)
import Internal.Model exposing (Model)
import Internal.Msg exposing (Msg(..))



{-
   ██████  ███████ ██████   ██████
   ██   ██ ██      ██   ██ ██    ██
   ██████  █████   ██████  ██    ██
   ██   ██ ██      ██      ██    ██
   ██   ██ ███████ ██       ██████
-}


view : Model -> Int -> Internal.Msg.Repo -> Element msg
view model index repo =
    text <| String.fromInt (index + 1) ++ ". " ++ repo.name
