import Float;
import flixel.util.FlxGradient;
var medalArray = [//Name,desc,sprite,color,howto,Font,ID.
	["Corntastic!", "Beat Week Bamber", 'Bamber', 0x00CC00, "• Play Bamber's week in Story Mode",'','w1'],
	["Shreddingly Good!", "Beat Week Davey", 'Davey', 0x0066FF, "• Play Davey's week in Story Mode",'','w2'],
	["Bruh Moment", "Beat Week Boris And Ronnie", 'BorisAndRonnie', 0xFED73E, "• Play Ronnie's & Boris's week in Story Mode",'','w3'],
	["The Swindler", "Hit EVERY note in Swindled (Located in Bonus Songs)\n(Modchart optional)", 'Swindler', 0x8E0108, "• FC Swindled",'','fcSwindled'],
	["Genocidal Tendencies", "Hit EVERY note in Judgement Farm\n& Judgement Farm 2", 'Judgement', 0x59DEF7, "• FC Judgement Farm\n• FC Judgement Farm 2", "Mars_Needs_Cunnilingus.ttf",'genocide'],
	["Secret Song 1", "Found Squeaky Clean\n(Now located in Joke Songs)", 'squeaky', 0xFE3455, '','','sc'],
	["Am I A Joke To You?", "Found Main Menu secret\n(Head to Freeplay for a surprise...)", 'Joke', 0x0F161F, "", "vcr_osd.ttf",'nightmare'],
	["Secret Song 2", "T E S T F O O T A G E", 'Test', 0x000000, "", "vcr_osd.ttf",'TF'],
	["Friendship!", "Beat every Collab Song", 'Collabs', 0x996633, "• Beat Call Bamber\n• Beat Deathbattle\n• Beat H2O",'','collab'],
	["Nostalgia", "Play a Volume. 1 song", 'Old', 0x16AD01, "• Play any Volume. 1 Song",'','v1']
];

var medals = [];
var curSlectedA=0;

var arrows:Array<FunkinSprite> = [];
function create() {
	updateCurStyle('YCE');
	add(new FlxSprite().loadGraphic(Paths.image("menus/menuBGYoshiCrafter")));
	add(new FlxSprite().makeGraphic(FlxG.width, 80, 0x88000000, true));
	add(gradient = FlxGradient.createGradientFlxSprite(Std.int(FlxG.width), Std.int(FlxG.height), [0x00000000, 0xFFAAAAAA]));

    add(title = new Alphabet(504, 17.5, "Medals", true, 0.75)).scale.set(0.75,0.75);

	add(count = new Alphabet(FlxG.width - 130, 17.5, curSlectedA+1 + "/" + medalArray.length, true, 0.75)).scale.set(0.75,0.75);

	//Arrows_here
	add(name = new FlxText(0, 0).setFormat(Paths.font("vcr.ttf"), 42));
	add(desc = new FlxText(0, 0).setFormat(Paths.font("vcr.ttf"), 24));
	for(e in 0...3){
		var curMedal = new FunkinSprite();
		curMedal.frames = Paths.getSparrowAtlas('menus/medals');
		for (i in medalArray) {
			curMedal.animation.addByPrefix(i[2], i[2], 24, true);
		}
		medals.push(curMedal);
	}
	for(c in medals){
		add(c).screenCenter();
		c.antialiasing = true;
		c.y -= 100;
	}
	for (a in 0...2) {
        arrows.push(new FunkinSprite());
		arrows[a].frames = Paths.getSparrowAtlas('menus/storymenu/assets');
        for(z in ["arrow ", "arrow push "]) {
			arrows[a].animation.addByPrefix(z, z + ["left", "right"][a], 24, false);
		}
        arrows[a].animation.play("arrow ");
        add(arrows[a]).antialiasing = Options.antialiasing;
		arrows[a].updateHitbox();
		arrows[a].y = medals[0].y + (medals[0].height/2) - (arrows[a].height/2);
    }
	arrows[0].x = medals[0].x - 50;
	arrows[1].x = medals[0].x + medals[0].width;
	desc.fieldWidth = 10000;
	desc.alignment = "center";
	medals[1].scale.set(0.75, 0.75);
	for(d in [0, 2]){medals[d].scale.set(0.5, 0.5);}
	for(i in 0...3) trace(medals[i].y);
	for(i in 0...3) {medals[i].x=switch(i){case 0:25;case 1:444.5;case 2:860.5;}
	medals[i].y=75.5;
	}
	change(0);
}
function update(){
	if (controls.BACK) FlxG.switchState(new MainMenuState());
	for(b in [0,1]) arrows[b].animation.play('arrow ');
	if (controls.LEFT_P||controls.RIGHT_P) change(controls.LEFT_P ? -1 : 1);
	if (controls.LEFT||controls.RIGHT)arrows[controls.LEFT?0:1].animation.play('arrow push ');
}

function change(a:Int) {
	curSlectedA = FlxMath.wrap(curSlectedA + a, 0, medalArray.length - 1);
	gradient.color = medalArray[curSlectedA][3];
	count.text = curSlectedA+1 + "/" + medalArray.length;
	count.x = FlxG.width - 50 - count.width;

	prev=medalArray[curSlectedA-1] == null?9:curSlectedA-1;
	next=medalArray[curSlectedA+1] == null?0:curSlectedA+1;

	medals[0].animation.play(medalArray[prev][2]);
	medals[1].animation.play(medalArray[curSlectedA][2]);
	medals[2].animation.play(medalArray[next][2]);

	medals[0].color=FlxG.save.data.gameStats.achievements.contains(medalArray[prev][6])?0xFFFFFF:0x000000;
	if(FlxG.save.data.gameStats.achievements.contains(medalArray[curSlectedA][6])){
		medals[1].color=0xFFFFFF;
		desc.text = medalArray[curSlectedA][1];
	}
	else{
		medals[1].color = 0x000000; 
		desc.text = "LOCKED" + "\n" + medalArray[curSlectedA][4];
	}
	medals[2].color=FlxG.save.data.gameStats.achievements.contains(medalArray[next][6])?0xFFFFFF:0x000000;
	name.text = medalArray[curSlectedA][0];
	name.x = medals[1].getMidpoint().x - (name.width/2);
	name.y = medals[1].y + medals[1].height - 40;
	desc.screenCenter();
	desc.y = name.y + 60;
}