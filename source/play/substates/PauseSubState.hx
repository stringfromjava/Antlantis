// public car
package play.substates;

import ui.UIClickableText;
import backend.util.FlixelUtil;
import flixel.util.FlxSpriteUtil;
import flixel.FlxCamera;
import flixel.math.FlxMath;
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
	var cam:FlxCamera;
	var buttonsGroup:FlxTypedGroup<UIClickableSprite>;
	var buttonIds:Array<String> = ['back-to-game', 'quit'];
	var createButtonsTimer:FlxTimer;

	var gamePausedText:FlxText;
	var hintText:FlxText;
	var bg:FlxSprite;
	var buttonsBg:FlxSprite;

	var isUnpausing:Bool = false;

	var hints:Array<String> = [
		'Press "ESCAPE" to unpause or "Q" to quit!',
		'// public car',
		'Take a peep at the source code, you\nmight find something interesting!',
		'"What the helli"',
		'When assigning variables with objects,\ndon\'t forget the parenthesis (looking at YOU Jawless).',
		'"How do you have 20 pairs of pants, and\n3 pairs of underwear?!"',
		'You\'re dead built like an apple',
		'"Careful with what you say buddy, the cock is WATCHING, and\nhe ain\'t take no prisoners, keep them cheeks TIGHT"',
		'"What\'s a quote that I have that isn\'t, uhm, racist?" (:skull:)',
		'Yo yo yo, what\'s good piggy gang.
		So I heard some:
		* **BOOTY SNIFFIN\'**,
		* **OPPOSITION**,
		* **"I LIKE TO TEXT MY *DISCORD KITTEN*™ :nerd:"**
		lookin\' ahh mufucka, is messin\' with the barn...
		*So*...
		This, is your *only*, warnin\'...
		My name... is ***Piggy_G***,
		I\'m a real gangster,
		I stay on all fours (no homo),
		and if you mess with the barn, *man*,
		I will attack yo farm.

		So get yo *"SuPeR sAiYaN :nerd:"*, Discord © gamin\'!
		"Gurl, *S L A Y*" sayin\',
		# offa my turf.'
	];

	override function create()
	{
		super.create();

		PlayState.instance.isDragging = false;
		cam = PlayState.instance.subStateCamera;

		bg = new FlxSprite();
		bg.makeGraphic(FlxG.width * 2, FlxG.height * 2);
		bg.screenCenter(XY);
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
		gamePausedText.cameras = [cam];
		add(gamePausedText);

		hintText = new FlxText();
		hintText.text = 'HINT: ${hints[FlxG.random.int(0, hints.length - 1)]}';
		hintText.size = 16;
		hintText.alpha = 0;
		hintText.font = PathUtil.ofFont('vcr');
		hintText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		hintText.setPosition(8, cam.height - hintText.height - 8);
		hintText.cameras = [cam];
		add(hintText);

		buttonsGroup = new FlxTypedGroup<UIClickableSprite>();
		add(buttonsGroup);

		FlxTween.tween(bg, {alpha: 0.65}, 0.43, {
			ease: FlxEase.quadInOut
		});
		FlxTween.tween(hintText, {alpha: 0.37}, 0.43, {
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
		if (FlxG.keys.justPressed.Q)
		{
			FlxG.switchState(() -> new MainMenuState());
		}

		cam.scroll.x = FlxMath.lerp(cam.scroll.x, (FlxG.mouse.viewX - (FlxG.width / 2)) * 0.025, (1 / 30) * 240 * elapsed);
		cam.scroll.y = FlxMath.lerp(cam.scroll.y, (FlxG.mouse.viewY - 6 - (FlxG.height / 2)) * 0.025, (1 / 30) * 240 * elapsed);
	}

	function backToGame():Void
	{
		if (isUnpausing)
		{
			return;
		}

		isUnpausing = true;

		// Cancel all current tweens
		createButtonsTimer.cancel();
		FlxTween.cancelTweensOf(buttonsBg);
		FlxTween.cancelTweensOf(bg);
		FlxTween.cancelTweensOf(gamePausedText);
		for (b in buttonsGroup)
		{
			b.behavior.canClick = false;
			FlxTween.cancelTweensOf(b);
			FlxTween.tween(b, {x: cam.width + 15, alpha: 0}, 0.16, {
				ease: FlxEase.quadOut
			});
		}

		FlxTween.tween(buttonsBg, {x: Std.int(FlxG.width + 100), alpha: 0}, 0.43, {
			ease: FlxEase.quadOut
		});
		FlxTween.tween(hintText, {alpha: 0}, 0.43, {
			ease: FlxEase.quadOut
		});
		FlxTween.tween(bg, {alpha: 0}, 0.43, {
			ease: FlxEase.quadOut,
			onComplete: (_) ->
			{
				close();
			}
		});
		FlxTween.tween(gamePausedText, {x: cam.width + 15, alpha: 0}, 0.43, {
			ease: FlxEase.quadOut
		});

		FlxG.sound.play(PathUtil.ofSharedSound('woosh-short'));
	}

	function createTextButtons():Void
	{
		// Functions that get called when the buttons are clicked
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

		// Create every button provided in the list of ID's
		var newY:Float = (FlxG.height / 2) - 40; // Spacing between the buttons
		var tweenTime:Float = 0.05; // For adding a small delay between the buttons being added
		for (i in 0...buttonIds.length)
		{
			var id = buttonIds[i];
			var b = new UIClickableSprite();
			b.loadGraphic(PathUtil.ofSharedImage('menus/$id'));
			b.scale.set(0.6, 0.6);
			b.updateHitbox();
			b.x = FlxG.width;
			b.y = newY;
			b.cameras = [cam];
			b.behavior.onClick = funcs.get(id);
			b.behavior.onHover = () ->
			{
				FlxSpriteUtil.setBrightness(b, 0.32);
			};
			b.behavior.onHoverLost = () ->
			{
				FlxSpriteUtil.setBrightness(b, 0);
			};
			buttonsGroup.add(b);

			var targetX = (i == 1) ? FlxG.width - 330 : FlxG.width - 290; // The second button's X value is lower

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
