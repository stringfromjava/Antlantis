// public car
package play.entities;

import flixel.ui.FlxBar;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

abstract class Entity extends FlxSpriteGroup
{
	public var hp:Float;
	public var activityStart:Float;
	public var activityEnd:Float;

	public var sprite:FlxSprite;
	public var bar:FlxBar;

	public function new(hp = 1.0, activityStart = 0.0, activityEnd = 1200.0)
	{
		super();
		this.hp = hp;
		this.activityStart = activityStart;
		this.activityEnd = activityEnd;
		bar = new FlxBar();
		sprite = new FlxSprite();
		add(bar);
		add(sprite);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		bar.x = sprite.x + (sprite.width - bar.width) / 2;
		bar.y = sprite.y - bar.height - 2;
	}
}
