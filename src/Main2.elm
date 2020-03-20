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
    100


height =
    100


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
            [ style "width" "100%"
            , style "height" "100%"
            , style "image-rendering" "crisp-edges"
            ]
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
            count / 6
    in
    List.range 1 100
        |> List.map toFloat
        |> List.map (\i -> firk x y (rotation + (20 * i)) count)


firk x y rotation count =
    shapes
        [ transform
            [ translate centerX centerY
            , translate
                ((((cos rotation * 200) * sin rotation * 1.11) * 0.21)
                    |> roundFloat
                )
                (((sin rotation * 50) * 1.2) |> roundFloat)
            , rotate
                rotation
            ]

        --       , Canvas.Settings.Advanced.compositeOperationMode
        --         Canvas.Settings.Advanced.Xor
        , fill (Color.hsl 0 0 0)
        ]
        [ rect ( x, y ) (cos (count / 10) * 11) (sin (count / 10) * 11) ]


roundFloat x =
    x |> round |> toFloat
