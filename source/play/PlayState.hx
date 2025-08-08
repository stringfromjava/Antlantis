package play;

import flixel.text.FlxText;
import play.substates.JournalSubState;
import flixel.util.FlxSpriteUtil;
import backend.data.ClientPrefs;
import flixel.tweens.FlxEase;
import flixel.FlxSubState;
import backend.util.PathUtil;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import play.substates.PauseSubState;
import play.substates.TutorialSubState;
import play.entities.Ant;
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
	var foodText:FlxText;
	var waterText:FlxText;
	var antsText:FlxText;

	//
	// UI
	// ========================
	var journal:UIClickableSprite;

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

	public var food:Int = 0;
	public var water:Int = 0;
	public var ants:Int = 0;

	var canInteract:Bool = true; // Can the user do basic things, such as dragging, interacting with entities, zooming, etc?
	var currentZoom:Float = 1.0;

	var mario:Ant;

	override public function create()
	{
		super.create();

		instance = this;
		lastMousePos = new FlxPoint();

		setupCameras();

		mario = new Ant();
		mario.animation.play('idle');
		mario.screenCenter(XY);
		mario.cameras = [gameCamera];
		add(mario);

		foodText = new FlxText();
		foodText.text = 'Food: $food';
		foodText.size = 32;
		foodText.color = 0xFF882E0A;
		foodText.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);
		foodText.font = PathUtil.ofFont('vcr');
		foodText.setPosition(10, 20);
		foodText.cameras = [uiCamera];
		add(foodText);

		waterText = new FlxText();
		waterText.text = 'Water: $water';
		waterText.size = 32;
		waterText.color = 0xFF0C6DA5;
		waterText.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);
		waterText.borderColor = FlxColor.WHITE;
		waterText.font = PathUtil.ofFont('vcr');
		waterText.setPosition(10, (foodText.y + foodText.height));
		waterText.cameras = [uiCamera];
		add(waterText);

		antsText = new FlxText();
		antsText.text = 'Ants: $ants';
		antsText.size = 32;
		antsText.color = 0xFF212222;
		antsText.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);
		antsText.borderColor = FlxColor.WHITE;
		antsText.font = PathUtil.ofFont('vcr');
		antsText.setPosition(10, (waterText.y + waterText.height));
		antsText.cameras = [uiCamera];
		add(antsText);

		journal = new UIClickableSprite();
		journal.loadGraphic(PathUtil.ofSharedImage('journal-closed'));
		journal.scale.set(0.4, 0.4);
		journal.updateHitbox();
		journal.x = FlxG.width - journal.width;
		journal.y = 0;
		journal.behavior.updateHoverBounds(journal.x, journal.y, journal.width, journal.height);
		journal.cameras = [uiCamera];
		journal.behavior.onHover = () ->
		{
			FlxSpriteUtil.setBrightness(journal, 0.32);
		};
		journal.behavior.onHoverLost = () ->
		{
			FlxSpriteUtil.setBrightness(journal, 0);
		};
		journal.behavior.onClick = () ->
		{
			openSubState(new JournalSubState());
		};
		add(journal);

		openSubState(new TutorialSubState());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		checkForDragging();
		updateCameraZoomsAndScrolls(elapsed);

		// Update the texts
		foodText.text = 'Food: $food';
		waterText.text = 'Water: $water';
		antsText.text = 'Ants: $ants';

		// Check if the user wants to pause the game
		if (FlxG.keys.justPressed.ESCAPE)
		{
			// YO MOM SO BEEG
			// SHE TOO BEEG !!!
			openSubState(new PauseSubState());
		}

		// Check if the user is trying to reset the zoom and
		// the dragged position of the game camera
		if (FlxG.keys.justPressed.R)
		{
			isDragging = false;
			canInteract = false;
			currentZoom = 1;
			FlxTween.cancelTweensOf(gameCamera.scroll);
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
		currentZoom += #if desktop 0.195 #else 0.0015 #end * FlxG.mouse.wheel;
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
