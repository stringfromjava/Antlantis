package play.entities;

import flixel.ui.FlxBar;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

abstract class Entity extends FlxSpriteGroup
{
	public var id:String;
	public var name:String;
	public var hp:Float;
    public var activityStart:Float;
    public var activityEnd:Float;

	public var sprite:FlxSprite;
	public var bar:FlxBar;

	public function new(id, name, hp = 1.0, activityStart = 0.0, activityEnd = 1200.0)
	{
		super();
		this.id = id;
		this.name = name;
		this.hp = hp;
		this.activityStart = activityStart;
		this.activityEnd = activityEnd;
		bar = new FlxBar();
	}
}
