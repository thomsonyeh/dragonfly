package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	/**
	 * Bullet Class.
	 * The velocity and acceleration of this bullet is defined by the owner.
	 * Lifetime determines how long it takes before this object is destroyed.
	 * 
	 * @author Celestics
	 */
	public class Bullet extends FlxSprite
	{
		public var owner:Entity;
		public var lifetime:Number;
		public var origLT:Number
		public var damage:Number;
		
		//Basic bullet creator.
		public function Bullet(own:Entity, lt:Number, dmg:Number, x:int, y:int, ImgBullet:Class) 
		{
			super(x, y, ImgBullet);
			owner = own;
			lifetime = lt;
			origLT = lt;
			damage = dmg;
		}
		
		override public function update():void
		{
			//For anything that we missed.
			super.update();
			
			//Lifetime check.
			lifetime -= FlxG.elapsed;
			if (this.alive && lifetime <= 0.0)
			{
				this.kill();
			}
		}
		
		//Kill itself.
		override public function kill():void
		{
			this.exists = false;
			this.lifetime = origLT;
			super.kill();
		}
	}

}