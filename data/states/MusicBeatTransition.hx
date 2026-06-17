function postCreate() {
	for (i in FlxG.sound.list) if (i._paused) i.resume();//FUCK FunkinParentDisabler.
}