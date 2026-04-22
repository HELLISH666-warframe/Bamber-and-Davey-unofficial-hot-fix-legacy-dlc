import flixel.addons.display.FlxBackdrop;

function create(){
	if (curSong.toLowerCase() == "coop"||curSong.toLowerCase()=='coop vol2'){
		grass.loadGraphic(Paths.image("stages/yard/Grass_WithBamber"));
		boyfriend.x+=100;
		boyfriend.y+=30;
	}
	insert(members.indexOf(hill), balloons = new FlxBackdrop(Paths.image("stages/yard/scrollingBG"), FlxAxes.X));
	balloons.setPosition(-600, -100);
	balloons.scrollFactor.x = balloons.scrollFactor.y = 0.2;
	if(strumLines.members[2].characters[0].curCharacter == "BnD-gf"){
		strumLines.members[2].characters[0].x -= 200;
		strumLines.members[2].characters[0].y -= 440;
	}
}

var danced = false;
function beatHit()
	bopper.playAnim((danced = !danced) ? "danceLeft" : "danceRight", "DANCE");

function update(elapsed:Float)
	balloons.x = Conductor.songPosition/50;


function onCameraMove(e){
	e.position.y -= (strumLines.members[curCameraTarget].characters[0].idleSuffix == "-alt" ? 200 : 0);
	defaultCamZoom = (strumLines.members[curCameraTarget].characters[0].idleSuffix == "-alt" ? 0.45 : 0.6);
}

