//import Native.List //
//import Native.Scheduler //
//import Native.Utils //

var _JohnBugner$elm_storage$Native_Local = function() {
    function rawSet(value, key) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
            try {
                if (window.localStorage === undefined) {
                    callback(_elm_lang$core$Native_Scheduler.fail({ctor : "Unavailable"}));
                    return;
                }
            } catch (e) {
                if (e.name === "SecurityError") {
                    callback(_elm_lang$core$Native_Scheduler.fail({ctor : "PermissionDenied"}));
                    return;
                }
            }

            try {
                window.localStorage.setItem(key, value);
            } catch (e) {
                if (e.name === "QuotaExceededError" || e.name === "NS_ERROR_DOM_QUOTA_REACHED") {
                    callback(_elm_lang$core$Native_Scheduler.fail({ctor : "QuotaExceeded"}));
                    return;
                }
            }

            callback(_elm_lang$core$Native_Scheduler.succeed(_elm_lang$core$Native_Utils.Tuple0));
            return;
        });
    }

    function rawGet(key) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
            try {
                if (window.localStorage === undefined) {
                    callback(_elm_lang$core$Native_Scheduler.fail({ctor : "Unavailable"}));
                    return;
                }
            } catch (e) {
                if (e.name === "SecurityError") {
                    callback(_elm_lang$core$Native_Scheduler.fail({ctor : "PermissionDenied"}));
                    return;
                }
            }

            var value = window.localStorage.getItem(key);

            if (value === null) {
                callback(_elm_lang$core$Native_Scheduler.succeed({ctor : "Nothing"}));
                return;
            } else {
                callback(_elm_lang$core$Native_Scheduler.succeed({ctor : "Just", _0 : value}));
                return;
            }
        });
    }

    // Ignore the _ parameter. I don't know how to make a scheduled function with 0 parameters,
    // but I do know how to make one with 1, so the _ parameter is just a placeholder.
    function keys(_) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
            try {
                if (window.localStorage === undefined) {
                    callback(_elm_lang$core$Native_Scheduler.fail({ctor : "Unavailable"}));
                    return;
                }
            } catch (e) {
                if (e.name === "SecurityError") {
                    callback(_elm_lang$core$Native_Scheduler.fail({ctor : "PermissionDenied"}));
                    return;
                }
            }

            var keyList = _elm_lang$core$Native_List.Nil;

            for (var i = window.localStorage.length; i > 0 ; --i) {
                keyList = _elm_lang$core$Native_List.Cons(window.localStorage.key(i - 1), keyList);
            }

            callback(_elm_lang$core$Native_Scheduler.succeed(keyList));
            return;
        });
    }

    function remove(key) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
            try {
                if (window.localStorage === undefined) {
                    callback(_elm_lang$core$Native_Scheduler.fail({ctor : "Unavailable"}));
                    return;
                }
            } catch (e) {
                if (e.name === "SecurityError") {
                    callback(_elm_lang$core$Native_Scheduler.fail({ctor : "PermissionDenied"}));
                    return;
                }
            }

            window.localStorage.removeItem(key);

            callback(_elm_lang$core$Native_Scheduler.succeed(_elm_lang$core$Native_Utils.Tuple0));
            return;
        });
    }

    function clear(_) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
            try {
                if (window.localStorage === undefined) {
                    callback(_elm_lang$core$Native_Scheduler.fail({ctor : "Unavailable"}));
                    return;
                }
            } catch (e) {
                if (e.name === "SecurityError") {
                    callback(_elm_lang$core$Native_Scheduler.fail({ctor : "PermissionDenied"}));
                    return;
                }
            }

            window.localStorage.clear();

            callback(_elm_lang$core$Native_Scheduler.succeed(_elm_lang$core$Native_Utils.Tuple0));
            return;
        });
    }

    return {
        rawSet : F2(rawSet),
        rawGet : rawGet,
        keys   : keys,
        remove : remove,
        clear  : clear
    };
}();
