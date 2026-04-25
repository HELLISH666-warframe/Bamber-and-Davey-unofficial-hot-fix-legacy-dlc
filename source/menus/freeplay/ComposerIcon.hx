import funkin.backend.scripting.events.DrawEvent;
import flixel.group.FlxTypedGroup;
import flixel.FlxState;

class ComposerIcon {
    public var x = 0;
	public var y = 0;
    public var icon1:FlxSprite;
    public var icon2:FlxSprite;
    public var icon3:FlxSprite;
    public var siloSprite:FlxSprite;
    public var siloname:String = "missing";
    public function new(xPos,yPos,silo) {
        siloname=silo;
        for (z in silo.split(",")){
            icon1 = new FlxSprite(xPos,yPos).loadGraphic(doesIconExist(z));

            icon1.scale.set(0.6,0.6);
            icon1.updateHitbox();
        }
    }
    public function update(elapsed:Float){
        icon1.setPosition(x,y);
    }
    
    override public function destroy() {
        icon1.destroy();
	}
    function doesIconExist(name) {
	for (cate in ['devs', 'contributors', 'specialthanks']) {
		if (Assets.exists(Paths.image('credits/'+cate+'/'+name.toLowerCase()))) {
			iconpath= Paths.image('credits/'+cate+'/'+name.toLowerCase());
            break;
		}
	}
	return iconpath;
}
}