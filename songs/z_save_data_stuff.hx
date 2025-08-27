//Aperraentrelyyd the engine will load this last since it starts with Z.
function onPlayerMiss(e) {
	//Sound
	if(FlxG.save.data.options.missSounds!=true){
	e.playMissSound=false;
	}
}
function postCreate() {
	//Sound
	if(FlxG.save.data.options.missSounds!=true){
		muteVocalsOnMiss=false;
	}
	//Appearance
	if(FlxG.save.data.options.healthIcons!=true){
		iconP1.alpha=iconP2.alpha=0.001;
	}
}
function onGameOver(e) {
	//Gameplay Options
	if(FlxG.save.data.options.skipGameOver){
		e.cancel();
		FlxG.resetState();
	}
}
if (FlxG.save.data.options.freeplayDialogue&&!PlayState.seenCutscene){
    playCutscenes=true;
}