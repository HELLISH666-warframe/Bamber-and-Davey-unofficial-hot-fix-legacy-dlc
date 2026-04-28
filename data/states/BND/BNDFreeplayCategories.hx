import funkin.backend.chart.Chart;
import funkin.menus.StoryMenuState.StoryWeeklist;
import funkin.backend.utils.WindowUtils;
import flixel.text.FlxTextBorderStyle;
import menus.freeplay.Capsule;

var backGround = new FunkinSprite().loadGraphic(Paths.image('menus/menuDesat'));

var arrows:Array<FunkinSprite> = [];
var moveTimer:FlxTimer = new FlxTimer();
var appear = true;

var data = [ // Image, Title, [Song1, Song2, etc], color, font
	["BambersFarm","Week Bamber",['Yield','Cornaholic','Harvest'],0xB6FF00],//3
	["DaveysYard","Week Davey",['Synthwheel','Yard','Coop'],0x0066FF],//6
	["RomaniaOutskirts","Week Ronnie & Boris",['Ron Be Like','Bob Be Like','Fortnite Duos'],0xFED73E],//9
	["BonusWIP","Bonus Songs",['Mathemathon','Blusterous Day','Escape From Poland','Slammed','Origins','Swindled','Trade','Multiversus'],0x00FFA6],//17
	["Jokes","Joke Songs",['Generations','Memeing',"Judgement Farm","Judgement Farm 2",'Too Slop',"Yeld",'Squeaky Clean'],0x038703],//24
	["Collabs","Collab Songs",["Call Bamber","Deathbattle","H2O"],0xA5CEE3],//27
	["Crossovers","Crossover Songs",["Corn N Roll","Screencast"],0xFE3455],//29
	["Remixes","Remixes",['Spookeez','South','Pico','2Hot'],0xFF338A9C],//33
	["Legacy","Legacy/Old Content",['Yield V1','Cornaholic V1','Harvest V1','Yield Seezee Remix','Cornaholic Erect Remix V1','Harvest Chill Remix','Yield demo','Cornaholic demo','Harvest demo','Synthwheel demo','Yard demo','Best-Farmers-Forever','Coop Old','Fortnite Duos V1','Godzilla','Judgement Farm Old','Matemathon V1','Call Bamber Old','Harvest Vol2','Synthwheel Vol2','Coop Vol2','Bob be like Vol2','Swindled Vol2','Trade Vol2','Judgement Farm Vol2','Judgement Farm 2 Vol2','Placeholder Vol2'],0x16AD01],//60
	["PLACEHOLDER","REMOVE_LATER",['Astray','Facsimile','Placeholder','Test Footage'],0x000000,'vcr_osd.ttf'],//64
	['Favourites','Favourites',FlxG.save.data.freeplayShit.favourites,0xFE3455],
	/*["Baller", "Custom_content.", 0x16AD01]*/
];

var vinylGroup:FlxTypedGroup = new FlxTypedGroup();
var vinylNotVinylAssFucker = new FlxCamera();
static var curSelected:Int = 0;
var songser = [];
var album;
var timer = 0;
var playall;
var scorText = new FlxText(24, 0);

subCurSelected = 0;
subCurSelectedLimit = songser.length - 1;

var kILLYOURSELF:FlxTypedGroup = new FlxTypedGroup();

function create() {
	if(!FlxG.save.data.unlocks.sc)data[4][2].remove('Squeaky Clean');
	add(backGround).screenCenter();
	
	add(album = new FlxSprite(-140,-140).loadGraphic(Paths.image("menus/freeplay/albums/vol2.5"))).angle=-3;
	album.setGraphicSize(350,350);

	//Make this a whole FlxGroup that gets tweened on screen showing the songs statstitcs later.
	scorText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "right", FlxTextBorderStyle.SHADOW, 0xFF000000);
	scorText.text = "Stats(Wip)";
	scorText.shadowOffset.set(2, 2);
	add(scorText).angle=-3;
	
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
	
	vinylNotVinylAssFucker = new FlxCamera();
	vinylNotVinylAssFucker.bgColor = 0;
	FlxG.cameras.add(vinylNotVinylAssFucker, false);
	
	catName.cameras = vinylGroup.cameras = [vinylNotVinylAssFucker];
	
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
		arrows[a].cameras = [vinylNotVinylAssFucker];
    }
	
	change(0);
	
	changements(0);
	insert(999,kILLYOURSELF);
}
function update(elapsed) {
	timer += elapsed;
    if (controls.LEFT_P||controls.RIGHT_P) change(controls.LEFT_P ? -1 : 1);
	if (controls.UP_P||controls.DOWN_P) changements(controls.UP_P ? -1 : 1);
	if (controls.BACK) FlxG.switchState(new ModState("BND/BNDMenu"));
		
	if (controls.ACCEPT) {
		FlxG.sound.play(Paths.sound('menu/accept/Default'), getVolume(1, 'sfx'));
		openSubState(new ModSubState("substates/Freeplay_substate"));
		persistentUpdate = !persistentDraw;
		FlxG.save.data.Bamber_SONGSONG = songser[subCurSelected];
	}
	if (FlxG.mouse.overlaps(playall) && FlxG.mouse.pressed && curSelected<3) {
		weeks = StoryWeeklist.get(true, false).weeks;
		PlayState.loadWeek(weeks[curSelected], "hard");
		FlxG.switchState(new PlayState());
    }

	if (FlxG.keys.justPressed.F) {
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
	
    for (i in vinylGroup.members) i.x = lerp(i.x, -460 * (curSelected - i.ID), 0.2);
	
	arrows[0].angle = Math.sin(timer * 3) * 5;
	for (i in kILLYOURSELF){
		i.text.targetY = i.text.ID - subCurSelected;
		var scaledY = FlxMath.remapToRange(i.text.targetY, 0, 1, 0, 1.3);
		i.text.y = CoolUtil.fpsLerp(i.text.y, (scaledY * 250) + (FlxG.height * 0.30), 0.16);
	}
	for (i in 0...kILLYOURSELF.members.length) {
		kILLYOURSELF.members[i].text.x=CoolUtil.fpsLerp(kILLYOURSELF.members[i].text.x,switch(subCurSelected-i){
			case 0:targetX = 1240;
			case -1:targetX = 1350;
			default:targetX = 1700;
		}-kILLYOURSELF.members[i].text.width, 0.2);
	}

	if (FlxG.mouse.overlaps(scorText) && FlxG.mouse.pressed){
		FlxG.save.data.Bamber_SONGSONG = songser[subCurSelected];
		persistentUpdate = !persistentDraw;
		openSubState(new ModSubState("substates/stats-test"));
	}
}
function changements(a) {
	subCurSelected = FlxMath.wrap(subCurSelected + a, 0, subCurSelectedLimit);
	if(a!=0)CoolUtil.playMenuSFX('scroll', getVolume(1, 'sfx'));
	
	//for (i in 0...kILLYOURSELF.length) kILLYOURSELF[i].alpha = 0.5;
	var ver = songser[subCurSelected].freeplayShit.album==null?1:songser[subCurSelected].freeplayShit.album;
	if (ver == null) ver = 2;
	
	album.loadGraphic(Paths.image("menus/freeplay/albums/vol"+ver));
	WindowUtils.set_suffix(" | Currently Selecting: "+songser[subCurSelected].displayName);

	backGround.color=data[curSelected][3];
}

function change(a) {
	mult=1;
	if(FlxG.save.data.freeplayShit.favourites.length==0)mult=curSelected==10?1:2;
    curSelected = FlxMath.wrap(curSelected + a, 0, vinylGroup.length - mult);
	
	catName.font=Paths.font(data[curSelected][4]==null?"vcr.ttf":data[curSelected][4]);
	moveTimer.cancel();
	
	if (!appear) {
		appear = true;
		FlxG.sound.play(Paths.sound("menu/freeplay/cassetteAppear"), getVolume(1, 'sfx'));
	}

	songser = [];
	for(s in data[curSelected][2]) songser.push(Chart.loadChartMeta(s, "normal", true));
	
	for (i in vinylGroup.members) {
		var relSel = Math.abs(curSelected - i.ID);
		var targetNumber = curSelected == i.ID ? 190 : 300;
		FlxTween.globalManager.cancelTweensOf(i);
		FlxTween.tween(i, {y: targetNumber + relSel * 50}, 0.4, {ease: FlxEase.quartOut});
	}
		
	if (a == 0) {
		appear = false;
		for (i in vinylGroup.members) {
			FlxTween.globalManager.completeTweensOf(i);
			new FlxTimer().start(0.06, ()->{i.y += 128;});
			i.x = -460 * (curSelected - i.ID);
		}
	}
	else
	{
		trace("boi");
		//arrows[FlxMath.bound(a, 0, 1)].y += 100;
		arrows[FlxMath.bound(a, 0, 1)].animation.play("hit");
		FlxTween.globalManager.cancelTweensOf(arrows[FlxMath.bound(a, 0, 1)]);
		arrows[FlxMath.bound(a, 0, 1)].scale.set(0.1, 0.2);
		FlxTween.tween(arrows[FlxMath.bound(a, 0, 1)], {"scale.x": 0.25, "scale.y": 0.25}, 0.5, {ease: FlxEase.circOut});
		
		FlxG.sound.play(Paths.sound("menu/freeplay/cassetteScroll"), getVolume(1, 'sfx'));
		moveTimer = new FlxTimer().start(0.7, ()->{
			appear = false;
			FlxG.sound.play(Paths.sound("menu/freeplay/cassetteDisappear"), getVolume(1, 'sfx'));
			for (i in vinylGroup.members)
				FlxTween.tween(i, {y: i.y + 128}, 0.5, {ease: FlxEase.quartOut});
		});	
	}
	
	kILLYOURSELF.clear();
	for (i in 0...data[curSelected][2].length) {
		add(capsuleSpawn(i,songser[i]));
		kILLYOURSELF.members[i].text.x=0;
		kILLYOURSELF.members[i].text.x=1240+(kILLYOURSELF.members[i].text.x-kILLYOURSELF.members[i].text.width);
	}
	
	subCurSelected = 0;
	subCurSelectedLimit = data[curSelected][2].length - 1;
	catName.text = data[curSelected][1];
	changements(0);
}
function destroy() WindowUtils.set_suffix("");

function capsuleSpawn(index,songData) {
	//SongText(Alphabet).
	var songItem = new Capsule();
	songItem.text = new Alphabet(0,0,songData.displayName,true);
	songItem.text.scale.set(0.9,0.9);
	songItem.text.targetY=songItem.text.ID=index;

	//Silhouette(Image_behind_song_text);
	capsuleImage=songData.freeplayShit.capsule;
	if(songData.freeplayShit.capsule.length<=3) capsuleImage=songData.freeplayShit.capsule[FlxG.random.int(0, songData.freeplayShit.capsule.length-1)];
	songItem.silhouette = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/silhouettes/'+capsuleImage));
	songItem.silhouette.scale.set(0.6,0.6);

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
	songItem.vipTag.scale.set(0.5,0.5);
	songItem.vipTag.updateHitbox();
	}
    if(songData.freeplayShit.updated){
    songItem.updatedTag = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/tags/updated'));
	songItem.updatedTag.scale.set(0.4,0.4);
	songItem.updatedTag.updateHitbox();
    }
	
	kILLYOURSELF.add(songItem);
	return songItem;
}