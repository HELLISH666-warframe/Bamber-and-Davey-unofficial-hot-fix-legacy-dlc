if(!PlayState.difficulty.toLowerCase() == "vip")return;
var feck_it = false;
var aggro = false;

function beatHit(curBeat:Int) {
    camZoomingInterval = feck_it ? 1 : 4;
    if(feck_it){
        if(FlxG.save.data.options.modcharts!='Never'){
            for(b in strumLines)
                for(c in b){
                    aggro?
                    c.y=100 : if(curBeat % 2 == 0)c.y=70;
                    FlxTween.cancelTweensOf(c,['y']);
                    FlxTween.tween(c, {y: 50}, 0.5, {ease: FlxEase.circOut});
                }
        }
    }
    switch(curBeat){
        case 32|64|256|320:feck_it=!feck_it;
        aggro=!aggro;
        case 94|158:feck_it=true;
        case 126|250:feck_it=false;
    }
}