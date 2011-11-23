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
		
		public static const COLOR_NONE:uint = 0;
		public static const COLOR_RED:uint = 1;
		public static const COLOR_ORANGE:uint = 2;
		public static const COLOR_YELLOW:uint = 3;
		public static const COLOR_GREEN:uint = 4;
		public static const COLOR_BLUE:uint = 5;
		public static const COLOR_PURPLE:uint = 6;
		
		public static const DIR_L_W:Number = 56;
		public static const DIR_L_H:Number = 43;
		public static const DIR_R_W:Number = 17;
		public static const DIR_R_H:Number = 43;
		public static const DIR_COMMON_W:Number = 60;
		public static const DIR_COMMON_H:Number = 60;
		
		private var _Direction:uint = DIR_12;
		private var _Type:uint = STATE_NONE;
		private var _Color:uint = COLOR_NONE;
		private var _PX:uint = 0;
		private var _PY:uint = 0;
		private var _X:Number = 0;
		private var _Y:Number = 0;
		private var _NextX:Number = 0;
		private var _NextY:Number = 0;
		
		private var _ContentPipie1:pipieOV = null;
		private var _ContentPipie2:pipieOV = null;
		private var _EnterPipie:pipieOV = null;
		
		public function pipieOV() 
		{
			
		}
		
		public function set direction(value:uint):void
		{
			this._Direction = value;
		}
		public function get direction():uint
		{
			return this._Direction;
		}
		
		public function set type(value:uint):void
		{
			this._Type = value;
		}
		public function get type():uint
		{
			return this._Type;
		}
		
		public function set color(value:uint):void
		{
			this._Color = value;
		}
		public function get color():uint
		{
			return this._Color;
		}
		
		public function set px(value:uint):void
		{
			this._PX = value;
		}
		public function get px():uint
		{
			return this._PX;
		}
		
		public function set py(value:uint):void
		{
			this._PY = value;
		}
		public function get py():uint
		{
			return this._PY;
		}
		
		public function set x(value:Number):void
		{
			this._X = value;
		}
		public function get x():Number
		{
			return this._X;
		}
		
		public function set y(value:Number):void
		{
			this._Y = value;
		}
		public function get y():Number
		{
			return this._Y;
		}
		
		public function set nextX(value:Number):void
		{
			this._NextX = value;
		}
		public function get nextX():Number
		{
			return this._NextX;
		}
		
		public function set nextY(value:Number):void
		{
			this._NextY = value;
		}
		public function get nextY():Number
		{
			return this._NextY;
		}
		
		public function set enterPipie(value:pipieOV):void
		{
			this._EnterPipie = value;
		}
		public function get enterPipie():pipieOV
		{
			return _EnterPipie;
		}
		
		public function set contentPipie1(value:pipieOV):void
		{
			this._ContentPipie1 = value;
		}
		public function get contentPipie1():pipieOV
		{
			return _ContentPipie1;
		}
		
		public function set contentPipie2(value:pipieOV):void
		{
			this._ContentPipie2 = value;
		}
		public function get contentPipie2():pipieOV
		{
			return _ContentPipie2;
		}

		public function cleanPipie():void
		{
			_ContentPipie1 = null;
			_ContentPipie2 = null;
			_EnterPipie = null;
		}
		
		public function traceString(value:String):void
		{
			trace(value,"= (", _PX, _PY, ")");
		}
	}

}