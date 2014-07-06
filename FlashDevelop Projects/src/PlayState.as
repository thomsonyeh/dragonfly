package
{
	import org.flixel.*;
	import org.flixel.system.FlxList;
	/**
	 * ...
	 * @author Celestics
	 */
	public class PlayState extends FlxState
	{
		//Bullet Images for Events.
		[Embed(source = "../assets/sprites/EnemyBullet.png")] private var ImgEBullet:Class
		[Embed(source = "../assets/sprites/BulletMedium.png")] private var ImgMBullet:Class
		
		//Music.
		[Embed(source = "../assets/sprites/9.mp3")] private var MP3Gangnam:Class
		[Embed(source = "../assets/sprites/PumpkinHill.mp3")] private var MP3PH:Class
		[Embed(source = "../assets/sprites/BeatBlock.mp3")] private var MP3BB:Class
		[Embed(source = "../assets/sprites/Divine.mp3")] private var MP3DV:Class
		
		//UTILITY CLASS
		public static var util:Utility = new Utility(0.1);
		
		//EVENT DATA
		public static var events:FlxList;
		
		//Data on player and enemies.
		public var player:Player;
		public var boss:Boss;
		public var playerGroup:FlxGroup = new FlxGroup(1);
		public var enemyGroup:FlxGroup = new FlxGroup();
		
		//Data on bullet setups.
		public var playerBullets:FlxGroup; //should be recycled
		public var enemyBullets:FlxGroup; //should be recycled - All
		public var beatBullets:FlxGroup; //should be recycled - Beats Only
		public var smallBullets:FlxGroup; //should be recycled - Small Only
		
		//Debugging Health and Other Information (FlxText)
		private var TEXTEnemyHealth:FlxText;
		public var BAREnemyHealth:FlxSprite;
		//For width of health bar.
		public static var MAX_ENEMY_HEALTH_WIDTH:uint = 620;
		public static var MAX_ENEMY_HEALTH_HEIGHT:uint = 5;
		//For height of health bar.
		
		//HUD Score Text.
		private var TEXTScore:FlxText;
		private var score:uint;
		private static var TEXTSCORE_HEIGHT:int = 460;
		private var TEXTDeaths:FlxText;
		private var deaths:uint;
		
		//Timer for Event purposes.
		public var timer:Number;
		private var initMusic:Boolean;
		private var eventSet:Boolean;
		
		//Timer for End of Game.
		public var endTimer:Number;
		private var ended:Boolean;
		private var flashSet:Boolean;
		
		public function PlayState()
		{
			events = LoadState.musicData;
			timer = 0.0;
			initMusic = true;
			eventSet = false;
			endTimer = 10.0;
			ended = false;
			flashSet = true;
			super();
		}
		
		override public function create():void
		{
			//Create and add entities.
			player = new Player(FlxG.width/2, 400);
			boss = new Boss(FlxG.width/2, 50);
			add(player);
			add(boss);
			
			//Update groups and add them.
			playerGroup.add(player);
			enemyGroup.add(boss);
			add(playerGroup);
			add(enemyGroup);
			
			//Set up HUD.
			TEXTEnemyHealth = new FlxText(10, 10, MAX_ENEMY_HEALTH_WIDTH, null, true);
			add(TEXTEnemyHealth);
			BAREnemyHealth = TEXTEnemyHealth.makeGraphic(MAX_ENEMY_HEALTH_WIDTH, MAX_ENEMY_HEALTH_HEIGHT, 0x0000FFFF, false, null);
			add(BAREnemyHealth);
			BAREnemyHealth.x = TEXTEnemyHealth.x;
			BAREnemyHealth.y = TEXTEnemyHealth.y;
			//HUD - Score
			score = 0;
			TEXTScore = new FlxText(10, TEXTSCORE_HEIGHT, 200, scoreToString(score), true);
			add(TEXTScore);
			//HUD - Deaths
			deaths = 0;
			TEXTDeaths = new FlxText(570, TEXTSCORE_HEIGHT, 200, "Deaths: " + deaths, true);
			add(TEXTDeaths);
			
			//Create recyclable groups.
			playerBullets = new FlxGroup(250);
			for (var a:int = 0; a < 250; a++)
			{
				var b1:Bullet = new Bullet(player, Player.BULLET_LIFE, Player.BULLET_DAMAGE, (player.x + player.frameWidth / 2), player.y, Player.ImgBullet);
				b1.exists = false;
				b1.alive = false;
				playerBullets.add(b1);
			}
			enemyBullets = new FlxGroup();
			smallBullets = new FlxGroup(500);
			for (var b:int = 0; b < 500; b++)
			{
				var b2:Bullet = new Bullet(boss, Boss.BULLET_LIFE, 1, (boss.x + boss.frameWidth / 2), boss.y, Boss.ImgEBullet);
				b2.exists = false;
				b2.alive = false;
				smallBullets.add(b2);
				enemyBullets.add(b2);
			}
			beatBullets = new FlxGroup(200);
			for (var c:int = 0; c < 200; c++)
			{
				var b3:Bullet = new Bullet(boss, Boss.BULLET_LIFE, 1, (boss.x + boss.frameWidth / 2), boss.y, Boss.ImgMBullet);
				b3.exists = false;
				b3.alive = false;
				beatBullets.add(b3);
				enemyBullets.add(b3);
			}
		}
		
		override public function update():void
		{
			
			/**
			 * MUSIC HERE!!!
			 */
			
			//Music! Initialize once.
			if (initMusic)
			{
				FlxG.playMusic(MP3Gangnam, 1.0);
				//FlxG.playMusic(MP3PH, 1.0);
				//FlxG.playMusic(MP3BB, 1.0);
				//FlxG.playMusic(MP3DV, 1.0);
				initMusic = false;
			}
			
			if (ended)
			{
				endTimer -= FlxG.elapsed;
				if (endTimer <= 1.5 && flashSet)
				{
					flashSet = false;
					FlxG.flash(0xFFFFFFFF, 2, null, false);
				}
				if (endTimer <= 0)
				{
					FlxG.switchState(new WinState());
				}
			}
			
			timer += FlxG.elapsed;
			checkEvents();
			
			//Calls update() on all objects in the game
			super.update();
			
			FlxG.overlap(playerBullets, enemyGroup, collisionDamage);	//Check to see if any bullets overlap any enemies.
			FlxG.overlap(enemyBullets, playerGroup, collisionDamage);	//Check to see if any bullets overlap the player.
			
			//Redraw the HUD.
			redrawHUD();
		}
		
		//Checks for Event Activation and Updates if necessary.
		public function checkEvents():void
		{
			if (events == null || events.object == null)
			{
				if (eventSet)
				{
					ended = true;
				}
				return;
			}
			var ge:GameEvent = (GameEvent)(events.object);
			if (ge == null)
			{
				trace("null reference to GameEvent");
				return;
			}
			while (events != null && ge != null && eventActive(ge))
			{
				eventSet = true;
				activateEvent(ge);
				events = events.next;
				if (events == null)
				{
					break;
				}
				ge = (GameEvent)(events.object);
			}
		}
		
		//Checks if an Event is active.
		public function eventActive(ge:GameEvent):Boolean
		{
			if (ge == null)
			{
				trace("null reference to GameEvent");
				return false;
			}
			return timer >= ge.timestamp;
		}
		
		//Activates an event.
		public function activateEvent(ge:GameEvent):void
		{
			if (ge == null)
			{
				return;
			}
			if (ge.type == "bullet")
			{
				var magnitudeS:int = 3;//ge.data[0];
				var magnitudeB:int = 1;//ge.data[0];
				var bulletType:int = ge.data[1];
				var bullet_speed:int = 200;
				//create bullets
				switch(bulletType)
				{
					case 0: //BIG
						{
							boss.directionMode *= (util.nextRandom()>0.5 ? -1:1);
							FlxG.flash((uint)(0xFFFFFFFF * util.nextRandom()), 0.5, null, false);
							for (var i:int = 0; i < magnitudeB; i++)
							{
								var xR:int = (int)(Math.round(util.nextRandom() * FlxG.width));
								var yR:int = (int)(Math.round(util.nextRandom() * 2 * FlxG.height / 5));
								var rR:Number = 2*Math.PI*util.nextRandom();
								for (var it:int = 0; it < 1; it++)
								{
									var nextBulletB:Bullet = (Bullet)(beatBullets.getFirstAvailable());
									if (nextBulletB == null)
										return;
									nextBulletB.lifetime = 5.0;
									nextBulletB.x = xR;
									nextBulletB.y = yR;
									nextBulletB.velocity = new FlxPoint(bullet_speed * (0.5-util.nextRandom()), 200+(30*(0.5-util.nextRandom())));
									add(nextBulletB);
									nextBulletB.exists = true;
									nextBulletB.alive = true;
								}
							}
							break;
						}
					case 1: //SMALL
						{
							for (var ib:int = 0; ib < magnitudeS; ib++)
							{
								var xRb:int = (int)(Math.round(util.nextRandom() * FlxG.width));
								var yRb:int = (int)(Math.round(util.nextRandom() * 2 * FlxG.height / 5));
								var rRb:Number = 2*Math.PI*util.nextRandom();
								for (var itb:int = 0; itb < (4*util.nextRandom()); itb++)
								{
									var nextBullet:Bullet = (Bullet)(enemyBullets.getFirstAvailable());
									if (nextBullet == null)
										return;
									nextBullet.lifetime = 5.0;
									nextBullet.x = xRb;
									nextBullet.y = yRb;
									nextBullet.velocity = new FlxPoint(bullet_speed * (0.5 - util.nextRandom()), 200+(40*(0.5-util.nextRandom())));
									add(nextBullet);
									nextBullet.exists = true;
									nextBullet.alive = true;
								}
							}
							break;
						}
				}
			}
			else if (ge.type == "section")
			{
				var end:Number = ge.data[0];
				var loudness:Number = ge.data[1];
			}
		}
		
		//When called, first object (bullet) affects second (entity).
		public function collisionDamage(o1:FlxObject, o2:FlxObject):void
		{
			if (o1 is Bullet)
			{
				var bullet:Bullet = (Bullet)(o1);
				o2.hurt(bullet.damage);
				bullet.kill();
				bullet.exists = false;
			}
			else
			{
				var bullet2:Bullet = (Bullet)(o2);
				o1.hurt(bullet2.damage);
				bullet2.kill();
				bullet2.exists = false;
			}
		}
		
		//Updates the HUD.
		public function redrawHUD():void
		{
			//Check Score.
			redrawScore();
			
			//Check Boss Health.
			redrawBossHealth();
			
			//Check Deaths.
			redrawDeaths();
		}
		
		//Updates Score.
		public function redrawScore():void
		{
			TEXTScore.text = scoreToString(score);
		}
		
		//Updates Boss Health.
		public function redrawBossHealth():void
		{
			if (boss.alive)
			{
				remove(TEXTEnemyHealth);
				remove(BAREnemyHealth);
				TEXTEnemyHealth = new FlxText(10, 10, MAX_ENEMY_HEALTH_WIDTH, null, true);
				add(TEXTEnemyHealth);
				var proportion:uint = (uint)(Math.round(MAX_ENEMY_HEALTH_WIDTH * (boss.health / boss.healthMax)));
				if (proportion <= 0.0) proportion = 1.0;
				BAREnemyHealth = TEXTEnemyHealth.makeGraphic(proportion, MAX_ENEMY_HEALTH_HEIGHT, 0xFF0000FF, false, null);
				add(BAREnemyHealth);
				BAREnemyHealth.x = TEXTEnemyHealth.x;
				BAREnemyHealth.y = TEXTEnemyHealth.y;
			}
			else
			{
				if (TEXTEnemyHealth.alive) remove(TEXTEnemyHealth);
				if (BAREnemyHealth.alive) remove(BAREnemyHealth);
			}
		}
		
		//Counts deaths and visualizes it.
		public function redrawDeaths():void
		{
			TEXTDeaths.text = "Deaths: " + deaths;
		}
		
		//Gives a retro-style scoring string representing the score.
		public function scoreToString(sc:uint):String
		{
			//default String length to 10 digits
			var s:String = "" + sc;
			while (s.length <= 10)
			{
				s = "0" + s;
			}
			return s;
		}
		
		//Adds points to the score.
		public function addScore(add:uint):void
		{
			score += add;
		}
		
		//Adds to deaths.
		public function addDeaths(add:uint):void
		{
			deaths += add;
		}
		
		/** Past this point are UNUSED METHODS. **/
		public function addEnemies():void
		{
			if (util.nextRandom() < 0.05)
			{
				var numSpawn:uint = 1+(uint)(Math.round(2 * util.nextRandom()));
				for (var i:int = 0; i < numSpawn; i++)
				{
					var nextDir:int = 0; //left
					nextDir = (util.nextRandom() < 0.5) ? nextDir : nextDir + 1; //right
					var x:int;
					var y:int;
					var v:FlxPoint;
					var a:FlxPoint;
					var aa:Number;
					switch(nextDir)
					{
						case 0: //left
							{
								x = -30;
								y = util.nextRandom() * FlxG.height / 3;
								v = new FlxPoint(100+200*util.nextRandom(), 0);
								a = new FlxPoint(3*util.nextRandom(), 3*util.nextRandom());
								aa = (util.nextRandom() < 0.5 ? -1 : 1) * 10 * util.nextRandom();
								break;
							}
						default: //right
							{
								x = FlxG.width+30;
								y = util.nextRandom() * FlxG.height / 3;
								v = new FlxPoint(-100-200*util.nextRandom(), 0);
								a = new FlxPoint(-3*util.nextRandom(), -3*util.nextRandom());
								aa = (util.nextRandom() < 0.5 ? -1 : 1) * 10 * util.nextRandom();
								break;
							}
					}
					var nextEnemy:Enemy = new Enemy(x, y, v, a, aa);
					add(nextEnemy);
					enemyGroup.add(nextEnemy);
				}
			}
		}
	}

}