package com.xhj.www.component
{
	import com.xhj.www.utils.HashMap;
	
	
	public class AbstractScene extends GameObjectBase
	{
		protected var _sceneType:uint;
		
		public function AbstractScene()
		{
			super();
			init();
		}
		
		protected function init():void
		{
			
		}
		
		public function exit():void
		{
			
		}
		
		public function getSceneType():uint
		{
			return _sceneType;
		}
		
	}
}