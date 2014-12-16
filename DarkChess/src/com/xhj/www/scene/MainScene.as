package com.xhj.www.scene
{
	import com.xhj.www.component.AbstractScene;
	import com.xhj.www.consts.SceneType;
	
	public class MainScene extends AbstractScene
	{
		public function MainScene()
		{
			_sceneType = SceneType.MAIN;
			super();
		}
		
		override public function exit():void
		{
			
		}
	}
}