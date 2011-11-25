package utils 
{
	import assets.Assets;
	import datamodels.pipieOV;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Tom.Lu
	 */
	public class PipieUtils 
	{
		public static const PIPIE_MID_BD:BitmapData = Bitmap(new Assets.PIPIE_ASSETS()).bitmapData;
		public static const PIPIE_TOP_BD:BitmapData = Bitmap(new Assets.PIPIE_TOP()).bitmapData;
		public static const PIPIE_BOTTOM_BD:BitmapData = Bitmap(new Assets.PIPIE_BOTTOM()).bitmapData;
		public static const DIR_LIST:Vector.<uint> = new Vector.<uint>();
		DIR_LIST.push(pipieOV.DIR_12, pipieOV.DIR_13, pipieOV.DIR_23, pipieOV.DIR_24, pipieOV.DIR_34, pipieOV.DIR_41);
		public static const COLOR_LIST:Vector.<uint> = new Vector.<uint>();
		COLOR_LIST.push(pipieOV.COLOR_GREEN, pipieOV.COLOR_RED, pipieOV.COLOR_BLUE, pipieOV.COLOR_YELLOW, pipieOV.COLOR_PURPLE);
		
		/*
		 * 随机抽取方向
		 */ 
		public static function randomPipieDir(dir:uint=0):uint
		{
			//trace("debug randomPipieDir");
			var direction:uint;
			var len:uint = DIR_LIST.length;
			//1-上水管，2-下水管，3-中间水管
			if (dir == pipieOV.DIR_TOP)
			{
				direction= pipieOV.DIR_TOP;
			}
			else if (dir == pipieOV.DIR_BOTTOM)
			{
				direction = pipieOV.DIR_BOTTOM;
			}
			else
			{
				direction = DIR_LIST[int(Math.random() * len)];
				//direction = pipieOV.DIR_13;
			}
			return direction;
		}
		/*
		 * 随机抽取颜色
		 */ 
		public static function randomPipieColor(colorTotal:uint):uint
		{
			//trace("debug randomPipieColor = " + colorTotal);
			var color:uint = pipieOV.COLOR_GREEN;
			var len:uint = colorTotal < COLOR_LIST.length?colorTotal:COLOR_LIST.length;
			color = COLOR_LIST[int(Math.random() * len)];
			return color;
		}
		/*
		 * 鼠标点击水管一次，旋转的后的方向 
		 */
		public static function changeDirByClick(oldDir:uint):uint
		{
			//trace("debug changeDirByClick");
			var newDir:uint = 0;
			switch(oldDir)
			{
				case pipieOV.DIR_12:
					newDir = pipieOV.DIR_23;
					break;
										
				case pipieOV.DIR_23:
					newDir = pipieOV.DIR_34;
					break;
								
				case pipieOV.DIR_34:
					newDir = pipieOV.DIR_41;
					break;
									
				case pipieOV.DIR_41:
					newDir = pipieOV.DIR_12;
					break;
					
				case pipieOV.DIR_13:
					newDir = pipieOV.DIR_24;
					break;
					
				case pipieOV.DIR_24:
					newDir = pipieOV.DIR_13;
					break;
			}
			
			return newDir;
		}
		/*
		 * 根据一个水管的出口（room），找和它连接对应的入口(entrance)
		 * 1 - 左
		 * 2 - 上
		 * 3 - 右
		 * 4 - 下
		 */
		public static function findEntranceByRoom(room:uint):uint
		{
			//trace("debug findEntranceByRoom");
			var entrance:uint = 0;
			switch(room)
			{
				case 1:
					entrance = 3;
					break;
				case 2:
					entrance = 4;
					break;
				case 3:
					entrance = 1;
					break;
				case 4:
					entrance = 2;
					break;
			}
			return entrance;
		}
		/*
		 * 根据方向，返回图片
		 */
		public static function genPipieBitmapData(pipie:pipieOV):BitmapData
		{
			//trace("debug genPipieBitmapData");
			var returnBitmapData:BitmapData = new BitmapData(pipieOV.DIR_COMMON_W, pipieOV.DIR_COMMON_H, true, 0);
			var rect:Rectangle = new Rectangle(0, 0, pipieOV.DIR_COMMON_W, pipieOV.DIR_COMMON_H);
			var point:Point = new Point(0, 0);
			var mc:Matrix;
			switch(pipie.direction)
			{
				case pipieOV.DIR_12:
					rect.x = pipieOV.DIR_COMMON_W;
					returnBitmapData.copyPixels(PIPIE_MID_BD, rect, point);
					break;
				case pipieOV.DIR_13:
					mc = new Matrix();
					mc.rotate(Math.PI / 2);
					mc.translate(pipieOV.DIR_COMMON_W, 0);
					returnBitmapData.draw(PIPIE_MID_BD, mc);
					break;
				case pipieOV.DIR_23:
					mc = new Matrix();
					mc.translate(-pipieOV.DIR_COMMON_W, 0);
					mc.rotate(Math.PI / 2);
					mc.translate(pipieOV.DIR_COMMON_W, 0);
					returnBitmapData.draw(PIPIE_MID_BD, mc);
					break;
				case pipieOV.DIR_24:
					returnBitmapData.copyPixels(PIPIE_MID_BD, rect, point);
					break;
				case pipieOV.DIR_34:
					mc = new Matrix();
					mc.translate(-pipieOV.DIR_COMMON_W, 0);
					mc.rotate(Math.PI);
					mc.translate(pipieOV.DIR_COMMON_W, pipieOV.DIR_COMMON_H);
					returnBitmapData.draw(PIPIE_MID_BD, mc);
					break;
				case pipieOV.DIR_41:
					mc = new Matrix();
					mc.translate(-pipieOV.DIR_COMMON_W, 0);
					mc.rotate(-Math.PI/2);
					mc.translate(0, pipieOV.DIR_COMMON_H);
					returnBitmapData.draw(PIPIE_MID_BD, mc);
					break;
				case pipieOV.DIR_TOP:
					rect.width = pipieOV.DIR_TOP_W;
					rect.x = pipie.color * pipieOV.DIR_TOP_W;
					point.x = (pipieOV.DIR_COMMON_W - pipieOV.DIR_TOP_W) / 2;
					returnBitmapData.copyPixels(PIPIE_TOP_BD, rect, point);
					break;
				case pipieOV.DIR_BOTTOM:
					rect.width = pipieOV.DIR_BOTTOM_W;
					rect.x = pipie.color * pipieOV.DIR_BOTTOM_W;
					point.x = (pipieOV.DIR_COMMON_W - pipieOV.DIR_BOTTOM_W) / 2;
					returnBitmapData.copyPixels(PIPIE_BOTTOM_BD, rect, point);
					break;
				default :
					rect.x = pipieOV.DIR_COMMON_W;
					returnBitmapData.copyPixels(PIPIE_MID_BD, rect, point);
					break;
			}
			return returnBitmapData;
		}
		
		/*
		 * 返回过关需要的颜色水管
		 */
		public static function genPipieTopBitmapData(color:uint=0):BitmapData
		{
			var returnBitmapData:BitmapData = new BitmapData(pipieOV.DIR_TOP_W, pipieOV.DIR_TOP_H, true, 0);
			var mc:Matrix = new Matrix();
			mc.rotate(-Math.PI);
			mc.translate((color +1)* pipieOV.DIR_TOP_W, pipieOV.DIR_TOP_H);
			returnBitmapData.draw(PIPIE_TOP_BD, mc);
			return returnBitmapData;
		}
	}

}