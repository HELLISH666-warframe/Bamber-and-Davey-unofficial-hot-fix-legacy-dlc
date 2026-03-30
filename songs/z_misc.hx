public static function executeFuncMultiple(funcName:String, ?args:Array<Any>, ?defaultReturnVal:Array<Any>) {
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
import funkin.backend.system.FunkinRatioScaleMode;
function create() {
    scoreText = [scoreTxt,accuracyTxt,missesTxt];
    inPlayState=true;
}

import openfl.system.Capabilities;
public static function windowShit(newWidth:Int, newHeight:Int ){
    FlxG.resizeWindow(1280/2, 720/2);
    //FlxG.fullscreen = false;
    //FlxG.scaleMode.fillScreen=true;
    FlxG.resizeGame(newWidth, newHeight);
    FlxG.scaleMode.width = FlxG.width = FlxG.initialWidth = newWidth;
    FlxG.scaleMode.height = FlxG.height = FlxG.initialHeight = newHeight;
    for(i in cameras){i.width=newWidth;
        i.height=newHeight;
    }
    /*FlxG.scaleMode.updateGameSize(3543,144);
    Main.scaleMode.updateGameSize(256,144);*/
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