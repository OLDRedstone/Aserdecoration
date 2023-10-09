function init(plugin)
    if app.apiVersion < 23 then
        print("The version is too old,")
        print("please upgrade to v1.3-rc3 or later.")
        return
    end
    local script_name = debug.getinfo(1, "S").source:sub(2)
    local script_path = script_name:match("(.*[/\\])")
    if plugin.preferences.lang == nil then
        plugin.preferences.lang = "en-us"
        local Execution = assert(loadfile(script_path .. "langDialog.lua"))()
        Execution(plugin)
    end
    local tempLang = {
        ["en-us"] = assert(loadfile(script_path .. "lang/en-us.lua"))(),
        ["zh-cn"] = assert(loadfile(script_path .. "lang/zh-cn.lua"))(),
        ["ja-jp"] = assert(loadfile(script_path .. "lang/ja-jp.lua"))()
    }
    local currentLang = plugin.preferences.lang
    plugin:newCommand {
        id = "Aserdecoration",
        title = tempLang[currentLang].menuTitle,
        group = "file_export_1",
        onclick = function()
            local Execution = assert(loadfile(script_path .. "Aserdecoration.lua"))()
            Execution()
        end
    }
    plugin:newCommand {
        id = "AserdecorationLang",
        title = tempLang[currentLang].changeLangMenuTitle,
        group = "view_controls",
        onclick = function()
            local Execution = assert(loadfile(script_path .. "langDialog.lua"))()
            Execution(plugin)
        end
    }
end

function exit(plugin)
    local script_name = debug.getinfo(1, "S").source:sub(2)
    local script_path = script_name:match("(.*[/\\])")
    local tempLang = assert(loadfile(script_path .. "lang\\" .. plugin.preferences.lang .. ".lua"))()
    print(tempLang.successfulExit)
end
