package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	import com.xhj.www.utils.MapTileUtil;
	
	public class Hero extends AbstractSprite
	{
		public function Hero()
		{
			_type = SpriteType.HERO;
			super();
		}
		
		override protected function getAttackRangeList():Array
		{
			return MapTileUtil.getAroundTileByDistance(_pos, 3);
		}
		
		override protected function getSpriteName():String
		{
			return "大将";
		}
	}
}