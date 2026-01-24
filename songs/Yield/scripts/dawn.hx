var currentColor:FlxColor = null;
var interpolationFactor:Float = 0;

var colors = [0xffBB3965, 0xffF4C67C, 0xffFFFFFF];
var skyColors = [0xffFF4F20, 0xff67F890, 0xffFFFFFF];

var godrays = new CustomShader('godrayz');

function postCreate() {
    FlxG.camera.addShader(godrays);
	godrays.Density = 0.25;
	godrays.Weight = 0.03;
	godrays.illuminationDecay = 0.001;

    for (i in state.members) if (i != null && i.name == 'Sky') sky = i;

    YCE_ColorChange(0);
}

//This is a function because FlxG.camera.color is BROKEN on YCE, no matter what I try.
function YCE_ColorChange(interpolationFactor) {
    currentColor = FlxColor.interpolate(colors[Math.floor(interpolationFactor)], colors[Math.floor(Math.min(colors.length-1, interpolationFactor+1))], interpolationFactor%1);
    for (i in members) {
        if (i != null && i.exists && i.color != null && i.camera == FlxG.camera) i.color = currentColor;
    }

    currentColor = FlxColor.interpolate(skyColors[Math.floor(interpolationFactor)], skyColors[Math.floor(Math.min(skyColors.length-1, interpolationFactor+1))], interpolationFactor%1);
    stage.getSprite("sky").color = currentColor;
}

function dawnProgress(steps) {
     FlxTween.num(interpolationFactor, interpolationFactor+1, Conductor.stepCrochet/250 * steps, null, function(value) {
        interpolationFactor = value;
        YCE_ColorChange(interpolationFactor);
    });
    FlxTween.num(godrays.data.Weight.value[0], godrays.data.Weight.value[0]-0.015, Conductor.stepCrochet/250 * steps, {onComplete: function(tween) {
        if (godrays.data.Weight.value[0] == 0) FlxG.camera.removeShader(godrays);
    }}, function(result) {
        godrays.data.Weight.value = [result];
    });
}