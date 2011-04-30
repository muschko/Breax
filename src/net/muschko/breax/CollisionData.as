package net.muschko.breax 
{
	public class CollisionData
	{
	    public var target:AABB;     // das getroffene objekt
	    public var side:int;        // getroffene kante
	    public var x:int, y:int;    // schnittpunkt
	    public var distance:Number; // zurückgelegte distanz
	        
	    public function CollisionData(_target:AABB, _x:int, _y:int) {
	        target = _target;
	        x      = _x;
	        y      = _y;
	    }
	}
}
