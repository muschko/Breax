package net.muschko.breax.aabb
{
	public class CollisionData
	{
		public var target:Bounds;
		public var x:Number;
		public var y:Number;
		public var side:uint;
		public var distance:Number;
			
		public function CollisionData(target:Bounds = null) {
			this.target = target;
		}
	}
}