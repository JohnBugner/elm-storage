module Local exposing (..)

{-| Store and load things with local storage.

# Storage
@docs Key, Error, set, get, keys, remove, clear
-}
import Native.Local

import Result exposing (Result)
import Task exposing (Task)
import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)

{-| An alias for a key's type.
-}
type alias Key = String

{-| Possible errors.
-}
type Error
    = Unavailable
    | PermissionDenied
    | QuotaExceeded
    | ValueCorrupt

{-| Set a key to a value.
-}
set : Value -> Key -> Task Error ()
set = Native.Local.rawSet

{-| Get a key's value.
-}
get : Decoder a -> Key -> Task Error (Maybe a)
get decoder key =
    let
        f : Maybe String -> Task Error (Maybe a)
        f muv =
            case muv of
                Nothing -> Task.succeed Nothing
                Just uv ->
                    case Json.Decode.decodeString decoder uv of
                        Err _ -> Task.fail ValueCorrupt
                        Ok v -> Task.succeed (Just v)
    in
        Native.Local.rawGet key |> Task.andThen f

{-| Get a list of all keys that have a value.
-}
keys : Task Error (List Key)
keys = Native.Local.keys ()

{-| Remove a key and its value.
-}
remove : Key -> Task Error ()
remove = Native.Local.remove

{-| Remove all keys and their values.
-}
clear : Task Error ()
clear = Native.Local.clear ()
