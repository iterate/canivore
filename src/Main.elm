module Main exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (rect, shapes)
import Canvas.Settings exposing (fill)
import Canvas.Settings.Advanced exposing (rotate, transform, translate)
import Color
import Html exposing (Html, div)
import Html.Attributes exposing (style)


type alias Model =
    { count : Float }


type Msg
    = Frame Float


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> ( { count = 0 }, Cmd.none )
        , view = view
        , update =
            \msg model ->
                case msg of
                    Frame _ ->
                        ( { model | count = model.count + 1 }, Cmd.none )
        , subscriptions = \model -> onAnimationFrameDelta Frame
        }


width =
    600


height =
    400


centerX =
    width / 2


centerY =
    height / 2


view : Model -> Html Msg
view { count } =
    div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        ]
        [ Canvas.toHtml
            ( width, height )
            [ style "border" "10px solid rgba(0,0,0,0.1)" ]
            (clearScreen :: render count)
        ]


clearScreen =
    shapes [ fill Color.white ] [ rect ( 0, 0 ) width height ]


size =
    width / 10


render count =
    let
        x =
            -(size / 2)

        y =
            -(size / 2)

        rotation =
            count / 60
    in
    List.range 1 100
        |> List.map toFloat
        |> List.map (\i -> firk x y (rotation + (20 * i)))


firk x y rotation =
    shapes
        [ transform
            [ translate centerX centerY
            , translate ((cos rotation * 100) * sin rotation * 4) (sin rotation * 100)
            , rotate rotation
            ]
        , Canvas.Settings.Advanced.compositeOperationMode
            Canvas.Settings.Advanced.Xor
        , fill (Color.hsla 0 0 0 1)
        ]
        [ rect ( x, y ) size size ]
