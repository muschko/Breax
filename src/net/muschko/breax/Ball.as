package net.muschko.breax {
	/**
	 * Ballinstanz
	 * @author muschko
	 */
	public class Ball extends BallAsset {
		private var speed : int;
		private var xspeed: int;
		private var yspeed: int;

		public function Ball(speed : int) {
			this.speed = speed;
		}

		public function getSpeed() : int {
			return speed;
		}

		public function setSpeed(speed : int) : void {
			this.speed = speed;
		}

		public function getXspeed() : int {
			return xspeed;
		}

		public function setXspeed(xspeed : int) : void {
			this.xspeed = xspeed;
		}

		public function getYspeed() : int {
			return yspeed;
		}

		public function setYspeed(yspeed : int) : void {
			this.yspeed = yspeed;
		}
		
		
	}
}
