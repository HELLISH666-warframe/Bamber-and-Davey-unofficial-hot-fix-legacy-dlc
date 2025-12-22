import flixel.util.FlxAxes;
import flixel.math.FlxRect;
import ColoredNoteShader;
var colorShader1 = new CustomShader("ColoredNoteShader");
var colorShader2 = new CustomShader("ColoredNoteShader");

var barTypes = [
    //STAGE-BASED
    'default' => [true, 'default', true, 'shader', [0,0], [-10,-10], [20,-20]],
    'bfdifield' => [false, null, false, 'none', [0,0], [-15,-10], [10,-20]],
    'cheater' => [false, null, false, 'none', [0,0], [0,0], [0,0]],
    'genstage' => [true, null, false, 'character', [0,0], [-25,-15], [0,0]],
    'battlegrounds' => [true, null, false, 'shader', [0,0], [0,0], [0,0]],
    'judgement hall' => [false, 'undertale', false, 'none', [0,0], [0,0], [0,0]],
    'undertalestage' => [false, 'undertale', false, 'none', [0,0], [0,0], [0,0]],
    'paintvoid' => [true, 'paintvoid/astray', true, 'shader', [0,0], [-10,-10], [20,-20]],
    'oldfarm' => [false, 'funkin', true, 'none', [5,-15], [20,15], [0,0]],
    'oldfarm_night' => [false, 'funkin', true, 'none', [5,-15], [20,15], [0,0]],
    'hot farm' => [false, 'funkin', true, 'none', [5,-15], [20,15], [0,0]],
    'exchangetown' => [false, 'exchangetown', true, 'none', [5,0], [-60,0], [0,0]],
    //SONG SPECIFIC
    'facsimile' => [true, 'paintvoid/facsimile', true, 'shader', [0,0], [-10,-10], [20,-20]],
    'placeholder' => [false, 'paintvoid/placeholder', true, 'none', [0,0], [0,0], [0,0]],
    'test footage' => [false, 'paintvoid/placeholder', true, 'none', [0,0], [0,0], [0,0]],
    'h2o' => [false, 'funkin', true, 'none', [5,-15], [20,15], [0,0]],
    'multiversus' => [true, 'multiversus', true, 'shader', [0,0], [-10,-10], [20,-20]],
];

var curBarType = (barTypes[SONG.meta.name.toLowerCase()] != null ? barTypes[SONG.meta.name.toLowerCase()] : (barTypes[SONG.stage.toLowerCase()] != null ? barTypes[SONG.stage.toLowerCase()] : barTypes['default']));

//Variable Initialization because indexing repeatedly can tax. Plus it's more readable that way.
var barType_isMask = curBarType[0];
var barType_directory = curBarType[1] != null ? curBarType[1] : SONG.stage.toLowerCase();
var barType_flipY = curBarType[2];
var barType_colorization = curBarType[3];
var barType_Y = curBarType[4];
var barType_YDown = curBarType[5];
var barType_StrumY = curBarType[6];

//Bar Masks
var maskHealthBar = new FlxSprite();
var maskTimeBar = new FlxSprite();

function postPostCreate() {
	healthBarBG.loadGraphic(Paths.image('HUD/'+barType_directory+'/HealthBar'));
	timerBG.loadGraphic(Paths.image('HUD/'+barType_directory+'/TimeBar'));
	
	healthBarBG.screenCenter(FlxAxes.X);
    timerBG.screenCenter(FlxAxes.X);
	
	if (barType_flipY) healthBarBG.flipY = timerBG.flipY = downscroll;

	if (barType_isMask)  { 
        healthBar.visible = timerBar.visible = false;

        maskHealthBar.loadGraphic(Paths.image('HUD/'+barType_directory+'/HealthBar'));
	    maskTimeBar.loadGraphic(Paths.image('HUD/'+barType_directory+'/TimeBar'));

        maskHealthBar.flipY = maskTimeBar.flipY = healthBarBG.flipY;
        maskHealthBar.camera = maskTimeBar.camera = camHUD;

        maskHealthBar.setPosition(healthBarBG.x, healthBarBG.y);
        maskTimeBar.setPosition(timerBG.x, timerBG.y);

        timerBG.color = 0xFF000000;

        var barColors = FlxG.save.data.options.coloredBar ? [0xFFFF0000, 0xFF00FF00] : [dad.iconColor, boyfriend.iconColor];
        //iiiiit's important. Sadly.
        if (barType_colorization == 'shader') barColors = [FlxColor.fromInt(dad.iconColor), FlxColor.fromInt(boyfriend.iconColor)];

        switch (barType_colorization) {
            case 'none':
            case 'character':
                maskTimeBar.color = maskHealthBar.color = barColors[0];
                healthBarBG.color = barColors[1];
            case 'shader':
                maskTimeBar.shader = maskHealthBar.shader = colorShader1;
                healthBarBG.shader = colorShader2;
                colorShader1.r = ((barColors[0] >> 16) & 0xFF);
                colorShader1.g = ((barColors[0] >> 8) & 0xFF);
                colorShader1.b = ((barColors[0]) & 0xFF);

                colorShader2.r = ((barColors[1] >> 16) & 0xFF);
                colorShader2.g = ((barColors[1] >> 8) & 0xFF);
                colorShader2.b = ((barColors[1]) & 0xFF);
        }

        insert(members.indexOf(iconP1),maskHealthBar);
        insert(members.indexOf(timerBG)+1,maskTimeBar);
    } else {

    }

    scripts.call('overrideBars',[maskHealthBar, maskTimeBar, curBarType]);

    maskHealthBar.y = healthBarBG.y += barType_Y[0] * (-1);
    scoreTxt.y += barType_Y[0] * (-1);
    maskTimeBar.y = timerBG.y += barType_Y[1] * (-1);

    healthBar.y = healthBarBG.y + healthBarBG.height/2 - healthBar.height/2;
    timerBar.y = timerBG.y + timerBG.height/2 - timerBar.height/2;

    for(i in [healthBarBG,maskTimeBar,maskHealthBar,iconP1,iconP2,scoreTxt,accuracyTxt,missesTxt])
    i.alpha = 0;

    if (!FlxG.save.data.options.timeBar && timerText != null) {
        timerText.destroy();
        timerText = null;
        timerNow.destroy();
        timerFinal.destroy();
        maskTimeBar.destroy();
    }

    //scoreWarning.y = Math.max(Math.min(healthBarBG.y - scoreWarning.height, guiSize.y - 5 - scoreWarning.height), 5);
}

function onStartCountdown() {
    if (FlxG.save.data.options.timeBar) strumLine.y += barType_StrumY[0];
    for(i in [healthBarBG,maskTimeBar,maskHealthBar,iconP1,iconP2,scoreTxt,accuracyTxt,missesTxt])
	FlxTween.tween(i, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});

    if (FlxG.save.data.options.timeBar) {
        maskTimeBar.alpha = 0;
        FlxTween.tween(maskTimeBar, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});
    }

    if (barType_isMask)  {
        timerBar.visible = healthBar.visible = false;
    }
}

if (barType_isMask) {
    function postUpdate(elapsed:Float) {
        if (FlxG.save.data.options.timeBar) {
            maskTimeBar.clipRect = new FlxRect(0, 0, maskTimeBar.frameWidth / (songLength != null ? songLength : 1) * Conductor.songPosition, maskTimeBar.frameHeight);
            timerBG.clipRect = new FlxRect(timerBG.frameWidth / (songLength != null ? songLength : 1) * Conductor.songPosition, 0, maskTimeBar.frameWidth, maskTimeBar.frameHeight);
        }
        maskHealthBar.clipRect = new FlxRect(0, 0, (maskHealthBar.frameWidth - (maskHealthBar.frameWidth / 2 * health)), maskHealthBar.frameHeight);
        healthBarBG.clipRect = new FlxRect(healthBarBG.frameWidth - (healthBarBG.frameWidth / 2 * health), 0, healthBarBG.frameWidth - (healthBarBG.frameWidth - (healthBarBG.frameWidth / 2 * health)), healthBarBG.frameHeight);
    }
}