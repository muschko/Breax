package net.muschko.breax {
	import flash.geom.Point;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.text.TextFieldAutoSize;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	
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
		private var level:Level;
		private var background:BackgroundAsset;
		private var gameTimer:Timer;
					
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
			ball = new Ball(5);
			addChild(ball);
			
			ball.setXspeed(0);
			ball.setYspeed(5);
			
			ball.y = 300;
			ball.x = 310.5;
			
			//ball.setXspeed(Math.ceil(ball.getSpeed() * Math.cos((300) * Math.PI / 180)));
			//ball.setYspeed(Math.ceil(ball.getSpeed() * Math.sin((300) * Math.PI / 180)));			
	
			ball.addEventListener(Event.ENTER_FRAME, placeBallonPaddle);
			
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
			
			//Level erstellten
			level = new Level();
			level.alpha = 0;
			level.createLevel(currentLevel);
			addChild(level);
			
			TweenMax.to(level, 0.5, {alpha: 1});
			
			// Levebeschreibung setzen
			var format2:TextFormat = new TextFormat(); 
			format2.color = 0x999999; 
			format2.size = 12;
			format2.font = "Helvetica";
			
			levelNameTextField.defaultTextFormat = format2;
			levelNameTextField.x = 12;
			levelNameTextField.y = stage.stageHeight - 80;
			levelNameTextField.autoSize = TextFieldAutoSize.LEFT;
			
			trace("Level: " + level.getLevelName());
			addChild(levelNameTextField);
			
			
			// First kick
			stage.addEventListener(MouseEvent.MOUSE_DOWN, kickBall);
			
			// Listener für Lebensverlust
			this.addEventListener("lostLife", lifeLost);		
		}
		
		private function kickBall(e:Event):void {
			firstKick = false;
			ball.removeEventListener(Event.ENTER_FRAME, placeBallonPaddle);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, kickBall);
			
			gameTimer=new Timer(5);
			gameTimer.addEventListener(TimerEvent.TIMER, frameScript);
			gameTimer.start();			
		}
		
		private function placeBallonPaddle(e:Event):void {
			
			levelNameTextField.text = level.getLevelName().toString();
		}
		
		private function frameScript(e:Event):void {
					
			// Ballbewegung
			ball.x = Math.round(ball.x + ball.getXspeed());
			ball.y = Math.round(ball.y + ball.getYspeed());			
						
			// Spielfeldbegrenzung		
			if (ball.x >= stage.stageWidth - ball.width || ball.x <= ball.width) {
				
				ball.setXspeed(-(ball.getXspeed()));
									
			} else if (ball.y <= 0) {
				
				ball.y = ball.height;
				ball.setYspeed(-(ball.getYspeed()));
				
			} else if (ball.y >= stage.stageHeight + ball.height) {
				
				// Leben verlieren
				gameTimer.removeEventListener(TimerEvent.TIMER, frameScript);
				gameTimer.stop();
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
				
				ball.x = Math.round(ball.x + ball.getXspeed());
				ball.y = Math.round(ball.y + ball.getYspeed());
			}				
		
			
			var kollisionsDaten:Array = new Array;
			kollisionsDaten.length = 0;
	
			for each (var brick:AABB in level.getBricks()) {
				
					brick.detectCollision(ball, kollisionsDaten);							
										
					if (kollisionsDaten.length) {  // kollision vorhanden
					   kollisionsDaten.sortOn("distance", Array.NUMERIC); // objekte anhand der entfernung sortieren
					   
					   var index:int = level.getBricks().indexOf(brick);				   		
					   					   
					   // in kollisionsDaten[0] befindet sich nun das kollisionsobjekt des zuerst getroffenen AABB objektes
					   
					   trace("Kollision mit " + kollisionsDaten[0].target + " | Getroffene Seite: " + kollisionsDaten[0].side);
					   if (kollisionsDaten[0].side == 1) {
					   		
					   		removeBrick(index);					   	
							ball.setXspeed(-(ball.getXspeed()));
							kollisionsDaten.length = 0;
							//break;   
							 
					   }else if(kollisionsDaten[0].side == 2){
						
							removeBrick(index);
					   		ball.setXspeed(-(ball.getXspeed()));
					   		kollisionsDaten.length = 0;
					   		//break;
					   		
					   }else if(kollisionsDaten[0].side == 3){
							
							removeBrick(index);
							ball.setYspeed(-(ball.getYspeed()));
							kollisionsDaten.length = 0;
							//break;
					   		
					   }else if(kollisionsDaten[0].side == 4){

							removeBrick(index);
					   		ball.setYspeed(-(ball.getYspeed()));
					   		kollisionsDaten.length = 0;
					   		//break;
					   }
					   				   				
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
				gameTimer.removeEventListener(TimerEvent.TIMER, frameScript);
				gameTimer.stop();
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
					gameTimer.removeEventListener(TimerEvent.TIMER, frameScript);
					gameTimer.stop();
					levelDone();
					return;							
				}					
			} 
			// Wenn der Ball einen brechbaren Stein trifft
			else if ( brick.getBrick().getBreakable() ) {
				 						 
				 if (brick.currentFrame == 7) {
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
						gameTimer.removeEventListener(TimerEvent.TIMER, frameScript);
						gameTimer.stop();
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
		
		private function prepareNewBall():void {
			
			// Neuen Ball vorbereiten
			TweenMax.to(paddle,0.3,{alpha:1});
			TweenMax.to(ball,0.3,{alpha:1});
			
			ball.setXspeed(0);
			ball.setYspeed(5);
			
			ball.y = 300;
			ball.x = 310.5;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, kickBall);
			ball.addEventListener(Event.ENTER_FRAME, placeBallonPaddle);
		}
		
		private function levelDone():void {
			trace("LEVEL DONE");
		}
	}
}
