module Generators exposing (..)

import Fuzz exposing (Fuzzer, intRange, oneOf)
import Random
import Bitmap exposing (Bitmap)


invalidIndex : Fuzzer Int
invalidIndex =
    oneOf
        [ intRange Random.minInt 0
        , intRange 11 Random.maxInt
        ]


validIndex : Fuzzer Int
validIndex =
    intRange 1 10


validColour : Fuzzer Int
validColour =
    intRange 0 9


emptyBitmap : Fuzzer Bitmap
emptyBitmap =
    Fuzz.map2 Bitmap.initialize validIndex validIndex
