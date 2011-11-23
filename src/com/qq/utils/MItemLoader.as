package com.qq.utils
{
    import com.qq.openapi.MttService;
    import com.qq.utils.MLoader;
    import flash.display.Sprite;
    import flash.events.Event;

    public class MItemLoader extends Sprite
    {
        public function MItemLoader(url:String, cname:String)
        {
            Request(url, cname);
        }

        private function Request(url:String, cname:String):void
        {
            mName = cname;

            if (mPic) { removeChild(mPic); mPic = null; }
            var c:Class = MLoader.getClass(cname);
            if (c != null)
            {
                mPic = new c() as Sprite;
                mName = "";

                if (mPic)  addChild(mPic);
                return ;
            }

            if (GLOADERS[url] == null)
            {
                GLOADERS[url] = new ItemLoader();
            }

            var item:ItemLoader = GLOADERS[url] as ItemLoader;
            if (item.loaded == true)
            {
                return ;
            }

            item.addEventListener(ItemLoader.EVENT_LOADED, onLoaded);
            item.load(MttService.urlResourse + url);
        }

        private function onLoaded(e:Event):void
        {
            e.currentTarget.removeEventListener(ItemLoader.EVENT_LOADED, arguments.callee);
            var c:Class = MLoader.getClass(mName);
            if (mPic || mName.length < 5 || c == null) return ;

            mPic = new c() as Sprite;
            if (mPic) addChild(mPic);
        }

        private static var GLOADERS:Object = {}; //ItemLoader的Map
        private var mPic    : Sprite = null;
        private var mName   : String = "";
    }
}

import com.qq.utils.MLoader;
import flash.events.Event;
import flash.events.EventDispatcher;

class ItemLoader extends EventDispatcher
{
    public static var EVENT_LOADED:String = "LDD"; //加载成功的事件
    
    public function get loaded():Boolean { return mLoaded == 2; }
    
    public function load(url:String):void
    {
        if (mLoaded == 2)
        {
            dispatchEvent(new Event(EVENT_LOADED));
            return ;
        }

        if (mLoaded == 1)
        {
            return ;
        }

        mLoaded = 1;
        if (mLoader == null)
        {
            mLoader = new MLoader();
            mLoader.addEventListener(MLoader.COMPLETE,		onLoad);
            mLoader.addEventListener(MLoader.ERROR, 		onLoad);
        }
        mLoader.load(url);
    }

    private function onLoad(e:Event):void
    {
        removeListeners();
        mLoaded = 2;
        
        dispatchEvent(new Event(EVENT_LOADED));
    }
    
    private function removeListeners():void
    {
        mLoader.removeEventListener(MLoader.COMPLETE,   onLoad);
        mLoader.removeEventListener(MLoader.ERROR,      onLoad);
        mLoader = null;
    }
    
    private var mLoaded :int        = 0;        //是否已经成功下载  0：初始化，1：下载中，2：下载成功
    private var mLoader :MLoader    = null;    //本URL的下载器
}


/*



package com.qq.utils
{
    import com.qq.openapi.MttService;
    import com.qq.utils.MLoader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.system.SecurityDomain;

    
    
    
    
    

    public class MItemLoader extends Sprite
	{
		private var mLoader : Loader        = new Loader();
        private var mDomain : LoaderContext = new LoaderContext(true);
        private var mPic    : Sprite        = null;

		public function MItemLoader(url:String, cname:String)
		{
            mDomain.applicationDomain = ApplicationDomain.currentDomain;

            Request(url, cname);
		}

		public function Request(url:String, cname:String):void
		{
            mPic = null;

			if (MLoader.getClass(cname))
			{
                mPic = MLoader.getClassInstance(cname) as Sprite;
				if (mPic)
				{
					addChild(mPic);
				}
			}
			else
			{
                mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e : Event):void
				{
					e.currentTarget.removeEventListener(Event.COMPLETE, arguments.callee);
					
					if (MLoader.getClass(cname))
					{
                        mPic = MLoader.getClassInstance(cname) as Sprite;
						if (mPic)
						{
							addChild(mPic);
						}
					}
				});
				mLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);

                mLoader.load(new URLRequest(MttService.urlResourse + url), mDomain);
			}
		}

		public function onError(e:Event):void
		{

		}
	}

}
*/