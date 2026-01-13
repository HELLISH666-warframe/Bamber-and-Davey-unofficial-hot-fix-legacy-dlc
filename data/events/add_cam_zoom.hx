function onEvent(_) {
	var Value1 = Std.parseFloat(_.event.params[0]);
	var Value2 = Std.parseFloat(_.event.params[1]);
	if (Math.isNaN(Value2)) Value2 = null;
	if (_.event.name == 'add_cam_zoom') {
		//PlayState.camZooming = true;

		camGame.zoom += Value1 * 2;
		camHUD.zoom += Value2 * 2;
		trace(camHUD.zoom+'HUDDDDD');
	}
}