import funkin.backend.system.framerate.Framerate;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.system.System;

public static var customText:TextField; // VECHETT WORKED OUT ALL THE CUSTOM FPS SHIT I JUST ADJUSTED/RECODED IT
public static var customSubText:TextField;
var customFormat:TextFormat = new TextFormat(Paths.getFontName(Paths.font('vcr.ttf')), 15, FlxColor.WHITE);

function new() {
    // custom fps shit
	Main.instance.addChild(customText = new TextField()).defaultTextFormat = customFormat;
	Main.instance.addChild(customSubText = new TextField()).defaultTextFormat = customFormat;
	customSubText.text = "\n\n"+Flags.VERSION_MESSAGE;
	customSubText.width = customSubText.textWidth + 10;
	customSubText.alpha = 0.3;
	customText.x = customText.y = customSubText.x = customSubText.y = 5;
	Options.fpsCounter = true;
    updateCurStyle('Default');
}
var dAlpha:Float = 0;
function update() {
    if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.H)updateCurStyle('Psych');
    if(curStyle=='CNE')return;
    customText.x=10+Framerate.offset.x;
    dAlpha=CoolUtil.fpsLerp(dAlpha, Framerate.debugMode > 0 ? 1 : 0, 0.5);
    customText.x=customSubText.x = FlxMath.lerp(-customText.width - 30, 0, dAlpha);
    switch (curStyle) {
        default:customText.text = "FPS: " + Framerate.fpsCounter.fpsNum.text + "\nMEM: " + Framerate.memoryCounter.memoryText.text + Framerate.memoryCounter.memoryPeakText.text;
        customText.width = customText.textWidth;
        case 'Psych':customText.text = "FPS: " + Framerate.fpsCounter.fpsNum.text + "\nMemory: "+StringTools.replace(CoolUtil.getSizeString(Framerate.memoryCounter.memory),'MB', ' MB');
        customText.textColor = 0xFFFFFFFF;
        if (/*memoryMegas > 3000 || */Framerate.fpsCounter.lastFPS <= FlxG.drawFramerate / 2) customText.textColor = 0xFFFF0000;
        customText.width = customText.textWidth;
        case 'YCE':customText.text = "FPS: " + Framerate.fpsCounter.fpsNum.text+ 
        "\nMemory: "+StringTools.replace(CoolUtil.getSizeString(Framerate.memoryCounter.memory),'MB')+" MB\nMem Peak: "+StringTools.replace(CoolUtil.getSizeString(Framerate.memoryCounter.memoryPeak),'MB', ' MB');
        customText.width = customText.textWidth;
    }
}
function preStateSwitch() {
    updateCurStyle('Default');
    changeFpsFont('vcr.ttf');
}
public static var curStyle = "Default";
public static var curStyle_2;
public static function updateCurStyle(e){
    if(e==curStyle_2)return;
    trace("Is_doings_fps_shits.");
    for(i in [Framerate.codenameBuildField,Framerate.memoryCounter.memoryText,Framerate.memoryCounter.memoryPeakText,Framerate.fpsCounter.fpsNum])
        if(i!=null) i.visible = Framerate.fpsCounter.fpsLabel.visible = false;
    customText.textColor = 0xFFFFFFFF;
    customSubText.visible=false;
	curStyle = e;
	switch (curStyle) {
		case 'CNE':
        Framerate.codenameBuildField.visible = Framerate.memoryCounter.memoryText.visible = Framerate.memoryCounter.memoryPeakText.visible = Framerate.fpsCounter.fpsNum.visible = Framerate.fpsCounter.fpsLabel.visible = true;
        Framerate.codenameBuildField.text = 'Codename Engine ';
        customText.visible=customSubText.visible=false;
        case 'Psych':/*changeFpsFont('_sans.ttf');
        Framerate.codenameBuildField.visible = Framerate.memoryCounter.memoryText.visible = Framerate.memoryCounter.memoryPeakText.visible = Framerate.fpsCounter.fpsNum.visible = Framerate.fpsCounter.fpsLabel.visible = true;*/
        customText.defaultTextFormat=customSubText.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('_sans.ttf')));
        default:customSubText.visible=true;
        customText.defaultTextFormat = customSubText.defaultTextFormat = customFormat;
    }
    curStyle_2=e;
}

public static function changeFpsFont(theFuckingFont:String,?size:Float=15) {
    for(i in [/*Framerate.fpsCounter.fpsNum,Framerate.fpsCounter.fpsLabel,Framerate.memoryCounter.memoryText,
    Framerate.memoryCounter.memoryPeakText,Framerate.codenameBuildField,*/customText,customSubText])
    if(i!=null)
    i.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font(theFuckingFont)),size);
}

function destroy(){
    updateCurStyle('CNE');
    Main.instance.removeChild(customText);
    Main.instance.removeChild(customSubText);
    changeFpsFont(Framerate.fontName);
}