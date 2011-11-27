package view 
{
	import assets.Assets;
	import datamodels.pipieOV;
	import events.ViewEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import utils.PipieUtils;
	
	/**
	 * ...
	 * @author Tom.Lu
	 */
	public class ViewMain extends Sprite 
	{	
		private const STATE_NONE:uint = 0;
		private const STATE_INIT:uint = 1;
		private const STATE_PLAY:uint = 2;
		private const STATE_PASS:uint = 3;
		private const STATE_DOWN:uint = 4;
		private const STATE_STOP:uint = 5;
		private const STATE_LOSE:uint = 6;
		private const STATE_LVUP:uint = 7;
		
		private const MAX_X:uint = 7;
		private const MIN_Y:uint = 4;
		private const MAX_Y:uint = 8;
		
		private var _StageW:Number = 480;
		private var _StageH:Number = 800;
		
		private var _CurState:uint = STATE_NONE;
		
		private var _PipieList:Vector.<pipieOV>;
		private var _PipiePoolList:Vector.<pipieOV>;
		private var _ContentPipieList:Vector.<pipieOV>;
		private var _ContentTopPipie:pipieOV;
		private var _ContentBottomPipie:pipieOV;
		private var _LastClickPipie:pipieOV;
		
		private var _SkyBg:Bitmap;
		private var _GroundBitmap:Bitmap;
		private var _GroundShape:Shape;
		private var _PipieTopSprite:Sprite;
		private var _PipieTopCanvas:Bitmap;
		private var _PipieBottomCanvas:Bitmap;
		private var _PipieCanvas:Bitmap;
		private var _ScoreLabel:TextField;
		private var _PipieColorTotalSprite:Sprite;
		private var _PipieColorTotalCanvas:Bitmap;
		private var _PipieColorLabelList:Vector.<TextField>;
		private var _PipieTimesLabelList:Vector.<TextField>;
		
		private var _ShowContentFrame:int = 30;
		private var _UpCanvasFrame:int = 6;
		
		private var _ColorNum:uint = 0;
		private var _ColorNumLimit:uint = 5;
		private var _LevelPipieNum:uint = 9;
		private var _LevelPipitLimit:uint = 9;
		private var _LevelPipieIncrease:uint = 1;
		private var _ShowNumPer:int = -5;
		private var _ShowNumPerLimit:uint = 20;
		private var _ShowNumPerIncrease:uint = 5;
		private var _CurY:uint = 3;
		
		private var _UserCleanColorPipie:Vector.<uint>;
		private var _UserScore:uint = 0;
		private var _UserLevel:uint = 0;
		
		private var _PipieTimesList:Vector.<int> = new Vector.<int>(7);
			
		public function ViewMain() 
		{
			trace("game size = ", this.width, this.height);
			
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			crateUI();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			trace("game size = ", stage.stageWidth, stage.stageHeight, stage.width, stage.height, this.width, this.height);
		}
		
		public function dispose():void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			disposeUI();
		}
		
		private function crateUI():void
		{
			_SkyBg = new Assets.SKY_BG() as Bitmap;
			addChild(_SkyBg);
						
			_PipieTopSprite = new Sprite();
			addChild(_PipieTopSprite);
			
			_GroundBitmap = new Assets.GROUND() as Bitmap;
			_GroundShape = new Shape();
			var g:Graphics = _GroundShape.graphics;
			g.beginBitmapFill(_GroundBitmap.bitmapData);
			g.drawRect(0, 0, _StageW, 540);
			g.endFill();
			_GroundShape.y = 117;
			_PipieTopSprite.addChild(_GroundShape);
			
			_PipieTopCanvas = new Bitmap();
			_PipieTopSprite.addChild(_PipieTopCanvas);
			
			var pipieTimesLabelFormat:TextFormat = new TextFormat("_sans", "40", "0x000000");
			pipieTimesLabelFormat.align = TextFormatAlign.CENTER;
			var pipieTimesLabel:TextField;
			_PipieTimesLabelList = new Vector.<TextField>();
			for (var i:uint = 0; i < MAX_X; i++)
			{
				pipieTimesLabel = new TextField();
				pipieTimesLabel.selectable = false;
				pipieTimesLabel.width = 60;
				pipieTimesLabel.defaultTextFormat = pipieTimesLabelFormat;
				pipieTimesLabel.visible = false;
				pipieTimesLabel.text = "0";
				_PipieTopSprite.addChild(pipieTimesLabel);
				_PipieTimesLabelList.push(pipieTimesLabel);
			}
			
			_PipieCanvas = new Bitmap();
			_PipieCanvas.x = 30;
			addChild(_PipieCanvas);
			
			_PipieBottomCanvas = new Bitmap();
			_PipieBottomCanvas.y = 800 - (pipieOV.DIR_BOTTOM_H + 5);
			addChild(_PipieBottomCanvas);
			
			_PipieColorTotalSprite = new Sprite();
			addChild(_PipieColorTotalSprite);
			
			_PipieColorTotalCanvas = new Bitmap();
			_PipieColorTotalSprite.addChild(_PipieColorTotalCanvas);
			var pipieTotalLabelFormat:TextFormat = new TextFormat("_sans", "40", "0x000000");
			pipieTotalLabelFormat.align = TextFormatAlign.CENTER;
			var pipieTotalLabel:TextField;
			_PipieColorLabelList = new Vector.<TextField>();
			for (var j:uint = 0; j < 5; j++)
			{
				pipieTotalLabel = new TextField();
				pipieTotalLabel.selectable = false;
				pipieTotalLabel.width = pipieOV.DIR_TOP_W+2;
				pipieTotalLabel.defaultTextFormat = pipieTotalLabelFormat;
				pipieTotalLabel.visible = false;
				pipieTotalLabel.text = "0";
				_PipieColorTotalSprite.addChild(pipieTotalLabel);
				_PipieColorLabelList.push(pipieTotalLabel);
			}
			
			var scoreFormat:TextFormat = new TextFormat("_sans", "40", "0x009900", "true");
            scoreFormat.align = TextFormatAlign.LEFT;
			_ScoreLabel = new TextField();
			_ScoreLabel.selectable = false;
			_ScoreLabel.defaultTextFormat = scoreFormat;
			_ScoreLabel.x = 5;
			addChild(_ScoreLabel);
						
			setState(STATE_INIT);
		}
		
		private function disposeUI():void
		{
			if (_SkyBg)
			{
				_SkyBg.bitmapData.dispose();
				removeChild(_SkyBg);
				_SkyBg = null;
			}
			
			if (_PipieTopSprite)
			{
				if (_GroundShape)
				{
					_GroundShape.graphics.clear();
					_PipieTopSprite.removeChild(_GroundShape)
					_GroundShape = null;
				}
				
				if (_GroundBitmap)
				{
					_GroundBitmap.bitmapData.dispose();
					_GroundBitmap = null;
				}
				
				if (_PipieTopCanvas)
				{
					_PipieTopCanvas.bitmapData.dispose();
					_PipieTopSprite.removeChild(_PipieTopCanvas);
					_PipieTopCanvas = null;
				}
				
				removeChild(_PipieTopSprite);
				_PipieTopSprite = null;
			}

			if (_PipieBottomCanvas)
			{
				_PipieBottomCanvas.bitmapData.dispose();
				removeChild(_PipieBottomCanvas);
				_PipieBottomCanvas = null;
			}
			
			if (_PipieCanvas)
			{
				_PipieCanvas.bitmapData.dispose();
				removeChild(_PipieCanvas);
				_PipieCanvas = null;
			}
			
			if (_ScoreLabel)
			{
				removeChild(_ScoreLabel);
				_ScoreLabel = null;
			}
		}
		
		private function setState(newState:uint):void
		{
			_CurState = newState;
			switch(_CurState)
			{
				case STATE_NONE:
					break;
					
				case STATE_INIT:
					gameStop();
					initData();
					setState(STATE_PLAY);
					break;
					
				case STATE_PLAY:
					gamePlay();
					break;
				
				case STATE_PASS:
					setPipiePassing();
					gameStop();
					break;
					
				case STATE_DOWN:
					gameStop();
					drawPipieTopCanvas()
					drawPipieButtomCanvas();
					drawPipieCanvas();
					movePipieDown();
					replacePipies();
					break;
					
				case STATE_LVUP:
					gameStop();
					newLevel();
					break;
				
				case STATE_STOP:
					break;
				
				case STATE_LOSE:
					gameStop();
					var evtObj:ViewEvent = ViewEvent.createGameOverEvent(_UserScore);
					this.dispatchEvent(evtObj);
					break;
			}
		}
		
		private function updateState():void
		{
			switch(_CurState)
			{
				case STATE_NONE:
					break;
					
				case STATE_INIT:
					break;
					
				case STATE_PLAY:
					break;
				
				case STATE_PASS:
					_ShowContentFrame--;
					if (_ShowContentFrame == 0)
					{
						_ShowContentFrame = 30;
						if (checkForLevel())
						{
							setState(STATE_LVUP);
						}
						else
						{
							setState(STATE_DOWN);
						}
					}
					break;
				
				case STATE_DOWN:
					updatePipieXY();
					drawPipieCanvas();
					if (!checkForFallingPipies()) 
					{						
						drawPipieTopCanvas()
						drawPipieButtomCanvas();
						genInitPipieContent();
						setState(STATE_PLAY);
					}		
					break;
				
				case STATE_LVUP:
					_PipieCanvas.y -= 10;
					_PipieTopSprite.y = _PipieCanvas.y - 117;
					_UpCanvasFrame--;
					if (_UpCanvasFrame == 0)
					{
						_UpCanvasFrame = 6;
						setState(STATE_PLAY);
					}
					break;
				
				case STATE_STOP:
					break;
				
				case STATE_LOSE:
					break;
			}
		}
		
		private function enterFrameHandler(e:Event):void
		{
			update();
			render();
		}
		
		private function update():void
		{
			updateState();
		}
		
		private function render():void
		{
			
		}
			
		private function initData():void
		{
			//trace("debug initData");
			_UserScore = 0;
			_ColorNum = 0;
			_LevelPipieNum = 18;
			_UserLevel = 0;
			_CurY = 3;
			_ShowNumPer = -5;
			
			_ScoreLabel.text = _UserScore.toString();
			
			for (var i:uint = 0; i < MAX_X; i++)
			{
				_PipieTimesList[i] = -1;
				_PipieTimesLabelList[i].visible = false;
				if (i < _PipieColorLabelList.length)
				{
					_PipieColorLabelList[i].visible = false;
				}
			}
			
			newLevel();
		}
		
		private function initPipieData():void
		{
			//trace("debug initPipieData");
			_PipiePoolList = new Vector.<pipieOV>();
			_PipieList = new Vector.<pipieOV>();
			var tmpPipieOV:pipieOV;
			for (var j:uint = 0; j <= _CurY+1; j++)
			{
				for (var i:uint = 0; i < MAX_X; i++)
				{
					tmpPipieOV = new pipieOV();
					tmpPipieOV.px = i;
					tmpPipieOV.py = j;
					if (j == 0)
					{
						tmpPipieOV.direction = PipieUtils.randomPipieDir(pipieOV.DIR_TOP);
						tmpPipieOV.color = PipieUtils.randomPipieColor(_ColorNum);
						tmpPipieOV.x = 30 + tmpPipieOV.px * pipieOV.DIR_COMMON_W + (pipieOV.DIR_COMMON_W - pipieOV.DIR_TOP_W) / 2;
						tmpPipieOV.y = 65;
					}
					else if (j == _CurY+1)
					{
						tmpPipieOV.direction = PipieUtils.randomPipieDir(pipieOV.DIR_BOTTOM);
						tmpPipieOV.color = PipieUtils.randomPipieColor(_ColorNum);
						tmpPipieOV.x = 30 + tmpPipieOV.px * pipieOV.DIR_COMMON_W + (pipieOV.DIR_COMMON_W - pipieOV.DIR_BOTTOM_W) / 2;
						tmpPipieOV.y = 0;
					}
					else
					{
						tmpPipieOV.direction = PipieUtils.randomPipieDir();
						tmpPipieOV.x = tmpPipieOV.nextX = tmpPipieOV.px * pipieOV.DIR_COMMON_W;
						tmpPipieOV.y = tmpPipieOV.nextY = (tmpPipieOV.py - 1) * pipieOV.DIR_COMMON_H;
					}
					_PipieList.push(tmpPipieOV);
				}
			}
		}
		
		private function drawPipieTopCanvas():void
		{
			//trace("debug drawPipieTopCanvas");
			if (_PipieTopCanvas)
			{
				_PipieTopCanvas.bitmapData = new BitmapData(480, 117, true, 0xffffff);
				
				var point:Point = new Point(0, 0);
				var tmpBD:BitmapData;
				var PIPIE_TIME_BD:BitmapData = Bitmap(new Assets.PIPIE_TIME()).bitmapData;
				var tmpPipieOV:pipieOV;
				
				_PipieTopCanvas.bitmapData.lock();
								
				point.x = -1;
				point.y = 0;
				tmpBD = Bitmap(new Assets.LAND_BACK()).bitmapData;
				_PipieTopCanvas.bitmapData.copyPixels(tmpBD, tmpBD.rect, point,tmpBD,new Point(),true);
				
				for (var i:uint = 0; i < MAX_X; i++)
				{
					tmpPipieOV = _PipieList[i];
					if (tmpPipieOV && tmpPipieOV.direction == pipieOV.DIR_TOP && tmpPipieOV.type == pipieOV.STATE_NONE)
					{
						var randmonNumber:Number = Math.random() * 100;
						if (_PipieTimesList[i] != -1 || randmonNumber < _ShowNumPer)
						{
							if (_PipieTimesList[i] == -1)
							{
								_PipieTimesList[i] = _CurY * 2;
							}
							point.x = tmpPipieOV.x - (PIPIE_TIME_BD.rect.width - pipieOV.DIR_TOP_W) / 2;
							point.y = tmpPipieOV.y - PIPIE_TIME_BD.rect.height + 3;
							_PipieTopCanvas.bitmapData.copyPixels(PIPIE_TIME_BD, PIPIE_TIME_BD.rect, point, PIPIE_TIME_BD, new Point(), true);
							_PipieTimesLabelList[i].visible = true;
							_PipieTimesLabelList[i].x = point.x;
							_PipieTimesLabelList[i].y = point.y - 4;
							_PipieTimesLabelList[i].text = _PipieTimesList[i].toString();
						}
								
						point.x = tmpPipieOV.x;
						point.y = tmpPipieOV.y;
						tmpBD = PipieUtils.genPipieBitmapData(tmpPipieOV);
						_PipieTopCanvas.bitmapData.copyPixels(tmpBD, tmpBD.rect, point, tmpBD, new Point(), true);
					}
				}
				
				point.x = -1;
				point.y = 92;
				tmpBD = Bitmap(new Assets.LAND_FRONT()).bitmapData;
				_PipieTopCanvas.bitmapData.copyPixels(tmpBD, tmpBD.rect, point,tmpBD,new Point(),true);
				
				_PipieTopCanvas.bitmapData.unlock();
			}
		}
		
		private function drawPipieButtomCanvas():void
		{
			//trace("debug drawPipieButtomCanvas");
			if (_PipieBottomCanvas)
			{
				_PipieBottomCanvas.bitmapData = new BitmapData(480, pipieOV.DIR_BOTTOM_H+5, false, 0x4E3728);
				
				var point:Point = new Point();
				var tmpBD:BitmapData;
				var tmpPipieOV:pipieOV;
				
				_PipieBottomCanvas.bitmapData.lock();
				
				for (var i:uint = 0; i < MAX_X; i++)
				{
					tmpPipieOV = _PipieList[(_CurY+1)*MAX_X+i];
					if (tmpPipieOV && tmpPipieOV.direction == pipieOV.DIR_BOTTOM)
					{
						tmpBD = PipieUtils.genPipieBitmapData(tmpPipieOV);
						point.x = tmpPipieOV.x;
						point.y = tmpPipieOV.y;
						_PipieBottomCanvas.bitmapData.copyPixels(tmpBD,tmpBD.rect,point,tmpBD,new Point(),true);
					}
				}
				
				point.x = -1;
				point.y = 0;
				tmpBD = Bitmap(new Assets.BOTTOM_LINE()).bitmapData;
				_PipieBottomCanvas.bitmapData.copyPixels(tmpBD, tmpBD.rect, point,tmpBD,new Point(),true);

				_PipieBottomCanvas.bitmapData.unlock();
			}
		}
	
		private function drawPipieCanvas():void
		{
			//trace("debug drawPipieCanvas");
			if (_PipieCanvas)
			{
				_PipieCanvas.bitmapData = new BitmapData(420, 540, true, 0xffffff);
				var point:Point = new Point();
				var tmpPipieOV:pipieOV;
				var tmpBitmapData:BitmapData;
				_PipieCanvas.bitmapData.lock();
				for (var i:uint = MAX_X; i < _PipieList.length-MAX_X; i++)
				{
					tmpPipieOV = _PipieList[i];
					if (tmpPipieOV && tmpPipieOV.type != pipieOV.STATE_PASSING)
					{
						tmpBitmapData = PipieUtils.genPipieBitmapData(tmpPipieOV);
						point.x = tmpPipieOV.x;
						point.y = tmpPipieOV.y;
						_PipieCanvas.bitmapData.copyPixels(tmpBitmapData, tmpBitmapData.rect, point);
					}
				}
				_PipieCanvas.bitmapData.unlock();
			}
		}
		
		private function gamePlay():void
		{
			this.addEventListener(MouseEvent.CLICK, mouseClickHandler, false, 0, true);
		}
		
		private function gameStop():void
		{
			this.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
		}
		
		private function mouseClickHandler(e:MouseEvent):void
		{
			//trace("debug mouseClickHandler");
			var tmpPipieOV:pipieOV = findPipieOV(this.mouseX, this.mouseY);
			if (tmpPipieOV)
			{
				changePipieDir(tmpPipieOV);
				checkPass(tmpPipieOV);
							
				if (_LastClickPipie != tmpPipieOV)
				{
					var pipieTotalLabel:TextField;
					for (var i:uint = 0; i < MAX_X; i++)
					{
						if (_PipieTimesList[i] != -1)
						{
							_PipieTimesList[i]--;
							pipieTotalLabel = _PipieTimesLabelList[i];
							pipieTotalLabel.text = _PipieTimesList[i].toString();
							if (_PipieTimesList[i] == 0)
							{
								setState(STATE_LOSE);
							}
						}
					}
					
					_LastClickPipie = tmpPipieOV;
				}
			}
		}
		
		private function findPipieOV(mouseX:Number,mouseY:Number):pipieOV
		{
			//trace("debug findPipieOV");
			if (mouseX<30|| mouseX>450 || mouseY<(_PipieBottomCanvas.y - _CurY*pipieOV.DIR_COMMON_H) || mouseY > _PipieBottomCanvas.y)
			{
				return null;
			}
			else
			{
				var pipieX:uint = int((mouseX - 30) / pipieOV.DIR_COMMON_W);
				var pipieY:uint = int((mouseY - _PipieCanvas.y) / pipieOV.DIR_COMMON_H) + 1;
				var index:uint = pipieY * MAX_X + pipieX;
				//trace(mouseX,mouseY,pipieX,pipieY,index)
				return _PipieList[index];
			}
		}
		/*
		 * 1.根据点击水管，设置改变方向后的图像
		 * 2.重新设置点击水管的连接水管
		 * 3.寻找点击水管相邻水管，重新设置这些相邻水管的连接水管
		 */ 
		private function changePipieDir(pipie:pipieOV):void
		{
			//trace("debug changePipieDir");
			pipie.direction = PipieUtils.changeDirByClick(pipie.direction);
			
			_PipieCanvas.bitmapData.lock();
			var midRect:Rectangle = new Rectangle(0, 0, pipieOV.DIR_COMMON_W, pipieOV.DIR_COMMON_H);
			var point:Point = new Point(pipie.x,pipie.y);
			var tmpBitmapData:BitmapData = PipieUtils.genPipieBitmapData(pipie);
			_PipieCanvas.bitmapData.copyPixels(tmpBitmapData, midRect, point);
			_PipieCanvas.bitmapData.unlock();
			
			setPipieContent(pipie);
			setPipieContent(findContentPipie(1, pipie, false))
			setPipieContent(findContentPipie(2, pipie, false));
			setPipieContent(findContentPipie(3, pipie, false));
			setPipieContent(findContentPipie(4, pipie, false));
		}
		
		private function checkPass(pipie:pipieOV):void
		{
			//trace("debug checkPass");
			if (pipie.contentPipie1 && pipie.contentPipie2)
			{
				_ContentPipieList = new Vector.<pipieOV>();
				_ContentPipieList.push(pipie);
				
				_ContentTopPipie = null;
				_ContentBottomPipie = null;
				
				var tmpEnterPipie:pipieOV;
				var tmpPipie1:pipieOV = pipie.contentPipie1;
				var tmpPipie2:pipieOV = pipie.contentPipie2;
				
				tmpPipie1.enterPipie = pipie;
				tmpPipie2.enterPipie = pipie;
				//tmpPipie1.traceString("tmpPipie1");
				var loop:int = (_CurY+1) * MAX_X;
				while (tmpPipie1.contentPipie1 && tmpPipie1.contentPipie2 && loop>0)
				{
					_ContentPipieList.push(tmpPipie1);
					tmpEnterPipie = tmpPipie1;
					if (tmpPipie1.contentPipie1 == tmpPipie1.enterPipie)
					{
						tmpPipie1 = tmpPipie1.contentPipie2;
					}
					else 
					{
						tmpPipie1 = tmpPipie1.contentPipie1;
					}
					tmpPipie1.enterPipie = tmpEnterPipie;
					//tmpPipie1.traceString("tmpPipie1");
					loop--;
				}
				loop = (_CurY+1) * MAX_X;
				//tmpPipie2.traceString("tmpPipie2");
				while (tmpPipie2.contentPipie1 && tmpPipie2.contentPipie2 && loop>0)
				{
					_ContentPipieList.push(tmpPipie2);
					tmpEnterPipie = tmpPipie2;
					if (tmpPipie2.contentPipie1 == tmpPipie2.enterPipie)
					{
						tmpPipie2 = tmpPipie2.contentPipie2;
					}
					else 
					{
						tmpPipie2 = tmpPipie2.contentPipie1;
					}
					tmpPipie2.enterPipie = tmpEnterPipie;
					//tmpPipie2.traceString("tmpPipie2");
					loop--;
				}
				//trace("_ContentPipieList.length = " + _ContentPipieList.length);
				if (_ContentPipieList.length >= _CurY && tmpPipie1.direction != tmpPipie2.direction &&
					(tmpPipie1.direction == pipieOV.DIR_TOP  || tmpPipie1.direction == pipieOV.DIR_BOTTOM) && 
					(tmpPipie2.direction == pipieOV.DIR_TOP || tmpPipie2.direction == pipieOV.DIR_BOTTOM))
				{
					if (tmpPipie1.direction == pipieOV.DIR_TOP)
					{
						_ContentTopPipie = tmpPipie1;
						_ContentBottomPipie = tmpPipie2;
					}
					else
					{
						_ContentTopPipie = tmpPipie2;
						_ContentBottomPipie = tmpPipie1;
					}
					
					debugCheckPipe(_ContentPipieList);
					setScore(_ContentPipieList);
					
					setState(STATE_PASS);
				}
			}
		}
		/*
		 * 根据当前的水管寻找上下左右相邻的水管
		 * room: 当前水管的接口
		 * pipie: 当前水管
		 * isContent: 相邻的水管是否需要连接，默认为true
		 */ 
		private function findContentPipie(room:uint, pipie:pipieOV, isContent:Boolean = true):pipieOV
		{
			//trace("debug findContentPipie");
			var pX:uint;
			var pY:uint;
			var nextPipie:pipieOV;
			switch(room)
			{
				case 1:
					pX = pipie.px - 1;
					pY = pipie.py;
					break;
				
				case 2:
					pX = pipie.px;
					pY = pipie.py - 1;
					break;
								
				case 3:
					pX = pipie.px + 1;
					pY = pipie.py;
					break;
									
				case 4:
					pX = pipie.px;
					pY = pipie.py + 1;
					break;
					
				case 0:
					return null;
					break;
			}
			if (pY >= 0 && pY <= _CurY+1 && pX >= 0 && pX<MAX_X)
			{
				nextPipie = _PipieList[pY * MAX_X + pX];
				if (isContent)
				{
					var entrance:uint = PipieUtils.findEntranceByRoom(room)
					var room1:uint = int(nextPipie.direction / 10);
					var room2:uint = int(nextPipie.direction % 10);
					if (entrance == room1 || entrance == room2)
					{
						return nextPipie;
					}
					else 
					{
						return null;
					}
				}
				else
				{
					return nextPipie;
				}
			}
			else
			{
				return null;
			}
		}
		/*
		 * 初期化每个水管的连接哪个水管
		 */ 
		private function genInitPipieContent():void
		{
			//trace("debug genInitPipieContent");
			var tmpPipieOV:pipieOV;
			for (var i:uint = MAX_X; i < _PipieList.length-MAX_X; i++)
			{
				tmpPipieOV = _PipieList[i];
				if (tmpPipieOV && tmpPipieOV.direction != pipieOV.DIR_TOP && tmpPipieOV.direction != pipieOV.DIR_BOTTOM)
				{
					setPipieContent(tmpPipieOV);
				}
			}
		}
		/*
		 * 根据当前的水管的设置连接的水管
		 */ 
		private function setPipieContent(pipie:pipieOV):void
		{
			//trace("debug setPipieContent");
			if (pipie)
			{
				pipie.cleanPipie();
				var room1:uint = int(pipie.direction / 10);
				var room2:uint = int(pipie.direction % 10);
				pipie.contentPipie1 = findContentPipie(room1, pipie);
				pipie.contentPipie2 = findContentPipie(room2, pipie);
				/*
				pipie.traceString("pipie");
				if (pipie.contentPipie1)
				{
					pipie.contentPipie1.traceString("contentPipie1");
				}
				if (pipie.contentPipie2)
				{
					pipie.contentPipie2.traceString("contentPipie2");
				}
				*/
			}
		}
				
		private function setPipiePassing():void
		{
			//trace("debug setPipiePassing");
			if (_ContentPipieList.length > 0)
			{
				var tmpPipie:pipieOV;
				for (var i:uint = 0; i < _ContentPipieList.length; i++)
				{
					tmpPipie = _ContentPipieList[i];
					if (tmpPipie)
					{
						tmpPipie.type = pipieOV.STATE_PASSING;
						_PipieList[tmpPipie.py * MAX_X + tmpPipie.px] = null;
						_PipiePoolList.push(tmpPipie);
					}
				}
				
				_ContentTopPipie.type = pipieOV.STATE_PASSING;
				_PipieList[_ContentTopPipie.py * MAX_X + _ContentTopPipie.px] = null;
				
				_ContentBottomPipie.type = pipieOV.STATE_PASSING;
				_PipieList[_ContentBottomPipie.py * MAX_X + _ContentBottomPipie.px] = null;
				
				_ContentPipieList = null;
				
				if (_ContentTopPipie.color == _ContentBottomPipie.color)
				{
					_UserCleanColorPipie[_ContentTopPipie.color] += 3;
				}
				else
				{
					_UserCleanColorPipie[_ContentTopPipie.color]++;
					_UserCleanColorPipie[_ContentBottomPipie.color]++;
				}
				
				var pipieTotalLabel:TextField;
				var pipieTotal:int;
				for (var j:uint = 0; j < _UserCleanColorPipie.length; j++)
				{
					pipieTotal = _LevelPipieNum - _UserCleanColorPipie[j];
					if (pipieTotal < 0)
					{
						pipieTotal = 0;
					}
					pipieTotalLabel = _PipieColorLabelList[j];
					pipieTotalLabel.text = pipieTotal.toString();
				}
				
				_PipieTimesList[_ContentTopPipie.px] = -1;
				_PipieTimesLabelList[_ContentTopPipie.px].visible = false;
			}
		}
		
		private function movePipieDown() :void 
		{
			//trace("debug movePipieDown");
			var len:uint = _PipieList.length - MAX_X;
			var tmpPipieOV:pipieOV;
			var missing:uint;
			var pipieIndex:uint;
			for (var i:uint = len-1; i >= MAX_X; i--)
			{
				missing = 0;
				tmpPipieOV = _PipieList[i];
				if (tmpPipieOV && tmpPipieOV.type != pipieOV.STATE_PASSING)
				{
					missing = 0;
					
					for (var j:int = 1; j < _CurY; j++) 
					{	
						pipieIndex = i + j * MAX_X;
						if (pipieIndex < len && !_PipieList[pipieIndex]) 
						{									
							missing++;
						}
					}
					
					if (missing > 0) 
					{						
						tmpPipieOV.py = tmpPipieOV.py + missing;
						tmpPipieOV.nextY = (tmpPipieOV.py - 1) * pipieOV.DIR_COMMON_H;
						tmpPipieOV.type = pipieOV.STATE_MOVE;
						_PipieList[tmpPipieOV.py*MAX_X + tmpPipieOV.px] = tmpPipieOV;							
						_PipieList[i] = null;			
						//trace(i,"=>",tmpPipieOV.py*MAX_X + tmpPipieOV.px);
					}
				}
			}
		}
		
		private function replacePipies():void
		{			
			//trace("debug replacePipies");
			var tmpPipieOV:pipieOV;
			var missing:uint;
			var pipieIndex:uint;
			for (var i:uint = 0; i < MAX_X && _PipiePoolList.length > 0; i++)
			{
				missing = 0;
				for (var j:int = 1; j <= _CurY; j++) 
				{	
					pipieIndex = i + j * MAX_X;
					if (!_PipieList[pipieIndex]) 
					{								
						missing++;
					}
				}
				for (var k:int = 0; k < missing; k++) 
				{	
					tmpPipieOV = _PipiePoolList.pop();
					tmpPipieOV.px = i;
					tmpPipieOV.py = missing - k;
					
					tmpPipieOV.direction = PipieUtils.randomPipieDir();
					tmpPipieOV.x = tmpPipieOV.nextX = tmpPipieOV.px * pipieOV.DIR_COMMON_W;
					
					tmpPipieOV.nextY = (tmpPipieOV.py - 1) * pipieOV.DIR_COMMON_H;
					tmpPipieOV.y = tmpPipieOV.nextY - missing * pipieOV.DIR_COMMON_H;
								
					tmpPipieOV.type = pipieOV.STATE_MOVE;
					
					_PipieList[tmpPipieOV.py * MAX_X + tmpPipieOV.px] = tmpPipieOV;
				}
			}

			_ContentTopPipie.direction = PipieUtils.randomPipieDir(pipieOV.DIR_TOP);
			_ContentTopPipie.color = PipieUtils.randomPipieColor(_ColorNum);
			_ContentTopPipie.type = pipieOV.STATE_NONE;
			_ContentTopPipie.cleanPipie();
			_PipieList[_ContentTopPipie.py * MAX_X + _ContentTopPipie.px] = _ContentTopPipie;
			
			_ContentBottomPipie.direction = PipieUtils.randomPipieDir(pipieOV.DIR_BOTTOM);
			_ContentBottomPipie.color = PipieUtils.randomPipieColor(_ColorNum);
			_ContentBottomPipie.type = pipieOV.STATE_NONE;
			_ContentBottomPipie.cleanPipie();
			_PipieList[_ContentBottomPipie.py * MAX_X + _ContentBottomPipie.px] = _ContentBottomPipie;
		}
		
		private function updatePipieXY():void
		{
			//trace("debug updatePipieXY");
			var tmpPipieOV:pipieOV;
			for (var i:uint = 0; i < _PipieList.length; i++)
			{
				tmpPipieOV = _PipieList[i];
				if (tmpPipieOV && tmpPipieOV.type == pipieOV.STATE_MOVE)
				{
					tmpPipieOV.y += 10;
					if (tmpPipieOV.y >= tmpPipieOV.nextY)
					{
						tmpPipieOV.y = tmpPipieOV.nextY;
						tmpPipieOV.type = pipieOV.STATE_NONE;
					}
				}
			}
		}
		
		private function checkForFallingPipies():Boolean 
		{
			//trace("debug checkForFallingPipies");
			var tmpPipieOV:pipieOV;
			var isFalling:Boolean = false;
			for (var i:int  = 0; i < _PipieList.length; i++) 
			{
				tmpPipieOV = _PipieList[i];						
				if (tmpPipieOV.type == pipieOV.STATE_MOVE) 
				{
					isFalling = true;
					break;
				}								
			}						
			return isFalling;
		}	
		
		private function checkForLevel():Boolean 
		{
			//trace("debug checkForLevel");
			var isLevelUp:Boolean = true;
			var colorTotal:uint;
			for (var i:int  = 0; i < _UserCleanColorPipie.length; i++) 
			{	
				colorTotal = _UserCleanColorPipie[i]
				if (colorTotal < _LevelPipieNum) 
				{
					isLevelUp = false;
					break;
				}								
			}						
			return isLevelUp;
		}
		
		private function newLevel():void
		{
			_UserLevel++;
			_ColorNum++;
			if (_ColorNum > _ColorNumLimit)
			{
				_ColorNum = _ColorNumLimit;
			}
			_UserCleanColorPipie = new Vector.<uint>();
			for (var i:uint = 0; i < _ColorNum; i++)
			{
				_UserCleanColorPipie.push(0);
			}
						
			_LevelPipieNum += _LevelPipieIncrease;
			if (_LevelPipieNum > _LevelPipitLimit)
			{
				_LevelPipieNum = _LevelPipitLimit;
			}
			
			_CurY++
			if(_CurY > MAX_Y)
			{
				_CurY = MAX_Y;
			}
			
			_ShowNumPer += _ShowNumPerIncrease;
			if (_ShowNumPer > _ShowNumPerLimit)
			{
				_ShowNumPer = _ShowNumPerLimit;
			}
			
			_PipieColorTotalCanvas.bitmapData = new BitmapData((pipieOV.DIR_TOP_W+2)*_ColorNum, pipieOV.DIR_TOP_H, true, 0xffffff);
			var rect:Rectangle = new Rectangle(0, 0, pipieOV.DIR_TOP_W+2, pipieOV.DIR_TOP_H);
			var point:Point = new Point();
			var tmpBitmapData:BitmapData;
			var pipieTotalLabel:TextField;
			_PipieColorTotalCanvas.bitmapData.lock();
			for (var j:uint = 0; j < _ColorNum; j++)
			{
				tmpBitmapData = PipieUtils.genPipieTopBitmapData(PipieUtils.COLOR_LIST[j]);
				
				point.x = j * (pipieOV.DIR_TOP_W + 2) + 1;
				point.y = 0;
				_PipieColorTotalCanvas.bitmapData.copyPixels(tmpBitmapData, rect, point);
				
				pipieTotalLabel = _PipieColorLabelList[j];
				pipieTotalLabel.visible = true;
				pipieTotalLabel.x = 480 - (_ColorNum - j) * (pipieOV.DIR_TOP_W + 2);
				pipieTotalLabel.text = _LevelPipieNum.toString();
			}
			_PipieColorTotalCanvas.bitmapData.unlock();
			_PipieColorTotalCanvas.x = 480 - _ColorNum * (pipieOV.DIR_TOP_W+2); 
			
			initPipieData();
			
			drawPipieTopCanvas()
			drawPipieButtomCanvas();
			drawPipieCanvas();
			
			genInitPipieContent();
			
			if (_UserLevel == 1)
			{
				_PipieCanvas.y = _PipieBottomCanvas.y - _CurY * pipieOV.DIR_COMMON_H;
			}
			else
			{
				_PipieCanvas.y = _PipieBottomCanvas.y - (_CurY-1) * pipieOV.DIR_COMMON_H;
			}
			_PipieTopSprite.y = _PipieCanvas.y - 117;
		}
		
		private function setScore(pipieList:Vector.<pipieOV>):void
		{
			//trace("debug setScore");
			for (var i:uint = 0; i < pipieList.length; i++)
			{
				_UserScore += 10*_UserLevel + i * _UserLevel;
			}
			_ScoreLabel.text = _UserScore.toString();
		}
		
		private function debugCheckPipe(pipieList:Vector.<pipieOV>):void
		{
			//trace("debug debugCheckPipe");
			
			_PipieCanvas.bitmapData.lock();
			var midRect:Rectangle = new Rectangle(0, 0, pipieOV.DIR_COMMON_W, pipieOV.DIR_COMMON_H);
			var point:Point = new Point();
			var drawPipie:pipieOV;
			for (var i:uint = 0; i < pipieList.length; i++)
			{
				drawPipie = pipieList[i];
				//drawPipie.traceString("drawPipie");
				point.x = drawPipie.x;
				point.y = drawPipie.y;
				var tmpBitmapData:BitmapData = PipieUtils.genPipieBitmapData(drawPipie);
				tmpBitmapData.colorTransform(tmpBitmapData.rect, new ColorTransform (1, 1, 1, 0, 0, 100, 0, 255));
				_PipieCanvas.bitmapData.copyPixels(tmpBitmapData, midRect, point);
			}
			_PipieCanvas.bitmapData.unlock();
		}
	}

}