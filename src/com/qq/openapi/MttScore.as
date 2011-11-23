package com.qq.openapi
{
    import com.qq.openapi.MttService;
    import com.qq.protocol.ProtocolHelper;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.utils.ByteArray;

    /**
     *  闪游地带开放平台提供积分管理API函数。
     *
     *  <p>支持Flash游戏结束后的用户积分上传，以支持游戏积分排行榜、好友积分排行榜的运营。</p>
     *  @author Tencent
     * 
     */ 
    public class MttScore
    {
        /**
         *  提交“当前游戏”、“当前玩家”的游戏积分。
         *  <p>本次请求成功或者失败，以参数形式传入的回调函数callback都将被调用。开发者可在该函数中判断调用结果，并取得当前玩家的积分数据。</p>
         *  @param score 玩家本次游戏的总积分
         *  @param callback 提交积分的回调函数
         * 
         *  @example
         *  <p>提交积分的回调函数包含一个描述积分结果的参数result，该参数的数据成员见下面的描述。</p>
         *  <p>function callback_function(result:Object):void</p>
         *  <p>result.code  类型为int，表示调用结果返回码，0表示成功，非0表示错误。</p>
         *  <p>result.score 类型为com.qq.openapi.ScoreInfo，包含当前玩家在本游戏中的积分情况。</p>
         *  <p>class ScoreInfo</p>
         *  <p>{</p>
         *  <p>    public var nickName:String = "";    //当前用户的QQ昵称</p>
         *  <p>    public var score:Number = 0;        //当前用户的当前游戏的最高积分</p>
         *  <p>    public var playTime:Number = 0;     //提交本次积分的时间戳，单位秒</p>
         *  <p>    public var rank:uint = 0;           //当前玩家的积分排名.</p>
         *  <p>};</p>
         * 
         *  @see com.qq.openapi.ScoreInfo
         */
        public static function submit(score:uint, callback:Function):void
        {
            if (score >= 2100000000)
            {
                LoadFinish(MttService.ESYSPARAM, null, callback);
                return ;
            }

            MttService.sapi(ProtocolHelper.ScoreEncode(1, score, 0), onLoadFinish);

            function onLoadFinish(scode:int, data:ByteArray):void
            {
                LoadFinish(scode, data, callback);  
            }
        }

        /**
         *  查询“当前游戏”、“当前玩家TOP10好友”的游戏积分列表。
         *  <p>本次请求成功或者失败，以参数形式传入的回调函数callback都将被调用。开发者可在该函数中判断调用结果，并取得当前玩家的积分数据。</p> 
         *  @param callback 查询积分的回调函数
         * 
         */
        public static function query(callback:Function):void
        {
            MttService.sapi(ProtocolHelper.ScoreEncode(2, 0, 10), onLoadFinish);

            function onLoadFinish(scode:int, data:ByteArray):void
            {
                LoadFinish(scode, data, callback);  
            }
        }

        /**
         *  显示最高积分并且提交游戏积分
         *  @param score    用户本次游戏的积分
         *  @param callback 用户点击了退出游戏的Button
         *
         */
        public static function show(score:uint, ps:Object = null):void
        {
            //如果资源已经加载成功
            if (MttService.loaded)
            {
                MttService.container.scoreShowUpload(score, ps);
                return ;
            }

            create();
            mText.text = "积分提交中，请您稍候......";
            MttScore.submit(score, onBoard);

            function onBoard(result:Object):void
            {
                if (result.code != 0)
                {
                    mText.text = "本次积分：" + score;
                }
                else if (score < result.score.score)
                {
                    mText.text = "本次积分：" + score + "\n\n您的最好成绩：" + result.score.score;
                }
                else
                {
                    mText.text = "恭喜您，积分 " + score + " 是您的最好成绩！";
                }
            }
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  加载素材失败后展示页面  
        private static function create():void
        {
            if (mLocal != null) return ;
            mLocal  = new Sprite();
            MttService.container.addChild(mLocal);

            var cover:Sprite    = createCover();
            mLocal.addChild(cover);

            mText               = createTextField("BETEXT", 100, 100, 200, 150, TextFormatAlign.LEFT);
            mText.wordWrap      = true;
            mLocal.addChild(mText);

            var again:TextField = createTextField("BAGAIN", 100, 300, 100,  25, TextFormatAlign.LEFT);
            again.text = "再玩一次";
            again.addEventListener(MouseEvent.CLICK, onMouseEvent);
            mLocal.addChild(again);

            var eback:TextField = createTextField("BEBACK", 240, 300, 100,  25, TextFormatAlign.LEFT);
            eback.text = "返    回";
            eback.addEventListener(MouseEvent.CLICK, onMouseEvent);
            mLocal.addChild(eback);
        }

        private static function onMouseEvent(e:MouseEvent):void
        {
            switch (e.currentTarget.name)
            {
                case "BAGAIN":  mLocal.visible = false; MttService.dispatchEvent(new Event(MttService.ETAGAIN));    break;
                case "BEBACK":  MttService.jump(2, false);                                                          break;
            }
        }

        private static function createCover():Sprite
        {
            var cover:Sprite = new Sprite();
            cover.graphics.beginFill(0x000000);
            cover.graphics.drawRoundRect(0, 0, 600, 600, 10);
            cover.graphics.endFill();
            cover.alpha = 0.5;

            return cover;
        }

        private static function createTextField(N:String, X:uint, Y:uint, W:uint, H:uint, A:String):TextField
        {
            var value:TextField     = new TextField();
            value.name              = N;
            value.x                 = X;
            value.y                 = Y;
            value.width             = W;
            value.height            = H;
            value.selectable        = false;
            value.defaultTextFormat = new TextFormat("Verdana", 14, 0xFFFFFF, null, null, null, null, null, A);

            return value;
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  上传积分的响应函数
        private static function LoadFinish(scode:int, data:ByteArray, callback:Function):void
        {
            if (scode != 0)
            {
                callback && callback.call(null, {code:scode, desc:""});
                return ;
            }

            callback && callback.call(null, ProtocolHelper.ScoreDecode(data));
        }

        ///////////////////////////////////////////////////////////////////////////////////////////
        //  内部使用变量数据
        private static var mLocal:Sprite    = null;
        private static var mText :TextField = null;
    }
}
