package net.muschko.breax.aabb
{
	public class Ray
	{
		public var x:Number, y:Number, vx:Number, vy:Number;
		public var length:Number, angle:Number;
		private var d:Number, t:Number, s:Number;
		
		public function Ray(x1:Number, y1:Number, x2:Number, y2:Number) {
			recompose(x1, y1, x2 - x1, y2 - y1);
		}
		
		public function intersect(r:Ray, cdata:CollisionData) : Boolean {
			d =  vx * r.vy - vy * r.vx;
			t = -(x * r.vy - y * r.vx - r.x * r.vy + r.y * r.vx) / d;
			s = -(x * vy - y * vx + vx * r.y - vy * r.x) / d;
			if ((t > 0 && s > 0) && (t < 1 && s < 1)) {
				cdata.x = x + (d = vx * t);
				cdata.y = y + (s = vy * t);
				cdata.distance	= Math.sqrt(d * d + s * s);
				return true;
			}
			return false;
		}
		
		public function recompose(x:Number, y:Number, vx:Number, vy:Number, ext:Number = 0) : void {
			this.x  = x;  this.y  = y;
			this.vx = vx; this.vy = vy;
			length  = Math.sqrt(vy * vy + vx * vx);
			angle   = Math.atan2(vy, vx);
			if (ext) normalize(length + ext);
		}
		
		public function normalize(value:Number) : void {
			vx *= value / length;
			vy *= value / length;
			length = value;
		}
	}

}