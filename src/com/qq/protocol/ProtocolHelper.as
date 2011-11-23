package com.qq.protocol
{
    import com.qq.openapi.MttService;
    import com.qq.openapi.PropItem;
    import com.qq.openapi.ListItem;
    import com.qq.protocol.DataHead;
    import com.qq.protocol.DataHelp;
    import com.qq.utils.UtilTool;
    import flash.utils.ByteArray;


    public class ProtocolHelper
    {
        ///////////////////////////////////////////////////////////////////////////////////////////
        //  积分接口编解码
        public static function ScoreEncode(op:int, sc:uint, tp:uint):ByteArray
        {
            var szEncode:ByteArray = new ByteArray();

            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
            DataHelp.writeUInt32(szEncode, op, 0);
            DataHelp.writeUInt32(szEncode, sc, 1);
            DataHelp.writeUInt32(szEncode, tp, 2);
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);

            return EncodeRequest("s", szEncode);
        }

        public static function ScoreDecode(s:ByteArray):Object
        {
            try
            {
                var ret:Object = DecodeRequest(s);
                if (ret.fcode == 0)
                {
                    var rsp:ScoreRsp = ScoreRsp.readStruct(ret.res, 0, true) as ScoreRsp; 
                    return {code:0, score:rsp.selfScore, board:rsp.vRankScore};
                }

                return {code:ret.fcode};
            }
            catch (e:Error) { }

            return {code:MttService.EPDECODE};
        }

        //////////////////////////////////////////////////////////////////////////////////////
        //  KEY-VALUE的设置函数
        public static function SetGameDataEncode(key:String, value:ByteArray):ByteArray
        {
            var szEncode:ByteArray = new ByteArray();

            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
            DataHelp.writeString(szEncode, key, 0);
            DataHelp.writeVectorByte(szEncode, value, 1);
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);

            return EncodeRequest("sgd", szEncode);
        }

        public static function SetGameDataDecode(s:ByteArray):Object
        {
            try
            {
                var ret:Object = DecodeRequest(s);
                if (ret.fcode == 0)
                {
                    var rsp:Object = PutGameDataRsp.readStruct(ret.res, 0, true) as PutGameDataRsp;

                    return {code:rsp.ret};
                }

                return {code:ret.fcode};
            }
            catch (e:Error) { }

            return {code: MttService.EPDECODE};        
        }

        //////////////////////////////////////////////////////////////////////////////////////
        //  KEY-VALUE的读取函数
        public static function GetGameDataEncode(key:String):ByteArray
        {
            var szEncode:ByteArray = new ByteArray();

            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
            DataHelp.writeString(szEncode, key, 0);
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);

            return EncodeRequest("ggd", szEncode);
        }

        public static function GetGameDataDecode(s:ByteArray):Object
        {
            try
            {
                var ret:Object = DecodeRequest(s);
                if (ret.fcode == 0)
                {
                    var rsp:Object = GetGameDataRsp.readStruct(ret.res, 0, true) as GetGameDataRsp; 

                    return {code:0, value:rsp.data};
                }

                return {code:ret.fcode==-6?MttService.ENOENT:ret.fcode};
            }
            catch (e:Error){ }

            return {code: MttService.EPDECODE};              
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  URL跳转请求封包
        public static function UrlJumpEncode(url:uint, window:Boolean):ByteArray
        {
            var szEncode:ByteArray = new ByteArray();

            DataHelp.writeUInt32(szEncode, url, 0);
            DataHelp.writeBoolean(szEncode, window, 1);

            return szEncode;
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  查询用户金币剩余
        public static function MallCoinsEncode():ByteArray
        {
            var szEncode:ByteArray = new ByteArray();
            
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
            DataHelp.writeUInt32(szEncode, 0, 0);
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);

            return EncodeRequest("gyb", szEncode);
        }

        public static function MallCoinsDecode(s:ByteArray):Object
        {
            try
            {
                var ret:Object = DecodeRequest(s);
                if (ret.fcode == 0)
                {
                    var rsp:MallCoinsRsp = MallCoinsRsp.readStruct(ret.res, 0, true) as MallCoinsRsp; 

                    return {code:0, balance:rsp.balance, status:rsp.status, regTime:rsp.regTime}; 
                }

                return {code:ret.fcode};
            }
            catch (e:Error){ }

            return {code: MttService.EPDECODE};          
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  商城道具列表
        public static function MallStoreEncode():ByteArray
        {
            var szEncode:ByteArray = new ByteArray();

            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
            DataHelp.writeUInt32(szEncode, 0, 0);
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);

            return EncodeRequest("ggp", szEncode);
        }

        public static function MallStoreDecode(s:ByteArray):Object
        {
            try
            {
                var ret:Object = DecodeRequest(s);
                if (ret.fcode == 0)
                {
                    var rsp:MallStoreRsp = MallStoreRsp.readStruct(ret.res, 0, true) as MallStoreRsp; 

                    return {code:0, items:rsp.items}; 
                }

                return {code:ret.fcode};
            }
            catch (e:Error){ }

            return {code: MttService.EPDECODE};            
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  个人道具列表
        public static function MallListEncode():ByteArray
        {
            var szEncode:ByteArray = new ByteArray();

            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
            DataHelp.writeUInt32(szEncode, 0, 0);
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);

            return EncodeRequest("lgp", szEncode);
        }

        public static function MallListDecode(s:ByteArray):Object
        {
            try
            {
                var ret:Object = DecodeRequest(s);
                if (ret.fcode == 0)
                {
                    var rsp:MallListRsp = MallListRsp.readStruct(ret.res, 0, true) as MallListRsp; 

                    return {code:0, items:rsp.items};
                }

                return {code:ret.fcode};
            }
            catch (e:Error){ }

            return {code: MttService.EPDECODE};        
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  赠送道具打包
        public static function MallPresentEncode(propId:uint, num:uint, desc:String):ByteArray
        {
            var szEncode:ByteArray = new ByteArray();

            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
            DataHelp.writeUInt32(szEncode, propId, 0);
            DataHelp.writeUInt32(szEncode, num, 1);
            DataHelp.writeString(szEncode, desc, 2);
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);

            return EncodeRequest("pgp", szEncode);
        }

        public static function MallPresentDecode(s:ByteArray):Object
        {
            try
            {
                var ret:Object = DecodeRequest(s);
                return {code:ret.fcode};
            }
            catch (e:Error){ }

            return {code: MttService.EPDECODE};    
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  购买道具打包
        public static function MallPurchaseEncode(propId:uint, num:uint):ByteArray
        {
            var szEncode:ByteArray = new ByteArray();
            
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
            DataHelp.writeUInt32(szEncode, propId, 0);
            DataHelp.writeUInt32(szEncode, num, 1);
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);

            return EncodeRequest("ppp", szEncode);
        }

        public static function MallPurchaseDecode(s:ByteArray):Object
        {
            try
            {
                var ret:Object = DecodeRequest(s);
                return {code:ret.code};
            }
            catch (e:Error){ }

            return {code: MttService.EPDECODE};
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  使用道具的打包
        public static function MallConsumeEncode(propId:uint, num:uint):ByteArray
        {
            var szEncode:ByteArray = new ByteArray();

            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
            DataHelp.writeUInt32(szEncode, propId, 0);
            DataHelp.writeUInt32(szEncode, num, 1);
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);

            return EncodeRequest("cgp", szEncode);
        }

        public static function MallConsumeDecode(s:ByteArray):Object
        {
            try
            {
                var ret:Object = DecodeRequest(s);
                return {code:ret.code};
            }
            catch (e:Error){ }

            return {code: MttService.EPDECODE};
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  最终协议的打包
        private static function EncodeRequest(sFuncName:String, sBuffer:ByteArray):ByteArray
        {
            var szEncode:ByteArray = new ByteArray(); 
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTBEGIN);
            DataHelp.writeUInt32(szEncode, MttService.nversion, 0);
            DataHelp.writeUInt32(szEncode, ++mRequestID, 1);
            DataHelp.writeString(szEncode, sFuncName, 2);
            DataHelp.writeVectorByte(szEncode, sBuffer, 3);
            DataHead.writeTo(szEncode, 0, DataHead.EM_STRUCTEND);
            return szEncode;
        }

        private static function DecodeRequest(ist:ByteArray):Object //返回框架的错误
        {
            try
            {
                var pack:ApiResponse = ApiResponse.readStruct(ist, 0, false);

                return {fcode:pack.code, code:pack.code, res:pack.data};
            }
            catch (e:Error) { }

            return {fcode: MttService.EPDECODE, code:MttService.EPDECODE};
        }

        private static var mRequestID:uint = 100;
    }
}

import com.qq.openapi.ListItem;
import com.qq.openapi.PropItem;
import com.qq.openapi.ScoreInfo;
import com.qq.protocol.DataHead;
import com.qq.protocol.DataHelp;

import flash.utils.ByteArray;

///////////////////////////////////////////////////////////////////////////////////////////////////
//  OPENAPISERVER的包裹类
class ApiResponse
{
    public var code:int     = 0;
    public var reqid:uint       = 0;
    public var data:ByteArray   = new ByteArray();

    public static function readFrom(ist:ByteArray):ApiResponse
    {
        var value:ApiResponse   = new ApiResponse();
        value.code              = DataHelp.readInt32(ist, 0, false);
        value.reqid             = DataHelp.readUInt32(ist, 1, false);
        value.data              = DataHelp.readVectorByte(ist, 2, false);

        return value;
    }

    public static function readStruct(ist:ByteArray, tag:int, require:Boolean):ApiResponse
    {
        return DataHelp.readStruct(ist, tag, require, readFrom) as ApiResponse;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//  读取积分查询的返回结构体
class ScoreRsp
{
    public var vRankScore   : Array     = new Array();
    public var selfScore    : ScoreInfo = new ScoreInfo();
    
    public static function readFrom(ist:ByteArray):ScoreRsp
    {
        var value:ScoreRsp  = new ScoreRsp();
        value.vRankScore    = DataHelp.readVectorObject(ist, 0, false, ScoreInfoReadStruct);
        value.selfScore     = ScoreInfoReadStruct(ist, 1, false);
        return value;
    }

    public static function readStruct(ist:ByteArray, tag:int, require:Boolean):ScoreRsp
    {
        return DataHelp.readStruct(ist, tag, require, readFrom) as ScoreRsp;
    }

    private static function ScoreInfoReadFrom(ist:ByteArray):ScoreInfo
    {
        var value:ScoreInfo = new ScoreInfo();
        value.nickName=DataHelp.readString(ist, 0, false);
        value.score=DataHelp.readInt64(ist, 1, false);
        value.playTime=DataHelp.readInt64(ist, 2, false);
        value.rank = DataHelp.readUInt32(ist, 3, false);
        return value;
    }

    private static function ScoreInfoReadStruct(ist:ByteArray, tag:int, require:Boolean):ScoreInfo
    {
        return DataHelp.readStruct(ist, tag, require, ScoreInfoReadFrom) as ScoreInfo;
    } 
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//  设置KEY-VALUE的返回结构体
class PutGameDataRsp
{
    public var ret:int = 0;

    public static function readFrom(ist:ByteArray):PutGameDataRsp
    {
        var value:PutGameDataRsp    = new PutGameDataRsp();
        value.ret                   = DataHelp.readInt32(ist, 0, false);

        return value;
    }

    public static function readStruct(ist:ByteArray, tag:int, require:Boolean):PutGameDataRsp
    {
        return DataHelp.readStruct(ist, tag, require, readFrom) as PutGameDataRsp;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//  读取KEY-VALUE的返回结构体
class GetGameDataRsp
{
    public var data:ByteArray = new ByteArray();

    public static function readFrom(ist:ByteArray):GetGameDataRsp
    {
        var value:GetGameDataRsp    = new GetGameDataRsp();
        value.data                  = DataHelp.readVectorByte(ist, 0, true);

        return value;
    }

    public static function readStruct(ist:ByteArray, tag:int, require:Boolean):GetGameDataRsp
    {
        return DataHelp.readStruct(ist, tag, require, readFrom) as GetGameDataRsp;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//  读取获取金币返回数据
class MallCoinsRsp
{
    public var balance:uint = 0;    //帐户余额
    public var status:uint = 0;     //帐户状态：0：正常；1：冻结；	
    public var regTime:uint = 0;    //开户时间

    public static function readFrom(ist:ByteArray):MallCoinsRsp
    {
        var value:MallCoinsRsp  = new MallCoinsRsp();
        value.balance   = DataHelp.readUInt32(ist, 1, true);
        value.status    = DataHelp.readUInt32(ist, 2, true);
        value.regTime   = DataHelp.readUInt32(ist, 3, true);

        return value;
    }

    public static function readStruct(ist:ByteArray, tag:int, require:Boolean):MallCoinsRsp
    {
        return DataHelp.readStruct(ist, tag, require, readFrom) as MallCoinsRsp;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//  读取商店道具列表返回数据
class MallStoreRsp
{
    public var code:int = 0;
    public var items:Array = new Array();

    public static function readFrom(ist:ByteArray):MallStoreRsp
    {
        var value:MallStoreRsp  = new MallStoreRsp();
        value.code  = DataHelp.readInt32(ist, 0, true);
        value.items = DataHelp.readVectorObject(ist, 1, true, PropItemReadStruct);

        return value;
    }

    public static function readStruct(ist:ByteArray, tag:int, require:Boolean):MallStoreRsp
    {
        return DataHelp.readStruct(ist, tag, require, readFrom) as MallStoreRsp;
    }

    private static function PropItemReadFrom(ist:ByteArray):PropItem
    {
        var value:PropItem = new PropItem();
 
        value.id        = DataHelp.readUInt32(ist, 0, false);
        value.name      = DataHelp.readString(ist, 1, false);
        value.desc      = DataHelp.readString(ist, 2, false);
        value.level     = DataHelp.readUInt32(ist, 3, false);
        value.type      = DataHelp.readUInt32(ist, 4, false);
        value.price     = DataHelp.readUInt32(ist, 5, false);
        value.url       = DataHelp.readString(ist, 6, false);
        value.limit     = DataHelp.readUInt32(ist, 7, false);
        value.gift      = DataHelp.readBoolean(ist, 8, false, false);
        value.consum    = DataHelp.readBoolean(ist, 9, false, true);
        value.atris     = DataHelp.readMap(ist, 10, false, DataHelp.readString, DataHelp.readString);   

        return value;
    }

    private static function PropItemReadStruct(ist:ByteArray, tag:int, require:Boolean):PropItem
    {
        return DataHelp.readStruct(ist, tag, require, PropItemReadFrom) as PropItem;
    } 
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//  道具列表返回数据
class MallListRsp
{
    public var code:int = 0;
    public var items:Array = new Array();

    public static function readFrom(ist:ByteArray):MallListRsp
    {
        var value:MallListRsp  = new MallListRsp();
        value.code  = DataHelp.readInt32(ist, 0, true);
        value.items = DataHelp.readVectorObject(ist, 1, true, ListItemReadStruct);
        
        return value;
    }

    public static function readStruct(ist:ByteArray, tag:int, require:Boolean):MallListRsp
    {
        return DataHelp.readStruct(ist, tag, require, readFrom) as MallListRsp;
    }

    private static function ListItemReadFrom(ist:ByteArray):ListItem
    {
        var value:ListItem = new ListItem();
        value.id        = DataHelp.readUInt32(ist, 0, false);
        value.name      = DataHelp.readString(ist, 1, false);
        value.remain    = DataHelp.readUInt32(ist, 2, false);
        value.total     = DataHelp.readUInt32(ist, 3, false);
        value.url       = DataHelp.readString(ist, 4, false);

        return value;
    }

    private static function ListItemReadStruct(ist:ByteArray, tag:int, require:Boolean):ListItem
    {
        return DataHelp.readStruct(ist, tag, require, ListItemReadFrom) as ListItem;
    }
};
