package play.substates;

import backend.util.FlixelUtil;
import flixel.util.FlxCollision;
import menus.MainMenuState;
import ui.UIClickableText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSubState;

class PauseSubstate extends FlxSubState
{

    var text:FlxText;
    var resumeText:UIClickableText;
    var toMenuText:UIClickableText;
    var gameQuitText:UIClickableText;
    var bg:FlxSprite;

    override function create() 
    {
        super.create();

        bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height);
        bg.alpha = 0;
        add(bg);

        text = new FlxText();
        text.text = 'GAME PAUSED';
        text.size = 80;
        text.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
        text.screenCenter(X);
        text.alpha = 0;
        add(text);

        resumeText = new UIClickableText();
        resumeText.text = 'Resume Game';
        resumeText.size = 64;
        resumeText.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
        resumeText.screenCenter(X);
        resumeText.y = 200;
        resumeText.alpha = 0;
        resumeText.behavior.updateHoverBounds(resumeText.x, resumeText.y, resumeText.width, resumeText.height);
        resumeText.behavior.onClick = () -> 
        {
            close();
        };
        add(resumeText);

        toMenuText = new UIClickableText();
        toMenuText.text = 'To Main Menu';
        toMenuText.size = 64;
        toMenuText.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
        toMenuText.screenCenter(X);
        toMenuText.y = 300;
        toMenuText.alpha = 0;
        toMenuText.behavior.updateHoverBounds(toMenuText.x, toMenuText.y, toMenuText.width, toMenuText.height);
        toMenuText.behavior.onClick = () ->
        {
            FlxG.switchState(() -> new MainMenuState());
        };
        add(toMenuText);

        gameQuitText = new UIClickableText();
        gameQuitText.text = 'Quit Game';
        gameQuitText.size = 64;
        gameQuitText.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
        gameQuitText.screenCenter(X);
        gameQuitText.y = 400;
        gameQuitText.alpha = 0;
        gameQuitText.behavior.updateHoverBounds(gameQuitText.x, gameQuitText.y, gameQuitText.width, gameQuitText.height);
        gameQuitText.behavior.onClick = () ->
        {
            FlixelUtil.closeGame();
        }
        add (gameQuitText);

        FlxTween.tween(bg, {alpha:0.65}, 0.43, {
            ease: FlxEase.quadInOut
        });

        FlxTween.tween(text, {alpha:1}, 0.43, {
            ease: FlxEase.quadInOut
        });

        FlxTween.tween(resumeText, {alpha:1}, 0.43, {
            ease: FlxEase.quadInOut
        });

        FlxTween.tween(toMenuText, {alpha:1}, 0.43, {
            ease: FlxEase.quadInOut
        });

        FlxTween.tween(gameQuitText, {alpha:1}, 0.43, {
            ease: FlxEase.quadInOut
        });
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ESCAPE)
        {
            close();
        }
    }
}