//VERY_wip.
import flixel.group.FlxTypedSpriteGroup;
import funkin.menus.ui.ClassicAlphabet;
import funkin.options.Options;
import menus.freeplay.ComposerIcon;

var curSong=FlxG.save.data.Bamber_SONGSONG;//Lazy_way_of_getting_the_selected_song_and_it's_meta.
var click_through:Bool = false;
var coolCam = new FlxCamera();//Cam_for_the_substate.
var portrait = new FlxSprite(700).loadGraphic(Paths.image('menus/freeplay/Portraits/PLACEHOLDER'));

var play_Text = new Alphabet(1055, 665, 'PLAY', true);
var hitbox:FlxSprite;//Scaling_the_text_up_fucks_up_the_hitbox_so_this.

var songName = new Alphabet(285.25, 70, 0, true);
var composer = new Alphabet(0, 130, 0, true);

var scroll_speed = new Alphabet(540, 505, "<"+ FlxG.save.data.options.scrollSpeed_Speed+">", true);

var difficultySprites:Map<String, FlxSprite> = [];
var arrows:Array<FunkinSprite> = [];

var optionSprites = new FlxTypedSpriteGroup();
var checkboxes = new FlxTypedSpriteGroup();
var optionText = new FlxTypedGroup();
var options:Array<String> = ['Cutscenes','Mod charts','Scroll Speed','Mode'];
var bulletoptionREAL:FlxSprite = new FlxSprite(-170,8);

static var curDifficulty:Int = 0;
var curOption:Int = 0;

static var curPlayingInst = Paths.inst(curSong.name, curSong.difficulties[curDifficulty]);
static var prevSong:String = "";

//Idea , have the option greyed out if mod-charts are set to always, same with scroll-speed.
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

	//Scroll_speed_modifier.
	add(scroll_speed).camera = coolCam;
	scroll_speed.scale.set(0.8,0.8);

	//Difficulty sprite setup.
	for (e in curSong.difficulties) {
		var le = e.toLowerCase();
		if (difficultySprites[le] == null) {
			var diffSprite = CoolUtil.loadAnimatedGraphic(new FlxSprite(90,458),Paths.image('menus/freeplay/modes/'+le));
			diffSprite.camera = coolCam;
			diffSprite.antialiasing = true;
			add(diffSprite).scale.set(0.3,0.3);

			difficultySprites[le] = diffSprite;
		}
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
        optionSprites.add(bulletOption);

        manY += bulletOption.height * (i % 4 == 0 ? 0.09 : 0.46 * (i % 4 == 2 ? 0.2 : 0.2));
        bulletOption.antialiasing = true;
		bulletOption.camera=coolCam;
    }
	add(optionSprites).y +=10;

	var namX = 444;
	for (i in 0...2) {
        checkbox_real = new FlxSprite(namX, manY);
        checkbox_real.frames = Paths.getFrames('menus/options/checkbox');

		checkbox_real.animation.addByIndices("false", "Checkbox0", [9,8,7,6,5,4,3,2,1,0], '',24, false);
		checkbox_real.animation.addByPrefix('true', "Checkbox0", 24,false);
		checkbox_real.animation.play([FlxG.save.data.options.freeplayDialogue,FlxG.save.data.options.modcharts][i]);
        checkboxes.add(checkbox_real);

        manY += checkbox_real.height * (i % 2 == 0 ? 1.3 : 3);
		namX += (i % 2 == 0 ? 70 : 500);
        checkbox_real.antialiasing = true;
		checkbox_real.camera=coolCam;
    }
	add(checkboxes).y= -245;

	add(optionText);
	for (i in 0...options.length) {
		var item = new Alphabet(120, (i * 80), options[i], 0,true);
		item.scale.set(0.9,0.9);
		item.y = ((i * optionSprites.members[4].y*0.8) * item.scale.y)+240;
		item.updateHitbox();
		item.camera=coolCam;
		optionText.add(item).width = item.width*item.scale.y;
	}

	changeDiff(0);
	changeOption(0);
	changeScroll(0);

	if(curSong.freeplayShit.hasCutscenes==null)optionText.members[0].alpha=0.3;
	if(!FlxG.save.data.options.scrollSpeed)optionText.members[2].alpha=scroll_speed.alpha=0.3;
	if(FlxG.save.data.options.modcharts=='Always'||curSong.freeplayShit.hasModchart==null)optionText.members[1].alpha=0.3;
	//Add something to make it skip grayed out ones dynamically.

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
	if ((controls.RIGHT_P||controls.LEFT_P) && curOption==3) changeDiff(controls.RIGHT_P ? 1 : -1);
	if ((controls.RIGHT_P||controls.LEFT_P) && curOption==2) changeScroll(controls.RIGHT_P ? 0.1 : -0.1);
	if (controls.BACK){
		FlxG.save.flush();
		FlxG.sound.music.fadeOut(9,0,1);
		CoolUtil.playMenuSFX(2, getVolume(0.9, 'sfx'));
		close();
	}
	if (controls.ACCEPT) toggle();
	if (FlxG.mouse.overlaps(hitbox) && FlxG.mouse.pressed)playsong();
	if (controls.UP_P||controls.DOWN_P) changeOption(controls.UP_P ? -1 : 1);
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
	if(curOption!=0)
	FlxTween.tween(bulletoptionREAL, {y: bulletoptionREAL.height/10 + optionSprites.members[(curOption/4) * 11].y}, 0.4,{ease: FlxEase.quartInOut});
	if(curOption==0) FlxTween.tween(bulletoptionREAL, {y: 8}, 0.5,{ease: FlxEase.quartInOut});
}
function toggle() {
	switch(curOption){
		case 0:FlxG.save.data.options.freeplayDialogue=!FlxG.save.data.options.freeplayDialogue;
		case 1:FlxG.save.data.options.modcharts=!FlxG.save.data.options.modcharts;
	}
	checkboxes.members[curOption].animation.play([FlxG.save.data.options.freeplayDialogue,FlxG.save.data.options.modcharts][curOption]);
}
function changeScroll(s) {
	if (FlxG.save.data.options.scrollSpeed)
		FlxG.save.data.options.scrollSpeed_Speed=FlxMath.bound(FlxG.save.data.options.scrollSpeed_Speed + s, 1, 10);
	scroll_speed.text ="<"+FlxG.save.data.options.scrollSpeed_Speed+">";
}
function playsong() {
	PlayState.loadSong(curSong.name, curSong.difficulties[curDifficulty].toLowerCase());

	acceptSound=curSong.freeplayShit.sound!=null?curSong.freeplayShit.sound:'default';
	if(curSong.freeplayShit.sound.length<=3) acceptSound=curSong.freeplayShit.sound[FlxG.random.int(0, curSong.freeplayShit.sound.length-1)];
	FlxG.sound.play(Paths.sound('menu/accept/'+acceptSound), getVolume(1, 'sfx')).persist=true;
	FlxG.switchState(new PlayState());
	curPlayingInst="fuck";
	click_through=false;
}
function destroy() FlxG.cameras.remove(coolCam);