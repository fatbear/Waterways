package com.qq.utils
{
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.utils.ByteArray;

    public class UtilTool
    {
        public static function goto(url:String, newWin:Boolean):void
        {
            navigateToURL(new URLRequest(url), "_top");
        }

        //将字符串转换为十六进制表示方法
        public static function printHEX(ost:ByteArray):void
        {
            var str:String = ""; 
            for (var i:int = 0; i < ost.length; i++)
            {
                if (ost[i] < 16)
                {
                    str += "0" + ost[i].toString(16) + ((i + 1)%16 == 0?"":" ");
                }
                else
                {
                    str += ost[i].toString(16) + ((i + 1)%16 == 0?"":" ");
                }
                
                if ((i + 1)%16 == 0)
                {
                    trace(str);
                    str = "";
                }
            }
            
            trace(str);
        }
    }
}
