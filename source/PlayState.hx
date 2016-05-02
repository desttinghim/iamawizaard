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
import openfl.Assets;

class PlayState extends FlxState
{
	public var level:FlxTilemap;
	var player:Player;

	override public function create():Void
	{
		super.create();	
		FlxG.camera.bgColor = 0xFF6DC2CA;
		Reg.state = this;

		addLevel();
		addPlayer(2, 22);
		setCamera();
			
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

	function setCamera():Void 
	{
		FlxG.camera.follow( player, FlxCameraFollowStyle.PLATFORMER );
		FlxG.camera.setScrollBoundsRect( 0, 0, level.width, level.height);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide( level, player );

	}

	public function gameOver(?t:FlxTimer):Void{
		openSubState(new GameOver());
	}
}