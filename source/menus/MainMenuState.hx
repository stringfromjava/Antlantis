package menus;

import backend.util.FlixelUtil;
import flixel.FlxState;
import flixel.text.FlxText;

class MainMenuState extends FlxState
{
    var playText:FlxText;

    override function create()
    {
        super.create();

        FlixelUtil.playMenuMusic();

        playText = new FlxText();
        playText.text = 'Play';
        playText.size = 64;
        playText.screenCenter(X);
        add(playText);
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);
    }
}