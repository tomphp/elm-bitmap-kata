module Command exposing (Command(..))

import Bitmap exposing (Colour)


type Command
    = Initialize Int Int
    | SetPixel Int Int Colour
    | HorizontalLine Int Int Int Colour
    | VerticalLine Int Int Int Colour
    | Clear Colour
    | Show
