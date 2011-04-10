package net.muschko.breax {

	/**
	 * Repräsentiert einen Brick-Stein
	 * @author muschko
	 */
	public class Brick extends BrickAsset {
		
		private static const HEIGHT:int = 20;
		private static const WIDTH:int = 30;
		private var destructable:Boolean = true;
		private var positionX:int;
		private var positionY:int;
		private var score:int;
		
		public function Brick() {
		}

		public function getHEIGHT() : int {
			return HEIGHT;
		}

		public function getWIDTH() : int {
			return WIDTH;
		}

		public function getDestructable() : Boolean {
			return destructable;
		}

		public function setDestructable(destructable : Boolean) : void {
			this.destructable = destructable;
		}

		public function getPositionX() : int {
			return positionX;
		}

		public function setPositionX(positionX : int) : void {
			this.positionX = positionX;
		}

		public function getPositionY() : int {
			return positionY;
		}

		public function setPositionY(positionY : int) : void {
			this.positionY = positionY;
		}

		public function getScore() : int {
			return score;
		}

		public function setScore(score : int) : void {
			this.score = score;
		}
		
		
	}
}
