package 
{
	import assets.Assets;
	import events.CustomEventSound;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import utils.SoundManager;
	import view.ViewMain;
	import view.ViewMenu;
	import view.ViewOver;
	import events.ViewEvent;
	
	import com.qq.openapi.MttService;
	import com.qq.openapi.MttScore;
	import com.qq.openapi.ScoreInfo;
	
	/**
	 * ...
	 * @author Tom.Lu
	 */
	public class Main extends Sprite 
	{
		private const VIEW_STATE_MENU:uint = 0;
		private const VIEW_STATE_MAIN:uint = 1;
		private const VIEW_STATE_OVER:uint = 2;
		
		private var curView:uint = VIEW_STATE_MENU;
		
		private var menuView:ViewMenu;
		private var mainView:ViewMain;
		private var overView:ViewOver;
		
		private var _DebugLabel:TextField;
		private var _StageW:Number;
		private var _StageH:Number;
		
		private var _UserScore:uint = 0;
		
		private var _SoundManager:SoundManager;
		
		//custom sounds
		public static const SOUND_CLICK:String = "Click";
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_StageW = stage.stageWidth;
			_StageH = stage.stageHeight;
			
			MttService.initialize(root);
			MttService.addEventListener(MttService.ETLOGOUT, onLogout); 
			MttService.addEventListener(MttService.ETAGAIN, onAgain); 
			
			_SoundManager = new SoundManager();
			_SoundManager.addSound(SOUND_CLICK, new Assets.SOUND_CLICK());
			this.addEventListener(CustomEventSound.PLAY_SOUND, customEventSoundHandler, false, 0, true);
			this.addEventListener(CustomEventSound.STOP_SOUND, customEventSoundHandler, false, 0, true);
			setViewChange(VIEW_STATE_MENU);
		}
		
		private function onLogout(e:Event):void 
		{ 
			MttService.login(); 
		} 
		
		private function onAgain(e:Event):void
		{
			disposeViewMain();
			setViewChange(VIEW_STATE_MAIN);
		}
		
		private function customEventSoundHandler(e:CustomEventSound):void
		{
			switch(e.type)
			{
				case CustomEventSound.PLAY_SOUND:
					_SoundManager.playSound(e.name, e.isSoundTrack, e.loops, e.offset, e.volume);
					break;
					
				case CustomEventSound.STOP_SOUND:
					_SoundManager.stopSound(e.name, e.isSoundTrack);
					break;
			}
		}
		
		private function viewEventHandler(e:ViewEvent):void
		{
			switch(e.type)
			{
				case ViewEvent.GAME_PLAY:
					setViewChange(VIEW_STATE_MAIN);
					break;
					
				case ViewEvent.GAME_OVER:
					_UserScore = e.score;
					setViewChange(VIEW_STATE_OVER);
					break;
					
				case ViewEvent.GAME_REPLAY:
					disposeViewMain();
					setViewChange(VIEW_STATE_MAIN);
					break;
					
				case ViewEvent.GAME_MENU:
					setViewChange(VIEW_STATE_MENU);
					break;
				
				case ViewEvent.GAME_SUBMIT:
					//MttScore.submit(e.score, onFinishSubmit);
					MttScore.show(e.score, {x:0, y:0, w:480, h:800});
					break;
				
				case ViewEvent.GAME_SHOW_SCORE:
					//createDebugLabel("ViewEvent.GAME_SHOW_SCORE")
					//MttScore.show(1, {x:0, y:0, w:240, h:240});
					break;	
					
			}
		}
		
		private function onFinishSubmit(result:Object):void 
		{ 
			var sInfo:String = "调用提交积分接口反馈：\n\n 返回码:" + result.code; 
			if (result.code == 0) 
			{ 
				var score:ScoreInfo = result.score as ScoreInfo; 
				var time :Date = new Date(score.playTime * 1000); 
				 
				sInfo += "\n结果描述：调用接口成功"; 
				sInfo += "\n我的昵称：" + score.nickName + "\n 最高积分：" + score.score + "\n创建时间：" + time.toLocaleString() + "\n 我的排名：" + score.rank; 
			}	 
			else 
			{ 
				sInfo += "\n结果描述：调用接口失败"; 
			} 
			 
			trace(sInfo); 
		} 

		private function setViewChange(newView:uint):void
		{
			curView = newView;
			switch(newView)
			{
				case VIEW_STATE_MENU:
					disposeViewMain();
					disposeViewOver();
					crateViewMenu();
					//createDebugLabel(stage.stageWidth+","+stage.stageHeight+","+stage.width+","+stage.height+","+this.width+","+this.height)
					break;
					
				case VIEW_STATE_MAIN:
					disposeViewMenu();
					disposeViewOver();
					createViewMain();
					break;
					
				case VIEW_STATE_OVER:
					disposeViewMenu();
					createViewOver();
					break;
			}
		}
		
		private function crateViewMenu():void
		{
			if (!menuView)
			{
				menuView = new ViewMenu();
				menuView.addEventListener(ViewEvent.GAME_PLAY, viewEventHandler, false, 0, true);
				menuView.addEventListener(ViewEvent.GAME_SHOW_SCORE, viewEventHandler, false, 0, true);
				addChild(menuView);
			}
		}
		
		private function disposeViewMenu():void
		{
			if (menuView)
			{
				menuView.removeEventListener(ViewEvent.GAME_PLAY, viewEventHandler);
				menuView.removeEventListener(ViewEvent.GAME_SHOW_SCORE, viewEventHandler);
				removeChild(menuView);
				menuView = null;
			}
		}
		
		private function createViewMain():void
		{
			if (!mainView)
			{
				mainView = new ViewMain();
				mainView.addEventListener(ViewEvent.GAME_OVER, viewEventHandler, false, 0, true);
				addChild(mainView);
			}
		}
		
		private function disposeViewMain():void
		{
			if (mainView)
			{
				mainView.removeEventListener(ViewEvent.GAME_OVER, viewEventHandler);
				removeChild(mainView);
				mainView = null;
			}
		}
		
		private function createViewOver():void
		{
			if (!overView)
			{
				overView = new ViewOver(_UserScore);
				overView.addEventListener(ViewEvent.GAME_SUBMIT, viewEventHandler, false, 0, true);
				overView.addEventListener(ViewEvent.GAME_REPLAY, viewEventHandler, false, 0, true);
				overView.addEventListener(ViewEvent.GAME_MENU, viewEventHandler, false, 0, true);
				addChild(overView);
			}
		}
		
		private function disposeViewOver():void
		{
			if (overView)
			{
				overView.removeEventListener(ViewEvent.GAME_SUBMIT, viewEventHandler);
				overView.removeEventListener(ViewEvent.GAME_REPLAY, viewEventHandler);
				overView.removeEventListener(ViewEvent.GAME_MENU, viewEventHandler);
				removeChild(overView);
				overView = null;
			}
		}
		
		private function createDebugLabel(newString:String):void
		{
			if (!_DebugLabel)
			{
				var scoreFormat:TextFormat = new TextFormat("_sans", "20", "0x009900", "true");
				_DebugLabel = new TextField();
				_DebugLabel.width = 100;
				_DebugLabel.autoSize = TextFieldAutoSize.LEFT;
				_DebugLabel.height = 200;
				_DebugLabel.selectable = false;
				_DebugLabel.defaultTextFormat = scoreFormat;
			}
			addChild(_DebugLabel);
			
			_DebugLabel.appendText(newString + "|");
		}
	}
	
}