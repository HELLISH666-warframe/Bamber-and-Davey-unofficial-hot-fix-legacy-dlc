function countdownBehavior(count, overrideSprite) {
	if (count == 3) {
		overrideSprite.scale.set(0.4, 1.5);
		overrideSprite.y += FlxG.height;

		FlxTween.tween(overrideSprite, {y: overrideSprite.y - FlxG.height}, startTimer.time * 0.5, {ease: FlxEase.backOut});
		FlxTween.tween(overrideSprite.scale, {y: 1, x: 1}, startTimer.time * 0.3, {ease: FlxEase.backOut});
	} else if (count == 0) {
		FlxTween.tween(overrideSprite, {y: overrideSprite.y + FlxG.height}, startTimer.time * 0.5, {ease: FlxEase.quartIn, startDelay: startTimer.time * 0.5});
		FlxTween.tween(overrideSprite.scale, {y: 1.3, x: 0.6}, startTimer.time * 0.3, {ease: FlxEase.quartIn, startDelay: startTimer.time * 0.5});
	}
}

function creditSetup(songBG, songTitle, creditTexts, creditIcons) {
	songBG.alpha = 1;
	songBG.screenCenter();
	songBG.scale.set(1,0);
	remove(songBG); insert(members.indexOf(strumLine[0]), songBG);

	songTitle.destroy();

	for (catText in creditTexts) {
		for (i in catText) {
			i.destroy();
		}
	}

	for (catIcons in creditIcons) {
		for (i in catIcons) {
			i.destroy();
		}
	}

	scripts.set('songIcons', []);
	scripts.set('songTexts', []);
}

function creditBehavior(songBG, songTitle, songTexts, songIcons, songTweens) {
	songTweens.push(FlxTween.tween(songBG.scale, {y: 1}, 0.5, {ease: FlxEase.backOut}));

    scripts.set('creditTweens', songTweens);

	return 4;
}


function creditEnding(songBG, songTitle, songTexts, songIcons, songTweens) {
	songTweens.push(FlxTween.tween(songBG.scale, {y: 0}, 0.5, {ease: FlxEase.backIn}));

    scripts.set('creditTweens', songTweens);
}