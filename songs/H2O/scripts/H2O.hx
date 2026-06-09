importScript("data/scripts/huds/psych");
import flixel.addons.display.FlxBackdrop;

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