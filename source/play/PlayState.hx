package play;

import backend.util.PathUtil;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import play.substates.PauseSubState;
import play.substates.TutorialSubState;
import ui.UIClickableSprite;

class PlayState extends FlxState
{
	var uiCamera:FlxCamera;
	var gameCamera:FlxCamera;
	var totalAntDisplay:FlxText;
	var totalAnts:Int = 0;
	var blackAntDisplay:FlxText;
	var blackAnts:Int = 0;
	var brownAntDisplay:FlxText;
	var brownAnts:Int = 0;
	var redAntDisplay:FlxText;
	var redAnts:Int = 0;
	var closedJournal:UIClickableSprite;
	var isDragging:Bool = false;
	var lastMousePos:FlxPoint;

	var mario:FlxSprite;

	override public function create()
	{
		super.create();

		lastMousePos = new FlxPoint();

		mario = new FlxSprite();
		mario.loadGraphic(PathUtil.ofSharedImage('mario'));
		mario.setGraphicSize(50, 50);
		mario.screenCenter(XY);
		mario.cameras = [gameCamera];
		add(mario);

		bgColor = FlxColor.fromRGB(140, 242, 255);

		uiCamera = new FlxCamera();
		gameCamera = new FlxCamera();
		uiCamera.bgColor.alpha = 0;
		FlxG.cameras.add(uiCamera, false);
		FlxG.cameras.add(gameCamera, false);

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

		trace('YO MOMMMMMAAA SOOOO BEEEEEGGGGG');

		openSubState(new TutorialSubState());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.pressed)
		{
			// For dragging around the map
			if (!isDragging)
			{
				// Start dragging
				isDragging = true;
				lastMousePos.set(FlxG.mouse.viewX, FlxG.mouse.viewY);
			}
			else
			{
				// Calculate mouse movement delta
				var dx = FlxG.mouse.viewX - lastMousePos.x;
				var dy = FlxG.mouse.viewY - lastMousePos.y;

				// Move the camera
				gameCamera.scroll.x -= dx;
				gameCamera.scroll.y -= dy;

				// Update last mouse position
				lastMousePos.set(FlxG.mouse.viewX, FlxG.mouse.viewY);
			}
		}
		else
		{
			isDragging = false;
		}

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

		if (FlxG.keys.justPressed.SPACE)
		{
			screenShake(elapsed);
		}

		// Zoom the camera back in when it adds zoom
		FlxG.camera.zoom = FlxMath.lerp(1.0, FlxG.camera.zoom, Math.exp(-elapsed * 3.125));
		uiCamera.zoom = FlxMath.lerp(1.0, uiCamera.zoom, Math.exp(-elapsed * 3.125));

		totalAnts = blackAnts + brownAnts + redAnts;
		totalAntDisplay.text = 'Total Ants: $totalAnts';
		blackAntDisplay.text = 'Black Ants: $blackAnts';
		brownAntDisplay.text = 'Brown Ants: $brownAnts';
		redAntDisplay.text = 'Red Ants: $redAnts';

		if (FlxG.keys.justPressed.ESCAPE)
		{
			// YO MOM SO BEEG
			// SHE TOO BEEG !!!
			openSubState(new PauseSubState());
		}
	}

	override function onFocusLost()
	{
		super.onFocusLost();
		openSubState(new PauseSubState());
	}

	function screenShake(elapsed:Float):Void
	{
		uiCamera.zoom += 0.03;
		FlxTween.completeTweensOf(uiCamera);
		uiCamera.shake(0.009, 0.078);
	}
}
