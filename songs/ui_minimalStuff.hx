import funkin.backend.scripting.events.ResizeEvent;
import funkin.backend.utils.WindowUtils;
import openfl.text.TextFormat;

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

var customFonts = [
    'bfdifield' => "adelon-serial-bold.ttf",
    'battlegrounds' => "Impact.ttf",
    'judgement hall' => "Mars_Needs_Cunnilingus.ttf",
    'undertalestage' => "Mars_Needs_Cunnilingus.ttf",
    'bot farm' => "goodbyeDespair.ttf",
    'paintvoid' => "vcr_osd.ttf",
    'default_stage' => "vcr_osd.ttf",
    'oldfarm' => "vcr_osd.ttf",
    'oldfarm_night' => "vcr_osd.ttf"
];

function postCreate() {
    for (song in songArray.keys()) {
        if (song.contains(PlayState.SONG.meta.name.toLowerCase())) { //checks which cursor to apply
            cursorName=songArray[song];
            break; //break out of the loop
        }
    }

    if (['facsimile', 'yield ', 'cornaholic v1', 'harvest v1', 'yield seezee remix', 'cornaholic erect remix v1', 'harvest chill remix', 'h2o'].contains(PlayState.SONG.meta.name.toLowerCase())) FlxG.mouse.unload();
    if (['placeholder', 'test footage'].contains(PlayState.SONG.meta.name.toLowerCase())) FlxG.mouse.useSystemCursor = true;
    if (customFonts[SONG.stage.toLowerCase()] != null) { //checks if there is a custom font to apply for the stage
        for (i in members) {
            if (i != null && Std.isOfType(i, FlxText)) { //checks every state object and if they're texts
                i.font = Paths.font(customFonts[SONG.stage.toLowerCase()]);
            }
        }
        changeFpsFont(customFonts[SONG.stage.toLowerCase()]);
    }
    WindowUtils.winTitle='Currently Playing: '+PlayState.SONG.meta.displayName;
}

var songLength = FlxG.sound.music.length;

function destroy() {
    changeFpsFont('vcr.ttf');
    WindowUtils.winTitle='';
}

function onSplashShown(e) if(StringTools.contains(curSong.toLowerCase(), "judgement"))
    e.splash.angle=switch (e.splash.strumID) {case 0:90; case 1:0;case 2:180;case 3:-90;};