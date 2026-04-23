if (PlayState.instance != null) {
    function update(elapsed) {
        if (['idle', 'idle-stare'].contains(getAnimName()) && isAnimFinished()) playAnim(getAnimName()+'-loop', false, 'DANCE');
    }

    function onDance(event) {
        if (FlxG.random.int(1,4) == 3 && ['idle-loop', 'idle-stare-loop'].contains(getAnimName())) {
            playAnim('idle-stare', true, 'NONE');
            event.cancelled = true;
        }
    }
}