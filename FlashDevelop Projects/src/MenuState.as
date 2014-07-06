package  
{
	import org.flixel.*;
	import org.flixel.system.FlxList;
	
	/**
	 * ...
	 * @author Celestics
	 */
	public class MenuState extends FlxState
	{
		override public function create():void
		{
			var t1:FlxText = new FlxText(10, 10, 500, "OHAI THAR (PRESS ENTER TO BEGIN IF YOU DARE)", true);
			var t2:FlxText = new FlxText(30, 50, 500, "But first, a story...", true);
			var t3:FlxText = new FlxText(30, 80, 500, "Once upon a time, a ruler named Bob turned evil.", true);
			var t4:FlxText = new FlxText(30, 110, 500, "He destroyed all of the gophers.", true);
			var t5:FlxText = new FlxText(30, 140, 500, "It is up to you to defeat Bob...", true);
			var t6:FlxText = new FlxText(30, 170, 500, "and restore the Creek Tribe to its former glory!", true);
			var t7:FlxText = new FlxText(30, 200, 500, "You only need to hold him off...", true);
			var t8:FlxText = new FlxText(30, 230, 500, "FOR EVEN HE CANNOT HANDLE THE POWER OF MUSIC!", true);
			t1.size = 12;
			t2.size = 14;
			t3.size = 14;
			t4.size = 14;
			t5.size = 14;
			t6.size = 14;
			t7.size = 14;
			t8.size = 14;
			add(t1);
			add(t2);
			add(t3);
			add(t4);
			add(t5);
			add(t6);
			add(t7);
			add(t8);
		}
		
		override public function update():void
		{
			if (FlxG.keys.ENTER)
			{
				var t:FlxList = new FlxList();
				FlxG.switchState(new LoadState());
			}
		}
	}

}