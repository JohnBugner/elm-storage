module Local exposing (..)

{-| Store things in local storage.

# Storage
@docs Key, SetError, GetError, set, get, keys, remove, clear
-}
import Native.Local

import Result exposing (Result)
import Task exposing (Task)
import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)

{-| An alias for a key's type.
-}
type alias Key = String

{-| Possible errors when setting a key.
-}
type SetError
    = QuotaExceeded

{-| Possible errors when getting a key.
-}
type GetError
    = ValueCorrupt

{-| Set a key to a value.
-}
set : Value -> Key -> Task SetError ()
set = Native.Local.rawSet

{-| Get a key's value.
-}
get : Decoder a -> Key -> Task GetError (Maybe a)
get decoder key =
    let
        -- This type annotation causes an error,
        -- because the `a` of the outer annotation is not
        -- shared with the inner annotation.
--        f : Maybe String -> Task GetError a
        f maybe = case maybe of
            Nothing -> Task.succeed Nothing
            Just unparsedValue -> case Json.Decode.decodeString decoder unparsedValue of
                Err _ -> Task.fail ValueCorrupt
                Ok value -> Task.succeed (Just value)
    in
        Native.Local.rawGet key `Task.andThen` f

{-| Get a list of all keys that have a value.
-}
keys : Task x (List Key)
keys = Native.Local.keys

{-| Remove a key and its value.
-}
remove : Key -> Task x ()
remove = Native.Local.remove

{-| Remove all keys and their values.
-}
clear : Task x ()
clear = Native.Local.clear
