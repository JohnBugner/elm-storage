//import Native.List //
//import Native.Scheduler //
//import Native.Utils //

var _JohnBugner$elm_storage$Native_Local = function() {
    function rawSet(value, key) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
            try {
                window.localStorage.setItem(key, value);
            } catch (e) {
                if (e.name === "QuotaExceededError" || e.name === "NS_ERROR_DOM_QUOTA_REACHED") {
                    callback(_elm_lang$core$Native_Scheduler.fail({ctor : "QuotaExceeded"}));
                    return;
                }
            }

            callback(_elm_lang$core$Native_Scheduler.succeed(_elm_lang$core$Native_Utils.Tuple0));
        });
    }

    function rawGet(key) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
            var value = window.localStorage.getItem(key);

            if (value === null) {
                callback(_elm_lang$core$Native_Scheduler.succeed({ctor : "Nothing"}));
            } else {
                callback(_elm_lang$core$Native_Scheduler.succeed({ctor : "Just", _0 : value}));
            }
        });
    }

    var keys = _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
        var keyList = _elm_lang$core$Native_List.Nil;

        for (var i = window.localStorage.length; i > 0 ; --i) {
            keyList = _elm_lang$core$Native_List.Cons(window.localStorage.key(i - 1), keyList);
        }

        callback(_elm_lang$core$Native_Scheduler.succeed(keyList));
    });

    function remove(key) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
            window.localStorage.removeItem(key);

            callback(_elm_lang$core$Native_Scheduler.succeed(_elm_lang$core$Native_Utils.Tuple0));
        });
    }

    var clear = _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
        window.localStorage.clear();

        callback(_elm_lang$core$Native_Scheduler.succeed(_elm_lang$core$Native_Utils.Tuple0));
    });

    return {
        rawSet : F2(rawSet),
        rawGet : rawGet,
        keys   : keys,
        remove : remove,
        clear  : clear
    };
}();
