import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxStringUtil;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import ColoredNoteShader;
import flixel.math.FlxRect;
public var timerBG:FlxSprite = null;
public var timerBar:FlxBar = null;
public var timerText:FlxText = null;
public var timerNow:FlxText = null;
public var timerFinal:FlxText = null;
public var songLength = FlxG.sound.music.length;

var barColors =[FlxColor.fromInt(dad.iconColor), FlxColor.fromInt(boyfriend.iconColor)];
var maskTimeBar = new FlxSprite(434,27.25);
function create() {
	timerBG = new FlxSprite(0, 10);
	timerBG.loadGraphic(Paths.image('timeBar'));
	timerBG.camera = camHUD;
	timerBG.antialiasing = true;
	timerBG.screenCenter(FlxAxes.X);
	timerBG.visible = false;
	timerBar = new FlxBar(timerBG.x + 2, timerBG.y + 2, 'LEFT_TO_RIGHT', Std.int(timerBG.width - 4), Std.int(timerBG.height - 4));
	timerBar.camera = camHUD;
	timerBar.screenCenter(FlxAxes.X);
	timerBar.antialiasing = true;

	var color:FlxColor;
	if (dad != null)
		timerBar.createGradientBar([0xFF222222], [color = CoolUtil.getColorFromDynamic(dad.xml.get("color")), FlxColor.subtract(color, 0x00333333)], 1, 90);
	else
		timerBar.createGradientBar([0xFF222222], [0xFF7163F1, 0xFFD15CF8], 1, 90);
	timerBar.visible = false;

	timerText = new FlxText(timerBG.x, timerBG.y + (timerBG.height / 2), 0, "/");
	timerText.setFormat(Paths.font("vcr.ttf"), Std.int(24), FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	timerText.camera = camHUD;
	timerText.antialiasing = true;
	timerText.visible = false;
	timerText.y -= timerText.height / 2;
	timerText.x = (FlxG.width / 2) - (timerText.width / 2);

	var x = -10 + (timerText.width > timerBG.width ? timerText.x : timerBG.x);
	timerNow = new FlxText(x, timerText.y, 0, "0:00");
	timerNow.setFormat(Paths.font("vcr.ttf"), Std.int(24), FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	timerNow.camera = camHUD;
	timerNow.antialiasing = true;
	timerNow.visible = false;
	timerNow.x = x - timerNow.width;

	var x = 10 + (timerText.width > timerBG.width ? timerText.x + timerText.width : timerBG.x + timerBG.width);
	timerFinal = new FlxText(x, timerText.y, 0, "0:00");
	timerFinal.setFormat(Paths.font("vcr.ttf"), Std.int(24), FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	timerFinal.camera = camHUD;
	timerFinal.antialiasing = true;
	timerFinal.visible = false;

	if (FlxG.save.data.options.timeBar) {
		add(timerBar);
		add(timerBG);
		add(timerText);
		add(timerNow);
		add(timerFinal);
	}
}

function onStartCountdown() {
    if (timerBar != null){
		timerBar.setParent(Conductor, "songPosition");
		timerBar.setRange(0, Math.max(inst.length, 1000));
	}
	for (elem in [timerText, timerBG, timerBar, timerNow, timerFinal])
		if (elem != null) {
			var oldAlpha = elem.alpha;
			elem.alpha = 0;
			FlxTween.tween(elem, {alpha: oldAlpha}, 0.75, {ease: FlxEase.quartInOut});
			elem.visible = true;
		}
}

function update(elapsed:Float) {
	if (timerText != null && timerText.visible) {
		//scripts.executeFunc("onPreTimerUpdate", [elapsed]);
		var pos = Math.max(Conductor.songPosition, 0);
		var timeNow = Math.floor(pos / 60000)+':'+CoolUtil.addZeros(Std.string(Math.floor(pos / 1000) % 60), 2);
		var length = Math.floor(inst.length / 60000)+':'+CoolUtil.addZeros(Std.string(Math.floor(inst.length / 1000) % 60), 2);
		timerText.x = (FlxG.width / 2) - (timerText.width / 2);

		var x = -10 + (timerText.x);
		timerNow.text = timeNow;
		timerNow.x = x - timerNow.width;

		timerFinal.text = length;
		timerFinal.x = 10
			+ (timerText.x + timerText.width);

		timerFinal.y = timerBG.y + (timerBG.height / 2) - (timerFinal.height / 2);
		timerNow.y = timerBG.y + (timerBG.height / 2) - (timerNow.height / 2);
		timerText.y = timerBG.y + (timerBG.height / 2) - (timerText.height / 2);
		//scripts.executeFunc("onTimerUpdate", [elapsed]);
	}
}