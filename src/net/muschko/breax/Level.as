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
		private var rowMax:int = 20;
		private var rowCounter:int = 0;
		private var rowBreak:Boolean;
		
		public function Level() {
		}

		public function createLevel(level:int):void {
			// Laden der XML
			loader.addEventListener(Event.COMPLETE, loadLevelComplete);
			loader.load(new URLRequest("levels/level"+level+".xml"));
		}
		
		private function loadLevelComplete(e:Event):void {
			levelXML = new XML(e.target.data);
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
                		
                		var brick0:Brick = setBrickPosition(i);      		
                		brick0.gotoAndStop(0);
                		break;
                		
                	case "brick1":
                	
                		var brick1:Brick = setBrickPosition(i); 
                		brick1.gotoAndStop(1);
                		break;
                		
                	case "brick2":
                	
                		var brick2:Brick = setBrickPosition(i); 
                		brick2.gotoAndStop(2);
                		break;
           
                }
                    		    					
				rowCounter = rowCounter + 1;
            } 			
			
		}
		
		private function setBrickPosition(counter:int):Brick {
			
			var brick:Brick = new Brick();
    		bricks.push(brick);
			
			if (rowCounter == 20) {
				rowBreak = true;
			} 
			
			trace(counter);
			   		
    		// Position X für den Stein
    		if (counter != 0 && !rowBreak) {
    			brick.setPositionX(brick.getWIDTH() + bricks[counter-1].getPositionX() + 1);
    		} else if (rowBreak) {
    			brick.setPositionX(1);
    		} else {
    			brick.setPositionX(1);
    		}
    		
    		// Position Y für den Stein
    		if (rowBreak) {
    			rowHeight = rowHeight + brick.getHEIGHT()+1;
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
		}
		
		public function getBricks() : Array {
			return bricks;
		}

		public function setBricks(bricks : Array) : void {
			this.bricks = bricks;
		}
		
		
	}
}
