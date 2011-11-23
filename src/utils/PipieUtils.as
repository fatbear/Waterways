package utils 
{
	import assets.Assets;
	import datamodels.pipieOV;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Tom.Lu
	 */
	public class PipieUtils 
	{
		/*
		 * 鼠标点击水管一次，旋转的后的方向 
		 */
		public static function changeDirByClick(oldDir:uint):uint
		{
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
		public static function genPipieBitmapData(dir:uint):BitmapData
		{
			var returnBitmapData:BitmapData;
			switch(dir)
			{
				case pipieOV.DIR_12:
					returnBitmapData = Bitmap(new Assets.PIPIE_1_2()).bitmapData;
					break;
				case pipieOV.DIR_13:
					returnBitmapData = Bitmap(new Assets.PIPIE_1_3()).bitmapData;
					break;
				case pipieOV.DIR_23:
					returnBitmapData = Bitmap(new Assets.PIPIE_2_3()).bitmapData;
					break;
				case pipieOV.DIR_24:
					returnBitmapData = Bitmap(new Assets.PIPIE_2_4()).bitmapData;
					break;
				case pipieOV.DIR_34:
					returnBitmapData = Bitmap(new Assets.PIPIE_3_4()).bitmapData;
					break;
				case pipieOV.DIR_41:
					returnBitmapData = Bitmap(new Assets.PIPIE_4_1()).bitmapData;
					break;
				case pipieOV.DIR_TOP:
					returnBitmapData = Bitmap(new Assets.PIPIE_TOP()).bitmapData;
					break;
				case pipieOV.DIR_BOTTOM:
					returnBitmapData = Bitmap(new Assets.PIPIE_BOTTOM()).bitmapData;
					break;
				default :
					returnBitmapData = Bitmap(new Assets.PIPIE_1_2()).bitmapData;
					break;
			}
			return returnBitmapData;
		}
	}

}