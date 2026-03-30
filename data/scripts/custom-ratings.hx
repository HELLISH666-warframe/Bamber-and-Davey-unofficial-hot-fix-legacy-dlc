/*The_cne_combo_shit_wasn't_capable_enough.
Also_split_up_to_reduce_clutter_in_uic-combo.hx.*/
var comboPath = 'game/score/'+PlayState.SONG.meta.customValues.comboPath;
public var combTestShit = [];
function postComboShit() {
	ratingManager.ratingData=[];
	switch(PlayState.SONG.meta.name){
		case'Astray':
		combTestShit = [
		{name:"Sick",image:comboPath+"Sick",accuracy:1,health:0.035,maxDiff:125*0.30,score:350,color:"#24DEFF",fcRating:"MFC",showSplashes:true},
		{name:"Good",image:comboPath+"Good",accuracy:2/3,health:0.025,maxDiff:125*0.55,score:200,color:"#3FD200",fcRating:"GFC"},
		{name:"Bad",image:comboPath+"Bad",accuracy:1/3,health:0.010,maxDiff:250,score: 50,color:"#D70000"}];
		case'Facsimile':
		combTestShit = [
		{name:"Good",image:comboPath+"Good",accuracy:1,health:0.035,maxDiff:125*0.55,score:200,color:"#FF0000",fcRating:"GFC"},
		{name:"Bad",image:comboPath+"Bad",accuracy:1/2,health:0.0175,maxDiff:250,score:100,color:"#00FF00"}];
		case'Placeholder'|'Test Footage':
		combTestShit = [{name:"Hit",image:null,accuracy:1,health:0.035,maxDiff:250,score:100,color:"#FFFFFF"}];
		case'Generations':
		combTestShit = [{name:"Good",image:comboPath+"keep yourself safe",accuracy:1,health:0.035,maxDiff:30,score:350,color:"#00FF00",fcRating:"MFC",showSplashes:true},
		{name:"You Should Kill Yourself, Now!",image:comboPath+"kill yourself",accuracy:-1000,health:0.005,maxDiff:9999999,score:0,fcRating:"Piece Of Shit",color:"#FF0000"}];
		case'Deathbattle':
		combTestShit = [
		{name:"Brutal",image:comboPath+"brutal",accuracy:1,health:0.035,maxDiff:125*0.30,score:350,color:"#FFB432",fcRating:"BFC",showSplashes:true},
    	{name:"Strong",image:comboPath+"strong",accuracy:2/3,health:0.025,maxDiff:125*0.55,score:200,color:"#FF1500",fcRating:"SFC"},
    	{name:"Average",image:comboPath+"average",accuracy:1/3,health:0.010,maxDiff:125*0.75,score:50,color:"#B50054"},
    	{name:"Weak",image:comboPath+"weak",accuracy:1/6,health:0.0,maxDiff:250,score:-150,color:"#89006B"}];
		case'Corn N Roll':
		combTestShit = [
		{name:"Nice",image:comboPath+"Nice",accuracy:1,health:0.035,maxDiff:125*0.25,score:350,color:"#FFD11A",fcRating:"MFC",showSplashes:true},
		{name:"Good",image:comboPath+"Good",accuracy:3/4,health:0.025,maxDiff:125*0.4,score:200,color:"#1DC0DE",fcRating:"GFC"},
		{name:"Ok",image:comboPath+"Ok",accuracy:1/2,health:0.010,maxDiff:125*0.65,score:100,color:"#0EC200"},
		{name:"Bad",image:comboPath+"Bad",accuracy:1/3,health:0.005,maxDiff:125*0.8,score:50,color:"#880E77"},
		{name:"Sad",image:comboPath+"Sad",accuracy:1/6,health:0.0,maxDiff:125,score:-150,color:"#565A6B"}];
		case'Judgement Farm'|'Judgement Farm 2'|'Judgement Farm 2 Vol2'|'Judgement Farm Vol2':
		combTestShit = [
		{name:"Perfect",image:comboPath+"perfect",accuracy:1,health:0.035,maxDiff:30,score:350,color:"#2877FF",fcRating:"PFC",showSplashes:true},
		{name:"Great",image:comboPath+"great",accuracy:2/3,health:0.025,maxDiff:70,score:200,color:"#51C3E2",fcRating:"GFC"},
		{name:"Nice",image:comboPath+"nice",accuracy:1/3,health:0.010,maxDiff:120,score:50,color:"#F6FF56"},
		{name:"Meh",image:comboPath+"meh",accuracy:1/6,health:0.0,maxDiff:250,score:-150,color:"#FF4040"}];
		default:
		combTestShit = [
    	{name:"Sick",image:comboPath + "Sick",accuracy:1,health:0.035,maxDiff:125*0.30,score:350,color:"#24DEFF",fcRating:"MFC",showSplashes:true},
    	{name:"Good",image:comboPath + "Good",accuracy:2/3,health:0.025,maxDiff:125*0.55,score:200,color:"#3FD200",fcRating:"GFC"},
    	{name:"Bad",image:comboPath + "Bad",accuracy:1/3,health:0.010,maxDiff:125*0.75,score:50,color:"#D70000"},
    	{name:"Shit",image:comboPath + "Shit",accuracy:1/6,health:0.0,maxDiff:250,score:-150,color:"#804913"}
		];
	}
	ratingManager.hitWindows.clear();
	hits.clear();
	for (i in 0...combTestShit.length)
		ratingManager.addRating({name:combTestShit[i].name, accuracy:combTestShit[i].accuracy, window:combTestShit[i].maxDiff, score:combTestShit[i].score, splash:combTestShit[i].showSplashes!=null? true :false});
	ratingManager.ratingData.sort((a, b) -> Reflect.compare(a.window, b.window));
	for (rating in [for (i in ratingManager.ratingData) i.name]) hits.set(rating, 0); // Ensure all keys exist as to prevent null errors.
}