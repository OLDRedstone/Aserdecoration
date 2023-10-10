local script_name = debug.getinfo(1, "S").source:sub(2)
local script_path = script_name:match("(.*[/\\])")
local setting = assert(loadfile(script_path .. "__pref.lua"))()
if not setting then
    return nil
end
local language = assert(loadfile(script_path .. "lang\\" .. setting.lang .. ".lua"))()

-- encode
local switch = {
    number = function(data)
        return data
    end,
    boolean = function(data)
        return data
    end,
    table = function(data)
        return '[' .. table.concat(data, ",") .. ']'
    end,
    string = function(data)
        return '"' .. data .. '"'
    end
}
local function gcd(a, b)
    if a == b then
        return a
    else
        times = times + 1
        if a > b then
            return gcd(a - b, b)
        else
            return gcd(a, b - a)
        end
    end
end

local function contains(table, key)
    for i = 1, #table do
        if table[i] == key then
            return true
        end
    end
    return false
end

local function gcdList(list)
    for i = 1, #list do
        list[i] = list[i] * 1000
    end
    local temp = list[1]
    for i = 2, #list do
        print(tostring(i) .. "/" .. tostring(#list))
        temp = gcd(temp, list[i])
    end
    return temp / 1000
end

local function sum(list)
    local s = 0
    for i = 1, #list do
        s = s + list[i]
    end
    return s
end

local function keys(table)
    local list = {}
    for key, _ in pairs(table) do
        list[#list + 1] = key
    end
    return list
end

local function values(table)
    local list = {}
    for _, value in pairs(table) do
        list[#list + 1] = value
    end
    return list
end

execute = function()
    local DecorationData = {}
    local sprite = app.sprite
    local spr = app.activeSprite
    if not spr then
        return app.alert(language.Error.SaveFile)
    end
    local path, title = spr.filename:match("^(.+[/\\])(.-).([^.]*)$")
    local defaultExpression = {
        character = { "neutral", "happy", "barely", "missed" },
        sprite = { "neutral" }
    }
    local namedExpression = { "neutral", "happy", "barely", "missed" }
    local lang = {
        [language.Usage.character] = "character",
        [language.Usage.sprite] = "sprite"
    }

    local showCompletedExpression = {
        ["character"] = function()
            return table.concat(defaultExpression.character, ", ")
        end,
        ["sprite"] = function()
            return table.concat(defaultExpression.sprite, ", ")
        end
    }

    function JsonToString(data, maxLengthData)
        local Output = '{'
        local char = ''
        local propertyOrder = {
            "name",
            "loop",
            "fps",
            "loopStart",
            "portraitOffset",
            "portraitSize",
            "portraitScale",
            "frames"
        }
        local tos = function(key, value)
            local out = '"' .. key .. '": ' .. switch[type(value)](value)
            return out
        end
        for i = 1, #propertyOrder - 1 do
            Output = Output ..
                tos(propertyOrder[i], data[propertyOrder[i]]) .. ','
            for j = #tostring(switch[type(data[propertyOrder[i]])](data[propertyOrder[i]])), maxLengthData[propertyOrder[i]] do
                Output = Output .. ' '
            end
        end
        Output = Output ..
            tos(propertyOrder[#propertyOrder], data[propertyOrder[#propertyOrder]])
        return Output .. '}'
    end

    for _, tag in ipairs(spr.tags) do
        for i = 1, #defaultExpression.character do
            if defaultExpression.character[i] == tag.name then
                table.remove(defaultExpression.character, i)
            end
        end
        for i = 1, #defaultExpression.sprite do
            if defaultExpression.sprite[i] == tag.name then
                table.remove(defaultExpression.sprite, i)
            end
        end
    end

    local renewFrameSetWidget = function()
        local visible1 = headerData.data.showPic
        local visible2 = headerData.data.loopOption ==
            language.Dialog.loopOption.options[4]
        headerData
            :modify { id = "frameTitle", visible = visible1 }
            :modify { id = "index", visible = visible1 }
        --:modify { id = "preview", visible = visible }
            :modify { id = "frameOffsetTitle", visible = visible1 }
            :modify { id = "rowPreviewOffsetX", visible = visible1 }
            :modify { id = "rowPreviewOffsetY", visible = visible1 }
            :modify { id = "loopSetTop", visible = visible2 }
            :modify { id = "loopSetBottom", visible = visible2 }
    end

    local decorationLoops = {}
    for i, tag in ipairs(spr.tags) do
        decorationLoops[tag.name] = language.Dialog.loopSetData.options[1]
    end

    local loopLangTrans = {
        [language.Dialog.loopSetData.options[1]] = "onBeat",
        [language.Dialog.loopSetData.options[2]] = "yes",
        [language.Dialog.loopSetData.options[3]] = "no"
    }

    local averageFps = 0
    for _, frame in ipairs(sprite.frames) do
        averageFps = averageFps + frame.duration
    end
    averageFps = averageFps * 1000 / #sprite.frames


    headerData = Dialog {
            title = language.Dialog.Title,
            notitlebar = false,
            onclose = nil
        }
        :check {
            id = "showPic",
            label = "",
            text = language.Dialog.showPic,
            selected = false,
            onclick = renewFrameSetWidget
        }
        :separator {
            id = "frameTitle",
            visible = false,
            text = language.Dialog.Separator[1]
        }
        :slider { id = "index",
            label = language.Dialog.index,
            min = 1,
            max = #sprite.frames,
            visible = false,
            value = 1,
            onchange = nil,
            onrelease = nil }
        -- :canvas {
        --     id = "preview",
        --     width = sprite.width,
        --     height = sprite.height,
        --     visible = false,
        --     onpaint = function(ev)
        --         local gc = ev.context
        --         local img = Image(sprite.width, sprite.height)
        --         for i, layer in ipairs(sprite.layers) do
        --             if not layer then
        --                 img:drawImage(layer:cel(20).image, 0, 0)
        --             end
        --         end
        --         gc:drawImage(img, 0, 0)
        --     end
        -- }
        :separator {
            id = "frameOffsetTitle",
            visible = false,
            text = language.Dialog.Separator[2]
        }
        :number {
            id = "rowPreviewOffsetX",
            text = "0",
            visible = false,
            decimals = integer,
            onchange = nil
        }
        :number {
            id = "rowPreviewOffsetY",
            text = "0",
            visible = false,
            decimals = integer,
            onchange = nil
        }
        :separator {
            text = language.Dialog.Separator[3]
        }
        :combobox {
            id = "loopOption",
            label = language.Dialog.loopOption.label,
            option = language.Dialog.loopOption.option,
            options = language.Dialog.loopOption.options,
            onchange = function()
                local visible = headerData.data.loopOption ==
                    language.Dialog.loopOption.options[4]
                headerData
                    :modify { id = "loopSetTop", visible = visible }
                    :modify { id = "loopSetName", visible = visible }
                    :modify { id = "loopSetData", visible = visible }
                    :modify { id = "loopSetBottom", visible = visible }
            end
        }
        :separator {
            id = "loopSetTop",
            visible = false
        }
        :combobox {
            id = "loopSetName",
            visible = false,
            label = language.Dialog.loopSetName.label,
            option = keys(decorationLoops)[1],
            options = keys(decorationLoops),
            onchange = function()
                headerData
                    :modify { id = "loopSetData", option = decorationLoops[headerData.data.loopSetName] }
            end
        }
        :combobox {
            id = "loopSetData",
            visible = false,
            label = language.Dialog.loopSetData.label,
            option = language.Dialog.loopSetData.option,
            options = language.Dialog.loopSetData.options,
            onchange = function()
                decorationLoops[headerData.data.loopSetName] = headerData.data.loopSetData
            end
        }
        :separator {
            id = "loopSetBottom",
            visible = false
        }
        :combobox {
            id = "loopDirection",
            label = language.Dialog.loopDirection.label,
            option = language.Dialog.loopDirection.option,
            options = language.Dialog.loopDirection.options,
            onchange = nil
        }
        :combobox {
            id = "fpsMethod",
            label = language.Dialog.fpsMethod.label,
            option = language.Dialog.fpsMethod.option,
            options = language.Dialog.fpsMethod.options,
            onchange = function()
                local visible = language.Dialog.fpsMethod.options[4]
                headerData:modify { id = "fpsSet", visible =
                    headerData.data.fpsMethod == visible }
            end
        }
        :number {
            id = "fpsSet",
            label = language.Dialog.fpsSet,
            text = tostring(averageFps),
            visible = false,
            decimals = integer,
            onchange = nil
        }
        :label {
            id = "fpsWarn",
            visible = false,
            label = "",
            text = language.Dialog.fpsWarn
        }
        :separator {
            text = language.Dialog.Separator[4]
        }
        :combobox {
            id = "outputMode",
            label = language.Dialog.outputMode.label,
            option = language.Dialog.outputMode.option,
            options = language.Dialog.outputMode.options,
            onchange = nil
        }
        :combobox {
            id = "usage",
            label = language.Dialog.usage,
            option = language.Usage.character,
            options = { language.Usage.character, language.Usage.sprite },
            onchange = function()
                headerData:modify { id = "spriteWarnContext",
                    text = showCompletedExpression[lang[headerData.data.usage]]() }
            end
        }
        :label {
            id = "spriteWarnTitle",
            label = "",
            text = language.Dialog.spriteWarnTitle
        }
        :label {
            id = "spriteWarnContext",
            label = "",
            text = showCompletedExpression["character"]()
        }
        :separator()
        :button {
            id = "ok",
            text = language.Dialog.ok,
            focus = true
        }
        :button {
            id = "cancel",
            text = language.Dialog.cancel
        }

    local function process()
        --set outputType
        local outputType
        if headerData.data.outputMode == language.Dialog.outputMode.options[1] then
            outputType = SpriteSheetType.HORIZONTAL
        elseif headerData.data.outputMode == language.Dialog.outputMode.options[2] then
            outputType = SpriteSheetType.VERTICAL
        elseif headerData.data.outputMode == language.Dialog.outputMode.options[3] then
            outputType = SpriteSheetType.PACKED
        end

        --set headerData
        local header = '\n\t"size": [' .. sprite.width .. ', ' .. sprite.height .. '],'
        if headerData.data.showPic then
            header = header .. '\n\t"rowPreviewFrame": ' .. headerData.data.index - 1 .. ',\n' ..
                '\t"rowPreviewOffset": [' ..
                headerData.data.rowPreviewOffsetX .. ', ' .. headerData.data.rowPreviewOffsetY .. '], \n'
        end

        --default expressions
        local createDefaultExpression
        if headerData.data.usage == language.Usage.character then
            createDefaultExpression = defaultExpression.character
        elseif headerData.data.usage == language.Usage.sprite then
            createDefaultExpression = defaultExpression.sprite
        end
        for i = 1, #createDefaultExpression do
            DecorationData[createDefaultExpression[i]] = {
                name = createDefaultExpression[i],
                loop = "onBeat",
                fps = 0,
                loopStart = 0,
                portraitOffset = { 25, 25 },
                portraitSize = { 25, 25 },
                portraitScale = 2,
                frames = {}
            }
        end

        --add frames
        for i, tag in ipairs(spr.tags) do
            local frames = {}
            local fps = 0
            local framesFps = {}
            if headerData.data.loopDirection == language.Dialog.loopDirection.options[1] or
                (headerData.data.loopDirection == language.Dialog.loopDirection.options[5] and tag.aniDir ==
                    AniDir.FORWARD) then
                for j = tag.fromFrame.frameNumber, tag.toFrame.frameNumber do
                    frames[#frames + 1] = j - 1
                    framesFps[#framesFps + 1] = sprite.frames[j].duration
                end
            elseif headerData.data.loopDirection == language.Dialog.loopDirection.options[2] or
                (headerData.data.loopDirection == language.Dialog.loopDirection.options[5] and tag.aniDir ==
                    AniDir.REVERSE) then
                for j = tag.toFrame.frameNumber, tag.fromFrame.frameNumber, -1 do
                    frames[#frames + 1] = j - 1
                    framesFps[#framesFps + 1] = sprite.frames[j].duration
                end
            elseif headerData.data.loopDirection == language.Dialog.loopDirection.options[3] or
                (headerData.data.loopDirection == language.Dialog.loopDirection.options[5] and tag.aniDir ==
                    AniDir.PING_PONG) then
                for j = tag.fromFrame.frameNumber, tag.toFrame.frameNumber - 1 do
                    frames[#frames + 1] = j - 1
                    framesFps[#framesFps + 1] = sprite.frames[j].duration
                end
                for j = tag.toFrame.frameNumber, tag.fromFrame.frameNumber + 1, -1 do
                    frames[#frames + 1] = j - 1
                    framesFps[#framesFps + 1] = sprite.frames[j].duration
                end
            elseif headerData.data.loopDirection == language.Dialog.loopDirection.options[4] or
                (headerData.data.loopDirection == language.Dialog.loopDirection.options[5] and tag.aniDir ==
                    AniDir.PING_PONG_REVERSE) then
                for j = tag.toFrame.frameNumber, tag.fromFrame.frameNumber + 1, -1 do
                    frames[#frames + 1] = j - 1
                    framesFps[#framesFps + 1] = sprite.frames[j].duration
                end
                for j = tag.fromFrame.frameNumber, tag.toFrame.frameNumber - 1 do
                    frames[#frames + 1] = j - 1
                    framesFps[#framesFps + 1] = sprite.frames[j].duration
                end
            end
            if headerData.data.fpsMethod == language.Dialog.fpsMethod.options[1] then
                fps = 0
            elseif headerData.data.fpsMethod == language.Dialog.fpsMethod.options[2] then
                fps = sum(framesFps) * 1000 / #frames
            elseif headerData.data.fpsMethod == language.Dialog.fpsMethod.options[3] then
                local base = gcdList(framesFps) * 1000
                fps = base
                for j = #frames, 1, -1 do
                    for k = 1, framesFps[j] / base - 1 do
                        table.insert(frames, j, frames[j])
                    end
                end
            elseif headerData.data.fpsMethod == language.Dialog.fpsMethod.options[4] then
                fps = headerData.data.fpsSet
            end
            local loop
            if headerData.data.loopOption == language.Dialog.loopOption.options[4] then
                loop = loopLangTrans[decorationLoops[tag.name]]
            else
                loop = loopLangTrans[headerData.data.loopOption]
            end
            DecorationData[tag.name] = {
                name = tag.name,
                loop = loop,
                fps = fps,
                loopStart = 0,
                portraitOffset = { 25, 25 },
                portraitSize = { 25, 25 },
                portraitScale = 2,
                frames = frames
            }
        end

        --pack into json
        local OutputJson = ''
        local maxLength = {
            name = 0,
            loop = 0,
            fps = 0,
            loopStart = 0,
            portraitOffset = 0,
            portraitSize = 0,
            portraitScale = 0,
            frames = 0
        }
        for _, expression in pairs(DecorationData) do
            for key, value in pairs(expression) do
                if maxLength[key] < #tostring(switch[type(value)](value)) then
                    maxLength[key] = #tostring(switch[type(value)](value))
                end
            end
        end
        local char = ''
        for i = 1, #namedExpression do
            if DecorationData[namedExpression[i]] then
                OutputJson = OutputJson ..
                    char .. '\t\t' .. JsonToString(DecorationData[namedExpression[i]], maxLength)
                char = ',\n'
            end
        end
        char = ',\n'
        for expressionName, expression in pairs(DecorationData) do
            if not contains(namedExpression, expressionName) then
                OutputJson = OutputJson .. char .. '\t\t' .. JsonToString(expression, maxLength)
            end
        end
        OutputJson = '{' .. header .. '\t"clips": [\n' .. OutputJson .. '\n\t]\n}'

        --output png file
        app.command.ExportSpriteSheet {
            ui = false,
            type = outputType,
            textureFilename = path .. '/' .. title .. '.png',
            ignoreLayer = "outline"
        }

        --output json file
        js = io.open(path .. '/' .. title .. '.json', "w")
        io.output(js)
        io.write(OutputJson)
        io.close()
    end

    if not path or not title then
        return app.alert(language.Error.Blank)
    end

    renewFrameSetWidget()
    headerData:show()

    if headerData.data.ok then
        process()
    end
end
return execute
