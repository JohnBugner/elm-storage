module Test exposing (..)

import Json.Encode
import Json.Decode
import Task

import Html exposing (Html)
import Html.App
import Html.Events

import Local exposing (Key, SetError, GetError)

main : Program Never
main = Html.App.program
    { init = update Get ""
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }

type alias Model = String

view : Model -> Html Event
view model =
    Html.div []
        [ Html.div [] [ Html.button [ Html.Events.onClick Set        ] [ Html.text "Set" ]]
        , Html.div [] [ Html.button [ Html.Events.onClick SetCorrupt ] [ Html.text "Set Corrupt" ]]
        , Html.div [] [ Html.button [ Html.Events.onClick Get        ] [ Html.text "Get" ]]
        , Html.div [] [ Html.button [ Html.Events.onClick Keys       ] [ Html.text "Keys" ]]
        , Html.div [] [ Html.button [ Html.Events.onClick Remove     ] [ Html.text "Remove" ]]
        , Html.div [] [ Html.button [ Html.Events.onClick Clear      ] [ Html.text "Clear" ]]
        , Html.div [] [ Html.text model ]
        ]

type Event
    = Set
    | SetCorrupt
    | Get
    | Keys
    | Remove
    | Clear

    | Success
    | GetSuccess (Maybe Int)
    | KeysSuccess (List Key)

    | Failure
    | SetFailure SetError
    | GetFailure GetError

update : Event -> Model -> (Model, Cmd Event)
update event model =
    let
        key : Key
        key = "a"
    in
        case event of
            Set ->
                model ! [Task.perform (SetFailure) (always Success) (Local.set (Json.Encode.int 5) key)]
            SetCorrupt ->
                model ! [Task.perform (SetFailure) (always Success) (Local.set (Json.Encode.string "5x") key)]
            Get ->
                model ! [Task.perform (GetFailure) (GetSuccess) (Local.get Json.Decode.int key)]
            Keys ->
                model ! [Task.perform (always Failure) (KeysSuccess) (Local.keys)]
            Remove ->
                model ! [Task.perform (always Failure) (always Success) (Local.remove key)]
            Clear ->
                model ! [Task.perform (always Failure) (always Success) (Local.clear)]

            Success ->
                ("success") ! [Cmd.none]
            GetSuccess model' ->
                ("get success : " ++ toString model') ! [Cmd.none]
            KeysSuccess keys ->
                ("keys success : " ++ toString keys) ! [Cmd.none]

            Failure ->
                ("failure") ! [Cmd.none]
            SetFailure error ->
                ("set failure : " ++ toString error) ! [Cmd.none]
            GetFailure error ->
                ("get failure : " ++ toString error) ! [Cmd.none]
