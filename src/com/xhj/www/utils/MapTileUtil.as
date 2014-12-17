package com.xhj.www.utils
{
	import com.xhj.www.App;
	import com.xhj.www.GameManager;
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
		public static function getStraightTiles(pos:int, range:int):Array
		{
			var mapTile:MapTile = getMapTile(pos);
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
				tile = getMapTileByDirection(mapTile.getPos(), dltX, dltY);//相邻格子
				count = 0;
				while (count < range && tile && !tile.getIsDark())//超过距离/格子超过边界/是障碍物
				{
					++count;
					if (!tile.getEmpty())//有士兵
					{
						if (!tile.getIsSameNation(GameManager.getCurrentNation()))//敌人
						{
							ary.push(tile);
							break;
						}
					}
					else
					{
						ary.push(tile);
					}
					tile = getMapTileByDirection(tile.getPos(), dltX, dltY);
				}
			}
			return ary;
		}
		
		/**
		 * 获取炮的可移动格子数组
		 * @param pos 当前格子pos
		 * @return 格子列表
		 * 
		 */		
		public static function getCannonTiles(pos:int):Array
		{
			var mapTile:MapTile = getMapTile(pos);
			var ary:Array = [];
			var i:int;
			var tile:MapTile;
			var dltX:int;
			var dltY:int;
			var isBlock:Boolean;		//记录是否有跳板
			for (i = 0; i < 4; ++i)
			{
				dltX = Math.sin(i * Math.PI / 2);
				dltY = Math.cos(i * Math.PI / 2);
				tile = getMapTileByDirection(mapTile.getPos(), dltX, dltY);//相邻格子
				isBlock = false;
				while (tile)//格子存在
				{
					if (tile.getEmpty() && !isBlock)//空地且还没有跳板
					{
						ary.push(tile);
					}
					else if (!tile.getEmpty())//有物体
					{
						if (!isBlock)//第一次碰到物体，视为跳板
						{
							isBlock = true;
						}
						else//跳板已存在
						{
							if (!tile.getIsDark() && !tile.getIsSameNation(GameManager.getCurrentNation()))//是敌人
							{
								ary.push(tile);
							}
							break;//无论是否可攻击，后面的格子都不在攻击范围内
						}
					}
					tile = getMapTileByDirection(tile.getPos(), dltX, dltY);
				}
			}
			return ary;
		}
		
		/**
		 * 获取当前格子某方向的格子
		 * @param pos 当前格子pos
		 * @param dltX x坐标偏移值
		 * @param dltY y坐标偏移值
		 * @return 格子
		 * 
		 */		
		public static function getMapTileByDirection(pos:int, dltX:int, dltY:int):MapTile
		{
			var mapTile:MapTile = getMapTile(pos);
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
		 * @param pos 当前格子pos
		 * @param range 距离 1：周围8格，2：周围24格， n：周围（2n+1)^2-1格
		 * @return 格子列表
		 * 
		 */		
		public static function getAroundRangeTiles(pos:int, range:int):Array
		{
			var mapTile:MapTile = getMapTile(pos);
			var ary:Array = getAroundTileByDistance(pos, 2 * range);
			for each (var tile:MapTile in ary)
			{
				if (Math.abs(tile.getPosX() - mapTile.getPosX()) > range ||
					Math.abs(tile.getPosY() - mapTile.getPosY()) > range)
				{
					ary.splice(ary.indexOf(tile), 1);		//删除越界格子
				}
			}
			return ary;
		}
		
		/**
		 * 获取当前格子一定步数内的所有可移动格子
		 * @param pos 当前格子pos
		 * @param distance 步数
		 * @return 格子列表
		 * 
		 */		
		public static function getAroundTileByDistance(pos:int, distance:int):Array
		{
			var mapTile:MapTile = getMapTile(pos);
			var dis:int = 0;
			var dltX:int;
			var dltY:int;
			var tile:MapTile;
			var nearTile:MapTile;
			var i:int;
			var j:int;
			var len:int;
			var openAry:Array = [];//需要检测的格子
			var closeAry:Array = [];//已检测过的格子
			var rtnAry:Array = [];//符合条件的格子
			openAry.push(mapTile);
			while (dis <= distance)
			{
				len = openAry.length;
				for (j = 0; j < len; ++j)
				{
					tile = openAry.shift();//已检测格子从open中移除
					closeAry.push(tile);//已检测的格子放入close
					if (!tile.getEmpty())
					{
						if (tile.getIsDark())//障碍物
						{
							continue;
						}
						else
						{
							if (!tile.getIsSameNation(GameManager.getCurrentNation()) && tile != mapTile)//敌人
							{
								rtnAry.push(tile);//放入rtn
								continue;
							}
						}
					}
					else
					{
						rtnAry.push(tile);
					}
					for (i = 0; i < 4; ++i)
					{
						dltX = Math.sin(i * Math.PI / 2);//0,1,0,-1
						dltY = Math.cos(i * Math.PI / 2);//1,0,-1,0
						nearTile = getMapTileByDirection(tile.getPos(), dltX, dltY);//相邻格子
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
		 * 获取格子
		 * @param pos 格子pos
		 * @return 
		 * 
		 */		
		public static function getMapTile(pos:int):MapTile
		{
			return _mapTile.get(pos);
		}
		
		/**
		 * 通过格子的posX,posY获取格子
		 * @param posX
		 * @param posY
		 * @return 
		 * 
		 */		
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
		
		/**
		 * 获取所有地图格子
		 * @return 
		 * 
		 */		
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