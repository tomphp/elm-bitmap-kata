module BitmapTests exposing (tests)

import Array
import Expect exposing (Expectation)
import Generators exposing (validIndex, validColour, invalidIndex, emptyBitmap)
import List.Extra
import Test exposing (..)
import Bitmap exposing (Bitmap)


countColours : Bitmap -> Int
countColours =
    Bitmap.toList
        >> List.concat
        >> List.Extra.unique
        >> List.length


dimensions : Bitmap -> ( Int, Int )
dimensions b =
    ( Bitmap.rows b, Bitmap.cols b )


tests =
    describe "Bitmap"
        [ describe "initialize"
            [ fuzz2 validIndex validIndex "the number or rows are set" <|
                \cols rows ->
                    Bitmap.initialize rows cols
                        |> Bitmap.rows
                        |> Expect.equal rows
            , fuzz2 validIndex validIndex "the number of cols is set" <|
                \cols rows ->
                    Bitmap.initialize rows cols
                        |> Bitmap.cols
                        |> Expect.equal cols
            , fuzz2 validIndex validIndex "all pixels the same" <|
                \cols rows ->
                    Bitmap.initialize rows cols
                        |> countColours
                        |> Expect.equal 1
            , fuzz2 validIndex validIndex "the first pixel is zero" <|
                \cols rows ->
                    Bitmap.initialize rows cols
                        |> Bitmap.toList
                        |> List.head
                        |> Maybe.andThen List.head
                        |> Expect.equal (Just 0)
            , describe "clear"
                [ fuzz2 emptyBitmap validColour "a clear bitmap contains 1 colour" <|
                    \bitmap colour ->
                        bitmap
                            |> Bitmap.clear colour
                            |> countColours
                            |> Expect.equal 1
                , fuzz2 emptyBitmap validColour "the first colour of a cleared bitmap is the clear colour" <|
                    \bitmap colour ->
                        bitmap
                            |> Bitmap.clear colour
                            |> Bitmap.toList
                            |> List.head
                            |> Maybe.andThen List.head
                            |> Expect.equal (Just colour)
                , fuzz3 validIndex validIndex validColour "the bitmap is the same size" <|
                    \rows cols colour ->
                        Bitmap.initialize rows cols
                            |> Bitmap.clear colour
                            |> dimensions
                            |> Expect.equal ( rows, cols )
                ]
            , describe "rows"
                [ fuzz2 validIndex validIndex "it returns the number of rows" <|
                    \rows cols ->
                        Bitmap.initialize rows cols
                            |> Bitmap.rows
                            |> Expect.equal rows
                ]
            , describe "cols"
                [ fuzz2 validIndex validIndex "it returns the number of cols" <|
                    \rows cols ->
                        Bitmap.initialize rows cols
                            |> Bitmap.cols
                            |> Expect.equal cols
                ]
            ]
        , describe "setPixel"
            [ fuzz validColour "setting a pixel" <|
                \colour ->
                    Bitmap.initialize 5 4
                        |> Bitmap.setPixel 3 2 colour
                        |> Expect.equal
                            (Bitmap.fromList
                                [ [ 0, 0, 0, 0 ]
                                , [ 0, 0, colour, 0 ]
                                , [ 0, 0, 0, 0 ]
                                , [ 0, 0, 0, 0 ]
                                , [ 0, 0, 0, 0 ]
                                ]
                            )
            , fuzz5
                validIndex
                validIndex
                validIndex
                validIndex
                validColour
                "the bitmap is the same size"
              <|
                \rows cols row col colour ->
                    Bitmap.initialize rows cols
                        |> Bitmap.setPixel row col colour
                        |> dimensions
                        |> Expect.equal ( rows, cols )
            ]
        , describe "horizontalLine"
            [ fuzz5
                emptyBitmap
                validIndex
                validIndex
                validIndex
                validColour
                "the bitmap is the same size"
              <|
                \bitmap row start end colour ->
                    let
                        rows =
                            Bitmap.rows bitmap

                        cols =
                            Bitmap.cols bitmap
                    in
                        Bitmap.initialize rows cols
                            |> Bitmap.horizontalLine row start end colour
                            |> dimensions
                            |> Expect.equal ( rows, cols )
            ]
        , describe "verticalLine"
            [ fuzz5
                emptyBitmap
                validIndex
                validIndex
                validIndex
                validColour
                "the bitmap is the same size"
              <|
                \bitmap col start end colour ->
                    let
                        rows =
                            Bitmap.rows bitmap

                        cols =
                            Bitmap.cols bitmap
                    in
                        Bitmap.initialize rows cols
                            |> Bitmap.verticalLine col start end colour
                            |> dimensions
                            |> Expect.equal ( rows, cols )
            ]
        ]
