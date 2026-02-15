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
import funkin.backend.system.FunkinRatioScaleMode;
function create() {
    scoreText = [scoreTxt,accuracyTxt,missesTxt];
    inPlayState=true;

    //Main.scaleMode.fillScreen=FlxG.scaleMode.fillScreen=false;
    Main.scaleMode=FlxG.scaleMode = new FunkinRatioScaleMode(false);
    /*Main.scaleMode=FlxG.scaleMode = new FunkinRatioScaleMode();
    Main.scaleMode.fillScreen=FlxG.scaleMode.fillScreen=true;*/
    /*FlxG.scaleMode.updateGameSize(256);
    FlxG.scaleMode.onMeasure(1280,720);
    Main.scaleMode.onMeasure(1280,720);*/

    /*
    camHUD.width=FlxG.camera.width=FlxG.scaleMode.width = 256;
    FlxG.scaleMode.height = FlxG.height = FlxG.initialHeight = 144;
    FlxG.resizeGame(256,144);
    FlxG.resizeWindow(1280,720);
    trace(FlxG.scaleMode.width,FlxG.scaleMode.height);*/
    windowShit(1280,720);
    //['256x144','854x480',"1280x720",'1920x1080','2560x1440','3840x2160']
    /*FlxG.resizeWindow(1280, 720);
    FlxG.resizeGame(1280/1.4, 720/1.4);
    camHUD.width=FlxG.camera.width=FlxG.scaleMode.width = 1280/1.4;
    FlxG.width=1280;
    FlxG.height=720;
    camHUD.height=FlxG.camera.height=FlxG.scaleMode.height = 720/1.4;
    if(camera != FlxG.camera && _cameras != null) {
		if(FlxG.cameras.list.contains(camera))
			FlxG.cameras.remove(camera, true);
	}*/
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