//YCE_vars_first.
var dads = [];

import flixel.math.FlxRect;
import flixel.text.FlxTextBorderStyle;

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

	var comboSpr = new FlxSprite(dad.x, dad.y).loadGraphic(Paths.image('game/score/battlegrounds/Combo'));
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


	for (i in 0...comboObjects.length) {
		comboObjects[i].x = comboPositions[i][0] + FlxG.random.float(combo/-50, combo/50);
		comboObjects[i].y = comboPositions[i][1] + FlxG.random.float(combo/-50, combo/50);
		comboObjects[i].angle = comboPositions[i][2] + FlxG.random.float(combo/-90, combo/90);
	}

	if (creditTimer != null) creditTimer.active = !paused;
}

function update(elapsed:Float) {
	if (FlxG.save.data.options.timeBar) {
		var pos = Math.max(Conductor.songPosition, 0);
		var time = CoolUtil.addZeros(Std.string(Math.floor(inst.length / 1000) - Math.floor(pos / 1000)), 3).split('');

		for (i in 0...3) {
			timeNumbers[i].animation.curAnim.curFrame = time[i];
		}
	}
	
	//Handler for bones that will fly out
	for (i in 0...bones.length) {
		bones[i].velocity.y += 15;

		if (bones[i].y >= boyfriend.y + 500) {
			bones[i].destroy();
			bones[i] = null;
		}
	}
	bones = bones.filter(function(i) return i != null);

	//For the ending when Manny and Grug will be flown out.
	if (curBeat >= 576) {
		dad.velocity.y += 5;
		grugSecondary.velocity.y += 5;
	}

	//I'll_do_THIS_shit_later.
	/*
	//Game Over Input Handler
	if (concluded || justDIED) {
		Conductor.songPosition = -5000;
		Conductor.songPositionOld = -5000;
		
		if (justDIED) {
			var camPos = dad.getGraphicMidpoint();
			camFollow.setPosition(camPos.x, camPos.y);

			if (concluded && controls.ACCEPT) {
				concluded = false;

				FlxG.sound.playMusic(Paths.sound(GameOverSubstate.retrySFX, 'mods/'+mod));
				FlxG.sound.play(Paths.sound('battlefx/gateclose'), 0.6);
				gate1.visible = gate2.visible = true;
				FlxTween.tween(gate2, {x: FlxG.width / 2}, 1.5, {ease: FlxEase.quartInOut});
				FlxTween.tween(gate1, {x: 0}, 1.5, {ease: FlxEase.quartInOut, onComplete: function(tween) {
					unspawnNotes = [];
	
					strumLineNotes.clear();
					playerStrums.clear();
					cpuStrums.clear();

					hits['Sick'] = hits['Good'] =  hits['Bad'] = hits['Shit'] = combo = misses = songScore = accuracy = numberOfNotes = numberOfArrowNotes = delayTotal = 0;

					pressedArray = [];

					for (i in [boyfriend, dad, gf, grugSecondary]) {
						i.velocity.x = i.velocity.y = 0;
						i.mass = 0;

						i.lastNoteHitTime = -60000;
						i.animation.reset();
						i.animation.finish();
					}

					boyfriend.setPosition(defaultPoses[0], defaultPoses[1]);
					gf.setPosition(defaultPoses[2], defaultPoses[3]);
					dad.setPosition(defaultPoses[4], defaultPoses[5]);
					grugSecondary.setPosition(defaultPoses[6], defaultPoses[7]);

					winnerText.alpha = 0;

					PlayState.scripts.executeFunc('reset', []);

					defaultCamZoom = 0.9;

					new FlxTimer().start(1.5, function(tmr:FlxTimer) {
						FlxG.sound.play(Paths.sound('battlefx/gateopen'), 0.6);

						FlxTween.tween(winnerDinnerChickenDinner.scale, {x: 3, y: 3}, 1, {ease: FlxEase.quartInOut, onUpdate: function() {
							winnerDinnerChickenDinner.updateHitbox();
							winnerDinnerChickenDinner.screenCenter();
						}});	

						FlxTween.tween(gate2, {x: FlxG.width + 100}, 1.5, {ease: FlxEase.quartInOut});
						FlxTween.tween(gate1, {x: 0 - gate1.width - 100}, 1.5, {ease: FlxEase.quartInOut, onComplete: function(tween) {
							gate1.visible = gate2.visible = false;
							justDIED = false;
							paused = false;
							blockPlayerInput = false;
							engineSettings.resetButton = wasResetButton;
							boyfriend.stunned = false;

							FlxG.sound.music.stop();
							inst = null;
							generateSong(PlayState.SONG.song);
							startCountdown();

							PlayState.scripts.executeFunc('setSplashes', []);

							health = 2;
							opponentHealth = 2;

							remove(strumLineNotes);
							insert(PlayState.members.indexOf(PlayState.scripts.getVariable('bar2'))+1, strumLineNotes);
							remove(notes);
							insert(PlayState.members.indexOf(strumLineNotes)+1, notes);

							for (elem in [
								iconP1, iconP2, scoreText, healthBarBG, hitCounter, opponentBarBG, opponentBarFill, oppName, plaName, timeCover, timeNote, timeNumbers[0], timeNumbers[1], timeNumbers[2]
							])
							{
								if (elem != null)
								{
									FlxTween.tween(elem, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});
								}
							}
						}});
					});
				}});
			}
	
			if (concluded && controls.BACK) {
				FlxG.save.data.vs_bamber_hasDiedInThisSong = null;
				FlxG.switchState(new FreeplayState());
			}
		} else {
			var camPos = gf.getGraphicMidpoint();
			camFollow.setPosition(camPos.x, camPos.y);

			if (concluded && controls.ACCEPT) endSong();
		}
	}*/
}

//Makes the player punch with every note hit. At least ones that warrant it.
/*
function onPlayerHit(e) {
	if (!e.isSustainNote && Math.floor(e.noteData / (PlayState.SONG.keyNumber * 2)) != 5) {
		opponentHealth -= 0.0015;
		punch(dads, FlxG.random.int(0,dads.length-1), FlxG.random.int(0,100) > 80, FlxG.random.int(0,100) > 80);
	}
}*/
function onPlayerHit(e) {
    e.showRating=false;
    if(e.note.isSustainNote)return;
    onShowCombo(combo+1,fuckingKillMe(e.rating));
    e.healthGain = 0;
	e.healthGain = combTestShit[e.rating].health;
}
function fuckingKillMe(fuckingValue:String)
    for (i in 0...combTestShit.length)
        if(combTestShit[i].name.toLowerCase()==fuckingValue)return combTestShit[i].image;

var comboSprite = new FlxSprite();
var comboTweens = [];
var comboObjects = [];
var comboPositions = [];

var comboTimers = [];


//An Effect for when a miss occurs, regular or ghost tapping misses.
function onPlayerMiss(e) {
	punch(playerTeam, FlxG.random.int(0,playerTeam.length-1), true, true);
	scripts.call('shake', [0.5]);

	if (comboTimers.length > 0) {
		for (i in comboTweens) i.finish();
		comboTweens = [];

		for (i in comboObjects) {
			comboTweens.push(FlxTween.tween(i, {angle: FlxG.random.float(-20, 20), y: i.y + FlxG.random.float(20, 50), alpha: 0}, 0.2, {ease: FlxEase.circIn, onComplete: function(tween) {
				remove(i);
			}}));
		}
		comboObjects = [];
		comboPositions = [];
		for (i in comboTimers) if (i != null) i.cancel();
		comboTimers = [];
	}
}
var thing = new FlxSprite();
function spawnJudgement(lastRating) {
	var tweens:Array<VarTween> = [];

    var strumsX:Float = 0;
    var strumsY:Float = 0;
    var strumScale:Float = 0;
    var strumCount = 0;

	for (e in playerStrums.members) {
        if (e != null) {
            strumsX += e.x + (e.width / 2);
            strumsY += e.y + (e.height / 2);
            strumScale += e.notesScale/7*4;
            strumCount++;
        }
    }
    strumsX /= strumCount;
    strumsY /= strumCount;
    strumScale /= strumCount;

    thing.x = Math.max(Math.min(strumsX, FlxG.width - 80), 20);
    thing.y = Math.max(Math.min(strumsY - FlxG.height/2*(PlayState.downscroll ? 1 : -1), FlxG.height - 80), 20);

	var rating:FlxSprite = new FlxSprite().loadGraphic(Paths.image(lastRating));
    rating.centerOrigin();

    rating.x = thing.x - rating.width/2;
    rating.y = thing.y - rating.height/2;
    rating.cameras = [camHUD];
    rating.antialiasing = lastRating.antialiasing;
    add(rating);

    rating.alpha = 0;
    rating.y -= 20;
    tweens.push(FlxTween.tween(rating, {y: rating.y + 30, alpha: 1}, 0.15, {
        onComplete: function(tween:FlxTween)
        {
            tweens.push(FlxTween.tween(rating, {alpha: 0}, 0.2, {
                onComplete: function(tween:FlxTween)
                {
                    rating.destroy();
                },
                startDelay: 0.5
            }));
        },
        ease: FlxEase.quartOut
    }));

	//if (engineSettings.maxRatingsAllowed > -1) optimizedTweenSet.push(tweens);
}

function onShowCombo(combo:Int, coolText:FlxText) {
	spawnJudgement(coolText);

	otherHitCounter.text = 'Brutal: '+hits['Brutal']+'\r\nStrong: '+hits['Strong']+'\r\nAverage: '+hits['Average']+'\r\nWeak: '+hits['Weak'];
	otherHitCounter.y = (FlxG.height / 2) - (otherHitCounter.height / 2);

	if (PlayState.combo == 1) for (i in comboTweens) i.finish();

    thing.x = 160;
    thing.y = FlxG.height/2 - 130 * (PlayState.downscroll ? 1 : -1);

	if (comboObjects[0] == null) {
		var comboSpr = new FlxSprite(thing.x, thing.y).loadGraphic(Paths.image('game/score/battlegrounds/Combo'));
		comboSpr.cameras = [camHUD];
		comboSpr.y -= comboSpr.height/2;
		add(comboSpr);
		comboObjects.push(comboSpr);
		comboPositions.push([comboSpr.x, comboSpr.y, 0]);
		comboSpr.antialiasing = Options.antialiasing;

		comboSpr.centerOrigin();
	}

	var splitCombo = Std.string(combo).split('');
	
	for (i in 0...splitCombo.length) {
		if (comboObjects[i+1] == null) {
			var comboNum = new FlxSprite(thing.x, thing.y + 20);
			comboNum.frames = Paths.getSparrowAtlas('game/score/battlegrounds/comboNum');
			comboNum.animation.addByPrefix('num', 'Num', 0, false);
			comboNum.animation.play('num');
			comboNum.cameras = [camHUD];
			comboNum.y -= comboNum.height/2 + FlxG.random.float(-5, 30);
			comboNum.x -= comboNum.width - 40 + ((comboNum.width - 6) * i);
			add(comboNum);
			comboObjects.push(comboNum);
			comboPositions.push([comboNum.x, comboNum.y, FlxG.random.float(-10, 10)]);
			comboNum.antialiasing = Options.antialiasing;

			comboNum.centerOrigin();
		}

		comboObjects[i+1].animation.curAnim.curFrame = splitCombo[splitCombo.length - i - 1];
	}

	for (i in 0...comboObjects.length) {
		if (comboTimers[i] == null) {
			comboObjects[i].alpha = 0;
			comboObjects[i].scale.set(1.5, 1.5);
			comboTweens.push(FlxTween.tween(comboObjects[i], {alpha: 1}, 0.15, {ease: FlxEase.circIn}));
			comboTweens.push(FlxTween.tween(comboObjects[i].scale, {x: 1, y: 1}, 0.15, {ease: FlxEase.circIn}));

			comboTimers[i] = new FlxTimer().start(3, function(tmr) {
				comboTweens.push(FlxTween.tween(comboObjects[i], {alpha: 0}, 0.15, {ease: FlxEase.circIn}));
				comboTimers[i] = null;
			});
		} else {
			comboTimers[i].reset(3);
		}
	}

    return false;
}/*

//Handler for Big Hits
function beatHit(curBeat) {
	stage.onBeat();

	if (curBeat == 256 || curBeat == 576) {
		opponentHealth = curBeat == 256 ? 1.25 : 0; //Fakes the damage the big hit does, it's static
		var xPoses = [boyfriend.x, gf.x]; //Saves positions for later
		punch(dads, 0, true, true); //Punches to the opponent
		punch(dads, 1, true, true);

		FlxG.camera.flash(0xFFFFFFFF, 0.5);

		//Move Player Position
		dad.x = defaultPoses[4];
		grugSecondary.x = defaultPoses[6];
		gf.x = dad.x + dad.width/2;
		boyfriend.x = grugSecondary.x + grugSecondary.width/2;

		if (curBeat == 256) {
			FlxTween.tween(gf, {x: xPoses[1]}, 1.5, {ease: FlxEase.backIn});
			FlxTween.tween(boyfriend, {x: xPoses[0]}, 1.5, {ease: FlxEase.backIn});

			FlxG.sound.play(Paths.sound('battlefx/powerhit'), 0.6);
			inst.volume = vocals.volume = 0.3;
			inst.pitch = vocals.pitch = 0.1;
			FlxTween.tween(inst, {volume: 1, pitch: 1}, 1.5, {ease: FlxEase.quartInOut, startDelay: 0.75});
			FlxTween.tween(vocals, {volume: 1, pitch: 1}, 1.5, {ease: FlxEase.quartInOut, startDelay: 0.75});
			new FlxTimer().start(0.5, function(timer:FlxTimer) {
				fight.alpha = 1;
				fight.animation.play('fight');
				FlxG.sound.play(Paths.sound('battlefx/fight'), 0.6);
				fight.animation.finishCallback = function(name){
					FlxTween.tween(fight, {alpha: 0}, 0.5, {ease: FlxEase.quartIn});
				};
			});
		} else {
			FlxTween.globalManager._tweens = [];
			engineSettings.botplay = true;
			engineSettings.ghostTapping = true;
			PlayState.scripts.executeFunc('onPsychEvent', ['Change Bars Size', 20, 0.1]);
			FlxG.sound.music.onComplete = null;
			conclusion(playerTeam, dads); //ENDING
		}

		FlxG.camera.zoom += curBeat == 256 ? 0.25 : 0.5;

		//Moves the Camera to the action
		var camera_follow = scripts.get('cameraFollow');
		FlxTween.tween(camera_follow, {x: camera_follow.x - 600}, 0.1, {ease: FlxEase.quartOut});

		scripts.call('shake', [20]);
	}
}*/


/* FUNCTION FOR PUNCHINES
- Target Team - Which Side To Inflict Hurt On
- ID - Individual ID of the target to hit (relies on dads and playerTeam vars. playerTeam means boyfriend, but will also include GF here.)
- Allow Blood? - Will Spawn Blood Alongside Punches
- Allow Bone Breaking? - - Will Spawn a Bone Alongside Punches
*/
/*
function punch(targetTeam, targetID, allowBlood, allowBone) {
	var fxPosition = targetTeam[targetID].getGraphicMidpoint();
	fxPosition.x += FlxG.random.int(-targetTeam[targetID].width/3,targetTeam[targetID].width/3);
	fxPosition.y += FlxG.random.int(-targetTeam[targetID].height/3,targetTeam[targetID].height/3);

	FlxG.sound.play(Paths.sound('battlefx/punch'+FlxG.random.int(1,3)), 0.4);

	var punch = new FlxSprite(fxPosition.x, fxPosition.y);
	punch.frames = Paths.getSparrowAtlas("battlevfx/punch", mod);
	punch.animation.addByPrefix("idle", "Punch"+Std.string(FlxG.random.int(1,5)), 24, false);
	punch.animation.play("idle");

	punch.x -= punch.width/2;
	punch.y -= punch.height/2;

	if (targetTeam == dads) punch.flipX = true;

	insert(PlayState.members.indexOf(targetTeam[targetID])+1,punch);
	punch.animation.finishCallback = function(name){
		punch.destroy();
	};

	if (allowBlood) {
		FlxG.sound.play(Paths.sound('battlefx/blood'+FlxG.random.int(1,4)), 0.4);

		var blood = new FlxSprite(fxPosition.x, fxPosition.y);
		blood.frames = Paths.getSparrowAtlas("battlevfx/blood", mod);
		blood.animation.addByPrefix("idle", "Blood"+Std.string(FlxG.random.int(1,4)), 24, false);
		blood.animation.play("idle");

		blood.scale.set(1.5, 1.5);
		blood.updateHitbox();

		blood.x -= blood.width/2;
		blood.y -= blood.height/2;

		if (targetTeam == dads) blood.flipX = true;
		
		insert(PlayState.members.indexOf(targetTeam[targetID])+1,blood);
		blood.animation.finishCallback = function(name){
			blood.destroy();
		};
	}

	if (allowBone) {
		FlxG.sound.play(Paths.sound('battlefx/bone'+FlxG.random.int(1,2)), 0.4);

		var bone = new FlxSprite(fxPosition.x, fxPosition.y).loadGraphic(Paths.image('battlevfx/bone'));
		bone.x -= bone.width/2;
		bone.y -= bone.height/2;
		insert(PlayState.members.indexOf(targetTeam[targetID])+1, bone);
		bones.push(bone);

		bone.velocity.y = FlxG.random.float(-750,-1250);
		bone.velocity.x = FlxG.random.float(100,1000) * (targetTeam == playerTeam ? 1 : -1);
		bone.angularVelocity = FlxG.random.float(1000,3000) * (targetTeam == playerTeam ? 1 : -1);
	}
}


function onOpenSubstate(substate) {
	if (health <= 0) {
		health = 0.001;

		for (i in FlxG.sound.list.members) {
			i.stop();
		}
		vocals.volume = 1;

		PlayState.scripts.executeFunc('reset', []);

		FlxTween.globalManager._tweens = [];
		FlxTimer.globalManager._timers = [];

		notes.clear();
		for (e in events) events.remove(e);

		justDIED = true;
		blockPlayerInput = true;
		currentSustains = [];
		generatedMusic = false;

		dad.x = gf.x + 270 - dad.width;
		grugSecondary.x = boyfriend.x + 300 - grugSecondary.width;

		var camera_follow = PlayState.scripts.getVariable('cameraFollow');
		FlxTween.tween(camera_follow, {x: boyfriend.x + boyfriend.width/2}, 0.1, {ease: FlxEase.quartOut});

		PlayState.scripts.executeFunc('onPsychEvent', ['Change Bars Size', 20, 0.5]);
		conclusion(dads, playerTeam);

		return false;
	}
}

function conclusion(winningTeam, losingTeam) {
	FlxG.sound.play(Paths.sound('battlefx/powerhit'), 0.6);

	winnerText.text = 'You r did it!';

	fight.alpha = 0;

	for (i in preloadedAssets) {
		i.y = 100000;
	}

	FlxG.sound.play(Paths.sound('battlefx/ko'), 1);
	var ko = new FlxSprite();
	ko.frames = Paths.getSparrowAtlas("HUD/battlegrounds/knockout", mod);
	ko.animation.addByPrefix("idle", 'knockout', 24, false);
	ko.animation.play("idle");
	ko.cameras = [camHUD];
	ko.screenCenter();
	add(ko);
	ko.animation.finishCallback = function(name){
		FlxTween.tween(ko, {alpha: 0}, 1, {ease: FlxEase.quartIn, onComplete: function(tween) {
			ko.destroy();
		}});
	};

	inst.volume = vocals.volume = 0.3;
	inst.pitch = vocals.pitch = 0.1;
	FlxTween.tween(inst, {volume: 1, pitch: 1}, 1.5, {ease: FlxEase.quartInOut, startDelay: 0.75});
	FlxTween.tween(vocals, {volume: 1, pitch: 1}, 1.5, {ease: FlxEase.quartInOut, startDelay: 0.75, onComplete: function(tween) {
		winnerDinnerChickenDinner.alpha = 1;

		PlayState.scripts.executeFunc('onPsychEvent', ['Change Bars Size', 0, 2]);
	}});

	FlxG.camera.bgColor = 0xFFFFFFFF;

	for (i in PlayState.members) {
		if (i != null && i.exists) {
			if (i.camera == FlxG.camera) {
				if (i.name != null && (i.name == 'vs' || i.name == 'bg')) {i.alpha = 0; FlxTween.tween(i, {alpha: 1}, 1.5, {ease: FlxEase.quartInOut, startDelay: 1.25});}
				else { 
					if (i.color != null) {i.color = 0xFF000000; FlxTween.color(i, 1.5, 0xFF000000, 0xFFFFFFFF, {ease: FlxEase.quartInOut, startDelay: 0.75});}
				}
			} else if (i.camera == camHUD) {
				if (i != null && i.exists && i.camera == camHUD && i.alpha != null && ![PlayState.scripts.getVariable('bar1'), PlayState.scripts.getVariable('bar2'), gate1, gate2, ko].contains(i)
					&& !comboObjects.contains(i)) {
					FlxTween.tween(i, {alpha: 0}, 0.75, {ease: FlxEase.quartIn});
				}
			}
		}
	}

	for (i in comboTweens) { if (i != null) i.finish(); }
	comboTweens = [];

	for (i in comboObjects) {
		if (i != null) {
			FlxTween.tween(i, {angle: FlxG.random.float(-20, 20), y: i.y + FlxG.random.float(20, 50), alpha: 0}, 0.2, {ease: FlxEase.circIn, onComplete: function(tween) {
				remove(i);
			}});
		}
	}
	comboPositions = [];
	for (i in comboTimers) { if (i != null) i.cancel(); }
	comboTimers = [];
	comboObjects = [];

	for (i in strumLineNotes.members) {
		FlxTween.tween(i, {alpha: 0}, 5, {ease: FlxEase.quartInOut, onComplete: function(tween) {
			if (winnerText.text == 'You r did it!') {
				i.destroy();
				playerStrums.clear();
				cpuStrums.clear();
				concluded = true;

				FlxG.sound.play(Paths.sound('battlefx/winnerappear'), 1);

				FlxTween.tween(winnerDinnerChickenDinner.scale, {x: 1, y: 1}, 0.75, {ease: FlxEase.quartInOut, onUpdate: function() {
					winnerDinnerChickenDinner.updateHitbox();
					winnerDinnerChickenDinner.screenCenter();
				}});

				FlxTween.tween(winnerText, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});

				if (justDIED) {
					FlxG.sound.playMusic(Paths.music(GameOverSubstate.gameOverMusic));
					winnerText.text = 'Game Over! Press CONFIRM to try again, or BACK to leave.';
				} else {
					FlxG.sound.playMusic(Paths.music('winnerWinner'));
					winnerText.text = 'You win this deathmatch! Press CONFIRM to proceed!';
				}

				FlxG.sound.music.volume = 1;
				FlxG.sound.music.onComplete = null;
			}
		}});
	}

	persistentUpdate = true;
	persistentDraw = true;
	engineSettings.resetButton = false;
	startingSong = true;
	startedCountdown = false;
	guiElemsPopped = false;
	startTimer = null;

	for (i in losingTeam) {
		i.mass = 10;
		i.velocity.y = -1000;
		i.velocity.x = (winningTeam == dads ? 150 : -150);
	}

	FlxTween.tween(iconP1, {alpha: 0}, 0.75, {ease: FlxEase.quartIn});
	FlxTween.tween(iconP2, {alpha: 0}, 0.75, {ease: FlxEase.quartIn, onComplete: function(tween) {
		for (i in [boyfriend, dad, gf, grugSecondary]) { //Makes all characters go into idle. Makes the winner screens look consistent.
			i.playAnim("idle");
			i.dance(true);
		}
	}});
}*/


var activateCreaits = false;
function creditUpdate(songBG, songTitle, creditTexts, creditIcons, elapsed) {
	if (activateCreaits) {
		for (catText in creditTexts) {
			for (i in catText) {
				i.updateMotion(elapsed); //for some reason you have to call it, it doesn't work without it on YCE
			}
		}
	}
}

function creditSetup(songBG, songTitle, creditTexts, creditIcons) {
	songBG.blend = 0;
	songTitle.angle = -20;

	songTitle.frames = Paths.getSparrowAtlas("credits/titles/Deathbattle");
	for (i in 1...11) {
		songTitle.animation.addByPrefix(i, i+'Title', 24, true);
	}

	songTitle.scale.set(1.01,1.01); songTitle.updateHitbox();

	var chance = FlxG.random.int(0,100);
	if (chance > 95) {
		songTitle.frames = Paths.getSparrowAtlas("HUD/battlegrounds/Horse Plinko");
		songTitle.animation.addByPrefix("Horse Plinko", 'Horse Plinko', 24, true);
		songTitle.animation.play("Horse Plinko");

		songTitle.scale.set(3,3); songTitle.updateHitbox(); songTitle.y += 40;
	} else if (chance > 70) {
		songTitle.animation.play(FlxG.random.int(2,10));
	} else {
		songTitle.animation.play("1");
	}

	songTitle.screenCenter(); songBG.screenCenter();
	songTitle.visible = false;
	songTitle.x = 0 - songTitle.width/2;

	songBG.x = 0;
	songBG.y += 180;
	songBG.scale.set(0,0); songBG.updateHitbox();

	remove(songBG); insert(members.indexOf(playerStrums)+1, songBG);
	remove(songTitle); insert(members.indexOf(playerStrums)+1, songTitle);

	for (catText in creditTexts) {
		for (i in catText) {
			i.visible = false;
			i.y -= FlxG.height;
			i.angle = [10,5,-20,0,10][creditTexts.indexOf(catText)] + FlxG.random.int(-2, 2);
			i.x = 0 - i.width/2 + FlxG.random(-15, 15);

			remove(i); insert(members.indexOf(playerStrums)+1, i);
		}
	}

	for (catIcons in creditIcons) {
		for (i in catIcons) {
			i.visible = false;
			i.y -= FlxG.height;
			i.angle = creditTexts[creditIcons.indexOf(catIcons)][catIcons.indexOf(i)].angle + FlxG.random.int(-20, 20);
			i.x = creditTexts[creditIcons.indexOf(catIcons)][catIcons.indexOf(i)].x - i.width/2 - 30 + FlxG.random(-15, 15);

			remove(i); insert(members.indexOf(playerStrums)+1, i);
		}
	}
}

function creditBehavior(songBG, songTitle, songTexts, songIcons, songTweens) {
	activateCreaits = true;

	songTweens.push(FlxTween.tween(songBG.scale, {x: 1, y: 1}, 2, {ease: FlxEase.backOut}));
	songBG.angularVelocity = 40;

	songTitle.visible = true;
	songTitle.velocity.set(FlxG.random.int(1900,2500), FlxG.random.int(-800,-700));
	songTitle.acceleration.set(20, 1500);
	songTitle.angularVelocity = FlxG.random.int(10,50);

	songTweens.push(FlxTween.tween(songTitle.velocity, {x: songTitle.velocity.x * 0.03, y: songTitle.velocity.y * 0.03}, 1, {ease: FlxEase.quartOut}));
	songTweens.push(FlxTween.tween(songTitle.acceleration, {x: songTitle.acceleration.x * 0.003, y: songTitle.acceleration.y * 0.003}, 1, {ease: FlxEase.quartOut}));
	songTweens.push(FlxTween.tween(songTitle, {angularVelocity: songTitle.angularVelocity * 0.03}, 1, {ease: FlxEase.quartOut}));

	songTweens.push(FlxTween.tween(songBG, {angularVelocity: songTitle.angularVelocity * 0.03}, 1, {ease: FlxEase.quartOut}));

	for (catText in songTexts) {
		for (i in catText) {
			i.visible = true;
			i.velocity.set([500,1000,1600,2200,3000][songTexts.indexOf(catText)] + FlxG.random.int(-100,100), [-200 + FlxG.random.int(-100,200),40 + FlxG.random.int(-200,100),-300 + FlxG.random.int(-100,400),-50 + FlxG.random.int(-100,100),-500 + FlxG.random.int(-100,600)][songTexts.indexOf(catText)] + 20 * (catText.indexOf(i)));
			i.acceleration.set(20, 1500);
			i.angularVelocity = FlxG.random.int(100,200);

			songTweens.push(FlxTween.tween(i.velocity, {x: i.velocity.x * 0.03, y: i.velocity.y * 0.03}, 1, {ease: FlxEase.quartOut}));
			songTweens.push(FlxTween.tween(i.acceleration, {x: i.acceleration.x * 0.003, y: i.acceleration.y * 0.003}, 1, {ease: FlxEase.quartOut}));
			songTweens.push(FlxTween.tween(i, {angularVelocity: i.angularVelocity * 0.03}, 1, {ease: FlxEase.quartOut}));
		}
	}

	for (catIcons in songIcons) {
		for (i in catIcons) {
			i.visible = true;
			i.velocity.set(songTexts[songIcons.indexOf(catIcons)][catIcons.indexOf(i)].velocity.x, songTexts[songIcons.indexOf(catIcons)][catIcons.indexOf(i)].velocity.y);
			i.acceleration.set(20, 1500);
			i.angularVelocity = FlxG.random.int(-3000,5000);
			
			songTweens.push(FlxTween.tween(i.velocity, {x: i.velocity.x * 0.03, y: i.velocity.y * 0.03}, 1, {ease: FlxEase.quartOut}));
			songTweens.push(FlxTween.tween(i.acceleration, {x: i.acceleration.x * 0.003, y: i.acceleration.y * 0.003}, 1, {ease: FlxEase.quartOut}));
			songTweens.push(FlxTween.tween(i, {angularVelocity: i.angularVelocity * 0.03}, 1, {ease: FlxEase.quartOut}));
		}
	}

    scripts.set('creditTweens', songTweens);

	return 4;
}

var creditTimer;

function creditEnding(songBG, songTitle, songTexts, songIcons, songTweens) {
	songTweens.push(FlxTween.tween(songTitle.velocity, {x: songTitle.velocity.x * 30, y: songTitle.velocity.y * 30}, 1, {ease: FlxEase.quartIn}));
	songTweens.push(FlxTween.tween(songTitle.acceleration, {x: songTitle.acceleration.x * 300, y: songTitle.acceleration.y * 300}, 1, {ease: FlxEase.quartIn}));
	songTweens.push(FlxTween.tween(songTitle, {angularVelocity: songTitle.angularVelocity * 30}, 1, {ease: FlxEase.quartIn}));

	songTweens.push(FlxTween.tween(songBG, {angularVelocity: songTitle.angularVelocity * 30}, 1, {ease: FlxEase.quartOut}));
	songTweens.push(FlxTween.tween(songBG.scale, {x: 0, y: 0}, 1, {ease: FlxEase.backIn}));

	for (catText in songTexts) {
		for (i in catText) {
			songTweens.push(FlxTween.tween(i.velocity, {x: i.velocity.x * 30, y: i.velocity.y * 30}, 1, {ease: FlxEase.quartIn}));
			songTweens.push(FlxTween.tween(i.acceleration, {x: i.acceleration.x * 300, y: i.acceleration.y * 300}, 1, {ease: FlxEase.quartIn}));
			songTweens.push(FlxTween.tween(i, {angularVelocity: i.angularVelocity * 30}, 1, {ease: FlxEase.quartIn}));
		}
	}

	for (catIcons in songIcons) {
		for (i in catIcons) {
			songTweens.push(FlxTween.tween(i.velocity, {x: i.velocity.x * 30, y: i.velocity.y * 30}, 1, {ease: FlxEase.quartIn}));
			songTweens.push(FlxTween.tween(i.acceleration, {x: i.acceleration.x * 300, y: i.acceleration.y * 300}, 1, {ease: FlxEase.quartIn}));
			songTweens.push(FlxTween.tween(i, {angularVelocity: i.angularVelocity * 30}, 1, {ease: FlxEase.quartIn}));
		}
	}

	creditTimer = new FlxTimer().start(2, function(timer) {
		activateCreaits = false;
		scripts.call('creditsDestroy');
	});

    scripts.set('creditTweens', songTweens);
}