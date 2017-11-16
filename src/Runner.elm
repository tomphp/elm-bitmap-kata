module Runner exposing (run)

import Command exposing (Command(..))
import Bitmap exposing (Bitmap)


run : List Command -> Result String Bitmap
run =
    List.foldl applyCommand Nothing >> Result.fromMaybe "Failed"


applyCommand : Command -> Maybe Bitmap -> Maybe Bitmap
applyCommand command bitmap =
    case bitmap of
        Nothing ->
            initialize command

        Just bitmap ->
            Just (updateBitmap command bitmap)


initialize : Command -> Maybe Bitmap
initialize command =
    case command of
        Initialize cols rows ->
            Just (Bitmap.initialize rows cols)

        _ ->
            Nothing


updateBitmap : Command -> Bitmap -> Bitmap
updateBitmap command =
    case command of
        SetPixel x y colour ->
            Bitmap.setPixel x y colour

        HorizontalLine row start end colour ->
            Bitmap.horizontalLine row start end colour

        VerticalLine row start end colour ->
            Bitmap.verticalLine row start end colour

        Show ->
            identity

        Clear colour ->
            Bitmap.clear colour

        Initialize _ _ ->
            identity
