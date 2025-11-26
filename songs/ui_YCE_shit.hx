import flixel.text.FlxTextBorderStyle;
public var watermark:FlxText;

function create() {
    //if (engineSettings.watermark) {
		watermark = new FlxText(0, 0, FlxG.width,'jfhrg');
		watermark.setFormat(Paths.font("vcr.ttf"), Std.int(16), FlxColor.WHITE, 'right', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		watermark.antialiasing = true;
		watermark.camera = camHUD;
		watermark.visible = false;
		add(watermark);
	//}
}