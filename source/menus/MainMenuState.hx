package menus;

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
        logo.y = -75;
        logo.screenCenter(X);
        add(logo);

        trace(logo.y);
        trace(logo.x);

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
		buttonsGroup.add(playText);

		gameQuitText = new UIClickableText();
		gameQuitText.text = 'Quit Game';
		gameQuitText.size = 64;
		gameQuitText.screenCenter(X);
		gameQuitText.y = FlxG.height;
		gameQuitText.behavior.updateHoverBounds(gameQuitText.x, gameQuitText.y, gameQuitText.width, gameQuitText.height);
		gameQuitText.behavior.onClick = () ->
		{
			FlixelUtil.closeGame();
		}
		buttonsGroup.add(gameQuitText);
		var dur:Float = 0.75;
		var newY:Float = 0;
		for (button in buttonsGroup)
		{
			var b:UIClickableText = cast(button, UIClickableText);
			var targetY = ((FlxG.height / 2) - (b.height / 2)) + newY; // capture value
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
			newY += button.height + 15;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
