//import Medals.MedalsJSON;
import MedalsJSON;
import medal.MedalSprite;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
//import flixel.addons.ui.FlxUIText;
import flixel.math.FlxMath;
import haxe.Json;
import openfl.utils.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

var bg:FlxSprite;
var medals:MedalsJSON = Json.parse(Assets.getText(Paths.file("data/config/medals.json")));
var sprites= new FlxTypedSpriteGroup();
var curSelected:Int = 0;
var unlockedMedals:Int = 0;
//var desc:FlxUIText;
var desc:FlxText;
var unlockedCaption:AlphabetOptimized;

final multiple = 1;

function create() {
    bg = new FlxSprite(0,0).loadGraphic(Paths.image('menus/menuBGYoshiCrafter_'));
	bg.setGraphicSize(Std.int(bg.width * 1.1));
	bg.screenCenter();
	bg.antialiasing = true;
	add(bg);
    bg.scrollFactor.set();
    if (medals.medals == null) medals.medals = [];
    for(k=>e in medals.medals) {
        var mSprite = new MedalSprite(e);
        mSprite.y = ((Math.floor(k / multiple)) * 125) + 25;
        //mSprite.title.outline = true;
        sprites.add(mSprite.title);
        sprites.add(mSprite.img);
        if (!mSprite.locked) unlockedMedals++;
    }
    add(sprites);

    var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, 80, 0x88000000, true);
    add(bg);
        
    var title = new Alphabet(FlxG.width / 2, 17.5, "Medals", true, 0.75);
    title.scale.set(0.8,0.8);
    title.x -= title.width / 2;
    add(title);

    unlockedCaption = new Alphabet(FlxG.width - 180, 20, unlockedMedals+'/'+medals.medals.length, false, 0.5);
    unlockedCaption.scale.set(0.7,0.7);
    //unlockedCaption.outline = true;
    add(unlockedCaption);

    //desc = new FlxUIText(0, FlxG.height * 0.9, "");
    desc = new FlxText(0, FlxG.height * 0.9, "");
    desc.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    desc.antialiasing = true;
    add(desc);

    bg.scrollFactor.set();
    title.scrollFactor.set();
    unlockedCaption.scrollFactor.set();
    desc.scrollFactor.set();
}
public static function getLerpRatio(t:Float) {
	return FlxMath.bound(t * 60 * FlxG.elapsed, 0, 1);
}
function update(elapsed:Float) {
    if (controls.BACK) FlxG.switchState(new MainMenuState());

    var oldSelected = curSelected;
    if (controls.RIGHT_P) curSelected++;
    if (controls.LEFT_P) curSelected--;
    if (controls.DOWN_P) curSelected += multiple;
    if (controls.UP_P) curSelected -= multiple;
    curSelected = FlxMath.wrap(curSelected, 0, sprites.length);
    if (curSelected != oldSelected) {
        CoolUtil.playMenuSFX(0);
        desc.alpha = 0;
        desc.offset.y = 25;
    }
    var descLerpRatio = getLerpRatio(0.25);

    desc.offset.y = FlxMath.lerp(desc.offset.y, 0, descLerpRatio);
    desc.alpha = FlxMath.lerp(desc.alpha, 1, descLerpRatio);

    var l = elapsed * 0.25 * 60;

    sprites.y = FlxMath.lerp(sprites.y, -125 * (Math.floor(curSelected / multiple) + 0.5) + (FlxG.height / 2), l);

    for(k=>e in sprites.members) {
        e.alpha = FlxMath.lerp(e.alpha, (k == curSelected) ? 1 : 0.3, l);
        if (k == curSelected) {
            desc.text = medals.medals[k].desc;
            /*desc.x = e.img.x + e.img.width + 5;
            desc.y = e.img.y + (e.img.height * 0.5) + 5;
        */}
        //e.title.offset.y = FlxMath.lerp(e.title.offset.y, (k == curSelected) ? e.title.height / 2 + 10 : 0, descLerpRatio);
        e.x = (1 - (1 - Math.pow(Math.sin(FlxMath.bound((e.y + (e.height / 2)) / FlxG.height * Math.PI, 0, Math.PI)), 1.5))) * 75;
    }
    unlockedCaption.x = FlxG.width - 10 - unlockedCaption.width;
}