package;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;

class Fire extends FlxEmitter
{
	public function new(X:Float, Y:Float)
	{
		super( X, Y );
		makeParticles(2,2,FlxColor.ORANGE, 400);

		setSize(25,25);
		scale.set(1, 1, 1.5, 1.5, 2, 2, 3, 3);
		angle.set(-90, 90);
		lifespan.set(0.5, 2);
		color.set(FlxColor.ORANGE, FlxColor.WHITE, FlxColor.BLACK);
		acceleration.set(-0.1, -100, 0.1, -50, -0.1, -100, 0.1, -50);
		velocity.set(-.1, -20, .1, -10);

		start(false, 0.02, 0);
	}
}