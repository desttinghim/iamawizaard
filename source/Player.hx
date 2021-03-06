package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

class Player extends FlxSprite
{
	var _maxWalkSpeed:Int = 140;
	var _maxRunSpeed:Int = 200;
	var _gravity:Int = 1600;
	var _maxFallSpeed:Int = 800;
	var _jumpForce:Int = 420;
	var _maxAcceleration:Int = 1000;
	var _drag:Int = 1000;

	public function new(X:Float, Y:Float)
	{
		super(X * 16, Y * 16 - 24);
		loadGraphic( "assets/images/andi.png", true, 32, 32);
		setSize(14, 24);
		offset.set(9, 8);

		animation.add("idle", [for (i in  0...64) i < 63 ? 0 : 8]);
		animation.add("walk", [for (i in 0...8) i], 16);
		animation.add("run", [for (i in 0...8) i], 24);
		animation.add("jump", [15]);
		animation.add("skid", [14]);
		animation.add("check", [9, 10, 11], 16, false);
		animation.add("death", [12]);

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		maxVelocity.y = _maxFallSpeed;
		acceleration.y = _gravity;
		drag.x = _drag;
	}

	public var hasWon:Bool = false;

	override public function update(elapsedTime:Float):Void
	{
		if (alive && !hasWon) controls();
		if(!hasWon) animate();
		levelConstraints();
		super.update(elapsedTime);
	}

	var joyPad:FlxGamepad;

	function controls():Void
	{
		var xForce:Float = 0;
		var running:Bool = false;
		var jumping:Bool = false;
		var fireball:Bool = false;

		if(joyPad == null) joyPad = FlxG.gamepads.lastActive;
		else {
			var xAxis:Float = joyPad.getXAxis(FlxGamepadInputID.LEFT_ANALOG_STICK);
			if(Math.abs(xAxis) > 0.3) xForce += xAxis;
			if(joyPad.anyJustPressed([FlxGamepadInputID.A])) jumping = true;
			else if (joyPad.anyJustReleased([FlxGamepadInputID.A]) && velocity.y < 0) velocity.y = velocity.y * 0.5;
			if(joyPad.anyJustPressed([FlxGamepadInputID.X])) running = true;
		}

		if(FlxG.keys.anyPressed(["LEFT", "A"])) xForce--;
		if(FlxG.keys.anyPressed(["RIGHT", "D"])) xForce++;
		if(FlxG.keys.anyJustPressed(["SPACE", "UP", "W", "C"])) jumping = true;
		if(FlxG.keys.anyJustReleased(["SPACE", "UP", "W", "C"])) velocity.y *= 0.5;
		if(FlxG.keys.anyJustReleased(["SHIFT", "X"])) running = true;

		// fireball code
		if(FlxG.mouse.justReleased) Reg.state.fireFireball();
		// end fireball code

		xForce = FlxMath.bound(xForce, -1, 1);
		maxVelocity.x = running ? _maxRunSpeed : _maxWalkSpeed;
		acceleration.x = xForce * _maxAcceleration;
		if(jumping && isTouching(FlxObject.FLOOR))
		{
			var finalJumpForces:Float = -(_jumpForce + Math.abs(velocity.x * .25));
			velocity.y = finalJumpForces;
		}
	} //function controls

	function animate():Void
	{
		if(acceleration.x > 0) facing = FlxObject.RIGHT;
		else if(acceleration.x < 0) facing = FlxObject.LEFT;

		if(!alive) animation.play("death");
		else if(!isTouching(FlxObject.FLOOR)) animation.play("jump");
		else {
			if(velocity.x == 0) animation.play("idle");
			else if(velocity.x > 0 && acceleration.x < 0 || velocity.x < 0 && acceleration.x > 0) animation.play("skid");
			else if(Math.abs(velocity.x) > _maxWalkSpeed) {
				animation.play("run");
			}
			else animation.play("walk");

		}
	}

	function levelConstraints():Void
	{
		if(x < 0) velocity.x = _maxRunSpeed;
		else if (x > Reg.state.level.width - 16) velocity.x = -_maxRunSpeed;
		if(alive && y > Reg.state.level.height) kill();
	}

	override public function kill():Void
	{
		alive = false;
		velocity.set(0, -500);
		acceleration.x = 0;
		allowCollisions = FlxObject.NONE;
		new FlxTimer().start(1, Reg.state.gameOver);
	}
}
