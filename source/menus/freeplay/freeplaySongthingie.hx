import flixel.group.FlxTypedGroup;
import flixel.FlxState;

class FreeplaySongthingie extends FunkinSprite {
    public var siloname:String = "placeholder";
    public var theSiloGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    public function new(x, y, silo,?vip:Bool,?isnew:Bool,?updated:Bool) {
        super(x, y);
        siloname=silo;
        if (silo != null) loadGraphic(Paths.image("menus/freeplay/silhouettes/"+siloname));
        scale.set(0.7,0.7);
        if(vip){
            var vip = new FlxSprite(240,40).loadGraphic(Paths.image("menus/freeplay/tags/vip"));
            vip.scale.set(3,3);
			theSiloGroup.add(vip);
            trace(vip);
        }
		FlxG.state.add(theSiloGroup); 
    }

    override public function destroy() {
        theSiloGroup.destroy();
        super.destroy();
	}
}