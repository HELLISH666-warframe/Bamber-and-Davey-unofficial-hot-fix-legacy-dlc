import flixel.util.FlxGradient;
var gradientSprite;
//GameOverSubstate.script = 'data/scripts/gameovers/meta';
//Thought having this script would be better then having charater scripts
if(FlxG.save.data.options.skipGameOver)return;
function onGameOver(e) {
    inPlayState=false;
    switch(boyfriend.curCharacter){
        case"Isaac":
        FlxTween.tween(FlxG.camera, {zoom: 0.8}, 3, {ease: FlxEase.quartInOut});
        switch(PlayState.SONG.meta.name){
            case"Memeing":
            GameOverSubstate.script = 'data/scripts/gameovers/cheater';
            FlxG.camera.zoom = 0.8;
            e.deathCharID="bf-dead-cheater";
            e.lossSFX="death/bf-dead-cheater";
            e.gameOverSong = "death/cheater";
            e.retrySFX = 'death/ends/cheater-end';
            default:
            GameOverSubstate.script = 'data/scripts/gameovers/default';
            e.lossSFX="death/bf-dead";
            e.gameOverSong = "death/default";
            e.retrySFX = 'death/ends/default-end';
    }
    }
    if(StringTools.startsWith(curSong, "judgement")){
        e.gameOverSong = "death/ut";
        GameOverSubstate.script = 'data/scripts/gameovers/judgemental-failure';
    }
    switch(curSong){
        case"Generations"|"Yeld":
        e.lossSFX="death/gen-bf-dead";
        e.gameOverSong = "death/funkin";
        e.retrySFX = 'death/ends/funkin-end';
        FlxG.camera.zoom = 0.8;
        FlxG.camera.bgColor = FlxColor.BLACK;
    }
}