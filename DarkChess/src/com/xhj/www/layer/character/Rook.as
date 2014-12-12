package com.xhj.www.layer.character
{
	import com.xhj.www.GlobalParam;
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	import com.xhj.www.utils.MapTileUtil;
	
	public class Rook extends AbstractSprite
	{
		public function Rook()
		{
			_type = SpriteType.ROOK;
			super();
		}
		
		override protected function getAttackRangeList():Array
		{
			return MapTileUtil.getStraightTiles(_pos, Math.max(GlobalParam.MAP_COLUMN, GlobalParam.MAP_ROW));
		}
		
		override protected function getSpriteName():String
		{
			return "车";
		}
	}
}