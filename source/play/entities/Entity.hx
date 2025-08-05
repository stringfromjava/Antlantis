package play.entities;

import flixel.group.FlxSpriteGroup;

enum abstract EntityType(String) from String to String
{
	public var WORKER:String = 'WORKER';
	public var DEFENDER:String = 'DEFENDER';
	public var ENEMY:String = 'ENEMY';
}

typedef EntityData = {
    var id:String;
    var name:String;
    var health:Float;
    var type:EntityType;
    var activityStart:Float;
    var activityEnd:Float;
    @:optional var strength:Float;
    @:optional var isHostile:Bool;
}

class Entity extends FlxSpriteGroup
{
	public var id:String;
	public var name:String;
	public var hp:Float;
	public var type:EntityType;
    public var activityStart:Float;
    public var activityEnd:Float;
	public var strength:Float;
    public var isHostile:Bool;

	public function new(data:EntityData)
	{
		super();
		this.id = data.id;
		this.name = data.name;
		this.hp = data.health;
		this.type = data.type;
		this.activityStart = data.activityStart;
		this.activityEnd = data.activityEnd;
        this.strength = (data.strength != null) ? data.strength : (type == EntityType.ENEMY || type == EntityType.DEFENDER) ? 1 : 0;
        this.isHostile = (data.isHostile != null) ? data.isHostile : (type == EntityType.ENEMY) ? true : false;
	}
}
