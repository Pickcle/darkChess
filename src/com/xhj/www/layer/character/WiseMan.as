package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	import com.xhj.www.utils.MapTileUtil;
	
	public class WiseMan extends AbstractSprite
	{
		public function WiseMan()
		{
			_type = SpriteType.WISEMAN;
			super();
		}
		
		override protected function getAttackRangeList():Array
		{
			return MapTileUtil.getAroundRangeTiles(_pos, 1);
		}
		
		override protected function getSpriteName():String
		{
			return "军师";
		}
	}
}