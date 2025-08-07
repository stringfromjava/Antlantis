// public car
package menus;

import backend.util.PathUtil;
import ui.options.OptionNumberScroller;
import ui.options.OptionCheckBox;
import ui.options.OptionSelectionList;
import ui.UIClickableText;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;
import backend.data.ClientPrefs;

class OptionsMenuState extends FlxState
{
	var selectionList:OptionSelectionList;

	override function create()
	{
		super.create();

		selectionList = new OptionSelectionList(STICK_OUT, LEFT, 30);
		selectionList.add(new OptionNumberScroller(20, 100, 'Click Sound Volume', 'clickVolume', 0.0, 1.0, 0.1, 0, true, () ->
		{
			FlxG.sound.play(PathUtil.ofSharedSound('click'), ClientPrefs.getOption('clickVolume'));
		}));
		selectionList.add(new OptionCheckBox(20, 250, 'Fullscreen', 'fullscreen', () ->
		{
			FlxG.fullscreen = ClientPrefs.getOption('fullscreen');
		}));
        selectionList.add(new OptionCheckBox(20, 400, 'Screen Shake', 'screenShake', false, null));
        selectionList.add(new OptionNumberScroller(20, 550, 'Game Speed', 'gameSpeed', 0.1, 2.0, 0.1, 1, true, null));
		selectionList.add(new OptionCheckBox(20, 700, 'Discord Presence', 'discordRPC', false, null));
		add(selectionList);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(() -> new MainMenuState());
		}

        if(FlxG.keys.justPressed.T)
        {
            trace(ClientPrefs.getOption('gameSpeed'));
        }
	}
}
