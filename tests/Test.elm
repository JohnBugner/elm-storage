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

    | Success
    | GetSuccess (Maybe Int)
    | KeysSuccess (List Key)

    | Failure Error

update : Message -> Model -> (Model, Cmd Message)
update event model =
    let
        key : Key
        key = "a"
        resultHandler : Result Error a -> Message
        resultHandler result = case result of
            Ok _ -> Success
            Err x -> Failure x
    in case event of
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
            [ Task.perform (KeysSuccess)
            (Local.keys)
            ]
        Remove ->
            model !
            [ Task.perform (always Success)
            (Local.remove key)
            ]
        Clear ->
            model !
            [ Task.perform (always Success)
            (Local.clear)
            ]
        SetGet ->
            model !
            [ Task.attempt
            resultHandler
            ((Local.set (Json.Encode.int 6) key) |> Task.andThen (\ () -> Local.get Json.Decode.int key))
            ]

        Success ->
            ("success") ! []
        GetSuccess modelx ->
            ("get success : " ++ toString modelx) ! []
        KeysSuccess keys ->
            ("keys success : " ++ toString keys) ! []

        Failure error ->
            ("error failure : " ++ toString error) ! []
