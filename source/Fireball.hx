package ;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Fireball extends FlxSprite
{
    public function new(startX:Float, starY:Float, X:Float, Y:Float)
    {
        super();

        makeGraphic(4, 4, FlxColor.ORANGE);

        velocity.x = X;
        velocity.y = Y;
    } // new
}
