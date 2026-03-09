// MOVED IT HERE SO IT IS LESS MESSY
public var optionsFile:Array<Dynamic> = [ // god help me
    [ // VIDEO
        // [name, desc, ["params", "leave blank if checkbox"], save name],
        ["Framerate", "The framerate that the game will run at.", [30, 60, 90, 120, 150, 180, 210, 240], 'framerate'],
        ["Anti-aliasing", "Toggles smoothing jagged edges on curves and diagonal lines", [], 'antialiasing'],
        ["Pixel Perfect", "", [], 'pixelperfect'],
        ["Resolution", "How many pixels the game renders at", ['854x480',"1280x720",'1920x1080','2560x1440','3840x2160'], 'resolution'],
        #if !mac
        ["Fullscreen", "Toggles the game filling your screen", [], 'fullscreen'],
        #end
        ["Borderless", "Toggles the game window border", [], 'borderless'],
        ["Brightness", "How bright the game is", [], 'brightness'],
        ["Gamma", "The gamma of the game", [], 'gamma']
    ],
    [ // SOUND
        ["Music Volume", "How loud the music is", [], 'musicVolume'],
        ["SFX Volume", "How loud sound effects are", [], 'sfxVolume'],
        ["Voice Volume","How loud the character voices are while playing a song", [], 'voiceVolume'], 
        ["Streamed Music", "Toggles streamed music.", [], 'streamedMusic'],
        ["Streamed Voices", "Toggles streamed voices.", [], 'streamedVocals'],
        ["Miss Sounds", "Toggles playing a sound effect on miss", [], 'missSounds'],
        ["Copyrighted Bypass", "Toggles replacing copyrighted audio with MIDI covers", [], 'copyrightBypass'],
        ["Subtitles", "Toggles words appearing on screen when spoken lyrics are heard", [], 'subtitles'], // can someone refine this description please
    ],
    [ // VISUAL
        ["Low Memory Mode", "Won't load things that could take up a lot of memory.", [], 'lowMemory'],
        ["VRAM Only Sprites", "VRAM-Only Sprites.", [], 'vramSprites'],
        ["Flashing Lights", "Toggles flashes on the screen", [], 'flashingLights'],
        ["Shaders", "What shaders should be shown", ["all", "Some", "None"], 'shaders'],
        ["Botplay UI", "Rather or not the botplay text will be visible.", [], 'botplayUI'],
        ["Background Blur", "Applys Osu! like blur to stage objects.", [], 'bgBlur'],
        ["Background Dim", "Applys Osu! like dim to stage objects.", [], 'bgDim'],
        ["Rapid Camera", "", [], 'rapidCam'],
        ["Timebar", "Toggles the bar that shows how long of the song is left until the end", [], 'timeBar'],
        ["Combo Pos Percent", "",[], 'comboPosPercent'],
        ["Cinematic Bars", "Toggles the bars seen at the top and bottom of the screen during a song", [], 'cinematicBars'],
        ["Health Icons", "Toggles health bar icons", [], 'healthIcons'],
        ["Song Credits", "Toggles the credits popup at the beginning of a song", [], 'songCredits'],
        ["Stamp Keybinds", "Shows keybinds under the your strum.(???)", [], 'stampKeybinds'],
        ["Auto pause", "If checked, switching windows will pause the game.", [], 'autoPause']
    ],
    [ // NOTE OPTIONS
        ["Noteskin", "What the notes appear as", ["Default", "Arrows",'3dcheater','awesome','bfdi','davey_obj','deathbattle','facsimile','funkin','joke_model_obj','night','test footage','trade','undertale'], 'noteskin'],
        ["Note Scale", "How big the notes appear in-game (Default is \"1\")", [1,2,3,4], 'noteScale'], //#
        ["Note Colors", "What color notes appear as", ["Placeholder","placeholder but not captialised."], 'noteColors']
    ],
    [ // Controls
        ["Controls", "Placeholder", ['Open'], 'placeholder']
        /*
        ["Left", "Placeholder", [], 'placeholder'],
        ["Down", "Placeholder", [], 'placeholder'],
        ["Up", "Placeholder", [], 'placeholder'],
        ["Right", "Placeholder", [], 'placeholder'],
        ["Reset", "Placeholder", [], 'placeholder'],
        ["Accept", "Placeholder", [], 'placeholder'],
        ["Back", "Placeholder", [], 'placeholder'],

        ["Volume up", "Placeholder", [], 'placeholder'],
        ["Volume down", "Placeholder", [], 'placeholder'],
        ["Volume mute", "Placeholder", [], 'placeholder'],

        ["Switch mod", "Placeholder", [], 'placeholder'],
        ["Fps counter", "Placeholder", [], 'placeholder'],
        */
    ],
    [ // GAMEPLAY
        ["Coloured Healthbar", "Toggles if  green and red or the char colors will be used.", [], 'coloredBar'],
        ["Modcharts", "Toggles the notes moving around during a song", ['Always', 'Sometimes', 'Never'], 'modcharts'],
        ["Custom Scroll Speed", "Toggles using your custom scroll speed", [], 'scrollSpeed'],
        ["Scroll Speed Speed", "How fast the scroll speed should be for a song", [1,10], 'scrollSpeed_Speed'], // 1 - 10?
        ["Pause Countdown", "Toggles the countdown after unpausing", [], 'pauseCountdown'],
        ["Skip Game Over", "Toggles if gameover will be skipped on death.", [], 'skipGameOver'],
        ["Skip Song Intro", "", [], 'skipSongIntro'],
        ["Scroll Mode", "Where the notes appear on your screen", ["Top", "Bottom"], 'scrollMode'],
        ["Middle Scroll", "Toggles your strum being centered", [], 'middleScroll'],
        ["Ghost Tapping", "Toggles ghost tapping", [], 'ghostTapping'],
        ["Story Mode Dialogue", "Toggles story mode dialogue", [], 'storyDialogue'],
        ["Freeplay Dialogue", "Toggles freeplay dialogue", [], 'freeplayDialogue'],
        ["Song Offset", "Changes the offset that songs should start with.", [], 'cinematicBars'],
    ],
    [ // MISC
	    ["Reset Scores", "Erases ALL song & week scores/achievements", [""], 'gameStats'],
	    ["Reset Options", "Restores all settings to their default", [""], 'idek'],
        ["Reset Misc", "Restores week completion, freeplay tags and stats.", [""], 'idek']
    ]
];

public var controlsOptions:Array<Dynamic> = [ // god help me
    ["Left", "Placeholder", [], 'placeholder'],
    ["Down", "Placeholder", [], 'placeholder'],
    ["Up", "Placeholder", [], 'placeholder'],
    ["Right", "Placeholder", [], 'placeholder'],
    ["Reset", "Placeholder", [], 'placeholder'],
    ["Accept", "Placeholder", [], 'placeholder'],
    ["Back", "Placeholder", [], 'placeholder'],

    ["Volume up", "Placeholder", [], 'placeholder'],
    ["Volume down", "Placeholder", [], 'placeholder'],
    ["Volume mute", "Placeholder", [], 'placeholder'],

    ["Switch mod", "Placeholder", [], 'placeholder'],
    ["Fps counter", "Placeholder", [], 'placeholder']
];