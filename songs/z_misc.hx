public function executeFuncMultiple(funcName:String, ?args:Array<Any>, ?defaultReturnVal:Array<Any>) {
    var a = args;
    if (a == null) a = [];
    if (defaultReturnVal == null) defaultReturnVal = [null];
    for (script in PlayState.instance.scripts.scripts) {
        var returnVal = script.call(funcName, a);
        if (!defaultReturnVal.contains(returnVal)) {
            return returnVal;
        }
    }
    return defaultReturnVal[0];
}

function postCreate() {
	scripts.call('postPostCreate');
}