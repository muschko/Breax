package net.muschko.breax.aabb
{
	public class Bounds
	{
		public var rays:Vector.<Ray>, collide:Boolean;
		public var collision:CollisionData, ray:Ray;
		private var i:int;
		
		public function Bounds() {
			rays			= new Vector.<Ray>();
			collision	= new CollisionData(this);
			ray			= new Ray(0, 0, 0, 0);
		}
		
		public function detectCollision(source:*, result:Array = null) : Boolean {
			collide = false;
			ray.recompose(source.x, source.y, source.vx, source.vy, 1);
			for (i = 0; i < rays.length; i++) if (rays[i].intersect(ray, collision)) pushCollision(result, i);
			return collide;
		}
		
		public function pushCollision(result:Array, side:int) : void {
			collide			= true;
			collision.side	= side;
			
			if (result) {
				result.push(collision);
				collision = new CollisionData(this);
			}
		}
	}
}