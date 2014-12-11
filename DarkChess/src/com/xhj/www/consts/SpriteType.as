package com.xhj.www.consts
{
	public class SpriteType
	{
		/**农民 攻击距离直向1*/
		public static const FARMER:int = 1;
		
		/**士兵 攻击距离直向2*/
		public static const SOLDIER:int = 2;
		
		/**军师 攻击距离周围1*1*/
		public static const WISEMAN:int = 3;
		
		/**君主 攻击距离直向3*/
		public static const KING:int = 4;
		
		/**骑兵 攻击距离直向2 周围1*1*/
		public static const KNIGHT:int = 5;
		
		/**大将 攻击距离直向3 周围2*2*/
		public static const HERO:int = 6;
		
		/**炮 隔一个单位打直向任意距离*/
		public static const CANNON:int = 7;
		
		/**车 直向 距离无限*/
		public static const ROOK:int = 8;
		
		/**暗棋 无法移动*/
		public static const CHESS:int = 9;
		
		public function SpriteType()
		{
		}
	}
}