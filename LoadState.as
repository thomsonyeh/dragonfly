package
{
	import org.flixel.*;
	import org.flixel.system.FlxList;
	/**
	 * ...
	 * @author Celestics
	 */
	public class LoadState extends FlxState
	{
		//List of Events. This will go to the PlayState.
		public static var musicData:FlxList = new FlxList;
		
		//Raw String Input.
		public var rawData:String = "";
		
		public function LoadState()
		{
			
		}
		
		override public function create():void
		{
			trace("Hello world");
		}
		
		override public function update():void
		{
			trace("Hello world");
		}
	}

}