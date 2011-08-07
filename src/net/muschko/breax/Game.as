package net.muschko.breax {
	import net.muschko.breax.specials.SpecialExtraLife;
	import net.muschko.breax.specials.SpecialDeath;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import net.muschko.breax.specials.SpecialShort;
	import net.muschko.breax.specials.SpecialLong;
	import net.muschko.breax.specials.SpecialPoints;
	import net.muschko.breax.specials.Special;

	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.ui.Mouse;

	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import net.muschko.breax.aabb.AABB;
	import net.muschko.breax.Ball;
	import net.muschko.breax.Level;

	/**
	 * GameEngine für Brix
	 * 
	 * @author muschko
	 */
	public class Game extends MovieClip {
		public var score : int;
		private var scoreTextField : TextField;
		private var levelNameTextField : TextField;
		private var lifes : Array = new Array(new LifeAsset(), new LifeAsset(), new LifeAsset());
		private var specials : Array = new Array();
		private var paddle : Paddle;
		private var ball : Ball;
		private var firstKick : Boolean = true;
		private var currentLevel : int = 1;
		private var maxLevel : int = 20;
		private var level : Level;
		private var background : BackgroundAsset;
		private var kollisionsDaten : Array = new Array;
		private var scoreMC : MovieClip = new MovieClip();
		private var paddleSound : Sound = new Sound();
		private var boundingSound : Sound = new Sound();
		private var brickSound : Sound = new Sound();
		private var dirtSound : Sound = new Sound();
		private var lostLifeSound : Sound = new Sound();
		private var metalSound : Sound = new Sound();
		private var specialPointSound : Sound = new Sound();
		private var specialShortSound : Sound = new Sound();
		private var specialLongSound : Sound = new Sound();
		private var sndChannel : SoundChannel = new SoundChannel();
		private var sndTransform : SoundTransform = new SoundTransform();
		private var longTimer : Timer = new Timer(5000,1);
		private var shortTimer : Timer = new Timer(5000,1);
		private var stageHeight : Number = 500;
		private var stageWidth : Number = 621;

		public function Game() {
		}

		public function init() : void {
			Mouse.hide();

			// Loading Sounds
			paddleSound.load(new URLRequest("sound/paddle2.mp3"));
			boundingSound.load(new URLRequest("sound/brick3.mp3"));
			brickSound.load(new URLRequest("sound/brick4.mp3"));
			dirtSound.load(new URLRequest("sound/dirt2.mp3"));
			lostLifeSound.load(new URLRequest("sound/life3.mp3"));
			metalSound.load(new URLRequest("sound/metal.mp3"));
			specialPointSound.load(new URLRequest("sound/specialPoint.mp3"));
			specialLongSound.load(new URLRequest("sound/specialLong.mp3"));
			specialShortSound.load(new URLRequest("sound/specialShort.mp3"));
			
			// Setting Volume
			sndTransform.volume = 0.05;

			// Background
			background = new BackgroundAsset();
			addChild(background);

			// Paddle erstellen
			paddle = new Paddle();
			addChild(paddle);

			paddle.alpha = 0;
			paddle.x = stageWidth / 2 - paddle.width / 2;
			paddle.y = stageHeight - paddle.height - 5;
			TweenMax.to(paddle, 0.5, {alpha:1});

			// Ball erstellen
			ball = new Ball(0);
			addChild(ball);

			ball.setXspeed(0);
			ball.setYspeed(0);

			// Leben erstellen
			for (var i : int = 0; i <= lifes.length - 1; i++) {
				var life : LifeAsset = lifes[i];
				addChild(life);

				life.alpha = 0;
				TweenMax.to(life, 0.5, {alpha:1});

				if (i == 0) {
					life.x = 15;
					life.y = stageHeight - 40;
				} else {
					life.x = lifes[i - 1].x + life.width + 3;
					life.y = stageHeight - 40;
				}
			}

			// Score & Levelname erstellen
			scoreTextField = new TextField();
			scoreMC.addChild(scoreTextField);
			addChild(scoreMC);

			levelNameTextField = new TextField();
			levelNameTextField.embedFonts = true;

			var format1 : TextFormat = new TextFormat();
			format1.color = 0x333333;
			format1.size = 20;
			format1.font = "Helvetica";

			(scoreMC.getChildAt(0) as TextField).defaultTextFormat = format1;
			scoreMC.x = 12;
			scoreMC.y = stageHeight - 65;
			(scoreMC.getChildAt(0) as TextField).text = score.toString();

			// Levebeschreibung setzen
			var format2 : TextFormat = new TextFormat();
			format2.color = 0x666666;
			format2.size = 8;
			format2.font = "Semplice Regular";

			levelNameTextField.defaultTextFormat = format2;
			levelNameTextField.x = 12;
			levelNameTextField.y = stageHeight - 90;
			levelNameTextField.autoSize = TextFieldAutoSize.LEFT;

			addChild(levelNameTextField);

			// Level erstellten
			level = new Level();
			level.alpha = 0;
			level.createLevel(currentLevel);

			level.addEventListener(Event.ADDED, setLevelName);
			addChild(level);

			TweenMax.to(level, 0.5, {alpha:1});

			// First kick
			stage.addEventListener(MouseEvent.MOUSE_DOWN, kickBall);

			// Listener für Lebensverlust
			this.addEventListener("lostLife", lifeLost);

			addEventListener(Event.ENTER_FRAME, frameScript);
			
			longTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetLongPaddle);
			shortTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetShortPaddle);
		}

		private function setLevelName(e : Event) : void {
			levelNameTextField.text = "LEVEL: " + level.getLevelName().toString();
		}

		private function kickBall(e : Event) : void {
			firstKick = false;
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, kickBall);

			ball.setXspeed(0);
			ball.setYspeed(-5);
		}

		private function frameScript(e : Event) : void {
			// Ballbewegung
			ball.x = ball.x + ball.getXspeed();
			ball.y = ball.y + ball.getYspeed();

			if (firstKick) {
				ball.y = Math.round(paddle.y - 20);
				ball.x = Math.round(paddle.x - ball.width/2);
			}

			// Paddlebewgung
			paddle.movePaddle();

			// Spielfeldbegrenzung
			if (ball.x >= stageWidth - ball.width ) {
				sndChannel = boundingSound.play(0, 1, sndTransform);

				ball.x = stageWidth - ball.width;
				ball.setXspeed(-(ball.getXspeed()));
			} else if (ball.x <= 0) {
				sndChannel = boundingSound.play(0, 1, sndTransform);

				ball.x = 0;
				ball.setXspeed(-(ball.getXspeed()));
			} else if (ball.y <= 0) {
				sndChannel = boundingSound.play(0, 1, sndTransform);

				ball.y = ball.height;
				ball.setYspeed(-(ball.getYspeed()));
			} else if (ball.y >= stageHeight + ball.height) {
				// Leben verlieren
				removeEventListener(Event.ENTER_FRAME, frameScript);
				dispatchEvent(new Event("lostLife"));
			}

			if (paddle.hitTestObject(ball)) {
				sndChannel = paddleSound.play(0, 1, sndTransform);

				if (ball.getYspeed() > 0) {
					if (ball.getYspeed() > 5) {
						ball.setYspeed(ball.getYspeed() * -1);
					} else {
						ball.setYspeed(ball.getYspeed() * -1.05);
					}
					ball.setXspeed(ball.getXspeed() + (ball.x - paddle.x) * 0.07 );
				}

				ball.x = ball.x + ball.getXspeed();
				ball.y = ball.y + ball.getYspeed();
			}

			for each (var brick:AABB in level.getBricks()) {
				brick.detectCollision(ball, kollisionsDaten);
			}

			if (kollisionsDaten.length) {
				// kollision vorhanden
				var collisionBrick : Brick = (kollisionsDaten[0].target).getBrick();

				kollisionsDaten.sortOn("distance", Array.NUMERIC);
				// objekte anhand der entfernung sortieren

				var index : int = level.getBricks().indexOf(kollisionsDaten[0].target);

				ball.x = ball.x + ball.getXspeed() + 0.1;
				ball.y = ball.y + ball.getYspeed() + 0.1;

				// Special erstellen falls vorhanden
				var special : Special = (collisionBrick.special);

				if ( special != null) {
					if (special is SpecialPoints) {
						var specialContainer : MovieClip = new MovieClip();
						specialContainer.addChild(special as SpecialPoints);
						addChild(specialContainer);

						specialContainer.x = collisionBrick.x;
						specialContainer.y = collisionBrick.y;

						specials.push(specialContainer);
					} else if (special is SpecialLong) {
						var specialContainerLong : MovieClip = new MovieClip();
						specialContainerLong.addChild(special as SpecialLong);
						addChild(specialContainerLong);

						specialContainerLong.x = collisionBrick.x;
						specialContainerLong.y = collisionBrick.y;

						specials.push(specialContainerLong);
					} else if (special is SpecialShort) {
						var specialContainerShort : MovieClip = new MovieClip();
						specialContainerShort.addChild(special as SpecialShort);
						addChild(specialContainerShort);

						specialContainerShort.x = collisionBrick.x;
						specialContainerShort.y = collisionBrick.y;

						specials.push(specialContainerShort);
					} else if (special is SpecialDeath) {
						var specialContainerDeath : MovieClip = new MovieClip();
						specialContainerDeath.addChild(special as SpecialDeath);
						addChild(specialContainerDeath);

						specialContainerDeath.x = collisionBrick.x;
						specialContainerDeath.y = collisionBrick.y;

						specials.push(specialContainerDeath);
					} else if (special is SpecialExtraLife) {
						var specialContainerExtraLife : MovieClip = new MovieClip();
						specialContainerExtraLife.addChild(special as SpecialExtraLife);
						addChild(specialContainerExtraLife);

						specialContainerExtraLife.x = collisionBrick.x;
						specialContainerExtraLife.y = collisionBrick.y;

						specials.push(specialContainerExtraLife);
					}
				}

				if (kollisionsDaten[0].side == 2) {
					removeBrick(index);
					ball.setXspeed(-(ball.getXspeed()));
				} else if (kollisionsDaten[0].side == 3) {
					removeBrick(index);
					ball.setXspeed(-(ball.getXspeed()));
				} else if (kollisionsDaten[0].side == 1) {
					removeBrick(index);
					ball.setYspeed(-(ball.getYspeed()));
				} else if (kollisionsDaten[0].side == 0) {
					removeBrick(index);
					ball.setYspeed(-(ball.getYspeed()));
				}
				kollisionsDaten.length = 0;
			}
			
			// SPECIALS ABFANGEN
			if (specials.length > 0 ) {
				for (var temp:String in specials) {
					specials[temp].y = specials[temp].y + 2;
					
					if (paddle.hitTestObject(specials[temp])) {
					
						if (specials[temp].getChildAt(0) is SpecialPointAsset) {
							sndChannel = specialPointSound.play(0, 1, sndTransform);
							addPoints(specials[temp].getChildAt(0).points);
						} 
						
						if (specials[temp].getChildAt(0) is SpecialLongAsset) {
							sndChannel = specialLongSound.play(0, 1, sndTransform);
							TweenMax.to(paddle, 0.5, {scaleX:1.3});
							longTimer.start();
						}
						
						if (specials[temp].getChildAt(0) is SpecialShortAsset) {
							sndChannel = specialShortSound.play(0, 1, sndTransform);
							TweenMax.to(paddle, 0.5, {scaleX:0.6});
							shortTimer.start();
						}
						
						if (specials[temp].getChildAt(0) is SpecialDeathAsset) {
							lifeLost(null);
						}
						
						if (specials[temp].getChildAt(0) is SpecialExtraLifeAsset) {
							sndChannel = specialPointSound.play(0, 1, sndTransform);
							addExtraLife();					
						}
												
						removeChild(specials[temp]);
						specials.splice(specials.indexOf(specials[temp]),1);
					}
				}
			}
		}

		private function lifeLost(e : Event) : void {
			TweenMax.to(paddle, 0.3, {alpha:0});
			TweenMax.to(ball, 0.3, {alpha:0});
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, kickBall);

			// Checkt ob noch genug Leben verfügbar sind
			if (lifes.length != 0) {
				TweenMax.to(lifes[lifes.length - 1], 0.5, {alpha:0, y:lifes[lifes.length - 1].y + 10, rotation:20, onComplete:prepareNewBall});
				lifes.splice(lifes.length - 1);
				sndChannel = lostLifeSound.play(0, 1, sndTransform);
			} else {
				sndChannel = lostLifeSound.play(0, 1, sndTransform);
				(scoreMC.getChildAt(0) as TextField).text = "";
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, kickBall);
				removeEventListener(Event.ENTER_FRAME, frameScript);
				paddle.destroy();
				removeChild(ball);
				dispatchEvent(new Event("gameover"));
			}
		}

		private function removeBrick(index : int) : void {
			var brick : AABB = level.getBricks()[index];

			// Wenn der Ball einen zerstörbaren Stein trifft
			if (brick.getBrick().getDestructable()) {
				sndChannel = brickSound.play(0, 1, sndTransform);

				// Stein entfernen
				TweenMax.to(brick.getBrick(), 0.5, {alpha:0, y:brick.getBrick().y + 10, rotation:Math.random() * 20, onComplete:removeBrickChild, onCompleteParams:[brick.getBrick()]});
				level.getBricks().splice(level.getBricks().indexOf(brick), 1);
				level.getPointBricks().splice(level.getPointBricks().indexOf(brick), 1);

				// Punkte hinzufügen
				addPoints(brick.getBrick().getScore());

				// Level geschafft
				if (level.getPointBricks().length == 0) {
					removeEventListener(Event.ENTER_FRAME, frameScript);
					levelDone();
					return;
				}
			} 
			// Wenn der Ball einen brechbaren Stein trifft 
			else if ( brick.getBrick().getBreakable() ) {
				sndChannel = dirtSound.play(0, 1, sndTransform);

				if (brick.getBrick().currentFrame == 7) {
					// Anderen Sprite anzeigen "brüchigen Stein"
					brick.getBrick().gotoAndStop(8);
				} else {
					// Stein entfernen
					TweenMax.to(brick.getBrick(), 0.5, {alpha:0, y:brick.getBrick().y + 10, rotation:Math.random() * 20, onComplete:removeBrickChild, onCompleteParams:[brick.getBrick()]});
					level.getBricks().splice(level.getBricks().indexOf(brick), 1);
					level.getPointBricks().splice(level.getPointBricks().indexOf(brick), 1);

					// Punkte hinzufügen
					addPoints(brick.getBrick().getScore());

					// Level geschafft
					if (level.getPointBricks().length == 0) {
						removeEventListener(Event.ENTER_FRAME, frameScript);
						levelDone();
					}
				}
			}
			// Stein ist nicht zerstörbar! 
			else {
				sndChannel = metalSound.play(0, 1, sndTransform);
			}
		}

		private function removeBrickChild(brick : Brick) : void {
			level.removeChild(brick);
		}

		public function prepareNewBall() : void {
			// Neuen Ball vorbereiten
			TweenMax.to(paddle, 0.3, {alpha:1});
			TweenMax.to(ball, 0.3, {alpha:1});

			ball.setXspeed(0);
			ball.setYspeed(0);

			ball.y = Math.round(paddle.y - 20);
			ball.x = Math.round(paddle.x - ball.width/2);

			firstKick = true;

			addEventListener(Event.ENTER_FRAME, frameScript);

			stage.addEventListener(MouseEvent.MOUSE_DOWN, kickBall);
		}

		private function levelDone() : void {
			// Leven beenden & Neuen Screen aufbauen
			dispatchEvent(new Event("levelDone"));
		}

		public function goToNextLevel() : void {
			// Altes Level löschen
			removeChild(level);

			// Nächstes Level
			currentLevel++;

			// Ball vorbereiten
			prepareNewBall();

			level = new Level();

			// Neues Level erstellen
			level.createLevel(currentLevel);

			level.addEventListener(Event.ADDED, setLevelName);

			// Neues Level auf stage platzieren
			addChild(level);

			// Level einfaden
			level.alpha = 0;
			TweenMax.to(level, 0.5, {alpha:1});
		}

		public function getCurrentLevel() : int {
			return currentLevel;
		}

		public function setCurrentLevel(currentLevel : int) : void {
			this.currentLevel = currentLevel;
		}
		
		private function addPoints(points:Number):void {
			score = score + points;
			(scoreMC.getChildAt(0) as TextField).text = score.toString();
			TweenMax.to(scoreMC, 0.2, {scaleX:1.2, scaleY:1.2});
			TweenMax.to(scoreMC, 0.2, {scaleX:1, scaleY:1, delay:0.2});
		}		
		
		private function resetLongPaddle(event : TimerEvent) : void {
			TweenMax.to(paddle, 0.5, {scaleX:1});
			sndChannel = specialShortSound.play(0, 1, sndTransform);
			longTimer.stop();
		}
		
		private function resetShortPaddle(event : TimerEvent) : void {
			TweenMax.to(paddle, 0.5, {scaleX:1});
			sndChannel = specialLongSound.play(0, 1, sndTransform);
			shortTimer.stop();
		}
		
		private function addExtraLife():void {
			
			var life : LifeAsset = new LifeAsset();
			
			// Leben erstellen
			 if (lifes.length == 0) {
				life.x = 15;
				life.y = stageHeight - 40;
			} else {
				life.x = lifes[lifes.length -1].x + life.width + 3;
				life.y = stageHeight - 40;
			}
			lifes.push(life);									
			addChild(life);
			
			life.alpha = 0;
			TweenMax.to(life, 0.5, {alpha:1});
		}
		
	}
}
