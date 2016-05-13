package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.util.FlxStringUtil;
import flixel.tile.FlxBaseTilemap;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.FlxSubState;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;
import openfl.Assets;

class PlayState extends FlxState
{
	var player:Player;
	var exit:FlxSprite;
	public var level:FlxTilemap;

	override public function create():Void
	{
		FlxG.camera.bgColor = 0xFF6DC2CA;
		Reg.state = this;

		addLevel();
		addPlayer(2, 22);
		add(new Fire(4*16,18*16));
		addExit(118, 19);
		setCamera();

		super.create();
	}

	function addLevel():Void
	{
		level = new FlxTilemap();
		level.loadMapFromCSV(Assets.getText("assets/data/Map1_Level.csv"), "assets/images/tiles.png", 16, 16);
		for (i in 16...31) level.setTileProperties(i, FlxObject.UP);
		for (i in 32...63) level.setTileProperties(i, FlxObject.NONE);
		add(level);
		FlxG.worldBounds.width = level.width;
		FlxG.worldBounds.height = level.height;
	}

	function addPlayer(X:Int, Y:Int):Void
	{
		player = new Player(X, Y);
		add(player);
	}

	function addExit(X:Int, Y:Int):Void
	{
		exit = new FlxSprite(X * 16, Y * 16 - 16);

		#if debug
		exit.makeGraphic(16, 32, 0x80FF0000);
		#else
		exit.makeGraphic(16, 32, 0x00000000);
		#end

		add(exit);
	}

	function setCamera():Void
	{
		FlxG.camera.follow( player, FlxCameraFollowStyle.PLATFORMER );
		FlxG.camera.setScrollBoundsRect( 0, 0, level.width, level.height);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide( level, player );
		FlxG.overlap( exit, player, winGame);

	}

	public function fireFireball()
	{
		add(new Fireball(player.x, player.y, FlxG.mouse.x, FlxG.mouse.y));
	}

	function winGame(e:FlxSprite, p:Player):Void
	{
		if(p.isTouching(FlxObject.FLOOR) && !p.hasWon)
		{
			p.velocity.x = 0;
			p.acceleration.x = 0;
			p.animation.play("check");
			p.hasWon = true;
			new FlxTimer().start(1, leaveStage);
		}
	}

	public function leaveStage(?t:FlxTimer):Void
	{
		openSubState(new WinState());
	}

	public function gameOver(?t:FlxTimer):Void{
		openSubState(new GameOver());
	}
}
