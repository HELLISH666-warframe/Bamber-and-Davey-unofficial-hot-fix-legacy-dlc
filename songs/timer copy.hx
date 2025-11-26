/*import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxStringUtil;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import NoteShader;
import flixel.math.FlxRect;
var timeTxt;
var timeBar;
var timerBG = new FlxSprite();
var songLength = FlxG.sound.music.length;

var barColors =[FlxColor.fromInt(dad.iconColor), FlxColor.fromInt(boyfriend.iconColor)];
var maskTimeBar = new FlxSprite(434,27.25);
function create() {
	timerBG = new FlxSprite(0, FlxG.height);
	timerBG.loadGraphic(Paths.image('game/timeBar'));
	timerBG.camera = camHUD;
	timerBG.antialiasing = true;
	timerBG.screenCenter(FlxAxes.X);
	timerBG.visible = false;
	timeTxt = new FlxText(42 + (FlxG.width / 2) - 248, 19, 400,curSong);
	timeTxt.setFormat(Paths.font("vcr_osd.ttf"), 32, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	timeTxt.scrollFactor.set();
	timeTxt.alpha = 1;
	timeTxt.borderSize = 2;

	
	maskTimeBar.setPosition(timeTxt.x, timeTxt.y + (timeTxt.height / 4));


	maskTimeBar.loadGraphic(Paths.image('game/TimeBar'));
	maskTimeBar.camera = camHUD;

    timeBar = new FlxBar(timerBG.x + 4, timerBG.y + 4, 'LEFT_TO_RIGHT', Std.int(timerBG.width - 8), Std.int(timerBG.height - 8), null, '', 0, 1);
	timeBar.shader = new ColoredNoteShader(barColors[0].red, barColors[0].green, barColors[0].blue, false);
	timeBar.createGradientBar([0xFF222222], [dad.iconColor], 1, 90);
	timeBar.scrollFactor.set();
	timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
	timeBar.alpha = 1;
	add(timeBar);
    add(timeTxt);
    for(i in [timeBar,timeTxt,timerBG])i.camera=camHUD;

	maskTimeBar.shader =new ColoredNoteShader(barColors[0].red, barColors[0].green, barColors[0].blue, false);
	insert(members.indexOf(timerBG)+1,maskTimeBar);
	trace(maskTimeBar.x,maskTimeBar.y);
}

function update(elapsed:Float) {
    var songCalc:Float = (songLength - Conductor.songPosition);
    if(FlxG.save.data.TimeBar == "elapsed") songCalc = Conductor.songPosition;
	if(songCalc < 0) songCalc = 0;
    timeTxt.text = FlxStringUtil.formatTime(songCalc/1000, false);

	maskTimeBar.clipRect = new FlxRect(0, 0, maskTimeBar.frameWidth / (songLength != null ? songLength : 1) * Conductor.songPosition, maskTimeBar.frameHeight);
	timerBG.clipRect = new FlxRect(timerBG.frameWidth / (songLength != null ? songLength : 1) * Conductor.songPosition, 0, maskTimeBar.frameWidth, maskTimeBar.frameHeight);
}*/