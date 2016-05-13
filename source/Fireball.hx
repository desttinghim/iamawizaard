package ;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxVector;
import flixel.effects.particles.FlxEmitter;

class Fireball extends FlxSprite
{
    var speed:Float = 500;
    var emitter:FlxEmitter;

    public function new(startX:Float, startY:Float, endX:Float, endY:Float)
    {
        super();

        makeGraphic(4, 4, FlxColor.ORANGE);
        emitter = new FlxEmitter();
        emitter.makeParticles(5, 5, FlxColor.ORANGE, 20);
        emitter.lifespan.set(1);
        emitter.color.set(FlxColor.ORANGE, 0x0FFFFFFF, 0x0F0000);
        emitter.start(false, 0.1, 0);
        Reg.state.add(emitter);

        var start = new FlxVector(startX, startY);
        var end = new FlxVector(endX, endY);
        var angle = end.subtractNew(start).normalize();

        x = startX;
        y = startY;
        velocity.x = angle.x * speed;
        velocity.y = angle.y * speed;
    } // new

    override function update(delta:Float)
    {
        emitter.setPosition(x, y);

        super.update(delta);
    }
}
