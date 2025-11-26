//VERY_wip.
import flixel.text.FlxTextBorderStyle;
import flixel.group.FlxTypedSpriteGroup;
import funkin.options.Options;

var click_through:Bool = false;
var coolCam = new FlxCamera();

var curSong=FlxG.save.data.Bamber_SONGSONG;

var text = new Alphabet(285.25, 70, 0, true);
var composer = new Alphabet(FlxG.width/2.8, 130, 0, true);
var play_Text = new Alphabet(1000, 650, 0, true);
var scroll_speed = new Alphabet(540, 480, 0, true);

var hitbox:FlxSprite;
var portrait = new FlxSprite(530,0);

var composer_icon = new FlxSprite(530,0);

static var curDifficulty:Int = 0;
var difficultySprites:Map<String, FlxSprite> = [];
var arrows:Array<FunkinSprite> = [];
var curOption:Int = 0;
public static var scroll_Speed:Float = 1;

static var curPlayingInst = Paths.inst(curSong.name, curSong.difficulties[curDifficulty]);
static var prevSong:String = "";

var progressGroup = new FlxTypedSpriteGroup();
var bulletoptionREAL:FlxSprite = new FlxSprite(-170,-20);
var options:Array<String> = ['Cutscenes','Mod charts','Scroll Speed','Mode'];
//Idea , have the option greyed out if mod-charts are set to always, same with scroll-speed.
var checkbox_real:FlxSprite;
var checkboxes = new FlxTypedSpriteGroup();
static var toggles = [FlxG.save.data.options.freeplayDialogue,FlxG.save.data.options.modcharts];
function create() {
	new FlxTimer().start(0.2, ()->{click_through = true;});
	prevchar = curPlayingInst;
    FlxG.cameras.add(coolCam, false).bgColor = 0x00000000;

	var bg = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
	bg.screenCenter();
	bg.scrollFactor.set();
	bg.camera = coolCam;
	add(bg).alpha = 0.6;
	play_Text.text = "PLAY";
	play_Text.camera = coolCam;
	add(play_Text).scale.set(1.5,1.5);
	add(hitbox = new FlxSprite(950, 600).makeSolid(330, 100, 0xE0000020)).alpha = 0;
	hitbox.camera = coolCam;
	portrait.camera = coolCam;
	if (!Assets.exists(Paths.image('menus/freeplay/albums/vol' +curSong.album)))
		portrait.loadGraphic(Paths.image('menus/freeplay/albums/vol1'));
	else
		portrait.loadGraphic(Paths.image('menus/freeplay/albums/vol'+curSong.album));
	add(portrait).angle=-3;
	portrait.setGraphicSize(300,300);
	text.text = curSong.displayName;
	text.alignment="center";
	add(text).camera = coolCam;
	text.screenCenter(FlxAxes.X);
	trace(text.width);
	
	composer.text = "By "+ curSong.composer;
	composer.camera = coolCam;
	composer.scale.set(0.5,0.5);
	add(composer).x =text.width*1.5;
	if(text.width<=200)composer.x =text.width*2.6;
	if(text.width<=195)composer.x =text.width*2.5;
	if(text.width<=180)composer.x =text.width*2.76;
	if(text.width>480)composer.x =text.width*1.2;

	composer_icon.camera = coolCam;
	if (!Assets.exists(Paths.image('credits/devs/' +curSong.composer)))
		composer_icon.loadGraphic(Paths.image('credits/missing'));
	else
		composer_icon.loadGraphic(Paths.image('credits/devs/'+curSong.composer));
	add(composer_icon);
	composer_icon.x=composer.x+composer.width;

	scroll_speed.text ="<"+ scroll_Speed+">";
	scroll_speed.alignment="right";
	scroll_speed.scale.set(0.9,0.9);
	add(scroll_speed).camera = coolCam;

	for (e in curSong.difficulties) {
		var le = e.toLowerCase();
		if (difficultySprites[le] == null) {
			var diffSprite = CoolUtil.loadAnimatedGraphic(new FlxSprite(170,450),Paths.image('menus/freeplay/modes/'+le));
			diffSprite.camera = coolCam;
			diffSprite.antialiasing = true;
			diffSprite.scrollFactor.set();
			add(diffSprite).scale.set(0.3,0.3);

			difficultySprites[le] = diffSprite;
		}
	}
	for (a in 0...2) {
        arrows.push(new FunkinSprite(0, 525));
		arrows[a].scale.set(0.25, 0.25);
        arrows[a].frames = Paths.getSparrowAtlas("menus/freeplay/selectArrows");
        for(z in ["hit", "idle"])
			arrows[a].animation.addByPrefix(z, z + ["Left", "Right"][a], 10, false);
        arrows[a].animation.play("idle");
        add(arrows[a]).antialiasing = Options.antialiasing;
		arrows[a].y -= 128;
		arrows[a].x = (a + 1) * 170 + a * 120;
		arrows[a].cameras = [coolCam];
    }

	changeDiff(0);
	changeOption(0);

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
        progressGroup.add(bulletOption);

        manY += bulletOption.height * (i % 4 == 0 ? 0.09 : 0.46 * (i % 4 == 2 ? 0.2 : 0.2));
        bulletOption.antialiasing = true;
		bulletOption.camera=coolCam;
    }
	add(progressGroup).y = -20;

	var namX = 444;
	for (i in 0...2) {
        checkbox_real = new FlxSprite(namX, manY);
        checkbox_real.frames = Paths.getFrames('menus/options/checkbox');

		checkbox_real.animation.addByIndices("false", "Checkbox0", [9,8,7,6,5,4,3,2,1,0], '',24, false);
		checkbox_real.animation.addByPrefix('true', "Checkbox0", 24,false);
		checkbox_real.animation.play(toggles[i]);
        checkboxes.add(checkbox_real);

        manY += checkbox_real.height * (i % 2 == 0 ? 1.3 : 3);
		namX += (i % 2 == 0 ? 70 : 500);
        checkbox_real.antialiasing = true;
		checkbox_real.camera=coolCam;
    }
	add(checkboxes).y= -280;

	for (i in 0...options.length) {
		var item = new Alphabet(120, (i * 80), options[i], 0,true);
		item.scale.set(0.9,0.9);
		item.y = ((i * progressGroup.members[4].y*0.95) * item.scale.y)+210;
		item.updateHitbox();
		item.camera=coolCam;
		add(item).width = item.width*item.scale.y;
	}

	if(!FlxG.save.data.options.scrollSpeed)scroll_speed.alpha=0.3;

	bulletoptionREAL.frames = Paths.getFrames('menus/freeplay/bulletOption');
	bulletoptionREAL.animation.addByPrefix('idle', "appear", 10, false);
	bulletoptionREAL.camera=coolCam;
	bulletoptionREAL.scale.set(0.3,0.3);
	add(bulletoptionREAL).animation.play('idle');
	if(curPlayingInst!=prevSong)
	FlxG.sound.playMusic(curPlayingInst, 0);
	if(FlxG.sound.music!=null) FlxG.sound.music.fadeIn(9,0,1);
}
function update(elapsed:Float) {
	if ((controls.RIGHT_P||controls.LEFT_P) && curOption==3) changeDiff(controls.RIGHT_P ? 1 : -1);
	if ((controls.RIGHT_P||controls.LEFT_P) && curOption==2) changeScroll(controls.RIGHT_P ? 0.1 : -0.1);
	if (controls.BACK){
		Options.save();
		FlxG.sound.music.fadeOut(9,0,1);
		close();
	}
	if(click_through){
	    if (controls.ACCEPT) toggle();
		if (FlxG.mouse.overlaps(hitbox) && FlxG.mouse.pressed){
			trace("WOAH!");
			playsong();
			click_through=false;
		}
		if (controls.UP_P||controls.DOWN_P){
		changeOption(controls.UP_P ? -1 : 1);
		}
	}
}
var __oldDiffName = null;
function changeDiff(e) {
	arrows[FlxMath.bound(e, 0, 1)].animation.play("hit");
	curDifficulty += e;
	if (curDifficulty < 0) curDifficulty = FlxG.save.data.Bamber_song_diff.length-1;
	if (curDifficulty >= FlxG.save.data.Bamber_song_diff.length) curDifficulty = 0;
	if (__oldDiffName != (__oldDiffName = FlxG.save.data.Bamber_song_diff[curDifficulty].toLowerCase())) {
		for(e in difficultySprites) e.alpha = 0.001;

		var diffSprite = difficultySprites[__oldDiffName];

		if (diffSprite != null) {
			diffSprite.alpha = !diffSprite.alpha;
		}
	}
	curPlayingInst = Paths.inst(curSong.name, curSong.difficulties[curDifficulty]);
	if(curPlayingInst!=prevSong){
		FlxG.sound.playMusic(curPlayingInst, 1);
		prevSong=curPlayingInst;
	}
}
function changeOption(p) {
	curOption += p;
	if (curOption < 0) curOption = 3;
	if (curOption >= 4) curOption = 0;
	trace("Options: "+options[curOption]);
	if(click_through && curOption!=0){
	FlxTween.tween(bulletoptionREAL, {y: bulletoptionREAL.height/10 + progressGroup.members[(curOption/4) * 11].y}, 0.4,{ease: FlxEase.quartInOut});
	}
	if(click_through && curOption==0){
		FlxTween.tween(bulletoptionREAL, {y: -20}, 0.5,{ease: FlxEase.quartInOut});
	}
}
function toggle() {
	switch(curOption){
		case 0:FlxG.save.data.options.freeplayDialogue=!FlxG.save.data.options.freeplayDialogue;
		case 1:FlxG.save.data.options.modcharts=!FlxG.save.data.options.modcharts;
	}
	toggles = [FlxG.save.data.options.freeplayDialogue,FlxG.save.data.options.modcharts];
	trace("\nCutscenes are : "+toggles[0]+"\nMod-charts are :"+toggles[1]);
	checkboxes.members[curOption].animation.play(toggles[curOption]);
}
function changeScroll(s) {
	if(FlxG.save.data.options.scrollSpeed)
	scroll_Speed+= s;
	trace(scroll_Speed);
	if (scroll_Speed < 0) scroll_Speed = 0.1;
	scroll_speed.text ="<"+ scroll_Speed+">";
}
function playsong() {
	FlxG.save.data.options.scrollSpeed_Speed=scroll_Speed;
	//if (FlxG.save.data.options.scrollSpeed) scrollSpeed = FlxG.save.data.options.scrollSpeed_Speed;
	PlayState.loadSong(curSong.name, curSong.difficulties[curDifficulty].toLowerCase());
	FlxG.switchState(new PlayState());
}
function destroy() {
	//Destroy_the_other_stuff_later.
	FlxG.cameras.remove(coolCam);
}