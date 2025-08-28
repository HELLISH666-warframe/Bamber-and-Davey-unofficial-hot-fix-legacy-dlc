function create() {
    switch(PlayState.instance.SONG.meta.name){
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
        for (j in i.notes) j.shader = colorShader;
    }
}
/*
function onSplashShown(e) {
    e.value1.shader = e.value2.shader;
}
*/