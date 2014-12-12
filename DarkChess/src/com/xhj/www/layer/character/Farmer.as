package com.xhj.www.layer.character
{
	import com.xhj.www.LayerManager;
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	import com.xhj.www.layer.map.MapTile;
	import com.xhj.www.utils.MapTileUtil;
	
	public class Farmer extends AbstractSprite
	{
		public function Farmer()
		{
			_type = SpriteType.FARMER;
			super();
		}
		
		override protected function getAttackRangeList():Array
		{
			return MapTileUtil.getStraightTiles(_pos, 1);
		}
		
		override protected function getSpriteName():String
		{
			return "农民";
		}
	}
}