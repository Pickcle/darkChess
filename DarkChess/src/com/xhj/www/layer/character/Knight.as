package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	
	public class Knight extends AbstractSprite
	{
		public function Knight()
		{
			_type = SpriteType.KNIGHT;
			super();
		}
		
		override protected function getSpriteName():String
		{
			return "骑兵";
		}
	}
}