package net.muschko.breax {

	/**
	 * Repräsentiert einen Brick-Stein
	 * @author muschko
	 */
	public class Brick extends BrickAsset {
		
		private static const HEIGHT:int = 20;
		private static const WIDTH:int = 30;
		private var destructable:Boolean = true;
		
		public function Brick() {
		}

		static public function get _HEIGHT() : int {
			return HEIGHT;
		}

		static public function get _WIDTH() : int {
			return WIDTH;
		}

		public function get _destructable() : Boolean {
			return destructable;
		}

		public function set _destructable(destructable : Boolean) : void {
			this.destructable = destructable;
		}
		
		
	}
}
