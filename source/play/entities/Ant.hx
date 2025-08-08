// public car
package play.entities;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import backend.util.PathUtil;

class Ant extends FlxSprite
{
	public var foodTimer:FlxTimer;
	public var waterTimer:FlxTimer;

	public function new()
	{
		var paths:Array<String> = PathUtil.ofEntityTexture('black-ant');
		super();
		frames = FlxAtlasFrames.fromSparrow(paths[0], paths[1]);
		animation.addByIndices('idle', 'black-ant-idle_', [0, 1, 2], '', 4);
		animation.addByIndices('walk', 'black-ant-walk_', [0, 1, 2, 3, 4, 5, 6, 7, 8], '', 10);
		scale.set(0.1, 0.1);
		updateHitbox();

		foodTimer = new FlxTimer().start(FlxG.random.float(9, 16), (_) ->
		{
			PlayState.instance.food += FlxG.random.int(4, 8);
		});
		waterTimer = new FlxTimer().start(FlxG.random.float(4, 15), (_) ->
		{
			PlayState.instance.water += FlxG.random.int(5, 9);
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
