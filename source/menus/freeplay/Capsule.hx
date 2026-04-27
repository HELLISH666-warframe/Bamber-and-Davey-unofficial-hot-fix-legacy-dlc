import flixel.group.FlxTypedGroup;
import flixel.FlxState;

class Capsule {
    public var x = 0;
	public var y = 0;
    public var siloSprite:FlxSprite;
    public var newTag:FlxSprite;
	public var vipTag:FlxSprite;
    public var updatedTag:FlxSprite;

    public var siloname:String = "placeholder";
    public var theSiloGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    public function new(xPos,yPos,silo,?vip:Bool,?isnew:Bool,?updated:Bool) {
        siloname=silo;
        siloSprite = new FlxSprite(xPos,yPos).loadGraphic(Paths.image('menus/freeplay/silhouettes/'+siloname));
		siloSprite.scale.set(0.6,0.6);
		siloSprite.updateHitbox();

        if(isnew){
        newTag = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/tags/new'));
		newTag.scale.set(0.4,0.4);
		newTag.updateHitbox();
        }
        if(vip){
        vipTag = new FlxSprite(siloSprite.x+siloSprite.width-350,siloSprite.y+siloSprite.height-400).loadGraphic(Paths.image('menus/freeplay/tags/vip'));
		vipTag.scale.set(0.5,0.5);
		vipTag.updateHitbox();
        }
        if(updated){
        updatedTag = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/tags/updated'));
		updatedTag.scale.set(0.4,0.4);
		updatedTag.updateHitbox();
        }
    }
    public function update(elapsed:Float){
        siloSprite.setPosition(x,y);
        newTag.setPosition(siloSprite.x+siloSprite.width-700,siloSprite.y+siloSprite.height-300);
        vipTag.setPosition(siloSprite.x+siloSprite.width-350,siloSprite.y+siloSprite.height-400);
        updatedTag.setPosition(siloSprite.x+siloSprite.width-700,siloSprite.y+siloSprite.height-200);
    }
    
    override public function destroy() {
        siloSprite.destroy();
        if(newTag!=null) newTag.destroy();
        if(vipTag!=null) vipTag.destroy();
        if(updatedTag!=null) updatedTag.destroy();
	}
}