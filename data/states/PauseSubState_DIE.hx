import funkin.backend.FunkinText;
import funkin.backend.utils.FunkinParentDisabler;
import funkin.editors.charter.Charter;
import funkin.menus.StoryMenuState;
import funkin.options.OptionsMenu;
import funkin.options.keybinds.KeybindsOptions;

var grpMenuShit:FlxTypedGroup<Alphabet>;

var levelInfo:FunkinText;
var levelDifficulty:FunkinText;
var deathCounter:FunkinText;
var multiplayerText:FunkinText;

var menuItems:Array<String>;

var curSelected_Pause:Int = 0;

var pauseMusic = FlxG.sound.load(Assets.getMusic(Paths.music('breakfast')), 0, true);

public var game:PlayState = PlayState.instance; // shortcut

var menuItems:Array<String> = ['Resume', 'Restart Song', 'Change Controls', 'Change Options', 'Exit to menu', "Exit to charter"];

var parentDisabler:FunkinParentDisabler;
function create(){
	if(!PlayState.seenCutscene&&PlayState.isStoryMode)return;
	if (menuItems.contains("Exit to charter") && !PlayState.chartingMode)
		menuItems.remove("Exit to charter");

	add(parentDisabler = new FunkinParentDisabler());

	pauseMusic.persist = false;
	pauseMusic.group = FlxG.sound.defaultMusicGroup;
	pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

	var bg:FlxSprite = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
	bg.updateHitbox();
	bg.alpha = 0;
	bg.screenCenter();
	bg.scrollFactor.set();
	add(bg);

	var multiplayerInfo:String = PlayState.opponentMode ? 'pause.coopMode' :
		PlayState.coopMode ? 'pause.opponentMode' :
		null;

	levelInfo = new FunkinText(20, 15, 0, PlayState.SONG.meta.displayName, 32, false);
	levelDifficulty = new FunkinText(20, 15, 0, PlayState.difficulty.toUpperCase(), 32, false);
	deathCounter = new FunkinText(20, 15, 0,'Blued balled: '+ PlayState.deathCounter, 32, false);
	multiplayerText = null;
	if(multiplayerInfo != null)
		multiplayerText = new FunkinText(20, 15, 0, PlayState.opponentMode ? 'OPPONENT MODE' : (PlayState.coopMode ? 'CO-OP MODE' : ''), 32, false);

	for(k=>label in [levelInfo, levelDifficulty, deathCounter, multiplayerText]) {
		if(label == null) continue;
		label.scrollFactor.set();
		label.alpha = 0;
		label.x = FlxG.width - (label.width + 20);
		label.y = 15 + (32 * k);
		FlxTween.tween(label, {alpha: 1, y: label.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3 * (k+1)});
		add(label);
	}

	FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

	grpMenuShit = new FlxTypedGroup<Alphabet>();
	add(grpMenuShit);

	for (i in 0...menuItems.length) {
		var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], "bold");
		songText.isMenuItem = true;
		songText.targetY = i;
		grpMenuShit.add(songText);
	}

	changeSelection(0);

	camera = new FlxCamera();
	camera.bgColor = 0;
	FlxG.cameras.add(camera, false);

	game.updateDiscordPresence();
}

function update(elapsed:Float) {
	if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * elapsed;

	var upP = controls.UP_P;
	var downP = controls.DOWN_P;
	var scroll = FlxG.mouse.wheel;

	if (upP || downP || scroll != 0)  // like this we wont break mods that expect a 0 change event when calling sometimes  - Nex
		changeSelection((upP ? -1 : 0) + (downP ? 1 : 0) - scroll);

	if (controls.ACCEPT) selectOption();
}

function selectOption() {
	switch (menuItems[curSelected_Pause]) {
		case "Resume":
			inPlayState=true;
			close();
		case "Restart Song":
			parentDisabler.reset();
			game.registerSmoothTransition();
			FlxG.resetState();
		case "Change Controls":
			persistentDraw = false;
			openSubState(new KeybindsOptions());
		case "Change Options":
			inPlayState=true;
			FlxG.switchState(new ModState("BND/BNDSettings-old"));
		case "Exit to charter":
			FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty/*, true*/));
			inPlayState=false;
		case "Exit to menu":
			if (PlayState.chartingMode && Charter.undos.unsaved)
				game.saveWarn(false);
			else {
				if (Charter.instance != null) Charter.instance.__clearStatics();

				// prevents certain notes to disappear early when exiting  - Nex
				game.strumLines.forEachAlive(function(grp) grp.notes.__forcedSongPos = Conductor.songPosition);

				CoolUtil.playMenuSong();
				inPlayState=false;
				FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
			}

	}
}
override function destroy() {
	if(camera != FlxG.camera && _cameras != null) {
		if(FlxG.cameras.list.contains(camera))
			FlxG.cameras.remove(camera, true);
	}

	if(pauseMusic != null) {
		FlxG.sound.destroySound(pauseMusic);
	}
}

function changeSelection(a:Int) {
	curSelected_Pause = FlxMath.wrap(curSelected_Pause + a, 0, menuItems.length-1);
	trace(curSelected_Pause+a);

	for (i=>item in grpMenuShit.members) {
		item.targetY = i - curSelected_Pause;

		item.alpha = (item.targetY == 0) ? 1 : 0.6;
	}
}