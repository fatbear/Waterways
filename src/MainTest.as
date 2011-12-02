package  
{
	import assets.Assets;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Tom.Lu
	 */
	public class MainTest extends Sprite 
	{
		private var _PipieBottomCanvas:Bitmap;
		
		public function MainTest() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			_PipieBottomCanvas = new Bitmap();
			addChild(_PipieBottomCanvas);	
			
			_PipieBottomCanvas.bitmapData = new BitmapData(480, 500, true, 0x4E3728);
				
			var point:Point = new Point(10, 10);
			var tmpBD:BitmapData = Bitmap(new Assets.LAND_BACK()).bitmapData;
			
			_PipieBottomCanvas.bitmapData.copyPixels(tmpBD, tmpBD.rect, point, tmpBD, new Point(), true);

			_PipieBottomCanvas.bitmapData.unlock();
		}
	}

}