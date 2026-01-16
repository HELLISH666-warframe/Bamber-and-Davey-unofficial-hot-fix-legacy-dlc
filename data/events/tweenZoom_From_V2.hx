//function tweenZoom(amount:Float, beats:Float, ease:String, ?affectHUD = 'true', ?doChangeDefaultZoom = 'false') {
function onEvent(_) {
	if (_.event.name == 'tweenZoom_From_V2') {
		var amount = Std.parseFloat(_.event.params[0]);
		var beats = Std.parseFloat(_.event.params[1]);
		FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + Std.parseFloat(amount)}, Conductor.stepCrochet / 250 * beats, {ease: CoolUtil.flxeaseFromString(_.event.params[2])});
		if (_.event.params[4]) FlxTween.num(defaultCamZoom, defaultCamZoom + Std.parseFloat(amount), Conductor.stepCrochet / 250 * beats, {ease: CoolUtil.flxeaseFromString(_.event.params[2])}, function(strength:FlxTween) {
			defaultCamZoom=strength;
		});
		if (_.event.params[3]) FlxTween.tween(camHUD, {zoom: camHUD.zoom + amount/3}, Conductor.stepCrochet / 250 * beats, {ease: CoolUtil.flxeaseFromString(_.event.params[2])});
	}
}
//CoolUtil.flxeaseFromString(_.event.params[2])