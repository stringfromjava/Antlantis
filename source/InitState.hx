package;

import menus.MainMenuState;
import flixel.text.FlxText;
import backend.util.PathUtil;
import flixel.system.FlxAssets;
import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

        configureFlixelSettings();
        FlxG.switchState(() -> new MainMenuState());
	}

    function configureFlixelSettings():Void
    {
        FlxG.mouse.useSystemCursor = true;
        FlxAssets.FONT_DEFAULT = PathUtil.ofFont('Orange Kid');
    }
}
