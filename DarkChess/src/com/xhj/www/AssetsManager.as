package com.xhj.www
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class AssetsManager
	{
		public function AssetsManager()
		{
		}
		
		public static function init(callback:Function):void
		{
			
			var aryRequest:Array = [];
			aryRequest.push(new URLRequest("../assets/tile.swf"), new URLRequest("../assets/sprite.swf"));
			
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			
			loadNext();
			
			function loadNext():void
			{
				loader.load(aryRequest[0], context);
			}
			
			function onComplete(e:Event):void
			{
				trace("load" + e.target.content.toString() + "success");
				aryRequest.shift();
				if (aryRequest.length > 0)
				{
					loadNext();
				}
				else
				{
					if (null != callback)
					{
						callback();
					}
				}
			}
		}
		
		
	}
}