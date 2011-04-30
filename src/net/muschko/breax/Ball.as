package net.muschko.breax {
	/**
	 * Ballinstanz
	 * @author muschko
	 */
	public class Ball extends BallAsset {
		private var speed : int;
		public var vx: int;
		public var vy: int;

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
			return vx;
		}

		public function setXspeed(vx : int) : void {
			this.vx = vx;
		}

		public function getYspeed() : int {
			return vy;
		}

		public function setYspeed(vy : int) : void {
			this.vy = vy;
		}
		
		
	}
}
