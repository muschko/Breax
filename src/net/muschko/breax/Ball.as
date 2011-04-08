package net.muschko.breax {
	import flash.events.Event;
	/**
	 * @author muschko
	 */
	public class Ball extends BallAsset{
		
		private var speed:int;
		private var xspeed:int;
		private var yspeed:int;		
		
		public function Ball(speed:int) {
			this.speed = speed;
		}
		
		public function moveBall(e:Event):void {
			
			this.x +=speed;
			this.y +=speed;
			
			xspeed = speed * Math.cos((45) * Math.PI / 180);
			yspeed = speed * Math.sin((45) * Math.PI / 180);		
		
		}
		
	}
}
