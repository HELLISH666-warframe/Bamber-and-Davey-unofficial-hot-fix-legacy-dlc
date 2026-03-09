import funkin.backend.utils.AudioAnalyzer;
//Wave_form_stuff_coming_once_i_figure_HOW_they_work.

import lime.media.AudioBuffer;

var instBuffer = AudioBuffer.fromFile(Assets.getPath(Paths.inst(PlayState.SONG.meta.displayName, PlayState.difficulty)));
import yoshi.WaveformSprite;
var waveformI = new WaveformSprite(-1200, 750, instBuffer, 300, 150);

var voiceBuffer = AudioBuffer.fromFile(Assets.getPath(Paths.voices(PlayState.SONG.meta.displayName, PlayState.difficulty)));
var waveformV = new WaveformSprite(-1200, 1150, voiceBuffer, 300, 75);

var fisheye = new CustomShader('fisheye');

function create() {
	FlxG.camera.addShader(fisheye);
	fisheye.MAX_POWER = .15;

	for (i in members) 
		if (i != null && Std.isOfType(i, Character)) {
			i.colorTransform.redMultiplier = 0.65*0.8;
			i.colorTransform.greenMultiplier = 0.4*0.8;
			i.colorTransform.blueMultiplier = 0.8;
			i.colorTransform.blueOffset -= 10;
	}
	waveformI.scrollFactor.set(0.65, 0.65);
	waveformI.color = 0x55FF0000;
	waveformI.origin.set();
	waveformI.scale.set(2.5, 40);

	waveformV.scrollFactor.set(0.9, 0.9);
	waveformV.color = 0x55FF00FF;
	waveformV.origin.set();
	waveformV.scale.set(2.5, 40);
	
	insert(3, waveformI);
	insert(8, waveformV);

	waveformI.antialiasing = waveformV.antialiasing = false;
	waveformI.angle = waveformV.angle = 270;
	waveformI.alpha = waveformV.alpha = 0.4;
	waveformI.blend = waveformV.blend = 0;
}
var fisheyePower:Float = 0.15;

function update() {
	fisheyePower = FlxMath.lerp(fisheyePower, 0.15, 0.07);
	fisheye.MAX_POWER = fisheyePower;

	waveformI.generateFlixel(Conductor.songPosition, Conductor.songPosition + 200);
	waveformV.generateFlixel(Conductor.songPosition - 200, Conductor.songPosition);

	if (vocals != null) waveformV.scale.y = 40 * vocals.volume;
}