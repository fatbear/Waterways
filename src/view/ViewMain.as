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
		private const STATE_STOP:uint = 4;
		private const STATE_LOSE:uint = 5;
		private const STATE_LVUP:uint = 6;
		
		private const MAX_X:uint = 7;
		private const MAX_Y:uint = 9;
		
		private var _CurState:uint = STATE_NONE;
		private var _Level:uint = 1;
		private var _CurY:uint = 3;
		private var _PipieList:Vector.<pipieOV>;
		private var _PipiePoolList:Vector.<pipieOV>;
		private var _RandomPipieDirList:Vector.<uint>;
		private var _ContentPipieList:Vector.<pipieOV>;
		
		private var _SkyBg:Bitmap;
		private var _GroundBitmap:Bitmap;
		private var _GroundShape:Shape;
		private var _PipieTopSprite:Sprite;
		private var _PipieTopBack:Bitmap;
		private var _PipieTopFront:Bitmap;
		private var _PipieTopCanvas:Bitmap;
		private var _PipieBottomCanvas:Bitmap;
		private var _PipieCanvas:Bitmap;
		private var _ScoreLabel:TextField;
	
		private var _UserScore:uint = 0;
		
		public function ViewMain() 
		{
			crateUI();
		}
		
		public function dispose():void
		{
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
			g.drawRect(0, 0, this.width, 540);
			g.endFill();
			_GroundShape.y = 117;
			_PipieTopSprite.addChild(_GroundShape);
			
			_PipieTopBack = new Assets.LAND_BACK() as Bitmap;
			_PipieTopBack.x = -1;
			_PipieTopBack.y = 0;
			_PipieTopSprite.addChild(_PipieTopBack);
			
			_PipieTopCanvas = new Bitmap(new BitmapData(this.width,117,true,0xffffff))
			_PipieTopSprite.addChild(_PipieTopCanvas);

			_PipieTopFront = new Assets.LAND_FRONT() as Bitmap;
			_PipieTopFront.x = -1;
			_PipieTopFront.y = 92;
			_PipieTopSprite.addChild(_PipieTopFront);
			
			_PipieCanvas = new Bitmap(new BitmapData(this.width,540,true,0xffffff));
			addChild(_PipieCanvas);
			
			_PipieBottomCanvas = new Bitmap(new BitmapData(this.width,82,false,0x4E3728))
			addChild(_PipieBottomCanvas);
			
			var newFormat:TextFormat = new TextFormat();
			newFormat.bold = true;
            newFormat.size = 30;
            newFormat.color = 0xFF0000;
            newFormat.align = TextFormatAlign.LEFT;
			
			_ScoreLabel = new TextField();
			_ScoreLabel.defaultTextFormat = newFormat;
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
				
				if (_PipieTopBack)
				{
					_PipieTopBack.bitmapData.dispose();
					_PipieTopSprite.removeChild(_PipieTopBack);
					_PipieTopBack = null;
				}
				
				if (_PipieTopFront)
				{
					_PipieTopFront.bitmapData.dispose();
					_PipieTopSprite.removeChild(_PipieTopFront);
					_PipieTopFront = null;
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
					initData();
					setState(STATE_PLAY);
					break;
					
				case STATE_PLAY:
					gamePlay();
					break;
				
				case STATE_PASS:
					gameStop();
					break;
				
				case STATE_STOP:
					break;
				
				case STATE_LOSE:
					break;
				
				case STATE_LVUP:
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
					break;
				
				case STATE_STOP:
					break;
				
				case STATE_LOSE:
					break;
				
				case STATE_LVUP:
					break;
			}
		}
			
		private function initData():void
		{
			_RandomPipieDirList = new Vector.<uint>();
			_RandomPipieDirList.push(pipieOV.DIR_12);
			_RandomPipieDirList.push(pipieOV.DIR_13);
			_RandomPipieDirList.push(pipieOV.DIR_23);
			_RandomPipieDirList.push(pipieOV.DIR_24);
			_RandomPipieDirList.push(pipieOV.DIR_34);
			_RandomPipieDirList.push(pipieOV.DIR_41);
			
			_PipiePoolList = new Vector.<pipieOV>();
			_PipieList = new Vector.<pipieOV>();
			
			var tmpPipieOV:pipieOV;
			for (var j:uint = 0; j <= _CurY+1; j++)
			{
				for (var i:uint = 0; i < MAX_X; i++)
				{
					if (j == 0)
					{
						tmpPipieOV = genRandomPipieOV(pipieOV.DIR_TOP);
					}
					else if (j == _CurY+1)
					{
						tmpPipieOV = genRandomPipieOV(pipieOV.DIR_BOTTOM);
					}
					else
					{
						tmpPipieOV = genRandomPipieOV();
					}
					tmpPipieOV.px = i;
					tmpPipieOV.py = j;
					_PipieList.push(tmpPipieOV);
				}
			}
			
			_ScoreLabel.text = _UserScore.toString();
			
			initPipieTopCanvas();
			initPipieButtomCanvas();
			genInitPipieContent();
			genPipieCanvas();
			
			_PipieBottomCanvas.y = this.height -82;
			_PipieCanvas.y = _PipieBottomCanvas.y - _CurY * pipieOV.DIR_COMMON_H;
			_PipieTopSprite.y = _PipieCanvas.y - 117;
		}
		
		private function initPipieTopCanvas():void
		{
			var rect:Rectangle = new Rectangle(0, 0, 60, 60);
			var point:Point = new Point();
			var tmpBD:BitmapData = PipieUtils.genPipieBitmapData(pipieOV.DIR_TOP);
			var tmpPipieOV:pipieOV;
			
			point.y = 50;
			
			_PipieTopCanvas.bitmapData.lock();
			
			for (var i:uint = 0; i < MAX_X; i++)
			{
				tmpPipieOV = _PipieList[i];
				if (tmpPipieOV && tmpPipieOV.direction == pipieOV.DIR_TOP)
				{
					point.x = 30 + (tmpPipieOV.px) * 60;
					_PipieTopCanvas.bitmapData.copyPixels(tmpBD, rect, point);
				}
			}
			
			_PipieTopCanvas.bitmapData.unlock();
		}
		
		private function initPipieButtomCanvas():void
		{
			var rect:Rectangle = new Rectangle(0, 0, 0, 0);
			var point:Point = new Point();
			var tmpBD:BitmapData = PipieUtils.genPipieBitmapData(pipieOV.DIR_BOTTOM);
			var tmpPipieOV:pipieOV;
			
			_PipieBottomCanvas.bitmapData.lock();
			
			rect.width = 60;
			rect.height = 60;
			point.y = 5;
			for (var i:uint = 0; i < MAX_X; i++)
			{
				tmpPipieOV = _PipieList[(_CurY+1)*MAX_X+i];
				if (tmpPipieOV && tmpPipieOV.direction == pipieOV.DIR_BOTTOM)
				{
					point.x = 30 + (tmpPipieOV.px) * 60;
					_PipieBottomCanvas.bitmapData.copyPixels(tmpBD, rect, point);
				}
			}
			
			rect.width = 480;
			rect.height = 32;
			point.x = 0;
			point.y = 0;
			tmpBD = Bitmap(new Assets.BOTTOM_LINE()).bitmapData;
			_PipieBottomCanvas.bitmapData.copyPixels(tmpBD, rect, point);
			
			_PipieBottomCanvas.bitmapData.unlock();
		}
		
		private function genRandomPipieOV(type:uint = 0):pipieOV
		{
			var tmpPipieOV:pipieOV = new pipieOV();
			var len:uint = _RandomPipieDirList.length;
			//1-上水管，2-下水管，3-中间水管
			if (type == pipieOV.DIR_TOP)
			{
				tmpPipieOV.direction = pipieOV.DIR_TOP;
			}
			else if (type == pipieOV.DIR_BOTTOM)
			{
				tmpPipieOV.direction = pipieOV.DIR_BOTTOM;
			}
			else
			{
				tmpPipieOV.direction = _RandomPipieDirList[int(Math.random() * len)];
				//tmpPipieOV.direction = pipieOV.DIR_13;
			}
			return tmpPipieOV;
		}
		
		private function genPipieCanvas():void
		{
			if (_PipieCanvas)
			{
				var rect:Rectangle = new Rectangle(0, 0, 60, 60);
				var point:Point = new Point();
				var tmpPipieOV:pipieOV;
				var tmpBitmapData:BitmapData;
				_PipieCanvas.bitmapData.lock();
				for (var i:uint = MAX_X; i < _PipieList.length-MAX_X; i++)
				{
					tmpPipieOV = _PipieList[i];
					if (tmpPipieOV && tmpPipieOV.direction != pipieOV.DIR_TOP && tmpPipieOV.direction != pipieOV.DIR_BOTTOM)
					{
						tmpBitmapData = PipieUtils.genPipieBitmapData(tmpPipieOV.direction);
						point.x = 30 + (tmpPipieOV.px) * pipieOV.DIR_COMMON_W;
						point.y = (tmpPipieOV.py - 1) * pipieOV.DIR_COMMON_H;
						_PipieCanvas.bitmapData.copyPixels(tmpBitmapData, rect, point);
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
			var tmpPipieOV:pipieOV = findPipieOV(this.mouseX, this.mouseY);
			if (tmpPipieOV)
			{
				changePipieDir(tmpPipieOV);
				checkPass(tmpPipieOV);
			}
		}
		
		private function findPipieOV(mouseX:Number,mouseY:Number):pipieOV
		{
			if (mouseX<30|| mouseX>450 || mouseY<(_PipieBottomCanvas.y - _CurY*pipieOV.DIR_COMMON_H) || mouseY > _PipieBottomCanvas.y)
			{
				return null;
			}
			else
			{
				var pipieX:uint = int((mouseX - 30) / pipieOV.DIR_COMMON_W);
				var pipieY:uint = int((mouseY - _PipieCanvas.y) / pipieOV.DIR_COMMON_H) + 1;
				var index:uint = pipieY * MAX_X + pipieX;
				
				trace(mouseX,mouseY,pipieX,pipieY,index)
				
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
			pipie.direction = PipieUtils.changeDirByClick(pipie.direction);
			
			_PipieCanvas.bitmapData.lock();
			var midRect:Rectangle = new Rectangle(0, 0, 60, 60);
			var point:Point = new Point();
			point.x = 30 + (pipie.px) * pipieOV.DIR_COMMON_W;
			point.y = (pipie.py - 1) * pipieOV.DIR_COMMON_H;
			var tmpBitmapData:BitmapData = PipieUtils.genPipieBitmapData(pipie.direction);
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
			if (pipie.contentPipie1 && pipie.contentPipie2)
			{
				_ContentPipieList = new Vector.<pipieOV>();
				_ContentPipieList.push(pipie);
				
				var tmpEnterPipie:pipieOV;
				var tmpPipie1:pipieOV = pipie.contentPipie1;
				var tmpPipie2:pipieOV = pipie.contentPipie2;
				
				tmpPipie1.enterPipie = pipie;
				tmpPipie2.enterPipie = pipie;
				tmpPipie1.traceString("tmpPipie1");
				while (tmpPipie1.contentPipie1 && tmpPipie1.contentPipie2 )
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
					tmpPipie1.traceString("tmpPipie1");
				}
				tmpPipie2.traceString("tmpPipie2");
				while (tmpPipie2.contentPipie1 && tmpPipie2.contentPipie2 )
				{
					_ContentPipieList.push(tmpPipie2);
					tmpEnterPipie = tmpPipie2;
					if (tmpPipie2.contentPipie1 == tmpPipie1.enterPipie)
					{
						tmpPipie2 = tmpPipie2.contentPipie2;
					}
					else 
					{
						tmpPipie2 = tmpPipie2.contentPipie1;
					}
					tmpPipie2.traceString("tmpPipie2");
				}
				trace("_ContentPipieList.length = " + _ContentPipieList.length);
				if (_ContentPipieList.length >= _CurY && 
					(tmpPipie1.direction == pipieOV.DIR_TOP  || tmpPipie1.direction == pipieOV.DIR_BOTTOM) && 
					(tmpPipie2.direction == pipieOV.DIR_TOP || tmpPipie2.direction == pipieOV.DIR_BOTTOM))
				{
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
			if (pipie)
			{
				pipie.cleanPipie();
				var room1:uint = int(pipie.direction / 10);
				var room2:uint = int(pipie.direction % 10);
				pipie.contentPipie1 = findContentPipie(room1, pipie);
				pipie.contentPipie2 = findContentPipie(room2, pipie);
				
				pipie.traceString("pipie");
				if (pipie.contentPipie1)
				{
					pipie.contentPipie1.traceString("contentPipie1");
				}
				if (pipie.contentPipie2)
				{
					pipie.contentPipie2.traceString("contentPipie2");
				}
			}
		}
				
		private function setScore(pipieList:Vector.<pipieOV>):void
		{
			for (var i:uint = 0; i < pipieList.length; i++)
			{
				_UserScore += 10 + i * 1;
			}
			_ScoreLabel.text = _UserScore.toString();
		}
		
		private function debugCheckPipe(pipieList:Vector.<pipieOV>):void
		{
			_PipieCanvas.bitmapData.lock();
			var midRect:Rectangle = new Rectangle(0, 0, pipieOV.DIR_COMMON_W, pipieOV.DIR_COMMON_H);
			var point:Point = new Point();
			var drawPipie:pipieOV;
			for (var i:uint = 0; i < pipieList.length; i++)
			{
				drawPipie = _ContentPipieList[i];
				point.x = 30 + (drawPipie.px) * pipieOV.DIR_COMMON_W;
				point.y = (drawPipie.py - 1) * pipieOV.DIR_COMMON_H;
				var tmpBitmapData:BitmapData = PipieUtils.genPipieBitmapData(drawPipie.direction);
				tmpBitmapData.colorTransform(tmpBitmapData.rect, new ColorTransform (0, 0, 0, 0, 255, 100, 255, 255));
				_PipieCanvas.bitmapData.copyPixels(tmpBitmapData, midRect, point);
			}
			_PipieCanvas.bitmapData.unlock();
		}
	}

}