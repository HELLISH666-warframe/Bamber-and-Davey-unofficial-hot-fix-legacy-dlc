import funkin.menus.StoryMenuState.StoryWeeklist;
import funkin.menus.StoryMenuState;

var aCamera = new FlxCamera();//Cam_for_the_substate.

var scoreText:FlxText;
var weekName:FlxText;
var weekImages:FlxSprite;
var txtTracklist:FlxText;

var selectedSmth:Bool = false;

var chapterThingyText:FlxText;

public var weekList:StoryWeeklist;

static var curWeek:Int = 0;
static var weekDiff:Int = 0;
var difficultySprites:Map<String, FlxSprite> = [];

function create() {
	FlxG.cameras.add(aCamera, false).bgColor = 0x00000000;
	weeklist = StoryWeeklist.get(true, false);
	trace(weeklist.weeks[0].difficulties);

	scoreText = new FlxText(300, 600, 0, "SCORE: 49324858", 36);
	scoreText.setFormat("w95.otf", 32);

	chapterThingyText = new FlxText(10, 50, 0, weeklist.weeks[curWeek].name, 36);
	chapterThingyText.setFormat("w95.otf", 32);

	txtTracklist = new FlxText(FlxG.width * 0.05,60, 0, "", 32);
	txtTracklist.alignment = 'center';

	txtTracklist.text = 'Tracks:';
	txtTracklist.font = Paths.font("vcr.ttf");

	for (i in weeklist.weeks[curWeek].songs) {
		txtTracklist.text = txtTracklist.text + '\n\n\n' + i.name;
	}
	txtTracklist.setPosition(300,140+ (txtTracklist.height) / 2);

	add(scoreText);
	add(chapterThingyText);
	add(txtTracklist);

	weekImages = new FlxSprite(0,0);
	add(weekImages);

	for (e in ['easy','normal','hard']) {
		var le = e.toLowerCase();
		if (difficultySprites[le] == null) {
			var diffSprite = CoolUtil.loadAnimatedGraphic(new FlxSprite(90,458),Paths.image('menus/freeplay/modes/'+le));
			diffSprite.camera = aCamera;
			diffSprite.antialiasing = true;
			add(diffSprite).scale.set(0.3,0.3);

			difficultySprites[le] = diffSprite;
		}
	}

	changeWeek(0);
	changeDiff(0);
}

function update(elapsed:Float) {
	chapterThingyText.screenCenter(FlxAxes.X);
	txtTracklist.setPosition(2,400);
	scoreText.screenCenter(FlxAxes.X);

	if (!selectedSmth) {
		if (controls.BACK) {
			new FlxTimer().start(0.02, ()-> {alive();
			close();});
		}
		if (controls.UP_P||controls.DOWN_P){
			changeWeek(controls.DOWN_P ? 1 : -1);
		}
		if (controls.RIGHT_P||controls.LEFT_P) changeDiff(controls.RIGHT_P ? 1 : -1);
		else if (controls.ACCEPT) {
			selectedSmth = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxTween.tween(FlxG.camera, {zoom: 3}, 1, {ease: FlxEase.expoIn});
			FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function() {
				play();
			});
		}
	}
}

import funkin.savedata.FunkinSave;
function changeWeek(change:Int = 0, ?stop:Bool = false):Void {
	if(stop) return;

	curWeek += change;

	if (curWeek < 0) curWeek = weeklist.weeks.length-1;
	if (curWeek >= weeklist.weeks.length) curWeek = 0;

	weekImages.loadGraphic(Paths.image('menus/storymenu/weeks/'+weeklist.weeks[curWeek].sprite));
	weekImages.screenCenter();
	weekImages.antialiasing = Options.antialiasing;
	txtTracklist.text="";
	for (i in weeklist.weeks[curWeek].songs) {
		txtTracklist.text = txtTracklist.text + '\n' + i.name;
		txtTracklist.updateHitbox();
	}
	chapterThingyText.text = weeklist.weeks[curWeek].name;
	
	trace(FunkinSave.getWeekHighscore( weeklist.weeks[curWeek].id,  weeklist.weeks[curWeek].difficulties[2]).score);
	scoreText.text="SCORE: "+ FunkinSave.getWeekHighscore(weeklist.weeks[curWeek].id, weeklist.weeks[curWeek].difficulties["hard"]).score;
	changeDiff(0);
}
var __oldDiffName = null;
function changeDiff(change:Int = 0) {
	weekDiff = FlxMath.wrap(weekDiff + change, 0, weeklist.weeks[curWeek].difficulties.length-1);

	if (__oldDiffName != (__oldDiffName = weeklist.weeks[curWeek].difficulties[weekDiff].toLowerCase())) {
		for(e in difficultySprites) e.alpha = 0.001;

		var diffSprite = difficultySprites[__oldDiffName];

		if (diffSprite != null)  diffSprite.alpha = !diffSprite.alpha;
	}
}

function play() {
	PlayState.loadWeek(weeklist.weeks[curWeek], "hard");
	FlxG.switchState(new PlayState());
}
function destroy() {
	//Destroy_the_other_stuff_later.
	FlxG.cameras.remove(aCamera);
}