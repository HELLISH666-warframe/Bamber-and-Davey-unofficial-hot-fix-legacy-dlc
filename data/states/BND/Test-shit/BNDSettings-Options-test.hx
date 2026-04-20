// MOVED IT HERE SO IT IS LESS MESSY
public var optionsFile:Array<Dynamic> = [ // god help me
    [ // VIDEO
        // [name, desc, ["params", "leave blank if checkbox"], save name],
        ["Framerate", "The framerate that the game will run at.", [30,60,90,120,150,180,210,240], 'framerate','Choice'],
        ["Anti-aliasing", "Toggles smoothing jagged edges on curves and diagonal lines", [], 'antialiasing','Bool'],
        ["Pixel Perfect", "", [], 'pixelperfect','Bool'],
        ["Resolution", "How many pixels the game renders at", ['854x480',"1280x720",'1920x1080','2560x1440','3840x2160'], 'resolution','Choice'],
        #if !mac
        //MacOs can fullscreen whenever so why have it available?
        ["Fullscreen", "Toggles the game filling your screen", [], 'fullscreen','Bool'],
        #end
        ["Borderless", "Toggles the game window border", [], 'borderless','Bool'],
        ["Brightness", "How bright the game is", [-200,200], 'brightness','Int'],
        ["Gamma", "The gamma of the game", [0.1,5], 'gamma','Float']
    ],
    [ // SOUND
        ["Music Volume", "How loud the music is", [0,100], 'musicVolume','Int'],
        ["SFX Volume", "How loud sound effects are", [0,100], 'sfxVolume','Int'],
        ["Voice Volume","How loud the character voices are while playing a song", [0,100], 'voiceVolume','Int'], 
        ["Streamed Music", "Toggles streamed music.", [], 'streamedMusic','Bool'],
        ["Streamed Voices", "Toggles streamed voices.", [], 'streamedVocals','Bool'],
        ["Miss Sounds", "Toggles playing a sound effect on miss", [], 'missSounds','Bool'],
        ["Copyrighted Bypass", "Toggles replacing copyrighted audio with MIDI covers", [], 'copyrightBypass','Bool'],
        ["Subtitles", "Toggles words appearing on screen when spoken lyrics are heard", [], 'subtitles','Bool'], // can someone refine this description please
    ],
    [ // VISUAL
        ["Low Memory Mode", "Won't load things that could take up a lot of memory.", [], 'lowMemory','Bool'],
        ["VRAM Only Sprites", "VRAM-Only Sprites.", [], 'vramSprites','Bool'],
        ["Flashing Lights", "Toggles flashes on the screen", [], 'flashingLights','Bool'],
        ["Shaders", "What shaders should be shown", ["all", "Some", "None"], 'shaders','Choice'],
        ["Botplay UI", "Rather or not the botplay text will be visible.", [], 'botplayUI','Bool'],
        ["Background Blur", "Applys Osu! like blur to stage objects.", [], 'bgBlur','Bool'],
        ["Background Dim", "Applys Osu! like dim to stage objects.", [], 'bgDim','Bool'],
        ["Rapid Camera", "", [], 'rapidCam','Bool'],
        ["Timebar", "Toggles the bar that shows how long of the song is left until the end", [], 'timeBar','Bool'],
        ["Combo Pos Percent", "",[], 'comboPosPercent','Bool'],
        ["Cinematic Bars", "Toggles the bars seen at the top and bottom of the screen during a song", [], 'cinematicBars','Bool'],
        ["Health Icons", "Toggles health bar icons", [], 'healthIcons','Bool'],
        ["Song Credits", "Toggles the credits popup at the beginning of a song", [], 'songCredits','Bool'],
        ["Stamp Keybinds", "Shows keybinds under the your strum.(???)", [], 'stampKeybinds','Bool'],
        ["Auto pause", "If checked, switching windows will pause the game.", [], 'autoPause','Bool']
    ],
    [ // NOTE OPTIONS
        ["Noteskin", "What the notes appear as", ['Default','Arrows','3dcheater','awesome','bfdi','davey_obj','deathbattle','facsimile','funkin','joke_model_obj','night','test footage','trade','undertale'], 'noteskin','Choice'],
        ["Note Scale", "How big the notes appear in-game (Default is \"1\")", [0.1,10], 'noteScale','Float'], //#
        ["Note Colors", "What color notes appear as", ["Placeholder","placeholder but not captialised."], 'noteColors','Wip']//Have_a_substate_for_it?
    ],
    [ // Controls
        ["Controls", "Placeholder", ['Open'], 'placeholder','Wip']
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
        ["Coloured Healthbar", "Toggles if  green and red or the char colors will be used.", [], 'coloredBar','Bool'],
        ["Modcharts", "Toggles the notes moving around during a song", ['Always','Sometimes','Never'], 'modcharts','Choice'],
        ["Custom Scroll Speed", "Toggles using your custom scroll speed", [], 'scrollSpeed','Bool'],
        ["Scroll Speed Speed", "How fast the scroll speed should be for a song", [0.1,10], 'scrollSpeed_Speed','Float'], // 1 - 10?
        ["Pause Countdown", "Toggles the countdown after unpausing", [], 'pauseCountdown','Bool'],
        ["Skip Game Over", "Toggles if gameover will be skipped on death.", [], 'skipGameOver','Bool'],
        ["Skip Song Intro", "", [], 'skipSongIntro','Bool'],
        ["Scroll Mode", "Where the notes appear on your screen", ['Top','Bottom'], 'scrollMode','Choice'],
        ["Middle Scroll", "Toggles your strum being centered", [], 'middleScroll','Bool'],
        ["Ghost Tapping", "Toggles ghost tapping", [], 'ghostTapping','Bool'],
        ["Story Mode Dialogue", "Toggles story mode dialogue", [], 'storyDialogue','Bool'],
        ["Freeplay Dialogue", "Toggles freeplay dialogue", [], 'freeplayDialogue','Bool'],
        ["Song Offset", "Changes the offset that songs should start with.", [-5000,5000], 'songOffset','Int'],
    ],
    [ // MISC
        //Add_an_if_statament_for_dev_shit_later.
        ["Resizable Editors", "If checked, this will allow the editors to render beyond the base 1280x720.", [], 'editorResize','Bool'],
        ["Bypass Editor Resize", "Disables the minimum resolution for resizing editors (Needs Resizable Editors To Be Enabled)", [], 'skipGameOver','Bool'],
        ["Editor SFXs", "If checked, will play sound effects when working on editors (ex: will play sfxs when checking checkboxes...)", [], 'skipGameOver','Bool'],
	    ["Reset Scores", "Erases ALL song & week scores/achievements", [""], 'gameStats'],
        ["Chart Pretty Print", "If checked, the saved files from the chart editor will be formatted to be easily viewable", [], 'skipGameOver','Bool'],
        ["Character Pretty Print", "If checked, the saved files from the character editor will be formatted to be easily viewable", [], 'skipGameOver','Bool'],
        ["Stage Pretty Print", "If checked, the saved files from the stage editor will be formatted to be easily viewable", [], 'skipGameOver','Bool'],
        ["Intensive Blur(editor)", "If checked, will use more intensive blur that may be laggier but look better.", [], 'skipGameOver','Bool'],
        ["Editor Autosaves", "If checked, this will autosave your files in the editor, with the settings listed below.", [], 'skipGameOver','Bool'],
        ["Autosaving Time", "This controls how often the editor will autosave your file (in seconds...)", [60,600], 'skipGameOver','Int'],
        ["Save Warning Time", "If checked, this will autosave your file in a separate folder with a time stamp instead of overriding your current file. (song/autosaves/)", [0,15], 'skipGameOver','Int'],
        ["Offset in Charter", "If checked, this will enable the Song Offset option in the Chart Editor too.", [], 'skipGameOver','Bool'],
	    ["Reset Options", "Restores all settings to their default", [""], 'idek'],
        ["Reset Misc", "Restores week completion, freeplay tags and stats.", [""], 'idek']
    ]
];