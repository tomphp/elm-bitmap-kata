module Main exposing (main)

import Json.Decode as Json
import Html
import Html.Events as Events
import Html.Attributes as Attr
import Bitmap exposing (Bitmap)
import Builder


type alias Model =
    Result String Bitmap


type Msg
    = Update String


main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( Err "Write your program", Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update code ->
            ( Builder.build code, Cmd.none )


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.textarea
            [ Events.on "input" (Json.map Update Events.targetValue)
            , Attr.class "code"
            ]
            []
        , bitmap model
        ]


bitmap : Model -> Html.Html Msg
bitmap model =
    case model of
        Ok b ->
            Html.pre [ Attr.class "bitmap" ]
                [ Html.text (bitmapToString b) ]

        Err err ->
            Html.strong [ Attr.class "error" ] [ Html.div [] [ Html.text err ] ]


bitmapToString : Bitmap -> String
bitmapToString =
    Bitmap.toList
        >> List.map (List.map toString)
        >> List.map (String.join " ")
        >> String.join "\n"
