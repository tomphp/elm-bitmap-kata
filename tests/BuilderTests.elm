module BuilderTests exposing (tests)

import Bitmap
import Builder
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, intRange)
import List.Extra
import Test exposing (..)
import Generators exposing (validIndex)
import Random


tests =
    describe "Builder"
        [ test "the dimensions are initialized" <|
            \_ ->
                "I 4 7\nS"
                    |> Builder.build
                    |> Result.map (\bitmap -> ( Bitmap.rows bitmap, Bitmap.cols bitmap ))
                    |> Expect.equal (Ok ( 7, 4 ))
          -- , test "an error is returned when no instructions are given" <|
          --     \_ ->
          --         Builder.build "" |> Expect.equal (Err "No instructions given")
        , test "setting a pixel" <|
            \_ ->
                [ "I 4 5", "P 3 2 5", "S" ]
                    |> String.join "\n"
                    |> Builder.build
                    |> Expect.equal
                        (Ok
                            (Bitmap.fromList
                                [ [ 0, 0, 0, 0 ]
                                , [ 0, 0, 5, 0 ]
                                , [ 0, 0, 0, 0 ]
                                , [ 0, 0, 0, 0 ]
                                , [ 0, 0, 0, 0 ]
                                ]
                            )
                        )
        , test "clearing" <|
            \_ ->
                [ "I 3 4"
                , "P 3 2 5"
                , "P 1 2 5"
                , "P 3 3 5"
                , "P 3 3 5"
                , "C 9"
                , "S"
                ]
                    |> String.join "\n"
                    |> Builder.build
                    |> Expect.equal
                        (Ok
                            (Bitmap.fromList
                                [ [ 9, 9, 9 ]
                                , [ 9, 9, 9 ]
                                , [ 9, 9, 9 ]
                                , [ 9, 9, 9 ]
                                ]
                            )
                        )
        ]
