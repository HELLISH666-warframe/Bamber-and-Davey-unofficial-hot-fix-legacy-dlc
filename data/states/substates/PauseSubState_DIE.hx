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

var curSelePa:Int = 0;

var pauseMusic = FlxG.sound.load(Assets.getMusic(Paths.music('breakfast')), 0, true);

public var game:PlayState = PlayState.instance; // shortcut

var menuItems:Array<String> = ['Resume','Restart Song','Change Controls','Change Options','Exit to menu','Exit to charter'];

var parentDisabler:FunkinParentDisabler;

//Bamber_shit.
var countTimer;
var diffColors = ['normal'=>0xfcfc04,'easy'=>0x04fc04,'hard'=>0xfc0404,'absolutely fucking fucked'=>0xfc0404];
var countdownTempo = 1 / Math.pow(2, Math.floor(Math.log(Conductor.bpm/120) / Math.log(2)));

var countdownSprite = new FlxSprite();
function create(){
	if(!PlayState.seenCutscene&&PlayState.isStoryMode)return;
	if (menuItems.contains("Exit to charter") && !PlayState.chartingMode)
		menuItems.remove("Exit to charter");

	add(parentDisabler = new FunkinParentDisabler());

	pauseMusic.persist = false;
	pauseMusic.group = FlxG.sound.defaultMusicGroup;
	pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

	var bg = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
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
		label.font = PlayState.instance.scoreTxt.font;
		label.x = FlxG.width - (label.width + 20);
		label.y = 15 + (32 * k);
		FlxTween.tween(label, {alpha: 1, y: label.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3 * (k+1)});
		add(label);
	}

	if(diffColors[levelDifficulty.text.toLowerCase()] != null){levelDifficulty.color = diffColors[levelDifficulty.text.toLowerCase()];} else {levelDifficulty.color = 0xFFFFFF;}

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

	if(Assets.exists(Paths.image("game/countdown/" +PlayState.SONG.meta.customValues.countdownPath+ "countdown"))){
		countdownSprite.frames = Paths.getSparrowAtlas("game/countdown/"+PlayState.SONG.meta.customValues.countdownPath+"/countdown");
		countdownSprite.animation.addByPrefix("3", "Three", 24, false);
		countdownSprite.animation.addByPrefix("2", "Two", 24, false);
		countdownSprite.animation.addByPrefix("1", "One", 24, false);
		countdownSprite.animation.addByPrefix("0", "Go", 24, false);
		countdownSprite.animation.play("3");
	} else {
		countdownSprite.loadGraphic(Paths.image("game/countdown/"+PlayState.SONG.meta.customValues.countdownPath+'/Get'));
	}
    
	countdownSprite.updateHitbox();
	countdownSprite.screenCenter();
	insert(2, countdownSprite);
	countdownSprite.alpha = 0.0001;

	camera = new FlxCamera();
	camera.bgColor = 0;
	FlxG.cameras.add(camera, false);

	game.updateDiscordPresence();
}

function update(elapsed:Float) {
	if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * elapsed;

	if (controls.UP_P || controls.DOWN_P || FlxG.mouse.wheel != 0)  // like this we wont break mods that expect a 0 change event when calling sometimes  - Nex
		changeSelection((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);

	if (controls.ACCEPT) selectOption();
}

function selectOption() {
	switch (menuItems[curSelePa]) {
		case "Resume":
			if(FlxG.save.data.options.pauseCountdown){
			var swagCounter = 2;
			isCountingDown = true;

			grpMenuShit.clear();
			menuItems = ['Cancel'];

			for (i in 0...menuItems.length)
			{
				var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
				songText.isMenuItem = true;
				songText.targetY = i;
				grpMenuShit.add(songText);
			}

			CoolUtil.playMenuSFX(1);
			changeSelection(0);

			executeFuncMultiple("onCountdown", [3, countdownSprite], [true, null]);
			countTimer = new FlxTimer().start(Conductor.crochet / 1000 / countdownTempo, function(tmr:FlxTimer) {
				if (swagCounter > -1) { 
					executeFuncMultiple("onCountdown", [swagCounter, countdownSprite], [true, null]);
				}
				else {
					inPlayState=true;
					close();
				}

				swagCounter--;
			}, 4);
        return false;
			}
			else{
			inPlayState=true;
			close();
			}
		case "Cancel":
		grpMenuShit.clear();
        menuItems = ['Resume', 'Restart Song', 'Change Controls', 'Change Options', 'Exit to menu', "Exit to charter"];

        for (i in 0...menuItems.length)
        {
            var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
            songText.isMenuItem = true;
            songText.targetY = i;
            grpMenuShit.add(songText);
        }

        isCountingDown = false;

        CoolUtil.playMenuSFX(2);
        changeSelection(0);

        countdownSprite.alpha = 0.0001;
        countTimer.cancel();

        return true;
		case "Restart Song":
			parentDisabler.reset();
			game.registerSmoothTransition();
			FlxG.resetState();
		case "Change Controls":
			persistentDraw = false;
			openSubState(new KeybindsOptions());
		case "Change Options":
			inPlayState=true;
			FlxG.switchState(new ModState("BND/BNDSettings"));
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

	if(pauseMusic != null) FlxG.sound.destroySound(pauseMusic);
}

function changeSelection(a:Int) {
	curSelePa = FlxMath.wrap(curSelePa + a, 0, menuItems.length-1);
	if(a!=0)CoolUtil.playMenuSFX('scroll', getVolume(1, 'sfx'));

	for (i=>item in grpMenuShit.members) {
		item.targetY = i - curSelePa;

		item.alpha = (item.targetY == 0) ? 1 : 0.6;
	}
}