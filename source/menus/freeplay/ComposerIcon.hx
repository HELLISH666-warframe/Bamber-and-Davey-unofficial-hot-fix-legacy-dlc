import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxState;

class ComposerIcon extends FlxSprite
{
    public var lines:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    public var sinOffset:Float = 10; 
    
    public var iconName:String = "missing";
    public function new(?x:Float = 0.0, ?y:Float = 0.0, ?dehGraphic,shit) {
        super(x, y, dehGraphic);
        iconName=shit;

        super.graphicLoaded();
		lines.clear(); 
        //if (graphic == null || graphic.height == 0) return;
        for (i in 0...iconName.split(",").length) {
			var spr = new FlxSprite();
            spr.loadGraphic(doesIconExist(iconName.split(",")[i])); 
            if(iconName.split(",").length>1)spr.setGraphicSize(90,90);
			lines.add(spr);
		}
        switch (iconName.split(",").length){
            case 1:lines.members[0].setPosition(x,10);
            case 2:lines.members[0].setPosition(x-30,-10);
            lines.members[1].setPosition(x+50,40);
            case 3:lines.members[0].setPosition(x-30,-30);
            lines.members[1].setPosition(x+50,50);
            lines.members[2].setPosition(x-30,60);
        }
    }
	
    override public function destroy() {
        lines.destroy();
        super.destroy();
	}
	
	public function update(elapsed:Float)
	{
        for (i=>spr in lines.members) {
            spr.alpha = alpha;
            spr.visible = visible;
            spr.cameras = cameras;
            spr.color = color;
            /*spr.x = x;
            spr.y = y + i;*/
			//spr.offset.x = offset.x + (Math.sin((FlxG.game.ticks + (100 * i)) / 500) * sinOffset);
            spr.offset.y = offset.y;
		}
	}
	override public function updateHitbox() {
        super.updateHitbox(); 
        lines.forEach(function(spr:FlxSprite) {
            spr.updateHitbox();
        });
	}
    function doesIconExist(name) {
	for (cate in ['devs', 'contributors', 'specialthanks']) {
		if (Assets.exists(Paths.image('credits/'+cate+'/'+name.toLowerCase()))) {
			iconpath= Paths.image('credits/'+cate+'/'+name.toLowerCase());
            break;
		}
        else{
            iconpath= Paths.image('credits/missing');
        }
	}
	return iconpath;
}
}
