package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * Enemy Class.
	 * @author Celestics
	 */
	public class Enemy extends Entity
	{
		//UTILITY CLASS
		private var util:Utility = PlayState.util;
		
		/** ALL STATIC VARIABLES **/
		
		//Boss Image.
		[Embed(source = "../assets/sprites/EnemyTest.png")] private var ImgEnemy:Class
		//Boss Bullet Image.
		[Embed(source = "../assets/sprites/EnemyBullet.png")] private var ImgBullet:Class
		
		//Movement data.
		private static var X_CHANGE_RATE:int = 5;
		private static var Y_CHANGE_RATE:int = 5;
		
		//Bullet data. Bullet speed should vary with attacks.
		private static var BULLET_SPEED:int = 250; //may be subject to variation
		private static var BULLET_ACCELERATION:FlxPoint = new FlxPoint(0, 0);
		private static var BULLET_LIFE:Number = 2.5;
		private static var BULLET_DELAY:Number = 0.5;
		
		//Boss Bullet Delay (NON-STATIC)
		private var currentBulletDelay:Number;
		
		/** ALL NON-STATIC VARIABLES **/
		
		//Boss Health Statistics.
		public var healthMax:Number = 40.0;
		//note that health is already extended, reset at constructor
		public var healthRegen:Number = 0.3; //per tick
		public var lifetime:Number = 2.0;
		
		//Score Data.
		private var score:int = 500;
		private var degradeRate:int = 3;
		
		/*
		 * Constructor. Takes in (x, y) position coordinates,
		 * v velocity, a acceleration, aa angular acceleration.
		 */
		public function Enemy(x:uint, y:uint, v:FlxPoint, a:FlxPoint, aa:Number) 
		{
			super(x, y, ImgEnemy);
			this.velocity = v;
			this.acceleration = a;
			this.angularAcceleration = aa;
			health = healthMax;
			currentBulletDelay = BULLET_DELAY;
		}
		
		override public function update():void
		{
			//Update position. Randomization of inputs randomizes movements.
			super.update();
			
			//Shoots bullets!
			currentBulletDelay -= FlxG.elapsed;
			if (util.nextRandom() <= 0.1 && currentBulletDelay <= 0.0)
			{
				var b1:Bullet = new Bullet(this, BULLET_LIFE, 1, (this.x+this.frameWidth/2), this.y+this.frameHeight, ImgBullet);
				b1.velocity = new FlxPoint((0.5-util.nextRandom())*100, +BULLET_SPEED-(util.nextRandom()*100));
				b1.acceleration = BULLET_ACCELERATION;
				b1.angularVelocity = 200 - (util.nextRandom() * 1000);
				(FlxG.state as PlayState).add(b1);
				(FlxG.state as PlayState).enemyBullets.add(b1);
				currentBulletDelay = BULLET_DELAY;
			}
			
			//Health checks. Also accounts for lifetime.
			checkHealth();
		}
		
		/** HEALTH-BASED METHODS **/
		
		//Modified kill() method.
		override public function kill():void
		{
			if(health == 0) {(FlxG.state as PlayState).addScore(score);}
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
		
		//Do all healing checks. Accounts for lifetime.
		public function checkHealth():void
		{
			regenerate(FlxG.elapsed);
			lifetime -= FlxG.elapsed;
			if (lifetime <= 0)
				kill();
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