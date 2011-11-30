package view 
{
	import assets.Assets;
	import events.CustomEventSound;
	import events.ViewEvent;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Tom.Lu
	 */
	public class ViewMenu extends Sprite 
	{
		private var _Bg:Bitmap;
		private var _StartBtn:SimpleButton;
		private var _HelpBtn:SimpleButton;
		private var _RankBtn:SimpleButton;
		private var _InfoBtn:SimpleButton;
		
		private var _HelpSprite:Sprite;
		private var _HelpShotBitmap:Bitmap;
		private var _HelpText:TextField;
		private var _HelpBackBtn:SimpleButton;
		
		public function ViewMenu() 
		{
			crateUI();
		}
		
		public function dispose():void
		{
			disposeUI();
		}
		
		private function crateUI():void
		{
			_Bg = new Assets.MENU_BG() as Bitmap;
			addChild(_Bg);
			
			_StartBtn = new SimpleButton();
			_StartBtn.upState = new Assets.MENU_START_BTN() as Bitmap;
			_StartBtn.overState = new Assets.MENU_START_BTN() as Bitmap;
			_StartBtn.downState = new Assets.MENU_START_BTN() as Bitmap;
			_StartBtn.hitTestState = new Assets.MENU_START_BTN() as Bitmap;
			_StartBtn.x = 72;
			_StartBtn.y = 408;
			addChild(_StartBtn);
			_StartBtn.addEventListener(MouseEvent.CLICK, startBtnClickHandler, false, 0, true);
			
			/*
			_HelpBtn = new SimpleButton();
			_HelpBtn.upState = new Assets.MENU_HELP_BTN() as Bitmap;
			_HelpBtn.overState = new Assets.MENU_HELP_BTN() as Bitmap;
			_HelpBtn.downState = new Assets.MENU_HELP_BTN() as Bitmap;
			_HelpBtn.hitTestState = new Assets.MENU_HELP_BTN() as Bitmap;
			_HelpBtn.x = 286;
			_HelpBtn.y = 495;
			addChild(_HelpBtn);
			_HelpBtn.addEventListener(MouseEvent.CLICK, helpBtnClickHandler, false, 0, true);
			
			_RankBtn = new SimpleButton();
			_RankBtn.upState = new Assets.MENU_RANK_BTN() as Bitmap;
			_RankBtn.overState = new Assets.MENU_RANK_BTN() as Bitmap;
			_RankBtn.downState = new Assets.MENU_RANK_BTN() as Bitmap;
			_RankBtn.hitTestState = new Assets.MENU_RANK_BTN() as Bitmap;
			_RankBtn.x = 180;
			_RankBtn.y = 452;
			addChild(_RankBtn);
			_RankBtn.addEventListener(MouseEvent.CLICK, rankBtnClickHandler, false, 0, true);
			
			_InfoBtn = new SimpleButton();
			_InfoBtn.upState = new Assets.MENU_INFO_BTN() as Bitmap;
			_InfoBtn.overState = new Assets.MENU_INFO_BTN() as Bitmap;
			_InfoBtn.downState = new Assets.MENU_INFO_BTN() as Bitmap;
			_InfoBtn.hitTestState = new Assets.MENU_INFO_BTN() as Bitmap;
			_InfoBtn.x = 399;
			_InfoBtn.y = 495;
			addChild(_InfoBtn);
			_InfoBtn.addEventListener(MouseEvent.CLICK, infoBtnClickHandler, false, 0, true);
			*/
		}
		
		private function disposeUI():void
		{
			if (_Bg)
			{
				_Bg.bitmapData.dispose();
				removeChild(_Bg);
				_Bg = null;
			}
			
			if (_StartBtn)
			{
				_StartBtn.removeEventListener(MouseEvent.CLICK, startBtnClickHandler);
				removeChild(_StartBtn);
				_StartBtn = null;
			}
			
			if (_HelpBtn)
			{
				_HelpBtn.removeEventListener(MouseEvent.CLICK, helpBtnClickHandler);
				removeChild(_HelpBtn);
				_HelpBtn = null;
			}
			
			if (_RankBtn)
			{
				_RankBtn.removeEventListener(MouseEvent.CLICK, rankBtnClickHandler);
				removeChild(_RankBtn);
				_RankBtn = null;
			}
			
			if (_InfoBtn)
			{
				_InfoBtn.removeEventListener(MouseEvent.CLICK, infoBtnClickHandler);
				removeChild(_InfoBtn);
				_InfoBtn = null;
			}
		}
		
		private function startBtnClickHandler(e:MouseEvent):void
		{
			this.dispatchEvent( new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_CLICK, false, 1, 0, 0.5) );
			
			var evtObj:ViewEvent = ViewEvent.createGamePlayEvent();
			this.dispatchEvent(evtObj);
		}
		
		private function helpBtnClickHandler(e:MouseEvent):void
		{
			this.dispatchEvent( new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_CLICK, false, 1, 0, 0.5) );
		}
		
		private function rankBtnClickHandler(e:MouseEvent):void
		{
			this.dispatchEvent( new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_CLICK, false, 1, 0, 0.5) );
			
			var evtObj:ViewEvent = ViewEvent.createGameShowScoreEvent();
			this.dispatchEvent(evtObj);
		}
		
		private function infoBtnClickHandler(e:MouseEvent):void
		{
			this.dispatchEvent( new CustomEventSound(CustomEventSound.PLAY_SOUND, Main.SOUND_CLICK, false, 1, 0, 0.5) );
		}
	}

}