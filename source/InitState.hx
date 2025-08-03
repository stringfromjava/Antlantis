package;

import backend.util.FlixelUtil;
import backend.util.SaveUtil;
import lime.app.Application;
import backend.data.ClientPrefs;
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

        ClientPrefs.loadAll();
        configureFlixelSettings();
        addEventListeners();

        FlxG.switchState(() -> new MainMenuState());
	}

    function configureFlixelSettings():Void
    {
        FlxG.mouse.useSystemCursor = true;
        FlxAssets.FONT_DEFAULT = PathUtil.ofFont('Orange Kid');
        FlxAssets.defaultSoundExtension = #if web 'mp3' #else 'ogg' #end;
    }

    function addEventListeners():Void
    {
        Application.current.window.onClose.add(() ->
        {
            FlixelUtil.closeGame(false);
        });
    }
}
