package play;

import play.substates.TutorialSubstate;
import ui.UIClickableSprite;
import play.substates.PauseSubstate;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	var uiCamera:FlxCamera;
	var totalAntDisplay:FlxText;
	var totalAnts:Int = 0;
	var blackAntDisplay:FlxText;
	var blackAnts:Int = 0;
	var brownAntDisplay:FlxText;
	var brownAnts:Int = 0;
	var redAntDisplay:FlxText;
	var redAnts:Int = 0;
	var closedJournal:UIClickableSprite;

	override public function create()
	{
		super.create();
		uiCamera = new FlxCamera();
		uiCamera.bgColor.alpha = 0;
		FlxG.cameras.add(uiCamera, false);

		totalAntDisplay = new FlxText();
		totalAntDisplay.text = 'Total Ants: $totalAnts';
		totalAntDisplay.size = 64;
		totalAntDisplay.cameras = [uiCamera];
		add(totalAntDisplay);

		blackAntDisplay = new FlxText();
		blackAntDisplay.text = 'Black Ants: $blackAnts';
		blackAntDisplay.size = 64;
		blackAntDisplay.y = 50;
		blackAntDisplay.cameras = [uiCamera];
		add(blackAntDisplay);

		brownAntDisplay = new FlxText();
		brownAntDisplay.text = 'Brown Ants: $brownAnts';
		brownAntDisplay.size = 64;
		brownAntDisplay.y = 100;
		brownAntDisplay.cameras = [uiCamera];
		add(brownAntDisplay);

		redAntDisplay = new FlxText();
		redAntDisplay.text = 'Red Ants: $redAnts';
		redAntDisplay.size = 64;
		redAntDisplay.y = 150;
		redAntDisplay.cameras = [uiCamera];
		add(redAntDisplay);

		openSubState(new TutorialSubstate());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.B)
		{
			blackAnts += 1;
		}

		if (FlxG.keys.justPressed.L)
		{
			brownAnts += 1;
		}

		if (FlxG.keys.justPressed.R)
		{
			redAnts += 1;
		}

		totalAnts = blackAnts + brownAnts + redAnts;
		totalAntDisplay.text = 'Total Ants: $totalAnts';
		blackAntDisplay.text = 'Black Ants: $blackAnts';
		brownAntDisplay.text = 'Brown Ants: $brownAnts';
		redAntDisplay.text = 'Red Ants: $redAnts';

		if (FlxG.keys.justPressed.ESCAPE)
		{
			//YO MOM SO BEEG
			//SHE TOO BEEG !!!
			openSubState(new PauseSubstate());
		}
	}
}
