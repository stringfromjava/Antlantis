package menus;

import flixel.FlxState;
import flixel.text.FlxText;

class MainMenuState extends FlxState
{

    var playText:FlxText;

    override public function create()
    {
        super.create();
        playText = new FlxText();
        playText.text = 'Play';
        playText.screenCenter(X);
        playText.size = 64;
        add(playText);
    }

    override public  function update(elapsed:Float) 
    {
        super.update(elapsed);
    }
}