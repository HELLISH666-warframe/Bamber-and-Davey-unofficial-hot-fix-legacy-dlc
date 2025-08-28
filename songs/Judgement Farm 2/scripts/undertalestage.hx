import flixel.math.FlxRect;
import flixel.ui.FlxBar;
function creditSetup() {
	for (catIcons in songIcons) {
		for (icon in catIcons) {
			icon.destroy();
		}
	}
	songIcons = [];
	songTitle.angle = 0;

	songTitle.scale.set(1, 1); //Clipping rectangles are finicky when scale is modified so I gotta revert them to normal size for them to work seamlessly.
	songTitle.updateHitbox();
	songTitle.screenCenter();
    songTitle.y -= 50;

    //remove(songTitle); insert(PlayState.members.indexOf(strumLineNotes), songTitle);
    remove(songTitle); insert(9, songTitle);

    songTitle.antialiasing = songBG.antialiasing = false;

	for (catText in songTexts) {
		for (i in catText) {
            i.size = (catText.indexOf(i) == 0 ? 40 : 20);
            i.y = 380 + ((i.height + 10) * catText.indexOf(i));
            i.angle = 0;
            i.x = 400 - (25 * (songTexts.length/4)) + ((FlxG.width - 700) / songTexts.length * songTexts.indexOf(catText));

            if (catText.indexOf(i) == 0) i.x += (songTexts[1][0].width - i.width) / 3;
            if (catText.indexOf(i) > 0) i.y = catText[0].y + catText[0].height - 5 + (i.height - 2) * (catText.indexOf(i) - 1);
			
            //remove(i); insert(PlayState.members.indexOf(strumLineNotes), i);
            remove(i); insert(9, i);

            i.antialiasing = false;
		}
	}

    songBG.alpha = 1;
    songBG.screenCenter();
    //remove(songBG); insert(PlayState.members.indexOf(strumLineNotes), songBG);
    remove(songBG); insert(9, songBG);

    songBG.x = FlxG.width + 1000;
    
    adjustCreditClippingRects(songBG, songTitle, songTexts);
}

function adjustCreditClippingRects(masker, songTitle, songTexts) {
    songTitle.clipRect = new FlxRect((masker.x + masker.width/2 - songTitle.x), 0, songTitle.frameWidth + (masker.x + masker.width/2 - songTitle.x) * -1, songTitle.frameHeight);
    for (catText in songTexts) {
		for (i in catText) {
            i.clipRect = new FlxRect((masker.x + masker.width/2 - i.x), 0, i.frameWidth + (masker.x + masker.width/2 - i.x) * -1, i.frameHeight);
		}
	}
}

public function creditBehavior() {
	creditTweens.push(FlxTween.tween(songBG, {x: 200}, 1, {ease: FlxEase.quartOut, onUpdate: function(twn:FlxTween) {
        adjustCreditClippingRects(songBG, songTitle, songTexts);
    }}));

	return 4;
}

function creditEnding() {
	creditTweens.push(FlxTween.tween(songBG, {x: FlxG.width + 1000}, 1, {ease: FlxEase.quartIn, onUpdate: function(twn:FlxTween) {
        adjustCreditClippingRects(songBG, songTitle, songTexts);
    }, onComplete: function(tween) {
        creditsDestroy();
    }}));
}