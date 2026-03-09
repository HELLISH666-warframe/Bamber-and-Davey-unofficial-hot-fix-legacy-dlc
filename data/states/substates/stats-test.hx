//VERY_wip.
import flixel.text.FlxTextBorderStyle;
import flixel.group.FlxTypedSpriteGroup;
import funkin.options.Options;

var click_through:Bool = false;
var coolCam = new FlxCamera();

var text = new Alphabet(285.25, 70, 0, true);
var composer = new Alphabet(FlxG.width/2.8, 130, 0, true);
var play_Text = new Alphabet(1000, 650, 0, true);
var scroll_speed = new Alphabet(540, 480, 0, true);

var difficultySprites:Map<String, FlxSprite> = [];
var arrows:Array<FunkinSprite> = [];
var curOption:Int = 0;
public static var scroll_Speed:Float = 1;

var progressGroup = new FlxTypedSpriteGroup();
var bulletoptionREAL:FlxSprite = new FlxSprite(-170,-20);
var options:Array<String> = ['Cutscenes','Mod charts','Scroll Speed','Mode'];
static var toggles = [FlxG.save.data.options.freeplayDialogue,FlxG.save.data.options.modcharts];
function create() {
	new FlxTimer().start(0.2, ()->{click_through = true;});
    FlxG.cameras.add(coolCam, false).bgColor = 0x00000000;

	var bg = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
	bg.screenCenter();
	bg.scrollFactor.set();
	bg.camera = coolCam;
	add(bg).alpha = 0.6;
	play_Text.text = "PLAY";
	play_Text.camera = coolCam;
	add(play_Text).scale.set(1.5,1.5);
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
}
function update(elapsed:Float) {
	if ((controls.RIGHT_P||controls.LEFT_P) && curOption==2) changeScroll(controls.RIGHT_P ? 0.1 : -0.1);
	if (controls.BACK){
		Options.save();
		close();
	}
	if(click_through){
		if (controls.UP_P||controls.DOWN_P){
		changeOption(controls.UP_P ? -1 : 1);
		}
	}
}
function changeOption(p) {
	curOption += p;
	if (curOption < 0) curOption = 3;
	if (curOption >= 4) curOption = 0;
}
function changeScroll(s) {
	if(FlxG.save.data.options.scrollSpeed)
	scroll_Speed+= s;
	trace(scroll_Speed);
	if (scroll_Speed < 0) scroll_Speed = 0.1;
	scroll_speed.text ="<"+ scroll_Speed+">";
}
function destroy() {
	//Destroy_the_other_stuff_later.
	FlxG.cameras.remove(coolCam);
}