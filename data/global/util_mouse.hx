import Type;

var idleCursorGraphic;
var clickCursorGraphic;
public static var cursorName = 'default';
public var clickableObjects = [];
var isHovering = false;
var switched = false;

function destroy(){
    FlxG.mouse.useSystemCursor = true;
    FlxG.mouse.visible = false;
}

function postStateSwitch() {
    if(Type.getClassName(Type.getClass(FlxG.state)) != 'funkin.game.PlayState'){
        cursorName="default";
        clickCursorGraphic = Assets.getBitmapData(Paths.image('cursors/'+cursorName+'_waiting'));
    }
    idleCursorGraphic = Assets.getBitmapData(Paths.image('cursors/'+cursorName));
    FlxG.mouse.load(idleCursorGraphic,1,1,1);
}

function postUpdate(elapsed) {
    if (FlxG.mouse.visible) {
        isHovering = false;

        for (i in clickableObjects) {
            if (FlxG.mouse.overlaps(i)) {
                isHovering = true;
                break;
            }
        }

        if (isHovering && !switched) {
            FlxG.mouse.load(clickCursorGraphic,1,1,1);
            switched = true;
        } else if (!isHovering && switched) {
            FlxG.mouse.load(idleCursorGraphic,1,1,1);
            switched = false;
        }
    }
}

function preStateCreate() {
    clickableObjects = [];
    isHovering = switched = false;
}

function preStateSwitch() { //Switch to where it was meant to be
    FlxG.mouse.useSystemCursor = false;
}

function update(elapsed) {
    if (FlxG.keys.justPressed.ANY) {FlxG.mouse.visible = false;} //i wish there was a Controls version so that the gamepad is supported
    if (FlxG.mouse.justMoved || FlxG.mouse.justPressed || FlxG.mouse.justPressedMiddle ||FlxG.mouse.justPressedRight) {FlxG.mouse.visible = true;}
}

public static function pushToClickables(obj) {
    clickableObjects.push(obj);
    return;
}

public static function removeFromClickables(obj) {
    clickableObjects.remove(obj);
    return; //apparently returns are what makes global functions actually global, i think
}

public static function clearClickables() {
    clickableObjects = [];
    return;
}

public static function getClickables() {
    return clickableObjects;
}