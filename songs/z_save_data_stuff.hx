//Aperraentrelyyd the engine will load this last since it starts with Z.
function onPlayerMiss(e) {
	//Sound
	if(FlxG.save.data.options.missSounds!=true){
	e.playMissSound=false;
	}else
	for (strumLine in strumLines.members) {
		strumLine.vocals.group.volume = getVolume(0.3/4);
	}
}
function postCreate() {
	//Sound
	muteVocalsOnMiss=FlxG.save.data.options.missSounds;
	//Appearance
	if(!FlxG.save.data.options.healthIcons){
		iconP1.alpha=iconP2.alpha=0.001;
	}
	//Gameplay Options
	if(FlxG.save.data.options.scrollSpeed){
	scrollSpeed=FlxG.save.data.options.scrollSpeed_Speed;
	}
	Options.ghostTapping=FlxG.save.data.options.ghostTapping;
	//if(inst!=null) inst.volume = getVolume(0.3/6, 'music');
}
/*function update(elapsed:Float) {
	//if (!isOffsync) return;
	for (strumLine in strumLines.members) {
		strumLine.vocals.group.volume = getVolume(4/10,'voices');
	}
}*/
function onGameOver(e) {
	//Gameplay Options
	FlxG.save.data.gameStats.deaths++;
	if(FlxG.save.data.options.skipGameOver){
		e.cancel();
		FlxG.resetState();
	}
}
//Gameplay Options
if (!PlayState.seenCutscene){
	if(PlayState.isStoryMode && !FlxG.save.data.options.dialogue[0]) playCutscenes=false;
	else playCutscenes=FlxG.save.data.options.dialogue[2];
}

var acheveweeks = [['w1','w2','w3'],['harvest','coop','fortnite duos']];
function onSongEnd(){
	if(!FlxG.save.data.gameStats.clearedSongs.contains(curSong))
		FlxG.save.data.gameStats.clearedSongs.push(curSong);
	if(!PlayState.isStoryMode)return;
	switch(curSong.toLowerCase()){
		case'harvest':FlxG.save.data.gameStats.discoveries["Bamber's Farm"]=true;
		if(!FlxG.save.data.gameStats.achievements.contains('w1')) FlxG.save.data.gameStats.achievements.push('w1');
		case'coop':FlxG.save.data.gameStats.discoveries["Davey's Yard"]=true;
		if(!FlxG.save.data.gameStats.achievements.contains('w2')) FlxG.save.data.gameStats.achievements.push('w2');
		case'fortnite duos':FlxG.save.data.gameStats.discoveries["Romania Outskirts"]=true;
		if(!FlxG.save.data.gameStats.achievements.contains('w3')) FlxG.save.data.gameStats.achievements.push('w3');
	}
}