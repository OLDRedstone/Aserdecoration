# Aserdecoration: Aseprite RD Decoration
将 Aseprite 转换为节奏医生精灵图及其 json 文件的快速方法。

支持版本：v1.3-rc3 或更新

### 安装：

**双击 .aseprite-extension 文件**或**依次点击**`编辑-首选项-扩展-添加扩展`以安装。

首次打开时需要选择语言，选择对应的语言后**重启插件**(`编辑-首选项-扩展-禁用/启用`)或**重启 Aseprite**以生效。

若需要更改语言，依次点击`窗口-更改 Aserdecoration 的语言`，之后以上述方法重启插件。

### 使用

在 Aseprite 里制作精灵图时，

1. 选择已保存的需要导出的 Aseprite 工程文件，
1. 调整帧持续时间(可选)，
1. 创建循环节，
	1. 选择多个帧，
	1. 右键帧序号，
	1. 选择`设置循环节`，
1. 将循环节名称设置为精灵图表情名称，
1. 调整循环节参数，
1. 依次点击`文件-导出...-导出节奏医生精灵图`以弹出导出对话框，

插件将会以**循环节名称**创建精灵表情，并以**循环节的动画方向**、**帧的持续时间(可选)**和**对话框内的参数**在**已打开的 Aseprite 工程文件同一位置**处创建与同名的精灵图 .png 和 .json 文件。

### 注意
+ 导出时请确保打开的 Aseprite 工程文件处没有同名的 .png 文件或 .json 文件，或者这些文件无重要数据。

***

# Aserdecoration: Aseprite RD Decoration
(Translated by [RaYmondCheung](https://github.com/RaYm0ndCheun9))

A quick way to generate sprite sheet and json file for Rhythm Doctor in Aseprite.

Support version: v1.3-rc3 or above

### Installation:

**Double-click the .aseprite-extension file** or **click** `Edit - Preferences - Extensions - Add Extension` to install. 

On first use: select the desired language then **restart the plugin** (`Edit-Preferences-Extension-Disable/Enable`) or **restart Aseprite** to take effect.

If you need to change the language, click `View - Change Aserdecoration language` and restart the plugin as described above.

### Usage

In Aseprite,

1. Open/select the corresponding file (remember to save first!),
1. Adjust the frame duration in 'frame properties` (optional),
1. Create a loop section:
	1. Select desired frames,
	1. Right-click the selected frame number,then select `Set Loop Section` or `New Tag`,
		1. or click `Frame - Tags - New Tag`
1. Open `Tag properties` dialog and rename to the expression name,
	1. Adjust other parameters if you want,
1. Click `File - Export... - Export Rhythm Doctor Sprite` to pop up the export dialog,

Plugin will fill-in sprite expressions based on the **loop section name**, and generate sprite sheet image (.png) and .json file based on **Animation Direction of the section**, **frame duration** and **the export settings**.

Image (.png) and .json file will be created with same name under **the same path as the opened Aseprite file**.

### Warning
+ When exporting, make sure that the folder where your Aseprite file saved doesn't have a .png file or json file with the same name, or these files don't have important data.

***

# Aserdecoration: Aseprite RD Decoration
(機械による翻訳)

アセプライトをリズムドクタージニーダイアグラムとその json ファイルに変換する簡単な方法。

エクスポートする Aseprite プロジェクトファイルを開きます!

対応バージョン：v1.3-rc3 以上

### インストール:

.aseprite-extension ファイルをダブルクリックするか、[編集] - [設定] - [拡張機能] - [拡張機能の追加] をクリックしてインストールします。 

初めて開くときに言語を選択し、対応する言語を選択した後、プラグインを再起動するか(「編集-設定-拡張機能-無効化/有効化」)またはAsepriteを再起動して有効にする必要があります。

言語を変更する必要がある場合は、[Aserdecoration の言語を変更する]をクリックして、上記のようにプラグインを再起動します。

### 使用する

アセプライトでスプライト図を作るとき、

1. エクスポートする保存済みのAsepriteプロジェクトファイルを選択します。
1. フレームの長さを調整します(オプション)。
1. ループセクションを作成し、
	1. 複数のフレームを選択し、
	1. フレームシーケンス番号を右クリックし、
	1. [ループセクションの設定]を選択し、
1. ループセクション名をスプライトプロット名に設定します。
1. ループセクションのパラメータを調整し、
1. [ファイル] - [エクスポート...] - [リズムドクタースプライト図のエクスポート]をクリックして、エクスポートダイアログをポップアップします。

プラグインは、ループのアニメーション方向、フレームの継続時間(オプション)、およびダイアログ内のパラメーターを使用して、開いている Aseprite プロジェクトファイルと同じ場所に、ループセクション名とスプライトダイアグラム .png と同じ名前の .json ファイルを使用してスプライト式を作成します。

### 注意
+ エクスポートするときは、開く Aseprite プロジェクトファイルに同じ名前の .png ファイルまたは .json ファイルが含まれていないこと、またはこれらのファイルに重要なデータがないことを確認してください。
