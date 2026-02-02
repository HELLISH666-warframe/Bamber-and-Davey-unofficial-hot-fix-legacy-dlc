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

public var scoreText=[];
function create() {
    scoreText = [scoreTxt,accuracyTxt,missesTxt];
    inPlayState=true;
}

function postCreate() {
	scripts.call('postPostCreate');
}
function onGamePause(event) {
    if(!PlayState.seenCutscene&&PlayState.isStoryMode)return;
    event.cancel();
    persistentUpdate = false;
    persistentDraw = true;
    paused = true;
        
    openSubState(new ModSubState("PauseSubState_DIE"));
}

function onSongEnd(e) inPlayState=false;