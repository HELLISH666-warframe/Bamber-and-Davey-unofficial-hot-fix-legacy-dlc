import StringTools;

function onNoteCreation(e)
	if (e.note.extra["charId"] != null) trace(e.note.extra);

var dadTweens = [];
var dadPosX = [];

var camera_follow = scripts.get('otherCamFollow');

var playerTeam=[];
var playerTweens = [];
var playerPosX = [];

function postCreate() {
	playerTeam.push(boyfriend); //Normally if everything was the boyfriends var, girlfiend wouldn't be included. Which is why this is necessary.
	playerTeam.push(gf); //I tried pushing gf to boyfriends but that wasn't the smartest idea.
}

function onNoteHit(e){
	switch(e.noteType){
		case "special/beatbox"|"special/guitar"|"alt-anim": e.animSuffix = "-alt";
		case "special/phone": e.cancelAnim();
		e.character.playAnim("break", true);
		for(num => a in [camGame, camHUD]){
			a.zoom += 0.05;
			FlxTween.cancelTweensOf(a);
			a.angle = Std.int(Conductor.songPosition) % 2 == 0 ? (a == 0 ? -1 : 1) : (a == 0 ? 1 : -1);
			FlxTween.tween(a, {angle: 0}, 0.25);
		}
		case "special/strike":
		var dads=[dad,strumLines.members[3].characters[0]];
		if (dadTweens.length == 0) for (i in 0...dads.length) {dadTweens[i] = null; dadPosX[i] = dads[i].x;}
        FlxTween.tween(otherCamFollow, {x: boyfriend.x + boyfriend.width/2}, 0.1, {ease: FlxEase.quartOut});
        var chosenDad = Math.min(FlxG.random.int(0, dads.length+3), dads.length-1);
        if (dadTweens[chosenDad] != null && dadTweens[chosenDad].active) dadTweens[chosenDad].cancel();
        dads[chosenDad].x = dadPosX[chosenDad];
        dads[chosenDad].x += 750;
        dadTweens[chosenDad] = FlxTween.tween(dads[chosenDad], {x: dadPosX[chosenDad]}, 0.5, {ease: FlxEase.backIn});

		case "special/shield":
		FlxG.sound.play(Paths.sound('battlefx/dodge'), 1);
        if (playerTweens.length == 0) for (i in 0...playerTeam.length) { playerTweens[i] = null; playerPosX[i] = playerTeam[i].x;}

		var chosenPlayer = FlxG.random.int(0, playerTeam.length-1);

        if (playerTweens[chosenPlayer] != null && playerTweens[chosenPlayer].active) playerTweens[chosenPlayer].cancel();
        playerTeam[chosenPlayer].x = playerPosX[chosenPlayer];
        playerTeam[chosenPlayer].x += 200;
        playerTweens[chosenPlayer] = FlxTween.tween(playerTeam[chosenPlayer], {x: playerPosX[chosenPlayer]}, 0.5, {ease: FlxEase.backIn});

		case "strumLine3Sing"|"gf-sing":e.cancelAnim();
        strumLines.members[2].characters[0].playSingAnim(e.direction, e.animSuffix);
		case "strumLine4Sing":e.cancelAnim();
        strumLines.members[3].characters[0].playSingAnim(e.direction, e.animSuffix);	
		case "no-anim":e.cancelAnim();
	}
}

function onPlayerMiss(e)
	if(e.noteType == "special/shield") health /= 3;