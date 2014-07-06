package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * Boss Class.
	 * @author Celestics
	 */
	public class Boss extends Entity
	{
		//UTILITY CLASS
		private var util:Utility = PlayState.util;
		
		/** ALL STATIC VARIABLES **/
		
		//Boss Image.
		[Embed(source = "../assets/sprites/Boss.png")] private var ImgBoss:Class
		//Boss Bullet Images.
		[Embed(source = "../assets/sprites/EnemyBullet.png")] public static var ImgEBullet:Class
		[Embed(source = "../assets/sprites/BulletMedium.png")] public static var ImgMBullet:Class
		private var imageList:Array;
		
		//Movement data.
		private static var X_CHANGE_RATE:int = 2;
		private static var Y_CHANGE_RATE:int = 2;
		private static var LEFT_LIMIT:int = FlxG.width / 6;
		private static var RIGHT_LIMIT:int = 5 * FlxG.width / 6;
		
		//Bullet data. Bullet speed should vary with attacks.
		public static var BULLET_SPEED:int = 380; //may be subject to variation
		public static var BULLET_ACCELERATION:FlxPoint = new FlxPoint(0, 0);
		public static var BULLET_LIFE:Number = 1.8;
		public static var BULLET_DELAY:Number = 0.4;
		
		//Boss Bullet Delay (NON-STATIC)
		private var currentBulletDelay:Number;
		
		/** ALL NON-STATIC VARIABLES **/
		
		//Boss Health Statistics.
		public var healthMax:Number = 30000.0;
		//note that health is already extended, reset at constructor
		public var healthRegen:Number = 0.02; //per tick
		
		//Directional movement data.
		public var directionMode:int = -1; //-1 is left (neg), 1 is right (pos)
		
		//Score Data.
		private var score:int = 5000000;
		private var degradeRate:int = 711;
		
		public function Boss(x:uint, y:uint) 
		{
			super(x, y, ImgBoss);
			health = healthMax;
			currentBulletDelay = BULLET_DELAY;
			imageList = new Array(ImgEBullet, ImgMBullet);
		}
		
		override public function update():void
		{
			//Update position. May switch direction as permits.
			if(directionMode == -1) //neg
			{
				this.x -= X_CHANGE_RATE;
				if (this.x <= LEFT_LIMIT)
					directionMode = 1;
			}
			else if(directionMode == 1) //pos
			{
				this.x += X_CHANGE_RATE;
				if (this.x >= RIGHT_LIMIT)
					directionMode = -1;
			}
			else
			{
				this.x = 0;
				this.y = 0;
			}
			/*
			if (util.nextRandom() < 0.02)
			{
				directionMode *= -1;
			}
			*/
			
			//Shoots bullets!
			currentBulletDelay -= FlxG.elapsed;
			if (util.nextRandom() <= 0.3 && currentBulletDelay <= 0.0)
			{
				var b1:Bullet = (Bullet)((FlxG.state as PlayState).enemyBullets.getFirstAvailable());
				if (b1 != null)
				{
					b1.x = (this.x + (this.frameWidth / 2));
					b1.y = this.y;
					b1.velocity = new FlxPoint((0.5 - util.nextRandom()) * 100, +BULLET_SPEED - (util.nextRandom() * 100));
					b1.acceleration = BULLET_ACCELERATION;
					b1.angularVelocity = 200 - (util.nextRandom() * 1000);
					b1.lifetime = Boss.BULLET_LIFE;
					(FlxG.state as PlayState).add(b1);
					b1.exists = true;
					b1.alive = true;
					currentBulletDelay = BULLET_DELAY;
				}
			}
			
			//Scoring Change!
			score -= degradeRate;
			
			//Health checks.
			checkHealth();
		}
		
		/** HEALTH-BASED METHODS **/
		
		//Modified kill() method.
		override public function kill():void
		{
			(FlxG.state as PlayState).addScore(score);
			(FlxG.state as PlayState).enemyGroup.remove(this);
			super.kill();
		}
		
		//Modified hurt(dmg) method.
		override public function hurt(dmg:Number):void
		{
			super.hurt(dmg);
			(FlxG.state as PlayState).addScore(10);
			healthNormalize();
		}
		
		//Do all healing checks.
		public function checkHealth():void
		{
			regenerate(FlxG.elapsed);
		}
		
		//Heals for a fixed amount.
		public function heal(amt:Number):void
		{
			health += amt;
			healthNormalize();
		}
		
		//Regenerates health. Call consistently during update.
		public function regenerate(time:Number):void
		{
			heal(healthRegen * time + (util.nextRandom()*2));
		}
		
		//Normalizes health (keeps it within valid range).
		public function healthNormalize():void
		{
			if (health > healthMax)
				health = healthMax;
			if (health < 0)
				health = 0;
		}
	}

}