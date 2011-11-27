package 
{
	import flash.display.Sprite;
	import flash.events.Event;
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
		
		private var _UserScore:uint = 0;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			trace("game size = ", stage.stageWidth, stage.stageHeight, stage.width, stage.height, this.width, this.height);
			
			MttService.initialize(root);
			MttService.addEventListener(MttService.ETLOGOUT, onLogout); 
 
			setViewChange(VIEW_STATE_MENU);
		}
		
		private function onLogout(e:Event):void 
		{ 
			MttService.login(); 
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
					MttScore.submit(e.score, onFinishSubmit);
					break;
				
				case ViewEvent.GAME_SHOW_SCORE:
					//MttScore.
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
	}
	
}