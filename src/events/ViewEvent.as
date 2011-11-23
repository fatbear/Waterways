package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Tom.Lu
	 */
	public class ViewEvent extends Event 
	{
		public static const GAME_PLAY:String = "ve01";
		public static const GAME_OVER:String = "ve02";
		public static const GAME_REPLAY:String = "ve03";
		public static const GAME_MENU:String = "ve04";
		
		private var _score:uint = 0;
		
		public function ViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
		public function get score():uint
		{
			return _score;
		}
		
		public static function createGamePlayEvent(bubbles:Boolean=false, cancelable:Boolean=false):ViewEvent
		{
			var eventObj : ViewEvent = new ViewEvent(GAME_PLAY, bubbles, cancelable);
			return eventObj;
		}
		
		public static function createGameOverEvent(score:uint,bubbles:Boolean=false, cancelable:Boolean=false):ViewEvent
		{
			var eventObj : ViewEvent = new ViewEvent(GAME_OVER, bubbles, cancelable);
			eventObj._score = score;
			return eventObj;
		}
		
		public static function createGameReplayEvent(bubbles:Boolean=false, cancelable:Boolean=false):ViewEvent
		{
			var eventObj : ViewEvent = new ViewEvent(GAME_REPLAY, bubbles, cancelable);
			return eventObj;
		}
		
		public static function createGameMenuEvent(bubbles:Boolean=false, cancelable:Boolean=false):ViewEvent
		{
			var eventObj : ViewEvent = new ViewEvent(GAME_MENU, bubbles, cancelable);
			return eventObj;
		}
	}

}