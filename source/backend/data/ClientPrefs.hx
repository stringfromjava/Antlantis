// public car
package backend.data;

import backend.util.FlixelUtil;
import backend.util.LoggerUtil;
import backend.util.PathUtil;
import backend.util.SaveUtil;
import flixel.FlxG;
import flixel.util.FlxSave;

/**
 * Class that handles, modifies and stores the user's
 * options and settings.
 * 
 * When you are updating a setting, use `setOption()` to update a user's option(s)
 * or `setBind()` to change a bind.
 * 
 * Controls are saved in their own variable, *NOT* in `options`.
 * 
 * The way controls are created is with this structure: `'keybind_id' => FlxKey.YOUR_KEY`.
 * To create a control, go to or search for `DEFAULT_CONTROLS_KEYBOARD` and then add your controls accordingly.
 * 
 * To access controls, use `backend.Controls`. (**TIP**: Read `backend.Controls`'s
 * documentation for how to access if binds are pressed!)
 */
final class ClientPrefs
{
	/**
	 * The default options for the game. These are only really used when
	 * the player wants to reset their options, has updated the game ***OR*** 
	 * is missing anything important.
	 */
	static final DEFAULT_OPTIONS:Map<String, Any> = [
		'discordRPC' => true,
		'minimizeVolume' => true,
		'fullscreen' => false,
		'clickVolume' => 1.0
	];

	/**
	 * The options the user currently has set.
	 */
	static var options:Map<String, Any> = DEFAULT_OPTIONS;

	function new() {}

	//
	// GETTERS AND SETTERS
	// =====================================

	/**
	 * Get and return the default options for the user.
	 * 
	 * @return A `Map` of the default options.
	 */
	public static inline function getDefaultOptions():Map<String, Any>
	{
		return DEFAULT_OPTIONS.copy();
	}

	/**
	 * Get and return a user's option by its ID.
	 * 
	 * @param option The option to get as a `String`.
	 * @return The value of the option.
	 * @exception Exception If the option does not exist.
	 */
	public static function getOption(option:String):Dynamic
	{
		if (options.exists(option))
		{
			return options.get(option);
		}
		else
		{
			FlixelUtil.crashGame('Client option "$option" doesn\'t exist!');
		}
		return null;
	}

	/**
	 * Get and return all of the user's current options.
	 * 
	 * @return A `Map` of all of the user's options.
	 */
	public static inline function getOptions():Map<String, Any>
	{
		return options.copy();
	}

	/**
	 * Sets a client's option.
	 * 
	 * @param option The setting to be set.
	 * @param value  The value to set the option to.
	 * @throws Exception If the option does not exist.
	 */
	public static function setOption(option:String, value:Any):Void
	{
		if (options.exists(option))
		{
			options.set(option, value); // TODO: Figure out how to make this type-safe!
			LoggerUtil.log('Set client option "$option" to "$value".', false);
			SaveUtil.saveUserOptions();
		}
		else
		{
			FlixelUtil.crashGame('Client option "$option" doesn\'t exist!');
		}
	}

	//
	// METHODS
	// =============================

	/**
	 * Load and set all of the user's options and controls.
	 * 
	 * This function should only be called ONCE when the game is being initialized!
	 */
	public static function loadAll():Void
	{
		LoggerUtil.log('Loading all client preferences');

		var optionsData:FlxSave = new FlxSave();
		var controlsData:FlxSave = new FlxSave();

		optionsData.bind(Constants.OPTIONS_SAVE_BIND_ID, PathUtil.getSavePath());

		if (optionsData.data.options != null)
		{
			options = optionsData.data.options;
		}
		else
		{
			options = getDefaultOptions();
			LoggerUtil.log('No options save data was found! Using default options', WARNING);
		}

		// Check if the user has any new options
		// (this is for when new options are added in an update!)
		for (option in DEFAULT_OPTIONS.keys())
		{
			if (!options.exists(option))
			{
				options.set(option, DEFAULT_OPTIONS.get(option));
			}
		}

		// Filter out any options that are not present in the current
		// standard set of options (which is determined by the default options)
		for (option in options.keys())
		{
			if (!DEFAULT_OPTIONS.exists(option))
			{
				options.remove(option);
			}
		}

		// Set the volume to the last used volume the user had
		if (optionsData.data.lastVolume != null)
		{
			FlxG.sound.volume = optionsData.data.lastVolume;
		}
		else
		{
			FlxG.sound.volume = 1.0;
		}

		// Respectfully close the saves to prevent data leaks
		optionsData.close();
		controlsData.close();
	}
}
