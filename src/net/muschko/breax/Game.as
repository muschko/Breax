package net.muschko.breax {
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
		
		private var score:int;
		private var lifes:Array = new Array(new LifeAsset(),new LifeAsset(), new LifeAsset());
		private var paddle:Paddle;
		private var ball:Ball;
		private var firstKick:Boolean = true;
							
		public function Game() {
		}
		
		public function init():void {
			
			// Paddle erstellen
			paddle = new Paddle();
			addChild(paddle);
			
			paddle.alpha = 0;
			paddle.x = stage.stageWidth/2 - paddle.width /2;
			paddle.y = stage.stageHeight - paddle.height;
			TweenMax.to(paddle,0.5,{alpha:1});
			
			// Ball erstellen
			ball = new Ball(5);
			addChild(ball);
			
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
			
			// First kick
			stage.addEventListener(MouseEvent.MOUSE_DOWN, kickBall);			
		}
		
		private function createLevel():void {
			
		}
		
		private function kickBall(e:Event):void {
			firstKick = false;
			
			this.addEventListener(Event.ENTER_FRAME, frameScript);
		}
		
		private function placeBallonPaddle(e:Event):void {
			ball.x = paddle.x+paddle.width/2;
			ball.y = paddle.y-ball.height/2;
		}
		
		private function frameScript(e:Event):void {

					
			ball.x += ball.getSpeed();
			ball.y += ball.getSpeed();
			
			if (ball.hitTestObject(paddle)) {
				
			}
			var xspeed = ball.getSpeed() * Math.cos((45) * Math.PI / 180);
			var yspeed = ball.getSpeed() * Math.sin((45) * Math.PI / 180);		
		
				
		}
	}
}
