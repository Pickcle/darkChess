package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	
	public class King extends AbstractSprite
	{
		public function King()
		{
			_type = SpriteType.KING;
			super();
		}
		
		override protected function getSpriteName():String
		{
			return "君主";
		}
	}
}