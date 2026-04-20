//FREE_ME_FROM_THIS_HELL.
import funkin.editors.ui.UISliceSprite;
import funkin.options.Options;
import hxvlc.flixel.FlxVideoSprite;
import flixel.group.FlxTypedSpriteGroup;
import funkin.menus.ui.ClassicAlphabet;
import funkin.backend.utils.WindowUtils;
import flixel.FlxCamera;
import StringTools;

// OPTIONS file, in a different script to be cleaner ig
importScript("data/states/BND/BNDSettings-Options");
// bg stuff, not used later
var box = new UISliceSprite(0, 0, FlxG.width/2 * 1.6, FlxG.height/3 * 2.25, 'menus/options/optionsBox');
var box2 = new UISliceSprite(0, 0, FlxG.width/2 * 1.6, FlxG.height/3 * 2.25, 'menus/options/optionsBoxbutuhh');
// stuff you can't interact with

add(vid = new FlxVideoSprite());
vid.load(Assets.getPath(Paths.file('videos/menuSubState.webm')), ['input-repeat=65535']);
vid.play();

var explainText = new FlxText(0, FlxG.height/3 * 2.72, 0, "Placeholder Message").setFormat(Paths.font("vcr.ttf"), 37.5);
// menu shiz
var buttons = new FlxTypedGroup();
var daOptions = new FlxTypedGroup();
var daParams = new FlxTypedGroup();
var daCheckboxes = new FlxTypedGroup();
// curselects
var curMenu:Int = 0;
var curSelect:Int = 0;
var curParam:Int = 0;

var theFuckingIMPORTANTbar = new FlxSprite(240, 130).loadGraphic(Paths.image('menus/options/backGround'));

function create() {
    /*FlxG.resizeWindow(1280, 720);
    FlxG.resizeGame(1280, 1280);
    FlxG.scaleMode.width = FlxG.width = FlxG.initialWidth = 1280;
    FlxG.scaleMode.height = FlxG.height = FlxG.initialHeight = 720;*/
    // Initialisation
    WindowUtils.set_winTitle("Options Menu");
    CoolUtil.playMenuSong();
    for(i in [box,box2]){
        i.incorporeal = true;
        i.screenCenter();
        i.x -= Math.round(i.bWidth/2) - 16;
        i.y -= Math.round(i.bHeight/2) - 16;
    }
    FlxG.cameras.add(optionsCam = new FlxCamera(box.x, box.y, FlxG.width/2 * 1.6, FlxG.height/3 * 2.23), false);
    optionsCam.bgColor = FlxColor.TRANSPARENT;
    // the menu	
	for(num => a in ["Video", "Sound", "Visual", "Notes", "Controls", "Gameplay", "Misc"]){
	    var button = new FunkinSprite(130 + (num * 146), 25);
		button.loadSprite(Paths.image('menus/options/pages'));
		button.antialiasing = Options.antialiasing;
		button.animateAtlas.anim.addBySymbolIndices("Select", "Scenes/Options/Buttons/Button_" + a, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24], 24, false);
		//button.updateHitbox();
		buttons.add(button);
        pushToClickables(buttons.members[num]);
	}
    for(num => b in [
        buttons,
        box,
        new FlxSprite().loadGraphic(Paths.image('menus/options/menuGraphic')).screenCenter(),
        new FlxSprite(FlxG.width/3 * 2.6).loadGraphic(Paths.image('menus/options/scrollbarBG')).screenCenter(FlxAxes.Y),
        daOptions,
        daParams,
        daCheckboxes,
        new FlxSprite(0, FlxG.height/3 * 2.7).makeGraphic(FlxG.width, 60, FlxColor.BLACK),
        explainText.screenCenter(FlxAxes.X)
    ]){
        add(b);
	    if([2, 7].contains(num)) b.alpha = 0.5;
        //if(num != 0 || num != 2) b.antialiasing = Options.antialiasing;
    }
    theFuckingIMPORTANTbar.camera=optionsCam;
    insert(3,theFuckingIMPORTANTbar).scale.set(1.8,1.8);
	
	changeOption(0);
    FlxG.cameras.add(optionsCam2 = new FlxCamera(), false);
    optionsCam2.bgColor = FlxColor.TRANSPARENT;
    add(box2).camera=optionsCam2;
}

function update(){
	if (FlxG.mouse.wheel != 0)
		changeOption(FlxG.mouse.wheel);
	if(FlxG.keys.justPressed.Q || FlxG.keys.justPressed.E)
		changeOption(FlxG.keys.justPressed.Q ? -1 : 1);
    if (controls.UP_P||controls.DOWN_P) changeCurSelected(controls.UP_P?-1:1);
    optionsCam.scroll.y = CoolUtil.fpsLerp(optionsCam.scroll.y, curSelect * 60, 0.2);
    if ((controls.LEFT_P||controls.RIGHT_P)&&optionsFile[curMenu][curSelect][4]!='Bool'){
        switch(optionsFile[curMenu][curSelect][4]){
            case 'Float':changeSelected(controls.LEFT_P?-0.1:0.1);
            default:changeSelected(controls.LEFT_P?-1:1);
        }
    }
    if (controls.BACK){
        if(inPlayState){
            inPlayState=false;
            FlxG.switchState(new PlayState());
        }
        else FlxG.switchState(new ModState("BND/BNDMenu"));
    }
    if (controls.ACCEPT&&optionsFile[curMenu][curSelect][4]=='Bool') acceptThingieAndNotDie();
}

function acceptThingieAndNotDie(){
    if(StringTools.endsWith(daOptions.members[curSelect].text, 'Controls')){
    persistentUpdate=false;
    openSubState(new ModSubState('substates/Keybinds'));
    return;
    }
    Reflect.setField(FlxG.save.data.options, optionsFile[curMenu][curSelect][3], !Reflect.field(FlxG.save.data.options, optionsFile[curMenu][curSelect][3]));
    for(i in 0...daCheckboxes.length)
        if(daCheckboxes.members[i].ID==optionsFile[curMenu][curSelect][3])
        Reflect.field(FlxG.save.data.options, optionsFile[curMenu][curSelect][3])?
        daCheckboxes.members[i].animation.play('ya',true): daCheckboxes.members[i].animation.play('nah',true);

    if(StringTools.endsWith(daOptions.members[curSelect].text, 'Scores'))resetTheModSave('Score');
    if(StringTools.endsWith(daOptions.members[curSelect].text, 'Options'))resetTheModSave('Options');
    if(StringTools.endsWith(daOptions.members[curSelect].text, 'Misc'))resetTheModSave('Misc');
}

function changeOption(a:Int){
	curMenu = FlxMath.wrap(curMenu + a, 0, buttons.length - 1);
	FlxG.sound.play(Paths.sound('firstTime/firstButtonScroll'), getVolume(0.8, 'sfx'));
	for(z in buttons){
		FlxTween.cancelTweensOf(z);
		//z.animateAtlas.anim.finished = true;
		z.playAnim('Select', true, null, buttons.members.indexOf(z) != curMenu, z.animateAtlas.anim.curFrame);
		FlxTween.tween(z, {y: buttons.members.indexOf(z) == curMenu ? 7.5 : 25}, 0.25);
	}
	regenMenu();
    changeCurSelected(0);
}

var type:String;
function changeSelected(a:Float){
    if(optionsFile[curMenu][curSelect][4]=='Choice')Reflect.setField(FlxG.save.data.options, optionsFile[curMenu][curSelect][3],curParam[FlxMath.wrap(getTheFuckingValue()+a, 0, curParam.length-1)]);
    else
        Reflect.setField(FlxG.save.data.options, optionsFile[curMenu][curSelect][3],FlxMath.bound(Reflect.field(FlxG.save.data.options, optionsFile[curMenu][curSelect][3])+a, optionsFile[curMenu][curSelect][2][0], optionsFile[curMenu][curSelect][2][1]));
    regenMenu();
    daParams.members[curSelect].text = '<' + Reflect.field(FlxG.save.data.options, optionsFile[curMenu][curSelect][3]) + '>';
    laText = daParams.members[curSelect];
    //laText.members[0].color = laText.members[laText.text.length - 1].color = FlxColor.fromRGB(255, 100, 19);
}
function getTheFuckingValue(){
    var found = null;
    for (i in 0...curParam.length)
        if(Reflect.field(FlxG.save.data.options, optionsFile[curMenu][curSelect][3])==curParam[i]){
            found=i; break;
        }
    return found;
}

function changeCurSelected(a:Int){
    curSelect = FlxMath.wrap(curSelect + a, 0, optionsFile[curMenu].length-1);
    if(optionsFile[curMenu][curSelect][2].length>=0){curParam=optionsFile[curMenu][curSelect][2];
    }
    for(i in 0...daOptions.length){
    daOptions.members[i].alpha=0.6;
    daOptions.members[curSelect].alpha=1;
    }
    explainText.text=optionsFile[curMenu][curSelect][1];
    explainText.screenCenter(FlxAxes.X);
    theFuckingIMPORTANTbar.y=daOptions.members[curSelect].y+40;
}

function regenMenu(){
    savetheshit();
    for(z in [daParams, daOptions, daCheckboxes]) z.clear();
    for(num => a in optionsFile[curMenu]){

        //trace("Name: " + b[0] + " | Desc: " + b[1], " | Params: " + b[2]);
        daOptions.add(new ClassicAlphabet(25, (90 * num), a[0], true));
        daOptions.members[num].color = (StringTools.startsWith(daOptions.members[num].text, "Reset") ? FlxColor.fromRGB(225, 225/7.5, 225/7.5) : FlxColor.WHITE);
        if(a[2].length != 0){
            daParams.add(new ClassicAlphabet(0, (90 * num), '<'+Reflect.field(FlxG.save.data.options, a[3])+'>', true));
            laText = daParams.members[daParams.length - 1];

            laText.camera = optionsCam;
            laText.x = optionsCam.x + optionsCam.width - laText.width - 175;
            if(a[2].length != 1) // options with only one parameter don't have the arrows
                laText.members[0].color = laText.members[laText.text.length - 1].color = FlxColor.fromRGB(255, 100, 19);
        } else {
            var checkbox = new FlxSprite(0, 90 * num);
            checkbox.frames = Paths.getSparrowAtlas("menus/options/checkbox");
            checkbox.animation.addByPrefix("ya", "Checkbox", 24, false);
            checkbox.animation.addByIndices("nah", "Checkbox", [9,8,7,6,5,4,3,2,1,0], '',24, false);
            checkbox.ID=num;//Make this fucking ID thing match the cur savedata thing , AHHHHH-

            daCheckboxes.add(checkbox);
            daCheckboxes.members[daCheckboxes.length - 1].animation.play("ya", true, !Reflect.field(FlxG.save.data.options, a[3]), !Reflect.field(FlxG.save.data.options, a[3]) ? 24 : 0);
            daCheckboxes.members[daCheckboxes.length - 1].camera = optionsCam;
            daCheckboxes.members[daCheckboxes.length - 1].x = optionsCam.x + optionsCam.width - daCheckboxes.members[daCheckboxes.length - 1].width - 175;
        }
        daOptions.members[num].camera = optionsCam;
    }
    changeCurSelected(0);
}

function destroy()
    savetheshit();

function resetTheModSave(howBad:String) {
    switch(howBad){
        case 'Options':
        FlxG.save.data.options = {};
        FlxG.save.data.options.framerate ??= 120; // is 120 a good default idk
        FlxG.save.data.options.antialiasing ??= true;
        FlxG.save.data.options.pixelperfect ??= true;
        FlxG.save.data.options.resolution ??= [1280, 720];
        FlxG.save.data.options.fullscreen ??= false; 
        FlxG.save.data.options.borderless ??= false;
        FlxG.save.data.options.brightness ??= 50;
        FlxG.save.data.options.gamma ??= 50;

        FlxG.save.data.options.musicVolume ??= 20; 
        FlxG.save.data.options.sfxVolume ??= 20;
        FlxG.save.data.options.voiceVolume ??= 20;
        FlxG.save.data.options.streamedMusic ??= true;
        FlxG.save.data.options.streamedVocals ??= false;
        FlxG.save.data.options.missSounds ??= true;
        FlxG.save.data.options.copyrightBypass ??= false;
        FlxG.save.data.options.subtitles ??= true;

        FlxG.save.data.options.lowMemory ??= true;
        FlxG.save.data.options.vramSprites ??= true;
        FlxG.save.data.options.flashingLights ??= true;
        FlxG.save.data.options.shaders ??= 'all';
        FlxG.save.data.options.botplayUI ??= true;
        FlxG.save.data.options.bgBlur ??= 0;
        FlxG.save.data.options.bgDim ??= 0;
        FlxG.save.data.options.rapidCam ??= true;
        FlxG.save.data.options.breakTime ??= true;
        FlxG.save.data.options.timeBar ??= true;
        FlxG.save.data.options.comboPosPercent ??= 0;
        FlxG.save.data.options.cinematicBars ??= true;
        FlxG.save.data.options.healthIcons ??= true;
        FlxG.save.data.options.songCredits ??= true;
        FlxG.save.data.options.stampKeybinds ??= false;
        FlxG.save.data.options.autoPause ??= true;

        FlxG.save.data.options.noteskin ??= 'Arrows';
        FlxG.save.data.options.noteScale ??= 1;
        FlxG.save.data.options.noteColors ??= [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F];

        FlxG.save.data.options.coloredBar ??= true;
        FlxG.save.data.options.modcharts ??= 'Always';
        FlxG.save.data.options.dialogue ??= [true, true, false]; //Story Mode, Playlists, Freeplay
        FlxG.save.data.options.scrollSpeed ??= false;
        FlxG.save.data.options.scrollSpeed_Speed ??= 3;
        FlxG.save.data.options.pauseCountdown ??= true;
        FlxG.save.data.options.skipGameOver ??=false;
        FlxG.save.data.options.skipSongIntro ??= false;
        FlxG.save.data.options.scrollMode ??= 'Top';
        FlxG.save.data.options.middleScroll ??= false;
        FlxG.save.data.options.storyDialogue ??= true;
        FlxG.save.data.options.freeplayDialogue ??= true;
        FlxG.save.data.options.ghostTapping??=true;
        FlxG.save.data.options.songOffset??=0;

        savetheshit();
        case 'Misc':
        FlxG.save.data.gameStats ??= {};
        FlxG.save.data.gameStats.discoveries ??= [
            "Bamber's Farm"=> false,
            "Davey's Yard"=> false,
            "Romania Outskirts"=> false
        ];

        FlxG.save.data.gameStats.playtime ??= 0;
        FlxG.save.data.gameStats.clearedSongs ??= [];
        FlxG.save.data.gameStats.achievements ??= [];
        FlxG.save.data.gameStats.deaths ??= 0;

        FlxG.save.data.freeplayShit ??= {};
        FlxG.save.data.freeplayShit.favourites ??= [];
    }

    FlxG.save.flush();
    FlxG.resetState();
}