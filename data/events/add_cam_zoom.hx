function onEvent(_) {
	if (_.event.name == 'add_cam_zoom') {
		var val1 = Std.parseFloat(_.event.params[0]);
		var val2 = Std.parseFloat(_.event.params[1]);
		PlayState.camZooming = true;
		camGame.zoom += val1 * 2;
		camHUD.zoom += _.event.params[1] * 2;
	}
}