package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	
	public class Cannon extends AbstractSprite
	{
		public function Cannon()
		{
			_type = SpriteType.CANNON;
			super();
		}
		
		override protected function getSpriteName():String
		{
			return "炮";
		}
	}
}