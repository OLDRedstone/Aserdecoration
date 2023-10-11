-- Translation by RaYmondCheung
-- Translation verifed by
return {
    menuTitle = "Export Rhythm Doctor Sprite",
    changeLangMenuTitle = "Change Aserdecoration language",
    Name = "English (United States)",
    Id = "en-us",
    LangDialog = {
        Title = "Language",
        langCombo = {
            label = "Select your language"
        },
        ok = "OK",
        warn = "Restart to take effect"
    },
    Error = {
        SaveFile = "Please open an existing file.",
        Blank = "Please save the file or open a saved file."
    },
    Usage = {
        character = "Character",
        sprite = "Sprite"
    },
    Dialog = {
        Separator = {
            "Preview frame",
            "Preview frame offset",
            "Animation and frame rate",
            "Export"
        },
        Title = "Sprite export options",
        showPic = "Frame Preview",
        frameTitle = "Preview frame",
        index = "Frame number",
        loopOption = {
            label = "Loop settings",
            option = "Loop by beat",
            options = {
                "Loop by beat",
                "Always (beat-independent)",
                "Single pass, no loop",
                "Let me decide"
            },
        },
        loopSetName = {
            label = "Select expression",
        },
        loopSetData = {
            label = "Expression loop",
            options = {
                "Loop by beat",
                "Always (beat-independent)",
                "Single pass, no loop"
            },
        },
        loopDirection = {
            label = "Loop direction",
            option = "Follow Aseprite",
            options = {
                "Forward",
                "Reverse",
                "Ping-pong",
                "Ping-pong Reverse",
                "Follow Aseprite"
            },
        },
        fpsMethod = {
            label = "Frame rate settings",
            option = "Disabled",
            options = {
                "Disabled",
                "Averaging by frame duration",
                "Try to get duplicate frames by frame duration",
                "Change all to"
            },
        },
        fpsSet = "fps",
        fpsWarn = "Sprite will plays back to the default expression",
        outputMode = {
            label = "Arrangement",
            option = "Packed",
            options = {
                "Horizontal only",
                "Vertical only",
                "Packed"
            },
        },
        usage = "Type",
        spriteWarnTitle = "Automatically fill in following blank expressions:",
        ok = "OK",
        cancel = "Cancel",
    },
    successfulExit = "Exit successfully"
}
