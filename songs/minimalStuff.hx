import Paths;
import Sys;
import sys.net.Host;
import sys.io.Process;
import openfl.utils.Assets;
import Main;
import openfl.text.TextFormat;
import haxe.io.Path;
import flixel.text.FlxTextBorderStyle;

//Cursors For Each Song
var songArray = [ //sorry guys i fucked up the song order oops...
    ["yield", "cornaholic", "harvest"] => "corn", //farm moment
    ["synthwheel", "yard", "coop", "squeaky clean"] => "acid", //davey's scientific love
    ["bob be like", "ron be like", "fortnite duos", "blusterous day"] => "ping", //because discord ping is funny
    ["judgement farm", "judgement farm 2"] => "knife", //real knife from undertale
    ["multiversus"] => "phone", //bambi's phone
    ["corn n roll"] => "cursor", //recommended character when
    ["astray"] => "mac", //used to have mac-like colors, did not bother changing it but that's the vibe going for it
    ["memeing"] => "3d-green", //3d cursors
    ["generations", "yeld"] => "shit", //funny shit
    ["deathbattle"] => "deathbattle",
    ["screencast"] => "hotline", //nikku hotline 024 *moans*
    ["trade"] => "money", //ya gotta pay for smth, right?
    ["swindled"] => "explode", //his losing icon
    ["call-bamber"] => "call" //call
];
function postCreate() {
    for (song in songArray.keys()) {
        if (song.contains(PlayState.instance.SONG.meta.name.toLowerCase())) { //checks which cursor to apply
            cursorName=songArray[song];
            break; //break out of the loop
        }
    }

    if (['facsimile', 'yield ', 'cornaholic v1', 'harvest v1', 'yield seezee remix', 'cornaholic erect remix v1', 'harvest chill remix', 'h2o'].contains(PlayState.instance.SONG.meta.name.toLowerCase())) FlxG.mouse.unload();
    if (['placeholder', 'test footage'].contains(PlayState.instance.SONG.meta.name.toLowerCase())) FlxG.mouse.useSystemCursor = true;
    timerNow = new FlxText(580, 30, 0, "0:00");
	timerNow.setFormat(Paths.font("vcr.ttf"), Std.int(24), FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	timerNow.cameras = [camHUD];
	timerNow.antialiasing = true;
    add(timerNow);
}

var songLength = FlxG.sound.music.length;
function update(elapsed:Float) {
    var timeRemaining = Std.int((Conductor.songPosition) / 1000);
    var dsfee = Std.int((inst.length) / 1000);
        timerNow.text = Std.int(timeRemaining / 60) + ":"
         + CoolUtil.addZeros(Std.string(timeRemaining % 60), 2)+" / "
         +Std.int(dsfee / 60)+":"
         + CoolUtil.addZeros(Std.string(dsfee % 60), 2);

    trace(CoolUtil.timeToStr(Conductor.songPosition)+"/ "+CoolUtil.timeToStr(songLength));
}