package play.substates;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TutorialSubState extends FlxSubState
{

    var bg:FlxSprite;
    var tutorialText:FlxText;
    var tutorialState:Int;
    var currentY:Float;
    var newY:Float;
    var hasTweened:Bool = false;

    override function create() 
    {
        super.create();

        bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height);
        bg.alpha = 0.65;
        add(bg);

        tutorialText = new FlxText();
        tutorialText.text = 'Welcome to Antlantis!';
        tutorialText.size = 100;
        tutorialText.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
        tutorialText.screenCenter(X);
        tutorialText.y = -FlxG.height;
        add(tutorialText);

        FlxTween.tween(tutorialText, {y:298.5}, 0.5, {
            ease:FlxEase.quadInOut
        });
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE)
        {
            tutorialState += 1;
        }

        if (tutorialState == 1)
        {
            tutorialText.text = 
            '
            As the queen ant, your job is to grow your anthill,
            manage your colony, and keep your ants safe!
            ';
            tutorialText.size = 50;
            tutorialText.screenCenter(XY);
            currentY = tutorialText.y;
            newY = currentY + 40;
        }

        if (tutorialState == 2)
        {
            tutorialText.text =
            '
            Sometimes, your anthill will be attacked by Antlions,
            Beetles, and even other kinds of ants!
            ';
            tutorialText.screenCenter(XY);
        }

        if (tutorialState == 3)
        {
            tutorialText.text =
            '
            When your anthill gets attacked, be sure to send your best ants at
            the predators and keep your colony safe
            ';
            tutorialText.screenCenter(XY);
        }

        if(tutorialState == 4)
        {
            close();
        }
    }
}