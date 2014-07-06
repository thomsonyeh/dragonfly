package  
{
	/**
	 * GameEvent Class.
	 * 
	 * @author Celestics
	 */
	public class GameEvent
	{
		//Type String.
		public var type:String; //either "bullet" or "section"
		
		//Number Timestamp.
		public var timestamp:Number; //time of occurrence
		
		//Number Array of size 2.
		public var data:Array;
		
		public function GameEvent(t:String, ti:Number, d:Array) 
		{
			type = t;
			timestamp = ti;
			data = d;
		}
	}

}