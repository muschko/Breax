package 
net.muschko.breax {
	import com.greensock.plugins.DropShadowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenMax;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	/**
	 * Breax Main Class
	 * 
	 * @author muschko
	 */
	public class Breax extends MovieClip
	{
		private var titleScreen:TitleAsset;
		private var gameOverScreen:GameOverAsset;
		private var game:Game;
		
		static private const TITLE_SCREEN:String = "title";
		static private const GAME_SCREEN:String = "game";
		static private const GAME_OVER_SCREEN:String = "gameover";
		
				
		public function Breax()
		{
			initBreax();					
		}
		
		private function initBreax():void {
			// Plugin für Schatten
			TweenPlugin.activate([DropShadowFilterPlugin]);
			
			// Listener
			addEventListener(TITLE_SCREEN, setupTitle);
			addEventListener(GAME_SCREEN, setupGame);
					
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
			game.addEventListener(GAME_OVER_SCREEN, setupGameOver);			
			
			game.init();

		}
		
		public function setupGameOver(e:Event):void {
			
			gameOverScreen = new GameOverAsset();
			addChild(gameOverScreen);
			
			gameOverScreen.txtGameOverScore.text = game.score.toString();
			gameOverScreen.alpha = 0;
			
			TweenMax.to(gameOverScreen, 0.5, {alpha:1});
			
			stage.addEventListener(MouseEvent.CLICK, backToTitle);
		}
		
		private function newGame(e:Event):void {
			TweenMax.to(titleScreen, 1, {alpha:0, onComplete:dispatchEventWithParam, onCompleteParams:[GAME_SCREEN]});	
		}
		
		private function menuMouseOver(e:Event):void {
			TweenMax.to(e.currentTarget, 0.2, {alpha:0.5, x: e.currentTarget.x + 10});	
		}
		private function menuMouseOut(e:Event):void {
			TweenMax.to(e.currentTarget, 0.2, {alpha:1, x: 115});	
		}
		private function backToTitle(e:Event):void {
			
			stage.removeEventListener(MouseEvent.CLICK, backToTitle);
			
			removeChild(gameOverScreen);
			removeChild(game);
			
			dispatchEvent(new Event(TITLE_SCREEN));
		}
		
		private function dispatchEventWithParam(event:String):void {
			dispatchEvent(new Event(event));
		}
		
	}

}
