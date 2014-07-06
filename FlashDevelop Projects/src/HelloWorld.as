package
{
	import org.flixel.*; //Allows you to refer to flixel objects in your code 
	[SWF(width="640", height="480", backgroundColor="#ABCC7D")] //Set the size and color of the Flash file
	/**
	 * ...
	 * @author Celestics
	 */
	public class HelloWorld  extends FlxGame
	{
		
		public function HelloWorld() 
		{
			super(640,480,MenuState,1); //Create a new FlxGame object at 640x480 with 1x pixels, then load PlayState
		}
		
	}
}