import funkin.backend.utils.WindowUtils;
function create() {
	window.title="";
	trace(window.title);
}
function postCreate() {
	WindowUtils.winTitle="";
	WindowUtils.suffix='Bamber & Davey Vol. 2.5 | '+PlayState.SONG.meta.displayName+' | '+PlayState.difficulty+"(Charter)";//I have the memmoryygt of a goldfish ok?
}