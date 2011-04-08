package 
net.muschko.breax {
	import com.greensock.TweenMax;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;

	public class Breax extends MovieClip
	{
		private var titleScreen:TitleAsset;
		private var game:Game;
		
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
									
			titleScreen = new TitleAsset();
			addChild(titleScreen);			
			titleScreen.y = 150;
			
			titleScreen.btnNewGame.addEventListener(MouseEvent.MOUSE_OVER, menuMouseOver);
			titleScreen.btnHighscore.addEventListener(MouseEvent.MOUSE_OVER, menuMouseOver);
			titleScreen.btnNewGame.addEventListener(MouseEvent.MOUSE_OUT, menuMouseOut);
			titleScreen.btnHighscore.addEventListener(MouseEvent.MOUSE_OUT, menuMouseOut);
			titleScreen.btnNewGame.addEventListener(MouseEvent.MOUSE_DOWN, newGame);
			
			titleScreen.btnNewGame.buttonMode = true;
			titleScreen.btnNewGame.useHandCursor = true;
						
			titleScreen.btnHighscore.buttonMode = true;
			titleScreen.btnHighscore.useHandCursor = true;
			
		}
		
		public function setupGame(e:Event):void {		
			removeChild(titleScreen);
			
			game = new Game();
			addChild(game);
			
			game.init();

		}
		
		public function setupGameOver(e:Event):void {			
		}
		
		private function newGame(e:Event):void {
			TweenMax.to(titleScreen, 1, {alpha:0, onComplete:dispatchEventWithParam, onCompleteParams:[GAME_SCREEN]});	
		}
		
		private function menuMouseOver(e:Event):void {
			TweenMax.to(e.currentTarget, 0.5, {alpha:0.5});	
		}
		private function menuMouseOut(e:Event):void {
			TweenMax.to(e.currentTarget, 0.5, {alpha:1});	
		}
		
		private function dispatchEventWithParam(event:String):void {
			dispatchEvent(new Event(event));
		}
		
	}

}
