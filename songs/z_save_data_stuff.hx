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
	if(inst!=null) inst.volume = getVolume(0.3/6, 'music');
}
function update(elapsed:Float) {
	//if (!isOffsync) return;
	for (strumLine in strumLines.members) {
		strumLine.vocals.group.volume = getVolume(4/10,'voices');
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

function onSongEnd(){
	if(!FlxG.save.data.gameStats.clearedSongs.contains(curSong))
		FlxG.save.data.gameStats.clearedSongs.push(curSong);
	if(PlayState.isStoryMode)
	switch(curSong){
		case'Harvest':FlxG.save.data.gameStats.discoveries["Bamber's Farm"]=true;
		case'Coop':FlxG.save.data.gameStats.discoveries["Davey's Yard"]=true;
		case'Fortnite Duos':FlxG.save.data.gameStats.discoveries["Romania Outskirts"]=true;
	}
}