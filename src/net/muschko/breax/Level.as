package net.muschko.breax {
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	
	/**
	 * Ein Level für Breax
	 * 
	 * @author muschko
	 */
	public class Level extends MovieClip {
		
		private var bricks:Array = new Array();
		private var pointBricks:Array = new Array();
		private var loader:URLLoader = new URLLoader();
		private var levelXML:XML;
		private var bricksList:XMLList;
		private var rowHeight:int = 1;
		private var rowCounter:int = 0;
		private var rowBreak:Boolean;
		private var levelName:String = new String();
		private var currentBrickPosition:int = 1;
		private var brickPaddingX:int = 1;
		private var brickPaddingY:int = 1;
		
		public function Level() {
		}

		public function createLevel(level:int):void {
			// Laden der XML
			loader.addEventListener(Event.COMPLETE, loadLevelComplete);
			loader.load(new URLRequest("levels/level"+level+".xml"));
		}
		
		private function loadLevelComplete(e:Event):void {
			levelXML = new XML(e.target.data);
			levelName = levelXML.attribute("name");
			generateBricks();
		}
		
		private function generateBricks():void{
			
			bricksList = new XMLList();
			bricksList = levelXML.children();

			for (var i:int = 0; i <= levelXML.children().length()-1; i++) { 
      			
      			var brickType:String;
                brickType = levelXML.children()[i].name();
                                               
                switch(brickType) {
                	
                	case "brick0":
                		// Space
                		setBrickPosition(i, true);      		
                		break;
                		
                	case "brick1":
                		// Blau
                		var brick1:AABB = setBrickPosition(i,false); 
                		brick1.getBrick().gotoAndStop(1);
                		brick1.getBrick().setScore(25);
                		// Listen hinzufügen
                		bricks.push(brick1);
                		pointBricks.push(brick1);                		
                		break;
                		
                	case "brick2":
                		// Grün
                		var brick2:AABB = setBrickPosition(i,false); 
                		brick2.getBrick().gotoAndStop(2);
                		brick2.getBrick().setScore(25);
                		// Listen hinzufügen
                		bricks.push(brick2);
                		pointBricks.push(brick2);  
                		break;
                	case "brick3":
                		// Rot
                		var brick3:AABB = setBrickPosition(i,false); 
                		brick3.getBrick().gotoAndStop(3);
                		brick3.getBrick().setScore(25);
                		// Listen hinzufügen
                		bricks.push(brick3);
                		pointBricks.push(brick3);  
                		break;
                	case "brick4":
                		// Orange
                		var brick4:AABB = setBrickPosition(i,false); 
                		brick4.getBrick().gotoAndStop(4);
                		brick4.getBrick().setScore(25);
                		// Listen hinzufügen
                		bricks.push(brick4);
                		pointBricks.push(brick4);  
                		break;
                	case "brick5":
                		// Lila
                		var brick5:AABB = setBrickPosition(i,false); 
                		brick5.getBrick().gotoAndStop(5);
                		brick5.getBrick().setScore(25);
                		// Listen hinzufügen
                		bricks.push(brick5);
                		pointBricks.push(brick5);  
                		break;
                	case "brick6":
                		// Unzerstörbar
                		var brick6:AABB = setBrickPosition(i,false); 
                		brick6.getBrick().gotoAndStop(6);
                		brick6.getBrick().setScore(0);
                		brick6.getBrick().setDestructable(false);
                		// Listen hinzufügen
                		bricks.push(brick6);
                		break;
                	case "brick7":
                		// Dreck
                		var brick7:AABB = setBrickPosition(i,false); 
                		brick7.getBrick().gotoAndStop(7);
                		brick7.getBrick().setScore(0);
                		brick7.getBrick().setBreakable(true);
                		brick7.getBrick().setDestructable(false);
                		brick7.getBrick().setScore(30);
                		// Listen hinzufügen
                		bricks.push(brick7);
                		pointBricks.push(brick7);  
                		break;
           
                }                    		    					
				rowCounter = rowCounter + 1;
            } 			
			trace("Anzahl: "+pointBricks.length);
			
		}
		
		private function setBrickPosition(counter:int,blankBrick:Boolean):AABB {
		
			if (!blankBrick) {	
				var brick:Brick = new Brick();
				
				if (rowCounter == 20) {
					rowBreak = true;
				} 
			
	    		// Position X für den Stein
	    		if (counter != 0 && !rowBreak) {
	    			currentBrickPosition = currentBrickPosition + brick.getWIDTH()+brickPaddingX;
	    			brick.setPositionX(currentBrickPosition);
	    		} else if (rowBreak) {
	    			currentBrickPosition = 1;
	    			brick.setPositionX(currentBrickPosition);
	    		} else {
	    			currentBrickPosition = 1;
	    			brick.setPositionX(currentBrickPosition);
	    		}
	    		
	    		// Position Y für den Stein
	    		if (rowBreak) {
	    			rowHeight = rowHeight + brick.getHEIGHT()+brickPaddingY;
	    			brick.setPositionY(rowHeight);
	    			rowCounter = 0;
	    			rowBreak = false;
	    		} else {
	    			brick.setPositionY(rowHeight);
	    		}    		
	    		
	    		brick.x = brick.getPositionX();
	    		brick.y = brick.getPositionY();	    		
	    		addChild(brick);
	    		
	    		// Schatten
	    		TweenMax.to(brick, 1, {dropShadowFilter:{blurX:5, blurY:5, distance:0, alpha:0.5}}); 
	    		
	    		var brickAABB:AABB = new AABB(brick.x + 15 , brick.y + 10 , 35 , 20 );
	    		
	    		brickAABB.setBrick(brick);	
	    			    		
	    		return brickAABB;
	    		
			} else {
				
				var brick1:Brick = new Brick();
								
				if (rowCounter == 20) {
					rowBreak = true;
				}			
				
				if (counter != 0 && !rowBreak ) {
					currentBrickPosition = currentBrickPosition + brick1.getWIDTH()+brickPaddingX;
				} else {
					currentBrickPosition = 1;
				}

				// Position Y für den Stein
	    		if (rowBreak) {
	    			rowHeight = rowHeight + brick1.getHEIGHT()+brickPaddingY;
	    			rowCounter = 0;
	    			rowBreak = false;	    		
	    		} 
				
				return null;
			}
		}
		
		public function getBricks() : Array {
			return bricks;
		}

		public function setBricks(bricks : Array) : void {
			this.bricks = bricks;
		}

		public function getLevelName() : String {
			return levelName;
		}

		public function setLevelName(levelName : String) : void {
			this.levelName = levelName;
		}

		public function getPointBricks() : Array {
			return pointBricks;
		}

		public function setPointBricks(pointBricks : Array) : void {
			this.pointBricks = pointBricks;
		}
		
	}
}
