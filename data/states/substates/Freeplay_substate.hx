//VERY_wip.
import flixel.group.FlxTypedSpriteGroup;
import funkin.options.Options;

var click_through:Bool = false;
var coolCam = new FlxCamera();

var curSong=FlxG.save.data.Bamber_SONGSONG;

var songName = new Alphabet(285.25, 70, 0, true);
var composer = new Alphabet(0, 130, 0, true);
var play_Text = new Alphabet(1000, 665, 'PLAY', true);
import funkin.menus.ui.ClassicAlphabet;
var scroll_speed = new Alphabet(540, 470, "<"+ FlxG.save.data.options.scrollSpeed_Speed+">", true);

var hitbox:FlxSprite;
var portrait = new FlxSprite(530,0);

var composer_icon = new FlxSprite(530,0);

static var curDifficulty:Int = 0;
var difficultySprites:Map<String, FlxSprite> = [];
var arrows:Array<FunkinSprite> = [];
var curOption:Int = 0;

static var curPlayingInst = Paths.inst(curSong.name, curSong.difficulties[curDifficulty]);
static var prevSong:String = "";

var progressGroup = new FlxTypedSpriteGroup();
var bulletoptionREAL:FlxSprite = new FlxSprite(-170,8);
var options:Array<String> = ['Cutscenes','Mod charts','Scroll Speed','Mode'];
//Idea , have the option greyed out if mod-charts are set to always, same with scroll-speed.
var checkboxes = new FlxTypedSpriteGroup();
var optionText = new FlxTypedGroup();
function create() {
	new FlxTimer().start(0.2, ()->{click_through = true;});
	prevchar = curPlayingInst;
    FlxG.cameras.add(coolCam, false).bgColor = 0x00000000;

	add(bg = new FlxSprite(-50,-50).makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK)).alpha = 0.6;
	bg.camera = coolCam;
	play_Text.camera = coolCam;
	add(play_Text).scale.set(1.5,1.5);
	add(hitbox = new FlxSprite(950, 615).makeSolid(330, 100, 0xE0000020)).alpha = 0;
	hitbox.camera = coolCam;
	portrait.camera = coolCam;
	if (!Assets.exists(Paths.image('menus/freeplay/albums/vol' +curSong.album)))
		portrait.loadGraphic(Paths.image('menus/freeplay/albums/vol1'));
	else
		portrait.loadGraphic(Paths.image('menus/freeplay/albums/vol'+curSong.album));
	add(portrait).angle=-3;
	portrait.setGraphicSize(300,300);
	songName.text = curSong.displayName;
	songName.alignment="center";
	add(songName).camera = coolCam;
	songName.screenCenter(FlxAxes.X);
	
	composer.text = "By "+ curSong.composer;
	composer.camera = coolCam;
	composer.scale.set(0.5,0.5);
	composer.screenCenter(FlxAxes.X);
	add(composer).x +=songName.width-songName.width/1.5;

	composer_icon.camera = coolCam;
	if (!Assets.exists(Paths.image('credits/devs/' +curSong.composer)))
		composer_icon.loadGraphic(Paths.image('credits/missing'));
	else
		composer_icon.loadGraphic(Paths.image('credits/devs/'+curSong.composer));
	add(composer_icon);
	composer_icon.x= songName.x+songName.width+10;//Make_a_custom_class_later_for_handling_multi_icons?

	scroll_speed.alignment="right";
	add(scroll_speed).camera = coolCam;
	scroll_speed.scale.set(0.8,0.8);

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

	changeDiff(0);
	changeOption(0);
	changeScroll(0);

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
	add(progressGroup).y +=10;

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
		item.y = ((i * progressGroup.members[4].y*0.8) * item.scale.y)+240;
		item.updateHitbox();
		item.camera=coolCam;
		optionText.add(item).width = item.width*item.scale.y;
	}

	if(!FlxG.save.data.options.scrollSpeed)optionText.members[2].alpha=scroll_speed.alpha=0.3;
	if(FlxG.save.data.options.modcharts=='Always')optionText.members[1].alpha=0.3;
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
		Options.save();
		FlxG.sound.music.fadeOut(9,0,1);
		close();
	}
	if (controls.ACCEPT) toggle();
	if (FlxG.mouse.overlaps(hitbox) && FlxG.mouse.pressed){
		playsong();
		click_through=false;
	}
	if (controls.UP_P||controls.DOWN_P) changeOption(controls.UP_P ? -1 : 1);
}
var __oldDiffName = null;
function changeDiff(e) {
	arrows[FlxMath.bound(e, 0, 1)].animation.play("hit");
	curDifficulty = FlxMath.wrap(curDifficulty + e, 0,  FlxG.save.data.Bamber_SONGSONG.difficulties.length - 1);
	if (__oldDiffName != (__oldDiffName = FlxG.save.data.Bamber_song_diff[curDifficulty].toLowerCase())) {
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
	curOption = FlxMath.wrap(curOption + p, 0,  3);
	trace("Options: "+options[curOption]);
	if(click_through && curOption!=0){
	FlxTween.tween(bulletoptionREAL, {y: bulletoptionREAL.height/10 + progressGroup.members[(curOption/4) * 11].y}, 0.4,{ease: FlxEase.quartInOut});
	}
	if(click_through && curOption==0) FlxTween.tween(bulletoptionREAL, {y: 8}, 0.5,{ease: FlxEase.quartInOut});
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
	//if (FlxG.save.data.options.scrollSpeed) scrollSpeed = FlxG.save.data.options.scrollSpeed_Speed;
	PlayState.loadSong(curSong.name, curSong.difficulties[curDifficulty].toLowerCase());
	FlxG.switchState(new PlayState());
	curPlayingInst="fuck";
}
function destroy() {
	//Destroy_the_other_stuff_later.
	FlxG.cameras.remove(coolCam);
}