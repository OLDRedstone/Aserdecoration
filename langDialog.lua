local script_name = debug.getinfo(1, "S").source:sub(2)
local script_path = script_name:match("(.*[/\\])")
execute = function(plugin)
    local tempLang = {
        ["en-us"] = assert(loadfile(script_path .. "lang/en-us.lua"))(),
        ["zh-cn"] = assert(loadfile(script_path .. "lang/zh-cn.lua"))(),
        ["ja-jp"] = assert(loadfile(script_path .. "lang/ja-jp.lua"))()
    }


    local currentLang = plugin.preferences.lang
    local langDic = {}
    local langNameList = {}
    local index = 1


    for key, value in pairs(tempLang) do
        langNameList[index] = value.Name
        langDic[value.Name] = key
        index = index + 1
    end


    local function renewDialog()
        LangDialog:modify { title = tempLang[currentLang].LangDialog.Title }
        LangDialog:modify { id = "ok", text = tempLang[currentLang].LangDialog.ok }
        LangDialog:modify {
            id = "lang",
            label = tempLang[currentLang].LangDialog.langCombo.label,
        }
        LangDialog:modify { id = "warn", text = tempLang[currentLang].LangDialog.warn }
    end

    LangDialog = Dialog {
            title = "language",
            notitlebar = false,
            onclose = nil
        }
        :combobox {
            id = "lang",
            option = tempLang[currentLang].Name,
            options = langNameList,
            onchange = function()
                currentLang = langDic[LangDialog.data.lang]
                renewDialog()
            end
        }
        :button {
            id = "ok",
            text = tempLang[currentLang].LangDialog.ok,
            focus = true
        }
        :label {
            id = "warn",
            label = "",
            text = tempLang[currentLang].LangDialog.warn
        }

    LangDialog:show()

    plugin.preferences.lang = currentLang
end
return execute
