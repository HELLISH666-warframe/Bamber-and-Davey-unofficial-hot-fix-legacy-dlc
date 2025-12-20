import funkin.backend.system.framerate.Framerate;
import openfl.text.TextFormat;
function create() {
	disclaimer.text="This is an *unofficial* hot-fix for #Bamber and Davey# that aims to fulfil what it was meant to release like with the planned legacy dlc included.\nPlease keep in mind this is still *unfinished*.";
}
function postCreate() {
	Framerate.fpsCounter.fpsNum.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('vcr.ttf')), 18, -1);
    Framerate.fpsCounter.fpsLabel.defaultTextFormat = Framerate.memoryCounter.memoryText.defaultTextFormat = Framerate.memoryCounter.memoryPeakText.defaultTextFormat = Framerate.codenameBuildField.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('vcr.ttf')), 12, -1);
}