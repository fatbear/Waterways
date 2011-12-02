package datamodels 
{
	/**
	 * ...
	 * @author Tom.Lu
	 */
	public class pipieOV 
	{
		public static const DIR_TOP:uint = 4;
		public static const DIR_BOTTOM:uint = 2; 
		public static const DIR_12:uint = 12;
		public static const DIR_23:uint = 23;
		public static const DIR_34:uint = 34;
		public static const DIR_41:uint = 41;
		public static const DIR_13:uint = 13;
		public static const DIR_24:uint = 24;
		
		public static const STATE_NONE:uint = 0;
		public static const STATE_CLICK:uint = 1;
		public static const STATE_PASSING:uint = 2;
		public static const STATE_MOVE:uint = 3;
		
		public static const COLOR_GREEN:uint = 0;
		public static const COLOR_RED:uint = 1;
		public static const COLOR_BLUE:uint = 2;
		public static const COLOR_YELLOW:uint = 3;
		public static const COLOR_PURPLE:uint = 4;
		
		public static const DIR_TOP_W:Number = 46;
		public static const DIR_TOP_H:Number = 63;
		public static const DIR_BOTTOM_W:Number = 66;
		public static const DIR_BOTTOM_H:Number = 100;
		public static const DIR_COMMON_W:Number = 68;
		public static const DIR_COMMON_H:Number = 68;
		
		public var direction:uint = DIR_12;
		public var type:uint = STATE_NONE;
		public var color:uint = COLOR_GREEN;
		public var px:uint = 0;
		public var py:uint = 0;
		public var x:Number = 0;
		public var y:Number = 0;
		public var nextX:Number = 0;
		public var nextY:Number = 0;
		public var times:int = -1;
		//-1 表示不倒数，大于0就是倒数，等于0表示倒数结束
		
		public var contentPipie1:pipieOV = null;
		public var contentPipie2:pipieOV = null;
		public var enterPipie:pipieOV = null;
		
		public function pipieOV() 
		{
			
		}
	
		public function cleanPipie():void
		{
			contentPipie1 = null;
			contentPipie2 = null;
			enterPipie = null;
		}
		
		public function traceString(value:String):void
		{
			trace(value,"= (", px+1, py+1, ")");
		}
	}

}