package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Celestics
	 */
	public class WinState extends FlxState
	{
		//Images.
		[Embed(source = "../assets/sprites/Gopher.png")] private var ImgGopher:Class
		
		//Win Screen.
		private static var winScreen:FlxSprite;
		private var TEXTa:FlxText;
		private var TEXTb:FlxText;
		private var TEXTc:FlxText;
		private var TEXTd:FlxText;
		private var restart:FlxText;
		
		public function WinState() 
		{
			winScreen = new FlxSprite(0, 0, ImgGopher);
			add(winScreen);
			TEXTa = new FlxText(80, 230, 500, "CONGRATULATIONS! YOU'RE WINNER!", true);
			TEXTb = new FlxText(120, 270, 500, "YOU HAVE SURVIVED", true);
			TEXTc = new FlxText(160, 310, 500, "THE BOB ONSLAUGHT!", true);
			TEXTd = new FlxText(200, 350, 500, "GET A GOPHER!", true);
			restart = new FlxText(460, 440, 200, "(Enter to Restart)", true);
			TEXTa.size = 20;
			TEXTb.size = 20;
			TEXTc.size = 20;
			TEXTd.size = 20;
			restart.size = 16;
			TEXTa.color = 0;
			TEXTb.color = 0;
			TEXTc.color = 0;
			TEXTd.color = 0;
			restart.color = 0;
			add(TEXTa);
			add(TEXTb);
			add(TEXTc);
			add(TEXTd);
			add(restart);
		}
		
		override public function update():void
		{
			if (FlxG.keys.ENTER)
			{
				FlxG.switchState(new MenuState());
			}
		}
	}

}