package net.muschko.breax {
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
                		var brick1:Brick = setBrickPosition(i,false); 
                		brick1.gotoAndStop(1);
                		brick1.setScore(25);
                		break;
                		
                	case "brick2":
                		// Grün
                		var brick2:Brick = setBrickPosition(i,false); 
                		brick2.gotoAndStop(2);
                		brick2.setScore(25);
                		break;
                	case "brick3":
                		// Rot
                		var brick3:Brick = setBrickPosition(i,false); 
                		brick3.gotoAndStop(3);
                		brick3.setScore(25);
                		break;
                	case "brick4":
                		// Orange
                		var brick4:Brick = setBrickPosition(i,false); 
                		brick4.gotoAndStop(4);
                		brick4.setScore(25);
                		break;
                	case "brick5":
                		// Lila
                		var brick5:Brick = setBrickPosition(i,false); 
                		brick5.gotoAndStop(5);
                		brick5.setScore(25);
                		break;
                	case "brick6":
                		// Unzerstörbar
                		var brick6:Brick = setBrickPosition(i,false); 
                		brick6.gotoAndStop(6);
                		brick6.setScore(0);
                		brick6.setDestructable(false);
                		break;
                	case "brick7":
                		// Dreck
                		var brick7:Brick = setBrickPosition(i,false); 
                		brick7.gotoAndStop(7);
                		brick7.setScore(0);
                		brick7.setBreakable(true);
                		brick7.setDestructable(false);
                		brick7.setScore(30);
                		break;
           
                }                    		    					
				rowCounter = rowCounter + 1;
            } 			
			
		}
		
		private function setBrickPosition(counter:int,blankBrick:Boolean):Brick {
		
			if (!blankBrick) {	
				var brick:Brick = new Brick();
	    		bricks.push(brick);
				
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
	    		
	    		return brick;  
			} else {
				var brick1:Brick = new Brick();
				if (counter != 0 ) {
					currentBrickPosition = currentBrickPosition + brick1.getWIDTH()+brickPaddingX;
				} else {
					currentBrickPosition = 1;
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
		
		
	}
}
