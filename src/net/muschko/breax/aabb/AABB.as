package net.muschko.breax.aabb
{
	import net.muschko.breax.Brick;
	import net.muschko.breax.aabb.Bounds;
	
	public class AABB extends Bounds
	{
		public var inverted:Boolean;
		private var brick:Brick;
		
		public function AABB(x:Number, y:Number, width:Number, height:Number, inverted:Boolean = false) {
			this.inverted = inverted;
			
			width  /= 2;
			height /= 2;
			rays.push(new Ray(x - width, y - height, x + width, y - height)); // top
			rays.push(new Ray(x - width, y + height, x + width, y + height)); // bottom
			rays.push(new Ray(x - width, y - height, x - width, y + height)); // left
			rays.push(new Ray(x + width, y - height, x + width, y + height)); // right
		}
		
		public override function detectCollision(source:*, result:Array = null) : Boolean {
			collide = false;
			ray.recompose(source.x, source.y, source.vx, source.vy, 1);
			
			if      ((inverted ? -ray.vy : ray.vy) > 0 && ray.intersect(rays[0], collision)) pushCollision(result, 0);
			else if ((inverted ? -ray.vy : ray.vy) < 0 && ray.intersect(rays[1], collision)) pushCollision(result, 1);
			
			if      ((inverted ? -ray.vx : ray.vx) > 0 && ray.intersect(rays[2], collision)) pushCollision(result, 2);
			else if ((inverted ? -ray.vx : ray.vx) < 0 && ray.intersect(rays[3], collision)) pushCollision(result, 3);
			
			return collide;
		}
		
		public function getBrick() : Brick {
			return brick;
		}

		public function setBrick(brick : Brick) : void {
			this.brick = brick;
		}
		
	}
}


	
