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
				dltX = Math.sin(i * Math.PI / 2);
				dltY = Math.cos(i * Math.PI / 2);
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
		}
		
		/**
		 * 获取当前格子一定步数内的所有可移动格子
		 * @param mapTile 当前格子
		 * @param distance 步数
		 * @return 格子列表
		 * 
		 */		
		public static function getAroundTiles(mapTile:MapTile, distance:int):Array
		{
			var dis:int = 0;
			var dltX:int;
			var dltY:int;
			var tile:MapTile;
			var nearTile:MapTile;
			var i:int;
			var openAry:Array = [];//需要检测的格子
			var closeAry:Array = [];//已检测过的格子
			var rtnAry:Array = [];//符合条件的格子
			openAry.push(mapTile);
			while (dis <= distance)
			{
				for each (tile in openAry)
				{
					openAry.splice(openAry.indexOf(tile), 1);//已检测格子从open中移除
					closeAry.push(tile);//已检测的格子放入close
					if ((tile.getEmpty() || !tile.getIsSameNation(App.myNation)) && tile != mapTile)//可行走，敌人或者空地/不是初始点
					{
						rtnAry.push(tile);//放入rtn
					}
					else if (tile.getIsDark())//障碍物
					{
						continue;
					}
					for (i = 0; i < 4; ++i)
					{
						dltX = Math.sin(i * Math.PI / 2);//0,1,0,-1
						dltY = Math.cos(i * Math.PI / 2);//1,0,-1,0
						nearTile = getMapTileByDirection(mapTile, dltX, dltY);//相邻格子
						if (nearTile)//格子存在
						{
							if (openAry.indexOf(nearTile) == -1 && closeAry.indexOf(nearTile) == -1)//没有被添加到open中，且没有被检测过
							{
								openAry.push(nearTile);
							}
						}
					}
					
				}
				++dis;
			}
			return rtnAry;
		}
		
		/**
		 * 获得相邻格子列表
		 * @param mapTile
		 * @return 
		 * 
		 */		
		public static function getNearTiles(mapTile:MapTile):Array
		{
			var dltX:int;
			var dltY:int;
			var tile:MapTile;
			var i:int;
			var ary:Array = [];
			for (i = 0; i < 4; ++i)
			{
				dltX = Math.sin(i * Math.PI / 2);
				dltY = Math.cos(i * Math.PI / 2);
				tile = getMapTileByDirection(mapTile, dltX, dltY);//相邻格子
				if (tile)
				{
					ary.push(tile);
				}
			}
			return ary;
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