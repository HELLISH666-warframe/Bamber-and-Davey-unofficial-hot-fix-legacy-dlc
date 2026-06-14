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

var foont="vcr_osd.ttf";

function postCreate() {
	if (scripts.get('customFonts')[PlayState.SONG.stage.toLowerCase()] != null)
	foont=scripts.get('customFonts')[PlayState.SONG.stage.toLowerCase()];
	timerBG.setGraphicSize(400,19);
	timerBG.updateHitbox();
	timerBG.screenCenter(FlxAxes.X);
	fakeScoreText = new FlxText(healthBar.x + (healthBar.width * 0.28), 0, FlxG.width, "A", 20);
	fakeScoreText.setFormat(Paths.font(foont), Std.int(20), 0xFFFFFFFF, 'center', FlxTextBorderStyle.OUTLINE, 0xFF000000);
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

		newTimerBar = new FlxBar(timerBG.x + 4, timerBG.y + 4, 'LEFT_TO_RIGHT', Std.int(timerBG.width - 12), Std.int(timerBG.height - 8));
		newTimerBar.y += timerBG.height - 19;
		newTimerBar.camera = camHUD;
		newTimerBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		newTimerBar.alpha = 0;
		newTimerBar.visible = false;
		insert(members.indexOf(timerBG), newTimerBar);
	}
	remove(comboGroup, true); 
	comboGroup.scale.set(0.7,0.7);
	comboGroup.updateHitbox();
	comboGroup.x -= 420;
	comboGroup.y += 320;
	updateCurStyle('Psych');
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
	comboGroup.cameras = [camHUD];
    add(comboGroup);
}

var accuracyText = '?';
function onPlayerMiss(e) {
	calculateRating();
	fakeScoreText.text = 'Score: ' + songScore + ' | Misses: ' + misses+ ' | Rating: ' + accuracyText;
}

var scoreTxtTween;
function onPlayerHit(e) {
	calculateRating();
	if(scoreTxtTween != null) scoreTxtTween.cancel();
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