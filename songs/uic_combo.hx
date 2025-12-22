//Custom Combo graphics
var comboPath = 'HUD/' + (['bfdifield', 'genstage', 'paintvoid', 'exchangetown'].contains(SONG.stage.toLowerCase()) ? SONG.stage.toLowerCase() : 'default') + '/';

var hasSubfolders = ['paintvoid'];
if (hasSubfolders.contains(SONG.stage.toLowerCase())) comboPath = 'HUD/' + PlayState.SONG.stage.toLowerCase() + '/' + SONG.meta.name.toLowerCase() + '/';

var countdownOverrideDir = [['judgement_hall', 'undertalestage'] => 'undertale'];

for (song in countdownOverrideDir.keys()) {
	if (song.contains(SONG.stage.toLowerCase()) || song.contains(SONG.meta.name.toLowerCase())) {
		comboPath = 'HUD/'+countdownOverrideDir[song]+'/';
		break; //break out of the loop
	}
}

var hasPlurality = (Assets.exists(Paths.image(comboPath + 'combo-plural')));

//Ratings for Custom Graphics
ratings = [
    {
        name: "Sick",
        image: comboPath + "Sick",
        accuracy: 1,
        health: 0.035,
        maxDiff: 125 * 0.30,
        score: 350,
        color: "#24DEFF",
        fcRating: "MFC",
        showSplashes: true
    },
    {
        name: "Good",
        image: comboPath + "Good",
        accuracy: 2 / 3,
        health: 0.025,
        maxDiff: 125 * 0.55,
        score: 200,
        color: "#3FD200",
        fcRating: "GFC"
    },
    {
        name: "Bad",
        image: comboPath + "Bad",
        accuracy: 1 / 3,
        health: 0.010,
        maxDiff: 125 * 0.75,
        score: 50,
        color: "#D70000"
    },
    {
        name: "Shit",
        image: comboPath + "Shit",
        accuracy: 1 / 6,
        health: 0.0,
        maxDiff: 99999,
        score: -150,
        color: "#804913"
    }
];

var savedCombo = 0;
var savedMisses = 0;

var enabledMissJudgement = !['genstage', 'cheater', 'paintvoid', 'default_stage', 'battlegrounds', 'oldfarm', 'oldfarm_night', 'hot_farm'].contains(SONG.stage.toLowerCase());

var comboScale = [['judgement_hall', 'undertalestage'] => [0.85, 0.85, 0.85], ['exchangetown'] => [1, 1, 1]];
var comboScaleMult = [0.85, 1, 1.5];
for (song in comboScale.keys()) {
	if (song.contains(SONG.stage.toLowerCase()) || song.contains(SONG.meta.name.toLowerCase())) {
		comboScaleMult = comboScale[song];
		break; //break out of the loop
	}
}

//Miss Judgement + Combo Broken
function updatePost(elapsed) {
    if (savedMisses != misses && health > 0) {
        var missCount = misses - savedMisses;
        savedMisses = misses;

        if (missCount >= 1) {
            for (i in 0...missCount) {
                scripts.call('miss', []);
                if (enabledMissJudgement) onShowCombo((savedCombo > 0 ? -1 : 0), new FlxText());
            }
        }
    }

    if (brokenTween != null) brokenTween.active = !paused;
    for (tweenSet in optimizedTweenSet) { for (i in tweenSet) { i.active = !paused;}}
}

var brokenTween;
var broken:FlxSprite;

var comboOffsets = [
    'bfdifield' => 0,
    'judgement_hall' => -3,
    'undertalestage' => -3
];
var comboXOffset = comboOffsets[SONG.stage.toLowerCase()] != null ? comboOffsets[SONG.stage.toLowerCase()] : -7;

function postCreate() {
    Flags.USE_LEGACY_TIMING=false;
    ratingManager.ratingData=[];
    for(i in 0...ratingManager.ratingData.length)
	trace(ratingManager.ratingData[i].name);
	ratingManager.addRating({name: "Perfect", window: 30, accuracy: 1, score: 350, splash: true});
	ratingManager.addRating({name: "Great", window: 70, accuracy: 2/3, score: 200, splash: false});
	ratingManager.addRating({name: "Nice", window: 120, accuracy: 1/3, score: 50, splash: false});
	ratingManager.addRating({name: "Meh", window: 170, accuracy: 1/6, score: -150, splash: false});
	for(i in 0...ratingManager.ratingData.length)
	trace(ratingManager.ratingData[i].name);
	//for (rating in [for (i in ratingManager.ratingData) i.name]) hits.set(rating, 0); // Ensure all keys exist as to prevent null errors.
}
function onPlayerHit(e) {
    trace(e.rating);
    if(e.note.isSustainNote)return;
   onShowCombo(combo,e.rating);
   trace(hits[e.rating]);
}
function onPlayerMiss(e) {
    var missCount = misses - savedMisses;
    savedMisses = misses;
    if (missCount >= 1) {
        for (i in 0...missCount) {
            scripts.call('miss', []);
            onShowCombo((savedCombo > 0 ? -1 : 0), new FlxText());
        }
    }
}
var thing = new FlxSprite();
function onShowCombo(combo:Int, coolText:String) {
	var tweens:Array<VarTween> = [];

    var strumsX:Float = 0;
    var strumsY:Float = 0;
    var strumScale:Float = 0;
    var strumCount = 2;

    for (e in strumLines){
        if (e != null) {
            strumsX += strumLines.members[1].members[0].x + (strumLines.members[1].members[0].width / 2);
            strumsY += strumLines.members[1].members[0].y + (strumLines.members[1].members[0].height / 2);
            strumScale += strumLines.members[1].members[0].scale.x/7*4;
        }
    }
    strumsX /= strumCount;
    strumsY /= strumCount;
    strumScale /= strumCount;

    thing.x = Math.max(Math.min(strumsX, FlxG.width - 350), 20);
    thing.y = Math.max(Math.min(strumsY - FlxG.height/2* -1, FlxG.height - 80), 20);

    if (combo > 0) {
        savedCombo++;
        if (brokenTween != null) { 
            brokenTween.cancel();
            broken.destroy();
        }

        var rating:FlxSprite = new FlxSprite().loadGraphic(Paths.image(comboPath+coolText));
        rating.centerOrigin();
        rating.scale.x = rating.scale.y = 1 * strumScale;
        rating.updateHitbox();
        
        rating.x = thing.x - rating.width/2;
        rating.y = thing.y - rating.height/2;
        rating.cameras = [camHUD];
        rating.antialiasing = coolText.antialiasing;
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

        var seperatedScore:Array<Int> = [];
        var stringCombo = Std.string(combo);

        for(i in 0...stringCombo.length) {
            seperatedScore.push(Std.parseInt(stringCombo.charAt(i)));
        }

        while(seperatedScore.length < combo.length) seperatedScore.insert(0, 0);

        var scoreWidth;
        var scoreHeight;
        var numScorePos = [];

        var comboSpr = new FlxSprite().loadGraphic(Paths.image(comboPath + ((hasPlurality && combo > 1) ? 'combo-plural' : 'combo')));
        comboSpr.centerOrigin();
        comboSpr.scale.set(strumScale * comboScaleMult[1], strumScale * comboScaleMult[1]);
        comboSpr.antialiasing = FlxG.save.data.options.antialiasing;
        comboSpr.updateHitbox();
        
        for (i in 0...seperatedScore.length + 1) {
            if (i < seperatedScore.length) {
                var numScore = new FlxSprite().loadGraphic(Paths.image(comboPath + 'num'+seperatedScore[i]));
                numScore.centerOrigin();
                numScore.scale.set(strumScale * comboScaleMult[0], strumScale * comboScaleMult[0]);
                numScore.antialiasing = FlxG.save.data.options.antialiasing;
                numScore.updateHitbox();
                scoreWidth = numScore.width;
                scoreHeight = numScore.height;

                numScore.x = thing.x - numScore.width/2 + (numScore.width * i + 3) - ((numScore.width + 3) * (seperatedScore.length - 1) + comboSpr.width + 3)/2 + comboXOffset;
                numScore.y = thing.y + rating.height/2 + 5;
                numScorePos = [numScore.x, numScore.y];

                numScore.cameras = [camHUD];

                add(numScore);

                numScore.alpha = 0;
                numScore.y += 20;
                tweens.push(FlxTween.tween(numScore, {y: numScore.y - 15, alpha: 1}, 0.15, {
                    onComplete: function(tween:FlxTween)
                    {
                        tweens.push(FlxTween.tween(numScore, {alpha: 0}, 0.2, {
                            onComplete: function(tween:FlxTween)
                            {
                                numScore.destroy();
                            },
                            startDelay: 0.5
                        }));
                    },
                    ease: FlxEase.quartOut
                }));
            } else {
                comboSpr.x = numScorePos[0] + (scoreWidth + 3);
                comboSpr.y = numScorePos[1] + scoreHeight - comboSpr.height;
                comboSpr.cameras = [camHUD];
                add(comboSpr);

                comboSpr.alpha = 0;
                comboSpr.y += 20;
                tweens.push(FlxTween.tween(comboSpr, {y: comboSpr.y - 15, alpha: 1}, 0.15, {
                    onComplete: function(tween:FlxTween)
                    {
                        tweens.push(FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
                            onComplete: function(tween:FlxTween)
                            {
                                comboSpr.destroy();
                            },
                            startDelay: 0.5
                        }));
                    },
                    ease: FlxEase.quartOut
                }));
            }
        }
    } else {
        savedCombo = 0;

        var miss:FlxSprite = new FlxSprite().loadGraphic(Paths.image(comboPath + 'miss'));
        miss.centerOrigin();
        miss.scale.x = miss.scale.y = strumScale;
        miss.updateHitbox();
        
        miss.x = thing.x - miss.width/2;
        miss.y = thing.y - miss.height/2;
        miss.cameras = [camHUD];
        miss.antialiasing = FlxG.save.data.options.antialiasing;
        add(miss);
        
        miss.alpha = 0;
        miss.y -= 20;
        tweens.push(FlxTween.tween(miss, {y: miss.y + 30, alpha: 1}, 0.15, {
            onComplete: function(tween:FlxTween)
            {
                tweens.push(FlxTween.tween(miss, {alpha: 0}, 0.2, {
                    onComplete: function(tween:FlxTween)
                    {
                        miss.destroy();
                    },
                    startDelay: 0.5
                }));
            },
            ease: FlxEase.quartOut
        }));

        if (combo == -1) {
            broken = new FlxSprite().loadGraphic(Paths.image(comboPath + 'broken'));
            broken.scale.set(comboScaleMult[2] * strumScale, comboScaleMult[2] * strumScale);
            broken.updateHitbox();

            broken.x = thing.x - broken.width/2;
            broken.y = thing.y + miss.height/2 + 5;

            broken.antialiasing = FlxG.save.data.options.antialiasing;
            broken.cameras = [camHUD];
            add(broken);

            broken.alpha = 0;
            broken.y += 20;
            brokenTween = FlxTween.tween(broken, {y: broken.y - 15, alpha: 1}, 0.15, {
                onComplete: function(tween:FlxTween)
                {
                    FlxTween.tween(broken, {alpha: 0}, 0.2, {
                        onComplete: function(tween:FlxTween)
                        {
                            broken.destroy();
                        },
                        startDelay: 0.5
                    });
                },
                ease: FlxEase.quartOut
            });
        }
    }

	//if (engineSettings.maxRatingsAllowed > -1) optimizedTweenSet.push(tweens);

    return false;
}