-- Translation verified by miaobukeyan
language = {
    menuTitle = "リズムドクタースプライト図のエクスポート",
    changeLangMenuTitle = "スプライトエクスポーターの言語を変更する",
    Name = "日本語",
    Id = "ja-jp",
    LangDialog = {
        Title = "言語",
        langCombo = {
            label = "言語を選択"
        },
        ok = "確定",
        warn = "再起動時に有効"
    },
    Error = {
        SaveFile = "既存のファイルを開いてください。",
        Blank = "ファイルを保存するか、保存したファイルを開きます。"
    },
    Usage = {
        character = "役割",
        sprite = "魔神"
    },
    Dialog = {
        Separator = {
            "プレビューフレーム",
            "フレームオフセットのプレビュー",
            "アニメーションとフレームレート",
            "輸出"
        },
        Title = "スプライトのエクスポートオプション",
        showPic = "特定のフレームでプレビューする",
        frameTitle = "フレームをプレビューする",
        index = "フレーム シーケンス番号",
        loopOption = {
            label = "ループ設定",
            option = "ビートごとのサイクル",
            options = { "ビートごとのサイクル", "常にループ(ビートに依存しない)", "ループなし" },
        },
        loopDirection = {
            label = "ループ方向",
            option = "アセプライトに従う",
            options = { "進む", "後進", "進む、戻る", "逆、戻る", "アセプライトに従う" },
        },
        fpsMethod = {
            label = "フレームレート設定",
            option = "(0)を設定しない",
            options = { "(0)を設定しない", "アセプライトパラメータによる平均", "すべてに変更" },
        },
        fpsSet = "fps",
        fpsWarn = "スプライトはデフォルトの絵文字に再生されます",
        outputMode = {
            label = "配置",
            option = "パック",
            options = { "水平並び", "垂直並び", "パック" },
        },
        usage = "使う",
        spriteWarnTitle = "空白の式を自動的に入力する:",
        ok = "確定",
        cancel = "キャンセル",
    },
    successfulExit = "正常な終了"
}
return language
