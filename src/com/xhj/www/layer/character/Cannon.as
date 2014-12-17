package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;
	import com.xhj.www.layer.map.MapTile;
	import com.xhj.www.utils.MapTileUtil;
	
	public class Cannon extends AbstractSprite
	{
		public function Cannon()
		{
			_type = SpriteType.CANNON;
			super();
		}
		
		override protected function getAttackRangeList():Array
		{
			return MapTileUtil.getCannonTiles(_pos);
		}
		
		override protected function getSpriteName():String
		{
			return "炮";
		}
		
		/**
		 * 炮的路线无视障碍物，只走直线
		 * @param startTile
		 * @param endTile
		 * @return 
		 * 
		 */		
		override protected function getWays(startTile:MapTile, endTile:MapTile):Array
		{
			if (startTile == endTile)
			{
				return [];
			}
			var tile:MapTile; 
			var rtn:Array = [endTile];
			var dlt:int;
			var distance:int = 1;
			if (startTile.getPosX() == endTile.getPosX())//如果在同一X轴
			{
				if (endTile.getPosY() > startTile.getPosY())
				{
					dlt = -1;
				}
				else
				{
					dlt = 1;
				}
				while (true)
				{
					tile = MapTileUtil.getMapTileByXY(endTile.getPosX(), endTile.getPosY() + distance * dlt);
					rtn.push(tile);
					++distance;
					if (tile == startTile)
					{
						break;
					}
				}
			}
			else//都在Y轴
			{
				if (endTile.getPosX() > startTile.getPosX())
				{
					dlt = -1;
				}
				else
				{
					dlt = 1;
				}
				while (true)
				{
					tile = MapTileUtil.getMapTileByXY(endTile.getPosX() + distance * dlt, endTile.getPosY());
					rtn.push(tile);
					++distance;
					if (tile == startTile)
					{
						break;
					}
				}
			}
			return rtn;
		}
	}
}