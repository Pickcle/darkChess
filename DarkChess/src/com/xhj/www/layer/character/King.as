package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	import com.xhj.www.utils.MapTileUtil;
	
	public class King extends AbstractSprite
	{
		public function King()
		{
			_type = SpriteType.KING;
			super();
		}
		
		override protected function getAttackRangeList():Array
		{
			return MapTileUtil.getStraightTiles(_pos, 3);
		}
		
		override protected function getSpriteName():String
		{
			return "君主";
		}
	}
}