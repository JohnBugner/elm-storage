# elm-storage

## Examples

Set a key to a value:

    set (Json.Encode.int 42) "key"

Get a key's value:

    get Json.Decode.int "key"

Get a list of all keys that have a value:

    keys

Remove a key and its value:

    remove "key"

Remove all keys and their values:

    clear
