import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.DiscordUtil;
import Type;
import haxe.io.Path;

var stateQuotes:Map<String, String> = [
    "BND/SplashScreen" => "Team Reimagination Splash Screen",
    "BND/FirstTimeState" => "First Time Setup",
    "BND/BNDMenu" => "In The Menus",
    "YCE/MedalsState" => " Medals Menu",
    "BND/BNDSettings" => "Options Menu",
    "BND/BNDFreeplayCategories" => "Freeplay Menu"
];

static var hasseen = false;
public static var inPlayState = false;

function destroy(){
	hasseen = false;
    if(!window.fullscreen)window.borderless=false;
}

function new() {
    for (i in Paths.getFolderContent('data/global')) importScript("data/global/"+Path.withoutExtension(i)); //import different global scripts for organization reasons
}

function postStateSwitch() {
    WindowUtils.set_prefix('Bamber & Davey Vol. 2.5 | ');
    if (stateQuotes[ModState.lastName] != null && Type.getClassName(Type.getClass(FlxG.state)) == 'funkin.backend.scripting.ModState') {
        WindowUtils.set_winTitle(stateQuotes[ModState.lastName]);
        DiscordUtil.changePresence(stateQuotes[ModState.lastName], null);
    }
}

function preStateSwitch() { //Switch to where it was meant to be
    if (Type.getClassName(Type.getClass(FlxG.game._requestedState)) == "funkin.menus.TitleState"&&FlxG.save.data.options.splashScreen) FlxG.game._requestedState = new ModState("BND/SplashScreen");
}

function update(elapsed) {
    if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.R) FlxG.resetGame();
}

public static function playBamberMenuSound(type) {
    return FlxG.sound.play(Paths.sound('menuSounds/'+type), getVolume(1, 'sfx'));
}

function onDiscordPresenceUpdate(e) {
	var data = e.presence;

	if(data.button1Label == null)
		data.button1Label = "Play the mod!";
	if(data.button1Url == null)
		data.button1Url = "https://github.com/HELLISH666-warframe/Bamber-and-Davey-unofficial-hot-fix-legacy-dlc";
}