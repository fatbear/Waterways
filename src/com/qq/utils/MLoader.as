package com.qq.utils
{
    import com.qq.utils.MEvent;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.system.SecurityDomain;
    import flash.utils.Timer;
    import flash.utils.getTimer;


    public class MLoader extends EventDispatcher
    {
        public static const COMPLETE    :String = Event.COMPLETE;
        public static const ERROR       :String = IOErrorEvent.IO_ERROR;
        public static const TIMEOUT     :String = "TIMEOUT";

        private var mDomain     :LoaderContext  = new LoaderContext();
        private var mLoader     :Loader         = new Loader();
        private var mTimeout    :uint           = 60*1000;                  //请求超时时间，单位为毫秒
        private var mTimer      :Timer          = null;

        public function MLoader()
        {
            mDomain.applicationDomain   = ApplicationDomain.currentDomain;
            mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,          _onLoad);
            mLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,   _onLoadError);
            mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,  _onLoadProcess);

            mTimer = new Timer(mTimeout);
        }

        public function load(sURL:String):void
        {
            mLoader.load(new URLRequest(sURL), mDomain);

            mTimer.addEventListener(TimerEvent.TIMER,   onTimeout);
            mTimer.delay = mTimeout;
            mTimer.start();
        }

        /**
         *  获取资源的类
         *  
         *  @param str  资源类名称
         *  @return     类
         * 
         */
        public static function getClass(str:String):Class
        {
            if (ApplicationDomain.currentDomain.hasDefinition(str))
            {
                return ApplicationDomain.currentDomain.getDefinition(str) as Class;
            }

            return null;
        }

        public static function getClassInstance(str:String):Object
        {
            var cls:Class = getClass(str);
            
            return !cls?null:new cls();
        }

        private function _onLoad(e:Event):void
        {
            removeEventListeners();

            dispatchEvent(new MEvent(COMPLETE));
        }

        private function _onLoadError(e:Event):void
        {
            removeEventListeners();

            dispatchEvent(new MEvent(ERROR, {type:e.type}));
        }

        private function _onLoadProcess(e:ProgressEvent):void
        {
            mTimer.reset();
            mTimer.delay = mTimeout;
            mTimer.start();

            dispatchEvent(e);
        }

        private function onTimeout(e:TimerEvent):void
        {
            removeEventListeners();

            dispatchEvent(new MEvent(ERROR, {type:TIMEOUT}));
        }

        private function removeEventListeners():void
        {
            mLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,           _onLoad);
            mLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,    _onLoadError);
            mLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,   _onLoadProcess);

            mTimer.reset();  
            mTimer.removeEventListener(TimerEvent.TIMER, onTimeout);
            mLoader.unload();
        }
    }
}
