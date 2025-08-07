// public car
package ui.options;

import backend.util.SaveUtil;
import backend.data.Constants;
import backend.data.ClientPrefs;
import flixel.FlxG;
import backend.util.PathUtil;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;

/**
 * Object for creating an option that is of type `Bool`.
 * (This is displayed as a checkbox, obviously.)
 */
class OptionCheckBox extends Option
{
	private var _isChecked:Bool = false;

	private var _checkmarkSymbol:FlxSprite;
	private var _displayText:UIClickableText;

	private var _isValidBoolPref:Bool;

	private var _callback:Void->Void;

	/**
	 * Constructor.
	 * 
	 * @param x           The X coordinate of the checkbox.
	 * @param y           The Y coordinate of the checkbox.
	 * @param name        The name of the checkbox.
	 * @param option      The option key associated with the checkbox. 
	 *                    (This is the preference ID that is made in `SaveVariables` in `backend.data.ClientPrefs`.)
	 * @param description A description of the checkbox (default is '[No Description Set]').
	 */
	public function new(x:Float, y:Float, name:String, option:String, canBeClickedOn:Bool = false, callback:Void->Void = null,
			description:String = '[No Description Set]')
	{
		this._isValidBoolPref = Type.typeof(ClientPrefs.getOption(option)) == TBool;
		this._isChecked = (this._isValidBoolPref) ? ClientPrefs.getOption(option) : false;

		super(name, option, description);

		this._callback = callback;

		_checkmarkSymbol = new FlxSprite();
		_checkmarkSymbol.loadGraphic(PathUtil.ofSharedImage((this._isValidBoolPref) ? (_isChecked) ? 'checked' : 'unchecked' : 'unchecked'));
		_checkmarkSymbol.scale.set(5, 5);
		_checkmarkSymbol.updateHitbox();
		_checkmarkSymbol.x = x;
		_checkmarkSymbol.y = y;
		_displayText = new UIClickableText();
		_displayText.text = (this._isValidBoolPref) ? name : 'OPTION "$option" IS NOT A VALID BOOLEAN';
		_displayText.color = FlxColor.WHITE;
		_displayText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);
		_displayText.size = Constants.OPTION_DISPLAY_TEXT_SIZE;
		_displayText.updateHitbox();
		_displayText.x = (this._checkmarkSymbol.x + this._checkmarkSymbol.width) + 10;
		_displayText.y = (this._checkmarkSymbol.y) + (this._checkmarkSymbol.height - this._displayText.height);
		_displayText.behavior.updateHoverBounds(
            _displayText.x,
            _displayText.y,
            _displayText.width,
            _displayText.height
        );
		this._displayText.behavior.onClick = (canBeClickedOn) ? onSelected : () -> {};

		this.add(this._checkmarkSymbol);
		this.add(this._displayText);
	}

	public function onSelected():Void
	{
		if (this._isValidBoolPref)
		{
			this._isChecked = !this._isChecked;
			ClientPrefs.setOption(this._option, this._isChecked);
			this._checkmarkSymbol.loadGraphic(PathUtil.ofSharedImage((_isChecked) ? 'checked' : 'unchecked'));
			this._checkmarkSymbol.updateHitbox();
			FlxG.sound.play(PathUtil.ofSharedSound((_isChecked) ? 'select' : 'unselect'), 0.8);
			if (_callback != null)
				_callback();
			this._isChecked = ClientPrefs.getOption(option);
		}
		else
		{
			FlxG.camera.shake(0.03, 0.1);
			FlxG.sound.play(PathUtil.ofSharedSound('nope'));
		}
	}
}
