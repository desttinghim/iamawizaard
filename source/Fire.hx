package;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;

class Fire extends FlxEmitter
{
	public function new(X:Float, Y:Float)
	{
		super( X, Y );
		makeParticles(5,5,FlxColor.ORANGE, 400);

		setSize(25,25);
		scale.set(1, 1, 1.5, 1.5, 2, 2, 3, 3);
		angle.set(-45, 45);
		lifespan.set(0.5, 3);
		color.set(FlxColor.ORANGE, 0x0FFFFFFF, 0x0F0000);
		acceleration.set(-0.1, -100, 50, -50, -0.1, -100, 0.1, -50);
		velocity.set(-.1, -20, .1, -10);
		launchMode = FlxEmitterMode.SQUARE;

		start(false, 0.01, 0);
	}
}
