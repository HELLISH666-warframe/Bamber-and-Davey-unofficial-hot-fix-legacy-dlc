//VERY_wip.
import flixel.group.FlxTypedSpriteGroup;
import funkin.menus.ui.ClassicAlphabet;
import menus.freeplay.ComposerIcon;
import menus.freeplay.FreeplayOptions;

var curSong=FlxG.save.data.Bamber_SONGSONG;//Lazy_way_of_getting_the_selected_song_and_it's_meta.
var click_through:Bool = false;
var coolCam = new FlxCamera();//Cam_for_the_substate.
var portrait = new FlxSprite(700);

var play_Text = new Alphabet(1055, 665, 'PLAY', true);
var hitbox:FlxSprite;//Scaling_the_text_up_fucks_up_the_hitbox_so_this.

var songName = new Alphabet(285.25, 70, 0, true);
var composer = new Alphabet(0, 130, 0, true);

var difficultySprites:Map<String, FlxSprite> = [];
var arrows:Array<FunkinSprite> = [];

var selectSprites = new FlxTypedSpriteGroup();
var options:Array<String> = [['Cutscenes','Mod charts','Scroll Speed','Mode'],
	['checkbox','string','string'],['freeplayDialogue','modcharts','scrollSpeed_Speed']];
var bulletoptionREAL = new FlxSprite(-170,8);

static var curDifficulty:Int = 0;
var curOption:Int = 0;

static var curPlayingInst = Paths.inst(curSong.name, curSong.difficulties[curDifficulty]);
static var prevSong:String = "";

var optionSprites = new FlxTypedGroup();
function create() {
	new FlxTimer().start(0.2, ()->{click_through = true;});//Anti_fuckup_thing.
	prevchar = curPlayingInst;
    FlxG.cameras.add(coolCam, false).bgColor = 0x00000000;

	add(bg = new FlxSprite(-50,-50).makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK)).alpha = 0.6;
	bg.camera = coolCam;

	//Portrait_shit.
	if (Assets.exists(Paths.image('menus/freeplay/Portraits/' +curSong.freeplayShit.portrait))){
	portrait.camera = coolCam;
	portrait.loadGraphic(Paths.image('menus/freeplay/Portraits/'+curSong.freeplayShit.portrait));
	add(portrait).setGraphicSize(570,570);
	portrait.setPosition(700,60/portrait.height+30);
	FlxTween.tween(portrait, {x: 500}, 1, {ease: FlxEase.elasticOut});
	}
	
	play_Text.camera = coolCam;
	add(play_Text).scale.set(1.1,1.1);
	add(hitbox = new FlxSprite(1050, 635).makeSolid(230, 85, 0xE0000020)).alpha = 0;
	hitbox.camera = coolCam;

	//Songname_and_composer_icon_shit.
	songName.text = curSong.displayName;
	add(songName).camera = coolCam;
	songName.screenCenter(FlxAxes.X);
	
	if(curSong.freeplayShit.composer!=null){
	composer.text = "By "+ curSong.freeplayShit.composer;
	composer.camera = coolCam;
	composer.scale.set(0.5,0.5);
	composer.screenCenter(FlxAxes.X);
	add(composer).x +=songName.width-songName.width/1.5;
	var testtt2=new ComposerIcon(songName.x+songName.width+10,200,curSong.freeplayShit.composer);
	add(testtt2.lines).camera=coolCam;
    }

	add(optionSprites).camera=coolCam;

	for (i in 0...options[0].length) {
		add(optionSpawn(i,options[0][i],options[1][i],options[2][i]));
		optionSprites.members[i].change();
	}

	//Difficulty sprite setup.
	for (e in curSong.difficulties) {
		var le = e.toLowerCase();
		diffImage= Assets.exists(Paths.image("menus/freeplay/modes/" + le))? le:'placeholder';
		diffSprite = CoolUtil.loadAnimatedGraphic(new FlxSprite(90,458),Paths.image('menus/freeplay/modes/'+diffImage));
		diffSprite.camera = coolCam;
		diffSprite.antialiasing = true;
		add(diffSprite).scale.set(0.3,0.3);

		difficultySprites[le] = diffSprite;
	}
	for (a in 0...2) {
        arrows.push(new FunkinSprite(0, 415));
		arrows[a].scale.set(0.25, 0.25);
        arrows[a].frames = Paths.getSparrowAtlas("menus/freeplay/selectArrows");
        for(z in ["hit", "idle"])
			arrows[a].animation.addByPrefix(z, z + ["Left", "Right"][a], 10, false);
        arrows[a].animation.play("idle");
        add(arrows[a]).antialiasing = Options.antialiasing;
		arrows[a].x = (a + 1) * 100 + a * 180;
		arrows[a].cameras = [coolCam];
    }

	//Technical_stuff_that_makes_me_want_to_die.
	var manY = 0;
    for (i in 0...10) {
        bulletOption = new FlxSprite(-170, manY);
        bulletOption.frames = Paths.getFrames('menus/freeplay/bulletOption');

        if (i % 3 == 0) {
            bulletOption.animation.addByPrefix('idle', "idle", 24, false);
            bulletOption.animation.play('idle');
        } else {
            bulletOption.animation.addByPrefix('dot', "dot", 24);
            bulletOption.animation.play('dot');
        }
		bulletOption.scale.set(0.3,0.3);
        selectSprites.add(bulletOption);

        manY += bulletOption.height * (i % 4 == 0 ? 0.09 : 0.46 * (i % 4 == 2 ? 0.2 : 0.2));
        bulletOption.antialiasing = true;
		bulletOption.camera=coolCam;
    }
	add(selectSprites).y +=10;

	changeDiff(0);
	changeOption(0);
	changeScroll(0);

	bulletoptionREAL.frames = Paths.getFrames('menus/freeplay/bulletOption');
	bulletoptionREAL.animation.addByPrefix('idle', "appear", 10, false);
	bulletoptionREAL.camera=coolCam;
	bulletoptionREAL.scale.set(0.3,0.3);
	add(bulletoptionREAL).animation.play('idle');
	if(curPlayingInst!=prevSong) FlxG.sound.playMusic(curPlayingInst, 0);
	if(FlxG.sound.music!=null) FlxG.sound.music.fadeIn(9,0,1);
}
function update(elapsed:Float) {
	if(!click_through)return;
	if (controls.ACCEPT && curOption==0) toggle();
	if(controls.RIGHT_P||controls.LEFT_P){
		switch(curOption){
			case 2:changeScroll(controls.RIGHT_P ? 0.1 : -0.1);
			case 3:changeDiff(controls.RIGHT_P ? 1 : -1);
		}
	}
	if (controls.BACK){
		FlxG.save.flush();
		FlxG.sound.music.fadeOut(9,0,1);
		CoolUtil.playMenuSFX(2, getVolume(0.9, 'sfx'));
		close();
	}
	if (FlxG.mouse.overlaps(hitbox) && FlxG.mouse.pressed)playsong();
	if (controls.UP_P||controls.DOWN_P) changeOption(controls.UP_P ? -1 : 1);
	bulletoptionREAL.y=lerp(bulletoptionREAL.y,switch(curOption){
		case 0:8;case 1:151;case 2:288;case 3:426;},0.25);
}
var __oldDiffName = null;
function changeDiff(e) {
	arrows[FlxMath.bound(e, 0, 1)].animation.play("hit");
	curDifficulty = FlxMath.wrap(curDifficulty + e, 0, curSong.difficulties.length - 1);
	if (__oldDiffName != (__oldDiffName = curSong.difficulties[curDifficulty].toLowerCase())) {
		for(e in difficultySprites) e.alpha = 0.001;

		var diffSprite = difficultySprites[__oldDiffName];

		if (diffSprite != null)  diffSprite.alpha = !diffSprite.alpha;
	}
	curPlayingInst = Paths.inst(curSong.name, curSong.difficulties[curDifficulty]);
	if(curPlayingInst!=prevSong){
		FlxG.sound.playMusic(curPlayingInst, 1);
		prevSong=curPlayingInst;
	}
}
function changeOption(p) {
	if(p!=0)CoolUtil.playMenuSFX('scroll', getVolume(1, 'sfx'));
	curOption = FlxMath.wrap(curOption + p, 0,  3);
}
function toggle() {
	FlxG.save.data.options.dialogue[2]=!FlxG.save.data.options.dialogue[2];
	optionSprites.members[curOption].checkBox.animation.play(FlxG.save.data.options.dialogue[2]);
	for(i in 0...optionSprites.members.length)
		optionSprites.members[i].change();
}
function changeScroll(s) {
	if (FlxG.save.data.options.scrollSpeed)
		FlxG.save.data.options.scrollSpeed_Speed=FlxMath.bound(FlxG.save.data.options.scrollSpeed_Speed + s, 1, 10);
	//scroll_speed.text ="<"+FlxG.save.data.options.scrollSpeed_Speed+">";
}
function playsong() {
	PlayState.loadSong(curSong.name, curSong.difficulties[curDifficulty].toLowerCase());

	acceptSound=curSong.freeplayShit.sound!=null?curSong.freeplayShit.sound:'default';
	if(acceptSound.length<=3)
		 acceptSound=curSong.freeplayShit.sound[FlxG.random.int(0, curSong.freeplayShit.sound.length-1)];
	FlxG.sound.play(Paths.sound('menu/accept/'+acceptSound), getVolume(1, 'sfx')).persist=true;
	FlxG.switchState(new PlayState());
	curPlayingInst="fuck";
	click_through=false;
}
function destroy() {FlxG.cameras.remove(coolCam);
	FlxG.save.flush();
}

function optionSpawn(index,name,type,?save=null) {
	//OptionText(Alphabet).
	var optionItem = new FreeplayOptions();
	if(save!=null)optionItem.option=save;
	optionItem.text = new Alphabet(100,0,name,true);
	optionItem.text.scale.set(0.9,0.9);
	if(name=='Cutscenes'&&curSong.freeplayShit.hasCutscenes==null)optionItem.text.alpha=0.3;
	if(name=='Mod charts'&&curSong.freeplayShit.hasModchart==null)optionItem.text.alpha=0.3;
	if(name=='Scroll Speed'&&!FlxG.save.data.options.scrollSpeed)optionItem.text.alpha=0.3;
	//optionItem.text.targetY=optionItem.text.ID=index;
	optionItem.text.y=250+(index * 135);
	switch(type){
		case 'checkbox':
		optionItem.checkBox = new FlxSprite();
        optionItem.checkBox.frames = Paths.getFrames('menus/options/checkbox');
		optionItem.checkBox.animation.addByIndices("false", "Checkbox0", [9,8,7,6,5,4,3,2,1,0], '',24, false);
		optionItem.checkBox.animation.addByPrefix('true', "Checkbox0", 24,false);
		optionItem.checkBox.updateHitbox();
		optionItem.checkBox.animation.play(FlxG.save.data.options.dialogue[2]);
		case 'string':optionItem.text2 = new ClassicAlphabet(0,0,"123",true);
		optionItem.text2.scale.set(0.7,0.7);
		if(!FlxG.save.data.options.scrollSpeed)optionItem.text2.alpha=0.3;
	}
	
	optionSprites.add(optionItem);
	return optionItem;
}