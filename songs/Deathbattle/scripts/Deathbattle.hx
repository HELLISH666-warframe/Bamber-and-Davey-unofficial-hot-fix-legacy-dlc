//YCE_vars_first.
var dads = [];

import flixel.math.FlxRect;
import flixel.text.FlxTextBorderStyle;

var stage:Stage = null;

var timeNumbers = [];
var timeNote;
var timeCover;

var opponentBarBG;
var opponentBarFill;

var winnerDinnerChickenDinner = new FlxSprite().loadGraphic(Paths.image('HUD/battlegrounds/winner'));

var winnerText;

var oppName = new FlxSprite().loadGraphic(Paths.image('HUD/battlegrounds/Descriptor_G'));
var plaName = new FlxSprite().loadGraphic(Paths.image('HUD/battlegrounds/Descriptor_B'));

var opponentHealth = 2;

var playerTeam=[];

var bones = [];

var justDIED = false;
var concluded = false;

var gate1 = new FlxSprite(0,0).loadGraphic(Paths.image('HUD/battlegrounds/gate'));
var gate2 = new FlxSprite(0,0).loadGraphic(Paths.image('HUD/battlegrounds/gate'));
gate2.flipX = true;

var fight = new FlxSprite(0,0);

var defaultPoses = [];

var otherHitCounter:FlxText = new FlxText(-20, 400, FlxG.width, "Misses : 0", 16);

function create() {
	strumLines.members[3].characters[0].setPosition(134,131);
	dads.push(dad);
	dads.push(strumLines.members[3].characters[0]);
}

function postCreate() {
	preloadAssets();

	gf.x += 428;
	gf.y += -79;

	defaultPoses = [boyfriend.x, boyfriend.y, gf.x, gf.y, dad.x, dad.y, strumLines.members[3].characters[0].x, strumLines.members[3].characters[0].y];

	//New Timer
	if (FlxG.save.data.options.timeBar) {
		timeCover = new FlxSprite().loadGraphic(Paths.image('HUD/battlegrounds/Cover'));
		timeCover.camera = camHUD;
		timeCover.screenCenter();

		timeCover.y = FlxG.height - 7 - timeCover.height;
		
		insert(members.indexOf(timerText),timeCover);

		timeCover.alpha = 0;
		FlxTween.tween(timeCover, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});
	}

	if (FlxG.save.data.options.timeBar) {
		for (i in 0...3) {
			var timeNumber = new FlxSprite();
			timeNumber.frames = Paths.getSparrowAtlas("HUD/battlegrounds/timeNum");
			timeNumber.animation.addByPrefix("num", "TimeNum", 0);
			timeNumber.animation.play("num");
			timeNumber.cameras = [camHUD];
			timeNumber.screenCenter();

			timeNumber.y = FlxG.height - 30 - timeNumber.height;
			timeNumber.x = timeNumber.x - timeNumber.width + 24 + ((timeNumber.width - 21) * i);
			
			insert(members.indexOf(timerText),timeNumber);
			timeNumbers.push(timeNumber);

			timeNumber.alpha = 0;
			FlxTween.tween(timeNumber, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});
		}
	}

	timerText.destroy();
	timerText = null;
	timerNow.destroy();
	timerFinal.destroy();
	//scoreWarning.destroy();

	health = 2; //What fighting game would it be if we didn't start at max HP?

	scoreTxt.x += FlxG.width / 4;
	scoreTxt.y = healthBarBG.y + healthBarBG.height + 20;

	playerTeam.push(boyfriend); //Normally if everything was the boyfriends var, girlfiend wouldn't be included. Which is why this is necessary.
	playerTeam.push(gf); //I tried pushing gf to boyfriends but that wasn't the smartest idea.

	//Winner Screen Overlay, or a game over one
	winnerDinnerChickenDinner.scrollFactor.set();
	winnerDinnerChickenDinner.camera = camHUD;
	winnerDinnerChickenDinner.scale.set(3,3);
	winnerDinnerChickenDinner.updateHitbox();
	winnerDinnerChickenDinner.screenCenter();
	add(winnerDinnerChickenDinner);

	//Winner Text for the ending, or game over
	winnerText = new FlxText(0, 660, FlxG.width, 'You r did it!', 30);
	winnerText.alignment = 'center';
	winnerText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 4, 1);
	winnerText.camera = camHUD;
	winnerText.alpha = 0;
	add(winnerText);

	gate1.x -= gate1.width + 100;
	gate2.x = FlxG.width + 100;
	gate1.camera = camHUD;
	gate2.camera = camHUD;
	add(gate1);
	add(gate2);
	gate1.visible = gate2.visible = false;
}

function onStartCountdown() {
	for (i in members) { if (Std.isOfType(i, Character) || Std.isOfType(i, Boyfriend) && i.animation != null) i.animation.curAnim = null; }
}

var preloadedAssets = [];

function preloadAssets() { //I always found this method of preloading to be the best for now
	var PREpunch = new FlxSprite(dad.x, dad.y);
	PREpunch.frames = Paths.getSparrowAtlas("battlevfx/punch");
	add(PREpunch);
	PREpunch.alpha = 0.0001;
	preloadedAssets.push(PREpunch);

	var PREblood = new FlxSprite(dad.x, dad.y);
	PREblood.frames = Paths.getSparrowAtlas("battlevfx/blood");
	add(PREblood);
	PREblood.alpha = 0.0001;
	preloadedAssets.push(PREblood);

	var PREko = new FlxSprite(dad.x, dad.y);
	PREko.frames = Paths.getSparrowAtlas("HUD/battlegrounds/knockout");
	add(PREko);
	PREko.alpha = 0.0001;
	preloadedAssets.push(PREko);

	var comboSpr = new FlxSprite(dad.x, dad.y).loadGraphic(Paths.image('HUD/battlegrounds/Combo'));
	add(comboSpr);
	comboSpr.alpha = 0.0001;
	preloadedAssets.push(comboSpr);

	fight.frames = Paths.getSparrowAtlas("HUD/battlegrounds/fight");
	fight.animation.addByPrefix("fight", "fight", 24, false);
	fight.animation.play("fight");
	fight.cameras = [camHUD];
	fight.screenCenter();
	add(fight);
	fight.alpha = 0.00001;
}

function overrideBars(healthMask, timeMask, type) {
	//Destroy Time
	timeMask.destroy();
	timerBG.destroy();

	//Make the original health bar as needed
	healthMask.loadGraphic(Paths.image('HUD/battlegrounds/HealthFill'));

	healthBarBG.x = healthMask.x += FlxG.width / 4;

	//Opponent Health Bar
	opponentBarFill = new FlxSprite(healthBarBG.x, healthBarBG.y).loadGraphic(Paths.image('HUD/battlegrounds/HealthBar'));
	opponentBarBG = new FlxSprite(healthBarBG.x, healthBarBG.y).loadGraphic(Paths.image('HUD/battlegrounds/HealthFill'));

	opponentBarBG.x = opponentBarFill.x -= FlxG.width / 2;

	opponentBarBG.cameras = opponentBarFill.cameras = [camHUD];

	opponentBarBG.flipX = opponentBarFill.flipX = true;

	var colorShader = new CustomShader("ColoredNoteShader");
	var color = FlxG.save.data.options.coloredBar ? FlxColor.fromString('0xFFFF0000') : FlxColor.fromInt(dad.iconColor);
    opponentBarFill.shader = colorShader;
	colorShader.r = ((color >> 16) & 0xFF);
    colorShader.g = ((color >> 8) & 0xFF);
    colorShader.b = ((color) & 0xFF);
	

	insert(members.indexOf(healthBarBG),opponentBarBG);
    insert(members.indexOf(healthBarBG)+1,opponentBarFill);

	opponentBarBG.alpha = 0;
	FlxTween.tween(opponentBarBG, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});
	opponentBarFill.alpha = 0;
	FlxTween.tween(opponentBarFill, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});

	//HUD Names
	plaName.setPosition(healthBarBG.x, healthBarBG.y - plaName.height + 5);
	oppName.setPosition(opponentBarBG.x + opponentBarBG.width - oppName.width, plaName.y);
	plaName.cameras = oppName.cameras = [camHUD];
	add(plaName);
	add(oppName);
	plaName.alpha = 0;
	FlxTween.tween(plaName, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});
	oppName.alpha = 0;
	FlxTween.tween(oppName, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});
}

function postUpdate(elapsed:Float) {
	//Bar Masking to simulate the same effect as a FlxBar
	opponentBarBG.clipRect = new FlxRect(0, 0, (opponentBarBG.frameWidth - (opponentBarBG.frameWidth / 2 * opponentHealth)), opponentBarBG.frameHeight);
    opponentBarFill.clipRect = new FlxRect(opponentBarBG.frameWidth - (opponentBarBG.frameWidth / 2 * opponentHealth), 0, opponentBarBG.frameWidth - (opponentBarBG.frameWidth - (opponentBarBG.frameWidth / 2 * opponentHealth)), opponentBarBG.frameHeight);

	var maskHealthBar = scripts.get('maskHealthBar');
	maskHealthBar.clipRect = new FlxRect(0, 0, (maskHealthBar.frameWidth - (maskHealthBar.frameWidth / 2 * health)), maskHealthBar.frameHeight);
    healthBarBG.clipRect = new FlxRect(healthBarBG.frameWidth - (healthBarBG.frameWidth / 2 * health), 0, healthBarBG.frameWidth - (healthBarBG.frameWidth - (healthBarBG.frameWidth / 2 * health)), healthBarBG.frameHeight);

	//Positions icons where needed, in corners
	for(icon in [iconP1,iconP2]){
		var decBeat = Conductor.getTimeInBeats(Conductor.songPosition,curBeat);
        if (decBeat <= 0) decBeat = 1 + (decBeat % 1);
			
		var iconlerp = FlxMath.lerp(1.15, 1, FlxEase.cubeOut(decBeat % 1));
		icon.scale.set(iconlerp, iconlerp);
		icon.scale.set(iconlerp, iconlerp);

		if (icon.isPlayer) {
			icon.x = FlxG.width - 10 - icon.width;
			icon.health = (healthBar.percent / 100);
		} else {
			icon.x = 10;
			icon.health = (opponentHealth / 2);
		}

		icon.y = healthBar.y + (healthBar.height / 2) - (icon.height / 2);
	}

	//return false;
}