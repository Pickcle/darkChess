package com.xhj.www.utils
{
	import com.xhj.www.App;
	import com.xhj.www.GlobalParam;
	import com.xhj.www.layer.map.MapTile;

	public class MapTileUtil
	{
		private static var _mapTile:HashMap;
		
		public function MapTileUtil()
		{
		}
		
		/**
		 * 获取格子直线四个方向上可移动的格子列表
		 * @param pos 当前格子pos
		 * @param range 距离上限
		 * @return 格子列表
		 * 
		 */		
		public static function getStraightRangeArray(pos:int, range:int):Array
		{
			var crtTile:MapTile = getMapTile(pos);//当前格子
			var ary:Array = [];
			var i:int;
			var tile:MapTile;
			var dltX:int;
			var dltY:int;
			var count:int;
			for (i = 0; i < 4; ++i)
			{
				dltX = Math.sin(i * Math.PI);
				dltY = Math.cos(i * Math.PI);
				tile = getMapTileByDirection(crtTile, dltX, dltY);//相邻格子
				while (count < range && tile && !tile.getIsDark())//超过距离/格子超过边界/是障碍物
				{
					++count;
					if (!tile.getEmpty())//有士兵
					{
						if (!tile.getIsSameNation(App.myNation))//敌人
						{
							ary.push(tile);
							break;
						}
					}
					else
					{
						ary.push(tile);
					}
					tile = getMapTileByDirection(tile, dltX, dltY);
				}
			}
			return ary;
		}
		
		/**
		 * 获取当前格子某方向的格子
		 * @param mapTile 当前格子
		 * @param dltX x坐标偏移值
		 * @param dltY y坐标偏移值
		 * @return 格子
		 * 
		 */		
		public static function getMapTileByDirection(mapTile:MapTile, dltX:int, dltY:int):MapTile
		{
			var x:int = mapTile.getPosX();
			var y:int = mapTile.getPosY();
			if (x + dltX >= GlobalParam.MAP_ROW || x + dltX < 0 ||
				y + dltY >= GlobalParam.MAP_COLUMN || y + dltY < 0)
			{
				return null;
			}
			return getMapTileByXY(x + dltX, y + dltY);
		}
		
		/**
		 * 获取当前格子周围一圈格子
		 * @param mapTile 当前格子
		 * @param range 距离 1：周围8格，2：周围24格， n：周围（2n+1)^2-1格
		 * @return 格子列表
		 * 
		 */		
		public static function getAroundRangeArray(mapTile:MapTile, range:int):Array
		{
			var x:int = mapTile.getPosX();
			var y:int = mapTile.getPosY();
			var tile:MapTile;
			for (var i:int = -range; i <= range; ++i)
			{
				for (var j:int = -range; j <= range; ++j)
				{
					if (i == 0 && j == 0)
					{
						continue;
					}
					tile = getMapTileByDirection(mapTile, i, j);
					if (tile && tile.
				}
			}
			for (var i:int = x - range; i <= x + range; ++i)
			{
				for (var j:int = y - range; j <= j + range; ++j)
				{
					tile = getMapTileByDirection(mapTile, i - x, j - y);
				}
			}
		}
		
		public static function getAroundTiles(mapTile:MapTile):Array
		{
			
		}
		
		public static function getMapTile(pos:int):MapTile
		{
			return _mapTile.get(pos);
		}
		
		public static function getMapTileByXY(posX:int, posY:int):MapTile
		{
			for each (var mapTile:MapTile in _mapTile.values())
			{
				if (mapTile.getPosX() == posX && mapTile.getPosY() == posY)
				{
					return mapTile;
				}
			}
			return null;
		}
		
		public static function getAllTiles():Array
		{
			return _mapTile.values();
		}
		
		public static function set mapTile(value:HashMap):void
		{
			_mapTile = value;
		}

	}
}