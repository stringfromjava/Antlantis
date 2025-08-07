// public car
package play.entities;

import flixel.graphics.frames.FlxAtlasFrames;
import backend.util.PathUtil;

enum abstract AntType(String) from String to String
{
	public var WORKER:String = 'WORKER';
	public var DEFENDER:String = 'DEFENDER';
}

class Ant extends Entity
{
	var type:AntType;

	public function new( hp = 1.0, activityStart = 0.0, activityEnd = 1200.0, type = WORKER)
	{
		var paths:Array<String> = PathUtil.ofEntityTexture('black-ant');
		super(hp, activityStart, activityEnd);
		this.type = type;
		sprite.frames = FlxAtlasFrames.fromSparrow(paths[0], paths[1]);
		sprite.animation.addByIndices('idle', 'black-ant-idle_', [0, 1, 2], '', 4);
		sprite.animation.addByIndices('walk', 'black-ant-walk_', [0, 1, 2, 3, 4, 5, 6, 7, 8], '', 10);
		sprite.scale.set(0.1, 0.1);
		sprite.updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var te:Float = PlayState.instance.timeElapsed;

		if (te > activityStart && te < activityEnd)
		{

		}
	}
}
