package play;

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
		blackAntDisplay.y = 100;
		blackAntDisplay.cameras = [uiCamera];
		add(blackAntDisplay);

		brownAntDisplay = new FlxText();
		brownAntDisplay.text = 'Brown Ants: $brownAnts';
		brownAntDisplay.size = 64;
		brownAntDisplay.y = 200;
		brownAntDisplay.cameras = [uiCamera];
		add(brownAntDisplay);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.F)
		{
			blackAnts += 1;
		}

		if (FlxG.keys.justPressed.L)
		{
			brownAnts += 1;
		}
		totalAnts = blackAnts + brownAnts;
		totalAntDisplay.text = 'Total Ants: $totalAnts';
		blackAntDisplay.text = 'Black Ants: $blackAnts';
		brownAntDisplay.text = 'Brown Ants: $brownAnts';
	}
}
