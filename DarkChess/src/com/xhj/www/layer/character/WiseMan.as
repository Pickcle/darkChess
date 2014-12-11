package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	
	public class WiseMan extends AbstractSprite
	{
		public function WiseMan()
		{
			_type = SpriteType.WISEMAN;
			super();
		}
		
		override protected function getSpriteName():String
		{
			return "军师";
		}
	}
}