local function findLang(langId, plugin)
    local langPath = plugin.path .. "\\lang\\" .. langId .. ".lua"
    local lang = dofile(langPath)
    return lang
end


LangDialogShowing = function(plugin)
    local langId = plugin.preferences.lang
    ---@type table<string, table<string, string>>
    local langDict = {}
    local langNames = {}
    local index = 1

    local Langs =  {
        ["en-us"] = findLang("en_us", plugin),
        ["zh_cn"] = findLang("zh_cn", plugin),
        ["ja_jp"] = findLang("ja_jp", plugin),
    }

    for _, value in pairs(Langs) do
        langDict[value["language.name"]] = { name = value["language.name"], id = value["language.id"] }
        langNames[index] = value["language.name"]
        index = index + 1
    end

    local function renewDialog()
        LangDialog:modify { title = findLang(langId, plugin)["dialog.language.title"] }
        LangDialog:modify { id = "ok", text = findLang(langId, plugin)["dialog.language.ok"] }
        LangDialog:modify { id = "lang", label = findLang(langId, plugin)["dialog.language.label"], }
    end

    LangDialog = Dialog {
            title = findLang(langId, plugin)["dialog.language.title"],
            notitlebar = false,
            onclose = function()
                plugin.preferences.lang = langId
            end
        }
        :combobox {
            id = "lang",
            option = findLang(langId, plugin)["language.name"],
            options = langNames,
            onchange = function()
                langId = langDict[LangDialog.data.lang].id
                renewDialog()
            end
        }
        :button {
            id = "ok",
            text = findLang(langId, plugin)["dialog.language.ok"],
            focus = true
        }

    LangDialog:show()
end

DecoDialogShowing = function(plugin)
    local langId = plugin.preferences.lang
    local lang = findLang(langId, plugin)
    local showingFrame = 0
    local showingFrameBorder = 2
    local currentSprite = app.sprite

    ---@class Expression
    ---@field name string
    ---@field loop string
    ---@field fps number
    ---@field loopStart integer
    ---@field portraitOffset integer[]
    ---@field portraitSize integer[]
    ---@field portraitScale number
    ---@field frames integer[]
    ---@field frameDurationData FrameInfo[]

    ---@class FrameInfo
    ---@field frame integer
    ---@field duration number

    if not currentSprite then
        app.alert {
            title = lang["error.title"],
            text = lang["error.blank"],
            buttons = { lang["dialog.main.ok"] }
        }
        return
    elseif currentSprite.isModified then
        app.alert {
            title = lang["error.title"],
            text = lang["error.saveFile"],
            buttons = { lang["dialog.main.ok"] }
        }
        return
    elseif #currentSprite.tags == 0 then
        app.alert {
            title = lang["error.title"],
            text = lang["error.noTag"],
            buttons = { lang["dialog.main.ok"] }
        }
        return
    end
    LoopType = {
        Beat = 1,
        Loop = 2,
        NoLoop = 3,
        Custom = 4
    }
    RDLoopTypeTranslation = {
        [LoopType.Beat] = "onBeat",
        [LoopType.Loop] = "yes",
        [LoopType.NoLoop] = "no",
    }

    PackMode = {
        HorizontalLine = 1,
        VerticalLine = 2,
        Pack = 3
    }
    FpsType = {
        Disabled = 1,
        Average = 2,
        TagAverage = 3,
        Auto = 4,
        ChangeTo = 5
    }

    local enumLocalization = {}
    enumLocalization = {
        AniDir = {
            [AniDir.FORWARD] = lang["option.anidir.forward"],
            [AniDir.REVERSE] = lang["option.anidir.backward"],
            [AniDir.PING_PONG] = lang["option.aniDir.ping_pong"],
            [AniDir.PING_PONG_REVERSE] = lang["option.anidir.ping_pong_reverse"],
        },

        LoopType = {
            [LoopType.Beat] = lang["option.loop.beat"],
            [LoopType.Loop] = lang["option.loop.loop"],
            [LoopType.NoLoop] = lang["option.loop.no"],
            [LoopType.Custom] = lang["option.loop.custom"],
        },

        PackMode = {
            [PackMode.HorizontalLine] = lang["option.pack.horizontalLine"],
            [PackMode.VerticalLine] = lang["option.pack.verticalLine"],
            [PackMode.Pack] = lang["option.pack.pack"],
        },

        FpsType = {
            [FpsType.Disabled] = lang["option.fps.disabled"],
            [FpsType.Average] = lang["option.fps.average"],
            [FpsType.TagAverage] = lang["option.fps.tagAverage"],
            [FpsType.Auto] = lang["option.fps.auto"],
            [FpsType.ChangeTo] = lang["option.fps.changeTo"],
        },

        keyOf = function(type, value)
            for k, v in pairs(enumLocalization[type]) do
                if v == value then
                    return k
                end
            end
            return nil
        end,
    }

    ---@generic TKey
    ---@param table table<TKey, any>
    ---@return TKey[]
    function table.keys(table)
        local list = {}
        for key, _ in pairs(table) do
            list[#list + 1] = key
        end
        return list
    end

    ---@generic TValue
    ---@param table table<any, TValue>
    ---@return TValue[]
    function table.values(table)
        local list = {}
        for _, value in pairs(table) do
            list[#list + 1] = value
        end
        return list
    end

    ---@generic TKey, TValue
    ---@param table table<TKey, TValue>
    ---@param value TValue
    ---@return TKey|nil
    function table.keyOf(table, value)
        for k, v in pairs(table) do
            if v == value then
                return k
            end
        end
        return nil
    end

    ---@generic TValue
    ---@param table TValue[]
    ---@param func fun(value: TValue): boolean
    ---@return integer|nil
    function table.indexOf(table, func)
        for k, v in pairs(table) do
            if func(v) then
                return k
            end
        end
        return nil
    end

    ---@param value string
    ---@return string|nil
    function lang.keyOf(value)
        for k, v in pairs(lang) do
            if v == value then
                return k
            end
        end
        return nil
    end

    ---@generic TKey, TValue
    ---@param table table<TKey, TValue>
    ---@param func fun(value: TValue): boolean
    ---@return boolean
    function table.any(table, func)
        for _, v in pairs(table) do
            if func(v) then
                return true
            end
        end
        return false
    end

    ---@generic TKey, TValue
    ---@param table table<TKey, TValue>
    ---@param value TValue
    ---@return boolean
    function table.contains(table, value)
        for _, v in pairs(table) do
            if v == value then
                return true
            end
        end
        return false
    end

    ---@param a number
    ---@param b number
    ---@return number
    local function gcd(a, b)
        if a == b then
            return a
        else
            if a > b then
                return gcd(a - b, b)
            else
                return gcd(a, b - a)
            end
        end
    end

    ---@param list table<integer, number>
    ---@return number|nil, integer|nil
    local function gcdList(list)
        for i = 1, #list do
            if list[i] == 0 then
                return nil, i
            end
            list[i] = list[i] * 1000
        end
        local temp = list[1]
        for i = 2, #list do
            temp = gcd(temp, list[i])
        end
        return temp / 1000
    end

    ---@param value any
    ---@return string
    local function serialize(value, isInteger)
        if type(value) == "number" then
            if not isInteger then
                 value = math.floor(value * 100 + 0.5) / 100
            end
            return tostring(value)
        elseif type(value) == "boolean" then
            return tostring(value)
        elseif type(value) == "string" then
            return '"' .. value .. '"'
        elseif type(value) == "table" then
            return '[' .. table.concat(value, ",") .. ']'
        elseif type(value) == "nil" then
            return "null"
        else
            return tostring(value)
        end
    end

    ---comment
    ---@param data Expression
    ---@param maxLengthData table<string, integer>
    ---@return string
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
            local out = '"' .. key .. '": ' .. serialize(value, key == "loopStart")
            return out
        end
        for i = 1, #propertyOrder - 1 do
            Output = Output ..
                tos(propertyOrder[i], data[propertyOrder[i]]) .. ','
            for j = #tostring(serialize(data[propertyOrder[i]])), maxLengthData[propertyOrder[i]] do
                Output = Output .. ' '
            end
        end
        Output = Output ..
            tos(propertyOrder[#propertyOrder], data[propertyOrder[#propertyOrder]])
        return Output .. '}'
    end

    local function updateDialog(dialog, config)
        local previewSettingsVisible = dialog.data.showPreview
        local loopOptionIndividuallyVisible = dialog.data.loopOption ==
            lang["option.loop.custom"]
        if previewSettingsVisible then
            showingFrame = dialog.data.showPreviewIndex
        else
            showingFrame = 0
        end
        config.previewFrame = showingFrame
        dialog:repaint()

        dialog
            :modify { id = "showPreviewFrameTitleSeparator", visible = previewSettingsVisible }
            :modify { id = "preview", visible = previewSettingsVisible }
            :modify { id = "showPreviewIndex", visible = previewSettingsVisible }
            :modify { id = "rowPreviewOffsetX", visible = previewSettingsVisible }
            :modify { id = "rowPreviewOffsetY", visible = previewSettingsVisible }

            :modify { id = "loopOptionIndividuallyTop", visible = loopOptionIndividuallyVisible }
            :modify { id = "loopOptionIndividuallyName", visible = loopOptionIndividuallyVisible }
            :modify { id = "loopOptionIndividuallyData", visible = loopOptionIndividuallyVisible }
            :modify { id = "loopOptionIndividuallyBottom", visible = loopOptionIndividuallyVisible }
    end

    ---@return config
    local function initConfig()
        ---@class config
        local config = {
            previewFrame = 0, -- 0 for no preview
            previewFrameOffsetX = 0,
            previewFrameOffsetY = 0,
            loopOption = LoopType.Beat,
            fpsOption = FpsType.Auto,
            fpsSet = 0,
            outputMode = PackMode.Pack,
            ---@type ConfigExpression[]
            expressions = {},
        }
        config.expressionNames = function()
            local names = {}
            for i, tag in ipairs(config.expressions) do
                names[i] = tag.decoNameFrame
            end
            return names
        end
        config.getExpressionByNameFrame = function(nameFrame)
            for i, expression in ipairs(config.expressions) do
                if expression.decoNameFrame == nameFrame then
                    return config.expressions[i]
                end
            end
            return nil
        end
        ---@return Expression[]
        config.getPackedExpressions = function()
            ---@type Expression[]
            local packedExpressions = {}
            local sum = 0
            for i, expression in ipairs(config.expressions) do
                local previousFrameCount = 0
                ---@type FrameInfo[]
                local allFrames = expression.compressedFrames
                local index = table.indexOf(packedExpressions, function(v)
                    return v.name == expression.name
                end)
                if index then
                    previousFrameCount = #packedExpressions[index].frames
                    local newTable = {}
                    for _, frameinfo in ipairs(packedExpressions[index].frameDurationData) do
                        newTable[#newTable + 1] = frameinfo
                    end
                    for _, frameinfo in ipairs(allFrames) do
                        newTable[#newTable + 1] = frameinfo
                    end
                    allFrames = newTable
                else
                    sum = sum + 1
                    index = sum
                    packedExpressions[index] = {
                        name = expression.name,
                        loop = RDLoopTypeTranslation[expression.loop],
                        loopStart = 0,
                        portraitOffset = { config.previewFrameOffsetX, config.previewFrameOffsetY },
                        portraitSize = { currentSprite.width, currentSprite.height },
                        portraitScale = 2,
                        frames = {},
                        fps = 0,
                        frameDurationData = allFrames,
                    }
                end
                local fps = 0
                local frames = {}
                local fpsOption = config.fpsOption
                if fpsOption == FpsType.Disabled or fpsOption == FpsType.Average then
                    for _, frameinfo in ipairs(allFrames) do
                        frames[#frames + 1] = frameinfo.frame - 1
                    end
                elseif fpsOption == FpsType.TagAverage then
                    local duration = 0
                    for _, frameinfo in ipairs(allFrames) do
                        frames[#frames + 1] = frameinfo.frame - 1
                        duration = duration + frameinfo.duration
                    end
                    fps = 1 / (duration / #allFrames)
                elseif fpsOption == FpsType.Auto then
                    local duration = 0
                    local durations = {}
                    for _, frameinfo in ipairs(allFrames) do
                        duration = duration + frameinfo.duration
                        durations[#durations + 1] = frameinfo.duration
                    end
                    local gcd0, err = gcdList(durations)
                    if err then
                        error(lang["error.frameZero"])
                    end
                    for _, frameinfo in ipairs(allFrames) do
                        for _ = 1, frameinfo.duration / gcd0 do
                            frames[#frames + 1] = frameinfo.frame - 1
                        end
                    end
                    fps = 1 / gcd0
                elseif fpsOption == FpsType.ChangeTo then
                    for _, frameinfo in ipairs(allFrames) do
                        frames[#frames + 1] = frameinfo.frame - 1
                    end
                    fps = config.fpsSet
                end
                packedExpressions[index].fps = fps
                packedExpressions[index].frames = frames
                packedExpressions[index].loopStart = previousFrameCount
                packedExpressions[index].frameDurationData = allFrames
                index = index + 1
            end
            if config.fpsOption == FpsType.Average then
                local duration = 0
                local frameCount = 0
                for _, expression in ipairs(config.expressions) do
                    for _, frameinfo in ipairs(expression.compressedFrames) do
                        duration = duration + frameinfo.duration
                    end
                    frameCount = frameCount + #expression.compressedFrames
                end
                local fps = 1 / (duration / #config.expressions)
                for _, expression in ipairs(config.expressions) do
                    packedExpressions[expression.name].fps = fps
                end
            end
            return packedExpressions
        end

        for i, tag in ipairs(currentSprite.tags) do
            local loopType = LoopType.Beat
            if tag.repeats == 1 or (tag.repeats == 2 and (tag.aniDir == AniDir.PING_PONG or tag.aniDir == AniDir.PING_PONG_REVERSE)) then
                loopType = LoopType.NoLoop
            end
            ---@class ConfigExpression
            config.expressions[i] = {
                name = tag.name,
                fromFrame = tag.fromFrame.frameNumber,
                toFrame = tag.toFrame.frameNumber,
                loop = loopType,
                loopDirection = tag.aniDir,
                decoNameFrame = tag.name .. '[' .. tag.fromFrame.frameNumber .. '..' .. tag.toFrame.frameNumber .. ']',
                getFrames = function()
                    local frames = {}
                    local from = config.expressions[i].fromFrame
                    local to = config.expressions[i].toFrame
                    if config.expressions[i].loopDirection == AniDir.FORWARD then
                        for j = from, to do
                            frames[#frames + 1] = j
                        end
                    elseif config.expressions[i].loopDirection == AniDir.REVERSE then
                        for j = to, from, -1 do
                            frames[#frames + 1] = j
                        end
                    elseif config.expressions[i].loopDirection == AniDir.PING_PONG then
                        for j = from, to - 1 do
                            frames[#frames + 1] = j
                        end
                        for j = to, from + 1, -1 do
                            frames[#frames + 1] = j
                        end
                    elseif config.expressions[i].loopDirection == AniDir.PING_PONG_REVERSE then
                        for j = to, from + 1, -1 do
                            frames[#frames + 1] = j
                        end
                        for j = from, to - 1 do
                            frames[#frames + 1] = j
                        end
                    end
                    return frames
                end
            }
        end

        return config
    end

    local function drawFrame(sprite, gc, frame, position)
        local function drawFrameLayer(g, f, l, p)
            if l.isVisible then
                if l.isGroup then
                    for _, sl in ipairs(l.layers) do
                        drawFrameLayer(g, f, sl, p)
                    end
                elseif l.isImage then
                    local cel = l:cel(f)
                    if cel then
                        g:drawImage(cel.image, p.x + cel.position.x, p.y + cel.position.y)
                    end
                end
            end
        end
        for _, layer in ipairs(sprite.layers) do
            drawFrameLayer(gc, frame, layer, position)
        end
    end

    local function createDialog(config)
        local dlg = Dialog {
            title = lang["dialog.main.title"],
        }
        dlg
            :check {
                id = "showPreview",
                text = lang["dialog.main.showPreview"],
                onclick = function()
                    updateDialog(dlg, config)
                end
            }
            :separator {
                id = "showPreviewFrameTitleSeparator",
                visible = false,
            }
            :slider {
                id = "showPreviewIndex",
                label = lang["dialog.main.previewFrame"],
                min = 1,
                max = #currentSprite.frames,
                visible = false,
                value = 1,
                onchange = function()
                    showingFrame = dlg.data.showPreviewIndex
                    dlg:repaint()
                end,
                onrelease = nil
            }
            :canvas {
                id = "preview",
                label = "",
                visible = false,
                width = currentSprite.width + showingFrameBorder * 2,
                height = currentSprite.height + showingFrameBorder * 2,
                onpaint = function(ev)
                    local gc = ev.context
                    gc:drawThemeRect("sunken_normal",
                        Rectangle(0, 0, currentSprite.width + showingFrameBorder * 2,
                            currentSprite.height + showingFrameBorder * 2))
                    if showingFrame == 0 then
                        return
                    end
                    drawFrame(currentSprite, gc, showingFrame, Point(showingFrameBorder, showingFrameBorder))

                    local px = dlg.data.rowPreviewOffsetX + currentSprite.width / 2
                    local py = dlg.data.rowPreviewOffsetY + currentSprite.height / 2
                    gc.color = Color { r = 255, g = 0, b = 0, a = 255 }
                    gc:beginPath()
                    if showingFrameBorder < px and px <= currentSprite.width - showingFrameBorder then
                        gc:moveTo(showingFrameBorder + px, showingFrameBorder)
                        gc:lineTo(showingFrameBorder + px, currentSprite.height + showingFrameBorder)
                    end
                    if showingFrameBorder < py and py <= currentSprite.height - showingFrameBorder then
                        gc:moveTo(showingFrameBorder, showingFrameBorder + py)
                        gc:lineTo(currentSprite.width + showingFrameBorder, showingFrameBorder + py)
                    end
                    if showingFrameBorder < px and px <= currentSprite.width - showingFrameBorder and showingFrameBorder < py and py <= currentSprite.height - showingFrameBorder then
                        gc:rect(Rectangle(px + 1, py + 1, 2, 2))
                    end
                    gc:closePath()
                    gc:stroke()
                end,
                onmousedown = function(ev)
                    if ev.button == MouseButton.LEFT then
                        dlg:modify { id = "rowPreviewOffsetX", text = ev.x - currentSprite.width / 2 - showingFrameBorder }
                        dlg:modify { id = "rowPreviewOffsetY", text = ev.y - currentSprite.height / 2 - showingFrameBorder }
                        config.previewFrameOffsetX = dlg.data.rowPreviewOffsetX
                        config.previewFrameOffsetY = dlg.data.rowPreviewOffsetY
                        dlg:repaint()
                    end
                end,
                onmousemove = function(ev)
                    if ev.button == MouseButton.LEFT then
                        dlg
                            :modify { id = "rowPreviewOffsetX", text = ev.x - currentSprite.width / 2 - showingFrameBorder }
                            :modify { id = "rowPreviewOffsetY", text = ev.y - currentSprite.height / 2 - showingFrameBorder }
                        config.previewFrameOffsetX = dlg.data.rowPreviewOffsetX
                        config.previewFrameOffsetY = dlg.data.rowPreviewOffsetY
                        dlg:repaint()
                    end
                end
            }
            :number {
                id = "rowPreviewOffsetX",
                label = lang["dialog.main.previewFrameOffset"],
                text = "0",
                decimals = integer,
                onchange = function()
                    dlg:repaint()
                    config.previewFrameOffsetX = dlg.data.rowPreviewOffsetX
                end
            }
            :number {
                id = "rowPreviewOffsetY",
                text = "0",
                decimals = integer,
                onchange = function()
                    dlg:repaint()
                    config.previewFrameOffsetY = dlg.data.rowPreviewOffsetY
                end
            }
            :separator {
                text = lang["dialog.main.separator.expression"]
            }
            :combobox {
                id = "loopOption",
                label = lang["dialog.main.loopOption.label"],
                option = enumLocalization.LoopType[config.loopOption],
                options = {
                    lang["option.loop.beat"],
                    lang["option.loop.loop"],
                    lang["option.loop.no"],
                    lang["option.loop.custom"]
                },
                onchange = function()
                    config.loopOption = enumLocalization.keyOf("LoopType", dlg.data.loopOption)
                    updateDialog(dlg, config)
                end
            }
            :separator {
                id = "loopOptionIndividuallyTop",
                text = string.gsub(lang["dialog.main.loopOptionIndividuallyTop.label"], "$1", config.expressions[1].decoNameFrame),
                visible = false
            }
            :combobox {
                id = "loopOptionIndividuallyName",
                visible = false,
                label = lang["dialog.main.loopOptionIndividuallyName.label"],
                option = config.expressions[1].decoNameFrame,
                options = config.expressionNames(),
                onchange = function()
                    dlg
                        :modify {
                            id = "loopOptionIndividuallyData",
                            option = enumLocalization.LoopType[config.getExpressionByNameFrame(dlg.data.loopOptionIndividuallyName).loop]
                        }
                        :modify {
                            id = "loopOptionIndividuallyTop",
                            text = string.gsub(lang["dialog.main.loopOptionIndividuallyTop.label"], "$1", dlg.data.loopOptionIndividuallyName)
                        }
                    updateDialog(dlg, config)
                end
            }
            :combobox {
                id = "loopOptionIndividuallyData",
                visible = false,
                label = lang["dialog.main.loopOptionIndividuallyData.label"],
                option = enumLocalization.LoopType[config.expressions[1].loop],
                options = {
                    lang["option.loop.beat"],
                    lang["option.loop.loop"],
                    lang["option.loop.no"]
                },
                onchange = function()
                    config.getExpressionByNameFrame(dlg.data.loopOptionIndividuallyName).loop = enumLocalization
                        .keyOf("LoopType", dlg.data.loopOptionIndividuallyData)
                end
            }
            :separator {
                id = "loopOptionIndividuallyBottom",
                visible = false
            }
            :combobox {
                id = "fpsMethod",
                label = lang["dialog.main.fpsMethod.label"],
                option = enumLocalization.FpsType[config.fpsOption],
                options = {
                    lang["option.fps.disabled"],
                    lang["option.fps.average"],
                    lang["option.fps.tagAverage"],
                    lang["option.fps.auto"],
                    lang["option.fps.changeTo"]
                },
                onchange = function()
                    config.fpsOption = enumLocalization.keyOf("FpsType", dlg.data.fpsMethod)
                    dlg:modify { id = "fpsSet", visible = config.fpsOption == FpsType.ChangeTo }
                end
            }
            :number {
                id = "fpsSet",
                label = lang["dialog.main.fpsSet"],
                text = tostring(config.fpsSet),
                visible = false,
                decimals = integer,
                onchange = function()
                    config.fpsSet = dlg.data.fpsSet
                    if config.fpsSet < 0 then
                        dlg:modify { id = "fpsSet", text = 0 }
                        config.fpsSet = 0
                    end
                end
            }
            :label {
                id = "fpsWarn",
                visible = false,
                label = "",
                text = lang["dialog.main.fpsTip"]
            }
            :separator {
                text = lang["dialog.main.separator.export"]
            }
            :combobox {
                id = "outputMode",
                label = lang["dialog.main.outputMode.label"],
                option = enumLocalization.PackMode[config.outputMode],
                options = {
                    lang["option.pack.horizontalLine"],
                    lang["option.pack.verticalLine"],
                    lang["option.pack.pack"]
                },
                onchange = function()
                    config.outputMode = enumLocalization.keyOf("PackMode", dlg.data.outputMode)
                end
            }
            :separator()
            :button {
                id = "ok",
                text = lang["dialog.main.ok"],
                focus = true
            }
            :button {
                id = "cancel",
                text = lang["dialog.main.cancel"]
            }
        dlg
            :modify { id = "showPreviewFrameTitleSeparator", visible = false }
            :modify { id = "showPreviewIndex", visible = false }
            :modify { id = "rowPreviewOffsetX", visible = false }
            :modify { id = "rowPreviewOffsetY", visible = false }
            :modify { id = "loopOptionIndividuallyTop", visible = false }
            :modify { id = "loopOptionIndividuallyName", visible = false }
            :modify { id = "loopOptionIndividuallyData", visible = false }
            :modify { id = "loopOptionIndividuallyBottom", visible = false }
        return dlg
    end

    ---@param config config
    ---@return config|nil
    local function GetDecoConfig(config)
        local averageFps = 0
        for _, frame in ipairs(currentSprite.frames) do
            averageFps = averageFps + frame.duration
        end
        averageFps = averageFps * 1000 / #currentSprite.frames

        config.fpsSet = averageFps
        local dialog = createDialog(config)
        dialog:show()
        if not dialog.data.ok then
            return nil
        end
        return config
    end

    ---@param sprite Sprite
    ---@param config any
    ---@return FrameInfo[]
    local function compressSprite(sprite, config)
        local compressedFrames = {}
        ---@param frame number
        ---@return FrameInfo
        local function getCompressedFrame(frame)
            local duration = sprite.frames[frame].duration
            local function isCellSame(l, f1, f2)
                if l.isVisible and l.opacity > 0 then
                    if l.isGroup then
                        for _, sl in ipairs(l.layers) do
                            return isCellSame(sl, f1, f2)
                        end
                    elseif l.isImage then
                        local cel1 = l:cel(f1)
                        local cel2 = l:cel(f2)
                        return (not cel1 and not cel2) or (cel1 and cel2 and cel1.image.bytes == cel2.image.bytes)
                    end
                end
                return true
            end
            local function isFrameSame(f1, f2)
                if f1 == f2 then
                    return true
                end
                for _, layer in ipairs(sprite.layers) do
                    if not isCellSame(layer, f1, f2) then
                        return false
                    end
                end
                return true
            end
            if #compressedFrames == 0 then
                compressedFrames[1] = { { frame = frame, duration = duration } }
                return { frame = 1, duration = duration }
            end
            for cflx, cf in pairs(compressedFrames) do
                if table.contains(cf, frame) then
                    return { frame = cflx, duration = duration }
                elseif table.any(cf, function(f)
                        return isFrameSame(f.frame, frame)
                    end) then
                    cf[#cf + 1] = { frame = frame, duration = duration }
                    return { frame = cflx, duration = duration }
                end
            end
            compressedFrames[#compressedFrames + 1] = { { frame = frame, duration = duration } }
            return { frame = #compressedFrames, duration = duration }
        end
        for i, expression in ipairs(config.expressions) do
            expression.compressedFrames = {}
            for j, value in pairs(expression.getFrames()) do
                expression.compressedFrames[j] = getCompressedFrame(value)
            end
        end
        return compressedFrames
    end

    ---@param sprite Sprite
    ---@param compressedFrames FrameInfo[]
    ---@param config config
    ---@param filename string
    local function compressImage(sprite, compressedFrames, config, filename)
        local size = { width = sprite.width, height = sprite.height }
        local sizeCount = { width = 1, height = 1 }
        local packMode = config.outputMode
        if packMode == PackMode.HorizontalLine then
            size.width = #compressedFrames * sprite.width
            size.height = sprite.height
            sizeCount.width = #compressedFrames
            sizeCount.height = 1
        elseif packMode == PackMode.VerticalLine then
            size.width = sprite.width
            size.height = #compressedFrames * sprite.height
            sizeCount.width = 1
            sizeCount.height = #compressedFrames
        elseif packMode == PackMode.Pack then
            while sizeCount.width * sizeCount.height < #compressedFrames do
                if size.width <= size.height then
                    sizeCount.width = sizeCount.width + 1
                    size.width = size.width + sprite.width
                else
                    sizeCount.height = sizeCount.height + 1
                    size.height = size.height + sprite.height
                end
            end
        end

        local image = Image(size.width, size.height)
        local frameIndex = { x = 0, y = 0 }

        local framesUsed = {}
        for key, value in pairs(compressedFrames) do
            frameIndex.x = (key - 1) % sizeCount.width
            frameIndex.y = math.floor((key - 1) / sizeCount.width)
            drawFrame(sprite, image, value[1].frame, Point(frameIndex.x * sprite.width, frameIndex.y * sprite.height))
            framesUsed[#framesUsed + 1] = value[1]
        end
        image:saveAs(filename .. ".png")
    end

    ---@param expressions Expression[]
    ---@param config any
    ---@param sprite Sprite
    ---@return string
    local function generateOutputJson(expressions, sprite, config)
        if not table.any(expressions, function(v)
                return v.name == "neutral"
            end) then
            expressions[#expressions + 1] = {
                name = "neutral",
                loop = RDLoopTypeTranslation[LoopType.NoLoop],
                fps = 0,
                loopStart = 0,
                portraitOffset = { config.previewFrameOffsetX, config.previewFrameOffsetY },
                portraitSize = { currentSprite.width, currentSprite.height },
                portraitScale = 2,
                frames = {},
                frameDurationData = {},
            }
        end
        local header = '\n\t"size": [' .. sprite.width .. ', ' .. sprite.height .. '],'
        if config.previewFrame > 0 then
            header = header .. '\n\t"rowPreviewFrame": ' .. config.previewFrame - 1 .. ',\n' ..
                '\t"rowPreviewOffset": [' ..
                config.previewFrameOffsetX .. ', ' .. config.previewFrameOffsetX .. '], \n'
        end

        local outputJson = ''
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
        for _, expression in pairs(expressions) do
            for key, value in pairs(expression) do
                if key ~= 'frameDurationData' then
                    if maxLength[key] < #tostring(serialize(value)) then
                        maxLength[key] = #tostring(serialize(value))
                    end
                end
            end
        end
        local char = ''
        for _, expression in ipairs(table.values(expressions)) do
            outputJson = outputJson .. char .. '\t\t' .. JsonToString(expression, maxLength)
            char = ',\n'
        end
        outputJson = '{' .. header .. '\t"clips": [\n' .. outputJson .. '\n\t]\n}'
        return outputJson
    end

    ---@param filename string
    ---@param content string
    local saveFile = function(filename, content)
        local file = io.open(filename .. ".json", "w")
        if file then
            file:write(content)
            file:close()
        else
            app.alert {
                title = lang["error.title"],
                text = lang["error.fileWrite"],
                buttons = { lang["dialog.main.ok"] },
                onclose = function()
                end
            }
        end
    end

    local outConfig = GetDecoConfig(initConfig())
    if not outConfig then
        return
    end
    ---@type string
    local filename = currentSprite.filename
    filename = filename:match("[^.]+")
    local compressedFrames = compressSprite(currentSprite, outConfig)
    compressImage(currentSprite, compressedFrames, outConfig, filename)
    local outputJson = generateOutputJson(outConfig.getPackedExpressions(), currentSprite, outConfig)
    saveFile(filename, outputJson)
end

function init(plugin)
    if app.apiVersion < 23 then
        print("The version is too old,")
        print("please upgrade to v1.3-rc3 or later.")
        return
    end
    if plugin.preferences.lang == nil then
        plugin.preferences.lang = "zh_cn"
        LangDialogShowing(plugin)
    end
    local langId = plugin.preferences.lang
    plugin:newCommand {
        id = "Aserdecoration",
        title = findLang(langId, plugin)["command.export"],
        group = "file_export_1",
        onclick = function()
            DecoDialogShowing(plugin)
        end,
        onenabled = function()
            local cs = app.sprite
            if (not cs) or
                cs.isModified or
                #cs.tags == 0 then
                return false
            end
            return true
        end
    }
    plugin:newCommand {
        id = "AserdecorationLang",
        title = findLang(langId, plugin)["command.changeLanguage"],
        group = "view_controls",
        onclick = function()
            LangDialogShowing(plugin)
            app.alert {
                title = findLang(plugin.preferences.lang, plugin)["dialog.language.title"],
                text = findLang(plugin.preferences.lang, plugin)["dialog.language.restartTip"],
                buttons = { findLang(plugin.preferences.lang, plugin)["dialog.main.ok"] },
            }
        end
    }
end

function exit(plugin)
end