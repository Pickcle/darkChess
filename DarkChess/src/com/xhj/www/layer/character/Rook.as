package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	
	public class Rook extends AbstractSprite
	{
		public function Rook()
		{
			_type = SpriteType.ROOK;
			super();
		}
		
		override protected function getSpriteName():String
		{
			return "车";
		}
	}
}