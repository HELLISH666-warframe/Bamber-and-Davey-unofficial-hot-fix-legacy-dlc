import funkin.backend.system.framerate.Framerate;
import openfl.text.TextFormat;
import openfl.text.TextField;

public static var customText:TextField; // VECHETT WORKED OUT ALL THE CUSTOM FPS SHIT I JUST ADJUSTED/RECODED IT
public static var customSubText:TextField;
var customFormat:TextFormat = new TextFormat(Paths.getFontName(Paths.font('vcr.ttf')), 15, FlxColor.WHITE);

function new() {
    // custom fps shit
	Main.instance.addChild(customText = new TextField()).defaultTextFormat = customFormat;
	Main.instance.addChild(customSubText = new TextField()).defaultTextFormat = customFormat;
	customSubText.text = "\n\nVs B&D Volume. 2.5";
	customSubText.width = customSubText.textWidth + 10;
	customSubText.alpha = 0.3;
	customText.x = customText.y = customSubText.x = customSubText.y = 5;
	Options.fpsCounter = true;
}
function update() {
    switch (curStyle) {
        default:customText.text = "FPS: " + Framerate.fpsCounter.fpsNum.text + "\nMEM: " + Framerate.memoryCounter.memoryText.text + Framerate.memoryCounter.memoryPeakText.text;
        customText.width = customText.textWidth;
    }
    if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.T) updateCurStyle('psych');
}
function preStateSwitch() {
    customText.defaultTextFormat = customSubText.defaultTextFormat = customFormat;
    Framerate.codenameBuildField.visible = Framerate.memoryCounter.memoryText.visible = Framerate.memoryCounter.memoryPeakText.visible = Framerate.fpsCounter.fpsNum.visible = Framerate.fpsCounter.fpsLabel.visible = false;
}
var fpsDiffTexts=[["FPS: ","\nMEM: "],//Default
    ["FPS: "+Framerate.fpsCounter.fpsNum.text,"\nMemory: "+Framerate.memoryCounter.memoryText.text," / Peak: "],//Psych
    ["FPS: ",""],//YCE
    []];
public static var curStyle = "default";
public static function updateCurStyle(e){
	curStyle = e;
	switch (curStyle) {
		case 'CNE':
        Framerate.codenameBuildField.visible = Framerate.memoryCounter.memoryText.visible = Framerate.memoryCounter.memoryPeakText.visible = Framerate.fpsCounter.fpsNum.visible = Framerate.fpsCounter.fpsLabel.visible = true;
        Framerate.codenameBuildField.text = 'Codename Engine ';
        Framerate.codenameBuildField.y = 42;
        FlxG.updateFramerate = FlxG.drawFramerate = Options.framerate;
        for (i in [Framerate.fpsCounter.fpsNum, Framerate.fpsCounter.fpsLabel, Framerate.codenameBuildField,Framerate.memoryCounter.memoryText,Framerate.memoryCounter.memoryPeakText]) {
            i.textColor = -1;
            i.visible = true;
            i.defaultTextFormat = new TextFormat(Framerate.fontName, i == Framerate.fpsCounter.fpsNum ? 18 : 12, -1);
            i.x = 0;
        }
        customText.visible=customSubText.visible=false;
        case 'psych':/*changeFpsFont('_sans.ttf');
        Framerate.codenameBuildField.visible = Framerate.memoryCounter.memoryText.visible = Framerate.memoryCounter.memoryPeakText.visible = Framerate.fpsCounter.fpsNum.visible = Framerate.fpsCounter.fpsLabel.visible = true;*/
        customText.defaultTextFormat=customSubText.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('_sans.ttf')));
    }
}

public static function changeFpsFont(theFuckingFont:String) {
    Framerate.fpsCounter.fpsNum.defaultTextFormat = Framerate.fpsCounter.fpsLabel.defaultTextFormat = Framerate.memoryCounter.memoryText.defaultTextFormat = Framerate.memoryCounter.memoryPeakText.defaultTextFormat = Framerate.codenameBuildField.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font(theFuckingFont)));
}

function destroy(){
    Framerate.codenameBuildField.visible = Framerate.memoryCounter.memoryText.visible = Framerate.memoryCounter.memoryPeakText.visible = Framerate.fpsCounter.fpsNum.visible = Framerate.fpsCounter.fpsLabel.visible = true;
    Main.instance.removeChild(customText);
    Main.instance.removeChild(customSubText);
    changeFpsFont(Framerate.fontName);
}