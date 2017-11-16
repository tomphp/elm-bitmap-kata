module Builder exposing (build)

import Bitmap exposing (Bitmap)
import Runner
import CommandParser


build : String -> Result String Bitmap
build instructions =
    CommandParser.parse instructions
        |> Result.andThen Runner.run
