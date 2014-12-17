package com.xhj.www
{
	public class GameManager
	{
		public function GameManager()
		{
		}
		
		public static function getCurrentNation():int
		{
			return RoundManager.getCurrentRound();
		}
	}
}