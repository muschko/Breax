package 
net.muschko.breax {
	import com.greensock.plugins.TintPlugin;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.ui.Mouse;
	import flash.display.DisplayObject;
	import com.greensock.easing.Expo;
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
		private var levelDone:LevelDoneAsset;
		private var howToPlay:HowToPlayAsset;
		private var soundClip:Sound;
		private var sndChannel:SoundChannel;
				
		static private const TITLE_SCREEN:String = "title";
		static private const GAME_SCREEN:String = "game";
		static private const GAME_OVER_SCREEN:String = "gameover";
		static private const LEVEL_DONE:String = "levelDone";
		static private const HOW_TO_PLAY:String = "howToPlay";
		
				
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
			addEventListener(HOW_TO_PLAY, setupHowToPlay);
					
			dispatchEvent(new Event(TITLE_SCREEN));	
			
			soundClip = new Sound();
			sndChannel = new SoundChannel();
			
			soundClip.load(new URLRequest("music.mp3"));
			soundClip.addEventListener(Event.COMPLETE,onSoundComplete,false,0,true);
			
		}
		
		public function setupTitle(e:Event):void {
									
			titleScreen = new TitleAsset();
			addChild(titleScreen);			
			titleScreen.y = 150;
			
			titleScreen.btnNewGame.addEventListener(MouseEvent.MOUSE_OVER, menuMouseOver);
			titleScreen.btnHowToPlay.addEventListener(MouseEvent.MOUSE_OVER, menuMouseOver);
			titleScreen.btnNewGame.addEventListener(MouseEvent.MOUSE_OUT, menuMouseOut);
			titleScreen.btnHowToPlay.addEventListener(MouseEvent.MOUSE_OUT, menuMouseOut);
			titleScreen.btnNewGame.addEventListener(MouseEvent.MOUSE_DOWN, newGame);
			titleScreen.btnHowToPlay.addEventListener(MouseEvent.MOUSE_DOWN, goToHowToPlay);
			
			titleScreen.btnNewGame.buttonMode = true;
			titleScreen.btnNewGame.useHandCursor = true;
						
			titleScreen.btnHowToPlay.buttonMode = true;
			titleScreen.btnHowToPlay.useHandCursor = true;
			
		}
		
		public function setupGame(e:Event):void {		
			removeChild(titleScreen);
			
			game = new Game();
			addChild(game);
			game.addEventListener(GAME_OVER_SCREEN, setupGameOver);	
			game.addEventListener(LEVEL_DONE, setupLevelDone);
						
			game.init();

		}
		
		public function setupGameOver(e:Event):void {
			
			Mouse.show();
			
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
		private function goToHowToPlay(e:Event):void {
			dispatchEventWithParam(HOW_TO_PLAY);	
		}
		
		public function setupLevelDone(e:Event):void {
			levelDone = new LevelDoneAsset();
			addChild(levelDone);
			
			levelDone.alpha = 0;
			
			TweenMax.to(levelDone, 0.5, {alpha:1});
			
			stage.addEventListener(MouseEvent.CLICK, nextLevel);
			
		}
		
		private function setupHowToPlay(e:Event):void {
			
			howToPlay = new HowToPlayAsset();
			addChild(howToPlay);			
			howToPlay.alpha = 0;			
			TweenMax.to(howToPlay, 0.5, {alpha:1});
			
			stage.addEventListener(MouseEvent.CLICK, removeMovieClip);
			
		}
		

		private function backToTitle(e:Event):void {
			
			Mouse.show();
			
			stage.removeEventListener(MouseEvent.CLICK, backToTitle);
			
			removeChild(gameOverScreen);
			removeChild(game);
			
			dispatchEvent(new Event(TITLE_SCREEN));
		}
		
		private function nextLevel(e:Event):void {
			
			Mouse.hide();
			
			stage.removeEventListener(MouseEvent.CLICK, backToTitle);
			stage.removeEventListener(MouseEvent.CLICK, nextLevel);
							
			TweenMax.to(levelDone.LevelDoneInfo, 0.5, {alpha: 0, y: stage.stageHeight+100,ease:Expo.easeInOut, rotation: 20, onComplete:game.goToNextLevel});
			
			TweenMax.to(levelDone, 0.5, {alpha: 0});
					
		}
		
		private function dispatchEventWithParam(event:String):void {
			dispatchEvent(new Event(event));
		}
		
		private function removeMovieClip(e:Event):void {
			stage.removeEventListener(MouseEvent.CLICK, removeMovieClip);
			
			removeChild(e.target as DisplayObject);
		}
		
		private function onSoundComplete(e:Event):void {
			
			var sndTransform:SoundTransform = new SoundTransform();
			sndTransform.volume = 0.2;

			sndChannel=soundClip.play(0,999,sndTransform);			
			
		}	
				
		private function menuMouseOver(e:Event):void {
			TweenMax.to(e.currentTarget, 0.2, {alpha:0.5, x: e.currentTarget.x + 10});	
		}
		private function menuMouseOut(e:Event):void {
			TweenMax.to(e.currentTarget, 0.2, {alpha:1, x: 115});	
		}
		
	}

}
