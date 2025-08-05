package play.entities;

enum abstract AntType(String) from String to String
{
	public var WORKER:String = 'WORKER';
	public var DEFENDER:String = 'DEFENDER';
}

class Ant extends Entity
{
	var type:AntType;

	public function new(id, name, hp = 1.0, activityStart = 0.0, activityEnd = 1200.0, type = WORKER)
	{
		super(id, name, hp, activityStart, activityEnd);
		this.type = type;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
