// public car
package menus;

import ui.UIClickableText;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;
import backend.data.ClientPrefs;

class OptionsMenuState extends FlxState
{
	var optionsText:FlxText;

	var minimizeVolumeText:UIClickableText;
	var minimizeVolume:Bool = ClientPrefs.getOption('minimizeVolume');
	var fullscreenText:UIClickableText;
	var fullscreenBool:Bool = false;

	override function create()
	{
		super.create();

		optionsText = new FlxText();
		optionsText.text = 'Options Menu';
		optionsText.size = 100;
		optionsText.screenCenter(X);
		add(optionsText);

		minimizeVolumeText = new UIClickableText();
		minimizeVolumeText.text = 'Lower Volume When Unfocused: $minimizeVolume';
		minimizeVolumeText.size = 64;
		minimizeVolumeText.screenCenter(X);
		minimizeVolumeText.y = 150;
		minimizeVolumeText.behavior.updateHoverBounds(minimizeVolumeText.x, minimizeVolumeText.y, minimizeVolumeText.width, minimizeVolumeText.height);
		minimizeVolumeText.behavior.onClick = () ->
		{
			minimizeVolume = !minimizeVolume;
			ClientPrefs.setOption('minimizeVolume', minimizeVolume);
			minimizeVolumeText.text = 'Lower Volume When Unfocused: $minimizeVolume';
		};
		add(minimizeVolumeText);

		fullscreenText = new UIClickableText();
		fullscreenText.text = 'Fullscreen: $fullscreenBool';
		fullscreenText.size = 64;
		fullscreenText.screenCenter(X);
		fullscreenText.y = 200;
		fullscreenText.behavior.updateHoverBounds(fullscreenText.x, fullscreenText.y, fullscreenText.width, fullscreenText.height);
		fullscreenText.behavior.onClick = () ->
		{
			fullscreenBool = !fullscreenBool;
			FlxG.fullscreen = fullscreenBool;
		};
		add(fullscreenText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.P)
		{
			ClientPrefs.setOption('minimizeVolume', !ClientPrefs.getOption('minimizeVolume'));
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(() -> new MainMenuState());
		}

		minimizeVolumeText.text = 'Lower Volume When Unfocused: $minimizeVolume';
		fullscreenText.text = 'Fullscreen: $fullscreenBool';
	}
}
