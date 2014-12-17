package com.xhj.www
{
	import com.xhj.www.component.AbstractScene;
	import com.xhj.www.consts.SceneType;
	import com.xhj.www.scene.GameScene;
	import com.xhj.www.scene.MainScene;

	public class SceneManager
	{
		private static var s_currentScene:AbstractScene;
		
		public function SceneManager()
		{
		}
		
		public static function changeScene(sceneType:uint):void
		{
			if (s_currentScene)
			{
				if (s_currentScene.getSceneType() == sceneType)
				{
					return;
				}
				s_currentScene.exit();
				App.stage.removeChild(s_currentScene);
			}
			s_currentScene = createScene(sceneType);
			App.stage.addChild(s_currentScene);
		}
		
		public static function createScene(sceneType:uint):AbstractScene
		{
			var result:AbstractScene;
			switch (sceneType)
			{
				case SceneType.MAIN:
					result = new MainScene();
					break;
				case SceneType.GAME:
					result = new GameScene();
					break;
			}
			return result;
		}
		
		public static function getCurrentScene():AbstractScene
		{
			return s_currentScene;
		}
	}
}