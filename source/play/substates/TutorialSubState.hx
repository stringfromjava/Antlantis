package play.substates;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TutorialSubState extends FlxSubState
{
	var bg:FlxSprite;
	var tutorialText:FlxText;
	var textArrayIndex:Int = 0;
	var currentY:Float;
	var newY:Float;
	var hasTweened:Bool = false;
	var textArray:Array<String> = [
		'Welcome to Antlantis!',
		'As the queen ant, your job is to grow your anthill,
        manage your colony, and keep your ants safe!',
		'Sometimes, your anthill will be attacked by Antlions,
        Beetles, and even other kinds of ants!',
		'When your anthill gets attacked, be sure to send your best ants at
        the predators and keep your colony safe'
	];

	override function create()
	{
		super.create();

		bg = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height);
		bg.alpha = 0.65;
		add(bg);

		tutorialText = new FlxText();
		tutorialText.text = textArray[0];
		tutorialText.size = 60;
		tutorialText.alignment = FlxTextAlign.CENTER;
		tutorialText.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
		tutorialText.screenCenter(X);
		tutorialText.y = -FlxG.height;
		add(tutorialText);

		FlxTween.tween(tutorialText, {y: 298.5}, 0.5, {
			ease: FlxEase.quadInOut
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
		{
			textArrayIndex++;
			var t:String = textArray[textArrayIndex];
			if (t == null)
			{
				close();
                return;
			}
			tutorialText.text = t;
			tutorialText.screenCenter(XY);
		}
	}
}
