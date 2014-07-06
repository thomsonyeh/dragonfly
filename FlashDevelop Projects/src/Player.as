package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	/**
	 * Player Class.
	 * 
	 * @author Celestics
	 */
	public class Player extends Entity
	{
		//UTILITY CLASS
		private var util:Utility = PlayState.util;
		
		/** ALL STATIC VARIABLES **/
		
		//Player Image.
		[Embed(source = "../assets/sprites/PlayerTest.png")] private var ImgPlayer:Class
		//Player Bullet Image.
		[Embed(source = "../assets/sprites/PlayerBullet.png")] public static var ImgBullet:Class
		
		//Player Movement Speed.
		private static var X_CHANGE_RATE:int = 5;
		private static var Y_CHANGE_RATE:int = 4;
		private static var X_SHIFT_RATE:int = 3; //decrease speed
		private static var Y_SHIFT_RATE:int = 2; //decrease speed
		
		//Bullet Statistics.
		public static var BULLET_SPEED:int = 420;
		public static var BULLET_ACCELERATION:FlxPoint = new FlxPoint(0, -15);
		public static var BULLET_LIFE:Number = 2.0;
		public static var BULLET_DAMAGE:Number = 30;
		private static var BULLET_DELAY:Number = 0.01;
		
		//Player Bounds to prevent world exiting.
		private static var PLAYER_BOUNDS:int = 10;
		
		/** ALL NON-STATIC VARIABLES **/
		
		//Player health statistics are insignificant, single hit kills
		
		//Player Bullet Delay.
		private var currentBulletDelay:Number;
		
		public function Player(x:uint, y:uint) 
		{
			super(x, y, ImgPlayer);
			currentBulletDelay = BULLET_DELAY;
		}
		
		override public function update():void
		{
			//Update position.
			if(FlxG.keys.LEFT)
			{
				this.x -= X_CHANGE_RATE;
				if (FlxG.keys.SHIFT)
					this.x += X_SHIFT_RATE;
			}
			if(FlxG.keys.RIGHT)
			{
				this.x += X_CHANGE_RATE;
				if (FlxG.keys.SHIFT)
					this.x -= X_SHIFT_RATE;
			}
			if(FlxG.keys.UP)
			{
				util.nextRandom(); //to help with randomization
				this.y -= Y_CHANGE_RATE;
				if (FlxG.keys.SHIFT)
					this.y += Y_SHIFT_RATE;
			}
			if(FlxG.keys.DOWN)
			{
				this.y += Y_CHANGE_RATE;
				if (FlxG.keys.SHIFT)
					this.y -= Y_SHIFT_RATE;
			}
			relocate();
			
			//Shoots bullets!
			currentBulletDelay -= FlxG.elapsed;
			if (FlxG.keys.SPACE && currentBulletDelay <= 0.0)
			{
				var b1:Bullet = (Bullet)((FlxG.state as PlayState).playerBullets.getFirstAvailable());
				if (b1 != null)
				{
					b1.x = (this.x + (this.frameWidth / 2));
					b1.y = this.y;
					b1.velocity = new FlxPoint((0.5 - util.nextRandom()) * 100, -BULLET_SPEED + (util.nextRandom() * 100));
					b1.acceleration = BULLET_ACCELERATION;
					b1.angularVelocity = 200 + (util.nextRandom() * 1000);
					b1.lifetime = Player.BULLET_LIFE;
					(FlxG.state as PlayState).add(b1);
					b1.exists = true;
					b1.alive = true;
					currentBulletDelay = BULLET_DELAY;
				}
			}
		}
		
		//Location-checking. If the player would be out of bounds, reset the location.
		public function relocate():void
		{
			if (this.x <= PLAYER_BOUNDS) this.x = PLAYER_BOUNDS;
			if (this.x >= FlxG.width - PLAYER_BOUNDS - this.frameWidth) this.x = FlxG.width - PLAYER_BOUNDS - this.frameWidth;
			if (this.y <= PLAYER_BOUNDS) this.y = PLAYER_BOUNDS;
			if (this.y >= FlxG.height - PLAYER_BOUNDS - this.frameHeight) this.y = FlxG.height - PLAYER_BOUNDS - this.frameHeight;
		}
		
		//Updated kill() function.
		override public function kill():void
		{
			(FlxG.state as PlayState).addDeaths(1);
			//(FlxG.state as PlayState).playerGroup.remove(this);
			//super.kill();
		}
		
		//Updated hurt(dmg) function.
		override public function hurt(dmg:Number):void
		{
			FlxG.flash(0x00FF0000, 1, null, false);
			(FlxG.state as PlayState).enemyBullets.kill();
			(FlxG.state as PlayState).playerBullets.kill();
			kill();
		}
	}

}