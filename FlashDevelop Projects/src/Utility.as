package  
{
	import org.flixel.FlxU;
	
	/**
	 * Utility Class.
	 * Used for mathematical operations.
	 * 
	 * @author Celestics
	 */
	public class Utility 
	{
		private var seed:Number;
		
		public function Utility(s:Number) 
		{
			seed = s;
		}
		
		public function nextRandom():Number
		{
			var next:Number = FlxU.srand(seed);
			seed = next;
			return next;
		}
	}

}