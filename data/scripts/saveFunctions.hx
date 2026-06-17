import funkin.savedata.FunkinSave;

var rankingTexts:Array<Dynamic> = [['You Suck!',0.2],['Good grief...',0.4],['Seriously?',0.5],['Mid',0.6],
['Meh',0.69],['Nice',0.7],['Good',0.8],['Awesome',0.9],['Bambtastic!',1],['Perfect!!',1]];

public function getTheThingie(song,diff,scoreThingie:String) {
    if(FunkinSave.getSongHighscore(song, diff).score!=0){
		switch(scoreThingie){
			case 'score': return FunkinSave.getSongHighscore(song, diff).score;
			case 'misses': return FunkinSave.getSongHighscore(song, diff).misses;
			case 'accuracy': return Std.string(floorDecimal(FunkinSave.getSongHighscore(song, diff).accuracy * 100, 2)).split('.').join('.')+ '%';
			case 'hits':return FunkinSave.getSongHighscore(song, diff).hits;
            case 'notes':num=0;
                for(i in FunkinSave.getSongHighscore(song, diff).hits.keys())
                num+=FunkinSave.getSongHighscore(song, diff).hits[i];
            return num;
            case 'rank':if(FunkinSave.getSongHighscore(song, diff).accuracy<0)return "?";
            for (rating in rankingTexts) if (FunkinSave.getSongHighscore(song, diff).accuracy < rating[1]) return rating[0];
            case 'test':
                for(i in FunkinSave.getSongHighscore(song, diff).hits.keys()){
                trace(FunkinSave.getSongHighscore(song, diff).hits[i]);
            }
		}
	} else {
		switch(scoreThingie){
			case 'hits': return ['???'];
			default: return '???';
		}
	}
}

function floorDecimal(value:Float, decimals:Int):Float{
	if (decimals < 1) return Math.floor(value);
	var tempMult:Float = 1;
	for (i in 0...decimals) tempMult *= 10;
	var newValue:Float = Math.floor(value * tempMult);
	return newValue / tempMult;
}