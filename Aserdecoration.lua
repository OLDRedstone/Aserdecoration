require("AserdecorationLanguage.ja-jp")
local DecorationData = {}
local sprite = app.sprite
local spr = app.activeSprite
if not spr then
    return app.alert(Language.Error.SaveFile)
end
local path, title = spr.filename:match("^(.+[/\\])(.-).([^.]*)$")
local defaultExpression = {
    character = { "neutral", "happy", "barely", "missed" },
    sprite = { "neutral" }
}
local lang = {
    [Language.Usage.character] = "character",
    [Language.Usage.sprite] = "sprite"
}


local showCompletedExpression = {
    ["character"] = function()
        return table.concat(defaultExpression.character, ", ")
    end,
    ["sprite"] = function()
        return table.concat(defaultExpression.sprite, ", ")
    end
}

-- encode
local switch = {
    ["number"] = function(data)
        return data
    end,
    ["boolean"] = function(data)
        return data
    end,
    ["table"] = function(data)
        return '[' .. table.concat(data, ",") .. ']'
    end,
    ["string"] = function(data)
        return '"' .. data .. '"'
    end
}

function JsonToString(data, maxLengthData)
    local Output = '{'
    local char = ''
    local propertyOrder = { "name", "loop", "fps", "loopStart", "portraitOffset", "portraitSize", "portraitScale",
        "frames" }
    local tos = function(key, value)
        local out = '"' .. key .. '": ' .. switch[type(value)](value)
        return out
    end
    for i = 1, #propertyOrder - 1 do
        Output = Output ..
            tos(propertyOrder[i], data[propertyOrder[i]]) .. ', '
        for j = 1, maxLengthData[propertyOrder[i]] - #tostring(switch[type(data[propertyOrder[i]])](data[propertyOrder[i]])) do
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
    headerData
        :modify { id = "frameTitle", visible = headerData.data.showPic }
        :modify { id = "index", visible = headerData.data.showPic }
    --:modify { id = "preview", visible = headerData.data.showPic }
        :modify { id = "frameOffsetTitle", visible = headerData.data.showPic }
        :modify { id = "rowPreviewOffsetX", visible = headerData.data.showPic }
        :modify { id = "rowPreviewOffsetY", visible = headerData.data.showPic }
end


local averageFps = 0
for _, frame in ipairs(sprite.frames) do
    averageFps = averageFps + frame.duration
end
averageFps = averageFps * 1000 / #sprite.frames


headerData = Dialog {
        title = Language.Dialog.Title,
        notitlebar = false,
        onclose = nil
    }
    :check {
        id = "showPic",
        label = "",
        text = Language.Dialog.showPic,
        selected = false,
        onclick = renewFrameSetWidget
    }
    :separator {
        id = "frameTitle",
        visible = false,
        text = Language.Dialog.Separator[1]
    }
    :slider { id = "index",
        label = Language.Dialog.index,
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
        text = Language.Dialog.Separator[2]
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
        text = Language.Dialog.Separator[3]
    }
    :combobox {
        id = "loopOption",
        label = Language.Dialog.loopOption.label,
        option = Language.Dialog.loopOption.option,
        options = Language.Dialog.loopOption.options,
        onchange = nil
    }
    :combobox {
        id = "loopDirection",
        label = Language.Dialog.loopDirection.label,
        option = Language.Dialog.loopDirection.option,
        options = Language.Dialog.loopDirection.options,
        onchange = nil
    }
    :combobox {
        id = "fpsMethod",
        label = Language.Dialog.fpsMethod.label,
        option = Language.Dialog.fpsMethod.option,
        options = Language.Dialog.fpsMethod.options,
        onchange = function()
            headerData:modify { id = "fpsSet", visible = headerData.data.fpsMethod == "全部更改为" }
        end
    }
    :number {
        id = "fpsSet",
        label = Language.Dialog.fpsSet,
        text = tostring(averageFps),
        visible = false,
        decimals = integer,
        onchange = nil
    }
    :label {
        id = "fpsWarn",
        visible = false,
        label = "",
        text = Language.Dialog.fpsWarn
    }
    :separator {
        text = Language.Dialog.Separator[4]
    }
    :combobox {
        id = "outputMode",
        label = Language.Dialog.outputMode.label,
        option = Language.Dialog.outputMode.option,
        options = Language.Dialog.outputMode.options,
        onchange = nil
    }
    :combobox {
        id = "usage",
        label = Language.Dialog.usage,
        option = Language.Usage.character,
        options = { Language.Usage.character, Language.Usage.sprite },
        onchange = function()
            headerData:modify { id = "spriteWarnContext",
                text = showCompletedExpression[lang[headerData.data.usage]]() }
        end
    }
    :label {
        id = "spriteWarnTitle",
        label = "",
        text = Language.Dialog.spriteWarnTitle
    }
    :label {
        id = "spriteWarnContext",
        label = "",
        text = showCompletedExpression["character"]()
    }
    :separator()
    :button {
        id = "ok",
        text = Language.Dialog.ok,
        focus = true
    }
    :button {
        id = "cancel",
        text = Language.Dialog.cancel
    }

local function process()
    --set outputType
    local outputType
    if headerData.data.outputMode == Language.Dialog.outputMode.options[1] then
        outputType = SpriteSheetType.HORIZONTAL
    elseif headerData.data.outputMode == Language.Dialog.outputMode.options[2] then
        outputType = SpriteSheetType.VERTICAL
    elseif headerData.data.outputMode == Language.Dialog.outputMode.options[3] then
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
    local createDefaultExpression = {}
    if headerData.data.usage == Language.Usage.character then
        createDefaultExpression = defaultExpression.character
    elseif headerData.data.usage == Language.Usage.sprite then
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
        if headerData.data.loopDirection == Language.Dialog.loopDirection.options[1] or
            (headerData.data.loopDirection == Language.Dialog.loopDirection.options[5] and tag.aniDir == AniDir.FORWARD) then
            for j = tag.fromFrame.frameNumber, tag.toFrame.frameNumber do
                frames[#frames + 1] = j - 1
                fps = fps + sprite.frames[j].duration
            end
        elseif headerData.data.loopDirection == Language.Dialog.loopDirection.options[2] or
            (headerData.data.loopDirection == Language.Dialog.loopDirection.options[5] and tag.aniDir == AniDir.REVERSE) then
            for j = tag.toFrame.frameNumber, tag.fromFrame.frameNumber, -1 do
                frames[#frames + 1] = j - 1
                fps = fps + sprite.frames[j].duration
            end
        elseif headerData.data.loopDirection == Language.Dialog.loopDirection.options[3] or
            (headerData.data.loopDirection == Language.Dialog.loopDirection.options[5] and tag.aniDir == AniDir.PING_PONG) then
            for j = tag.fromFrame.frameNumber, tag.toFrame.frameNumber - 1 do
                frames[#frames + 1] = j - 1
                fps = fps + sprite.frames[j].duration
            end
            for j = tag.toFrame.frameNumber, tag.fromFrame.frameNumber + 1, -1 do
                frames[#frames + 1] = j - 1
                fps = fps + sprite.frames[j].duration
            end
        elseif headerData.data.loopDirection == Language.Dialog.loopDirection.options[4] or
            (headerData.data.loopDirection == Language.Dialog.loopDirection.options[5] and tag.aniDir == AniDir.PING_PONG_REVERSE) then
            for j = tag.toFrame.frameNumber, tag.fromFrame.frameNumber + 1, -1 do
                frames[#frames + 1] = j - 1
                fps = fps + sprite.frames[j].duration
            end
            for j = tag.fromFrame.frameNumber, tag.toFrame.frameNumber - 1 do
                frames[#frames + 1] = j - 1
                fps = fps + sprite.frames[j].duration
            end
        end
        if headerData.data.fpsMethod == Language.Dialog.fpsMethod.options[1] then
            fps = 0
        elseif headerData.data.fpsMethod == Language.Dialog.fpsMethod.options[2] then
            fps = fps * 1000 / #frames
        elseif headerData.data.fpsMethod == Language.Dialog.fpsMethod.options[3] then
            fps = headerData.data.fpsSet
        end
        DecorationData[tag.name] = {
            name = tag.name,
            loop = "onBeat",
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
    for _, expression in pairs(DecorationData) do
        OutputJson = OutputJson .. char .. '\t\t' .. JsonToString(expression, maxLength)
        char = ',\n'
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
    return app.alert(Language.Error.Blank)
end

renewFrameSetWidget()
headerData:show()

if headerData.data.ok then
    process()
end
