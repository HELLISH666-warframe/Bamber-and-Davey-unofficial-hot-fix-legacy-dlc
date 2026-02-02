function helicopter()
	FlxTween.tween(boyfriend, {y: -50000}, 5, {ease: FlxEase.circIn});

function postCreate() {
	if (FlxG.save.data.options.timeBar) {
		timerBG.y = healthBarBG.y + 7 * (PlayState.downscroll ? 1 : -1);
		timerBar.y = 1000000;

		timerBG.flipY = false;
		timerBG.x += 230;
		timerBar.x += 230;

		timerNow.x = timerBG.x + 30;
	}

	healthBar.y += 12 * (PlayState.downscroll ? 1 : -1);
	scoreText.y += 30 * (PlayState.downscroll ? 1 : -1);

	if (!PlayState.downscroll) scoreText.y -= -2 + scoreText.height;

	healthBarBG.x -= 150;
	healthBar.x -= 145;
	//scoreWarning.x -= 150;
	scoreText.x -= 150;

	//remove(notes); insert(PlayState.members.indexOf(iconGroup), notes);

	for (i in members) if (i != null && i.exists && i.antialiasing != null) i.antialiasing = false;

	maxHealth = 8.2;
	health = maxHealth/2;
}

var lastHealth = 4;

function miss(e) {
	health -= (lastHealth - health) * 3;
	lastHealth = health;
}

function onPlayerHit(e) {
	lastHealth = health;
}

public function onTimerUpdate(elapsed) {
	timerNow.x = timerBG.x + timerBG.width + 10;
	timerText.x = timerNow.x + timerNow.width;
	timerFinal.x = timerText.x + timerText.width;
}

function DIE() {
	FlxTween.tween(dad, {angle: 90, y: dad.y + 40, x: dad.x + 40}, 1, {ease: FlxEase.circOut});
	FlxTween.color(dad, 1, 0xFF000000, 0x71C41900, {
		onComplete: function(twn:FlxTween) {
			dad.alpha = 0;
		}
	});
	dad.cancelAnim.play('dead', true);
	defaultCamZoom=0.52;
	trace("STAY_DEAD.");
}