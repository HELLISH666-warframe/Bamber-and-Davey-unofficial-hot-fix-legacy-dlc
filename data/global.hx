import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.DiscordUtil;
import Type;
import haxe.io.Path;
import funkin.backend.system.framerate.Framerate;
import funkin.savedata.FunkinSave;
import openfl.text.TextFormat;

var stateQuotes:Map<String, String> = [
    "BND/SplashScreen" => "Team Reimagination Splash Screen",
    "BND/FirstTimeState" => "First Time Setup",
    "BND/BNDMenu" => "In The Menus",
    "BND/achievementsState" => "AchievementsState Menu",
    "BND/BNDSettings" => "Options Menu",
    "BND/BNDFreeplayCategories" => "Freeplay Menu"
];

var idleCursorGraphic;
var clickCursorGraphic;
public static var cursorName = 'default';
public var clickableObjects = [];
var isHovering = false;
var switched = false;
static var hasseen = false;
public static var inPlayState = false;
var colorMatrixFilterGLOBAL = new CustomShader('ColorMatrixFilter');
var colorMatrixFilterGLOBAL2 = new CustomShader('ColorMatrixFilter');

function destroy(){
	hasseen = false;
    FlxG.mouse.useSystemCursor = true;
    FlxG.mouse.visible = false;
    changeFpsFont(Framerate.fontName);
    if(!window.fullscreen)window.borderless=false;
    FlxG.game.removeShader(colorMatrixFilterGLOBAL);
    FlxG.game.removeShader(colorMatrixFilterGLOBAL2);
    FlxG.save.bind('save-default', 'CodenameEngine');
}

static function updateColorMatrix(){
    matrix=[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
    colorMatrixFilterGLOBAL.uMultipliers = matrix;
    colorMatrixFilterGLOBAL2.uMultipliers = matrix;
    colorMatrixFilterGLOBAL.uOffsets = [0, 0, 0, 0];
    colorMatrixFilterGLOBAL2.uOffsets = [0, 0, 0, 0];

    matrix = [
		0.20 * FlxG.save.data.options.gamma, 0.99 * FlxG.save.data.options.gamma, -.19 * FlxG.save.data.options.gamma, 0, FlxG.save.data.options.brightness,
		0.16 * FlxG.save.data.options.gamma, 0.79 * FlxG.save.data.options.gamma, 0.04 * FlxG.save.data.options.gamma, 0, FlxG.save.data.options.brightness,
		0.01 * FlxG.save.data.options.gamma, -.01 * FlxG.save.data.options.gamma,    1 * FlxG.save.data.options.gamma, 0, FlxG.save.data.options.brightness,
		 0,                       0,                       0, 1,                     0,
	];

    colorMatrixFilterGLOBAL.uMultipliers[0] = matrix[0];
	colorMatrixFilterGLOBAL.uMultipliers[1] = matrix[1];
	colorMatrixFilterGLOBAL.uMultipliers[2] = matrix[2];
	colorMatrixFilterGLOBAL.uMultipliers[3] = matrix[3];
	colorMatrixFilterGLOBAL.uMultipliers[4] = matrix[5];
	colorMatrixFilterGLOBAL.uMultipliers[5] = matrix[6];
	colorMatrixFilterGLOBAL.uMultipliers[6] = matrix[7];
	colorMatrixFilterGLOBAL.uMultipliers[7] = matrix[8];
	colorMatrixFilterGLOBAL.uMultipliers[8] = matrix[10];
	colorMatrixFilterGLOBAL.uMultipliers[9] = matrix[11];
	colorMatrixFilterGLOBAL.uMultipliers[10] = matrix[12];
	colorMatrixFilterGLOBAL.uMultipliers[11] = matrix[13];
	colorMatrixFilterGLOBAL.uMultipliers[12] = matrix[15];
	colorMatrixFilterGLOBAL.uMultipliers[13] = matrix[16];
	colorMatrixFilterGLOBAL.uMultipliers[14] = matrix[17];
	colorMatrixFilterGLOBAL.uMultipliers[15] = matrix[18];

    colorMatrixFilterGLOBAL.uOffsets=[matrix[4]/255.0,matrix[9]/255.0,matrix[14]/255.0,matrix[19]/255.0];

    var cosA:Float = Math.cos(-0 * Math.PI / 180);
	var sinA:Float = Math.sin(-0 * Math.PI / 180);

	var a1:Float = cosA + (1.0 - cosA) / 3.0;
	var a2:Float = 1.0 / 3.0 * (1.0 - cosA) - Math.sqrt(1.0 / 3.0) * sinA;
	var a3:Float = 1.0 / 3.0 * (1.0 - cosA) + Math.sqrt(1.0 / 3.0) * sinA;

	var b1:Float = a3;
	var b2:Float = cosA + 1.0 / 3.0 * (1.0 - cosA);
	var b3:Float = a2;

	var c1:Float = a2;
	var c2:Float = a3;
	var c3:Float = b2;

	colorM = [
		a1, b1, c1, 0, 0,
		a2, b2, c2, 0, 0,
		a3, b3, c3, 0, 0,
		 0,  0,  0, 1, 0
	];

    colorMatrixFilterGLOBAL2.uMultipliers[0] = colorM[0];
	colorMatrixFilterGLOBAL2.uMultipliers[1] = colorM[1];
	colorMatrixFilterGLOBAL2.uMultipliers[2] = colorM[2];
	colorMatrixFilterGLOBAL2.uMultipliers[3] = colorM[3];
	colorMatrixFilterGLOBAL2.uMultipliers[4] = colorM[5];
	colorMatrixFilterGLOBAL2.uMultipliers[5] = colorM[6];
	colorMatrixFilterGLOBAL2.uMultipliers[6] = colorM[7];
	colorMatrixFilterGLOBAL2.uMultipliers[7] = colorM[8];
	colorMatrixFilterGLOBAL2.uMultipliers[8] = colorM[10];
	colorMatrixFilterGLOBAL2.uMultipliers[9] = colorM[11];
	colorMatrixFilterGLOBAL2.uMultipliers[10] = colorM[12];
	colorMatrixFilterGLOBAL2.uMultipliers[11] = colorM[13];
	colorMatrixFilterGLOBAL2.uMultipliers[12] = colorM[15];
	colorMatrixFilterGLOBAL2.uMultipliers[13] = colorM[16];
	colorMatrixFilterGLOBAL2.uMultipliers[14] = colorM[17];

    colorMatrixFilterGLOBAL2.uOffsets=[colorM[4]/255.0,colorM[9]/255.0,colorM[14]/255.0,colorM[19]/255.0];
}

function new() {
    FlxG.save.bind('BamberAndDavey', 'TeamReimagination'); //I found out that mod options use regular saves instead of a save in the Options class for example

    if (FlxG.save.data.options == null) FlxG.save.data.options = {};

    //MOD SPECIFIC OPTIONS, DEFAULT ONES SHOULD BE INCLUDED TOO
    //Video Options
    FlxG.save.data.options.framerate ??= 120; // is 120 a good default idk
    FlxG.save.data.options.antialiasing ??= true;
    FlxG.save.data.options.pixelperfect ??= true;
    FlxG.save.data.options.resolution ??= ['1280x720'];
    FlxG.save.data.options.fullscreen ??= false; 
    FlxG.save.data.options.borderless ??= false;
    FlxG.save.data.options.brightness ??= 0;
    FlxG.save.data.options.gamma ??= 0;

    //Sound options
    //Master Volume - FlxG.volume
    FlxG.save.data.options.musicVolume ??= 100; 
    FlxG.save.data.options.sfxVolume ??= 100;
    FlxG.save.data.options.voiceVolume ??= 100;
    FlxG.save.data.options.streamedMusic ??= true;
    FlxG.save.data.options.streamedVocals ??= false;
    FlxG.save.data.options.missSounds ??= true;
    FlxG.save.data.options.copyrightBypass ??= false;
    FlxG.save.data.options.subtitles ??= true;

    //Appearance Options
    FlxG.save.data.options.lowMemory ??= true;
    FlxG.save.data.options.vramSprites ??= true;
    FlxG.save.data.options.flashingLights ??= true;
    FlxG.save.data.options.shaders ??= 'all';
    FlxG.save.data.options.botplayUI ??= true;
    FlxG.save.data.options.bgBlur ??= 0;
    FlxG.save.data.options.bgDim ??= 0;
    FlxG.save.data.options.rapidCam ??= true;
    FlxG.save.data.options.breakTime ??= true;
    FlxG.save.data.options.timeBar ??= true;
    FlxG.save.data.options.comboPosPercent ??= 0;
    FlxG.save.data.options.cinematicBars ??= true;
    FlxG.save.data.options.healthIcons ??= true;
    FlxG.save.data.options.songCredits ??= true;
    FlxG.save.data.options.stampKeybinds ??= false;
    FlxG.save.data.options.autoPause ??= true;
    FlxG.save.data.options.splashScreen ??= true;

    //Notes Options
    FlxG.save.data.options.noteskin ??= 'Arrows';
    FlxG.save.data.options.noteScale ??= 1;
    FlxG.save.data.options.noteColors ??= [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F];

    //Control Options
    //FlxG.save.data.options.controls ??= {};
    //will have to be reserved elsewhere

    //Gameplay Options
    FlxG.save.data.options.coloredBar ??= true;
    FlxG.save.data.options.modcharts ??= 'Always';
    FlxG.save.data.options.dialogue ??= [true, true, false]; //Story Mode, Playlists, Freeplay
    FlxG.save.data.options.scrollSpeed ??= false;
    FlxG.save.data.options.scrollSpeed_Speed ??= 3;
    FlxG.save.data.options.pauseCountdown ??= true;
    FlxG.save.data.options.skipGameOver ??=false;
    //Why is it a choice option????
    //FlxG.save.data.options.skipGameOver ??='off';
    FlxG.save.data.options.skipSongIntro ??= false;
    FlxG.save.data.options.scrollMode ??= 'Top';
    FlxG.save.data.options.middleScroll ??= false;
    FlxG.save.data.options.storyDialogue ??= true;
    FlxG.save.data.options.freeplayDialogue ??= true;
    FlxG.save.data.options.ghostTapping??=true;
    FlxG.save.data.options.songOffset??=0;

    //Debug/dev
    FlxG.save.data.options.editorResize??=true;
    FlxG.save.data.options.editorSFX??=true;
    FlxG.save.data.options.prettyChart??=true;
    FlxG.save.data.options.prettyChara??=true;
    FlxG.save.data.options.prettyStage??=true;
    FlxG.save.data.options.editorBlur??=true;
    FlxG.save.data.options.editorAutosave??=true;
    FlxG.save.data.options.editorAutosaveTime??=60;
    FlxG.save.data.options.editorSaveWarnTime??=15;
    FlxG.save.data.options.editorSaveFolder??=true;
    FlxG.save.data.options.charterOffset??=true;

    //Game Statistics
    FlxG.save.data.gameStats ??= {};
    FlxG.save.data.gameStats.discoveries ??= [
        "Bamber's Farm"=> false,
        "Davey's Yard"=> false,
        "Romania Outskirts"=> false
    ];

    FlxG.save.data.gameStats.playtime ??= 0;
    FlxG.save.data.gameStats.clearedSongs ??= [];
    FlxG.save.data.gameStats.achievements ??= [];
    FlxG.save.data.gameStats.deaths ??= 0;

    //Tags?
    FlxG.save.data.freeplayShit ??= {};
    FlxG.save.data.freeplayShit.favourites ??= [];

    FlxG.save.flush();
    savetheshit();
}

function postStateSwitch() {
    WindowUtils.set_prefix('Bamber & Davey Vol. 2.5 | ');
    if (stateQuotes[ModState.lastName] != null && Type.getClassName(Type.getClass(FlxG.state)) == 'funkin.backend.scripting.ModState') {
        WindowUtils.set_winTitle(stateQuotes[ModState.lastName]);
        DiscordUtil.changePresence(stateQuotes[ModState.lastName], null);
    }
    if(Type.getClassName(Type.getClass(FlxG.state)) != 'funkin.game.PlayState'){
        cursorName="default";
        clickCursorGraphic = Assets.getBitmapData(Paths.image('cursors/'+cursorName+'_waiting'));
    }
    idleCursorGraphic = Assets.getBitmapData(Paths.image('cursors/'+cursorName));
    FlxG.mouse.load(idleCursorGraphic,1,1,1);
    FlxG.game.addShader(colorMatrixFilterGLOBAL);
    FlxG.game.addShader(colorMatrixFilterGLOBAL2);
    updateColorMatrix();
}

function postUpdate(elapsed) {
    if (FlxG.mouse.visible) {
        isHovering = false;

        for (i in clickableObjects) {
            if (FlxG.mouse.overlaps(i)) {
                isHovering = true;
                break;
            }
        }

        if (isHovering && !switched) {
            FlxG.mouse.load(clickCursorGraphic,1,1,1);
            switched = true;
        } else if (!isHovering && switched) {
            FlxG.mouse.load(idleCursorGraphic,1,1,1);
            switched = false;
        }
    }
}

function preStateCreate() {
    clickableObjects = [];
    isHovering = switched = false;
}

function preStateSwitch() { //Switch to where it was meant to be
    if (Type.getClassName(Type.getClass(FlxG.game._requestedState)) == "funkin.menus.TitleState"&&FlxG.save.data.options.splashScreen) FlxG.game._requestedState = new ModState("BND/SplashScreen");

    FlxG.mouse.useSystemCursor = false;
    for (a in [colorMatrixFilterGLOBAL,colorMatrixFilterGLOBAL2])
		FlxG.game.removeShader(a);
}

function update(elapsed) {
    if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.R) //DEV: Restarting game
        FlxG.resetGame();

    if (FlxG.keys.justPressed.ANY) {FlxG.mouse.visible = false;} //i wish there was a Controls version so that the gamepad is supported
    if (FlxG.mouse.justMoved || FlxG.mouse.justPressed || FlxG.mouse.justPressedMiddle ||FlxG.mouse.justPressedRight) {FlxG.mouse.visible = true;}
}

public static function getVolume(initValue = 1, type = 'sfx') {
    return initValue * switch (type) { case 'music': FlxG.save.data.options.musicVolume; case 'sfx': FlxG.save.data.options.sfxVolume; default: FlxG.save.data.options.voiceVolume;}/100;
}

public static function pushToClickables(obj) {
    clickableObjects.push(obj);
    return;
}

public static function removeFromClickables(obj) {
    clickableObjects.remove(obj);
    return; //apparently returns are what makes global functions actually global, i think
}

public static function clearClickables() {
    clickableObjects = [];
    return;
}

public static function getClickables() {
    return clickableObjects;
}

public static function playBamberMenuSound(type) {
    return FlxG.sound.play(Paths.sound('menuSounds/'+type), getVolume(1, 'sfx'));
}

public static function resetTheModSave() {
}

public static function changeFpsFont(theFuckingFont:String) {
    Framerate.fpsCounter.fpsNum.defaultTextFormat = Framerate.fpsCounter.fpsLabel.defaultTextFormat = Framerate.memoryCounter.memoryText.defaultTextFormat = Framerate.memoryCounter.memoryPeakText.defaultTextFormat = Framerate.codenameBuildField.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font(theFuckingFont)));
}

function onDiscordPresenceUpdate(e) {
	var data = e.presence;

	if(data.button1Label == null)
		data.button1Label = "Play the mod!";
	if(data.button1Url == null)
		data.button1Url = "https://github.com/HELLISH666-warframe/Bamber-and-Davey-unofficial-hot-fix-legacy-dlc";
}

public static function savetheshit() {
    // save it
    Options.framerate=FlxG.save.data.options.framerate;
    Options.week6PixelPerfect=FlxG.save.data.options.pixelperfect;
    FlxG.autoPause=Options.autoPause=FlxG.save.data.options.autoPause;
    Options.songOffset=FlxG.save.data.options.songOffset;
    Options.ghostTapping=FlxG.save.data.options.ghostTapping;
    Options.antialiasing=FlxG.save.data.options.antialiasing;
    Options.colorHealthBar=FlxG.save.data.options.coloredBar;
    Options.lowMemoryMode=FlxG.save.data.options.lowMemory;
    Options.streamedMusic=FlxG.save.data.options.streamedMusic;
    Options.streamedVocals=FlxG.save.data.options.streamedVocals;
    Options.gpuOnlyBitmaps=FlxG.save.data.options.vramSprites;
    Options.downscroll=FlxG.save.data.options.scrollMode=='Top'? false: true;
    Options.intensiveBlur=FlxG.save.data.options.editorBlur;
    Options.editorSFX=FlxG.save.data.options.editorSFX;
    Options.editorCharterPrettyPrint=FlxG.save.data.options.prettyChart;
    Options.editorCharacterPrettyPrint=FlxG.save.data.options.prettyChara;
    Options.editorStagePrettyPrint=FlxG.save.data.options.prettyStage;
    Options.editorsResizable=FlxG.save.data.options.editorResize;
    Options.songOffsetAffectEditors=FlxG.save.data.options.charterOffset;
    Options.charterAutoSaves=FlxG.save.data.options.editorAutosave;
    Options.charterAutoSaveTime=FlxG.save.data.options.editorAutosaveTime;
    Options.charterAutoSaveWarningTime=FlxG.save.data.options.editorSaveWarnTime;
    Options.charterAutoSavesSeparateFolder=FlxG.save.data.options.editorSaveFolder;
    Options.save();
    if (FlxG.updateFramerate < Options.framerate) FlxG.drawFramerate = FlxG.updateFramerate = Options.framerate;
	else FlxG.updateFramerate = FlxG.drawFramerate = Options.framerate;

    //Window_shit.
    if(!window.fullscreen) window.borderless=FlxG.save.data.options.borderless;
    window.fullscreen=FlxG.save.data.options.fullscreen;
    updateColorMatrix();
    FlxG.save.flush();
}