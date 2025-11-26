function overrideBars(healthMask, timeMask, colors) {
	healthBarBG.color = 0xFFFF0000;
	healthMask.color = 0xFF00FF00;
}

function onNoteHit(e){
	e.ratingPrefix = "game/score/genstage/";
	switch(e.rating){
		case"sick": e.rating = "keep yourself safe";
		default: e.rating = "kill yourself";
	}
}


function creditSetup(songBG, songTitle, creditTexts, creditIcons) {
	for (catIcons in creditIcons) {
		for (icon in catIcons) {
			icon.destroy();
		}
	}
	creditIcons = [];
	scripts.set('songIcons', creditIcons);
	songTitle.angle = 0;
	songBG.destroy();

	songTitle.scale.set(0.3, 0.3);
	songTitle.updateHitbox();
	songTitle.x = 80;
	songTitle.y = 20;
	songTitle.alpha = 0;

	for (catText in creditTexts) {
		for (i in 0...catText.length) {
			if (i == 0) {
				catText[i].angle = 0;
				catText[i].scale.x = 1;
				catText[i].updateHitbox();
				catText[i].y = songTitle.y + songTitle.height + 20 + 100 * creditTexts.indexOf(catText);
				catText[i].x = 100;
				catText[0].text += ":";
				catText[0].size = 30;
				catText[0].borderSize = 4;
				catText[0].alpha = 0;
			} else { 
				catText[0].text += " " + catText[i].text + (i < catText.length - 1 ? ',' : '');
			}
		}

		catText = [catText[0]];
	}
	scripts.set('songTexts', creditTexts);
}

function creditBehavior(songBG, songTitle, songTexts, songIcons, songTweens) {
	songTweens.push(FlxTween.tween(songTitle, {alpha: 1}, 1, {ease: FlxEase.quartOut}));

	for (catText in songTexts) {
		songTweens.push(FlxTween.tween(catText[0], {alpha: 1}, 1, {ease: FlxEase.quartOut}));
	}
	scripts.set('creditTweens', songTweens);

	return 4;
}

function creditEnding(songBG, songTitle, songTexts, songIcons, songTweens) {
	songTweens.push(FlxTween.tween(songTitle, {alpha: 0}, 1, {ease: FlxEase.quartIn}));

	for (catText in songTexts) {
		songTweens.push(FlxTween.tween(catText[0], {alpha: 0}, 1, {ease: FlxEase.quartIn, onComplete: function(tween) {
			scripts.call('creditsDestroy');
		}}));
	}
	scripts.set('creditTweens', songTweens);
}
