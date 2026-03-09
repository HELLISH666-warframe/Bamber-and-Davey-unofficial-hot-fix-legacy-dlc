/*import flixel.input.keyboard.FlxKey;

var stuffs:Array<FunkinText> = [];
var stuffs2:Array<FunkinText> = [];

var keys:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'RESET', 'ACCEPT', 'BACK', 'SWITCHMOD','Volume up'];

var cur:Int = 0;
var selectBar:FlxSprite;

var currentlyRebinding:FunkinText;

function create() {
    FlxG.cameras.add(controlsCam = new FlxCamera(), false);
    controlsCam.bgColor = FlxColor.TRANSPARENT;
    add(new FunkinText(0, 48, 0, "-------- KEYBINDS --------", 48, false)).screenCenter(FlxAxes.X);
    add(selectBar = new FlxSprite(120).makeSolid(1, 70)).scale.x = (16.2 * 64) + 2;
    selectBar.screenCenter(FlxAxes.X);

    for(a in 0...7) {
        stuffs.push(new FunkinText(128, 125 + (70 * (a * 1.125)), 0, ["Left Key", "Down Key", "Up Key", "Right Key", "Accept", "Back", "Secret Thing"][a], 64, false));
        add(stuffs[a]);
        stuffs2.push(new FunkinText(0, stuffs[a].y, 0, CoolUtil.keyToString(Reflect.field(Options, 'P1_' + keys[a])[0]), 64, false));
        add(stuffs2[a]).x = FlxG.width - 128 - stuffs2[a].width;
        stuffs[a].antialiasing = stuffs2[a].antialiasing = Options.antialiasing;
    }

    changeSelect(0);
}

function postCreate() {
    controls.ACCEPT = false;
}

var skipFrame:Bool = false;

function postUpdate(elapsed:Float) {
	if((controls.UP_P || controls.DOWN_P) && currentlyRebinding == null)
		changeSelect(controls.UP_P ? -1 : 1);

    if (controls.BACK && currentlyRebinding == null) {
        close();
    }

    if (controls.ACCEPT && currentlyRebinding == null) {
        currentlyRebinding = stuffs2[cur];
        skipFrame = true;
    }

    if(FlxG.keys.justPressed.ANY && currentlyRebinding != null && !skipFrame) {
            var keyToSet:String = CoolUtil.keyToString(FlxG.keys.firstJustPressed());
            if (!checkifbound(keyToSet)) {
                currentlyRebinding.text = keyToSet;
                currentlyRebinding.visible = true;
                currentlyRebinding.x = FlxG.width - 128 - currentlyRebinding.width;
                currentlyRebinding = null;
                for (a in ['P1_', 'P1_NOTE_', 'P2_NOTE_']) Reflect.setField(Options, a + keys[cur], [FlxG.keys.firstJustPressed()]);
                Options.applyKeybinds();
                Options.save();
        }
    }
    skipFrame = false;
}

function stepHit()
    if (currentlyRebinding != null)
        currentlyRebinding.visible = !currentlyRebinding.visible;

function changeSelect(a:Int) {
    if(a != 0) CoolUtil.playMenuSFX();
    stuffs[cur].color = stuffs2[cur].color = FlxColor.WHITE;
    cur = FlxMath.wrap(cur + a, 0, stuffs.length - 1);
    stuffs[cur].color = stuffs2[cur].color = 0xff141378;
    selectBar.y = stuffs[cur].y - 3;
}

function checkifbound(_:String):Bool {
    for (z in 0...7) {
        trace(stuffs2[z].text);
        trace(_);
        if (stuffs2[z].text == _ && z != cur) 
            return true;
    }
    return false;
}

function destroy() {
    FlxG.cameras.remove(controlsCam);
}*/

//FREE_ME_FROM_THIS_HELL.
import funkin.editors.ui.UISliceSprite;
import funkin.options.Options;
import hxvlc.flixel.FlxVideoSprite;
import flixel.group.FlxTypedSpriteGroup;
import funkin.menus.ui.ClassicAlphabet;
import funkin.backend.utils.WindowUtils;
import flixel.FlxCamera;
import StringTools;

// OPTIONS file, in a different script to be cleaner ig
importScript("data/states/BND/BNDSettings-Options");
// bg stuff, not used later
// stuff you can't interact with

// menu shiz
var buttons = new FlxTypedGroup();
var daOptions = new FlxTypedGroup();
var daParams = new FlxTypedGroup();
var daCheckboxes = new FlxTypedGroup();
// curselects
var curSelect:Int = 0;
var curParam:Int = 0;

function create() {
    // the menu	
    for(num => b in [
        buttons,
        new FlxSprite(FlxG.width/3 * 2.6).loadGraphic(Paths.image('menus/options/scrollbarBG')).screenCenter(FlxAxes.Y),
        daOptions,
        daParams,
        daCheckboxes,
    ]){
        add(b);
        //if(num != 0 || num != 2) b.antialiasing = Options.antialiasing;
    }
}

function update(){
}

function regenMenu(){
    for(z in [daParams, daOptions, daCheckboxes]) z.clear();
    for(num => a in controlsOptions[0]){

        //trace("Name: " + b[0] + " | Desc: " + b[1], " | Params: " + b[2]);
        daOptions.add(new ClassicAlphabet(25, (90 * num), a[0], true));
        daOptions.members[num].color = (StringTools.startsWith(daOptions.members[num].text, "Reset") ? FlxColor.fromRGB(225, 225/7.5, 225/7.5) : FlxColor.WHITE);
        if(a[2].length != 0){
            daParams.add(new ClassicAlphabet(0, (90 * num), (a[2].length != 1 ? "<" + (a[2][a[2].indexOf(Reflect.field(FlxG.save.data.options, a[3]))]) + ">" : a[2][0]), true));
            laText = daParams.members[daParams.length - 1];
            //trace(laText.text);
        } else {
            var checkbox = new FlxSprite(0, 90 * num);
            checkbox.frames = Paths.getSparrowAtlas("menus/options/checkbox");
            checkbox.animation.addByPrefix("ya", "Checkbox", 24, false);
            checkbox.animation.addByIndices("nah", "Checkbox", [9,8,7,6,5,4,3,2,1,0], '',24, false);
            checkbox.ID=a[1*num];//Make this fucking ID thing match the cur savedata thing , AHHHHH-
            //trace(checkbox.ID);

            daCheckboxes.add(checkbox);
            daCheckboxes.members[daCheckboxes.length - 1].animation.play("ya", true, !Reflect.field(FlxG.save.data.options, a[3]), !Reflect.field(FlxG.save.data.options, a[3]) ? 24 : 0);
        }
    }
}

function destroy(){
    
}