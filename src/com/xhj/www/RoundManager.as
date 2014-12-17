package com.xhj.www
{
	import com.xhj.www.component.AbstractCommand;
	import com.xhj.www.scene.GameScene;

	public class RoundManager
	{
		private static var s_currentRound:int;
		
		public function RoundManager()
		{
		}
		
		public static function nextRound():void
		{
			(SceneManager.getCurrentScene() as GameScene).endRound();
			s_currentRound = s_currentRound % 3 + 1;
			startRound();
		}
		
		private static function startRound():void
		{
//			if (s_currentRound == App.myNation)
//			{
//				(SceneManager.getCurrentScene() as GameScene).startRound();
//			}
//			else
//			{
//				nextRound();
//			}
			//test
			(SceneManager.getCurrentScene() as GameScene).startRound();
		}
		
		public static function getCurrentRound():int
		{
			return s_currentRound;
		}
		
	}
}