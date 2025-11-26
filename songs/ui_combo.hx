function postUpdate(elapsed:Float) {
    comboGroup.setPosition(800,500);
    for(i in comboGroup.members){
        i.scale.set(0.6,0.6);
        i.camera=camHUD;
    }
}
function onPlayerHit(e) {
   e.displayCombo=true;
}