package com.qq.openapi
{
    /**
     *  商城商品元素类。
     *
     *  @author Tencent
     */
    public class PropItem
    {
        /**
         *  道具编号 
         */     
        public var id:uint          = 0;

        /**
         *  道具名称
         */     
        public var name:String      = "";

        /**
         *  道具描述
         */     
        public var desc:String      = "";

        /**
         *  道具等级 
         */     
        public var level:uint       = 0;

        /**
         *  道具类型 
         */     
        public var type:uint        = 0;

        /**
         *  道具价格
         */     
        public var price:uint       = 0;

        /**
         *  数量上限 
         */     
        public var limit:uint       = 0;

        /**
         *  资源地址 
         */     
        public var url:String       = "";

        /**
         *  是否赠品。<strong>赠品不可购买只能被系统赠送</strong>
         */     
        public var gift:Boolean = false;

        /**
         *  是否消耗品
         */     
        public var consum:Boolean   = false;

        /**
         *  附加属性。每个元素为一个键值对。 
         */
        public var atris:Array      = new Array();
    }
}
