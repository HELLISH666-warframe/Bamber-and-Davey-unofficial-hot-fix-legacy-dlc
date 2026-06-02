public static var bop = false;

function beatHit(curBeat:Int) {
    if(curBeat == -4) bop = false;
    camZoomingInterval = bop ? 1 : 4;
    if(bop){
        for(a in [iconP1, iconP2]){
			a.angle = curBeat % 2 == 0 ? 25 : -25;
			FlxTween.cancelTweensOf(a,['angle']);
			FlxTween.tween(a, {angle: 0}, 0.5, {ease: FlxEase.circOut});
        }
        if(PlayState.difficulty.toLowerCase() == "hard" && FlxG.save.data.options.modcharts!='Never')
            for(b in strumLines)
                for(c in b){
                    c.angle = curBeat % 2 == 0 ? (c.strumID % 2 == 0 ? 5 : -5) : (c.strumID % 2 == 0 ? -5 : 5);
                    FlxTween.cancelTweensOf(c,['angle']);
                    FlxTween.tween(c, {angle: 0}, 0.5, {ease: FlxEase.circOut});
                }
    }
}

//Memory_leak!
function update(elapsed:Float) {
    //strumLines.members[0].notes.forEach((note) -> {trace(note);});
    //return;
    for(b in 0...playerStrums.members.length){
        for (i in playerStrums.notes) {
            if(i.noteData==b&&i.strumTime-Conductor.songPosition<=900)
            i.scale.set(playerStrums.members[b].scale.x,playerStrums.members[b].scale.y);
        }
    }

    for(b in 0...cpuStrums.members.length){
        for (i in cpuStrums.notes) {
            if(i.noteData==b&&i.strumTime-Conductor.songPosition<=900)
            i.scale.set(cpuStrums.members[b].scale.x,cpuStrums.members[b].scale.y);
        }
    }

        //playerStrums.members[i].scale.x
    //for(b in strumLines)for(i in b.notes) i.scale.set(0.4,0.4);
}