class GameEvent
{
	type:String;
	timestamp:number;
	params:Number[];
	
	public function Event(ty:String, ti:number, pl:Number[])
	{
		type = ty;
		time = ti;
		params = new Number[2]
		params[0] = pl[0];
		params[1] = pl[1];
		params[2] = pl[2];
	}
	
	override public function run():void
	{
		
	}
}