import flixel.math.FlxRect;
import flixel.ui.FlxBar;

var hptexter;
var hepertexter;
function postCreate() {
    for(i in [scoreTxt,missesTxt,accuracyTxt])
	i.font=Paths.font('Mars_Needs_Cunnilingus.ttf');

    GameOverSubstate.firstDeathSFX = "death/starts/ut-death";
	iconP1.visible = iconP2.visible = false;
	healthBarBG.visible = false;
	remove(healthBar);
	healthBar = new FlxBar(0, 640, null, 92 * 2, 35, healthBar.parent, healthBar.parentVariable,0,2);
	healthBar.screenCenter(FlxAxes.X);
	healthBar.createFilledBar(0xFFFF0000, 0xFFfffd03);
	add(healthBar);
	if(PlayState.instance.SONG.stage=="judgement hall"){
	var thing = new FlxSprite(-2000, PlayState.downscroll ? -10 : 600).makeGraphic(1, 1, 0xFF000000);
    thing.scale.set(5000,130); thing.updateHitbox();
	insert(0, thing).camera=camHUD;
	}
	var nametexter = new FlxText(healthBar.x - 350, healthBarBG.y - 16, 0, "BAMBER", 30);
	add(nametexter);
	var leveltexter = new FlxText(healthBar.x - 200, healthBarBG.y - 16, 0, "LV 19", 30);
	add(leveltexter);
	hptexter = new FlxText(healthBar.x - 40, healthBarBG.y - 12, 0, "HP", 15);
	hepertexter = new FlxText(healthBar.x + (healthBar.width + 20), healthBarBG.y - 16, 0, "FHOSIOJFHSDJ", 30);
	add(hepertexter);
	healthBar.cameras = nametexter.cameras = leveltexter.cameras = hptexter.cameras = hepertexter.cameras = [camHUD];
	hptexter.font = Paths.font("8bit_wonder.ttf");
	add(hptexter);
}

function update(elapsed:Float) {
    hepertexter.text = Math.min(Math.floor(health * 46), 92)  + " / 92";
}