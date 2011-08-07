package net.muschko.breax {
	import flash.events.Event;
	
	/**
	 * Paddle repräsentiert das Pedal, welches der Spieler steuert
	 * 
	 * @author muschko
	 */
	public class Paddle extends PaddleAsset {
		
		static private const friction:int = 5;
		private var endX:int;
		private var myStageWidth:int = 621;
	
		public function Paddle() {
		}
		
		public function movePaddle():void 
		{
			// Maussteuerung
			endX = stage.mouseX;
						
			if (endX > stage.width / 2) {
				if (endX < myStageWidth - this.width/2) {			
					this.x += (endX - this.x - this.width/2) / friction;				
				} else {
					this.x += ((myStageWidth - this.width/2) - this.x) / friction;			
				}
			}
			else {
				if (endX > this.width/2) {			
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
