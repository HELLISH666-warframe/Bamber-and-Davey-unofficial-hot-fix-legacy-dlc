//VERY_wip.
import flixel.text.FlxTextBorderStyle;
import flixel.group.FlxTypedSpriteGroup;
import funkin.menus.StoryMenuState;

var click_through:Bool = false;
var canPlay:Bool = true;
var coolCam = new FlxCamera();

var curSong=FlxG.save.data.Bamber_SONGSONG;

var text = new Alphabet(285.25, 70, 0, true);
//So people don't click the text and have it MISS.

var curOption:Int = 0;

var bulletOption:FlxSprite;
var progressGroup = new FlxTypedSpriteGroup();
var bulletoptionREAL:FlxSprite = new FlxSprite(-170,-20);
var options:Array<String> = ['Story Mode','Freeplay','Gallery','DLC'];
function create() {
	new FlxTimer().start(0.2, function(tmr:FlxTimer) click_through = true);
    FlxG.cameras.add(coolCam, false).bgColor = 0x00000000;

	var bg = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
	bg.screenCenter();
	bg.scrollFactor.set();
	bg.camera = coolCam;
	add(bg).alpha = 0.6;
	text.text = "Placeholder_substate.";
	text.camera = coolCam;
	text.alignment="center";
	add(text);
	text.screenCenter(FlxAxes.X);
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
	FlxG.sound.music.fadeIn(9,0,1);
}
function update(elapsed:Float) {
	if ((controls.RIGHT_P||controls.LEFT_P) && curOption==3) changeDiff(controls.RIGHT_P ? 1 : -1);
	if ((controls.RIGHT_P||controls.LEFT_P) && curOption==2) changeScroll(controls.RIGHT_P ? 0.1 : -0.1);
	if (controls.BACK){
		close();
	}
	if(click_through){
	    if (controls.ACCEPT) toggle();
		if (controls.UP_P||controls.DOWN_P){
		changeOption(controls.UP_P ? -1 : 1);
		}
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
		case 0:
		FlxG.switchState(new StoryMenuState());
		case 1:
		FlxG.switchState(new ModState("BNDFreeplayCategories"));
	}
}
function destroy() {
	//Destroy_the_other_stuff_later.
	FlxG.cameras.remove(coolCam);
}