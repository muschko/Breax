package net.muschko.breax 

{   
	 public class AABB extends Brick
    {
        private var tempData:CollisionData, tempRay:Ray = new Ray(0, 0, 0, 0);
        private var temp1:int, temp2:int, temp3:int, temp4:int;
        private var top:Ray, bottom:Ray, left:Ray, right:Ray;
        private var d:Number, t:Number, s:Number;
		private var brick:Brick;
		        
        public function AABB(x:Number, y:Number, width:int, height:int) {
            width  /= 2;
            height /= 2;
            
            top    = new Ray(x - width, y - height, x + width, y - height);
            bottom = new Ray(x - width, y + height, x + width, y + height);
            left   = new Ray(x - width, y - height, x - width, y + height);
            right  = new Ray(x + width, y - height, x + width, y + height);
        }
        
        public function detectCollision(source:*, resultData:Array) : void {
            tempRay.x1 = source.x;
            tempRay.y1 = source.y;
            tempRay.x2 = source.x + source.vx;
            tempRay.y2 = source.y + source.vy;
            
            if      (source.vx > 0 && intersectRays(tempRay, left))   pushData(resultData, 1);
            else if (source.vx < 0 && intersectRays(tempRay, right))  pushData(resultData, 2);
            
            if      (source.vy > 0 && intersectRays(tempRay, top))    pushData(resultData, 3);
            else if (source.vy < 0 && intersectRays(tempRay, bottom)) pushData(resultData, 4);
        }
        
        private function pushData(data:Array, side:int) : void {
            tempData.distance = Math.sqrt(Math.pow(tempData.x - tempRay.x1, 2) + Math.pow(tempData.y - tempRay.y1, 2));
            tempData.side = side;
            data.push(tempData);
        }
        
        private function intersectRays(r1:Ray, r2:Ray) : Boolean {
            temp1 = r1.x2 - r1.x1; temp2 = r1.y2 - r1.y1;
            temp3 = r2.x2 - r2.x1; temp4 = r2.y2 - r2.y1;
            d =  temp1 * temp4 - temp2 * temp3;
            t = -(r1.x1 * temp4 - r1.y1 * temp3 - r2.x1 * temp4 + r2.y1 * temp3) / d;
            s = -(r1.x1 * temp2 - r1.y1 * temp1 + temp1 * r2.y1 - temp2 * r2.x1) / d;
            if ((t > 0 && s > 0) && (t < 1 && s < 1)) {
                tempData = new CollisionData(this, r1.x1 + temp1 * t, r1.y1 + temp2 * t);
                return true;
            }
			return false;
		}

		public function getBrick() : Brick {
			return brick;
		}

		public function setBrick(brick : Brick) : void {
			this.brick = brick;
		}
        
        
        
    }
    
    
} 
 