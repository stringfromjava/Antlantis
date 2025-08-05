// public car
package menus;

import lime.app.Application;
import backend.util.PathUtil;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import play.PlayState;
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
	var buttonsGroup:FlxSpriteGroup;
    var logo:FlxSprite;
	var playText:UIClickableText;
	var gameQuitText:UIClickableText;
	var optionsText:UIClickableText;

	override function create()
	{
		super.create();
		FlixelUtil.playMenuMusic();

		buttonsGroup = new FlxSpriteGroup();
		add(buttonsGroup);

        logo = new FlxSprite();
        logo.loadGraphic(PathUtil.ofSharedImage('logo'));
        logo.scale.set(0.4, 0.4);
        logo.updateHitbox();
        logo.y = -20;
        logo.screenCenter(X);
        add(logo);

		playText = new UIClickableText();
		playText.text = 'Play';
		playText.size = 64;
		playText.x = FlxG.width/3;
		playText.y = FlxG.height;
		playText.behavior.updateHoverBounds(playText.x, playText.y, playText.width, playText.height);
		playText.behavior.onClick = () ->
		{
			FlxG.switchState(() -> new PlayState());
		};
		buttonsGroup.add(playText);

		gameQuitText = new UIClickableText();
		gameQuitText.text = 'Quit';
		gameQuitText.size = 64;
		gameQuitText.x = FlxG.width * 19/32;
		gameQuitText.y = FlxG.height;
		gameQuitText.behavior.updateHoverBounds(gameQuitText.x, gameQuitText.y, gameQuitText.width, gameQuitText.height);
		gameQuitText.behavior.onClick = () ->
		{
			FlixelUtil.closeGame();
		}
		buttonsGroup.add(gameQuitText);

		optionsText = new UIClickableText();
		optionsText.text = 'Options';
		optionsText.size = 64;
		optionsText.x = FlxG.width * 7/16;
		optionsText.y = FlxG.height;
		optionsText.behavior.updateHoverBounds(optionsText.x, optionsText.y, optionsText.width, optionsText.height);
		optionsText.behavior.onClick = () ->
		{
			FlxG.switchState(() -> new OptionsMenuState());
		}
		buttonsGroup.add(optionsText);
		var dur:Float = 0.75;
		var newY:Float = 0;
		for (button in buttonsGroup)
		{
			var b:UIClickableText = cast(button, UIClickableText);
			var targetY = ((FlxG.height / 1.3) - (b.height / 1.3)); // capture value
			new FlxTimer().start(dur, (_) ->
			{
				FlxTween.tween(b, {y: targetY}, 0.65, {
					ease: FlxEase.quadOut,
					onComplete: (_) ->
					{
						b.behavior.updateHoverBounds(b.x, b.y, b.width, b.height);
					}
				});
			});
			dur *= 1.25;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
