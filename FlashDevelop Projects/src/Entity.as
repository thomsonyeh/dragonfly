package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * Entity Class.
	 * Defines how owners are cast for Bullets.
	 * 
	 * @author Celestics
	 */
	public class Entity extends FlxSprite
	{
		public function Entity(x:int, y:int, img:Class) 
		{
			super(x, y, img);
		}
	}

}