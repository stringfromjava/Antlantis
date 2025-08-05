// public car
package;

import flixel.FlxSprite;
#if web
import js.Browser;
#end
import flixel.text.FlxText;
import backend.util.LoggerUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.math.FlxMath;
import backend.util.CacheUtil;
import backend.util.FlixelUtil;
import lime.app.Application;
import backend.data.ClientPrefs;
import menus.MainMenuState;
import backend.util.PathUtil;
import flixel.system.FlxAssets;
import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		LoggerUtil.initialize();
		ClientPrefs.loadAll();
		configureFlixelSettings();
		addEventListeners();

		#if web
		var clickMeText:FlxText = new FlxText();
		clickMeText.text = 'Click the screen to start!';
		clickMeText.size = 64;
		clickMeText.underline = true;
		clickMeText.screenCenter(XY);
		add(clickMeText);
		#end

		#if !web
		FlxG.switchState(() -> new MainMenuState());
		#end
	}

	#if web
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed)
		{
			FlxG.switchState(() -> new MainMenuState());
		}
	}
	#end

	function configureFlixelSettings():Void
	{
		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;
		FlxAssets.FONT_DEFAULT = PathUtil.ofFont('Orange Kid');
		FlxAssets.defaultSoundExtension = #if web 'mp3' #else 'ogg' #end;

		// Disable the right-click context menu for HTML5
		#if html5
		Browser.document.addEventListener('contextmenu', (e) ->
		{
			e.preventDefault();
		});
		#end
	}

	function addEventListeners():Void
	{
		#if desktop
		// Maximize/Minimize volume when the window is gets/loses focus
		Application.current.window.onFocusIn.add(() ->
		{
			// Bring the volume back up when the window is focused again
			if (ClientPrefs.getOption('minimizeVolume') && !CacheUtil.isWindowFocused)
			{
				// Set back to one decimal place (0.1) when the screen gains focus again
				// (note that if the user had the volume all the way down, it will be set to zero)
				FlxG.sound.volume = (!(Math.abs(FlxG.sound.volume) < FlxMath.EPSILON)) ? 0.1 : 0;
				CacheUtil.isWindowFocused = true;
				// Set the volume back to the last volume used
				FlxTween.num(FlxG.sound.volume, CacheUtil.lastVolumeUsed, 0.3, {type: FlxTweenType.ONESHOT}, (v:Float) ->
				{
					FlxG.sound.volume = v;
				});
			}
		});
		Application.current.window.onFocusOut.add(() ->
		{
			// Minimize the volume when the window loses focus
			if (ClientPrefs.getOption('minimizeVolume') && CacheUtil.isWindowFocused)
			{
				// Set the last volume used to the current volume
				CacheUtil.lastVolumeUsed = FlxG.sound.volume;
				CacheUtil.isWindowFocused = false;
				// Tween the volume to 0.05
				FlxTween.num(FlxG.sound.volume, (!(Math.abs(FlxG.sound.volume) < FlxMath.EPSILON)) ? 0.05 : 0, 0.3, {type: FlxTweenType.ONESHOT}, (v:Float) ->
				{
					FlxG.sound.volume = v;
				});
			}
		});

		// Fullscreen :sparkles:
		FlxG.signals.postUpdate.add(() ->
		{
			if (FlxG.keys.justPressed.F11)
			{
				FlxG.fullscreen = !FlxG.fullscreen;
			}
		});
		#end

		// Add a click animation and play a sound when the
		// user clicks anywhere on the screen
		FlxG.signals.postUpdate.add(() ->
		{
			if (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight)
			{
				var clickSpr:FlxSprite = new FlxSprite().loadGraphic(PathUtil.ofSharedImage('mario'));
				clickSpr.setGraphicSize(20, 20);
				clickSpr.updateHitbox();
				clickSpr.setPosition(FlxG.mouse.viewX - (clickSpr.width / 2), FlxG.mouse.viewY - (clickSpr.height / 2));
				FlxG.state.add(clickSpr);
				FlxG.sound.play(PathUtil.ofSharedSound('click'), ClientPrefs.getOption('clickVolume'), () ->
				{
					FlxG.state.remove(clickSpr, true);
				});
			}
		});

		Application.current.window.onClose.add(() ->
		{
			FlixelUtil.closeGame(false);
		});
	}
}
