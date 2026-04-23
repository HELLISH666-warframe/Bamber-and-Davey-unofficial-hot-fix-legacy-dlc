import flixel.math.FlxRandom;
var time:Float = 0;

function create() {
	for (i in 0...30) {
		var speedline = new FlxSprite(new FlxRandom().float(3280, 7580), new FlxRandom().float(-1500, 1700)).makeGraphic(new FlxRandom().float(520, 1080), new FlxRandom().float(1, 20));
		FlxTween.tween(speedline, {x: -3720}, 0.1, {onComplete: function(twn:FlxTween) {
			speedline.x = new FlxRandom().float(3280, 7580);
			speedline.y = new FlxRandom().float(-1500, 1700);
			speedline.width = new FlxRandom().float(520, 1080);
			speedline.height = new FlxRandom().float(1, 20);
		}, type: FlxTween.LOOPING});
		add(speedline);
	}
	octopus.forceIsOnScreen = true; 
}

function update(elapsed) {
	time += elapsed;
	var sine = Math.sin(60 * time) * 2;
	var shake = new FlxRandom().float(0, 2) * 0.3;
	camGame.scroll.x += shake * sine * FlxG.camera.zoom * 10;
	var sineY = Math.sin(75 * time) * 2;
	var shakeY = new FlxRandom().float(0, 2) * 0.4;
	camGame.scroll.y += shakeY * sineY * FlxG.camera.zoom * 10;
}