import flixel.util.FlxGradient;
function create() {
	add(new FlxSprite(0, 0).loadGraphic(Paths.image("menus/menuBGYoshiCrafter")));
	add(new FlxSprite(0, 0).makeGraphic(FlxG.width, 80, 0x88000000, true));
	add(gradient = FlxGradient.createGradientFlxSprite(Std.int(FlxG.width), Std.int(FlxG.height), [0x00000000, 0xFFAAAAAA]));
}
function update(){
	if (controls.BACK) FlxG.switchState(new MainMenuState());
}