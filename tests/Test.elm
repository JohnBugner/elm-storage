module Test exposing (..)

import String
import Json.Encode
import Json.Decode
import Task

import Html exposing (Html)
import Html.Events

import Local exposing (Key, Error)

main : Program Never Model Message
main = Html.program
    { init = update Get ""
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }

type alias Model = String

view : Model -> Html Message
view model =
    Html.div []
        [ Html.div [] [ Html.button [ Html.Events.onClick Set              ] [ Html.text "Set" ]]
        , Html.div [] [ Html.button [ Html.Events.onClick SetValueCorrupt  ] [ Html.text "Set Value Corrupt" ]]
        , Html.div [] [ Html.button [ Html.Events.onClick SetQuotaExceeded ] [ Html.text "Set Quota Exceeded" ]]
        , Html.div [] [ Html.button [ Html.Events.onClick Get              ] [ Html.text "Get" ]]
        , Html.div [] [ Html.button [ Html.Events.onClick Keys             ] [ Html.text "Keys" ]]
        , Html.div [] [ Html.button [ Html.Events.onClick Remove           ] [ Html.text "Remove" ]]
        , Html.div [] [ Html.button [ Html.Events.onClick Clear            ] [ Html.text "Clear" ]]
        , Html.div [] [ Html.button [ Html.Events.onClick SetGet           ] [ Html.text "Set, Get" ]]
        , Html.div [] [ Html.text model ]
        ]

type Message
    = Set
    | SetValueCorrupt
    | SetQuotaExceeded
    | Get
    | Keys
    | Remove
    | Clear
    | SetGet
    | ChangeModel String

update : Message -> Model -> (Model, Cmd Message)
update message model =
    let
        key : Key
        key = "a"
        resultHandler : Result Error a -> Message
        resultHandler = ChangeModel << toString
    in
        case message of
            Set ->
                model !
                [ Task.attempt
                resultHandler
                (Local.set (Json.Encode.int 5) key)
                ]
            SetValueCorrupt ->
                model !
                [ Task.attempt
                resultHandler
                (Local.set (Json.Encode.string "x") key)
                ]
            SetQuotaExceeded ->
                model !
                [ Task.attempt
                resultHandler
                (Local.set (Json.Encode.string <| String.repeat (5 * 1024 * 1024) "x") key)
                ]
            Get ->
                model !
                [ Task.attempt
                resultHandler
                (Local.get Json.Decode.int key)
                ]
            Keys ->
                model !
                [ Task.attempt
                --[ Task.perform
                --(KeysSuccess)
                resultHandler
                (Local.keys)
                ]
            Remove ->
                model !
                [ Task.attempt
                --[ Task.perform
                --(always Success)
                resultHandler
                (Local.remove key)
                ]
            Clear ->
                model !
                [ Task.attempt
                --[ Task.perform
                --(always Success)
                resultHandler
                (Local.clear)
                ]
            SetGet ->
                model !
                [ Task.attempt
                resultHandler
                ((Local.set (Json.Encode.int 10) key) |> Task.andThen (\ () -> Local.get Json.Decode.int key))
                ]
            ChangeModel model_ -> model_ ! []
