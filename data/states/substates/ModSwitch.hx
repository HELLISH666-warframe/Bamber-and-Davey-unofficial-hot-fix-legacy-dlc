import funkin.backend.assets.ModsFolder;

var mods:Array<String> = ModsFolder.getModsList();
var alphabets = new FlxTypedGroup<Alphabet>();
var curSelected_ms:Int = 0;

var subCam:FlxCamera;

function create() {
	camera = subCam = new FlxCamera();
	subCam.bgColor = 0;
	FlxG.cameras.add(subCam, false);

	var bg = new FlxSprite(0, 0).makeSolid(FlxG.width, FlxG.height, 0xFF000000);
	bg.updateHitbox();
	bg.scrollFactor.set();
	add(bg).alpha = 0;
	FlxTween.tween(bg, {alpha: 0.5}, 0.25, {ease: FlxEase.cubeOut});

	mods.push(null);
	CoolUtil.sortAlphabetically(mods,true);//Only_windows_orders_it_alphabeticalrdyl_by_default.

	for(mod in mods) {
		var a = new Alphabet(0, 0, mod ==null ?"disableMods": mod, "bold");
		if(mod == ModsFolder.currentModFolder) a.color = FlxColor.LIME;
		a.isMenuItem = true;
		a.scrollFactor.set();
		alphabets.add(a);
	}
	add(alphabets);
	changeSelection(0, true);
}
function update(elapsed:Float) {
	changeSelection((controls.DOWN_P ? 1 : 0) + (controls.UP_P ? -1 : 0) - FlxG.mouse.wheel);

	if (controls.ACCEPT) {
		ModsFolder.switchMod(mods[curSelected_ms]);
		close();
	}

	if (controls.BACK) close();
}

function changeSelection(change:Int, force:Bool = false) {
	if (change == 0 && !force) return;

	curSelected_ms = FlxMath.wrap(curSelected_ms + change, 0, alphabets.length-1);

	CoolUtil.playMenuSFX('scroll', getVolume(0.7, 'sfx'));

	for(k=>alphabet in alphabets.members) {
		k==curSelected_ms?alphabet.alpha =1:alphabet.alpha =0.6;
		alphabet.targetY = k - curSelected_ms;
	}
}

function destroy() if (FlxG.cameras.list.contains(subCam)) FlxG.cameras.remove(subCam);