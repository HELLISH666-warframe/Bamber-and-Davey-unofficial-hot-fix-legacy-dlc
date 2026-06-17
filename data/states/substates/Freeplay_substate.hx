//VERY_wip.
import funkin.menus.ui.ClassicAlphabet;
import menus.freeplay.ComposerIcon;

var curSong=FlxG.save.data.Bamber_SONGSONG;//Gets_the_selected_song_and_it's_meta.
var click_through:Bool = false;//So_if_accept_is_held_from_the_privous_menu_it_doesn't_do_anything.
var coolCam = new FlxCamera();//Cam_for_the_substate.
var portrait = new FlxSprite(700);

var hitbox = new FlxSprite(1045, 635);//Scaling_the_text_up_fucks_up_the_hitbox_so_this.

var songName;
var composer = new Alphabet(0, 130, 0, true);

var options:Array<String> = ['Cutscenes','Mod charts','Scroll Speed','Mode'];
var optionTexts = new FlxTypedGroup();
var checkBox = new FlxSprite(450,210);
var optionParams = new FlxTypedGroup();

var difficultySprites:Map<String, FlxSprite> = [];
var arrows:Array<Alphabet> = [];

var optionPointer = new FlxSprite(-170,8);

static var curDifficulty:Int = 0;
var curOption:Int = 0;

static var curPlayingInst = Paths.inst(curSong.name, curSong.difficulties[curDifficulty]);
static var prevSong:String = "";

function create() {
	camera = coolCam = new FlxCamera();
	FlxG.cameras.add(coolCam, false).bgColor = 0x00000000;
	new FlxTimer().start(0.2, ()->{click_through = true;});//Anti_fuckup_thing.
	prevchar = curPlayingInst;

	add(bg = new FlxSprite().makeSolid(1280,720,FlxColor.BLACK)).alpha = 0.6;

	//Portrait_shit.
	if (Assets.exists(Paths.image('menus/freeplay/Portraits/' +curSong.freeplayShit.portrait))){
	portrait.loadGraphic(Paths.image('menus/freeplay/Portraits/'+curSong.freeplayShit.portrait));
	add(portrait).setGraphicSize(570,570);
	portrait.setPosition(700,60/portrait.height+30);
	FlxTween.tween(portrait, {x: 500}, 1, {ease: FlxEase.elasticOut});
	}
	
	add(playText = new Alphabet(1050, 665, 'PLAY',true)).scale.set(1.1,1.1);
	add(hitbox.makeSolid(230, 80, 0xE0000020)).alpha = 0;

	//Songname_and_composer_icon_shit.
	if(curSong.credits!=null&&Assets.exists(Paths.image('credits/Titles/' +curSong.credits.title))){
		songName=getSongTitle(curSong.credits.title);
	}
	else songName = new Alphabet(285.25, 70, curSong.displayName, true);
	add(songName).screenCenter(FlxAxes.X);
	
	if(curSong.freeplayShit.composer!=null){
	composer.text = "By "+ curSong.freeplayShit.composer;
	composer.scale.set(0.5,0.5);
	composer.updateHitbox();
	composer.screenCenter(FlxAxes.X);
	add(composer).x =songName.x+songName.width;
	var testtt2=new ComposerIcon(songName.x+songName.width+10,200,curSong.freeplayShit.composer);
	add(testtt2.lines);
    }

	add(optionTexts);
	for (i in 0...options.length) {
		var item = new Alphabet(120, (i * 80), options[i],true);
		item.scale.set(0.9,0.9);
		item.y=250+(i * 135);
		item.updateHitbox();
		if([curSong.freeplayShit.hasCutscenes,curSong.freeplayShit.hasModchart,FlxG.save.data.options.scrollSpeed][i]!=true&& i<=2)item.alpha=0.3;
		optionTexts.add(item).width = item.width*item.scale.y;
	}

	checkBox.frames = Paths.getFrames('menus/options/checkbox');
	checkBox.animation.addByIndices("false", "Checkbox0", [9,8,7,6,5,4,3,2,1,0], '',24, false);
	checkBox.animation.addByPrefix('true', "Checkbox0", 24,false);
	checkBox.animation.play(true,true,!FlxG.save.data.options.dialogue[2],FlxG.save.data.options.dialogue[2]?24:9);
	if(curSong.freeplayShit.hasCutscenes==null)checkBox.alpha=0.3;
    add(checkBox);

	add(optionParams);
	for (i in 0...2) {
		params = new ClassicAlphabet(0,0,"<"+[FlxG.save.data.options.modcharts,FlxG.save.data.options.scrollSpeed_Speed][i]+">",true);
		params.scale.set(0.7,0.7);
		params.y=340+(i * 135);
		params.x=i==0?508.8:554.7;
		if(i==0&&curSong.freeplayShit.hasModchart==null)params.alpha=0.3;
		if(i==1&&!FlxG.save.data.options.scrollSpeed)params.alpha=0.3;
        optionParams.add(params);
    }

	//Difficulty sprite setup.
	for (e in curSong.difficulties) {
		var le = e.toLowerCase();
		diffImage= Assets.exists(Paths.image("menus/freeplay/modes/" + le))? le:'placeholder';
		diffSprite = CoolUtil.loadAnimatedGraphic(new FlxSprite(90,458),Paths.image('menus/freeplay/modes/'+diffImage));
		diffSprite.antialiasing = true;
		add(diffSprite).scale.set(0.3,0.3);

		difficultySprites[le] = diffSprite;
	}
	for (a in 0...2) {
        arrows.push(new Alphabet(0,650,["<", ">"][a],true));
        add(arrows[a]).scale.set(1.2,1.2);
		arrows[a].x = (a + 1) * 100 + a * 180+230;
		if(curSong.difficulties.length==1)arrows[a].alpha=0.3;
    }

	var manY = 0;
    for (i in 0...10) {
        bulletOption = new FlxSprite(-170, manY);
        bulletOption.frames = Paths.getFrames('menus/freeplay/bulletOption');

        if (i % 3 == 0) {
            bulletOption.animation.addByPrefix('idle', "idle", 24, false);
            bulletOption.animation.play('idle');
        } else {
            bulletOption.animation.addByPrefix('dot', "dot", 24);
            bulletOption.animation.play('dot');
        }
		bulletOption.scale.set(0.3,0.3);
        add(bulletOption);

        manY += bulletOption.height * (i % 4 == 0 ? 0.09 : 0.46 * (i % 4 == 2 ? 0.2 : 0.2));
        bulletOption.antialiasing = true;
		bulletOption.y+=10;
    }

	changeDiff(0);
	changeOption(0);
	changeThang(0);

	optionPointer.frames = Paths.getFrames('menus/freeplay/bulletOption');
	optionPointer.animation.addByPrefix('idle', "appear", 10, false);
	optionPointer.scale.set(0.3,0.3);
	add(optionPointer).animation.play('idle');
	if(curPlayingInst!=prevSong) FlxG.sound.playMusic(curPlayingInst, 0);
	if(FlxG.sound.music!=null) FlxG.sound.music.fadeIn(9,0,1);
	pushToClickables(hitbox);
}
function getSongTitle(name) {
	var fuck = new FlxSprite(0,-150);
	if (!Assets.exists(Paths.file("images/credits/Titles/"+name+".xml"))){
		fuck.loadGraphic(Paths.image('credits/titles/'+name));
		if(fuck.width>600){
		fuck.scale.set(0.5,0.5);
		fuck.updateHitbox();
		fuck.y=FlxG.height-fuck.height-500;
		}
		else{
			fuck.updateHitbox();
			fuck.y=FlxG.height-fuck.height-560;
		}
	}
	else{
		fuck.frames = Paths.getSparrowAtlas("credits/titles/"+name);
		for (i in 1...11) fuck.animation.addByPrefix(i, i+'Title', 24, true);
		fuck.scale.set(1.01,1.01); fuck.updateHitbox();

		var chance = FlxG.random.int(0,100);
		if (chance > 95) {
			fuck.frames = Paths.getSparrowAtlas("game/battlegrounds/Horse Plinko");
			fuck.animation.addByPrefix("Horse Plinko", 'Horse Plinko', 24, true);
			fuck.animation.play("Horse Plinko");

			fuck.scale.set(3,3); fuck.updateHitbox(); fuck.y += 40;
		} else if (chance > 70) {
			fuck.animation.play(FlxG.random.int(2,10));
		} else {
			fuck.animation.play("1");
		}
		fuck.updateHitbox();
		fuck.y=FlxG.height-fuck.height-590;
	}

	if(curSong.freeplayShit.offset!=null)
		fuck.setPosition(curSong.freeplayShit.offset[0],curSong.freeplayShit.offset[1]);

	return fuck;
}
function update(elapsed:Float) {
	if(!click_through)return;
	if (controls.ACCEPT && curOption==0&&curSong.freeplayShit.hasCutscenes!=null){
		FlxG.save.data.options.dialogue[2]=!FlxG.save.data.options.dialogue[2];
		checkBox.animation.play(FlxG.save.data.options.dialogue[2]);
	}
	if (controls.BACK){
		FlxG.save.flush();
		FlxG.sound.music.fadeOut(9,0,1);
		CoolUtil.playMenuSFX(2, getVolume(0.9, 'sfx'));
		close();
	}
	if (FlxG.mouse.overlaps(hitbox) && FlxG.mouse.pressed)playsong();
	if(controls.RIGHT_P||controls.LEFT_P){
		switch(curOption){
			case 1:changeThang(controls.RIGHT_P ? 1 : -1);
			case 2:changeThang(controls.RIGHT_P ? 0.1 : -0.1);
			case 3:changeDiff(controls.RIGHT_P ? 1 : -1);
		}
		optionParams.forEach(function (param) {
			param.members[0].color=param.members[param.members.length-1].color=FlxColor.fromRGB(255, 100, 19);
		});
	}
	if (controls.UP_P||controls.DOWN_P) changeOption(controls.UP_P ? -1 : 1);
	optionPointer.y=lerp(optionPointer.y,switch(curOption){
		case 0:8;case 1:151;case 2:288;case 3:426;},0.25);
}
function postUpdate(elapsed:Float) {
	for(b in [0,1]) {arrows[b].color=FlxColor.WHITE;
		if (FlxG.mouse.overlaps(arrows[b]) && FlxG.mouse.pressed){
			arrows[FlxG.mouse.overlaps(arrows[0])?0:1].color=FlxColor.fromRGB(255, 100, 19);
			if(FlxG.mouse.justPressed) changeDiff(FlxG.mouse.overlaps(arrows[0])?-1:1);
		}
	}
	if ((controls.LEFT||controls.RIGHT)&&curOption==3)arrows[controls.LEFT?0:1].color=FlxColor.fromRGB(255, 100, 19);
	playText.alpha=FlxG.mouse.overlaps(hitbox)?1:0.3;
}

var __oldDiffName = null;
function changeDiff(e) {
	//arrows[FlxMath.bound(e, 0, 1)].animation.play("hit");
	curDifficulty = FlxMath.wrap(curDifficulty + e, 0, curSong.difficulties.length - 1);
	if (__oldDiffName != (__oldDiffName = curSong.difficulties[curDifficulty].toLowerCase())) {
		for(e in difficultySprites) e.alpha = 0.001;

		var diffSprite = difficultySprites[__oldDiffName];

		if (diffSprite != null)  diffSprite.alpha = !diffSprite.alpha;
	}
	curPlayingInst = Paths.inst(curSong.name, curSong.difficulties[curDifficulty]);
	if(curPlayingInst!=prevSong){
		FlxG.sound.playMusic(curPlayingInst, 1);
		prevSong=curPlayingInst;
	}
}
function changeOption(p) {
	if(p!=0)CoolUtil.playMenuSFX('scroll', getVolume(1, 'sfx'));
	curOption = FlxMath.wrap(curOption + p, 0, 3);
}
function changeThang(s) {
	switch(curOption){
		case 1:if(curSong.freeplayShit.hasModchart==null)return;
		optionParams.members[0].text ="<"+FlxG.save.data.options.modcharts+">";
		case 2:if(!FlxG.save.data.options.scrollSpeed)return;
		FlxG.save.data.options.scrollSpeed_Speed=FlxMath.bound(FlxG.save.data.options.scrollSpeed_Speed + s, 1, 10);
		optionParams.members[1].text ="<"+FlxG.save.data.options.scrollSpeed_Speed+">";
	}
}
function playsong() {
	PlayState.loadSong(curSong.name, curSong.difficulties[curDifficulty].toLowerCase());

	acceptSound=curSong.freeplayShit.sound!=null?curSong.freeplayShit.sound:'default';
	if(acceptSound.length<=3)
		acceptSound=curSong.freeplayShit.sound[FlxG.random.int(0, curSong.freeplayShit.sound.length-1)];
	FlxG.sound.play(Paths.sound('menu/accept/'+acceptSound), getVolume(1, 'sfx'));
	FlxG.switchState(new PlayState());
	curPlayingInst="fuck";
	click_through=false;
}
function destroy() {FlxG.cameras.remove(coolCam);
	removeFromClickables(hitbox);
	FlxG.save.flush();
}