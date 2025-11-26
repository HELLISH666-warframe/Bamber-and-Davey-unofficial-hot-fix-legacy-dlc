import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import flixel.ui.FlxBar;

var fakeScoreText; //To simulate the changes in score.

var newTimerBar;

var rankingTexts = [
	['You Suck!', 0.2], //From 0% to 19%
	['Good grief...', 0.4], //From 20% to 39%
	['Seriously?', 0.5], //From 40% to 49%
	['Mid', 0.6], //From 50% to 59%
	['Meh', 0.69], //From 60% to 68%
	['Nice', 0.7], //69%
	['Good', 0.8], //From 70% to 79%
	['Awesome', 0.9], //From 80% to 89%
	['Bambtastic!', 1], //From 90% to 99%
	['Perfect!!', 1], //100%
];

function postCreate() {
	fakeScoreText = new FlxText(healthBar.x + (healthBar.width * 0.28), 0, FlxG.width, "A", 20);
	fakeScoreText.setFormat(Paths.font("vcr_osd.ttf"), Std.int(20), 0xFFFFFFFF, 'center', FlxTextBorderStyle.OUTLINE, 0xFF000000);
	fakeScoreText.borderSize = 1.5;
	fakeScoreText.camera = camHUD;
	fakeScoreText.screenCenter();
	fakeScoreText.y = healthBarBG.y + 30;
	add(fakeScoreText);
	fakeScoreText.alpha = 0;
	FlxTween.tween(fakeScoreText, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});
	fakeScoreText.text = 'Score: ' + songScore + ' | Misses: ' + misses + ' | Rating: ?';

	scoreTxt.visible = false;
	accuracyTxt.visible=false;
	missesTxt.visible=false;

	if (FlxG.save.data.options.timeBar) {
		timerFinal.visible = false;
		timerBG.visible = false;
		timerBar.visible = false;

		timerNow.size = 24;
		timerNow.borderSize = 2;
		timerNow.visible = false;


		newTimerBar = new FlxBar(timerBG.x + 4, timerBG.y + 4, 'LEFT_TO_RIGHT', Std.int(timerBG.width - 8), Std.int(timerBG.height - 8));
		newTimerBar.y += timerBG.height - 4;
		newTimerBar.camera = camHUD;
		newTimerBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		newTimerBar.alpha = 0;
		newTimerBar.visible = false;
		insert(members.indexOf(timerBG), newTimerBar);
	}
}

function onSongStart() {
	if (timerText != null) {
		newTimerBar.setParent(Conductor, "songPosition");
		newTimerBar.setRange(0, Math.max(inst.length, 1000));

		newTimerBar.visible = true;
		FlxTween.tween(newTimerBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		timerNow.alpha = 0;
		timerNow.visible = true;
		FlxTween.tween(timerNow, {alpha: 1}, 0.5, {ease: FlxEase.circOut});

		timerBG.alpha = 0;
		timerBG.visible = true;
		FlxTween.tween(timerBG, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
	}
}

function postUpdate(elapsed:Float) {
	if (FlxG.save.data.options.timeBar) { 
		timerText.alpha = 0;
		timerNow.screenCenter(FlxAxes.X);
	}
}

var accuracyText = '?';
function onPlayerMiss(e) {
	calculateRating();
	fakeScoreText.text = 'Score: ' + songScore + ' | Misses: ' + misses+ ' | Rating: ' + accuracyText;
}

var scoreTxtTween;
function onPlayerHit(note) {
	calculateRating();
	if(scoreTxtTween != null) {
		scoreTxtTween.cancel();
	}
	fakeScoreText.scale.x = 1.075;
	fakeScoreText.scale.y = 1.075;
	scoreTxtTween = FlxTween.tween(fakeScoreText.scale, {x: 1, y: 1}, 0.2, {
		onComplete: function(twn:FlxTween) {
			scoreTxtTween = null;
		}
	});
	fakeScoreText.text = 'Score: ' + songScore + ' | Misses: ' + misses + ' | Rating: ' + accuracyText;
}


function calculateRating() {
	var ratingName = '';

	if (accuracy >= 1) ratingName = rankingTexts[rankingTexts.length - 1][0];
	else {
		for (i in 0...rankingTexts.length-1)
		{
			if(accuracy < rankingTexts[i][1])
			{
				ratingName = rankingTexts[i][0];
				break;
			}
		}
	}

	var advancedRating = "";
    if (misses > 0) {
        if (misses == 0) {
            var t = "FC";
            for (r in ratings) {
                if (hits[r.name] > 0 && r.fcRating != null) {
                    t = r.fcRating;
                    }
                }
            advancedRating = t;
        }
    	else if (misses < 10) advancedRating = "SDCB"
		else if (misses > 0) advancedRating = "Clear";
    }


	accuracyText = ratingName + ' (' + (Math.floor(accuracy * 10000) / 100) + '%) - ' + advancedRating;
}

var thineCreditObjects = [];

var lastTime = 0;
var activateCreaits = false;
function creditUpdate(songBG, songTitle, creditTexts, creditIcons, elapsed) {
	if (activateCreaits) {
		lastTime += elapsed;
		songBG.shader.data.uTime.value = [lastTime];

		for (catText in creditTexts) {
			for (i in catText) {
				i.updateMotion(elapsed); //for some reason you have to call it
			}
		}
	}
}

function creditIconBehavior(songIcons, songTexts, elapsed) {
	for (catText in songIcons) {
		for (icon in catText) {
			if (icon != null) {
				var decBeat = Conductor.getTimeInBeats(Conductor.songPosition,curBeat);
                 if (decBeat <= 0) decBeat = 1 + (decBeat % 1);
						
				var iconlerp = FlxMath.lerp(songTexts[0][1].height * 2 * 1.3, songTexts[0][1].height * 2, FlxEase.cubeOut(decBeat % 1));
				icon.setGraphicSize(iconlerp);
			}
		}
	}

	return false;
}

function creditSetup(songBG, songTitle, creditTexts, creditIcons) {
	songBG.screenCenter();
	songBG.shader = new CustomShader('textureoffset');
	songBG.shader.speed = 0.255;
	songBG.alpha = 0;
	remove(songBG); insert(members.indexOf(strumLines), songBG);

	songTitle.screenCenter();
	songTitle.x += 500;
	songTitle.y -= 50;
	songTitle.angle = 0;
	remove(songTitle); insert(members.indexOf(strumLines), songTitle);

	songTitle.x -= FlxG.width;

	var lastIndex = [-1,0];
	
	for (catText in creditTexts) {
		for (i in catText) {
			i.screenCenter();
			i.angle = 0;

			if (catText.indexOf(i) == 0) i.y += FlxG.random.float(-60, 60);
			else {
				i.y = catText[0].y + catText[0].height/2 - i.height/2;
			}
			
			i.x = (lastIndex[0] == -1 ? songTitle.x : creditTexts[lastIndex[0]][lastIndex[1]].x) - i.width - 20;

			if (catText.indexOf(i) == 0 && creditTexts.indexOf(catText) != 0) i.x -= 50;

			lastIndex[1]++;

			if (lastIndex[0] == -1) {
				lastIndex = [0, 0];
			}

			if (lastIndex[1] > creditTexts[lastIndex[0]].length - 1) {
				lastIndex[1] = 0;
				lastIndex[0]++;
			}

			remove(i); insert(members.indexOf(strumLines), i);
		}
	}

	for (catIcon in creditIcons) {
		for (i in catIcon) {
			i.angle = 0;

			var targetCredit = creditTexts[creditIcons.indexOf(catIcon)][catIcon.indexOf(i) + 1];
			i.x = targetCredit.x + targetCredit.width/2 - i.width/2;
			i.y = targetCredit.y + targetCredit.height/2 - i.height/2 + (i.height + 20) * (targetCredit.y + targetCredit.height/2 > songBG.y + songBG.height/2 ? -1 : 1);
			remove(i); insert(members.indexOf(strumLines), i);
		}
	}
}


function creditBehavior(songBG, songTitle, songTexts, songIcons, songTweens) {
	songTweens.push(FlxTween.tween(songBG, {alpha: 0.6}, 1, {ease: FlxEase.quartOut}));
	activateCreaits = true;
    scripts.set('creditTweens', songTweens);

	songTitle.velocity.x = 450;

	for (catIcon in songTexts) {
		for (i in catIcon) {
			i.initMotionVars();
			i.velocity.x = 450;
		}
	}

	for (catIcon in songIcons) {
		for (i in catIcon) {
			i.velocity.x = 450;
		}
	}

	return 8;
}

function creditEnding(songBG, songTitle, songTexts, songIcons, songTweens) {
	songTitle.destroy();

	for (acc in [songTexts, songIcons]) {
		for (cat in acc) {
			for (i in cat) {
				i.destroy();
			}
		}
	}
	scripts.set('songTexts', []);
	scripts.set('songIcons', []);

	songTweens.push(FlxTween.tween(songBG, {alpha: 0}, 1, {ease: FlxEase.quartIn, onComplete: function(tween:FlxTween) {
		activateCreaits = false;
		scripts.call('creditsDestroy');
	}}));
    scripts.set('creditTweens', songTweens);
}