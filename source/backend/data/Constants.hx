package backend.data;

/**
 * Class that holds all of the general values that do not change.
 */
final class Constants
{
	//
	// SAVE BIND ID'S
	// ======================================

	/**
	 * The name of the save file for the player's options.
	 */
	public static final OPTIONS_SAVE_BIND_ID:String = 'options';

	/**
	 * The name of the save file for the player's progress.
	 */
	public static final PROGRESS_SAVE_BIND_ID:String = 'progress';

	//
	// LOGGING
	// =======================================

	/**
	 * The maximum amount of log files that can be stored in the `logs` folder.
	 */
	public static final MAX_LOG_FILES_LIMIT:Int = 30;

	//
	// MUSIC & SOUNDS
	// =====================================================

	/**
	 * Name of the music that plays when in the main menus.
	 */
	public static final MENU_MUSIC_NAME:String = 'Worthless';

	//
	// PLAYER
	// =======================================

	/**
	 * A `String` that holds characters which are valid for
	 * usernames of players.
	 */
	public static final VALID_SAVE_FILE_CHARACTERS:String = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_';

	//
	// API
	// =============================

	/**
	 * The ID for the app on Discord to display in the user's
	 * "Activity" box, showing that they are playing Antlantis and
	 * for displaying how long they have played it.
	 */
	public static final DISCORD_APP_ID:String = '';

	function new() {}
}
