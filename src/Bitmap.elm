module Bitmap
    exposing
        ( Bitmap
        , Colour
        , initialize
        , rows
        , cols
        , fromList
        , toList
        , setPixel
        , horizontalLine
        , verticalLine
        , clear
        )

import Array exposing (Array)


type alias Bitmap =
    Array (Array Colour)


type alias Colour =
    Int


initialize : Int -> Int -> Bitmap
initialize rows cols =
    Array.repeat rows (Array.repeat cols 0)


clear : Colour -> Bitmap -> Bitmap
clear colour bitmap =
    let
        r =
            rows bitmap

        c =
            cols bitmap
    in
        Array.repeat r (Array.repeat c colour)


rows : Bitmap -> Int
rows =
    Array.length


cols : Bitmap -> Int
cols =
    Array.get 0 >> Maybe.map Array.length >> Maybe.withDefault 0


setPixel : Int -> Int -> Colour -> Bitmap -> Bitmap
setPixel col row colour bitmap =
    let
        row1 =
            row - 1

        col1 =
            col - 1
    in
        Array.get row1 bitmap
            |> Maybe.map (Array.set col1 colour)
            |> Maybe.map (\newRow -> Array.set row1 newRow bitmap)
            |> Maybe.withDefault bitmap


horizontalLine : Int -> Int -> Int -> Colour -> Bitmap -> Bitmap
horizontalLine row start end colour bitmap =
    List.range start end
        |> List.foldl (\c b -> setPixel c row colour b) bitmap


verticalLine : Int -> Int -> Int -> Colour -> Bitmap -> Bitmap
verticalLine col start end colour bitmap =
    List.range start end
        |> List.foldl (\r b -> setPixel col r colour b) bitmap


fromList : List (List Colour) -> Bitmap
fromList =
    List.map Array.fromList >> Array.fromList


toList : Bitmap -> List (List Colour)
toList =
    Array.map Array.toList >> Array.toList
