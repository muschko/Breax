package net.muschko.breax {
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
							
		public function Game() {
		}
		
		public function init():void {
			
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
			
			ball.setXspeed(ball.getSpeed() * Math.cos((300) * Math.PI / 180));
			ball.setYspeed(ball.getSpeed() * Math.sin((300) * Math.PI / 180));			
	
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
			addChild(level);			
			level.alpha = 0;
			level.createLevel(1);
			TweenMax.to(level, 0.5, {alpha: 1});
			
			// First kick
			stage.addEventListener(MouseEvent.MOUSE_DOWN, kickBall);
			
			// Listener für Lebensverlust
			this.addEventListener("lostLife", lifeLost);		
		}
		
		private function createLevel():void {
			
		}
		
		private function kickBall(e:Event):void {
			firstKick = false;
			ball.removeEventListener(Event.ENTER_FRAME, placeBallonPaddle);
			
			this.addEventListener(Event.ENTER_FRAME, frameScript);
		}
		
		private function placeBallonPaddle(e:Event):void {
			ball.x = paddle.x+paddle.width/2;
			ball.y = paddle.y-ball.height/2-3;
		}
		
		private function frameScript(e:Event):void {
							
			ball.x += ball.getXspeed();
			ball.y += ball.getYspeed();			
					
			if (ball.x >= stage.stageWidth - ball.width/2 || ball.x <= ball.width/2) {
				ball.setXspeed(-(ball.getXspeed()));		
			} else if (ball.y <= ball.height/2) {
				ball.setYspeed(-(ball.getYspeed()));
			} else if (ball.y >= stage.stageHeight + ball.height) {
				// Leben verlieren
				this.removeEventListener(Event.ENTER_FRAME, frameScript);
				dispatchEvent(new Event("lostLife"));
			} 
			if (paddle.hitTestObject(ball)) {
				 
				// 5 Punkte für Pedal
				score = score + 5;
				scoreTextField.text = score.toString(); 
				 
				ball.setYspeed(-(ball.getYspeed()));

                var pixelsLeftRight:int = 25;
                
                if ((ball.x > (paddle.x + paddle.width - pixelsLeftRight)) && (ball.getXspeed() < 0)) {
                    // : Impact auf der rechten "Kante" und Ball kam von rechts
                    // : X Richtung umdrehen
                    ball.setXspeed(-(ball.getXspeed()));
                } else
                if ((ball.x + ball.width <= paddle.x + pixelsLeftRight) && (ball.getXspeed() > 0)) {
                    // : Impact auf der linken "Kante" und Ball kam von links
                    // : X Richtung umdrehen
                   ball.setXspeed(-(ball.getXspeed()));
                }
									
			}else {
				
				for(var i:int = 0; i<=level.getBricks().length-1; i++) {
					
					var brick:Brick = level.getBricks()[i];
					
					if (ball.hitTestObject(brick)) {
						
						ball.setYspeed(-(ball.getYspeed()));
						
						if ( brick.getDestructable()) {
							TweenMax.to(brick, 0.5, {alpha: 0, y: brick.y+10, rotation: 20, onComplete: removeBrickChild, onCompleteParams: [brick]});						
							level.getBricks().splice(level.getBricks().indexOf(brick),1);
							score = score + brick.getScore();
							scoreTextField.text = score.toString();
							break;
						}
						// Falls power up hier unterdrücken: ball.setYspeed(-(ball.getYspeed()));	
					}
				}
				
			}
			 
		}
		
		
		private function lifeLost(e:Event):void {
			TweenMax.to(paddle,0.3,{alpha:0});
			TweenMax.to(ball,0.3,{alpha:0});
			trace("lost life");
			
			if (lifes.length != 0) {
				TweenMax.to(lifes[lifes.length-1], 0.5, {alpha: 0, y: lifes[lifes.length-1].y+10, rotation: 20, onComplete: prepareNewGame});
				lifes.splice(lifes.length-1);
			} else {
				scoreTextField.text = "";
				dispatchEvent(new Event("gameover"));
			}
						
		}
		
		private function prepareNewGame():void {
			TweenMax.to(paddle,0.3,{alpha:1});
			TweenMax.to(ball,0.3,{alpha:1});
			
			ball.setXspeed(ball.getSpeed() * Math.cos((300) * Math.PI / 180));
			ball.setYspeed(ball.getSpeed() * Math.sin((300) * Math.PI / 180));
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, kickBall);
			ball.addEventListener(Event.ENTER_FRAME, placeBallonPaddle);
		}
		
		private function removeBrickChild(brick:Brick):void {
			level.removeChild(brick);
		}
	}
}
