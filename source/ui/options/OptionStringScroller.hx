package ui.options;

import backend.util.SaveUtil;
import backend.util.PathUtil;
import flixel.FlxG;
import flixel.util.FlxColor;
import backend.data.Constants;
import backend.data.ClientPrefs;
import flixel.text.FlxText;

class OptionStringScroller extends Option
{
	private var _displayText:FlxText;
	private var _options:Array<Any>;
	private var _currentSelectedOption:Any;
	private var _currentIndex:Int;

	public function new(x:Float, y:Float, name:String, option:String, options:Array<Any>, description:String = '[No Description Set]')
	{
		super(name, option, description);

		this._options = options;

		_currentIndex = _options.indexOf(ClientPrefs.getOption(option));
		_currentSelectedOption = _options[_currentIndex];

		_displayText = new FlxText(x, y);
		_displayText.text = '${name}: < ${_currentSelectedOption} >';
		_displayText.size = Constants.OPTION_DISPLAY_TEXT_SIZE;
		_displayText.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
		_displayText.updateHitbox();
		add(_displayText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (isFocused)
		{
			if (FlxG.keys.justPressed.LEFT)
			{
				_changeOption(-1);
			}
			else if (FlxG.keys.justPressed.RIGHT)
			{
				_changeOption(1);
			}
		}
	}

	public function onSelected()
	{
		_changeOption(1);
	}

	private function _changeOption(increment:Int)
	{
		FlxG.sound.play(PathUtil.ofSharedSound('woosh-short'));

		_currentIndex += increment;
		if (_currentIndex == -1)
		{
			_currentIndex = _options.length - 1;
		}
		else if (_currentIndex >= _options.length)
		{
			_currentIndex = 0;
		}

		_currentSelectedOption = _options[_currentIndex];
		ClientPrefs.setOption(_option, _currentSelectedOption);
		_displayText.text = '${name}: < ${_currentSelectedOption} >';

		SaveUtil.saveUserOptions();
	}
}
