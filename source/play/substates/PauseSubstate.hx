// public car
package play.substates;

import backend.util.FlixelUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import menus.MainMenuState;
import ui.UIClickableText;
class PauseSubState extends FlxSubState
{
	var textGroup:FlxTypedGroup<FlxSprite>;
	var buttonTexts:Array<String> = ['Resume Game', 'Quit Game'];

	var text:FlxText;
	var b:UIClickableText;
	var toMenuText:UIClickableText;
	var gameQuitText:UIClickableText;
	var bg:FlxSprite;
    var buttonsBg:FlxSprite;

	override function create()
	{
		super.create();

		textGroup = new FlxTypedGroup<FlxSprite>();
		add(textGroup);

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

		text = new FlxText();
		text.text = 'GAME PAUSED';
		text.size = 80;
		text.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
		text.screenCenter(X);
		text.alpha = 0;
		add(text);

		var funcs:Map<String, Void->Void> = [
			'Resume Game' => () ->
			{
				close();
			},
			'Quit Game' => () ->
			{
				FlxG.switchState(() -> new MainMenuState());
			}
		];

		var newY:Float = (FlxG.height / 2) - 40;
		for (button in buttonTexts)
		{
			var b = new UIClickableText();
			b.text = button;
			b.size = 64;
			b.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
			b.x = FlxG.width;
			b.y = newY;
			b.alpha = 0;
			b.behavior.updateHoverBounds(b.x, b.y, b.width, b.height);
			b.behavior.onClick = funcs.get(button);
			textGroup.add(b);

			FlxTween.tween(b, {x: (FlxG.width - b.width) - 15}, 0.43, {
				ease: FlxEase.quadInOut,
			});

            newY += b.height + 5;
		}

		FlxTween.tween(bg, {alpha: 0.65}, 0.43, {
			ease: FlxEase.quadInOut
		});

        FlxTween.tween(buttonsBg, {x: (FlxG.width - buttonsBg.width) - 50}, 1.2, {
            ease: FlxEase.backInOut
        });
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE)
		{
			close();
		}
	}
}
