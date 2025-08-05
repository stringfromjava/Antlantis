package play;

import backend.data.ClientPrefs;
import backend.util.DataUtil;
import play.entities.Entity;
import backend.util.AssetUtil;
import openfl.Assets;
import flixel.tweens.FlxEase;
import flixel.FlxSubState;
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

using StringTools;

class PlayState extends FlxState
{
	/**
	 * The instance used to access the public attributes of
	 * the play state from anywhere in the code.
	 * 
	 * (Thanks, once again, FNF for the idea lmao.)
	 */
	public static var instance:PlayState;

	//
	// CAMERAS
	// ================================
	public var uiCamera:FlxCamera;
	public var gameCamera:FlxCamera;
	public var subStateCamera:FlxCamera;

	//
	// TEXT DISPLAYS
	// =======================================
	var totalAntDisplay:FlxText;
	var blackAntDisplay:FlxText;
	var brownAntDisplay:FlxText;
	var redAntDisplay:FlxText;

	//
	// UI
	// ========================
	var closedJournal:UIClickableSprite;

	//
	// EXTRAS
	// ====================================
	var lastMousePos:FlxPoint;

	//
	// DATA
	// ==============================

	/**
	 * Is the user currently dragging?
	 * This can be set to `false` at any time to
	 * stop the user from dragging and force them to
	 * hold down RMB again.
	 */
	public var isDragging:Bool = false;

	/**
	 * All of the registered entities for the game.
	 */
	public var registeredEntities:Map<String, Entity> = [];

	var canInteract:Bool = true; // Can the user do basic things, such as dragging, interacting with entities, zooming, etc?
	var totalAnts:Int = 0;
	var blackAnts:Int = 0;
	var brownAnts:Int = 0;
	var redAnts:Int = 0;
	var currentZoom:Float = 1.0;
	var timeElapsed:Float = 1;

	var mario:FlxSprite;

	override public function create()
	{
		super.create();

		instance = this;
		lastMousePos = new FlxPoint();

		setupCameras();
		registerEntities();

		mario = new FlxSprite();
		mario.loadGraphic(PathUtil.ofSharedImage('mario'));
		mario.setGraphicSize(150, 150);
		mario.screenCenter(XY);
		mario.cameras = [gameCamera];
		add(mario);

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

		openSubState(new TutorialSubState());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		timeElapsed += elapsed * ClientPrefs.getOption('gameSpeed');

		checkForDragging();
		updateCameraZoomsAndScrolls(elapsed);

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

		totalAnts = blackAnts + brownAnts + redAnts;
		totalAntDisplay.text = 'Total Ants: $totalAnts';
		blackAntDisplay.text = 'Black Ants: $blackAnts';
		brownAntDisplay.text = 'Brown Ants: $brownAnts';
		redAntDisplay.text = 'Red Ants: $redAnts';

		// Check if the user wants to pause the game
		if (FlxG.keys.justPressed.ESCAPE)
		{
			// YO MOM SO BEEG
			// SHE TOO BEEG !!!
			openSubState(new PauseSubState());
		}

		// Check if the user is trying to reset the zoom and
		// the dragged position of the game camera
		if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.R)
		{
			isDragging = false;
			canInteract = false;
			currentZoom = 1;
			FlxTween.tween(gameCamera.scroll, {x: 0, y: 0}, 0.42, {
				ease: FlxEase.quadOut,
				onComplete: (_) ->
				{
					canInteract = true;
				}
			});
			FlxG.sound.play(PathUtil.ofSharedSound('woosh-short'));
		}
	}

	override function onFocusLost()
	{
		super.onFocusLost();
		openSubState(new PauseSubState());
	}

	override function openSubState(SubState:FlxSubState)
	{
		super.openSubState(SubState);
		SubState.cameras = [subStateCamera];
		FlxTween.num(FlxG.sound.music.volume, 0.2, 0.43, (v) ->
		{
			FlxG.sound.music.volume = v;
		});
	}

	override function closeSubState()
	{
		super.closeSubState();
		FlxTween.num(FlxG.sound.music.volume, 1, 0.43, (v) ->
		{
			FlxG.sound.music.volume = v;
		});
	}

	//
	// CREATE FUNCTIONS
	// =========================================================

	function setupCameras():Void
	{
		uiCamera = new FlxCamera();
		gameCamera = new FlxCamera();
		subStateCamera = new FlxCamera();
		uiCamera.bgColor.alpha = 0;
		subStateCamera.bgColor.alpha = 0;
		gameCamera.bgColor = FlxColor.fromRGB(140, 242, 255);
		FlxG.cameras.add(gameCamera);
		FlxG.cameras.add(uiCamera, false);
		FlxG.cameras.add(subStateCamera, false);
	}

	function registerEntities():Void
	{
		for (asset in Assets.list())
		{
			if (asset.indexOf('assets/entities/metadata/') == 0)
			{
				var id:String = AssetUtil.removeFileExtension(AssetUtil.getFileNameFromPath(asset)); // The ID is the file name
				registeredEntities.set(id, AssetUtil.getJsonData(asset)); // TODO: Fix null data on desktop?????
			}
		}
		trace(registeredEntities);
	}

	//
	// UPDATE FUNCTIONS
	// ==============================================================

	function checkForDragging():Void
	{
		if (FlxG.mouse.pressedRight && canInteract)
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
	}

	function updateCameraZoomsAndScrolls(elapsed:Float):Void
	{
		// Multiplies by the current state of the wheel during the current frame
		currentZoom += #if desktop 0.175 #else 0.0015 #end * FlxG.mouse.wheel;
		if (currentZoom < 0.3)
		{
			currentZoom = 0.3;
		}
		else if (currentZoom > 3)
		{
			currentZoom = 3;
		}

		// Zoom the camera back in when it adds zoom
		// (I stole this from FNF Psych Engine lol)
		gameCamera.zoom = FlxMath.lerp(currentZoom, gameCamera.zoom, Math.exp(-elapsed * 4.765));
		uiCamera.zoom = FlxMath.lerp(1.0, uiCamera.zoom, Math.exp(-elapsed * 3.125));

		// Move the UI camera based on the mouse position
		uiCamera.scroll.x = FlxMath.lerp(uiCamera.scroll.x, (FlxG.mouse.viewX - (FlxG.width / 2)) * 0.03, (1 / 30) * 240 * elapsed);
		uiCamera.scroll.y = FlxMath.lerp(uiCamera.scroll.y, (FlxG.mouse.viewY - 6 - (FlxG.height / 2)) * 0.03, (1 / 30) * 240 * elapsed);
	}

	//
	// UTILITY FUNCTIONS
	// =====================================================

	function screenShake(elapsed:Float):Void
	{
		gameCamera.zoom += 0.025;
		uiCamera.zoom += 0.03;
		if (ClientPrefs.getOption('screenShake'))
		{
			FlxTween.cancelTweensOf(gameCamera);
			FlxTween.cancelTweensOf(uiCamera);
			gameCamera.shake(0.0065, 0.078);
			uiCamera.shake(0.009, 0.078);
		}
	}
}
