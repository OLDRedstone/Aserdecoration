**English** | [中文](README-zh_cn.md) | [日本語](README-ja_jp.md)

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

1. Open/select the corresponding saved file,
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
