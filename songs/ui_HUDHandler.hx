function create() {
    switch(PlayState.SONG.meta.name){
        case"Judgement Farm"|"Judgement Farm 2"|"Judgement Farm 2 Vol2"|"Judgement Farm Vol2":
    importScript("data/scripts/huds/undertale");
    }
}
//Note shit dirctlly from https://gamebanana.com/mods/585254.
public var noteShaders = [];
var defaultNoteColors = [FlxColor.fromString('#C24B99'), FlxColor.fromString('#00FFFF'), FlxColor.fromString('#12FA05'), FlxColor.fromString('#F9393F')];
function postCreate() {
    for (i=>strum in strumLines.members) {
        changeStrumLineColors(strum);
    }
    for (i=>strum in strumLines.members) {
        for (j=>receptor in strum.members) {
            receptor.shader = noteShaders[i][j];
        }

        for (note in strum.notes.members) {
            if (note.extra.get("noShader") == null) note.shader = noteShaders[i][note.noteData];

            //splashHandler.getSplashGroup(e.note.noteType == null ? 'default' : e.note.noteType).members[e.note.noteData + (strum.members.length * s)].shader = e.note.shader;
        }
    }
}

public function changeStrumLineColors(strumLine, ?char) {
    var i = strumLines.members.indexOf(strumLine);
    if (noteShaders[i] == null) noteShaders[i] = [];
    var colorArray = defaultNoteColors;
        
    if ((char != null || (char == null && strumLine.characters.length >= 1))) {
        var colorations = (char != null ? char : strumLine.characters[0]).xml.get("noteColors");

        if (colorations != null) {
            colorArray = colorations.split(",");
            
            for (col in 0...colorArray.length) {
                colorArray[col] = FlxColor.fromString(colorArray[col]);
            }
        }
    }

    for (r in 0...strumLine.members.length) {
        if (noteShaders[i][r] == null) noteShaders[i][r] = new CustomShader("ColoredNoteShader");
        noteShaders[i][r].r = ((colorArray[r] >> 16) & 0xFF);
        noteShaders[i][r].g = ((colorArray[r] >> 8) & 0xFF);
        noteShaders[i][r].b = ((colorArray[r]) & 0xFF);
    }
}

function onNoteCreation(e) {
    if(StringTools.startsWith(e.noteType, "special/"))return;
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