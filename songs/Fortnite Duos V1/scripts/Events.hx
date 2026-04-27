var pixel = new CustomShader("JPG");

var pixelSize:Float = 22;

var startPostiosnesfgre = [-104,8,120,232];

function postCreate(){
	FlxG.camera.addShader(pixel);

    pixelSize=0.1;
    camZooming=true;
}
function fadePixels(time:Float, size:Float)
{
	FlxTween.num(pixelSize, size, time, {ease: FlxEase.quartInOut}, function(v) {pixelSize = v;});
}

function update(elapsed:Float)  pixel.pixel_size = pixelSize;

function onStartCountdown(){
    for (i in 0...4) { 
        for (guh in [strumLines.members[3], cpuStrums]) {
        FlxTween.completeTweensOf(guh.members[i]);
        guh.members[i].scrollFactor.set(1,1);
        guh.members[i].setPosition(startPostiosnesfgre[i],430);
        }
    }
    for (i in cpuStrums.members) {i.camera = camGame;
        i.x += 1050;
    }
    for (i in strumLines.members[3]) {i.camera = camGame;
        i.x += 1050;
        i.visible=false;
    }
}

function onStrumCreation(e) if(!e.player) e.__doAnimation=false;//So_the_y_isnt_fucked_up.
//for(num => a in [iconP1, iconP2]) a.setIcon(["bf-fortniteduos", "ronnieandboris"][num]);
function onCameraMove(e)
    if(curCameraTarget==0||curCameraTarget==3){
    iconP2.setIcon(curCameraTarget==0?'ronnie-old':'boris-old');
    //healthBar.createFilledBar(curCameraTarget==0?0xFFF600:0xFFFFFF, boyfriend.iconColor);
    }

function giveBirthToThe3rd() {
	for (i in strumLines) {
		FlxTween.cancelTweensOf(i);
	}
	for (i in 0...cpuStrums.length) {
		cpuStrums.members[i].camera = camGame;
    	FlxTween.tween(cpuStrums.members[i], {x: cpuStrums.members[0].x + (270 + Note.swagWidth * (i * 0.9)), 'scale.x': cpuStrums.members[i].scale.x * 0.9,'scale.y': cpuStrums.members[i].scale.y * 0.9}, Conductor.crochet / 1000, {ease: FlxEase.backOut});

        strumLines.members[3].members[i].visible=true;
		FlxTween.tween(strumLines.members[3].members[i], {x: strumLines.members[3].members[0].x - (-230 + Note.swagWidth * (4-i * 1.1)), 'scale.x': strumLines.members[3].members[i].scale.x * 1.1,'scale.y': strumLines.members[3].members[i].scale.y * 1.1, y: strumLines.members[3].members[i].y + 100}, Conductor.crochet / 1000, {ease: FlxEase.backOut});
	}
}