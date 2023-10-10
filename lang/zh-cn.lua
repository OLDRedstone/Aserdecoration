-- Made by Observer
-- Translation verifed by Observer
return {
    menuTitle = "导出节奏医生精灵图",
    changeLangMenuTitle = "更改 Aserdecoration 的语言",
    Name = "中文",
    Id = "zh-cn",
    LangDialog = {
        Title = "语言",
        langCombo = {
            label = "选择你的语言"
        },
        ok = "确定",
        warn = "重启时生效"
    },
    Error = {
        SaveFile = "请打开一个已有的文件。",
        Blank = "请保存文件或打开一个已保存的文件。"
    },
    Usage = {
        character = "角色",
        sprite = "精灵"
    },
    Dialog = {
        Separator = {
            "预览帧",
            "预览帧偏移",
            "动画与帧率",
            "导出"
        },
        Title = "精灵图导出选项",
        showPic = "以特定帧作为预览",
        frameTitle = "预览帧",
        index = "帧序列号",
        loopOption = {
            label = "循环设置",
            option = "按节拍循环",
            options = {
                "按节拍循环",
                "始终循环(不依赖节拍)",
                "不循环",
                "让我决定每一个"
            },
        },
        loopSetName = {
            label = "选择表情",
        },
        loopSetData = {
            label = "表情循环",
            options = {
                "按节拍循环",
                "始终循环(不依赖节拍)",
                "不循环",
            },
        },
        loopDirection = {
            label = "循环方向",
            option = "遵循 Aseprite",
            options = {
                "正向",
                "逆向",
                "正向，来回",
                "逆向，来回",
                "遵循 aseprite"
            },
        },
        fpsMethod = {
            label = "帧率设置",
            option = "禁用",
            options = {
                "禁用",
                "通过 Aseprite 参数取平均值",
                "尝试以 Aseprite 参数获取重复帧",
                "全部更改为"
            },
        },
        fpsSet = "fps",
        fpsWarn = "精灵图播放时会回到默认表情",
        outputMode = {
            label = "排列方式",
            option = "打包",
            options = {
                "水平条",
                "垂直条",
                "打包"
            },
        },
        usage = "用途",
        spriteWarnTitle = "自动补充空白表情:",
        ok = "确定",
        cancel = "取消",
    },
    successfulExit = "成功退出"
}