package play.substates;

import ui.UIClickableText;
import backend.util.PathUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;

class JournalSubState extends FlxSubState
{
	var bg:FlxSprite;
	var journal:FlxSprite;
	var exitText:UIClickableText;

	override function create()
	{
		super.create();

		bg = new FlxSprite();
		bg.makeGraphic(FlxG.width * 2, FlxG.height * 2);
		bg.screenCenter(XY);
		bg.color = FlxColor.GRAY;
		bg.alpha = 0.65;
		add(bg);

		journal = new FlxSprite();
		journal.loadGraphic(PathUtil.ofSharedImage('journal-open'));
		journal.setGraphicSize(FlxG.width, FlxG.height);
		journal.screenCenter(XY);
		add(journal);

		exitText = new UIClickableText();
		exitText.text = 'click here or press ESC to close journal';
		exitText.size = 32;
		exitText.color = FlxColor.BLACK;
		exitText.setBorderStyle(OUTLINE, FlxColor.WHITE, 3);
		exitText.behavior.updateHoverBounds(exitText.x, exitText.y, exitText.width, exitText.height);
		exitText.behavior.onClick = () ->
		{
			close();
		};
		add(exitText);
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
