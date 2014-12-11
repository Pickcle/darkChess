package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	
	public class Solider extends AbstractSprite
	{
		public function Solider()
		{
			_type = SpriteType.SOLDIER;
			super();
		}
		
		override protected function getSpriteName():String
		{
			return "士兵";
		}
	}
}