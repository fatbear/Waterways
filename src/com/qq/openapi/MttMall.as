package com.qq.openapi
{
    import com.qq.openapi.MttService;
    import com.qq.protocol.ProtocolHelper;
    import flash.utils.ByteArray;

    /**
     *  闪游地带开发平台易贝、商城物品管理包裹类。
     *
     *  <p>支持游戏查询用户易贝余额、获取商品列表、获取玩家道具列表、商品购买、道具赠送、道具使用等。</p>
     *
     *  @author Tencent
     */
    public class MttMall
    {
        /**
         *  查询用户易贝余额
         * 
         *  @param onFinish 回调函数
         */
        public static function coins(callback:Function):void
        {
            MttService.sapi(ProtocolHelper.MallCoinsEncode(), onLoadFinish);

            function onLoadFinish(scode:int, data:ByteArray):void
            {
                CoinsLoadFinish(scode, data, callback);
            }
        }

        /**
         *  获取本游戏的商场道具列表
         *  
         *  @param onFinish 回调函数
         */
        public static function store(callback:Function):void
        {
            MttService.sapi(ProtocolHelper.MallStoreEncode(), onLoadFinish);

            function onLoadFinish(scode:int, data:ByteArray):void
            {
                StoreLoadFinish(scode, data, callback);
            }
        }

        /**
         *  获取当前玩家本游戏的道具列表
         * 
         *  @param onFinish 回调函数
         */
        public static function list(callback:Function):void
        {
            MttService.sapi(ProtocolHelper.MallListEncode(), onLoadFinish);

            function onLoadFinish(scode:int, data:ByteArray):void
            {
                ListLoadFinish(scode, data, callback);
            }
        }

        /**
         *  购买道具指令
         * 
         *  @param PropID   本游戏中道具的编号
         *  @param Num      本次购买道具的数量
         *  @param onFinish 回调函数
         */
        public static function purchase(propId:uint, num:uint, callback:Function):void
        {
            MttService.sapi(ProtocolHelper.MallPurchaseEncode(propId, num), onLoadFinish);

            function onLoadFinish(scode:int, data:ByteArray):void
            {
                PurchaseLoadFinish(scode, data, callback);
            }
        }

        /**
         *  赠送道具
         *  
         *  @param PropID   本游戏中道具的编号
         *  @param Num      本次赠送道具的数量
         *  @param onFinish 回调函数
         */
        public static function present(propId:uint, num:uint, desc:String, callback:Function):void
        {
            MttService.sapi(ProtocolHelper.MallPresentEncode(propId, num, desc), onLoadFinish);

            function onLoadFinish(scode:int, data:ByteArray):void
            {
                PresentLoadFinish(scode, data, callback);
            }
        }

        /**
         *  使用道具
         * 
         *  @param PropID   本游戏中道具的编号
         *  @param Num      本次消耗道具的数量
         *  @param onFinish 回调函数
         */
        public static function consume(propId:uint, num:uint, callback:Function):void
        {
            MttService.sapi(ProtocolHelper.MallConsumeEncode(propId, num), onLoadFinish);

            function onLoadFinish(scode:int, data:ByteArray):void
            {
                ConsumeLoadFinish(scode, data, callback);
            }
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  解码查询金币的返回
        private static function CoinsLoadFinish(scode:int, data:ByteArray, callback:Function):void
        {
            if (scode != 0)
            {
                callback && callback.call(null, {code:scode});
                return ;
            }

            callback && callback.call(null, ProtocolHelper.MallCoinsDecode(data));
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  解码获取商城道具列表
        private static function StoreLoadFinish(scode:int, data:ByteArray, callback:Function):void
        {
            if (scode != 0)
            {
                callback && callback.call(null, {code:scode, desc:""});
                return ;
            }

            callback && callback.call(null, ProtocolHelper.MallStoreDecode(data));
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  解码获取列表
        private static function ListLoadFinish(scode:int, data:ByteArray, callback:Function):void
        {
            if (scode != 0)
            {
                callback && callback.call(null, {code:scode, desc:""});
                return ;
            }

            callback && callback.call(null, ProtocolHelper.MallListDecode(data));
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  解码购买道具
        private static function PurchaseLoadFinish(scode:int, data:ByteArray, callback:Function):void
        {
            if (scode != 0)
            {
                callback && callback.call(null, {code:scode, desc:""});
                return ;
            }

            callback && callback.call(null, ProtocolHelper.MallPurchaseDecode(data));
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  解码赠送道具
        private static function PresentLoadFinish(scode:int, data:ByteArray, callback:Function):void
        {
            if (scode != 0)
            {
                callback && callback.call(null, {code:scode, desc:""});
                return ;
            }

            callback && callback.call(null, ProtocolHelper.MallPresentDecode(data));
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  解码消费道具
        private static function ConsumeLoadFinish(scode:int, data:ByteArray, callback:Function):void
        {
            if (scode != 0)
            {
                callback && callback.call(null, {code:scode, desc:""});
                return ;
            }

            callback && callback.call(null, ProtocolHelper.MallConsumeDecode(data));
        }
    }
}
