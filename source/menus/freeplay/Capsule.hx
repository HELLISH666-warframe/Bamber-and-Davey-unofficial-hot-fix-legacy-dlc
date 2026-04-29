class Capsule extends FlxSprite {
	public var text:Dynamic;
	public var silhouette:Dynamic;
	public var icon:Dynamic;
	public var newTag:Dynamic;
	public var updatedTag:Dynamic;
	public var vipTag:Dynamic;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		text.update(elapsed);
		silhouette.update(elapsed);
		silhouette.setPosition(text.x+text.width-440,text.y-160);
		icon.update(elapsed);
		//Tags.
		if(vipTag!=null){
		vipTag.update(elapsed);
		vipTag.setPosition(silhouette.x+(silhouette.width -vipTag.width) / 2+20,silhouette.y+30);
		}
		if(updatedTag!=null){
		updatedTag.update(elapsed);
		updatedTag.setPosition(silhouette.x-updatedTag.width+70,text.y+70);
		}
		if(newTag!=null){
		newTag.update(elapsed);
		newTag.setPosition(silhouette.x+40,text.y-80);
		}
	}
	override public function draw() {
		silhouette.draw();
		if(newTag!=null)newTag.draw();
		if(updatedTag!=null)updatedTag.draw();
		icon.draw();
		text.draw();
		if(vipTag!=null)vipTag.draw();
	}
	override public function destroy() {
		silhouette.destroy();
		text.destroy();
		icon.destroy();
		if(newTag!=null)newTag.destroy();
		if(vipTag!=null)vipTag.destroy();
		if(updatedTag!=null)updatedTag.destroy();
	}
}