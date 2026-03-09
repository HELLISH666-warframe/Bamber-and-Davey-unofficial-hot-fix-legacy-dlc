import flixel.text.FlxTextBorderStyle;
import flixel.FlxCamera.FlxCameraFollowStyle;
function postCreate() {
    var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/menuBGYoshiCrafter'));
	bg.scrollFactor.x = 0;
	bg.scrollFactor.y = 0;
	bg.setGraphicSize(Std.int(bg.width * 1.1 / 0.75));
	bg.updateHitbox();
	bg.screenCenter();
	bg.antialiasing = true;
	add(bg);

    socialThingy = new FlxText(0, 0, 0, "< - >");
    socialThingy.setFormat(Paths.font("vcr.ttf"), Std.int(44), FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    socialThingy.antialiasing = true;
    add(socialThingy);

    camFollow = new FlxSprite(FlxG.width / 2, 0);
    FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.08);
    FlxG.camera.zoom = 0.75;

    var y = 0;
}

function update(elapsed:Float) {
    if (controls.BACK) FlxG.switchState(new ModState("BND/BNDMenu"));
}