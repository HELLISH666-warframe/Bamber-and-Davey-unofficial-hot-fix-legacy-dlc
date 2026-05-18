import funkin.backend.utils.ShaderResizeFix;
import funkin.backend.system.framerate.Framerate;
import flixel.text.FlxTextBorderStyle;

var progressList = ['Astray', 'Facsimile', 'Placeholder', 'test footage'];
var progressindex = progressList.indexOf(PlayState.SONG.meta.name);

var allowLeave:Bool = true;
var time:Float = 0;

var rippleShader = new CustomShader('ripple');

var scoreTextSize = 18;
if (progressindex >= 0) {
	//engineSettings.timerSongName = engineSettings.minimizedMode = true;
	//engineSettings.scoreJoinString = '   ';
}
if (progressindex >= 1) {
	/*engineSettings.watermark = */FlxG.save.data.options.timeBar = Options.SOLO_RESET = false;
	FlxG.save.data.options.coloredBar = false;
	//engineSettings.accuracyMode = 1;
}
if (progressindex >= 2) {
	accuracyTxt.visable = false;
	Options.ghostTapping = true;
	scoreTextSize = 14;
	//popupArrows = false;
}

var shader = new CustomShader('grain');
var bloom = new CustomShader('bloom');
var scanline = new CustomShader('scanLines');
var vignette = new CustomShader('vignette');
var cooler = new CustomShader('sketchShader');

var elapsedShader:Float = 0;
var grainStrength:Float = 16;
var actualGrainStrength:Float = 16;
var chromaticaAbber:Float = 0.001;
var tempBeat:Int = 0;
var oppositeHealth:Float = 1;
var hdr:Float = 1.5;

function create(){
    FlxG.resizeWindow(FlxG.stage.window.height/3*4,FlxG.stage.window.height);
	FlxG.resizeGame(1280,960);
	FlxG.scaleMode.width = FlxG.camera.width = 1280;
	FlxG.scaleMode.height = FlxG.camera.height = 960;
	ShaderResizeFix.doResizeFix = true;
	ShaderResizeFix.fixSpritesShadersSizes();
    FlxG.stage.window.x += (FlxG.stage.window.width - FlxG.stage.window.height/3*4) / 2;

	if (!Options.lowMemoryMode) {
		camHUD.addShader(cooler);
		camHUD.addShader(bloom);
		camHUD.addShader(shader);
		camHUD.addShader(scanline);

		// camGame shader initialization
		FlxG.camera.addShader(cooler);
		FlxG.camera.addShader(bloom);
		FlxG.camera.addShader(vignette);

		// variable initialization
		bloom.hDRthingy = 1.5;
		shader.strength = 35;
		vignette.size = 1.2;
	}
}

function postCreate(){
    iconP1.setIcon("davey");
    window.title = "";
    Framerate.debugMode = camFollowLerp = camZoomingInterval = 0;
	health = 1.59;
    defaultCamZoom = 0.6;
    strumLines.members[1].characters[0].visible = FlxG.autoPause = false;
	for(i in [scoreTxt,missesTxt,accuracyTxt])
	i.font=Paths.font('vcr_osd.ttf');

	if (progressindex >= 1) {
		if (progressindex < 3) {
			fakeScoreText = new FlxText(healthBar.x + (healthBar.width * 0.28), 0, healthBar.width * (1 - 0.28), "A", 20);
			fakeScoreText.setFormat(Paths.font("vcr_osd.ttf"), Std.int(scoreTextSize), 0xFFFFFFFF, 'right', (progressindex < 2 ? FlxTextBorderStyle.OUTLINE : FlxTextBorderStyle.NONE), 0xFF000000);
			fakeScoreText.antialiasing = false;
			fakeScoreText.scale.set(1,1);
			fakeScoreText.camera = camHUD;
			fakeScoreText.screenCenter();
			fakeScoreText.y = healthBarBG.y + 30;
			add(fakeScoreText);
			fakeScoreText.alpha = 0;
			FlxTween.tween(fakeScoreText, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});
			fakeScoreText.text = 'Score: ' + songScore + (progressindex < 2 ? '   Misses: ' + misses + '   ' + 'Accuracy: 0': '');
	} else {
		for (i in members) if (i.name != null) i.destroy();
		healthBarBG.y = healthBar.y = -1000000;

		comboTxt.setFormat(Paths.font("vcr_osd.ttf"), 64, 0xFFFFFFFF, 'center', FlxTextBorderStyle.NONE, 0xFF000000);
		comboTxt.camera = camHUD;
		comboTxt.screenCenter();
		comboTxt.x += 200;
		add(comboTxt);

		boyfriend.visible = false;
	}

	/*if (progressindex >= 2) {
		for (i in unspawnNotes) {
			if (i.isSustainNote) i.alpha = 1;
		}
	}*/

	scoreTxt.visible = false;
	}
}

function update(elapsed){
	camGame.angle = 0;
	if (progressindex == 3) {
		health = 1.59;
		misses = songScore = 0;

		//scoreWarning.y = -1000000;
	}

	oppositeHealth = (2.2 - health);

	// chromatic abberation
	chromaticaAbber = FlxMath.lerp(chromaticaAbber, 0.1, 0.02);
	bloom.data.chromatic.value = [chromaticaAbber];
	if (PlayState.curBeat != tempBeat) {
		chromaticaAbber = 1;
		tempBeat = PlayState.curBeat;
	}
	hdr = 1.5 - (PlayState.misses / 20);
	bloom.data.hDRthingy.value = [hdr];
	if (hdr <= 0) gameOver();

	//grain
	elapsedShader += Std.parseFloat(elapsed);
	shader.data.iTime.value = [elapsedShader];
	grainStrength = oppositeHealth * 47;
	actualGrainStrength = FlxMath.lerp(actualGrainStrength, grainStrength, 0.01);
	shader.data.strength.value = [actualGrainStrength];

	//scanline
	scanline.data.opacity.value = [oppositeHealth/6];
}

if (progressindex < 3 && progressindex > 0) {
	function onMiss(e) {
		fakeScoreText.text = 'Score: ' + songScore + (progressindex < 2 ? '   Misses: ' + misses + '   '  + 'Accuracy: ' + (Math.floor(accuracy * 10000) / 100) : '');
	}

	function onPlayerHit(note) {
		fakeScoreText.text = 'Score: ' + songScore + (progressindex < 2 ? '   Misses: ' + misses + '   '  + 'Accuracy: '+(Math.floor(accuracy * 10000) / 100): '');
	}
}

function destroy() {
    if(allowLeave){
        FlxG.resizeWindow(1280, 720);
        FlxG.resizeGame(1280, 720);
	    FlxG.scaleMode.width = FlxG.camera.width = 1280;
	    FlxG.scaleMode.height = FlxG.camera.height = 720;
        window.opacity = 1;
        FlxG.stage.window.x -= (FlxG.stage.window.height/9*16 - FlxG.stage.window.width) / 2;
    } else {
        FlxG.switchState(new PlayState());
        window.alert("I'M NOT DONE WITH YOU.", "");
    }
    
    for(a in [shader])
        FlxG.game.removeShader(a);
}


function postUpdate(elapsed){
	iconP2.scale.x = iconP2.scale.y = 1;
	camFollow.setPosition(strumLines.members[0].characters[0].getMidpoint().x, strumLines.members[0].characters[0].getMidpoint().y);
}

function onGameOver(e){
	e.cancel();
	if(SONG.meta.name != "Test Footage"){
		PlayState.loadSong("Test Footage", "null");
		FlxG.switchState(new PlayState());
	}
	if(!FlxG.save.data.gameStats.achievements.contains('TF')) FlxG.save.data.gameStats.achievements.push('TF');
}
function onNoteHit(e){
	switch(curSong){
		case"Astray":
		e.ratingPrefix = "game/score/paintvoid/astray/";
		switch(e.rating){
			case"sick": e.rating = "sick";
			case"good": e.rating = "good";
			default: e.rating = "Bad";
		}
		case"Facsimile":
		e.ratingPrefix = "game/score/paintvoid/facsimile/";
		switch(e.rating){
			case"sick": e.rating = "Good";
			default: e.rating = "Bad";
		}
		default:
		e.ratingPrefix = "game/score/paintvoid/placeholder/";
		switch(e.rating){
			default: e.rating = "TimeBar";
			separatedScore=0;
		}
	}
}

function creditSetup(songBG, songTitle, creditTexts, creditIcons) {
	if (progressindex >= 1) {
		for (catIcons in creditIcons) {
			for (icon in catIcons) {
				icon.destroy();
			}
		}
		creditIcons = [];
		scripts.set('songIcons', creditIcons);
		songTitle.angle = 0;
		songBG.alpha = 1;
	}

	if (progressindex == 1) {
		for (catText in creditTexts) {
			for (i in 0...catText.length) {
				if (i == 0) {
					catText[i].angle = 0;
					catText[i].y = creditTexts[0][0].y;
					catText[i].x -= 25;
					catText[0].text += "\n";
					catText[0].size -= 10;
				} else { 
					catText[0].text += catText[i].text + "\n";
				}
			}

			catText = [catText[0]];
		}
		scripts.set('songTexts', creditTexts);
	} else if (progressindex == 2) {
		for (catText in creditTexts) {
			for (field in catText) {
				field.destroy();
			}
		}
		creditTexts = [];
		scripts.set('songTexts', creditTexts);
	}
}

function creditBehavior(songBG, songTitle, songTexts, songIcons, songTweens) {
	if (progressindex == 1) {
		songTweens.push(FlxTween.tween(songBG, {y: songBG.y - FlxG.height}, 1));

		songTweens.push(FlxTween.tween(songTitle, {y: songTitle.y - FlxG.height}, 1));

		for (catText in songTexts) {
			songTweens.push(FlxTween.tween(catText[0], {y: catText[0].y - FlxG.height}, 1));
		}
		scripts.set('creditTweens', songTweens);
	} else if (progressindex == 2) {
		songTitle.y -= FlxG.height;
	}

	return (progressindex == 0 ? true : 4);
}

function creditEnding(songBG, songTitle, songTexts, songIcons, songTweens) {
	if (progressindex == 1) {
		songTweens.push(FlxTween.tween(songBG, {y: songBG.y - FlxG.height}, 1));

		songTweens.push(FlxTween.tween(songTitle, {y: songTitle.y - FlxG.height}, 1, {onComplete: function(tween) {
			scripts.call('creditsDestroy');
		}}));

		for (catText in songTexts) {
			songTweens.push(FlxTween.tween(catText[0], {y: catText[0].y - FlxG.height}, 1));
		}
		scripts.set('creditTweens', songTweens);
	} else if (progressindex == 2) {
		songTitle.y -= FlxG.height;
	}
}