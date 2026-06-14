import funkin.backend.chart.Chart;
import funkin.backend.utils.WindowUtils;
import flixel.text.FlxTextBorderStyle;
import menus.freeplay.Capsule;

var arrows:Array<FunkinSprite> = [];
var moveTimer:FlxTimer = new FlxTimer();
var appear = true;

var data = [ // Image, Title, [Song1, Song2, etc], color, font
	["BambersFarm","Week Bamber",['Yield','Cornaholic','Harvest'],0xB6FF00],//3
	["DaveysYard","Week Davey",['Synthwheel','Yard','Coop'],0x0066FF],//6
	["RomaniaOutskirts","Week Ronnie & Boris",['Ron Be Like','Bob Be Like','Fortnite Duos'],0xFED73E],//9
	["BonusWIP","Bonus Songs",['Mathemathon','Blusterous Day','Escape From Poland','Slammed','Swindled','Trade','Multiversus'],0x00FFA6],//16
	["Jokes","Joke Songs",['Generations','Memeing',"Judgement Farm","Judgement Farm 2",'Too Slop','Pibenis',"Yeld",'Squeaky Clean'],0x038703],//23
	["Collabs","Collab Songs",["Call Bamber","Deathbattle","H2O"],0xA5CEE3],//26
	["Crossovers","Crossover Songs",["Corn N Roll","Screencast"],0xFE3455],//28
	["Remixes","Remixes",['Spookeez','South','Pico','2Hot'],0xFF338A9C],//32
	["Legacy","Legacy/Old Content",['Yield V1','Cornaholic V1','Harvest V1','Yield Seezee Remix','Cornaholic Erect Remix V1','Harvest Chill Remix','Yield demo','Cornaholic demo','Harvest demo','Synthwheel demo','Yard demo','Best-Farmers-Forever','Coop Old','Fortnite Duos V1','Godzilla','Judgement Farm Old','Matemathon V1','Call Bamber Old','Harvest Vol2','Synthwheel Vol2','Coop Vol2','Bob be like Vol2','Swindled Vol2','Trade Vol2','Judgement Farm Vol2','Judgement Farm 2 Vol2','Placeholder Vol2'],0x16AD01],//59
	["PLACEHOLDER","REMOVE_LATER",['Astray','Facsimile','Placeholder','Test Footage'],0x000000,'vcr_osd.ttf'],//63
	['Favourites','Favourites',FlxG.save.data.freeplayShit.favourites,0xFE3455],
	/*["Baller", "Custom_content.", 0x16AD01]*/
];

var vinylGroup:FlxTypedGroup = new FlxTypedGroup();
static var curSelFP:Int = 0;
var songser = [];
var album;
var timer = 0;
var playall;
var scorText = new FlxText(24, 0);

subCurSelected = 0;

var capsules = new FlxTypedGroup();

//Test_score_shit.
var ratingsAndShit = new FlxText(500, 400,100,'FUCK',24);
var scoreBg = new FlxSprite(40,45).makeSolid(385, 350, FlxColor.BLACK);
function create() {
	if(!FlxG.save.data.gameStats.achievements.contains('pibby')) data[4][2].remove('Pibenis');
	if(!FlxG.save.data.gameStats.achievements.contains('sc')) data[4][2].remove('Squeaky Clean');
	if(!FlxG.save.data.gameStats.achievements.contains('nightmare')) data[8][2].remove('Placeholder Vol2');
	if(!FlxG.save.data.gameStats.achievements.contains('TF')) data[9][2].remove('Test Footage');
	add(backGround = new FunkinSprite().loadGraphic(Paths.image('menus/menuDesat'))).screenCenter();
	
	add(album = new FlxSprite(40,45).loadGraphic(Paths.image("menus/freeplay/albums/vol2.5"))).angle=-3;
	//Test_score_shit.
	add(scoreBg).alpha=0.01;
	add(ratingsAndShit);

	//Make this a whole FlxGroup that gets tweened on screen showing the songs statstitcs later.
	scorText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "right", FlxTextBorderStyle.SHADOW, 0xFF000000);
	scorText.text = "Stats(Wip)";
	scorText.shadowOffset.set(2, 2);
	add(scorText).angle=-3;
	
	add(capsules);
	playall = new FlxSprite().loadGraphic(Paths.image("menus/freeplay/silhouettes/playall"));
	playall.scale.set(0.33, 0.33);
	playall.x += 96;
	playall.y -= 116;
	add(playall);
	
	catName = new FlxText(FlxG.camera.width - 456, FlxG.camera.height - 672);
	catName.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "left", FlxTextBorderStyle.SHADOW, 0xFF000000);
	add(catName);
	
    for (id=>i in data) {
		cassetteImage= Assets.exists(Paths.image("menus/freeplay/cassettes/" + i[0]))? i[0]:'placeholder';
        var sprite = new FlxSprite(0, 300).loadGraphic(Paths.image("menus/freeplay/cassettes/"+cassetteImage));
		
        sprite.ID = id;
        sprite.scale.set(0.4, 0.4);
        vinylGroup.add(sprite);
    }
    add(vinylGroup);
	if(FlxG.sound.music!=null) FlxG.sound.music.fadeOut(2,0);
	//Why_:(
	
    for (a in 0...2) {
        arrows.push(new FunkinSprite(0, 525));
		arrows[a].scale.set(0.2, 0.2);
        arrows[a].frames = Paths.getSparrowAtlas("menus/freeplay/selectArrows");
        for(z in ["hit", "idle"]) {
			arrows[a].animation.addByPrefix(z, z + ["Left", "Right"][a], 4, false);
		}
        arrows[a].animation.play("idle");
        add(arrows[a]).antialiasing = Options.antialiasing;
		arrows[a].y -= 128;
		arrows[a].x = (a + 1) * 128 + a * 408;
    }
	
	change(0);
}
function update(elapsed) {
	timer += elapsed;
    if (controls.LEFT_P||controls.RIGHT_P) change(controls.LEFT_P ? -1 : 1);
	if (controls.UP_P||controls.DOWN_P||FlxG.mouse.wheel!=0) 
		changements((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);
	if (controls.BACK) FlxG.switchState(new ModState("BND/BNDMenu"));
	if (controls.ACCEPT) enterSong();

	if (FlxG.keys.justPressed.F) {//DOOKIE.
		FlxG.save.data.freeplayShit.favourites.contains(songser[subCurSelected].name)?
		FlxG.save.data.freeplayShit.favourites.remove(songser[subCurSelected].name):
		FlxG.save.data.freeplayShit.favourites.push(songser[subCurSelected].name);
		FlxG.save.flush();
	}

	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = !persistentDraw;
		import funkin.editors.EditorPicker;
		openSubState(new EditorPicker());
	}
	
    for (i in vinylGroup.members) i.x = lerp(i.x, -460 * (curSelFP - i.ID), 0.2);
	
	arrows[0].angle = Math.sin(timer * 3) * 5;
	for (i in capsules){
		i.text.targetY = i.text.ID - subCurSelected;
		var scaledY = FlxMath.remapToRange(i.text.targetY, 0, 1, 0, 1.3);
		i.text.y = CoolUtil.fpsLerp(i.text.y, (scaledY * 250) + (FlxG.height * 0.37), 0.16);
	}
	for (i in 0...capsules.members.length) {
		capsules.members[i].text.x=CoolUtil.fpsLerp(capsules.members[i].text.x,switch(subCurSelected-i){
			case 0:targetX = 1240; case -1:targetX = 1350 ;default:targetX = 2700;
		}-capsules.members[i].text.width, switch(subCurSelected-i){
			case 0|-1:0.16; default:0.06;
		});
	}
	capsules.forEach(function (silo) {
        if (FlxG.mouse.overlaps(silo.text) && FlxG.mouse.justPressed) if (silo.text.ID != subCurSelected) {
			subCurSelected = silo.text.ID;
			changements(0,true);
		} else enterSong();
		if (FlxG.mouse.overlaps(silo.text)||silo.text.ID==subCurSelected) silo.text.alpha=1;
		else {silo.text.alpha=silo.icon.alpha=0.5;
		}
    });

	if (FlxG.mouse.overlaps(scorText) && FlxG.mouse.pressed){
		FlxG.save.data.Bamber_SONGSONG = songser[subCurSelected];
		persistentUpdate = !persistentDraw;
		openSubState(new ModSubState("substates/stats-test"));
	}
	if (FlxG.keys.justPressed.J) {
		showScore();
	}
}
var showingSc=false;
function showScore() {
	FlxTween.cancelTweensOf(album, ['color','angle']);
	FlxTween.cancelTweensOf(scoreBg, ['scale']);
	if(!showingSc){
		FlxTween.color(album, 0.2, album.color, 0xFF000000, {ease: FlxEase.circOut});
		FlxTween.tween(album, {angle: 0}, 0.2, {ease: FlxEase.circOut});
		FlxTween.tween(scoreBg.scale, {y: 600}, 0.4, {ease: FlxEase.circOut,
			onUpdate: function(twn:FlxTween){scoreBg.updateHitbox();}});
	} else {
		FlxTween.color(album, 0.2, album.color, 0xFFFFFFFF, {ease: FlxEase.circOut});
		FlxTween.tween(album, {angle: -3}, 0.2, {ease: FlxEase.circOut});
		FlxTween.tween(scoreBg.scale, {y: 350}, 0.4, {ease: FlxEase.circOut,
			onUpdate: function(twn:FlxTween){scoreBg.updateHitbox();}});
	}
	showingSc=!showingSc;
}
function postUpdate(elapsed) {
	if(scoreBg==null)return;
	scoreBg.alpha=CoolUtil.fpsLerp(scoreBg.alpha, showingSc?0.8:0.01, 0.16);
}
function changements(a,?sound) {
	subCurSelected = FlxMath.wrap(subCurSelected + a, 0, data[curSelFP][2].length - 1);
	catName.font=Paths.font(songser[subCurSelected].freeplayShit.font==null?"vcr.ttf":songser[subCurSelected].freeplayShit.font);
	var ver = songser[subCurSelected].freeplayShit.album==null?1:songser[subCurSelected].freeplayShit.album;
	
	album.loadGraphic(Paths.image("menus/freeplay/albums/vol"+ver));
	WindowUtils.set_suffix(" | Currently Selecting: "+songser[subCurSelected].displayName);

	if (a == 0 && !sound) return; CoolUtil.playMenuSFX('scroll', getVolume(1, 'sfx'));
}

function change(a) {
	mult=1;
	if(FlxG.save.data.freeplayShit.favourites.length==0)mult=curSelFP==10?1:2;
    curSelFP = FlxMath.wrap(curSelFP + a, 0, vinylGroup.length - mult);
	
	moveTimer.cancel();
	
	if (!appear) {
		appear = true;
		FlxG.sound.play(Paths.sound("menu/freeplay/cassetteAppear"), getVolume(1, 'sfx'));
	}

	songser = [];
	for(s in data[curSelFP][2]) songser.push(Chart.loadChartMeta(s, "normal", true));
	
	for (i in vinylGroup.members) {
		var relSel = Math.abs(curSelFP - i.ID);
		var targetNumber = curSelFP == i.ID ? 190 : 300;
		FlxTween.globalManager.cancelTweensOf(i);
		FlxTween.tween(i, {y: targetNumber + relSel * 50}, 0.4, {ease: FlxEase.quartOut});
	}
		
	if (a == 0) {
		appear = false;
		for (i in vinylGroup.members) {
			FlxTween.globalManager.completeTweensOf(i);
			new FlxTimer().start(0.06, ()->{i.y += 128;});
			i.x = -460 * (curSelFP - i.ID);
		}
	}
	else
	{
		arrows[FlxMath.bound(a, 0, 1)].animation.play("hit");
		FlxTween.globalManager.cancelTweensOf(arrows[FlxMath.bound(a, 0, 1)]);
		arrows[FlxMath.bound(a, 0, 1)].scale.set(0.1, 0.2);
		FlxTween.tween(arrows[FlxMath.bound(a, 0, 1)].scale, {x: 0.25, y: 0.25}, 0.5, {ease: FlxEase.circOut});
		
		FlxG.sound.play(Paths.sound("menu/freeplay/cassetteScroll"), getVolume(1, 'sfx'));
		moveTimer = new FlxTimer().start(0.7, ()->{
			appear = false;
			FlxG.sound.play(Paths.sound("menu/freeplay/cassetteDisappear"), getVolume(1, 'sfx'));
			for (i in vinylGroup.members)
				FlxTween.tween(i, {y: i.y + 128}, 0.5, {ease: FlxEase.quartOut});
		});	
	}
	
	capsules.clear();
	for (i in 0...data[curSelFP][2].length) {
		add(capsuleSpawn(i,songser[i]));
		capsules.members[i].text.x=0;
		capsules.members[i].text.x=1240+(capsules.members[i].text.x-capsules.members[i].text.width);
	}
	
	subCurSelected = 0;
	catName.text = data[curSelFP][1];
	backGround.color=data[curSelFP][3];
	changements(0);
}
function enterSong() {
	CoolUtil.playMenuSFX(1, getVolume(1, 'sfx'));
	openSubState(new ModSubState("substates/Freeplay_substate"));
	persistentUpdate = !persistentDraw;
	FlxG.save.data.Bamber_SONGSONG = songser[subCurSelected];
}
function destroy() WindowUtils.set_suffix("");

function capsuleSpawn(index,songData) {
	//SongText(Alphabet).
	var songItem = new Capsule();
	songItem.text = new Alphabet(0,0,songData.displayName,true);
	songItem.text.scale.set(0.9,0.9);
	songItem.text.updateHitbox();
	songItem.text.targetY=songItem.text.ID=index;

	//Silhouette(Image_behind_song_text);
	capsuleImage=songData.freeplayShit.capsule;
	if(songData.freeplayShit.capsule.length<=3) capsuleImage=songData.freeplayShit.capsule[FlxG.random.int(0, songData.freeplayShit.capsule.length-1)];
	songItem.silhouette = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/silhouettes/'+capsuleImage));

	//Icon
	songItem.icon = new HealthIcon(songData.icon);
	songItem.icon.sprTracker = songItem.text;
	songItem.icon.sprTrackerAlignment='left';
	songItem.icon.flipX=songData.icon!='face';
	songItem.icon.sprTrackerOffset.set(0,-50);

	//Tags
	if(songData.freeplayShit.new){
	songItem.newTag = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/tags/new'));
	songItem.newTag.scale.set(0.4,0.4);
	songItem.newTag.updateHitbox();
	}
	if(songData.freeplayShit.vip){
	songItem.vipTag = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/tags/vip'));
	songItem.vipTag.scale.set(0.45,0.45);
	songItem.vipTag.updateHitbox();
	}
    if(songData.freeplayShit.updated){
    songItem.updatedTag = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/tags/updated'));
	songItem.updatedTag.scale.set(0.4,0.4);
	songItem.updatedTag.updateHitbox();
    }
	
	capsules.add(songItem);
	return songItem;
}