module CommandParserTests exposing (tests)

import Command exposing (Command(..))
import CommandParser exposing (parse)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, intRange)
import List.Extra
import Test exposing (..)
import Random
import Bitmap
import Generators exposing (validIndex, validColour)


tests =
    1



-- tests =
--     describe "CommandParser"
--         [ describe "initialize"
--             [ fuzz2 validIndex validIndex "I X Y" <|
--                 \width height ->
--                     [ "I", toString width, toString height ]
--                         |> String.join " "
--                         |> parse
--                         |> Expect.equal (Ok [ Initialize width height ])
--             ]
--         , describe "set pixel"
--             [ fuzz3 validIndex validIndex validColour "P X Y C" <|
--                 \x y colour ->
--                     [ "P", toString x, toString y, toString colour ]
--                         |> String.join " "
--                         |> parse
--                         |> Expect.equal (Ok [ SetPixel x y colour ])
--             ]
--         , describe "clear"
--             [ test "C" <|
--                 \_ ->
--                     "C"
--                         |> parse
--                         |> Expect.equal (Ok [ Clear 0 ])
--             , fuzz validColour "C R" <|
--                 \colour ->
--                     ("C " ++ (toString colour))
--                         |> parse
--                         |> Expect.equal (Ok [ Clear colour ])
--             ]
--         , describe "show"
--             [ test "S" <|
--                 \_ ->
--                     parse "S" |> Expect.equal (Ok [ Show ])
--             ]
--         ]
