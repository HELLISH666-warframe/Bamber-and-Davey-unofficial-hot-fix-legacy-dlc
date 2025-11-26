function create() {
    switch(PlayState.SONG.meta.name){
        case"Judgement Farm"|"Judgement Farm 2"|"Judgement Farm 2 Vol2"|"Judgement Farm Vol2":
    importScript("data/scripts/huds/undertale");
    }
}

function postCreate() {
    for (i in strumLines.members) {
        var color = i.characters[0].iconColor;
        var colorShader = new CustomShader("ColoredNoteShader");
        colorShader.r = ((color >> 16) & 0xFF);
        colorShader.g = ((color >> 8) & 0xFF);
        colorShader.b = ((color) & 0xFF);

        for (j in i.members) j.shader = colorShader;
        for (j in i.notes) j.shader = colorShader;//Gonna_add_custom_note_shit_later.Ok?
    }
}

function onNoteCreation(e) {
    Assets.exists(Paths.image('game/notes/' + strumLines.members[e.strumLineID].characters[0].xml.get("noteskin"))) ? port=strumLines.members[e.strumLineID].characters[0].xml.get("noteskin") : port="default";
	e.noteSprite = "game/notes/" +port;
}
function onStrumCreation(e) {
	Assets.exists(Paths.image('game/notes/' + strumLines.members[e.player].characters[0].xml.get("noteskin"))) ? port=strumLines.members[e.player].characters[0].xml.get("noteskin") : port="default";
	e.sprite = "game/notes/" +port;
}
function onPlayerHit(e){
	e.note.splash = (Assets.exists(Paths.image("game/splashes/"+boyfriend.xml.get("noteskin"))) ? boyfriend.xml.get("noteskin") : "default");
	}
/*
function onSplashShown(e) {
    e.value1.shader = e.value2.shader;
}
*/