function postCreate() {
	strumLines.forEach((s) -> {
		s.onNoteUpdate.add(onNoteUpdate);
	});
}
function onPostNoteCreation(e) {
	e.note.forceIsOnScreen = true;
	e.note.strumRelativePos = false;
	e.note.useAntialiasingFix = true;
}
function onNoteUpdate(e) {
	if (e.__reposNote) {
		if (!e.note.exists)
			return;

		e.strum.updateNotePosition(e.note);
		updateNotePos(e.note, e.strum);
	}
	e.cancelPositionUpdate();
}

final PIX180:Float = 565.4866776461628; // 180 * Math.PI
final _noteOffset = FlxPoint.get(0, 0);
final TO_RAD:Float = 0.017453292519943295; // Math.PI / 180;
final helperOffset = 90;

function updateNotePos(daNote, strum) {
	var shouldX = strum.updateNotesPosX && daNote.updateNotesPosX;
	var shouldY = strum.updateNotesPosY && daNote.updateNotesPosY;

	if (shouldX || shouldY) {
		final distance = (Conductor.songPosition - daNote.strumTime) * (-0.45 * strum.getScrollSpeed(daNote));
		final angleX = Math.cos((daNote.__noteAngle + helperOffset) * TO_RAD);
		final angleY = Math.sin((daNote.__noteAngle + helperOffset) * TO_RAD);
		_noteOffset.set(angleX * distance, angleY * distance);
		_noteOffset.x += -daNote.origin.x + daNote.offset.x;
		_noteOffset.y += -daNote.origin.y + daNote.offset.y;
		if (daNote.isSustainNote) {
			final m = (daNote.height * 0.5);
			_noteOffset.x += angleX * m;
			_noteOffset.y += angleY * m;
		}
		_noteOffset.x += strum.x + (strum.width * 0.5);
		_noteOffset.y += strum.y + (strum.height * 0.5);
		if (shouldX)
			daNote.x = _noteOffset.x;
		if (shouldY)
			daNote.y = _noteOffset.y;
	}
}