package view 
{
	import assets.Assets;
	import events.ViewEvent;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Tom.Lu
	 */
	public class ViewOver extends Sprite 
	{
		private var _StageW:Number;
		private var _StageH:Number;
		
		private var _Bg:Sprite;
		private var _LoseText:Bitmap;
		private var _SumbitScoreBtn:SimpleButton;
		private var _RePlayBtn:SimpleButton;
		private var _BackToMenuBtn:SimpleButton;
		private var _ScoreLabel:TextField;
		
		private var _UserScore:uint = 0;
		
		
		public function ViewOver(score:uint) 
		{
			_StageW = 480;
			_StageH = 800;
			_UserScore = score;
			
			crateUI();
		}
		
		public function dispose():void
		{
			disposeUI();
		}
		
		private function crateUI():void
		{
			trace("ViewOver game size = ", this.width, this.height);
			
			_Bg = new Sprite();
			var g:Graphics = _Bg.graphics;
			g.clear();
			g.beginFill(0x00CBFF, 0.8);
			g.drawRect(0, 0, _StageW, _StageH);
			g.endFill();
			addChild(_Bg);
			
			_LoseText = new Assets.OVER_TITLE() as Bitmap;
			_LoseText.x = (_StageW - _LoseText.width) / 2;
			_LoseText.y = 100;
			addChild(_LoseText);
			
			var scoreFormat:TextFormat = new TextFormat("_sans", "40", "0x009900", "true");
            scoreFormat.align = TextFormatAlign.CENTER;
			
			_ScoreLabel = new TextField();
			_ScoreLabel.autoSize = TextFieldAutoSize.CENTER;
			_ScoreLabel.selectable = false;
			_ScoreLabel.defaultTextFormat = scoreFormat;
			_ScoreLabel.text = "得分:" + _UserScore.toString();
			_ScoreLabel.x = (_StageW - _ScoreLabel.width) / 2;
			_ScoreLabel.y = _LoseText.y + _LoseText.height + 50;
			addChild(_ScoreLabel);
			
			_SumbitScoreBtn = new SimpleButton();
			_SumbitScoreBtn.upState = new Assets.OVER_SUMBIT_BTN() as Bitmap;
			_SumbitScoreBtn.overState = new Assets.OVER_SUMBIT_BTN() as Bitmap;
			_SumbitScoreBtn.downState = new Assets.OVER_SUMBIT_BTN() as Bitmap;
			_SumbitScoreBtn.hitTestState = new Assets.OVER_SUMBIT_BTN() as Bitmap;
			addChild(_SumbitScoreBtn);
			_SumbitScoreBtn.addEventListener(MouseEvent.CLICK, sumbitScoreBtnClickHandler, false, 0, true);
			
			_RePlayBtn = new SimpleButton();
			_RePlayBtn.upState = new Assets.OVER_REPLAY_BTN() as Bitmap;
			_RePlayBtn.overState = new Assets.OVER_REPLAY_BTN() as Bitmap;
			_RePlayBtn.downState = new Assets.OVER_REPLAY_BTN() as Bitmap;
			_RePlayBtn.hitTestState = new Assets.OVER_REPLAY_BTN() as Bitmap;
			addChild(_RePlayBtn);
			_RePlayBtn.addEventListener(MouseEvent.CLICK, replayBtnClickHandler, false, 0, true);
			
			_BackToMenuBtn = new SimpleButton();
			_BackToMenuBtn.upState = new Assets.OVER_MENU_BTN() as Bitmap;
			_BackToMenuBtn.overState = new Assets.OVER_MENU_BTN() as Bitmap;
			_BackToMenuBtn.downState = new Assets.OVER_MENU_BTN() as Bitmap;
			_BackToMenuBtn.hitTestState = new Assets.OVER_MENU_BTN() as Bitmap;
			addChild(_BackToMenuBtn);
			_BackToMenuBtn.addEventListener(MouseEvent.CLICK, backToMenuClickHandler, false, 0, true);
			
			_SumbitScoreBtn.x = (_StageW - _SumbitScoreBtn.width) / 2;
			_SumbitScoreBtn.y = 500;
			_RePlayBtn.x = _SumbitScoreBtn.x
			_RePlayBtn.y = _SumbitScoreBtn.y + _SumbitScoreBtn.height + 20;
			_BackToMenuBtn.x = _RePlayBtn.x
			_BackToMenuBtn.y = _RePlayBtn.y + _RePlayBtn.height + 20;
		}
		
		private function disposeUI():void
		{
			if (_Bg)
			{
				_Bg.graphics.clear();
				removeChild(_Bg)
				_Bg = null;
			}
			
			if (_LoseText)
			{
				_LoseText.bitmapData.dispose();
				removeChild(_LoseText);
				_LoseText = null;
			}
			
			if (_ScoreLabel)
			{
				removeChild(_ScoreLabel);
				_ScoreLabel = null;
			}
			
			if (_SumbitScoreBtn)
			{
				_SumbitScoreBtn.removeEventListener(MouseEvent.CLICK, sumbitScoreBtnClickHandler);
				removeChild(_SumbitScoreBtn);
				_SumbitScoreBtn = null;
			}
			
			if (_RePlayBtn)
			{
				_RePlayBtn.removeEventListener(MouseEvent.CLICK, replayBtnClickHandler);
				removeChild(_RePlayBtn);
				_RePlayBtn = null;
			}
			
			if (_BackToMenuBtn)
			{
				_BackToMenuBtn.removeEventListener(MouseEvent.CLICK, backToMenuClickHandler);
				removeChild(_BackToMenuBtn);
				_BackToMenuBtn = null;
			}
		}
		
		private function sumbitScoreBtnClickHandler(e:MouseEvent):void
		{
			var evtObj:ViewEvent = ViewEvent.createGameSubmitEvent(_UserScore);
			this.dispatchEvent(evtObj);
		}
		
		private function replayBtnClickHandler(e:MouseEvent):void
		{
			var evtObj:ViewEvent = ViewEvent.createGameReplayEvent();
			this.dispatchEvent(evtObj);
		}
		
		private function backToMenuClickHandler(e:MouseEvent):void
		{
			var evtObj:ViewEvent = ViewEvent.createGameMenuEvent();
			this.dispatchEvent(evtObj);
		}
	}

}