// public car
//  ____  ____  ____  _  __
// /   _\/  _ \/   _\/ |/ /
// |  /  | / \||  /  |   / 
// |  \_ | \_/||  \_ |   \ 
// \____/\____/\____/\_|\_\

package;

import openfl.Lib;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	final game:Dynamic = {
		width: 1280,
		height: 720,
		initState: InitState,
		framerate: 60,
		skipSplash: true,
		startFullscreen: false
	}

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();
		addChild(new FlxGame(
			game.width,
			game.height,
			game.initState,
			game.framerate,
			game.framerate,
			game.skipSplash,
			game.startFullscreen,
		));
	}
}
