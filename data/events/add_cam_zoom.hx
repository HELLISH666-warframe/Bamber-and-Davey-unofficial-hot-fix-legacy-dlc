function onEvent(_) {
	var flValue1 = Std.parseFloat(_.event.params[0]);
	var flValue2 = Std.parseFloat(_.event.params[1]);
	if (Math.isNaN(flValue2)) flValue2 = null;
	if (_.event.name == 'add_cam_zoom') {

		FlxG.camera.zoom += flValue1 * 2;
		camHUD.zoom += flValue2 * 2;
		trace(defaultCamZoom);
		trace(camHUD.zoom+'HUDDDDD');
	}
}