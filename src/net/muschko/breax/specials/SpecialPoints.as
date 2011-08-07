package net.muschko.breax.specials {
	/**
	 * @author muschko
	 */
	public class SpecialPoints extends SpecialPointAsset implements Special{
		
		private var _points:Number = 500;
		
		public function SpecialPoints() {
		}

		public function get points() : Number {
			return _points;
		}

		public function set points(points : Number) : void {
			_points = points;
		}
	}
}
