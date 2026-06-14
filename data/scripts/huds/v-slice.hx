import flixel.util.FlxStringUtil;
//21,71.
var old=[FlxG.save.data.options.timeBar,FlxG.save.data.options.coloredBar];
function new() {
	//FlxG.save.data.options.timeBar=FlxG.save.data.options.coloredBar=false; 
	savetheshit();
}
function postCreate() {
	comboGroup.setPosition(560, 290);
	comboGroup.cameras = [camHUD];
	updateCurStyle('v-slice');
	accuracyTxt.kill();
    missesTxt.kill();
	//scripts.get('maskTimeBar').visible=false;
	trace(FlxG.save.data.options.timeBar);
}

function postUpdate(elapsed:Float) {
	scoreTxt.text = 'Score: ' + FlxStringUtil.formatMoney(songScore, false, true);
}

function onPlayerHit(e) {
	e.showSplash=false;
}

function onPostNoteHit(e) comboGroup.cameras = [camHUD];

function destroy() {
	FlxG.save.data.options.timeBar=old[0];
	FlxG.save.data.options.coloredBar=old[1];
}