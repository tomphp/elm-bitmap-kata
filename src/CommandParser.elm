module CommandParser exposing (parse)

import Parser exposing (..)
import Command exposing (Command(..))


parse : String -> Result String (List Command)
parse =
    runParser commands


runParser : Parser a -> String -> Result String a
runParser parser input =
    run parser input
        |> Result.mapError (\e -> "Parse error: " ++ (toString e.problem) ++ " [row: " ++ (toString e.row) ++ ", col: " ++ (toString e.col) ++ "]")


commands : Parser (List Command)
commands =
    succeed mkProgram
        |= initialize
        |. newLines
        |= repeat zeroOrMore command
        |= show
        |. repeat zeroOrMore newLines
        |. end


mkProgram : Command -> List Command -> Command -> List Command
mkProgram init body show =
    List.concat [ [ init ], body, [ show ] ]


command : Parser Command
command =
    oneOf
        [ setPixel
        , horizontalLine
        , verticalLine
        , clearWithColour
        , clear
        ]
        |. newLines


initialize : Parser Command
initialize =
    succeed Initialize
        |. symbol "I"
        |. space
        |= int
        |. space
        |= int


setPixel : Parser Command
setPixel =
    succeed SetPixel
        |. symbol "P"
        |. space
        |= int
        |. space
        |= int
        |. space
        |= int


horizontalLine : Parser Command
horizontalLine =
    succeed HorizontalLine
        |. symbol "H"
        |. space
        |= int
        |. space
        |= int
        |. space
        |= int
        |. space
        |= int


verticalLine : Parser Command
verticalLine =
    succeed VerticalLine
        |. symbol "V"
        |. space
        |= int
        |. space
        |= int
        |. space
        |= int
        |. space
        |= int


clearWithColour : Parser Command
clearWithColour =
    delayedCommit (symbol "C" |. space) <|
        succeed Clear
            |= int


clear : Parser Command
clear =
    succeed (Clear 0)
        |. symbol "C"


show : Parser Command
show =
    succeed Show
        |. symbol "S"


newLines : Parser (List ())
newLines =
    repeat oneOrMore (symbol "\n")


space : Parser ()
space =
    symbol " "
