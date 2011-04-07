package 
net.muschko.breax{
	import flash.events.Event;
	import flash.display.MovieClip;

	public class Breax extends MovieClip
	{
		private var paddle:Paddle;
		static private const TITLE_SCREEN:String = "title";
		static private const GAME_SCREEN:String = "game";
		static private const GAME_OVER_SCREEN:String = "gameover";
		
		
		public function Breax()
		{
			initBreax();					
		}
		
		private function initBreax():void {
			addEventListener(TITLE_SCREEN, setupTitle);
			addEventListener(GAME_SCREEN, setupGame);
			addEventListener(GAME_OVER_SCREEN, setupGameOver);
			
			dispatchEvent(new Event(TITLE_SCREEN));		
		}
		
		public function setupTitle(e:Event):void {
			paddle = new Paddle();
			addChild(paddle);
		}
		
		public function setupGame(e:Event):void {
			
		}
		
		public function setupGameOver(e:Event):void {
			
			
			
		}		
		
	}

}
