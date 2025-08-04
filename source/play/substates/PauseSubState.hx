// public car
package play.substates;

import backend.util.PathUtil;
import ui.UIClickableSprite;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import menus.MainMenuState;

class PauseSubState extends FlxSubState
{
	var buttonsGroup:FlxTypedGroup<FlxSprite>;
	var buttonIds:Array<String> = ['back-to-game', 'quit'];
	var createButtonsTimer:FlxTimer;

	var gamePausedText:FlxText;
	var bg:FlxSprite;
	var buttonsBg:FlxSprite;

	override function create()
	{
		super.create();

		bg = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height);
		bg.alpha = 0;
		add(bg);

		buttonsBg = new FlxSprite();
		buttonsBg.makeGraphic(Std.int(FlxG.width / 2) + 50, FlxG.height * 5, FlxColor.BLACK);
		buttonsBg.setPosition(FlxG.width + 400, -100);
		buttonsBg.alpha = 0.83;
		buttonsBg.angle = 15;
		add(buttonsBg);

		gamePausedText = new FlxText();
		gamePausedText.text = 'GAME PAUSED';
		gamePausedText.size = 80;
		gamePausedText.font = PathUtil.ofFont('vcr');
		gamePausedText.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
		gamePausedText.x = FlxG.width;
		gamePausedText.y = 75;
		add(gamePausedText);

		buttonsGroup = new FlxTypedGroup<FlxSprite>();
		add(buttonsGroup);

		FlxTween.tween(bg, {alpha: 0.65}, 0.43, {
			ease: FlxEase.quadInOut
		});
		FlxTween.tween(buttonsBg, {x: (FlxG.width - buttonsBg.width) - 50}, 1.2, {
			ease: FlxEase.backInOut
		});
		FlxTween.tween(gamePausedText, {x: (FlxG.width - gamePausedText.width) - 10}, 1.35, {
			ease: FlxEase.backInOut,
			onStart: (_) ->
			{
				FlxG.sound.play(PathUtil.ofSharedSound('woosh-long'));
			}
		});

		FlxTween.num(FlxG.sound.music.volume, 0.2, 1.2, (v) ->
		{
			FlxG.sound.music.volume = v;
		});

		createButtonsTimer = new FlxTimer().start(1.15, (_) ->
		{
			createTextButtons();
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE)
		{
			backToGame();
		}
	}

	function backToGame():Void
	{
		createButtonsTimer.cancel();
		FlxTween.cancelTweensOf(buttonsBg);
		FlxTween.cancelTweensOf(bg);
		FlxTween.cancelTweensOf(gamePausedText);
		for (b in buttonsGroup)
		{
			FlxTween.cancelTweensOf(b);
		}

		FlxTween.tween(buttonsBg, {x: Std.int(FlxG.width + 100)}, 0.43, {
			ease: FlxEase.quadOut
		});
		// Tween buttons
		for (b in buttonsGroup)
		{
			FlxTween.tween(b, {x: FlxG.width}, 0.16, {
				ease: FlxEase.quadOut
			});
		}
		FlxTween.tween(bg, {alpha: 0}, 0.43, {
			ease: FlxEase.quadOut,
			onComplete: (_) ->
			{
				close();
			}
		});
		FlxTween.tween(gamePausedText, {x: FlxG.width}, 0.43, {
			ease: FlxEase.quadOut
		});

		// Tween the music's volume back up
		FlxTween.cancelTweensOf(FlxG.sound.music);
		FlxTween.num(FlxG.sound.music.volume, 1, 0.43, (v) ->
		{
			FlxG.sound.music.volume = v;
		});

		FlxG.sound.play(PathUtil.ofSharedSound('woosh-short'));
	}

	function createTextButtons():Void
	{
		var funcs:Map<String, Void->Void> = [
			'back-to-game' => () ->
			{
				backToGame();
			},
			'quit' => () ->
			{
				FlxG.switchState(() -> new MainMenuState());
			}
		];

		var newX:Float = FlxG.width - 290;
		var newY:Float = (FlxG.height / 2) - 40;
		var tweenTime:Float = 0.05;
		for (i in 0...buttonIds.length)
		{
			var id = buttonIds[i];
			var b = new UIClickableSprite();
			b.loadGraphic(PathUtil.ofSharedImage('menus/$id'));
			b.scale.set(0.6, 0.6);
			b.updateHitbox();
			b.x = FlxG.width;
			b.y = newY;
			b.behavior.onClick = funcs.get(id);
			buttonsGroup.add(b);

			var targetX = (i == 1) ? (FlxG.width - 330) : newX; // Only change x for second button

			new FlxTimer().start(tweenTime, (_) ->
			{
				FlxTween.tween(b, {x: targetX}, 0.43, {
					ease: FlxEase.quadOut,
					onComplete: (_) ->
					{
						b.behavior.updateHoverBounds(b.x, b.y, b.width, b.height);
					}
				});
			});

			newY += b.height + 40;
			tweenTime += 0.05;
		}
	}
}
