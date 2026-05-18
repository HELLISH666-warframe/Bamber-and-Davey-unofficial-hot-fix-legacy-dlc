import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideoSprite;

var newEndings = new FlxVideoSprite();
var endingPlayed = false;
var hehBro = false;

function postCreate() {
	newEndings.load(Assets.getPath(Paths.video("lazy")));
    newEndings.camera = camHUD;
    newEndings.bitmap.onFormatSetup.add(function():Void {
        if (newEndings.bitmap != null && newEndings.bitmap.bitmapData != null) {
            final scale:Float = Math.min(FlxG.width / newEndings.bitmap.bitmapData.width, FlxG.height / newEndings.bitmap.bitmapData.height);
            newEndings.setGraphicSize(newEndings.bitmap.bitmapData.width * scale, newEndings.bitmap.bitmapData.height * scale);
            newEndings.updateHitbox();
            newEndings.screenCenter();
        }
    });
	add(newEndings);
    boyfriend.color=0xF6C594;//246,197,148
}

function wellTimeToEnd() {
    newEndings.play();
    endingPlayed = true;
}

function onSubstateOpen() {
    hehBro = true;
    if (endingPlayed) newEndings.pause();
}

function onFocus() {
    if (endingPlayed && hehBro) newEndings.pause();
}

function onSubstateClose() {
    hehBro = false;
    if (endingPlayed) newEndings.resume();
}

function destroy() {
    newEndings.destroy();
}

function onGameOver(event) {
    event.cancel();
	PlayState.loadSong("Pibenis", "Normal");
	    FlxG.switchState(new PlayState());
    if(!FlxG.save.data.gameStats.achievements.contains('pibby')) FlxG.save.data.gameStats.achievements.push('pibby');
}