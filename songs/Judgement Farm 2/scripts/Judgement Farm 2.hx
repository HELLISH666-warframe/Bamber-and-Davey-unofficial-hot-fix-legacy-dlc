import flixel.math.FlxRect;
function creditSetup(songBG, songTitle, creditTexts, creditIcons) {
	for (catIcons in creditIcons) {
		for (icon in catIcons) {
			icon.destroy();
		}
	}
	creditIcons = [];
	scripts.set('songIcons', creditIcons);
	songTitle.angle = 0;

	songTitle.scale.set(1, 1); //Clipping rectangles are finicky when scale is modified so I gotta revert them to normal size for them to work seamlessly.
	songTitle.updateHitbox();
	songTitle.screenCenter();
    songTitle.y -= 50;

    remove(songTitle); insert(members.indexOf(playerStrums)+1, songTitle);

    songTitle.antialiasing = songBG.antialiasing = false;

	for (catText in creditTexts) {
		for (i in catText) {
            i.size = (catText.indexOf(i) == 0 ? 40 : 20);
            i.y = 380 + ((i.height + 10) * catText.indexOf(i));
            i.angle = 0;
            i.x = 400 - (25 * (creditTexts.length/4)) + ((FlxG.width - 700) / creditTexts.length * creditTexts.indexOf(catText));

            if (catText.indexOf(i) == 0) i.x += (creditTexts[1][0].width - i.width) / 3;
            if (catText.indexOf(i) > 0) i.y = catText[0].y + catText[0].height - 5 + (i.height - 2) * (catText.indexOf(i) - 1);
			
            remove(i); insert(members.indexOf(playerStrums)+1, i);

            i.antialiasing = false;
		}
	}

    songBG.alpha = 1;
    songBG.screenCenter();
    remove(songBG); insert(members.indexOf(playerStrums)+1, songBG);

    songBG.x = FlxG.width + 1000;
    
    adjustCreditClippingRects(songBG, songTitle, creditTexts);
}

function adjustCreditClippingRects(masker, songTitle, creditTexts) {
    songTitle.clipRect = new FlxRect((masker.x + masker.width/2 - songTitle.x), 0, songTitle.frameWidth + (masker.x + masker.width/2 - songTitle.x) * -1, songTitle.frameHeight);
    for (catText in creditTexts) {
		for (i in catText) {
            i.clipRect = new FlxRect((masker.x + masker.width/2 - i.x), 0, i.frameWidth + (masker.x + masker.width/2 - i.x) * -1, i.frameHeight);
		}
	}
}

function creditBehavior(songBG, songTitle, songTexts, songIcons, songTweens) {
	songTweens.push(FlxTween.tween(songBG, {x: 200}, 1, {ease: FlxEase.quartOut, onUpdate: function(twn:FlxTween) {
        adjustCreditClippingRects(scripts.get('songBG'), scripts.get('songTitle'), scripts.get('songTexts'));
    }}));
    scripts.set('creditTweens', songTweens);

	return 4;
}

function creditEnding(songBG, songTitle, songTexts, songIcons, songTweens) {
	songTweens.push(FlxTween.tween(songBG, {x: FlxG.width + 1000}, 1, {ease: FlxEase.quartIn, onUpdate: function(twn:FlxTween) {
        adjustCreditClippingRects(scripts.get('songBG'), scripts.get('songTitle'), scripts.get('songTexts'));
    }, onComplete: function(tween) {
        scripts.call('creditsDestroy');
    }}));
    scripts.set('creditTweens', songTweens);
}