
var creditHeaders = [];

function postCreate() {
	for(i in [scoreTxt,missesTxt,accuracyTxt])
	i.font=Paths.font('goodbyeDespair.ttf');
}

function creditSetup(songBG, songTitle, creditTexts, creditIcons) {
	songBG.destroy();
	songTitle.destroy();
	
	for (i in creditIcons) {
		for (icon in i) {
			icon.destroy();
		}
	}
	scripts.set('songIcons', []);

	creditTexts[0][0].angle = creditTexts[0][1].angle = 0;

	for (catText in creditTexts) {
		if (creditTexts.indexOf(catText) != 0) creditTexts[0][0].text += creditTexts[creditTexts.indexOf(catText)][0].text;

		for (i in 0...catText.length) {
			if (i == 0) {
				creditTexts[0][0].text += " by";
			} else {
				creditTexts[0][0].text += " " + catText[i].text + (i < catText.length - 2 ? ',' : i == catText.length - 2 ? ' &' : ' ');
			}
		}
		creditTexts[0][0].text += "\n";
	}
	creditTexts[0][1].text = creditTexts[0][0].text;
	creditTexts[0][1].scale.x = 1;
	creditTexts[0][1].updateHitbox();

	creditTexts[0][0].text = 'SCREENCAST';
	creditTexts[0][0].size = 40;
	creditTexts[0][1].size = 20;
	creditTexts[0][0].font = Paths.font('Coco-Sharp-Heavy-Italic-trial.ttf');

	creditTexts[0][0].y = 190;
	creditTexts[0][1].y = creditTexts[0][0].y + creditTexts[0][0].height + 15;

	creditTexts[0][0].x = creditTexts[0][1].x = 20;

	creditTexts = [creditTexts[0]];

	for (i in 0...creditTexts[0].length) {
		var creditHead = new FlxSprite(0, creditTexts[0][i].y - 10).makeGraphic(creditTexts[0][i].width + 80,creditTexts[0][i].height + 15,0x88000000);
		creditHead.cameras = [camHUD];
		insert(members.indexOf(creditTexts[0][i]), creditHead);

		creditHead.x -= creditHead.width;
		creditTexts[0][i].x -= creditHead.width;

		creditHeaders.push(creditHead);
	}

	creditTexts[0][1].y += 15;

	scripts.set('songTexts', creditTexts);
}

function creditBehavior(songBG, songTitle, songTexts, songIcons, songTweens) {
	for (i in 0...songTexts[0].length) {
		songTweens.push(FlxTween.tween(creditHeaders[i], {x: 0}, 1, {ease: FlxEase.quartOut}));
		songTweens.push(FlxTween.tween(songTexts[0][i], {x: songTexts[0][i].x + creditHeaders[i].width}, 1, {ease: FlxEase.quartOut}));
	}
	scripts.set('creditTweens', songTweens);
	return 4;
}

function creditEnding(songBG, songTitle, songTexts, songIcons, songTweens) {
	for (i in 0...songTexts[0].length) {
		songTweens.push(FlxTween.tween(creditHeaders[i], {x: creditHeaders[i].x - creditHeaders[i].width}, 1, {ease: FlxEase.quartIn}));
		songTweens.push(FlxTween.tween(songTexts[0][i], {x: songTexts[0][i].x - creditHeaders[i].width}, 1, {ease: FlxEase.quartIn, onComplete: function(tween) {
			scripts.call('creditsDestroy');
			creditHeaders[i].destroy();
		}}));
	}
	scripts.set('creditTweens', songTweens);
}