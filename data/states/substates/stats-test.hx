//VERY_wip.
import flixel.text.FlxTextBorderStyle;
import funkin.savedata.FunkinSave;
import openfl.filters.ShaderFilter;
//import openfl.filters.ColorMatrixFilter;

var coolCam = new FlxCamera();
var curSong=FlxG.save.data.Bamber_SONGSONG;

var songName = new Alphabet(285.25, 30, 0, true);
var diff_Text = new FlxText(500, 80);

var basicScoreShit = new FlxTypedGroup();

var ratingsAndShit = new FlxText(500, 400);

var curDifficulty_CUNT:Int = 0;

var noMoreScore={
	score: 0,
	accuracy: 0,
	misses: 0,
	hits: [],
	date: null
};

function create() {
    FlxG.cameras.add(coolCam, false).bgColor = 0x00000000;

	add(bg = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK)).alpha = 0.6;
	bg.camera = coolCam;

	songName.text = curSong.displayName;
	add(songName).camera = coolCam;
	songName.screenCenter(FlxAxes.X);

	diff_Text.setFormat(Paths.font("vcr_osd.ttf"), 50, FlxColor.WHITE, "right", FlxTextBorderStyle.SHADOW, 0xFF000000);
	diff_Text.shadowOffset.set(2, 2);
	add(diff_Text).camera=coolCam;

	add(basicScoreShit).camera=coolCam;
	for (i in 0...3) {
		var item = new FlxText(500, 160+(i * 80));
		item.setFormat(Paths.font("vcr_osd.ttf"), 30, FlxColor.WHITE,"center", FlxTextBorderStyle.SHADOW, 0xFF000000);
		item.shadowOffset.set(2, 2);
		basicScoreShit.add(item);
	}
	changeDiff(0);
	FunkinSave.setSongHighscore(curSong.name,curSong.difficulties[curDifficulty_CUNT],null,{
		score: 0,
		misses: 0,
		accuracy: 0,
		hits: [],
		date: null
	}, []);
	//FunkinSave.highscores.clear();
}
function update(elapsed:Float) {
	if (controls.RIGHT_P||controls.LEFT_P) changeDiff(controls.RIGHT_P ? 1 : -1);
	if (controls.BACK) close();
}
function destroy() {
	//Destroy_the_other_stuff_later.
	FlxG.cameras.remove(coolCam);
}

public static function floorDecimal(value:Float, decimals:Int):Float{
	if (decimals < 1) return Math.floor(value);
	var tempMult:Float = 1;
	for (i in 0...decimals) tempMult *= 10;
	var newValue:Float = Math.floor(value * tempMult);
	return newValue / tempMult;
}

function changeDiff(e) {
	curDifficulty_CUNT = FlxMath.wrap(curDifficulty_CUNT + e, 0, curSong.difficulties.length - 1);
	basicScoreShit.members[0].text = "Score: "+getTheThingie('score');
	basicScoreShit.members[1].text = "Accuracy: "+getTheThingie('accuracy');
	basicScoreShit.members[2].text = "Misses: "+getTheThingie('misses');
	diff_Text.text=curSong.difficulties[curDifficulty_CUNT].toUpperCase();
	
	remove(ratingsAndShit);
	ratingsAndShit.text=getTheThingie('hits');
	ratingsAndShit.text=StringTools.replace(ratingsAndShit.text,' =>',':');
	ratingsAndShit.text=StringTools.replace(ratingsAndShit.text,',','\n\n');
	for(i in ['[',']']) ratingsAndShit.text=StringTools.replace(ratingsAndShit.text,i,'');
	ratingsAndShit.updateHitbox();
	ratingsAndShit.setFormat(Paths.font("vcr_osd.ttf"), 30, FlxColor.WHITE,"center", FlxTextBorderStyle.SHADOW, 0xFF000000);
	add(ratingsAndShit).camera=coolCam;

	for(i in 0...3)
	for(i in [diff_Text,basicScoreShit.members[i],ratingsAndShit])
	i.screenCenter(FlxAxes.X);
}

function getTheThingie(scoreThingie:String) {
	if(FunkinSave.getSongHighscore(curSong.name, curSong.difficulties[curDifficulty_CUNT]).score!=0){
		switch(scoreThingie){
			case 'score': return FunkinSave.getSongHighscore(curSong.name, curSong.difficulties[curDifficulty_CUNT]).score;
			case 'misses': return FunkinSave.getSongHighscore(curSong.name, curSong.difficulties[curDifficulty_CUNT]).misses;
			case 'accuracy': return Std.string(floorDecimal(FunkinSave.getSongHighscore(curSong.name, curSong.difficulties[curDifficulty_CUNT]).accuracy * 100, 2)).split('.').join('.')+ '%';
			case 'hits': return FunkinSave.getSongHighscore(curSong.name, curSong.difficulties[curDifficulty_CUNT]).hits;
		}
	} else {
		switch(scoreThingie){
			case 'hits': return ['???'];
			default: return '???';
		}
	}
}