package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	import com.xhj.www.utils.MapTileUtil;
	
	public class Knight extends AbstractSprite
	{
		public function Knight()
		{
			_type = SpriteType.KNIGHT;
			super();
		}
		
		override protected function getAttackRangeList():Array
		{
			return MapTileUtil.getAroundTileByDistance(_pos, 2);
		}
		
		override protected function getSpriteName():String
		{
			return "骑兵";
		}
	}
}