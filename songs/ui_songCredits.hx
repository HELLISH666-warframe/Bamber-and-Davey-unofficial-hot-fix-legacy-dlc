import openfl.utils.Assets;
import flixel.text.FlxTextBorderStyle;
import Reflect;

if (SONG.meta.credits!=null&&FlxG.save.data.options.songCredits) {
    var isOnLeftSide = StringTools.contains(curSong, "call bamber");//WHY_DOES_CURSONG_MAKE_IT_LOWERCASE???
    var curSongLowerCase:String = PlayState.SONG.meta.name.toLowerCase();

    var songBG;
    var songTitle;
    var songTexts = [];
    var songIcons = [];

    var orderShit = ['Art', '3D Model', 'Music', 'Instrumental', 'Vocals', 'OG Music', 'Remix', 'Chart', 'Code', "My (Art)", "Asshole (Music)", "Burns (Chart)", "Bruh (Code)",
                    "drawingz", "myoosick", "note stuff", "funny hacking"]; //Fields for ordering JSONs

    var songTitleOffsets = SONG.meta.credits.offset;
    var songBackground = SONG.meta.credits.background;
    songBackground??='null';
    songTitleOffsets ??= [0,0];

    function postCreate() {
        songBG = new FlxSprite(0).loadGraphic(Paths.image('credits/backgrounds/'+songBackground.toLowerCase()));
        songTitle = new FlxSprite(0).loadGraphic(Paths.image('credits/titles/'+SONG.meta.credits.title));
        songBG.screenCenter();
        songBG.x += 2 * (isOnLeftSide ? -0.5 : 1); //Minor correction due to outlines

        songTitle.x = (isOnLeftSide ? 400 : -210) + songTitleOffsets[0];
        songTitle.y -= 10 - songTitleOffsets[1]; songBG.y += 10;
        songTitle.scale.set(0.6, 0.6);

        songTitle.angle = -70 * (isOnLeftSide ? -1 : 1);

        songBG.blend = 'hardlight';
        songBG.alpha = 0.7;
        songBG.flipX = isOnLeftSide;

        songTitle.camera = songBG.camera = camHUD;
        songTitle.antialiasing = songBG.antialiasing = FlxG.save.data.options.antialiasing;
        add(songBG); add(songTitle);

        songBG.y += FlxG.height;
        songTitle.y += FlxG.height;

        var orderShit = orderShit.filter(x -> Reflect.fields(PlayState.SONG.meta.credits).indexOf(x) != -1);

        for (i in orderShit) {
            songTexts[orderShit.indexOf(i)] = [];
            songIcons[orderShit.indexOf(i)] = [];

            var fieldText = new FlxText(0, 0, 0, i, 50);
            fieldText.setFormat(scoreTxt.font, 50, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
            fieldText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2, 1);

            fieldText.centerOffsets(true);
            fieldText.scale.x = fieldText.scale.y = 1 * 4 / (orderShit.length * (orderShit.length > 4 ? 0.75 : 1)); if (fieldText.width >= (200 * 4 / orderShit.length)) fieldText.scale.x = fieldText.scale.x * (200 * 4 / orderShit.length) / fieldText.width;
            fieldText.angle = -5 * (isOnLeftSide ? -1 : 1);
            fieldText.updateHitbox();

            fieldText.x = 175 - (25 * (orderShit.length/4)) + ((FlxG.width - 200) / orderShit.length * orderShit.indexOf(i));
            fieldText.y = FlxG.height / 2 - 20 - (isOnLeftSide ? (FlxG.width - fieldText.x) : fieldText.x) / 13;
            fieldText.camera = camHUD;
            fieldText.antialiasing = FlxG.save.data.options.antialiasing;
            add(fieldText); songTexts[orderShit.indexOf(i)].push(fieldText);

            fieldText.y += FlxG.height;

            var whereToLook = Reflect.field(SONG.meta.credits, i);
            if (['Chart', "Burns (Chart)", "note stuff"].contains(i)) whereToLook = Reflect.field(Reflect.field(SONG.meta.credits, i), PlayState.difficulty.toLowerCase());

            for (a in whereToLook) {
                var nameText = new FlxText(0, 0, 0, a, 24);
                nameText.setFormat(scoreTxt.font, 24, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
                nameText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2, 1);

                var curTitleText = songTexts[orderShit.indexOf(i)][0];

                nameText.centerOffsets(true);
                nameText.scale.x = nameText.scale.y = curTitleText.scale.y; if (nameText.width >= (150 * 4 / orderShit.length)) nameText.scale.x = nameText.scale.x * (150 * 4 / orderShit.length) / nameText.width;
                nameText.updateHitbox();
                nameText.x = curTitleText.x + curTitleText.width / 2 - nameText.width / 2 + (5 * whereToLook.indexOf(a)) + 5 + 30;
                nameText.y = curTitleText.y + curTitleText.height + ((nameText.height + 10) * whereToLook.indexOf(a));
                nameText.cameras = [camHUD];
                nameText.angle = -5 * (isOnLeftSide ? -1 : 1);
                nameText.antialiasing = FlxG.save.data.options.antialiasing;
                add(nameText); songTexts[orderShit.indexOf(i)].push(nameText);

                iconPath = Paths.image('credits/missing');
                for (cate in ['devs', 'contributors', 'specialthanks']) {
                    if (Assets.exists(Paths.image('credits/'+cate+'/'+a.toLowerCase()))) {
                        iconPath = Paths.image('credits/'+cate+'/'+a.toLowerCase());
                        break;
                    }
                }
                if (Assets.exists(Paths.image(iconPath + '-' + SONG.stage.toLowerCase()))) iconPath = Paths.image(iconPath + '-' + SONG.stage.toLowerCase());
                if (Assets.exists(Paths.image(iconPath + '-' + curSongLowerCase))) iconPath = Paths.image(iconPath + '-' + curSongLowerCase);

                var nameIcon = new FlxSprite().loadGraphic(iconPath);
                nameIcon.centerOffsets(true);
                nameIcon.setGraphicSize(nameText.height * 1.25); nameIcon.updateHitbox();
                nameIcon.x = nameText.x - 10 - nameIcon.width;
                nameIcon.y = nameText.y - (isOnLeftSide ? 15 : 0);
                nameIcon.camera = camHUD;
                nameIcon.angle = -5 * (isOnLeftSide ? -1 : 1);
                nameIcon.antialiasing = FlxG.save.data.options.antialiasing;
                add(nameIcon); songIcons[orderShit.indexOf(i)].push(nameIcon);
            }
        }

        scripts.call('creditSetup',[songBG, songTitle, songTexts, songIcons]);
    }

    var doBounceIcons = !['Memeing', 'Multiversus'].contains(PlayState.SONG.song);

    function update(elapsed) {
        if (doBounceIcons && songIcons.length > 0) {
            if (executeFuncMultiple("creditIconBehavior", [songIcons, songTexts, elapsed], [true, null]) != false) {
                for (fieldIcons in songIcons) {
                    for (icon in fieldIcons) {
                        if (icon != null) {
                            var decBeat = Conductor.getTimeInBeats(Conductor.songPosition,curBeat);
                            if (decBeat <= 0) decBeat = 1 + (decBeat % 1);
                                    
                            var iconlerp = FlxMath.lerp(songTexts[0][1].height * 1.25 * 1.3, songTexts[0][1].height * 1.25, FlxEase.cubeOut(decBeat % 1));
                            icon.setGraphicSize(iconlerp);
                        }
                    }
                }
            }
        }

        scripts.call('creditUpdate', [songBG, songTitle, songTexts, songIcons, elapsed]);

        for (i in creditTweens) i.active = !paused;
        if (creditTimer != null) creditTimer.active = !paused;
    }

    var delaySize = SONG.meta.credits.delay;
    delaySize ??= 0;

    function musicStart() if (delaySize == 0) spawnCredit();
    function beatHit(curBeat) if (curBeat == delaySize) spawnCredit();

    var creditTweens = [];
    var creditTime;
    var creditTimer;

    function spawnCredit() {
        if ((creditTime = executeFuncMultiple("creditBehavior", [songBG, songTitle, songTexts, songIcons, creditTweens], [true, null])) == true) {
            creditTweens.push(FlxTween.tween(songBG, {y: songBG.y - FlxG.height}, 1, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
                creditTweens.push(FlxTween.tween(songBG, {y: songBG.y - FlxG.height}, 1, {startDelay: 3, ease: FlxEase.quartIn, onComplete: function(twn:FlxTween) {
                    songBG.destroy();
                }}));
            }}));

            creditTweens.push(FlxTween.tween(songTitle, {y: songTitle.y - FlxG.height, angle: -5 * (isOnLeftSide ? -1 : 1)}, 1, {ease: FlxEase.backOut, onComplete: function(twn:FlxTween) {
                creditTweens.push(FlxTween.tween(songTitle, {y: songTitle.y - FlxG.height, angle: -70 * (isOnLeftSide ? -1 : 1)}, 1, {startDelay: 3, ease: FlxEase.backIn, onComplete: function(twn:FlxTween) {
                    songTitle.destroy();
                }}));
            }}));

            for (catText in songTexts) {
                for (field in catText) {
                    creditTweens.push(FlxTween.tween(field, {y: field.y - FlxG.height}, 1, {startDelay:0.03 * catText.indexOf(field), ease: FlxEase.backOut, onComplete: function(twn:FlxTween) {
                        creditTweens.push(FlxTween.tween(field, {y: field.y - FlxG.height}, 1, {startDelay: 3 + 0.03 * catText.indexOf(field), ease: FlxEase.backIn, onComplete: function(twn:FlxTween) {
                            field.destroy();
                        }}));
                    }}));
                }
            }

            for (catIcons in songIcons) {
                for (icon in catIcons) {
                    creditTweens.push(FlxTween.tween(icon, {y: icon.y - FlxG.height}, 1, {startDelay:0.03 * (catIcons.indexOf(icon)+1), ease: FlxEase.backOut, onComplete: function(twn:FlxTween) {
                        creditTweens.push(FlxTween.tween(icon, {y: icon.y - FlxG.height}, 1, {startDelay: 3 + 0.03 * (catIcons.indexOf(icon)+1), ease: FlxEase.backIn, onComplete: function(twn:FlxTween) {
                            if (songIcons.indexOf(catIcons) == songIcons.length - 1 && catIcons.indexOf(icon) == catIcons.length - 1) {
                                for (a in songIcons) {
                                    for (b in a) b.destroy();
                                }

                                songIcons = [];
                            }
                        }}));
                    }}));
                }
            }
        } else if (creditTime == false) {
        } else {
            creditTimer = new FlxTimer().start(creditTime, function() {
                scripts.call('creditEnding', [songBG, songTitle, songTexts, songIcons, creditTweens]);
            });
        }
    }

    function reset() {
        for (i in creditTweens) i.cancel();
        creditTweens = [];
        if (creditTimer != null) creditTimer.cancel();
        new FlxTimer().start(0.75, function() {
            creditsDestroy();

            postCreate();
        });
    }
}

function creditsDestroy() {
    if (songBG != null) songBG.destroy();
    if (songTitle != null) songTitle.destroy();
    for (catText in songTexts) { for (field in catText) { if (field != null) field.destroy(); }}
    for (catIcons in songIcons) { for (icon in catIcons) { if (icon != null) icon.destroy(); }}
    songTexts = []; songIcons = [];
}