package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;

class GameOver extends FlxSubState
{
	public function new()
	{
		super(0xff000000);
		var gameOverText:FlxText = new FlxText(0, 0, 0 ,"GAME OVER");
		gameOverText.scrollFactor.set( 0, 0 );
		gameOverText.screenCenter();
		add(gameOverText);
	}

	override public function update(dt:Float):Void
	{
		if(FlxG.gamepads.lastActive != null)
			if(FlxG.gamepads.lastActive.justPressed.ANY)
				close();
		if(FlxG.keys.justPressed.ANY)
			close();
		super.update(dt);
	}

	override public function close():Void
	{
		FlxG.switchState(new PlayState());
	}
}