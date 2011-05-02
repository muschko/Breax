package net.muschko.breax {
	import flash.events.Event;
	
	/**
	 * Paddle repräsentiert das Pedal, welches der Spieler steuert
	 * 
	 * @author muschko
	 */
	public class Paddle extends PaddleAsset {
		
		static private const friction:int = 5;
		
		public function Paddle() {
			this.addEventListener(Event.ENTER_FRAME, movePaddle);
		}
		
		public function movePaddle(e:Event):void {

			var endX:int = stage.mouseX;
						
			if (stage.mouseX > stage.width / 2) {
				if (stage.mouseX < stage.stageWidth - this.width/2) {			
					this.x += (endX - this.x - this.width/2) / friction;				
				} else {
					this.x += ((stage.stageWidth - this.width/2) - this.x) / friction;			
				}
			}
			else {
				if (stage.mouseX > this.width/2) {			
					this.x += (endX - this.x) / friction;	
				} else {
					this.x += ((this.width/2) - this.x) / friction;			
				}
			}
			
				
		}
		public function destroy():void {
			this.removeEventListener(Event.ENTER_FRAME, movePaddle);
		}
	}
}
