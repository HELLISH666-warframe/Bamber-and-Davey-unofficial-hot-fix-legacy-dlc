import flixel.util.FlxGradient;
import StringTools;
var gradientSprite;
//GameOverSubstate.script = 'data/scripts/gameovers/meta';
//Thought having this script would be better then having charater scripts
if(!FlxG.save.data.options.skipGameOver){
function onGameOver(e) {
    switch(boyfriend.curCharacter){
        case"bf":
        switch(PlayState.instance.SONG.meta.name){
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

            gradientSprite = FlxGradient.createGradientFlxSprite(FlxG.width * 2, 900, [0x00000000, PlayState.instance.boyfriend.iconColor], 1, 90, true);
            gradientSprite.scrollFactor.set();
	        gradientSprite.screenCenter();
            gradientSprite.y += 100;
            PlayState.instance.insert(99,gradientSprite);
    }
    }
    if(StringTools.startsWith(curSong, "Judgement")){
        trace("Chris_pratt.");
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
}