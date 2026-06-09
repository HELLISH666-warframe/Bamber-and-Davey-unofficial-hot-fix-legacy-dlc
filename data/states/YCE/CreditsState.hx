import flixel.text.FlxTextBorderStyle;
import funkin.menus.ui.ClassicAlphabet;
import flixel.FlxCamera.FlxCameraFollowStyle;
var chars:Array/*<CreditChar>*/ = [];
var curSelectC:Int = 0;
var curSocial:Int = 0;
var camFollow:FlxSprite;
var socialThingy:FlxText;
function postCreate() {
    updateCurStyle('YCE');
    var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/menuBGYoshiCrafter'));
	bg.scrollFactor.set(0,0);
	bg.setGraphicSize(Std.int(bg.width * 1.1 / 0.75));
	bg.updateHitbox();
	bg.screenCenter();
	bg.antialiasing = true;
	add(bg);

    socialThingy = new FlxText(0, 0, 0, "< - >");
    socialThingy.setFormat(Paths.font("vcr.ttf"), Std.int(44), FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    socialThingy.antialiasing = true;
    add(socialThingy);

    camFollow = new FlxSprite(FlxG.width / 2, 0);
    FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.08);
    FlxG.camera.zoom = 0.75;

    var y = 0;

    //Json_shit.
    json = Json.parse(Assets.getText(Paths.json('config/credits')));

    y++;
    var modTitle = new Alphabet(0, 125 * y, 'Bamber & Davey Vol. 2.5', true, false);
    modTitle.x = (FlxG.width / 2) - (modTitle.width / 2);
    add(modTitle);
    y++;
    for (modMaker in json) {
        var modMakerAlphabet = new ClassicAlphabet(0, 125 * y, modMaker.name,true);
        modMakerAlphabet.x = -60;
        y++;
        add(modMakerAlphabet);

        var icon = new FlxSprite(modMakerAlphabet.x - 100, modMakerAlphabet.y + (modMakerAlphabet.height / 2) - (125 / 2));
        var iconPath = modMaker.icon;
        if (iconPath != null) {
            var tex = Paths.image(iconPath);
            if (tex != null) icon.loadGraphic(tex);
            else icon.loadGraphic(Paths.image('creditEmptyIcon', 'preload'));    
        } else icon.loadGraphic(Paths.image('creditEmptyIcon', 'preload'));

        icon.setGraphicSize(125, 125);
        icon.updateHitbox();
        var sc = Math.min(icon.scale.x, icon.scale.y);
        icon.scale.set(sc, sc);
        icon.antialiasing = true;
        add(icon);
        icon.x = modMakerAlphabet.x - 10 - icon.width;
        icon.y = (125 * y) - (125 / 2) - (icon.height / 2);

        var role = new FlxText(modMakerAlphabet.x, modMakerAlphabet.y + 110, Std.int(FlxG.width - modMakerAlphabet.x - 20), modMaker.role);
        role.setFormat(Paths.font("vcr.ttf"), Std.int(22), FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        role.antialiasing = true;
        add(role);
        chars.push({
            nameAlphabet: modMakerAlphabet,
            icon: icon,
            role: role,
            json: modMaker
        });
    }
    changeSelection(0);
}

function changeSelection(a:Int = 0) {
    var oldSocial = "";
    /*try {
    oldSocial = chars[curSelectC].json.urls[curSocial].name;
    } catch(e) {}*/
    
    curSelectC = FlxMath.wrap(curSelectC + a, 0, chars.length-1);

    for(i in 0...chars.length) {
        var e = chars[i];
        e.icon.alpha = (i == curSelectC) ? 1 : 0.4;
        e.role.alpha = (i == curSelectC) ? 1 : 0.4;
        e.nameAlphabet.alpha = (i == curSelectC) ? 1 : 0.4;
        if (i == curSelectC) camFollow.y = e.nameAlphabet.y + (e.nameAlphabet.height / 2);
    }
    curSocial = 0;
    if (chars[curSelectC].json.urls != null) {
        for(i in 0...chars[curSelectC].json.urls.length) {
            if (chars[curSelectC].json.urls[i].name.toLowerCase() == oldSocial.toLowerCase()) {
                curSocial = i;
                break;
            }
        }
    }
    CoolUtil.playMenuSFX('scroll', getVolume(1, 'sfx'));
    changeSocial(0);
}

function changeSocial(e:Int = 0) {
    var exists = chars[curSelectC].json.urls != null;
    if (exists) exists = exists && (chars[curSelectC].json.urls.length != 0);

    if (exists) {
        curSocial = FlxMath.wrap(curSocial + e, 0, chars[curSelectC].json.urls.length-1);

        var social = chars[curSelectC].json.urls[curSocial].name;
        socialThingy.text = '< $social >';
        socialThingy.x = FlxG.width + ((FlxG.width / 0.75 - FlxG.width) / 2) - 25 - socialThingy.width;
        socialThingy.y = chars[curSelectC].nameAlphabet.y + (chars[curSelectC].nameAlphabet.height / 2);
    } else socialThingy.text = "";
}

function update(elapsed:Float) {
    if (controls.UP_P||controls.DOWN_P) changeSelection(controls.UP_P?-1:1);
    if (controls.ACCEPT) CoolUtil.openURL(chars[curSelectC].json.urls[curSocial].url);
    if (controls.LEFT_P||controls.RIGHT_P) changeSocial(controls.LEFT_P?-1:1);
    if (controls.BACK) {
        CoolUtil.playMenuSFX(2, getVolume(1, 'sfx'));
        FlxG.switchState(new ModState("BND/BNDMenu"));
    }
}