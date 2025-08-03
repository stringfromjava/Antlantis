package menus;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import ui.UIClickableText;
import backend.util.FlixelUtil;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MainMenuState extends FlxState
{
	var titleText:FlxText;
	var playText:UIClickableText;
	var gameQuitText:UIClickableText;

	override function create()
	{
		super.create();
		FlixelUtil.playMenuMusic();

		titleText = new FlxText();
		titleText.text = 'ANTLANTIS';
		titleText.size = 100;
		titleText.screenCenter(X);
		add(titleText);

		playText = new UIClickableText();
		playText.text = 'Play';
		playText.size = 64;
		playText.screenCenter(X);
		playText.y = FlxG.height;
		playText.behavior.updateHoverBounds(playText.x, playText.y, playText.width, playText.height);
		playText.behavior.onClick = () ->
		{
			FlxG.switchState(() -> new PlayState());
		};
		add(playText);

		gameQuitText = new UIClickableText();
		gameQuitText.text = 'Quit Game';
		gameQuitText.size = 64;
		gameQuitText.screenCenter(X);
		gameQuitText.y = 400;
		gameQuitText.behavior.updateHoverBounds(gameQuitText.x, gameQuitText.y, gameQuitText.width, gameQuitText.height);
		gameQuitText.behavior.onClick = () ->
		{
			FlixelUtil.closeGame();
		}
		add(gameQuitText);

		new FlxTimer().start(1, (_) ->
		{
			FlxTween.tween(playText, {y: (FlxG.height / 2) - (playText.height / 2)}, 0.75, {
				ease: FlxEase.quadOut
			});
		}, 1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
