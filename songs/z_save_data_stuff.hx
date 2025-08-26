function postCreate() {
	if(FlxG.save.data.options.healthIcons!=true){
		iconP1.alpha=iconP2.alpha=0.001;
	}
}