package com.qq.openapi
{
    /**
     *  游戏玩家元素类。
     *
     *  @author Tencent
     */
    public class ListItem
    {
        /**
         *  道具编号 
         */     
        public var id:uint      = 0;

        /**
         *  道具名称
         */     
        public var name:String  = "";

        /**
         *  剩余数量 
         */        
        public var remain:uint  = 0;

        /**
         *  道具总数 
         */        
        public var total:uint   = 0;

        /**
         *  资源地址 
         */        
        public var url:String   = "";
    }
}
