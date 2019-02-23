module ViewRepo exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Internal.Model as Model exposing (Model)
import Internal.Msg as Msg exposing (Msg(..))
import Internal.Shared as Shared



{-
   ██████  ███████ ██████   ██████
   ██   ██ ██      ██   ██ ██    ██
   ██████  █████   ██████  ██    ██
   ██   ██ ██      ██      ██    ██
   ██   ██ ███████ ██       ██████
-}


view : Model -> Int -> Msg.Repo -> Element msg
view model index repo =
    text <| String.fromInt (index + 1) ++ ". " ++ repo.name
