package net.muschko.breax {

	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import net.muschko.breax.aabb.AABB;
	import net.muschko.breax.Ball;
	import net.muschko.breax.Level;
	
	/**
	 * GameEngine für Brix
	 * 
	 * @author muschko
	 */
	public class Game extends MovieClip{
		
		public var score:int;
		private var scoreTextField:TextField;
		private var levelNameTextField:TextField;
		private var lifes:Array = new Array(new LifeAsset(),new LifeAsset(), new LifeAsset());
		private var paddle:Paddle;
		private var ball:Ball;
		private var firstKick:Boolean = true;
		private var currentLevel:int = 1;
		private var maxLevel:int = 20;
		private var level:Level;
		private var background:BackgroundAsset;
		private var kollisionsDaten:Array = new Array;
		private var ballStartPositionY:int = 400;
		private var ballStartPositionX:int = 322.5;
					
		public function Game() {
		}
		
		public function init():void {
			
			// Background
			background = new BackgroundAsset();
			addChild(background);	
			
			// Paddle erstellen
			paddle = new Paddle();
			addChild(paddle);
			
			paddle.alpha = 0;
			paddle.x = stage.stageWidth/2 - paddle.width /2;
			paddle.y = stage.stageHeight - paddle.height - 5;
			TweenMax.to(paddle,0.5,{alpha:1});
			
			// Ball erstellen
			ball = new Ball(0);
			addChild(ball);
			
			ball.setXspeed(0);
			ball.setYspeed(0);
			
			ball.y = ballStartPositionY;
			ball.x = ballStartPositionX;
			
			// Leben erstellen
			for (var i:int = 0; i<= lifes.length -1; i++) {
				
				var life:LifeAsset = lifes[i];
				addChild(life);
				
				life.alpha = 0;
				TweenMax.to(life,0.5, {alpha:1});
				
				if (i == 0) {
					life.x = 15;
					life.y = stage.stageHeight - 40;
				} else {
					life.x = lifes[i-1].x+life.width + 3;
					life.y = stage.stageHeight - 40;
				}
								
			}
			
			// Score & Levelname erstellen
			scoreTextField = new TextField();
			levelNameTextField = new TextField();
			
			var format1:TextFormat = new TextFormat(); 
			format1.color = 0x333333; 
			format1.size = 20;
			format1.font = "Helvetica";			
			
			scoreTextField.defaultTextFormat = format1;
			scoreTextField.x = 12;
			scoreTextField.y = stage.stageHeight - 65;
			scoreTextField.text = score.toString();
			
			addChild(scoreTextField);				
			
			// Levebeschreibung setzen
			var format2:TextFormat = new TextFormat(); 
			format2.color = 0x666666; 
			format2.size = 11;
			format2.font = "Helvetica";
			
			levelNameTextField.defaultTextFormat = format2;
			levelNameTextField.x = 12;
			levelNameTextField.y = stage.stageHeight - 80;
			levelNameTextField.autoSize = TextFieldAutoSize.LEFT;

			addChild(levelNameTextField);		
			
			//Level erstellten
			level = new Level();
			level.alpha = 0;
			level.createLevel(currentLevel);
						
			level.addEventListener(Event.ADDED, setLevelName);
			
			addChild(level);
			
			TweenMax.to(level, 0.5, {alpha: 1});
						
			// First kick
			stage.addEventListener(MouseEvent.MOUSE_DOWN, kickBall);
			
			// Listener für Lebensverlust
			this.addEventListener("lostLife", lifeLost);	
			
			addEventListener(Event.ENTER_FRAME, frameScript);	
		}
		
		private function setLevelName(e:Event):void {
			level.removeEventListener(Event.ADDED, setLevelName);
			levelNameTextField.text = level.getLevelName().toString();	
		}
		
		private function kickBall(e:Event):void {
			
			firstKick = false;
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, kickBall);
			
			ball.setXspeed(0);
			ball.setYspeed(-5);			
				
		}		
		
		private function frameScript(e:Event):void {			
			
			// Ballbewegung
			ball.x = ball.x + ball.getXspeed();
			ball.y = ball.y + ball.getYspeed();	
			
			paddle.movePaddle();		
						
			// Spielfeldbegrenzung		
			if (ball.x >= stage.stageWidth - ball.width ) {
				
				ball.x = stage.stageWidth - ball.width;
				ball.setXspeed(-(ball.getXspeed()));
				
			}
			else if(ball.x <= 0) {
				
				ball.x = 0;
				ball.setXspeed(-(ball.getXspeed()));
			
			}						
			else if (ball.y <= 0) {
				
				ball.y = ball.height;
				ball.setYspeed(-(ball.getYspeed()));
				
			} else if (ball.y >= stage.stageHeight + ball.height) {
				
				// Leben verlieren
				removeEventListener(Event.ENTER_FRAME, frameScript);
				dispatchEvent(new Event("lostLife"));
			} 
			
			if (paddle.hitTestObject(ball)) {
			
				// 5 Punkte für Pedal
				score = score + 5;
				scoreTextField.text = score.toString(); 
				 
				if (ball.getYspeed()>0) {
					
					if (ball.getYspeed()>6) {
						
						ball.setYspeed(ball.getYspeed()*-1);
						
					} else {
						
						ball.setYspeed(ball.getYspeed()*-1.05);
						
					}
					ball.setXspeed(ball.getXspeed() + (ball.x - paddle.x) * 0.05);
				}
				
				ball.x = ball.x + ball.getXspeed();
				ball.y = ball.y + ball.getYspeed();
			}
			

			kollisionsDaten.length = 0;
	
			for each (var brick:AABB in level.getBricks()) {
				
				brick.detectCollision(ball, kollisionsDaten);							
			}				
								
			if (kollisionsDaten.length) {  // kollision vorhanden
			   
			   kollisionsDaten.sortOn("distance", Array.NUMERIC); // objekte anhand der entfernung sortieren
			   
			   var index:int = level.getBricks().indexOf(kollisionsDaten[0].target);				   		
			   					   
			   if (kollisionsDaten[0].side == 2) {
			   		
			   		removeBrick(index);					   	
					ball.setXspeed(-(ball.getXspeed()));
					 
			   }else if(kollisionsDaten[0].side == 3){
				
					removeBrick(index);
			   		ball.setXspeed(-(ball.getXspeed()));
			   		
			   }else if(kollisionsDaten[0].side == 1){
					
					removeBrick(index);
					ball.setYspeed(-(ball.getYspeed()));
			   		
			   }else if(kollisionsDaten[0].side == 0){

					removeBrick(index);
			   		ball.setYspeed(-(ball.getYspeed()));
			   }					   			
				
			}
		 
		}
		
			
		private function lifeLost(e:Event):void {
			
			TweenMax.to(paddle,0.3,{alpha:0});
			TweenMax.to(ball,0.3,{alpha:0});
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, kickBall);
			
			// Check ob noch genug Leben verfügbar sind
			if (lifes.length != 0) {
				TweenMax.to(lifes[lifes.length-1], 0.5, {alpha: 0, y: lifes[lifes.length-1].y+10, rotation: 20, onComplete: prepareNewBall});
				lifes.splice(lifes.length-1);
				trace(lifes.length);
			} else {
				scoreTextField.text = "";
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, kickBall);
				removeEventListener(Event.ENTER_FRAME, frameScript);
				paddle.destroy();
				removeChild(ball);
				dispatchEvent(new Event("gameover"));
			}
						
		}
		
		private function removeBrick(index:int):void {		
			
			var brick:AABB = level.getBricks()[index];	
			
			// Wenn der Ball einen zerstörbaren Stein trifft						
			if (brick.getBrick().getDestructable()) {					
										
				// Stein entfernen
				TweenMax.to(brick.getBrick(), 0.5, {alpha: 0, y: brick.getBrick().y+10, rotation: Math.random()*20, onComplete:removeBrickChild, onCompleteParams:[brick.getBrick()]});						
				level.getBricks().splice(level.getBricks().indexOf(brick),1);
				level.getPointBricks().splice(level.getPointBricks().indexOf(brick),1);
				
				// Punkte hinzufügen
				score = score + brick.getBrick().getScore();
				scoreTextField.text = score.toString();	
									
				// Level geschafft
				if (level.getPointBricks().length == 0) {
					removeEventListener(Event.ENTER_FRAME, frameScript);
					levelDone();
					return;							
				}					
			} 
			// Wenn der Ball einen brechbaren Stein trifft
			else if ( brick.getBrick().getBreakable() ) {
				 						 
				 if (brick.getBrick().currentFrame == 7) {
				 	// Anderen Sprite anzeigen "brüchigen Stein"
				 	brick.getBrick().gotoAndStop(8);
				 } else {
				 	// Stein entfernen
				 	TweenMax.to(brick.getBrick(), 0.5, {alpha: 0, y: brick.getBrick().y+10, rotation: Math.random()*20, onComplete:removeBrickChild, onCompleteParams:[brick.getBrick()]});						
					level.getBricks().splice(level.getBricks().indexOf(brick),1);
					level.getPointBricks().splice(level.getPointBricks().indexOf(brick),1);
										
					// Punkte hinzufügen
					score = score + brick.getBrick().getScore();
					scoreTextField.text = score.toString();	

					// Level geschafft
					if (level.getPointBricks().length == 0) {
						removeEventListener(Event.ENTER_FRAME, frameScript);
						levelDone();
					}					
				 }						 
			}
			// Stein ist nicht zerstörbar!					
			else {
				// Ball abprallen lassen
			}
										
				
		}
		
		private function removeBrickChild(brick:Brick):void {
			level.removeChild(brick);
		}
		
		public function prepareNewBall():void {
			
			// Neuen Ball vorbereiten
			TweenMax.to(paddle,0.3,{alpha:1});
			TweenMax.to(ball,0.3,{alpha:1});
			
			ball.setXspeed(0);
			ball.setYspeed(0);
			
			ball.y = ballStartPositionY;
			ball.x = ballStartPositionX;
			
			addEventListener(Event.ENTER_FRAME, frameScript);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, kickBall);
		}
		
		private function levelDone():void {

			// Leven beenden & Neuen Screen aufbauen
			dispatchEvent(new Event("levelDone"));

		}
		
		public function goToNextLevel():void {
			
			// Altes Level löschen
			removeChild(level);
			
			// Nächstes Level
			currentLevel++;
			
			// Ball vorbereiten
			prepareNewBall();
			
			level = new Level();
			
			// Neues Level erstellen
			level.createLevel(currentLevel);
			
			level.addEventListener(Event.ADDED, setLevelName);
			
			// Neues Level auf stage platzieren
			addChild(level);
			
			// Level einfaden
			level.alpha = 0;
			TweenMax.to(level, 0.5, {alpha: 1});
		}

		public function getCurrentLevel() : int {
			return currentLevel;
		}

		public function setCurrentLevel(currentLevel : int) : void {
			this.currentLevel = currentLevel;
		}
	}
}
