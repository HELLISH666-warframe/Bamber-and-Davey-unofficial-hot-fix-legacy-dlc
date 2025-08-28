//VERY_wip.
import flixel.text.FlxTextBorderStyle;
import flixel.group.FlxTypedSpriteGroup;
import funkin.options.type.Checkbox;
import funkin.options.Options;

var click_through:Bool = false;
var canPlay:Bool = true;
var coolCam = new FlxCamera();

var curSong=FlxG.save.data.Bamber_SONGSONG;

var text = new Alphabet(285.25, 70, 0, true);
var composer = new Alphabet(FlxG.width/2.8, 130, 0, true);
var play_Text = new Alphabet(1000, 650, 0, true);
var hitbox:FlxSprite;
//So people don't click the text and have it MISS.

var portrait = new FlxSprite(530,0);
static var curDifficulty:Int = 0;
var difficultySprites:Map<String, FlxSprite> = [];
var arrows:Array<FunkinSprite> = [];
var curOption:Int = 0;

static var curPlayingInst = Paths.inst(curSong.name, curSong.difficulties[curDifficulty]);
static var prevSong:String = "";

var bulletOption:FlxSprite;
var progressGroup = new FlxTypedSpriteGroup();
var bulletoptionREAL:FlxSprite = new FlxSprite(-170,-20);
var options:Array<String> = ['Cutscenes','Mod charts','Scroll Speed','Mode'];
public static var cutscene_Toggle:Bool = FlxG.save.data.options.freeplayDialogue;
public static var modchart_Toggle:Bool = FlxG.save.data.options.modcharts;
public static var scroll_Speed:Float = 1;
var checkbox_text:Checkbox;
var checkbox_real:Checkbox;
var checkboxes = new FlxTypedSpriteGroup();
static var toggles = [cutscene_Toggle,modchart_Toggle];
function create() {
	new FlxTimer().start(0.2, function(tmr:FlxTimer) click_through = true);
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
	text.camera = coolCam;
	text.alignment="center";
	add(text);
	text.screenCenter(FlxAxes.X);
	composer.text =  "By placeholder";
	composer.camera = coolCam;
	composer.scale.set(0.5,0.5);
	add(composer).x = text.width+140;

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
		bulletOption.ID = i;
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

        checkbox_real.animation.addByPrefix('false', "Checkbox_false", 24, false);
		checkbox_real.animation.addByPrefix('true', "Checkbox0", 24,false);
		checkbox_real.animation.play(toggles[i]);

		checkbox_real.ID = i;
        checkboxes.add(checkbox_real);

        manY += checkbox_real.height * (i % 2 == 0 ? 1.3 : 3);
		namX += (i % 2 == 0 ? 70 : 500);
        checkbox_real.antialiasing = true;
		checkbox_real.camera=coolCam;
    }
	add(checkboxes).y= -280;

	for (i in 0...options.length) {
		var item = new Alphabet(120, (i * 80), 540, 0,true);
		item.text=options[i];
		item.scale.set(0.9,0.9);
		item.y = ((i * progressGroup.members[4].y*0.95) * item.scale.y)+210;
		item.updateHitbox();
		item.ID = i;
		item.camera=coolCam;
		add(item).width = item.width*item.scale.y;
	}

	bulletoptionREAL.frames = Paths.getFrames('menus/freeplay/bulletOption');
	bulletoptionREAL.animation.addByPrefix('idle', "appear", 10, false);

	bulletoptionREAL.camera=coolCam;
	bulletoptionREAL.scale.set(0.3,0.3);
	add(bulletoptionREAL).animation.play('idle');
	if(curPlayingInst!=prevSong)
	FlxG.sound.playMusic(curPlayingInst, 0);
	if(FlxG.sound.music!=null) FlxG.sound.music.fadeIn(9,0,1);
	trace(curSong.color);
}
function update(elapsed:Float) {
	if ((controls.RIGHT_P||controls.LEFT_P) && curOption==3) changeDiff(controls.RIGHT_P ? 1 : -1);
	if ((controls.RIGHT_P||controls.LEFT_P) && curOption==2) changeScroll(controls.RIGHT_P ? 0.1 : -0.1);
	if (controls.BACK){
		FlxG.save.data.options.modcharts=modchart_Toggle;
		Options.save();
		FlxG.sound.music.fadeOut(9,0,1);
		close();
	}
	if(click_through){
	    if (controls.ACCEPT) toggle();
		if (FlxG.mouse.overlaps(hitbox) && FlxG.mouse.pressed&&canPlay){
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
		case 0:cutscene_Toggle=!cutscene_Toggle;
		trace("Cutscenes are : "+cutscene_Toggle);
		case 1:modchart_Toggle=!modchart_Toggle;
		trace("Mod-charts are : "+modchart_Toggle);
	}
	toggles = [cutscene_Toggle,modchart_Toggle];
	checkboxes.members[curOption].animation.play(toggles[curOption]);
}
function changeScroll(s) {
	scroll_Speed+= s;
	trace(scroll_Speed);
	if (scroll_Speed < 0) scroll_Speed = 0.1;
}
function playsong() {
	FlxG.save.data.options.freeplayDialogue=cutscene_Toggle;
	FlxG.save.data.options.modcharts=modchart_Toggle;
	//if (FlxG.save.data.options.scrollSpeed) scrollSpeed = FlxG.save.data.options.scrollSpeed_Speed;
	PlayState.loadSong(curSong.name, curSong.difficulties[curDifficulty].toLowerCase());
	FlxG.switchState(new PlayState());
}
function destroy() {
	//Destroy_the_other_stuff_later.
	FlxG.cameras.remove(coolCam);
}