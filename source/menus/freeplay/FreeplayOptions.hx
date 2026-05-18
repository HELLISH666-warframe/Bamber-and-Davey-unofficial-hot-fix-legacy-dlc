class FreeplayOptions extends FlxSprite {
	public var text:Dynamic;
	public var checkBox:Dynamic;
	public var text2:Dynamic;
	public var option:Dynamic;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		text.update(elapsed);
		//Options(visual).
		if(checkBox!=null){
		checkBox.update(elapsed);
		checkBox.setPosition(text.x+text.width+20,text.y-40);
		}
		if(text2!=null){
		text2.update(elapsed);
		text2.setPosition(text.x+text.width+20,text.y-5);
		}
	}
	override public function draw() {
		text.draw();
		if(checkBox!=null)checkBox.draw();
		if(text2!=null)text2.draw();
	}
	override public function destroy() {
		text.destroy();
		if(checkBox!=null)checkBox.destroy();
		if(text2!=null)text2.destroy();
	}
	public function change() {
		if(text2!=null){
			text2.scale.set(0.7,0.7);
			text2.text="<"+Reflect.field(FlxG.save.data.options, option)+">";
			laText = text2.members[text2.length - 1];
			text2.members[0].color=FlxColor.fromRGB(255, 100, 19);
		}
	}
}

//laText.members[0].color = laText.members[laText.text.length - 1].color = FlxColor.fromRGB(255, 100, 19);