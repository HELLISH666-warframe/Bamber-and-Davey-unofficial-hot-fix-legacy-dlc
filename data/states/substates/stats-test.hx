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
	FunkinSave.setSongHighscore(curSong.name,FlxG.save.data.Bamber_song_diff[curDifficulty_CUNT],null,{
		score: 0,
		misses: 0,
		accuracy: 0,
		hits: [],
		date: null
	}, []);
	//FunkinSave.highscores.clear();

	colorMatrixFilter = new CustomShader('colorMatrix');
	colorMatrixFilter.uMultipliers = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
	coolCam.addShader(colorMatrixFilter);
	colorMatrixFilter2 = new CustomShader('colorMatrix');
	colorMatrixFilter2.uMultipliers = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
	coolCam.addShader(colorMatrixFilter2);

	colorMatrixFilter.data.uOffsets.value = [FlxG.save.data.options.brightness/ 255.0,
		FlxG.save.data.options.brightness/ 255.0,FlxG.save.data.options.brightness/ 255.0,0/ 255.0];
	var cunt = [
	1 * FlxG.save.data.options.gamma,0,0, 0, FlxG.save.data.options.brightness,
	0, 1 * FlxG.save.data.options.gamma, 0, 0, FlxG.save.data.options.brightness,
	0, 0, 1 * FlxG.save.data.options.gamma, 0, FlxG.save.data.options.brightness,
	0,                    0,                    0, 1,                     0,
	];
	
	colorMatrixFilter.uMultipliers[0] = cunt[0];
	colorMatrixFilter.uMultipliers[1] = cunt[1];
	colorMatrixFilter.uMultipliers[2] = cunt[2];
	colorMatrixFilter.uMultipliers[3] = cunt[3];
	colorMatrixFilter.uMultipliers[4] = cunt[5];
	colorMatrixFilter.uMultipliers[5] = cunt[6];
	colorMatrixFilter.uMultipliers[6] = cunt[7];
	colorMatrixFilter.uMultipliers[7] = cunt[8];
	colorMatrixFilter.uMultipliers[8] = cunt[10];
	colorMatrixFilter.uMultipliers[9] = cunt[11];
	colorMatrixFilter.uMultipliers[10] = cunt[12];
	colorMatrixFilter.uMultipliers[11] = cunt[13];
	colorMatrixFilter.uMultipliers[12] = cunt[15];
	colorMatrixFilter.uMultipliers[13] = cunt[16];
	colorMatrixFilter.uMultipliers[14] = cunt[17];
	colorMatrixFilter.uMultipliers[15] = cunt[18];

	//BULLSHIT.

	var cosA:Float = Math.cos(-50 * Math.PI / 180);
	var sinA:Float = Math.sin(-50 * Math.PI / 180);

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

	colorMatrixFilter2.uMultipliers[0] = colorM[0];
	colorMatrixFilter2.uMultipliers[1] = colorM[1];
	colorMatrixFilter2.uMultipliers[2] = colorM[2];
	colorMatrixFilter2.uMultipliers[3] = colorM[3];
	colorMatrixFilter2.uMultipliers[4] = colorM[5];
	colorMatrixFilter2.uMultipliers[5] = colorM[6];
	colorMatrixFilter2.uMultipliers[6] = colorM[7];
	colorMatrixFilter2.uMultipliers[7] = colorM[8];
	colorMatrixFilter2.uMultipliers[8] = colorM[10];
	colorMatrixFilter2.uMultipliers[9] = colorM[11];
	colorMatrixFilter2.uMultipliers[10] = colorM[12];
	colorMatrixFilter2.uMultipliers[11] = colorM[13];
	colorMatrixFilter2.uMultipliers[12] = colorM[15];
	colorMatrixFilter2.uMultipliers[13] = colorM[16];
	colorMatrixFilter2.uMultipliers[14] = colorM[17];
	colorMatrixFilter2.uMultipliers[15] = colorM[18];

	colorMatrixFilter2.data.uOffsets.value=[colorM[4] / 255.0,colorM[9] / 255.0,colorM[14] / 255.0,
	colorM[19] / 255.0
	];

	colorMatrixFilter2.data.uOffsets.value = [0,0,0,0];
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
	curDifficulty_CUNT = FlxMath.wrap(curDifficulty_CUNT + e, 0, FlxG.save.data.Bamber_SONGSONG.difficulties.length - 1);
	basicScoreShit.members[0].text = "Score: "+getTheThingie('score');
	basicScoreShit.members[1].text = "Accuracy: "+getTheThingie('accuracy');
	basicScoreShit.members[2].text = "Misses: "+getTheThingie('misses');
	diff_Text.text=FlxG.save.data.Bamber_song_diff[curDifficulty_CUNT].toUpperCase();
	
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
	if(FunkinSave.getSongHighscore(curSong.name, FlxG.save.data.Bamber_song_diff[curDifficulty_CUNT]).score!=0){
		switch(scoreThingie){
			case 'score': return FunkinSave.getSongHighscore(curSong.name, FlxG.save.data.Bamber_song_diff[curDifficulty_CUNT]).score;
			case 'misses': return FunkinSave.getSongHighscore(curSong.name, FlxG.save.data.Bamber_song_diff[curDifficulty_CUNT]).misses;
			case 'accuracy': return Std.string(floorDecimal(FunkinSave.getSongHighscore(curSong.name, FlxG.save.data.Bamber_song_diff[curDifficulty_CUNT]).accuracy * 100, 2)).split('.').join('.')+ '%';
			case 'hits': return FunkinSave.getSongHighscore(curSong.name, FlxG.save.data.Bamber_song_diff[curDifficulty_CUNT]).hits;
		}
	} else {
		switch(scoreThingie){
			case 'hits': return ['???'];
			default: return '???';
		}
	}
}