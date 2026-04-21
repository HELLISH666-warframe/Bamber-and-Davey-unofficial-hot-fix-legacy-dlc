import funkin.backend.utils.DiscordUtil;

function onMenuLoaded(name:String) {
	DiscordUtil.changePresenceSince("In the Menus", null);
}

function onDiscordPresenceUpdate(e) {
	var data = e.presence;

	if(data.button1Label == null)
		data.button1Label = "Play the mod!";
	if(data.button1Url == null)
		data.button1Url = "https://github.com/HELLISH666-warframe/Bamber-and-Davey-unofficial-hot-fix-legacy-dlc";
}