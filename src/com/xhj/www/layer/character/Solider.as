package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	import com.xhj.www.utils.MapTileUtil;
	
	public class Solider extends AbstractSprite
	{
		public function Solider()
		{
			_type = SpriteType.SOLDIER;
			super();
		}
		
		override protected function getAttackRangeList():Array
		{
			return MapTileUtil.getStraightTiles(_pos, 2);
		}
		
		override protected function getSpriteName():String
		{
			return "士兵";
		}
	}
}